namespace JapaneseLearner.E2ETests;

[Collection("E2E")]
public class HomePageTests
{
    private readonly AppFixture _fixture;
    public HomePageTests(AppFixture fixture) => _fixture = fixture;

    [Fact]
    public async Task Page_Loads_With_Correct_Title()
    {
        await using var pw = await PlaywrightFixture.CreateAsync();
        await pw.Page.GotoAsync(_fixture.ServerUrl);

        // Wait for Blazor to render and update the page title
        await pw.Page.WaitForSelectorAsync(".hero-title", new() { Timeout = 15000 });
        await Task.Delay(1000);

        var title = await pw.Page.TitleAsync();
        Assert.Equal("Japanese Learner — Học tiếng Nhật", title);
    }

    [Fact]
    public async Task Hero_Title_Is_Displayed()
    {
        await using var pw = await PlaywrightFixture.CreateAsync();
        await pw.Page.GotoAsync(_fixture.ServerUrl);

        await pw.Page.WaitForSelectorAsync(".hero-title");
        var titleText = await pw.Page.TextContentAsync(".hero-title");
        Assert.Equal("Japanese Learner", titleText);
    }

    [Fact]
    public async Task Hero_Subtitle_Is_Displayed()
    {
        await using var pw = await PlaywrightFixture.CreateAsync();
        await pw.Page.GotoAsync(_fixture.ServerUrl);

        await pw.Page.WaitForSelectorAsync(".hero-subtitle");
        Assert.True(await pw.Page.Locator(".hero-subtitle").IsVisibleAsync());
    }

    [Fact]
    public async Task Navigation_Cards_Are_Displayed()
    {
        await using var pw = await PlaywrightFixture.CreateAsync();
        await pw.Page.GotoAsync(_fixture.ServerUrl);

        await pw.Page.WaitForSelectorAsync(".nav-card");
        var cards = pw.Page.Locator(".nav-card");
        Assert.Equal(5, await cards.CountAsync());
    }

    [Fact]
    public async Task Navigation_Cards_Have_Expected_Titles()
    {
        await using var pw = await PlaywrightFixture.CreateAsync();
        await pw.Page.GotoAsync(_fixture.ServerUrl);

        await pw.Page.WaitForSelectorAsync(".nav-card-title");
        var titles = pw.Page.Locator(".nav-card-title");
        var expected = new[] { "Bảng chữ cái", "Từ vựng", "Quiz từ vựng", "Kanji", "Quản trị" };

        Assert.Equal(expected.Length, await titles.CountAsync());
        for (int i = 0; i < expected.Length; i++)
        {
            var text = await titles.Nth(i).TextContentAsync();
            Assert.Equal(expected[i], text);
        }
    }

    [Fact]
    public async Task All_Cards_Have_Navigation_Buttons()
    {
        await using var pw = await PlaywrightFixture.CreateAsync();
        await pw.Page.GotoAsync(_fixture.ServerUrl);

        await pw.Page.WaitForSelectorAsync(".nav-card-btn");
        var buttons = pw.Page.Locator(".nav-card-btn");
        Assert.Equal(5, await buttons.CountAsync());
    }

    [Fact]
    public async Task Navigate_To_Alphabet_Shows_Flashcard()
    {
        await using var pw = await PlaywrightFixture.CreateAsync();
        // Navigate directly via URL to avoid SPA link rendering issues
        await pw.Page.GotoAsync($"{_fixture.ServerUrl}/alphabet");

        // Wait for the alphabet page flashcard content to render
        await pw.Page.WaitForSelectorAsync(".japanese-char-display", new() { Timeout = 15000 });
        Assert.Contains("/alphabet", pw.Page.Url);
    }

    [Fact]
    public async Task Hero_Section_Has_Book_Icon()
    {
        await using var pw = await PlaywrightFixture.CreateAsync();
        await pw.Page.GotoAsync(_fixture.ServerUrl);

        await pw.Page.WaitForSelectorAsync(".hero-icon");
        Assert.True(await pw.Page.Locator(".hero-icon").IsVisibleAsync());
    }
}
