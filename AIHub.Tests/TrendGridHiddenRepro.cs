using Bunit;
using Microsoft.Extensions.DependencyInjection;
using Moq;
using AIHub.Pages;
using AIHub.Services;
using AIHub.Models;
using AIHub.Tests.TestHelpers;

namespace AIHub.Tests;

/// <summary>
/// Repro mới từ user: "đã thấy có log, nhưng class lại có hidden nên bị ẩn".
/// Home load được dữ liệu (có log/network), nhưng grid-item bị class hidden => không hiển thị.
/// </summary>
public class TrendGridHiddenRepro : BunitTestBase
{
    private static Mock<ITrendingService> CreateDataService(int count = 5)
    {
        var items = Enumerable.Range(1, count)
            .Select(i => new TrendingItem
            {
                Title = $"owner/repo-{i}",
                Description = $"Repo number {i}",
                Source = "GitHub Trending",
                Stars = 100 + i,
                Forks = 10,
                PublishedAt = DateTime.UtcNow.AddHours(-i)
            })
            .ToList();

        var mock = new Mock<ITrendingService>();
        mock.Setup(s => s.GetTrendingAsync(It.IsAny<TimeFilter>(), It.IsAny<int>(), It.IsAny<int>()))
            .ReturnsAsync(items);
        mock.SetupGet(s => s.HasFailures).Returns(false);
        return mock;
    }

    [Fact]
    public void Home_WhenDataLoads_GridItemsShouldBeVisibleNotHidden()
    {
        Context.Services.AddSingleton(CreateDataService().Object);

        var cut = Context.Render<Home>();

        // Data hiển thị — repo title phải có mặt trong markup
        Assert.Contains("owner/repo-1", cut.Markup);

        // Bug: grid-item bị class "hidden" => opacity 0, max-height 0 => user không thấy gì
        var hiddenItems = cut.FindAll("div.grid-item.hidden");
        var visibleItems = cut.FindAll("div.grid-item.visible");

        // Dump toàn bộ class của các grid-item để phân tích
        var allClasses = cut.FindAll("div.grid-item")
            .Select(el => el.GetAttribute("class"))
            .ToList();

        Assert.False(hiddenItems.Count > 0,
            $"Có {hiddenItems.Count} grid-item bị class 'hidden'. Classes: [{string.Join(", ", allClasses)}]");
        Assert.True(visibleItems.Count == 5,
            $"Mong đợi 5 grid-item 'visible', thực tế {visibleItems.Count}. Classes: [{string.Join(", ", allClasses)}]");
    }

    [Fact]
    public void Home_WhenSearchQueryEmpty_IsVisibleReturnsTrue()
    {
        Context.Services.AddSingleton(CreateDataService().Object);

        var cut = Context.Render<Home>();

        // Nếu SearchQuery rỗng thì mọi item phải visible (không có class hidden)
        var hiddenCount = cut.FindAll("div.grid-item.hidden").Count;
        Assert.Equal(0, hiddenCount);
    }
}
