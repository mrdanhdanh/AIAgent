namespace AIHub.Models;

public enum ApiType
{
    GitHub,
    RestApi,
    Rss
}

public enum TimeFilter
{
    Last24Hours,
    Last7Days,
    Last30Days
}

public static class TimeFilterExtensions
{
    public static (DateTime from, DateTime to) GetDateRange(this TimeFilter filter)
    {
        var now = DateTime.UtcNow;
        return filter switch
        {
            TimeFilter.Last24Hours => (now.AddHours(-24), now),
            TimeFilter.Last7Days => (now.AddDays(-7), now),
            TimeFilter.Last30Days => (now.AddDays(-30), now),
            _ => (now.AddHours(-24), now)
        };
    }

    public static string ToDisplayString(this TimeFilter filter)
    {
        return filter switch
        {
            TimeFilter.Last24Hours => "24h",
            TimeFilter.Last7Days => "7 days",
            TimeFilter.Last30Days => "30 days",
            _ => "24h"
        };
    }
}

public class TrendingSource
{
    public string Name { get; set; } = string.Empty;
    public string ApiEndpoint { get; set; } = string.Empty;
    public ApiType ApiType { get; set; } = ApiType.GitHub;
    public bool Enabled { get; set; } = true;
    public Dictionary<string, string> Headers { get; set; } = new();
    public string? ResponseMapping { get; set; }
}
