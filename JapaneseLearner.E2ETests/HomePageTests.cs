namespace JapaneseLearner.E2ETests;

public class HomePageTests : IClassFixture<AppFixture>
{
    private readonly AppFixture _fixture;
    public HomePageTests(AppFixture fixture) => _fixture = fixture;

    [Fact]
    public async Task Page_Loads_And_Shows_Character()
    {
        await using var pw = await PlaywrightFixture.CreateAsync();
        await pw.Page.GotoAsync(_fixture.ServerUrl);

        await pw.Page.WaitForSelectorAsync(".japanese-char");
        var charText = await pw.Page.TextContentAsync(".japanese-char");
        Assert.False(string.IsNullOrWhiteSpace(charText));
    }

    [Fact]
    public async Task Typing_Answer_And_Clicking_Check_Shows_Feedback()
    {
        await using var pw = await PlaywrightFixture.CreateAsync();
        await pw.Page.GotoAsync(_fixture.ServerUrl);

        await pw.Page.WaitForSelectorAsync(".romaji-input input");
        await pw.Page.FillAsync(".romaji-input input", "a");
        await pw.Page.ClickAsync("text=Kiểm tra");

        var feedback = pw.Page.Locator(".feedback");
        await feedback.WaitForAsync(new() { Timeout = 5000 });
        Assert.True(await feedback.IsVisibleAsync());
    }

    [Fact]
    public async Task Wrong_Answer_Shows_Correct_Romaji()
    {
        await using var pw = await PlaywrightFixture.CreateAsync();
        await pw.Page.GotoAsync(_fixture.ServerUrl);

        await pw.Page.WaitForSelectorAsync(".romaji-input input");
        await pw.Page.FillAsync(".romaji-input input", "---wrong---");
        await pw.Page.ClickAsync("text=Kiểm tra");

        await pw.Page.WaitForSelectorAsync("text=Đáp án đúng:");
        Assert.True(await pw.Page.Locator("text=Đáp án đúng:").IsVisibleAsync());
    }

    [Fact]
    public async Task Next_Button_Appears_After_Answer()
    {
        await using var pw = await PlaywrightFixture.CreateAsync();
        await pw.Page.GotoAsync(_fixture.ServerUrl);

        await pw.Page.WaitForSelectorAsync(".romaji-input input");
        await pw.Page.FillAsync(".romaji-input input", "a");
        await pw.Page.ClickAsync("text=Kiểm tra");

        await pw.Page.WaitForSelectorAsync("text=Tiếp →", new() { Timeout = 5000 });
        Assert.True(await pw.Page.Locator("text=Tiếp →").IsVisibleAsync());
    }

    [Fact]
    public async Task Next_Button_Loads_Next_Character()
    {
        await using var pw = await PlaywrightFixture.CreateAsync();
        await pw.Page.GotoAsync(_fixture.ServerUrl);

        await pw.Page.WaitForSelectorAsync(".japanese-char");
        var firstChar = await pw.Page.TextContentAsync(".japanese-char");

        await pw.Page.WaitForSelectorAsync(".romaji-input input");
        await pw.Page.FillAsync(".romaji-input input", "---wrong---");
        await pw.Page.ClickAsync("text=Kiểm tra");
        await pw.Page.WaitForSelectorAsync("text=Tiếp →");
        await pw.Page.ClickAsync("text=Tiếp →");
        await Task.Delay(500);

        var secondChar = await pw.Page.TextContentAsync(".japanese-char");
        Assert.NotEqual(firstChar, secondChar);
    }

    [Fact]
    public async Task Title_Is_Displayed()
    {
        await using var pw = await PlaywrightFixture.CreateAsync();
        await pw.Page.GotoAsync(_fixture.ServerUrl);

        var title = await pw.Page.TitleAsync();
        Assert.Equal("Japanese Learner", title);
    }
}
