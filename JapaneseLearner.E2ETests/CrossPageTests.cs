using Microsoft.Playwright;

namespace JapaneseLearner.E2ETests;

public class CrossPageTests : E2ETestBase
{
    public CrossPageTests(AppFixture fixture) : base(fixture) { }

    private static async Task<string?> GetThemeAsync(IPage page)
    {
        return await page.Locator(".app-layout").First.GetAttributeAsync("data-theme");
    }

    [Fact]
    public async Task Theme_Toggle_Switches_DataTheme()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/", ".app-layout");

        var initial = await GetThemeAsync(pw.Page);
        Assert.Contains(initial, new[] { "light", "dark" });

        await pw.Page.Locator(".theme-btn").First.ClickAsync();
        await Task.Delay(400);

        var after = await GetThemeAsync(pw.Page);
        Assert.NotEqual(initial, after);
    }

    [Fact]
    public async Task Theme_Toggle_Changes_Accent_Color()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/", ".app-layout");

        var lightAccent = await GetCssVarAsync(pw.Page, ".app-layout", "--accent-color");
        Assert.Equal("#c5413b", lightAccent);

        await pw.Page.Locator(".theme-btn").First.ClickAsync();
        await Task.Delay(400);

        var darkAccent = await GetCssVarAsync(pw.Page, ".app-layout", "--accent-color");
        Assert.Equal("#e56a55", darkAccent);
        Assert.NotEqual(lightAccent, darkAccent);
    }

    [Fact]
    public async Task Theme_Toggle_Changes_Card_And_Text_Colors()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/", ".app-layout");

        var lightBg = await GetCssVarAsync(pw.Page, ".app-layout", "--bg-card");
        var lightText = await GetCssVarAsync(pw.Page, ".app-layout", "--text-primary");
        Assert.Equal("#ffffff", lightBg);
        Assert.Equal("#2b211f", lightText);

        await pw.Page.Locator(".theme-btn").First.ClickAsync();
        await Task.Delay(400);

        var darkBg = await GetCssVarAsync(pw.Page, ".app-layout", "--bg-card");
        var darkText = await GetCssVarAsync(pw.Page, ".app-layout", "--text-primary");
        Assert.Equal("#1f1c1a", darkBg);
        Assert.Equal("#ece7e1", darkText);
    }

    [Fact]
    public async Task Theme_Preference_Persists_Across_Reload()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/", ".app-layout");

        var initial = await GetThemeAsync(pw.Page);
        await pw.Page.Locator(".theme-btn").First.ClickAsync();
        await Task.Delay(400);
        var toggled = await GetThemeAsync(pw.Page);
        Assert.NotEqual(initial, toggled);

        await pw.Page.ReloadAsync();
        await pw.Page.WaitForSelectorAsync(".app-layout", new() { Timeout = 15000 });

        var reloaded = await GetThemeAsync(pw.Page);
        Assert.Equal(toggled, reloaded);
    }

    [Fact]
    public async Task Brand_Is_Visible_On_Every_Page()
    {
        var pages = new[] { "/", "/alphabet", "/words", "/kanji", "/grammar", "/practice" };
        foreach (var path in pages)
        {
            await using var pw = await GotoAsync($"{Fixture.ServerUrl}{path}", ".app-bar");
            Assert.True(await pw.Page.Locator(".brand-name").IsVisibleAsync(), $"Brand missing on {path}");
            var brandText = (await pw.Page.Locator(".brand-name").InnerTextAsync()).Trim();
            Assert.Equal("Japanese Learner", brandText);
        }
    }
}
