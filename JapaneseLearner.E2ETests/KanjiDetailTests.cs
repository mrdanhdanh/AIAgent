using Microsoft.Playwright;

namespace JapaneseLearner.E2ETests;

public class KanjiDetailTests : E2ETestBase
{
    public KanjiDetailTests(AppFixture fixture) : base(fixture) { }

    [Fact]
    public async Task Detail_Page_Shows_Kanji_Hero()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/kanji/1", ".kanji-hero-char");

        var kanji = (await pw.Page.Locator(".kanji-hero-char").InnerTextAsync()).Trim();
        Assert.False(string.IsNullOrWhiteSpace(kanji));

        Assert.True(await pw.Page.Locator(".info-card").CountAsync() >= 4);
    }

    [Fact]
    public async Task Detail_Page_Shows_On_Kun_Meanings()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/kanji/1", ".kanji-hero-char");

        Assert.True(await pw.Page.Locator(".info-value.on-yomi").IsVisibleAsync());
        Assert.True(await pw.Page.Locator(".info-value.kun-yomi").IsVisibleAsync());
        Assert.True(await pw.Page.Locator(".info-value.meaning").IsVisibleAsync());
    }

    [Fact]
    public async Task On_Yomi_And_Kun_Yomi_Colors_Are_Distinct()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/kanji/1", ".kanji-hero-char");

        var onColor = await GetCssVarAsync(pw.Page, ".info-value.on-yomi", "--color-on-yomi");
        var kunColor = await GetCssVarAsync(pw.Page, ".info-value.kun-yomi", "--color-kun-yomi");
        Assert.Equal("#c5413b", onColor);
        Assert.Equal("#3f6b85", kunColor);
        Assert.NotEqual(onColor, kunColor);
    }

    [Fact]
    public async Task Back_Button_Navigates_To_List()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/kanji/1", ".kanji-hero-char");

        await pw.Page.ClickAsync("text=← Quay lại");
        await pw.Page.WaitForSelectorAsync(".kanji-study-container", new() { Timeout = 10000 });
        Assert.Contains("/kanji", pw.Page.Url);
    }

    [Fact]
    public async Task Layout_Is_Centered()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/kanji/1", ".kanji-hero-char");

        var maxWidth = await GetStyleAsync(pw.Page, ".kanji-detail-container", "maxWidth");
        Assert.Equal("560px", maxWidth);
    }

    [Fact]
    public async Task Invalid_Id_Shows_Empty_State()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/kanji/999999", ".empty-state");

        var heading = await pw.Page.Locator(".empty-state h3").InnerTextAsync();
        Assert.Equal("Không tìm thấy Kanji", heading);
    }
}
