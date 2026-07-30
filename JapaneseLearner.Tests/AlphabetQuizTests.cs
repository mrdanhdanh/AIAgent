using System.Reflection;
using Bunit;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.FluentUI.AspNetCore.Components;
using JapaneseLearner.Models;
using JapaneseLearner.Services;
using JapaneseLearner.Tests.TestHelpers;
using Moq;

namespace JapaneseLearner.Tests;

public class AlphabetQuizTests : BunitTestBase
{
    private readonly Mock<ICharService> _mockService;
    private readonly List<JapaneseChar> _testChars;

    public AlphabetQuizTests()
    {
        _mockService = new Mock<ICharService>();
        _testChars = new List<JapaneseChar>
        {
            new() { Id = 1, Character = "あ", Romaji = "a", Type = "Hiragana" },
            new() { Id = 2, Character = "い", Romaji = "i", Type = "Hiragana" },
            new() { Id = 3, Character = "う", Romaji = "u", Type = "Hiragana" },
            new() { Id = 4, Character = "え", Romaji = "e", Type = "Hiragana" },
            new() { Id = 5, Character = "お", Romaji = "o", Type = "Hiragana" },
            new() { Id = 6, Character = "ア", Romaji = "a", Type = "Katakana" },
            new() { Id = 7, Character = "イ", Romaji = "i", Type = "Katakana" },
            new() { Id = 8, Character = "ウ", Romaji = "u", Type = "Katakana" },
        };

        _mockService.Setup(s => s.GetByTypeAsync("All")).ReturnsAsync(_testChars);
        _mockService.Setup(s => s.GetByTypeAsync("Hiragana")).ReturnsAsync(_testChars.Where(c => c.Type == "Hiragana").ToList());
        _mockService.Setup(s => s.GetByTypeAsync("Katakana")).ReturnsAsync(_testChars.Where(c => c.Type == "Katakana").ToList());
    }

    private static void SetField<T>(T instance, string name, object value)
    {
        typeof(T).GetField(name, BindingFlags.NonPublic | BindingFlags.Instance)!.SetValue(instance, value);
    }

    private static object? GetField<T>(T instance, string name)
    {
        return typeof(T).GetField(name, BindingFlags.NonPublic | BindingFlags.Instance)!.GetValue(instance);
    }

    private static Task RunAsync<T>(T instance, string methodName)
    {
        return (Task)typeof(T).GetMethod(methodName, BindingFlags.NonPublic | BindingFlags.Instance)!.Invoke(instance, null)!;
    }

    private static object? CallMethod<T>(T instance, string methodName, object[] args)
    {
        return typeof(T).GetMethod(methodName, BindingFlags.NonPublic | BindingFlags.Instance)!.Invoke(instance, args);
    }

    [Fact]
    public void Render_ShowsTitle()
    {
        Context.Services.AddScoped(_ => _mockService.Object);
        var cut = Context.Render<JapaneseLearner.Pages.AlphabetQuiz>();
        Assert.Contains("Trắc nghiệm bảng chữ cái", cut.Markup);
    }

    [Fact]
    public void Render_ShowsModeToggle()
    {
        Context.Services.AddScoped(_ => _mockService.Object);
        var cut = Context.Render<JapaneseLearner.Pages.AlphabetQuiz>();
        Assert.Contains("Kana → Romaji", cut.Markup);
        Assert.Contains("Romaji → Kana", cut.Markup);
    }

    [Fact]
    public void Render_DefaultModeIsKanaToRomaji()
    {
        Context.Services.AddScoped(_ => _mockService.Object);
        var cut = Context.Render<JapaneseLearner.Pages.AlphabetQuiz>();
        var isKanaToRomajiMode = (bool)GetField(cut.Instance, "isKanaToRomajiMode")!;
        Assert.True(isKanaToRomajiMode);
    }

    [Fact]
    public void Render_DisplaysChar_WhenDataExists_DefaultMode()
    {
        Context.Services.AddScoped(_ => _mockService.Object);
        var cut = Context.Render<JapaneseLearner.Pages.AlphabetQuiz>();
        var hasAnyChar = _testChars.Any(c => cut.Markup.Contains(c.Character));
        Assert.True(hasAnyChar, "Expected at least one test character to be rendered in default mode");
    }

