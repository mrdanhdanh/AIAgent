using Microsoft.Playwright;

namespace JapaneseLearner.E2ETests;

public class KanjiStudyTests : E2ETestBase
{
    public KanjiStudyTests(AppFixture fixture) : base(fixture) { }

    [Fact]
    public async Task Page_Loads_And_Shows_Kanji()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/kanji", ".kanji-study-container");

        var heading = await pw.Page.Locator(".study-header-title h1").InnerTextAsync();
        Assert.Equal("Luyện Kanji", heading);

        var kanji = (await pw.Page.Locator(".kanji-char").InnerTextAsync()).Trim();
        Assert.False(string.IsNullOrWhiteSpace(kanji));

        var statBoxes = pw.Page.Locator(".stat-box");
        Assert.Equal(2, await statBoxes.CountAsync());
    }

    [Fact]
    public async Task Filter_Buttons_Are_Visible()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/kanji", ".kanji-study-container");

        var filterBtns = pw.Page.Locator(".filter-btn");
        Assert.Equal(2, await filterBtns.CountAsync());

        await pw.Page.ClickAsync(".filter-btn:has-text('N5')");
        await Task.Delay(300);
        var active = pw.Page.Locator(".filter-btn.active");
        Assert.Contains("N5", await active.InnerTextAsync());
    }

    [Fact]
    public async Task Wrong_Answer_Shows_On_Kun_Readings()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/kanji", ".kanji-study-container");

        await SetValueAndPressEnterAsync(pw.Page, "---wrong---");

        await pw.Page.WaitForSelectorAsync(".feedback-wrong", new() { Timeout = 5000 });
        var feedback = await pw.Page.Locator(".feedback-wrong").InnerTextAsync();
        Assert.Contains("Âm On:", feedback);
        Assert.Contains("Âm Kun:", feedback);

        await pw.Page.WaitForSelectorAsync("text=Tiếp →", new() { Timeout = 5000 });
        Assert.True(await pw.Page.Locator("text=Tiếp →").IsVisibleAsync());
    }

    [Fact]
    public async Task Correct_Answer_Shows_Reading_Boxes()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/kanji", ".kanji-study-container");

        var kanji = (await pw.Page.Locator(".kanji-char").InnerTextAsync()).Trim();
        var onYomi = await LookupKanjiOnYomiAsync(pw.Page, kanji);
        Assert.False(string.IsNullOrEmpty(onYomi), $"Không tìm thấy On-yomi cho '{kanji}'");

        var reading = onYomi.Split(new[] { '・', '、', ',', ' ' }, StringSplitOptions.RemoveEmptyEntries)[0];

        await SetValueAndPressEnterAsync(pw.Page, reading);

        await pw.Page.WaitForSelectorAsync(".feedback-correct", new() { Timeout = 5000 });
        Assert.True(await pw.Page.Locator(".reading-display").IsVisibleAsync());
        Assert.Equal(2, await pw.Page.Locator(".reading-box").CountAsync());
    }

    [Fact]
    public async Task Layout_Is_Centered()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/kanji", ".kanji-study-container");

        var maxWidth = await GetStyleAsync(pw.Page, ".kanji-study-container", "maxWidth");
        Assert.Equal("520px", maxWidth);
    }

    [Fact]
    public async Task Badges_Use_Design_Token_Colors()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/kanji", ".kanji-study-container");

        var levelColor = await GetCssVarAsync(pw.Page, ".level-badge", "--badge-level-text");
        Assert.Equal("#66500d", levelColor);

        var textPrimary = await GetCssVarAsync(pw.Page, ".kanji-char", "--text-primary");
        Assert.Equal("#2b211f", textPrimary);
    }
}
