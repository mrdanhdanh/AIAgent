using System.Net;
using AIHub.Models;
using AIHub.Services;
using AIHub.Tests.TestHelpers;

namespace AIHub.Tests;

/// <summary>
/// Unit tests TrendingService — BUG-20260803-001:
/// service phải expose failure (HasFailures/LastError/FailedSourceCount) thay vì
/// trả list rỗng im lặng khi GitHub API fail (403/exception).
/// </summary>
public class TrendingServiceTests
{
    private const string SourcesJson = """
    [
      {
        "Name": "GitHub Trending",
        "ApiType": 0,
        "ApiEndpoint": "https://api.github.com/search/repositories?q=created:>{date}&sort=stars&order=desc&per_page={pageSize}&page={page}",
        "Enabled": true,
        "Headers": {}
      }
    ]
    """;

    private const string GithubSuccessJson = """
    {
      "total_count": 1,
      "items": [
        {
          "full_name": "test/repo",
          "description": "A test repository",
          "html_url": "https://github.com/test/repo",
          "stargazers_count": 100,
          "forks_count": 10,
          "language": "C#",
          "owner": { "avatar_url": "https://avatars.example/a.png" },
          "pushed_at": "2026-08-01T00:00:00Z"
        }
      ]
    }
    """;

    private static HttpClient CreateClient(Func<HttpRequestMessage, HttpResponseMessage> responder)
    {
        var handler = new MockHttpMessageHandler(responder);
        return new HttpClient(handler) { BaseAddress = new Uri("http://localhost/") };
    }

    private static bool IsSourcesRequest(HttpRequestMessage req) =>
        req.RequestUri!.PathAndQuery.StartsWith("/data/sources.json");

    [Fact]
    public async Task GetTrendingAsync_AllSourcesForbidden_SetsHasFailures()
    {
        var client = CreateClient(req =>
            IsSourcesRequest(req)
                ? HttpResponder.Json(HttpStatusCode.OK, SourcesJson)
                : HttpResponder.Json(HttpStatusCode.Forbidden, "{}"));

        var service = new TrendingService(client);
        var items = await service.GetTrendingAsync(TimeFilter.Last24Hours);

        Assert.Empty(items);
        Assert.True(service.HasFailures);
        Assert.Equal(1, service.FailedSourceCount);
        Assert.Contains("403", service.LastError);
    }

    [Fact]
    public async Task GetTrendingAsync_Success_ReturnsItems_NoFailures()
    {
        var client = CreateClient(req =>
            IsSourcesRequest(req)
                ? HttpResponder.Json(HttpStatusCode.OK, SourcesJson)
                : HttpResponder.Json(HttpStatusCode.OK, GithubSuccessJson));

        var service = new TrendingService(client);
        var items = await service.GetTrendingAsync(TimeFilter.Last24Hours);

        Assert.False(service.HasFailures);
        Assert.Equal(0, service.FailedSourceCount);
        Assert.Single(items);
        Assert.Equal("test/repo", items[0].Title);
        Assert.Equal(100, items[0].Stars);
    }

    [Fact]
    public async Task GetTrendingAsync_SourceThrows_SetsHasFailures_DoesNotThrow()
    {
        var client = CreateClient(req =>
            IsSourcesRequest(req)
                ? HttpResponder.Json(HttpStatusCode.OK, SourcesJson)
                : throw new HttpRequestException("network down"));

        var service = new TrendingService(client);
        var items = await service.GetTrendingAsync(TimeFilter.Last24Hours);

        Assert.Empty(items);
        Assert.True(service.HasFailures);
        Assert.Equal(1, service.FailedSourceCount);
        Assert.Contains("network down", service.LastError);
    }

    [Fact]
    public async Task GetTrendingAsync_Failure_IsNotCached_RetriesOnNextCall()
    {
        var githubCalls = 0;
        var client = CreateClient(req =>
        {
            if (IsSourcesRequest(req))
                return HttpResponder.Json(HttpStatusCode.OK, SourcesJson);
            githubCalls++;
            return HttpResponder.Json(HttpStatusCode.Forbidden, "{}");
        });

        var service = new TrendingService(client);

        var first = await service.GetTrendingAsync(TimeFilter.Last24Hours);
        Assert.Empty(first);
        Assert.True(service.HasFailures);
        Assert.Equal(1, githubCalls);

        // Kết quả fail KHÔNG được cache — lần gọi sau phải fetch lại
        var second = await service.GetTrendingAsync(TimeFilter.Last24Hours);
        Assert.Empty(second);
        Assert.Equal(2, githubCalls);
    }

    [Fact]
    public async Task GetTrendingAsync_CacheHit_DoesNotSetFailures()
    {
        var githubCalls = 0;
        var client = CreateClient(req =>
        {
            if (IsSourcesRequest(req))
                return HttpResponder.Json(HttpStatusCode.OK, SourcesJson);
            githubCalls++;
            return HttpResponder.Json(HttpStatusCode.OK, GithubSuccessJson);
        });

        var service = new TrendingService(client);
        var first = await service.GetTrendingAsync(TimeFilter.Last24Hours); // fetch + cache
        var second = await service.GetTrendingAsync(TimeFilter.Last24Hours); // cache hit

        Assert.Single(first);
        Assert.Equal(1, githubCalls);
        Assert.Single(second);
        Assert.False(service.HasFailures);
    }

    [Fact]
    public async Task ResetErrorState_ClearsFailureFlags()
    {
        var client = CreateClient(req =>
            IsSourcesRequest(req)
                ? HttpResponder.Json(HttpStatusCode.OK, SourcesJson)
                : HttpResponder.Json(HttpStatusCode.Forbidden, "{}"));

        var service = new TrendingService(client);
        await service.GetTrendingAsync(TimeFilter.Last24Hours);
        Assert.True(service.HasFailures);

        service.ResetErrorState();
        Assert.False(service.HasFailures);
        Assert.Equal(0, service.FailedSourceCount);
        Assert.Null(service.LastError);
    }
}