    [Fact]
    public void Render_ShowsFourOptions()
    {
        Context.Services.AddScoped(_ => _mockService.Object);
        var cut = Context.Render<JapaneseLearner.Pages.AlphabetQuiz>();
        var optionBtns = cut.FindAll(".option-btn");
        Assert.Equal(4, optionBtns.Count);
    }

    [Fact]
    public void Options_IncludeCorrectAnswer_DefaultMode()
    {
        Context.Services.AddScoped(_ => _mockService.Object);
        var cut = Context.Render<JapaneseLearner.Pages.AlphabetQuiz>();
        var currentChar = (JapaneseChar?)GetField(cut.Instance, "currentChar");
        Assert.NotNull(currentChar);
        var optionTexts = cut.FindAll(".option-text").Select(e => e.TextContent).ToList();
        Assert.Contains(currentChar.Romaji, optionTexts);
    }

    [Fact]
    public void AllOptions_HaveDistinctValues()
    {
        Context.Services.AddScoped(_ => _mockService.Object);
        var cut = Context.Render<JapaneseLearner.Pages.AlphabetQuiz>();
        var optionTexts = cut.FindAll(".option-text").Select(e => e.TextContent).ToList();
        Assert.Equal(4, optionTexts.Distinct().Count());
    }

    private static object FindFirstOption<T>(T instance, bool isCorrect)
    {
        var optionsField = typeof(T).GetField("options", BindingFlags.NonPublic | BindingFlags.Instance)!;
        var options = (System.Collections.IList)optionsField.GetValue(instance)!;
        var optType = options.GetType().GetGenericArguments()[0];
        var isCorrectProp = optType.GetProperty("IsCorrect")!;
        var displayProp = optType.GetProperty("Display")!;

        foreach (var opt in options)
        {
            if ((bool)isCorrectProp.GetValue(opt)! == isCorrect)
                return opt;
        }
        throw new InvalidOperationException($"No {(isCorrect ? "correct" : "wrong")} option found");
    }

    [Fact]
    public async Task SelectCorrectAnswer_IncrementsCorrectCount()
    {
        Context.Services.AddScoped(_ => _mockService.Object);
        var cut = Context.Render<JapaneseLearner.Pages.AlphabetQuiz>();

        await cut.InvokeAsync(() =>
        {
            var correct = FindFirstOption(cut.Instance, true);
            typeof(JapaneseLearner.Pages.AlphabetQuiz)
                .GetMethod("SelectAnswer", BindingFlags.NonPublic | BindingFlags.Instance)!
                .Invoke(cut.Instance, new[] { correct });
        });

        var correctCount = (int)GetField(cut.Instance, "correctCount")!;
        Assert.Equal(1, correctCount);
    }

    [Fact]
    public async Task SelectWrongAnswer_IncrementsWrongCount()
    {
        Context.Services.AddScoped(_ => _mockService.Object);
        var cut = Context.Render<JapaneseLearner.Pages.AlphabetQuiz>();

        await cut.InvokeAsync(() =>
        {
            var wrong = FindFirstOption(cut.Instance, false);
            typeof(JapaneseLearner.Pages.AlphabetQuiz)
                .GetMethod("SelectAnswer", BindingFlags.NonPublic | BindingFlags.Instance)!
                .Invoke(cut.Instance, new[] { wrong });
        });

        var wrongCount = (int)GetField(cut.Instance, "wrongCount")!;
        Assert.Equal(1, wrongCount);
    }

    [Fact]
    public async Task SelectCorrectAnswer_ShowsCorrectFeedback()
    {
        Context.Services.AddScoped(_ => _mockService.Object);
        var cut = Context.Render<JapaneseLearner.Pages.AlphabetQuiz>();

        await cut.InvokeAsync(() =>
        {
            var correct = FindFirstOption(cut.Instance, true);
            typeof(JapaneseLearner.Pages.AlphabetQuiz)
                .GetMethod("SelectAnswer", BindingFlags.NonPublic | BindingFlags.Instance)!
                .Invoke(cut.Instance, new[] { correct });
        });
        cut.Render();
        Assert.Contains("Chính xác", cut.Markup);
    }

    [Fact]
    public async Task SelectWrongAnswer_ShowsCorrectAnswer()
    {
        Context.Services.AddScoped(_ => _mockService.Object);
        var cut = Context.Render<JapaneseLearner.Pages.AlphabetQuiz>();

        await cut.InvokeAsync(() =>
        {
            var wrong = FindFirstOption(cut.Instance, false);
            typeof(JapaneseLearner.Pages.AlphabetQuiz)
                .GetMethod("SelectAnswer", BindingFlags.NonPublic | BindingFlags.Instance)!
                .Invoke(cut.Instance, new[] { wrong });
        });
        cut.Render();
        Assert.Contains("Đáp án đúng", cut.Markup);
    }

