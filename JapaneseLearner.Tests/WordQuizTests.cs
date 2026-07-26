using System.Reflection;
using Bunit;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.FluentUI.AspNetCore.Components;
using JapaneseLearner.Models;
using JapaneseLearner.Services;
using JapaneseLearner.Tests.TestHelpers;
using Moq;

namespace JapaneseLearner.Tests;

public class WordQuizTests : BunitTestBase
{
    private readonly Mock<IWordService> _mockService;
    private readonly List<JapaneseWord> _testWords;

    public WordQuizTests()
    {
        _mockService = new Mock<IWordService>();
        _testWords = new List<JapaneseWord>
        {
            new() { Id = 1, Characters = "あさ", Romaji = "asa", Meaning = "sáng", Type = "Seion" },
            new() { Id = 2, Characters = "いぬ", Romaji = "inu", Meaning = "chó", Type = "Seion" },
            new() { Id = 3, Characters = "うみ", Romaji = "umi", Meaning = "biển", Type = "Seion" },
            new() { Id = 4, Characters = "えき", Romaji = "eki", Meaning = "ga tàu", Type = "Seion" },
            new() { Id = 5, Characters = "ねこ", Romaji = "neko", Meaning = "mèo", Type = "Seion" },
            new() { Id = 6, Characters = "はな", Romaji = "hana", Meaning = "hoa", Type = "Seion" },
            new() { Id = 7, Characters = "せんせい", Romaji = "sensei", Meaning = "giáo viên", Type = "Choon" },
            new() { Id = 8, Characters = "がっこう", Romaji = "gakkou", Meaning = "trường học", Type = "Sokuon" },
        };

        _mockService.Setup(s => s.GetByTypeAsync("All")).ReturnsAsync(_testWords);
        _mockService.Setup(s => s.GetByTypeAsync("Seion")).ReturnsAsync(_testWords.Where(w => w.Type == "Seion").ToList());
        _mockService.Setup(s => s.GetByTypeAsync("Sokuon")).ReturnsAsync(_testWords.Where(w => w.Type == "Sokuon").ToList());
        _mockService.Setup(s => s.GetByTypeAsync("Choon")).ReturnsAsync(_testWords.Where(w => w.Type == "Choon").ToList());
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

    [Fact]
    public void Render_ShowsTitle()
    {
        Context.Services.AddScoped(_ => _mockService.Object);
        var cut = Context.Render<JapaneseLearner.Pages.WordQuiz>();
        Assert.Contains("Trắc nghiệm từ vựng", cut.Markup);
    }

    [Fact]
    public void Render_DisplaysWord_WhenDataExists()
    {
        Context.Services.AddScoped(_ => _mockService.Object);
        var cut = Context.Render<JapaneseLearner.Pages.WordQuiz>();
        var hasAnyWord = _testWords.Any(w => cut.Markup.Contains(w.Characters));
        Assert.True(hasAnyWord, "Expected at least one test word to be rendered");
    }

    [Fact]
    public void Render_ShowsFourOptions()
    {
        Context.Services.AddScoped(_ => _mockService.Object);
        var cut = Context.Render<JapaneseLearner.Pages.WordQuiz>();
        var optionBtns = cut.FindAll(".option-btn");
        Assert.Equal(4, optionBtns.Count);
    }

    [Fact]
    public void Options_IncludeCorrectAnswer()
    {
        Context.Services.AddScoped(_ => _mockService.Object);
        var cut = Context.Render<JapaneseLearner.Pages.WordQuiz>();
        var currentWord = (JapaneseLearner.Models.JapaneseWord?)GetField(cut.Instance, "currentWord");
        Assert.NotNull(currentWord);
        var optionTexts = cut.FindAll(".option-text").Select(e => e.TextContent).ToList();
        Assert.Contains(currentWord.Meaning, optionTexts);
    }

    [Fact]
    public void AllOptions_HaveDistinctMeanings()
    {
        Context.Services.AddScoped(_ => _mockService.Object);
        var cut = Context.Render<JapaneseLearner.Pages.WordQuiz>();
        var optionTexts = cut.FindAll(".option-text").Select(e => e.TextContent).ToList();
        Assert.Equal(4, optionTexts.Distinct().Count());
    }

    private static object FindFirstOption<T>(T instance, bool isCorrect)
    {
        var optionsField = typeof(T).GetField("options", BindingFlags.NonPublic | BindingFlags.Instance)!;
        var options = (System.Collections.IList)optionsField.GetValue(instance)!;
        var optType = options.GetType().GetGenericArguments()[0];
        var isCorrectProp = optType.GetProperty("IsCorrect")!;
        var meaningProp = optType.GetProperty("Meaning")!;

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
        var cut = Context.Render<JapaneseLearner.Pages.WordQuiz>();

        await cut.InvokeAsync(() =>
        {
            var correct = FindFirstOption(cut.Instance, true);
            typeof(JapaneseLearner.Pages.WordQuiz)
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
        var cut = Context.Render<JapaneseLearner.Pages.WordQuiz>();

        await cut.InvokeAsync(() =>
        {
            var wrong = FindFirstOption(cut.Instance, false);
            typeof(JapaneseLearner.Pages.WordQuiz)
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
        var cut = Context.Render<JapaneseLearner.Pages.WordQuiz>();

        await cut.InvokeAsync(() =>
        {
            var correct = FindFirstOption(cut.Instance, true);
            typeof(JapaneseLearner.Pages.WordQuiz)
                .GetMethod("SelectAnswer", BindingFlags.NonPublic | BindingFlags.Instance)!
                .Invoke(cut.Instance, new[] { correct });
        });
        cut.Render();
        Assert.Contains("Chính xác", cut.Markup);
    }

    [Fact]
    public async Task SelectWrongAnswer_ShowsCorrectMeaning()
    {
        Context.Services.AddScoped(_ => _mockService.Object);
        var cut = Context.Render<JapaneseLearner.Pages.WordQuiz>();

        await cut.InvokeAsync(() =>
        {
            var wrong = FindFirstOption(cut.Instance, false);
            typeof(JapaneseLearner.Pages.WordQuiz)
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
        var cut = Context.Render<JapaneseLearner.Pages.WordQuiz>();

        await cut.InvokeAsync(() =>
        {
            var correct = FindFirstOption(cut.Instance, true);
            typeof(JapaneseLearner.Pages.WordQuiz)
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
        var cut = Context.Render<JapaneseLearner.Pages.WordQuiz>();

        await cut.InvokeAsync(() =>
        {
            var correct = FindFirstOption(cut.Instance, true);
            typeof(JapaneseLearner.Pages.WordQuiz)
                .GetMethod("SelectAnswer", BindingFlags.NonPublic | BindingFlags.Instance)!
                .Invoke(cut.Instance, new[] { correct });
        });
        cut.Render();
        var correctBtns = cut.FindAll(".opt-correct");
        Assert.Single(correctBtns);
    }

    [Fact]
    public void SwitchTab_CallsServiceWithCorrectType()
    {
        Context.Services.AddScoped(_ => _mockService.Object);
        var cut = Context.Render<JapaneseLearner.Pages.WordQuiz>();
        var seionBtn = cut.FindAll("button.tab-btn").First(b => b.TextContent.Contains("清音"));
        seionBtn.Click();
        _mockService.Verify(s => s.GetByTypeAsync("Seion"), Times.AtLeastOnce);
    }

    [Fact]
    public void EmptyState_ShowsMessage_WhenNoData()
    {
        var emptyMock = new Mock<IWordService>();
        emptyMock.Setup(s => s.GetByTypeAsync("All")).ReturnsAsync(new List<JapaneseWord>());

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

        var cut = ctx.Render<JapaneseLearner.Pages.WordQuiz>();
        Assert.Contains("Chưa có dữ liệu", cut.Markup);
    }

    [Fact]
    public void Stats_InitiallyZero()
    {
        Context.Services.AddScoped(_ => _mockService.Object);
        var cut = Context.Render<JapaneseLearner.Pages.WordQuiz>();
        Assert.Contains("0", cut.FindAll(".stat-num")[0].TextContent);
        Assert.Contains("0", cut.FindAll(".stat-num")[1].TextContent);
    }
}
