using Microsoft.Playwright;

namespace JapaneseLearner.E2ETests;

public class KanjiQuizTests : E2ETestBase
{
    public KanjiQuizTests(AppFixture fixture) : base(fixture) { }

    [Fact]
    public async Task Page_Loads_And_Shows_Quiz()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/kanji/quiz", ".kanji-quiz-container");

        var heading = await pw.Page.Locator(".study-header-title h1").InnerTextAsync();
        Assert.Equal("Trắc nghiệm Kanji từ vựng", heading);

        var statBoxes = pw.Page.Locator(".stat-box");
        Assert.Equal(2, await statBoxes.CountAsync());

        var options = pw.Page.Locator(".option-btn");
        Assert.Equal(4, await options.CountAsync());

        var modeBtns = pw.Page.Locator(".mode-btn");
        Assert.Equal(2, await modeBtns.CountAsync());
    }

    [Fact]
    public async Task Mode_Toggle_Switches_Display()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/kanji/quiz", ".kanji-quiz-container");

        await pw.Page.ClickAsync(".mode-btn:has-text('Romaji → Kanji')");
        await pw.Page.WaitForSelectorAsync(".romaji-text");

        Assert.True(await pw.Page.Locator(".romaji-text").IsVisibleAsync());
        var activeBtn = pw.Page.Locator(".mode-btn.active");
        Assert.Contains("Romaji → Kanji", await activeBtn.InnerTextAsync());
    }

    /// <summary>
    /// Click option[0]; if the quiz auto-advances to the next question (random word),
    /// retry until the requested outcome (correct or wrong) is observed.
    /// </summary>
    private static async Task<string> ClickUntilOutcomeAsync(IPage page, string want, int maxAttempts = 20)
    {
        for (int i = 0; i < maxAttempts; i++)
        {
            await page.Locator(".option-btn").First.ClickAsync();

            for (int w = 0; w < 30; w++)
            {
                var correct = await page.Locator(".feedback-correct").CountAsync();
                var wrong = await page.Locator(".feedback-wrong").CountAsync();
                if (correct > 0 && want == "correct") return "correct";
                if (wrong > 0 && want == "wrong") return "wrong";
                if ((correct > 0 || wrong > 0) && want != "correct" && want != "wrong") return correct > 0 ? "correct" : "wrong";
                await Task.Delay(100);
            }

            // Outcome not rendered in time; likely auto-advanced to a new question.
            await page.WaitForSelectorAsync(".option-btn:not(.opt-disabled)", new() { Timeout = 10000 });
        }
        Assert.Fail($"Không đạt được outcome '{want}' sau {maxAttempts} lần thử");
        return "";
    }

    [Fact]
    public async Task Selecting_Any_Option_Highlights_Correct_One_Green()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/kanji/quiz", ".kanji-quiz-container");

        var outcome = await ClickUntilOutcomeAsync(pw.Page, "correct");
        Assert.Equal("correct", outcome);
        await Task.Delay(400); // let the 0.2s border transition settle

        var correctCount = await pw.Page.Locator(".option-btn.opt-correct").CountAsync();
        Assert.Equal(1, correctCount);

        var borderColor = await GetStyleAsync(pw.Page, ".option-btn.opt-correct", "borderColor");
        Assert.Contains("47, 125, 95", borderColor);
    }

    [Fact]
    public async Task Selecting_Wrong_Option_Highlights_Red()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/kanji/quiz", ".kanji-quiz-container");

        var outcome = await ClickUntilOutcomeAsync(pw.Page, "wrong");
        Assert.Equal("wrong", outcome);
        await Task.Delay(400); // let the 0.2s border transition settle

        var borderColor = await GetStyleAsync(pw.Page, ".option-btn.opt-wrong", "borderColor");
        Assert.Contains("197, 65, 59", borderColor);
        Assert.Contains("Đáp án đúng:", await pw.Page.Locator(".feedback-wrong").InnerTextAsync());
    }

    [Fact]
    public async Task Options_Disabled_After_Selection()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/kanji/quiz", ".kanji-quiz-container");

        await pw.Page.Locator(".option-btn").First.ClickAsync();
        await pw.Page.WaitForSelectorAsync(".opt-disabled", new() { Timeout = 5000 });

        Assert.Equal(4, await pw.Page.Locator(".option-btn.opt-disabled").CountAsync());
        Assert.Equal(4, await pw.Page.Locator(".option-btn[disabled]").CountAsync());
    }

    [Fact]
    public async Task Layout_Is_Centered_With_Responsive_Grid()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/kanji/quiz", ".kanji-quiz-container");

        var maxWidth = await GetStyleAsync(pw.Page, ".kanji-quiz-container", "maxWidth");
        Assert.Equal("520px", maxWidth);

        var cols = await CountTrackColumnsAsync(pw.Page, ".options-grid");
        Assert.Equal(2, cols);
    }

    [Fact]
    public async Task Stat_Boxes_Use_Design_Token_Colors()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/kanji/quiz", ".kanji-quiz-container");

        var correctText = await GetCssVarAsync(pw.Page, ".stat-correct", "--stat-correct-text");
        var wrongText = await GetCssVarAsync(pw.Page, ".stat-wrong", "--stat-wrong-text");
        Assert.Equal("#1f5c44", correctText);
        Assert.Equal("#8f2b26", wrongText);
    }
}
