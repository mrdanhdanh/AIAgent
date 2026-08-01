using Microsoft.Playwright;

namespace JapaneseLearner.E2ETests;

public class TrainingTests : E2ETestBase
{
    public TrainingTests(AppFixture fixture) : base(fixture) { }

    [Fact]
    public async Task Page_Loads_With_Target_And_Canvas()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/practice/train", ".train-layout");

        var heading = await pw.Page.Locator(".study-header-title h1").InnerTextAsync();
        Assert.Equal("Tập luyện", heading);

        Assert.True(await pw.Page.Locator(".target-char").IsVisibleAsync());
        Assert.True(await pw.Page.Locator(".target-label").IsVisibleAsync());
        Assert.True(await pw.Page.Locator("#train-canvas").IsVisibleAsync());
    }

    [Fact]
    public async Task Char_Selector_And_Random_Button_Are_Visible()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/practice/train", ".train-layout");

        Assert.True(await pw.Page.Locator(".char-selector").IsVisibleAsync());
        Assert.True(await pw.Page.Locator(".random-btn").CountAsync() >= 1);
    }

    [Fact]
    public async Task Random_Button_Keeps_Valid_Target()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/practice/train", ".train-layout");

        await pw.Page.Locator(".random-btn").ClickAsync();
        await Task.Delay(300);

        var charText = (await pw.Page.Locator(".target-char").InnerTextAsync()).Trim();
        Assert.False(string.IsNullOrWhiteSpace(charText));
    }

    [Fact]
    public async Task Save_With_Empty_Canvas_Shows_Error()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/practice/train", ".train-layout");

        await pw.Page.ClickAsync("text=Lưu mẫu");
        await pw.Page.WaitForSelectorAsync(".save-message.msg-err", new() { Timeout = 5000 });

        var message = await pw.Page.Locator(".save-message").InnerTextAsync();
        Assert.Contains("Lỗi", message);
    }

    [Fact]
    public async Task Template_Stats_Are_Visible()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/practice/train", ".train-layout");

        Assert.True(await pw.Page.Locator(".template-stats h3").IsVisibleAsync());
        Assert.True(await pw.Page.Locator(".export-btn").IsVisibleAsync());
        Assert.True(await pw.Page.Locator(".import-btn").IsVisibleAsync());
    }

    [Fact]
    public async Task Layout_Is_Centered()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/practice/train", ".train-layout");

        var maxWidth = await GetStyleAsync(pw.Page, ".practice-container", "maxWidth");
        Assert.Equal("520px", maxWidth);
    }
}
