using Microsoft.Playwright;

namespace JapaneseLearner.E2ETests;

[Collection("E2E")]
public class AlphabetStudyTests
{
    private readonly AppFixture _fixture;
    public AlphabetStudyTests(AppFixture fixture) => _fixture = fixture;

    /// <summary>
    /// Helper: set value on the fluent-text-field Web Component and trigger Enter keydown.
    /// Sets value at the Web Component level (not the inner input) so Blazor's
    /// @bind-Value picks it up, then dispatches keydown on the component for @onkeydown.
    /// </summary>
    private static async Task SetValueAndPressEnterAsync(IPage page, string text)
    {
        var field = page.Locator(".romaji-input");
        // Set value via JavaScript on the web component and dispatch change event
        await field.EvaluateAsync($$"""
            (el) => {
                el.value = '{{text.Replace("'", "\\'")}}';
                el.dispatchEvent(new Event('change', { bubbles: true }));
            }
            """);
        await Task.Delay(200);
        // Dispatch Enter keydown on the web component for Blazor @onkeydown handler
        await field.EvaluateAsync("""
            (el) => {
                el.dispatchEvent(new KeyboardEvent('keydown', {
                    key: 'Enter', code: 'Enter', keyCode: 13, which: 13,
                    bubbles: true, cancelable: true, composed: true
                }));
            }
            """);
        await Task.Delay(300);
    }

    [Fact]
    public async Task Page_Loads_And_Shows_Character()
    {
        await using var pw = await PlaywrightFixture.CreateAsync();
        await pw.Page.GotoAsync($"{_fixture.ServerUrl}/alphabet");

        await pw.Page.WaitForSelectorAsync(".japanese-char-display");
        var charText = await pw.Page.TextContentAsync(".japanese-char-display");
        Assert.False(string.IsNullOrWhiteSpace(charText));
    }

    [Fact]
    public async Task Page_Title_Is_Correct()
    {
        await using var pw = await PlaywrightFixture.CreateAsync();
        await pw.Page.GotoAsync($"{_fixture.ServerUrl}/alphabet");

        await pw.Page.WaitForSelectorAsync(".japanese-char-display", new() { Timeout = 15000 });
        await Task.Delay(1000);

        var title = await pw.Page.TitleAsync();
        Assert.Equal("Bảng chữ cái — Japanese Learner", title);
    }

    [Fact]
    public async Task Input_Field_Is_Visible()
    {
        await using var pw = await PlaywrightFixture.CreateAsync();
        await pw.Page.GotoAsync($"{_fixture.ServerUrl}/alphabet");

        await pw.Page.WaitForSelectorAsync(".romaji-input");
        Assert.True(await pw.Page.Locator(".romaji-input").IsVisibleAsync());
    }

    [Fact]
    public async Task Typing_Answer_And_Checking_Shows_Feedback()
    {
        await using var pw = await PlaywrightFixture.CreateAsync();
        await pw.Page.GotoAsync($"{_fixture.ServerUrl}/alphabet");

        await pw.Page.WaitForSelectorAsync(".japanese-char-display");
        await SetValueAndPressEnterAsync(pw.Page, "a");

        var feedback = pw.Page.Locator(".feedback");
        await feedback.WaitForAsync(new() { Timeout = 5000 });
        Assert.True(await feedback.IsVisibleAsync());
    }

    [Fact]
    public async Task Wrong_Answer_Shows_Correct_Romaji()
    {
        await using var pw = await PlaywrightFixture.CreateAsync();
        await pw.Page.GotoAsync($"{_fixture.ServerUrl}/alphabet");

        await pw.Page.WaitForSelectorAsync(".japanese-char-display");
        await SetValueAndPressEnterAsync(pw.Page, "---wrong---");

        await pw.Page.WaitForSelectorAsync("text=Đáp án đúng:", new() { Timeout = 5000 });
        Assert.True(await pw.Page.Locator("text=Đáp án đúng:").IsVisibleAsync());
    }

    [Fact]
    public async Task Next_Button_Appears_After_Wrong_Answer()
    {
        await using var pw = await PlaywrightFixture.CreateAsync();
        await pw.Page.GotoAsync($"{_fixture.ServerUrl}/alphabet");

        await pw.Page.WaitForSelectorAsync(".japanese-char-display");
        await SetValueAndPressEnterAsync(pw.Page, "---wrong---");

        await pw.Page.WaitForSelectorAsync("text=Tiếp →", new() { Timeout = 5000 });
        Assert.True(await pw.Page.Locator("text=Tiếp →").IsVisibleAsync());
    }

    [Fact]
    public async Task Next_Button_Loads_Next_Character()
    {
        await using var pw = await PlaywrightFixture.CreateAsync();
        await pw.Page.GotoAsync($"{_fixture.ServerUrl}/alphabet");

        await pw.Page.WaitForSelectorAsync(".japanese-char-display");
        var firstChar = await pw.Page.TextContentAsync(".japanese-char-display");

        await SetValueAndPressEnterAsync(pw.Page, "---wrong---");
        await pw.Page.WaitForSelectorAsync("text=Tiếp →");
        await pw.Page.Locator("text=Tiếp →").ClickAsync();
        await Task.Delay(500);

        var secondChar = await pw.Page.TextContentAsync(".japanese-char-display");
        Assert.NotEqual(firstChar, secondChar);
    }

    [Fact]
    public async Task Stats_Are_Displayed()
    {
        await using var pw = await PlaywrightFixture.CreateAsync();
        await pw.Page.GotoAsync($"{_fixture.ServerUrl}/alphabet");

        await pw.Page.WaitForSelectorAsync(".stat-box");
        var stats = pw.Page.Locator(".stat-box");
        Assert.Equal(2, await stats.CountAsync());
    }

    [Fact]
    public async Task Filter_Row_Is_Visible()
    {
        await using var pw = await PlaywrightFixture.CreateAsync();
        await pw.Page.GotoAsync($"{_fixture.ServerUrl}/alphabet");

        await pw.Page.WaitForSelectorAsync(".filter-row");
        Assert.True(await pw.Page.Locator(".filter-row").IsVisibleAsync());
    }

    [Fact]
    public async Task Heading_And_Subtitle_Are_Displayed()
    {
        await using var pw = await PlaywrightFixture.CreateAsync();
        await pw.Page.GotoAsync($"{_fixture.ServerUrl}/alphabet");

        await pw.Page.WaitForSelectorAsync(".study-header-title h1");
        var heading = await pw.Page.TextContentAsync(".study-header-title h1");
        Assert.Equal("Bảng chữ cái", heading);

        await pw.Page.WaitForSelectorAsync(".study-header-sub");
        Assert.True(await pw.Page.Locator(".study-header-sub").IsVisibleAsync());
    }

    [Fact]
    public async Task Romaji_Hint_Indicators_Are_Displayed()
    {
        await using var pw = await PlaywrightFixture.CreateAsync();
        await pw.Page.GotoAsync($"{_fixture.ServerUrl}/alphabet");

        await pw.Page.WaitForSelectorAsync(".hint-dot");
        var dots = pw.Page.Locator(".hint-dot");
        Assert.Equal(2, await dots.CountAsync());
    }
}