    [Fact]
    public async Task AfterAnswer_OptionsAreDisabled()
    {
        Context.Services.AddScoped(_ => _mockService.Object);
        var cut = Context.Render<JapaneseLearner.Pages.AlphabetQuiz>();

        await cut.InvokeAsync(() =>
        {
            var correct = FindFirstOption(cut.Instance, true);
            typeof(JapaneseLearner.Pages.AlphabetQuiz)
                .GetMethod("SelectAnswer", BindingFlags.NonPublic | BindingFlags.Instance)!
                .Invoke(cut.Instance, new[] { correct });
        });
        cut.Render();
        var disabledBtns = cut.FindAll(".option-btn[disabled]");
        Assert.Equal(4, disabledBtns.Count);
    }

    [Fact]
    public async Task CorrectAnswer_HasOptCorrectClass()
    {
        Context.Services.AddScoped(_ => _mockService.Object);
        var cut = Context.Render<JapaneseLearner.Pages.AlphabetQuiz>();

        await cut.InvokeAsync(() =>
        {
            var correct = FindFirstOption(cut.Instance, true);
            typeof(JapaneseLearner.Pages.AlphabetQuiz)
                .GetMethod("SelectAnswer", BindingFlags.NonPublic | BindingFlags.Instance)!
                .Invoke(cut.Instance, new[] { correct });
        });
        cut.Render();
        var correctBtns = cut.FindAll(".opt-correct");
        Assert.Single(correctBtns);
    }

    [Fact]
    public void Render_ShowsFilterDropdown()
    {
        Context.Services.AddScoped(_ => _mockService.Object);
        var cut = Context.Render<JapaneseLearner.Pages.AlphabetQuiz>();
        Assert.Contains("Tất cả", cut.Markup);
        Assert.Contains("Hiragana", cut.Markup);
        Assert.Contains("Katakana", cut.Markup);
    }

    [Fact]
    public void EmptyState_ShowsMessage_WhenNoData()
    {
        var emptyMock = new Mock<ICharService>();
        emptyMock.Setup(s => s.GetByTypeAsync("All")).ReturnsAsync(new List<JapaneseChar>());

        var ctx = new BunitContext();
        ctx.Services.AddFluentUIComponents();
        ctx.Services.AddScoped(_ => emptyMock.Object);

        var js = ctx.JSInterop;
        var ver = "?v=4.14.3.26174";
        js.SetupModule("./_content/Microsoft.FluentUI.AspNetCore.Components/Components/List/ListComponentBase.razor.js" + ver);
        var labelModule = js.SetupModule("./_content/Microsoft.FluentUI.AspNetCore.Components/Components/Label/FluentInputLabel.razor.js" + ver);
        labelModule.SetupVoid("setInputAriaLabel", _ => true);
        js.SetupModule("./_content/Microsoft.FluentUI.AspNetCore.Components/Components/Dialog/FluentDialog.razor.js" + ver);
        js.SetupModule("./_content/Microsoft.FluentUI.AspNetCore.Components/Components/Select/FluentSelect.razor.js" + ver);
        js.SetupModule("./_content/Microsoft.FluentUI.AspNetCore.Components/Components/TextField/FluentTextField.razor.js" + ver);
        js.SetupModule("./_content/Microsoft.FluentUI.AspNetCore.Components/Components/ProgressRing/FluentProgressRing.razor.js" + ver);
        js.SetupModule("./_content/Microsoft.FluentUI.AspNetCore.Components/Components/Button/FluentButton.razor.js" + ver);
        js.SetupModule("./_content/Microsoft.FluentUI.AspNetCore.Components/Components/NavMenu/FluentNavMenu.razor.js" + ver);
        js.SetupModule("./_content/Microsoft.FluentUI.AspNetCore.Components/Components/DesignTheme/FluentDesignTheme.razor.js" + ver);

        var cut = ctx.Render<JapaneseLearner.Pages.AlphabetQuiz>();
        Assert.Contains("Chưa có dữ liệu", cut.Markup);
    }

