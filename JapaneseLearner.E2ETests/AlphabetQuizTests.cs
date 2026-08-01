using Microsoft.Playwright;

namespace JapaneseLearner.E2ETests;

public class AlphabetQuizTests : E2ETestBase
{
    public AlphabetQuizTests(AppFixture fixture) : base(fixture) { }

    [Fact]
    public async Task Page_Loads_And_Shows_Quiz()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/alphabet/quiz", ".kana-quiz-container");

        var heading = await pw.Page.Locator(".study-header-title h1").InnerTextAsync();
        Assert.Equal("Trắc nghiệm bảng chữ cái", heading);

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
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/alphabet/quiz", ".kana-quiz-container");

        await pw.Page.ClickAsync(".mode-btn:has-text('Romaji → Kana')");
        await pw.Page.WaitForSelectorAsync(".romaji-text");

        Assert.True(await pw.Page.Locator(".romaji-text").IsVisibleAsync());
        var activeBtn = pw.Page.Locator(".mode-btn.active");
        Assert.Contains("Romaji → Kana", await activeBtn.InnerTextAsync());
    }

    [Fact]
    public async Task Selecting_Correct_Answer_Shows_Green_Feedback()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/alphabet/quiz", ".kana-quiz-container");

        var displayed = (await pw.Page.Locator(".kana-char").InnerTextAsync()).Trim();
        var romaji = await LookupCharRomajiAsync(pw.Page, displayed);
        Assert.False(string.IsNullOrEmpty(romaji), $"Không tìm thấy romaji cho '{displayed}'");

        await ClickOptionByExactTextAsync(pw.Page, romaji);

        await pw.Page.WaitForSelectorAsync(".feedback-correct", new() { Timeout = 5000 });
        Assert.Contains("Chính xác", await pw.Page.Locator(".feedback-correct").InnerTextAsync());
    }

    [Fact]
    public async Task Selecting_Wrong_Answer_Shows_Red_Feedback_With_Correct_Answer()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/alphabet/quiz", ".kana-quiz-container");

        var displayed = (await pw.Page.Locator(".kana-char").InnerTextAsync()).Trim();
        var romaji = await LookupCharRomajiAsync(pw.Page, displayed);

        var wrongOption = pw.Page.Locator(".option-btn").First;
        var wrongText = (await wrongOption.InnerTextAsync()).Trim();
        if (wrongText == romaji)
        {
            wrongOption = pw.Page.Locator(".option-btn").Nth(1);
        }
        await wrongOption.ClickAsync();

        await pw.Page.WaitForSelectorAsync(".feedback-wrong", new() { Timeout = 5000 });
        Assert.Contains("Đáp án đúng:", await pw.Page.Locator(".feedback-wrong").InnerTextAsync());
    }

    [Fact]
    public async Task Options_Disabled_After_Selection()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/alphabet/quiz", ".kana-quiz-container");

        await pw.Page.Locator(".option-btn").First.ClickAsync();
        await pw.Page.WaitForSelectorAsync(".opt-disabled", new() { Timeout = 5000 });

        var disabledCount = await pw.Page.Locator(".option-btn.opt-disabled").CountAsync();
        Assert.Equal(4, disabledCount);
        Assert.True(await pw.Page.Locator(".option-btn[disabled]").CountAsync() == 4);
    }

    [Fact]
    public async Task Stat_Boxes_Update_After_Answer()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/alphabet/quiz", ".kana-quiz-container");

        var displayed = (await pw.Page.Locator(".kana-char").InnerTextAsync()).Trim();
        var romaji = await LookupCharRomajiAsync(pw.Page, displayed);
        Assert.NotNull(romaji);
        await ClickOptionByExactTextAsync(pw.Page, romaji);

        await pw.Page.WaitForSelectorAsync(".feedback-correct", new() { Timeout = 5000 });

        var correctNum = await pw.Page.Locator(".stat-correct .stat-num").InnerTextAsync();
        var wrongNum = await pw.Page.Locator(".stat-wrong .stat-num").InnerTextAsync();
        Assert.Equal("1", correctNum);
        Assert.Equal("0", wrongNum);
    }

    [Fact]
    public async Task Layout_Is_Centered_And_Responsive_Grid()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/alphabet/quiz", ".kana-quiz-container");

        var maxWidth = await GetStyleAsync(pw.Page, ".kana-quiz-container", "maxWidth");
        Assert.Equal("520px", maxWidth);

        var cols = await CountTrackColumnsAsync(pw.Page, ".options-grid");
        Assert.Equal(2, cols);
    }

    [Fact]
    public async Task Colors_Use_Design_Tokens()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/alphabet/quiz", ".kana-quiz-container");

        var accent = await GetCssVarAsync(pw.Page, ".app-layout", "--accent-color");
        Assert.Equal("#c5413b", accent);

        var bgCard = await GetCssVarAsync(pw.Page, ".study-card", "--bg-card");
        Assert.Equal("#ffffff", bgCard);
    }
}
