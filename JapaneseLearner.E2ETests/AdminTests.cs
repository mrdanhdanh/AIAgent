namespace JapaneseLearner.E2ETests;

public class AdminTests : E2ETestBase
{
    public AdminTests(AppFixture fixture) : base(fixture) { }

    [Fact]
    public async Task Page_Loads_With_Title()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/admin", "h2");
        await Task.Delay(1000);

        var title = await pw.Page.TitleAsync();
        Assert.Contains("Quản lý", title);
    }

    [Fact]
    public async Task Char_Table_Is_Visible()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/admin", ".table-wrap");
        Assert.True(await pw.Page.Locator(".table-wrap").IsVisibleAsync());
    }

    [Fact]
    public async Task Can_Switch_To_Words_Tab()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/admin", ".admin-tab-btn");

        await pw.Page.Locator(".admin-tab-btn:has-text('Từ vựng')").ClickAsync();
        await pw.Page.WaitForSelectorAsync("h2:has-text('Quản lý từ vựng')", new() { Timeout = 10000 });
        Assert.True(await pw.Page.Locator("h2:has-text('Quản lý từ vựng')").IsVisibleAsync());
    }

    [Fact]
    public async Task Add_Char_Button_Is_Visible()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/admin", ".admin-tab-btn");
        Assert.True(await pw.Page.Locator("text=Thêm chữ").IsVisibleAsync());
    }

    [Fact]
    public async Task Char_Table_Has_Rows()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/admin", ".table-char");
        var count = await pw.Page.Locator(".table-char").CountAsync();
        Assert.True(count >= 1);
    }

    [Fact]
    public async Task Four_Tabs_Are_Displayed()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/admin", ".admin-tab-btn");
        var tabs = pw.Page.Locator(".admin-tab-btn");
        Assert.Equal(4, await tabs.CountAsync());
    }
}
