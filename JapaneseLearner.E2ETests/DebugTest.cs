namespace JapaneseLearner.E2ETests;

public class DebugTest : IClassFixture<AppFixture>
{
    private readonly AppFixture _fixture;
    public DebugTest(AppFixture fixture) => _fixture = fixture;

    [Fact]
    public async Task Screenshot_All_Pages()
    {
        await using var pw = await PlaywrightFixture.CreateAsync();

        // Home page
        await pw.Page.GotoAsync(_fixture.ServerUrl);
        await pw.Page.WaitForLoadStateAsync(Microsoft.Playwright.LoadState.NetworkIdle);
        var homeTitle = await pw.Page.TitleAsync();
        await pw.Page.ScreenshotAsync(new() { Path = Path.Combine(Path.GetTempPath(), "pw_home.png") });
        var homeBody = await pw.Page.InnerTextAsync("body");

        // WordStudy
        await pw.Page.GotoAsync($"{_fixture.ServerUrl}/words");
        await pw.Page.WaitForLoadStateAsync(Microsoft.Playwright.LoadState.NetworkIdle);
        var wordsTitle = await pw.Page.TitleAsync();
        await pw.Page.ScreenshotAsync(new() { Path = Path.Combine(Path.GetTempPath(), "pw_words.png") });

        // Admin
        await pw.Page.GotoAsync($"{_fixture.ServerUrl}/admin");
        await pw.Page.WaitForLoadStateAsync(Microsoft.Playwright.LoadState.NetworkIdle);
        var adminTitle = await pw.Page.TitleAsync();
        await pw.Page.ScreenshotAsync(new() { Path = Path.Combine(Path.GetTempPath(), "pw_admin.png") });

        Assert.True(true, $"Home:'{homeTitle}' Words:'{wordsTitle}' Admin:'{adminTitle}'");
    }
}
