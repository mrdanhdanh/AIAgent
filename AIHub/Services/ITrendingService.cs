using AIHub.Models;

namespace AIHub.Services;

public interface ITrendingService
{
    Task<List<TrendingItem>> GetTrendingAsync(TimeFilter filter, int page = 1, int pageSize = 50);
    Task<List<TrendingSource>> GetSourcesAsync();
    void ClearCache();

    // BUG-20260803-001: failure surfacing — phân biệt "không có dữ liệu" vs "load thất bại"
    bool HasFailures { get; }
    string? LastError { get; }
    int FailedSourceCount { get; }
    void ResetErrorState();
}
