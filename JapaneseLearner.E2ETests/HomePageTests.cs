namespace JapaneseLearner.E2ETests;

public class HomePageTests : E2ETestBase
{
    public HomePageTests(AppFixture fixture) : base(fixture) { }

    [Fact]
    public async Task Page_Loads_With_Correct_Title()
    {
        await using var pw = await GotoAsync(Fixture.ServerUrl, ".hero-title");
        await Task.Delay(1000);

        var title = await pw.Page.TitleAsync();
        Assert.Equal("Japanese Learner — Học tiếng Nhật", title);
    }

    [Fact]
    public async Task Hero_Title_Is_Displayed()
    {
        await using var pw = await GotoAsync(Fixture.ServerUrl, ".hero-title");

        var titleText = (await pw.Page.Locator(".hero-title").InnerTextAsync()).Trim();
        Assert.Equal("Japanese Learner.", titleText);
    }

    [Fact]
    public async Task Hero_Subtitle_Is_Displayed()
    {
        await using var pw = await GotoAsync(Fixture.ServerUrl, ".hero-subtitle");
        Assert.True(await pw.Page.Locator(".hero-subtitle").IsVisibleAsync());
    }

    [Fact]
    public async Task Navigation_Cards_Are_Displayed()
    {
        await using var pw = await GotoAsync(Fixture.ServerUrl, ".nav-card");

        var cards = pw.Page.Locator(".nav-card");
        Assert.Equal(7, await cards.CountAsync());
    }

    [Fact]
    public async Task Navigation_Cards_Have_Expected_Titles()
    {
        await using var pw = await GotoAsync(Fixture.ServerUrl, ".nav-card-title");

        var titles = pw.Page.Locator(".nav-card-title");
        var expected = new[] { "Bảng chữ cái", "Từ vựng", "Luyện viết", "Quiz từ vựng", "Kanji", "Ngữ pháp N5", "Quản trị" };

        Assert.Equal(expected.Length, await titles.CountAsync());
        for (int i = 0; i < expected.Length; i++)
        {
            var text = (await titles.Nth(i).TextContentAsync())?.Trim();
            Assert.Equal(expected[i], text);
        }
    }

    [Fact]
    public async Task All_Cards_Have_Navigation_Buttons()
    {
        await using var pw = await GotoAsync(Fixture.ServerUrl, ".nav-card-btn");

        var buttons = pw.Page.Locator(".nav-card-btn");
        Assert.Equal(7, await buttons.CountAsync());
    }

    [Fact]
    public async Task Navigate_To_Alphabet_Shows_Flashcard()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/alphabet", ".japanese-char-display");
        Assert.Contains("/alphabet", pw.Page.Url);
    }

    [Fact]
    public async Task Hero_Section_Has_Glyph()
    {
        await using var pw = await GotoAsync(Fixture.ServerUrl, ".hero-glyph");
        Assert.True(await pw.Page.Locator(".hero-glyph").IsVisibleAsync());
    }
}
