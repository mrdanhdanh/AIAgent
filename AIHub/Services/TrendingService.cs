using System.Collections.Concurrent;
using System.Net.Http.Json;
using System.Text.Json;
using AIHub.Models;

namespace AIHub.Services;

public class TrendingService : ITrendingService
{
    private readonly HttpClient _http;
    private List<TrendingSource> _sources = new();
    private readonly ConcurrentDictionary<string, (List<TrendingItem> items, DateTime cachedAt)> _cache = new();
    private static readonly TimeSpan CacheTtl = TimeSpan.FromMinutes(5);
    private bool _sourcesLoaded;

    // BUG-20260803-001: failure surfacing state (thread-safe qua lock vì FetchFromSourceAsync chạy song song)
    private readonly object _errorLock = new();
    private bool _hasFailures;
    private string? _lastError;
    private int _failedSourceCount;

    public bool HasFailures
    {
        get { lock (_errorLock) { return _hasFailures; } }
    }

    public string? LastError
    {
        get { lock (_errorLock) { return _lastError; } }
    }

    public int FailedSourceCount
    {
        get { lock (_errorLock) { return _failedSourceCount; } }
    }

    public void ResetErrorState()
    {
        lock (_errorLock)
        {
            _hasFailures = false;
            _lastError = null;
            _failedSourceCount = 0;
        }
    }

    private void RecordFailure(string sourceName, string reason)
    {
        lock (_errorLock)
        {
            _hasFailures = true;
            _failedSourceCount++;
            _lastError = $"Source '{sourceName}' failed: {reason}";
        }
    }

    public TrendingService(HttpClient http)
    {
        _http = http;
    }

    public async Task<List<TrendingSource>> GetSourcesAsync()
    {
        await EnsureSourcesLoadedAsync();
        return _sources.Where(s => s.Enabled).ToList();
    }

    public void ClearCache()
    {
        _cache.Clear();
    }

    public async Task<List<TrendingItem>> GetTrendingAsync(TimeFilter filter, int page = 1, int pageSize = 50)
    {
        var cacheKey = $"{(int)filter}_{page}";

        // BUG-20260803-001: reset failure flags mỗi request (cache hit => không fetch => không có failure mới)
        ResetErrorState();

        if (_cache.TryGetValue(cacheKey, out var cached) && DateTime.UtcNow - cached.cachedAt < CacheTtl)
            return cached.items;

        await EnsureSourcesLoadedAsync();
        var enabledSources = _sources.Where(s => s.Enabled).ToList();

        var tasks = enabledSources.Select(s => FetchFromSourceAsync(s, filter, page, pageSize));
        var results = await Task.WhenAll(tasks);

        var allItems = results.SelectMany(r => r).ToList();

        foreach (var item in allItems)
        {
            item.Score = CalculateScore(item);
        }

        allItems = allItems.OrderByDescending(i => i.Score).ToList();

        // BUG-20260803-001: không cache kết quả rỗng do lỗi — retry sau đó sẽ fetch lại thay vì nhận empty từ cache
        if (allItems.Count > 0 || !HasFailures)
            _cache[cacheKey] = (allItems, DateTime.UtcNow);

        return allItems;
    }

    private async Task EnsureSourcesLoadedAsync()
    {
        if (_sourcesLoaded) return;

        try
        {
            var response = await _http.GetAsync("data/sources.json");
            if (response.IsSuccessStatusCode)
            {
                var sources = await response.Content.ReadFromJsonAsync<List<TrendingSource>>();
                if (sources != null)
                    _sources = sources;
            }
        }
        catch
        {
            // Fallback to default sources
            _sources = GetDefaultSources();
        }

        _sourcesLoaded = true;
    }

    private async Task<List<TrendingItem>> FetchFromSourceAsync(TrendingSource source, TimeFilter filter, int page, int pageSize)
    {
        try
        {
            var (from, _) = filter.GetDateRange();
            var dateStr = from.ToString("yyyy-MM-dd");
            var endpoint = source.ApiEndpoint
                .Replace("{date}", dateStr)
                .Replace("{page}", page.ToString())
                .Replace("{pageSize}", pageSize.ToString());

            var request = new HttpRequestMessage(HttpMethod.Get, endpoint);

            foreach (var header in source.Headers)
                request.Headers.TryAddWithoutValidation(header.Key, header.Value);

            var response = await _http.SendAsync(request);

            if (response.StatusCode == System.Net.HttpStatusCode.Forbidden)
            {
                RecordFailure(source.Name, "HTTP 403 (rate limited)"); // BUG-20260803-001
                return new List<TrendingItem>();
            }

            if (!response.IsSuccessStatusCode)
            {
                RecordFailure(source.Name, $"HTTP {(int)response.StatusCode}"); // BUG-20260803-001
                return new List<TrendingItem>();
            }

            var content = await response.Content.ReadAsStringAsync();

            return source.ApiType switch
            {
                ApiType.GitHub => ParseGitHubResponse(content, source.Name),
                _ => new List<TrendingItem>()
            };
        }
        catch (Exception ex)
        {
            RecordFailure(source.Name, ex.Message); // BUG-20260803-001: không nuốt exception im lặng
            return new List<TrendingItem>();
        }
    }

