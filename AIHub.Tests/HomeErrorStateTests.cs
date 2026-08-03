using Bunit;
using Microsoft.Extensions.DependencyInjection;
using Moq;
using AIHub.Pages;
using AIHub.Services;
using AIHub.Models;
using AIHub.Tests.TestHelpers;

namespace AIHub.Tests;

/// <summary>
/// Reproduce + verify tests cho BUG-20260803-001:
/// "AIHub không load được hoặc load toàn nội dung ra rỗng"
///
/// Root cause: data-fetch pipeline nuốt lỗi im lặng — không error state, không retry.
/// Sau fix: khi service fail (throw / HasFailures=true) UI phải hiển thị error state
/// với nút Retry thay vì empty state "No trending items" im lặng.
/// </summary>
public class HomeErrorStateTests : BunitTestBase
{
    private static Mock<ITrendingService> CreateFailingService()
    {
        var mock = new Mock<ITrendingService>();
        mock.Setup(s => s.GetTrendingAsync(It.IsAny<TimeFilter>(), It.IsAny<int>(), It.IsAny<int>()))
            .ThrowsAsync(new HttpRequestException("GitHub API rate limited (403)"));
        return mock;
    }

    [Fact]
    public void Home_WhenServiceThrows_ShowsErrorStateWithRetry()
    {
        var mock = CreateFailingService();
        Context.Services.AddSingleton(mock.Object);

        var cut = Context.Render<Home>();

        Assert.Contains("Failed to load trending items", cut.Markup);
        Assert.Contains("Retry", cut.Markup);
        Assert.DoesNotContain("No trending items", cut.Markup);
    }

    [Fact]
    public void Home_WhenServiceFailsViaFlag_ShowsErrorStateInsteadOfEmptyState()
    {
        var mock = new Mock<ITrendingService>();
        mock.Setup(s => s.GetTrendingAsync(It.IsAny<TimeFilter>(), It.IsAny<int>(), It.IsAny<int>()))
            .ReturnsAsync(new List<TrendingItem>());
        mock.SetupGet(s => s.HasFailures).Returns(true);
        mock.SetupGet(s => s.LastError).Returns("Source 'GitHub Trending' failed: HTTP 403 (rate limited)");
        Context.Services.AddSingleton(mock.Object);

        var cut = Context.Render<Home>();

        Assert.Contains("Failed to load trending items", cut.Markup);
        Assert.Contains("Retry", cut.Markup);
        Assert.DoesNotContain("No trending items", cut.Markup);
    }

    [Fact]
    public void Home_WhenServiceReturnsEmptyWithoutFailures_ShowsEmptyState()
    {
        var mock = new Mock<ITrendingService>();
        mock.Setup(s => s.GetTrendingAsync(It.IsAny<TimeFilter>(), It.IsAny<int>(), It.IsAny<int>()))
            .ReturnsAsync(new List<TrendingItem>());
        mock.SetupGet(s => s.HasFailures).Returns(false);
        Context.Services.AddSingleton(mock.Object);

        var cut = Context.Render<Home>();

        Assert.Contains("No trending items", cut.Markup);
        Assert.DoesNotContain("Failed to load trending items", cut.Markup);
    }

    [Fact]
    public void Home_WhenServiceReturnsData_ShowsTrendGrid()
    {
        var mock = new Mock<ITrendingService>();
        mock.Setup(s => s.GetTrendingAsync(It.IsAny<TimeFilter>(), It.IsAny<int>(), It.IsAny<int>()))
            .ReturnsAsync(new List<TrendingItem>
            {
                new() { Title = "test/repo", Source = "GitHub Trending", Stars = 100 }
            });
        mock.SetupGet(s => s.HasFailures).Returns(false);
        Context.Services.AddSingleton(mock.Object);

        var cut = Context.Render<Home>();

        Assert.Contains("test/repo", cut.Markup);
        Assert.DoesNotContain("Failed to load trending items", cut.Markup);
        Assert.DoesNotContain("No trending items", cut.Markup);
    }

    [Fact]
    public void Home_Retry_ReloadsDataWhenServiceRecovers()
    {
        var callCount = 0;
        var mock = new Mock<ITrendingService>();
        mock.Setup(s => s.GetTrendingAsync(It.IsAny<TimeFilter>(), It.IsAny<int>(), It.IsAny<int>()))
            .ReturnsAsync(() =>
            {
                callCount++;
                return callCount == 1
                    ? new List<TrendingItem>()
                    : new List<TrendingItem> { new() { Title = "test/repo", Source = "GitHub Trending" } };
            });
        mock.SetupGet(s => s.HasFailures).Returns(() => callCount == 1);
        mock.SetupGet(s => s.LastError).Returns(() => callCount == 1 ? "HTTP 403" : null);
        Context.Services.AddSingleton(mock.Object);

        var cut = Context.Render<Home>();

        // Lần render đầu: error state (service fail)
        Assert.Contains("Failed to load trending items", cut.Markup);

        // Click Retry -> service recover -> grid hiển thị dữ liệu
        var retryButton = cut.FindAll("fluent-button").First(b => b.TextContent.Contains("Retry"));
        retryButton.Click();

        cut.WaitForAssertion(() =>
        {
            Assert.Contains("test/repo", cut.Markup);
            Assert.DoesNotContain("Failed to load trending items", cut.Markup);
        });
    }
}
