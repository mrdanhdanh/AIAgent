namespace JapaneseLearner.E2ETests;

public class AdminTests : IClassFixture<AppFixture>
{
    private readonly AppFixture _fixture;
    public AdminTests(AppFixture fixture) => _fixture = fixture;

    [Fact]
    public async Task Page_Loads_With_Title()
    {
        await using var pw = await PlaywrightFixture.CreateAsync();
        await pw.Page.GotoAsync($"{_fixture.ServerUrl}/admin");
        await pw.Page.WaitForSelectorAsync("h2");

        var title = await pw.Page.TitleAsync();
        Assert.Contains("Quản lý", title);
    }

    [Fact]
    public async Task Char_Table_Is_Visible()
    {
        await using var pw = await PlaywrightFixture.CreateAsync();
        await pw.Page.GotoAsync($"{_fixture.ServerUrl}/admin");

        await pw.Page.WaitForSelectorAsync(".table-wrap");
        Assert.True(await pw.Page.Locator(".table-wrap").IsVisibleAsync());
    }

    [Fact]
    public async Task Can_Switch_To_Words_Tab()
    {
        await using var pw = await PlaywrightFixture.CreateAsync();
        await pw.Page.GotoAsync($"{_fixture.ServerUrl}/admin");

        await pw.Page.WaitForSelectorAsync("button:has-text('Từ vựng')");
        await pw.Page.ClickAsync("button:has-text('Từ vựng')");
        await pw.Page.WaitForSelectorAsync("h2:has-text('Quản lý từ vựng')");

        var header = pw.Page.Locator("h2:has-text('Quản lý từ vựng')");
        Assert.True(await header.IsVisibleAsync());
    }

    [Fact]
    public async Task Add_Char_Button_Is_Visible()
    {
        await using var pw = await PlaywrightFixture.CreateAsync();
        await pw.Page.GotoAsync($"{_fixture.ServerUrl}/admin");

        await pw.Page.WaitForSelectorAsync("text=Thêm chữ");
        Assert.True(await pw.Page.Locator("text=Thêm chữ").IsVisibleAsync());
    }

    [Fact]
    public async Task Char_Table_Has_Rows()
    {
        await using var pw = await PlaywrightFixture.CreateAsync();
        await pw.Page.GotoAsync($"{_fixture.ServerUrl}/admin");

        await pw.Page.WaitForSelectorAsync(".table-char");
        var count = await pw.Page.Locator(".table-char").CountAsync();
        Assert.True(count >= 1);
    }

    [Fact]
    public async Task Two_Tabs_Are_Displayed()
    {
        await using var pw = await PlaywrightFixture.CreateAsync();
        await pw.Page.GotoAsync($"{_fixture.ServerUrl}/admin");

        await pw.Page.WaitForSelectorAsync(".tab-btn");
        var tabs = pw.Page.Locator(".tab-btn");
        Assert.Equal(2, await tabs.CountAsync());
    }
}
