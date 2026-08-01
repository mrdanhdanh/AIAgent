using Microsoft.Playwright;

namespace JapaneseLearner.E2ETests;

public class WordStudyTests : E2ETestBase
{
    public WordStudyTests(AppFixture fixture) : base(fixture) { }

    [Fact]
    public async Task Page_Loads_And_Shows_Word()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/words", ".japanese-char-display");

        var wordText = (await pw.Page.Locator(".japanese-char-display").InnerTextAsync()).Trim();
        Assert.False(string.IsNullOrWhiteSpace(wordText));
    }

    [Fact]
    public async Task Tab_Click_Changes_Active_State()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/words", ".japanese-char-display");

        await pw.Page.GetByRole(AriaRole.Button, new() { Name = "濁音", Exact = true }).ClickAsync();
        await Task.Delay(300);

        var activeBtn = pw.Page.Locator("button.active");
        var text = (await activeBtn.InnerTextAsync()).Trim();
        Assert.Contains("濁音", text);
    }

    [Fact]
    public async Task Typing_Answer_Shows_Feedback()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/words", ".japanese-char-display");

        await SetValueAndPressEnterAsync(pw.Page, "test");
        await pw.Page.Locator(".feedback").WaitForAsync(new() { Timeout = 5000 });
        Assert.True(await pw.Page.Locator(".feedback").IsVisibleAsync());
    }

    [Fact]
    public async Task Wrong_Answer_Shows_Correct_Answer()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/words", ".japanese-char-display");

        await SetValueAndPressEnterAsync(pw.Page, "---wrong---");
        await pw.Page.WaitForSelectorAsync("text=Đáp án đúng:", new() { Timeout = 5000 });
        Assert.True(await pw.Page.Locator("text=Đáp án đúng:").IsVisibleAsync());
    }

    [Fact]
    public async Task All_Seven_Tabs_Are_Displayed()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/words", ".japanese-char-display");

        var tabs = pw.Page.Locator(".tab-btn");
        Assert.Equal(7, await tabs.CountAsync());

        var expectedTabs = new[] { "Tất cả", "清音", "濁音", "半濁音", "拗音", "促音", "長音" };
        foreach (var tab in expectedTabs)
        {
            var btn = pw.Page.GetByRole(AriaRole.Button, new() { Name = tab, Exact = true });
            Assert.True(await btn.IsVisibleAsync(), $"Tab '{tab}' not visible");
        }
    }

    [Fact]
    public async Task Type_Badge_Is_Displayed_After_Tab_Click()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/words", ".japanese-char-display");

        await pw.Page.ClickAsync("text=清音");
        await Task.Delay(300);

        var badge = pw.Page.Locator(".type-badge");
        Assert.True(await badge.IsVisibleAsync());
    }
}