    private List<TrendingItem> ParseGitHubResponse(string json, string sourceName)
    {
        var items = new List<TrendingItem>();
        try
        {
            using var doc = JsonDocument.Parse(json);
            var root = doc.RootElement;

            if (!root.TryGetProperty("items", out var itemsArray))
                return items;

            foreach (var repo in itemsArray.EnumerateArray())
            {
                var title = repo.TryGetProperty("full_name", out var fn) ? fn.GetString() ?? "" : "";
                var desc = repo.TryGetProperty("description", out var d) ? d.GetString() ?? "" : "";
                var url = repo.TryGetProperty("html_url", out var hu) ? hu.GetString() ?? "" : "";
                var stars = repo.TryGetProperty("stargazers_count", out var sc) ? sc.GetInt32() : 0;
                var forks = repo.TryGetProperty("forks_count", out var fc) ? fc.GetInt32() : 0;
                var lang = repo.TryGetProperty("language", out var l) ? l.GetString() ?? "" : "";
                var avatar = repo.TryGetProperty("owner", out var owner) &&
                             owner.TryGetProperty("avatar_url", out var av) ? av.GetString() ?? "" : "";
                var pushed = repo.TryGetProperty("pushed_at", out var pa) &&
                             DateTime.TryParse(pa.GetString(), out var dt) ? dt : DateTime.UtcNow;

                items.Add(new TrendingItem
                {
                    Id = $"gh_{title.Replace("/", "_")}",
                    Title = title,
                    Description = desc,
                    Url = url,
                    Source = sourceName,
                    SourceIcon = "https://github.githubassets.com/favicons/favicon.svg",
                    AvatarUrl = avatar,
                    Stars = stars,
                    Forks = forks,
                    Language = lang,
                    PublishedAt = pushed
                });
            }
        }
        catch
        {
            // Parse error — return empty
        }
        return items;
    }

    private static double CalculateScore(TrendingItem item)
    {
        var score = 0.0;
        score += item.Stars * 0.4;
        score += item.Forks * 0.3;

        var hoursAgo = (DateTime.UtcNow - item.PublishedAt).TotalHours;
        if (hoursAgo < 24) score += 20;
        else if (hoursAgo < 72) score += 10;
        else if (hoursAgo < 168) score += 5;

        if (!string.IsNullOrEmpty(item.Description) && item.Description.Length > 100)
            score += 10;

        if (!string.IsNullOrEmpty(item.Language))
            score += 3;

        return Math.Min(score, 100);
    }

    private static List<TrendingSource> GetDefaultSources()
    {
        return new List<TrendingSource>
        {
            new()
            {
                Name = "GitHub Trending",
                ApiType = ApiType.GitHub,
                ApiEndpoint = "https://api.github.com/search/repositories?q=created:>{date}&sort=stars&order=desc&per_page={pageSize}&page={page}",
                Enabled = true,
                Headers = new Dictionary<string, string> { { "User-Agent", "AIHub/1.0" }, { "Accept", "application/vnd.github.v3+json" } }
            },
            new()
            {
                Name = "GitHub AI Topics",
                ApiType = ApiType.GitHub,
                ApiEndpoint = "https://api.github.com/search/repositories?q=topic:ai+created:>{date}&sort=stars&order=desc&per_page={pageSize}&page={page}",
                Enabled = true,
                Headers = new Dictionary<string, string> { { "User-Agent", "AIHub/1.0" }, { "Accept", "application/vnd.github.v3+json" } }
            },
            new()
            {
                Name = "GitHub LLM Topics",
                ApiType = ApiType.GitHub,
                ApiEndpoint = "https://api.github.com/search/repositories?q=topic:llm+topic:agent+created:>{date}&sort=stars&order=desc&per_page={pageSize}&page={page}",
                Enabled = true,
                Headers = new Dictionary<string, string> { { "User-Agent", "AIHub/1.0" }, { "Accept", "application/vnd.github.v3+json" } }
            }
        };
    }
}
