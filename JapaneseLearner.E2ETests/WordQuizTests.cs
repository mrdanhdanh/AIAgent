using Microsoft.Playwright;

namespace JapaneseLearner.E2ETests;

public class WordQuizTests : E2ETestBase
{
    public WordQuizTests(AppFixture fixture) : base(fixture) { }

    [Fact]
    public async Task Page_Loads_And_Shows_Quiz()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/words/quiz", ".word-quiz-container");

        var heading = await pw.Page.Locator(".study-header-title h1").InnerTextAsync();
        Assert.Equal("Trắc nghiệm từ vựng", heading);

        var statBoxes = pw.Page.Locator(".stat-box");
        Assert.Equal(2, await statBoxes.CountAsync());

        var options = pw.Page.Locator(".option-btn");
        Assert.Equal(4, await options.CountAsync());

        var tabs = pw.Page.Locator(".tab-btn");
        Assert.Equal(7, await tabs.CountAsync());
    }

    [Fact]
    public async Task Tab_Switch_Filters_Questions()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/words/quiz", ".word-quiz-container");

        await pw.Page.ClickAsync(".tab-btn:has-text('清音')");
        await Task.Delay(300);

        var active = pw.Page.Locator(".tab-btn.active");
        Assert.Contains("清音", await active.InnerTextAsync());
        Assert.True(await pw.Page.Locator(".japanese-char-display").IsVisibleAsync());
    }

    [Fact]
    public async Task Selecting_Correct_Answer_Shows_Green_Feedback()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/words/quiz", ".word-quiz-container");

        var displayed = (await pw.Page.Locator(".japanese-char-display").InnerTextAsync()).Trim();
        var meaning = await LookupWordMeaningAsync(pw.Page, displayed);
        Assert.False(string.IsNullOrEmpty(meaning), $"Không tìm thấy nghĩa cho '{displayed}'");

        await ClickOptionByExactTextAsync(pw.Page, meaning);

        await pw.Page.WaitForSelectorAsync(".feedback-correct", new() { Timeout = 5000 });
        Assert.Contains("Chính xác", await pw.Page.Locator(".feedback-correct").InnerTextAsync());
    }

    [Fact]
    public async Task Selecting_Wrong_Answer_Shows_Correct_Meaning()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/words/quiz", ".word-quiz-container");

        var displayed = (await pw.Page.Locator(".japanese-char-display").InnerTextAsync()).Trim();
        var meaning = await LookupWordMeaningAsync(pw.Page, displayed);
        Assert.NotNull(meaning);

        var wrongOption = pw.Page.Locator(".option-btn").First;
        if ((await wrongOption.InnerTextAsync()).Trim() == meaning)
            wrongOption = pw.Page.Locator(".option-btn").Nth(1);
        await wrongOption.ClickAsync();

        await pw.Page.WaitForSelectorAsync(".feedback-wrong", new() { Timeout = 5000 });
        var feedback = await pw.Page.Locator(".feedback-wrong").InnerTextAsync();
        Assert.Contains("Đáp án đúng:", feedback);
        Assert.Contains(meaning, feedback);
    }

    [Fact]
    public async Task Layout_Is_Centered_With_Responsive_Grid()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/words/quiz", ".word-quiz-container");

        var maxWidth = await GetStyleAsync(pw.Page, ".word-quiz-container", "maxWidth");
        Assert.Equal("520px", maxWidth);

        var cols = await CountTrackColumnsAsync(pw.Page, ".options-grid");
        Assert.Equal(2, cols);
    }
}
