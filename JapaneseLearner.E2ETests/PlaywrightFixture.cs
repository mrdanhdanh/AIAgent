using Microsoft.Playwright;

namespace JapaneseLearner.E2ETests;

public class PlaywrightFixture : IAsyncDisposable
{
    private readonly IPlaywright _playwright;
    private readonly IBrowser _browser;
    public IPage Page { get; }

    private PlaywrightFixture(IPlaywright playwright, IBrowser browser, IPage page)
    {
        _playwright = playwright;
        _browser = browser;
        Page = page;
    }

    public static async Task<PlaywrightFixture> CreateAsync()
    {
        var playwright = await Playwright.CreateAsync();
        var browser = await playwright.Chromium.LaunchAsync(new()
        {
            Headless = true,
            ExecutablePath = @"C:\Users\nguye\AppData\Local\ms-playwright\chromium-1228\chrome-win64\chrome.exe"
        });
        var page = await browser.NewPageAsync();
        return new PlaywrightFixture(playwright, browser, page);
    }

    public async ValueTask DisposeAsync()
    {
        await _browser.CloseAsync();
        _playwright.Dispose();
    }
}
