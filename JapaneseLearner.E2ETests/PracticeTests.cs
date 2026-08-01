using Microsoft.Playwright;

namespace JapaneseLearner.E2ETests;

public class PracticeTests : E2ETestBase
{
    public PracticeTests(AppFixture fixture) : base(fixture) { }

    [Fact]
    public async Task Page_Loads_With_Tabs_And_Stats()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/practice", ".practice-container");

        var heading = await pw.Page.Locator(".study-header-title h1").InnerTextAsync();
        Assert.Equal("Luyện viết", heading);

        var tabs = pw.Page.Locator(".tab-btn");
        Assert.Equal(2, await tabs.CountAsync());

        var statBoxes = pw.Page.Locator(".stat-box");
        Assert.Equal(2, await statBoxes.CountAsync());
    }

    [Fact]
    public async Task Dictionary_Mode_Shows_Prompt_And_Canvas()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/practice", ".practice-container");

        Assert.True(await pw.Page.Locator(".prompt-romaji").IsVisibleAsync());
        Assert.True(await pw.Page.Locator("#practice-canvas").IsVisibleAsync());
        Assert.True(await pw.Page.Locator(".romaji-input").CountAsync() >= 1);
    }

    [Fact]
    public async Task Correct_Answer_Shows_Green_Feedback()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/practice", ".practice-container");

        var prompt = (await pw.Page.Locator(".prompt-romaji").InnerTextAsync()).Trim();
        var answer = await LookupWordCharactersByRomajiAsync(pw.Page, prompt);
        Assert.NotNull(answer);

        await SetValueAndPressEnterAsync(pw.Page, answer!);

        await pw.Page.WaitForSelectorAsync(".feedback-correct", new() { Timeout = 5000 });
        var feedback = await pw.Page.Locator(".feedback-correct").InnerTextAsync();
        Assert.Contains("Chính xác", feedback);
    }

    [Fact]
    public async Task Wrong_Answer_Shows_Red_Feedback()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/practice", ".practice-container");

        var prompt = (await pw.Page.Locator(".prompt-romaji").InnerTextAsync()).Trim();
        var answer = await LookupWordCharactersByRomajiAsync(pw.Page, prompt);
        Assert.NotNull(answer);

        var wrong = "zzzz" + answer!;
        await SetValueAndPressEnterAsync(pw.Page, wrong);

        await pw.Page.WaitForSelectorAsync(".feedback-wrong", new() { Timeout = 5000 });
        var feedback = await pw.Page.Locator(".feedback-wrong").InnerTextAsync();
        Assert.Contains("Đáp án đúng:", feedback);
        Assert.Contains(answer, feedback);
    }

    [Fact]
    public async Task Layout_Is_Centered()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/practice", ".practice-container");

        var maxWidth = await GetStyleAsync(pw.Page, ".practice-container", "maxWidth");
        Assert.Equal("520px", maxWidth);
    }
}
