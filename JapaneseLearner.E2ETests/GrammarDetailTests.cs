using Microsoft.Playwright;

namespace JapaneseLearner.E2ETests;

public class GrammarDetailTests : E2ETestBase
{
    public GrammarDetailTests(AppFixture fixture) : base(fixture) { }

    [Fact]
    public async Task Detail_Page_Shows_Pattern_And_Meaning()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/grammar/1", ".grammar-hero-pattern");

        var pattern = (await pw.Page.Locator(".grammar-hero-pattern").InnerTextAsync()).Trim();
        Assert.False(string.IsNullOrWhiteSpace(pattern));

        Assert.True(await pw.Page.Locator(".meaning").IsVisibleAsync());
        Assert.True(await pw.Page.Locator(".grammar-level-badge-detail").IsVisibleAsync());
    }

    [Fact]
    public async Task Detail_Page_Shows_Explanation_Info()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/grammar/1", ".grammar-hero-pattern");

        Assert.True(await pw.Page.Locator(".info-explanation").IsVisibleAsync());
        Assert.True(await pw.Page.Locator(".info-card").CountAsync() >= 2);
    }

    [Fact]
    public async Task Layout_Is_Centered()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/grammar/1", ".grammar-hero-pattern");

        var maxWidth = await GetStyleAsync(pw.Page, ".grammar-detail-container", "maxWidth");
        Assert.Equal("640px", maxWidth);
    }

    [Fact]
    public async Task Back_Button_Navigates_To_List()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/grammar/1", ".grammar-hero-pattern");

        await pw.Page.ClickAsync("text=← Quay lại");
        await pw.Page.WaitForSelectorAsync(".grammar-card", new() { Timeout = 10000 });
        Assert.Contains("/grammar", pw.Page.Url);
    }

    [Fact]
    public async Task Level_Badge_Uses_Design_Token()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/grammar/1", ".grammar-hero-pattern");

        var levelText = await GetCssVarAsync(pw.Page, ".grammar-level-badge-detail", "--badge-level-text");
        Assert.Equal("#66500d", levelText);
    }

    [Fact]
    public async Task Invalid_Id_Shows_Empty_State()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/grammar/999999", ".empty-state");

        var heading = await pw.Page.Locator(".empty-state h3").InnerTextAsync();
        Assert.Equal("Không tìm thấy mẫu ngữ pháp", heading);
    }
}