    [Fact]
    public void Stats_InitiallyZero()
    {
        Context.Services.AddScoped(_ => _mockService.Object);
        var cut = Context.Render<JapaneseLearner.Pages.AlphabetQuiz>();
        Assert.Contains("0", cut.FindAll(".stat-num")[0].TextContent);
        Assert.Contains("0", cut.FindAll(".stat-num")[1].TextContent);
    }

    [Fact]
    public async Task SwitchMode_ResetsAndShowsRomajiDisplay()
    {
        Context.Services.AddScoped(_ => _mockService.Object);
        var cut = Context.Render<JapaneseLearner.Pages.AlphabetQuiz>();

        // Switch to Romaji → Kana mode
        var romajiModeBtn = cut.FindAll(".mode-btn").First(b => b.TextContent.Contains("Romaji → Kana"));
        romajiModeBtn.Click();
        cut.Render();

        var isKanaToRomajiMode = (bool)GetField(cut.Instance, "isKanaToRomajiMode")!;
        Assert.False(isKanaToRomajiMode);

        // Current char's Romaji should be displayed
        var currentChar = (JapaneseChar?)GetField(cut.Instance, "currentChar");
        Assert.NotNull(currentChar);
        Assert.Contains(currentChar.Romaji, cut.Markup);
    }

    [Fact]
    public async Task RomajiToKanaMode_OptionsContainKanaCharacters()
    {
        Context.Services.AddScoped(_ => _mockService.Object);
        var cut = Context.Render<JapaneseLearner.Pages.AlphabetQuiz>();

        // Switch to Romaji → Kana mode
        var romajiModeBtn = cut.FindAll(".mode-btn").First(b => b.TextContent.Contains("Romaji → Kana"));
        romajiModeBtn.Click();
        cut.Render();

        var currentChar = (JapaneseChar?)GetField(cut.Instance, "currentChar");
        Assert.NotNull(currentChar);

        var optionTexts = cut.FindAll(".option-text").Select(e => e.TextContent).ToList();
        Assert.Contains(currentChar.Character, optionTexts);
    }

    [Fact]
    public async Task RomajiToKanaMode_CorrectAnswerShowsCharInFeedback()
    {
        Context.Services.AddScoped(_ => _mockService.Object);
        var cut = Context.Render<JapaneseLearner.Pages.AlphabetQuiz>();

        // Switch to Romaji → Kana mode
        var romajiModeBtn = cut.FindAll(".mode-btn").First(b => b.TextContent.Contains("Romaji → Kana"));
        romajiModeBtn.Click();
        cut.Render();

        await cut.InvokeAsync(() =>
        {
            var correct = FindFirstOption(cut.Instance, true);
            typeof(JapaneseLearner.Pages.AlphabetQuiz)
                .GetMethod("SelectAnswer", BindingFlags.NonPublic | BindingFlags.Instance)!
                .Invoke(cut.Instance, new[] { correct });
        });
        cut.Render();

        var currentChar = (JapaneseChar?)GetField(cut.Instance, "currentChar");
        Assert.NotNull(currentChar);
        Assert.Contains(currentChar.Character, cut.Markup);
    }

    [Fact]
    public async Task FilterByType_ChangesAvailableChars()
    {
        var mock = new Mock<ICharService>();
        var allChars = new List<JapaneseChar>
        {
            new() { Id = 1, Character = "あ", Romaji = "a", Type = "Hiragana" },
            new() { Id = 6, Character = "ア", Romaji = "a", Type = "Katakana" },
        };
        mock.Setup(s => s.GetByTypeAsync("All")).ReturnsAsync(allChars);
        mock.Setup(s => s.GetByTypeAsync("Hiragana")).ReturnsAsync(allChars.Where(c => c.Type == "Hiragana").ToList());

        Context.Services.AddScoped(_ => mock.Object);
        var cut = Context.Render<JapaneseLearner.Pages.AlphabetQuiz>();

        // Switch to Hiragana filter
        await cut.InvokeAsync(() =>
        {
            SetField(cut.Instance, "selectedType", "Hiragana");
            CallMethod(cut.Instance, "OnTypeChanged", Array.Empty<object>());
        });
        cut.Render();

        // Should only show Hiragana chars
        var availableChars = (List<JapaneseChar>)GetField(cut.Instance, "availableChars")!;
        Assert.All(availableChars, c => Assert.Equal("Hiragana", c.Type));
    }
}
