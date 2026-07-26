namespace JapaneseLearner.E2ETests;

public class WordStudyTests : IClassFixture<AppFixture>
{
    private readonly AppFixture _fixture;
    public WordStudyTests(AppFixture fixture) => _fixture = fixture;

    [Fact]
    public async Task Page_Loads_And_Shows_Word()
    {
        await using var pw = await PlaywrightFixture.CreateAsync();
        await pw.Page.GotoAsync($"{_fixture.ServerUrl}/words");

        await pw.Page.WaitForSelectorAsync(".japanese-word");
        var wordText = await pw.Page.TextContentAsync(".japanese-word");
        Assert.False(string.IsNullOrWhiteSpace(wordText));
    }

    [Fact]
    public async Task Tab_Click_Changes_Active_State()
    {
        await using var pw = await PlaywrightFixture.CreateAsync();
        await pw.Page.GotoAsync($"{_fixture.ServerUrl}/words");

        await pw.Page.ClickAsync("text=濁音");
        await Task.Delay(300);

        var activeBtn = pw.Page.Locator("button.active");
        var text = await activeBtn.TextContentAsync();
        Assert.Contains("濁音", text);
    }

    [Fact]
    public async Task Typing_Answer_Shows_Feedback()
    {
        await using var pw = await PlaywrightFixture.CreateAsync();
        await pw.Page.GotoAsync($"{_fixture.ServerUrl}/words");

        await pw.Page.WaitForSelectorAsync(".romaji-input input");
        await pw.Page.FillAsync(".romaji-input input", "test");
        await pw.Page.ClickAsync("text=Kiểm tra");

        await pw.Page.WaitForSelectorAsync(".feedback", new() { Timeout = 5000 });
        Assert.True(await pw.Page.Locator(".feedback").IsVisibleAsync());
    }

    [Fact]
    public async Task Wrong_Answer_Shows_Correct_Answer()
    {
        await using var pw = await PlaywrightFixture.CreateAsync();
        await pw.Page.GotoAsync($"{_fixture.ServerUrl}/words");

        await pw.Page.WaitForSelectorAsync(".romaji-input input");
        await pw.Page.FillAsync(".romaji-input input", "---wrong---");
        await pw.Page.ClickAsync("text=Kiểm tra");

        await pw.Page.WaitForSelectorAsync("text=Đáp án đúng:");
        Assert.True(await pw.Page.Locator("text=Đáp án đúng:").IsVisibleAsync());
    }

    [Fact]
    public async Task All_Seven_Tabs_Are_Displayed()
    {
        await using var pw = await PlaywrightFixture.CreateAsync();
        await pw.Page.GotoAsync($"{_fixture.ServerUrl}/words");

        var expectedTabs = new[] { "Tất cả", "清音", "濁音", "半濁音", "拗音", "促音", "長音" };
        foreach (var tab in expectedTabs)
        {
            var btn = pw.Page.Locator($"button:has-text(\"{tab}\")");
            Assert.True(await btn.IsVisibleAsync(), $"Tab '{tab}' not visible");
        }
    }

    [Fact]
    public async Task Type_Badge_Is_Displayed_After_Tab_Click()
    {
        await using var pw = await PlaywrightFixture.CreateAsync();
        await pw.Page.GotoAsync($"{_fixture.ServerUrl}/words");

        await pw.Page.ClickAsync("text=清音");
        await Task.Delay(300);

        var badge = pw.Page.Locator(".type-badge");
        Assert.True(await badge.IsVisibleAsync());
    }
}
