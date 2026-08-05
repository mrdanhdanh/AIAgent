namespace AIHub.Models;

public enum CardSize
{
    Small,
    Medium,
    Large
}

public class TrendingItem
{
    public string Id { get; set; } = string.Empty;
    public string Title { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public string Url { get; set; } = string.Empty;
    public string Source { get; set; } = string.Empty;
    public string SourceIcon { get; set; } = string.Empty;
    public string AvatarUrl { get; set; } = string.Empty;
    public int Stars { get; set; }
    public int Forks { get; set; }
    public string Language { get; set; } = string.Empty;
    public DateTime PublishedAt { get; set; }
    public double Score { get; set; }

    public CardSize GetCardSize()
    {
        return Score switch
        {
            >= 80 => CardSize.Large,
            >= 40 => CardSize.Medium,
            _ => CardSize.Small
        };
    }

    public string GetTimeAgo()
    {
        var diff = DateTime.UtcNow - PublishedAt;
        return diff switch
        {
            { TotalDays: >= 30 } => $"{(int)(diff.TotalDays / 30)}mo ago",
            { TotalDays: >= 1 } => $"{(int)diff.TotalDays}d ago",
            { TotalHours: >= 1 } => $"{(int)diff.TotalHours}h ago",
            { TotalMinutes: >= 1 } => $"{(int)diff.TotalMinutes}m ago",
            _ => "just now"
        };
    }
}
