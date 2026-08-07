using Microsoft.Playwright;

namespace JapaneseLearner.E2ETests;

public class GrammarStudyTests : E2ETestBase
{
    public GrammarStudyTests(AppFixture fixture) : base(fixture) { }

    [Fact]
    public async Task Page_Loads_And_Lists_Grammar()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/grammar", ".grammar-card");

        var heading = await pw.Page.Locator(".study-header-title h1").InnerTextAsync();
        Assert.Equal("Ngữ pháp N5", heading);

        var cards = pw.Page.Locator(".grammar-card");
        Assert.True(await cards.CountAsync() >= 1);

        Assert.True(await pw.Page.Locator(".word-count").IsVisibleAsync());
    }

    [Fact]
    public async Task Filter_Buttons_Are_Visible()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/grammar", ".grammar-card");

        var filterBtns = pw.Page.Locator(".filter-btn");
        Assert.Equal(2, await filterBtns.CountAsync());
    }

    [Fact]
    public async Task Card_Click_Navigates_To_Detail()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/grammar", ".grammar-card");

        await pw.Page.Locator(".grammar-card").First.ClickAsync();
        await pw.Page.WaitForSelectorAsync(".grammar-hero-pattern", new() { Timeout = 10000 });
        Assert.Matches(@"/grammar/\d+", pw.Page.Url);
    }

    [Fact]
    public async Task Card_Shows_Pattern_Level_And_Meaning()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/grammar", ".grammar-card");

        Assert.True(await pw.Page.Locator(".grammar-pattern").CountAsync() >= 1);
        Assert.True(await pw.Page.Locator(".grammar-level-badge").CountAsync() >= 1);
        Assert.True(await pw.Page.Locator(".grammar-meaning").CountAsync() >= 1);
        Assert.True(await pw.Page.Locator(".grammar-example-count").CountAsync() >= 1);
    }

    [Fact]
    public async Task Layout_Is_Centered()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/grammar", ".grammar-card");

        var maxWidth = await GetStyleAsync(pw.Page, ".grammar-study-container", "maxWidth");
        Assert.Equal("720px", maxWidth);
    }

    [Fact]
    public async Task Level_Badge_Uses_Design_Token()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/grammar", ".grammar-card");

        var levelText = await GetCssVarAsync(pw.Page, ".grammar-level-badge", "--badge-level-text");
        Assert.Equal("#66500d", levelText);
    }
}
