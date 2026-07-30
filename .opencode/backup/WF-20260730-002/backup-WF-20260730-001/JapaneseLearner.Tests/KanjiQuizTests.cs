using System.Reflection;
using Bunit;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.FluentUI.AspNetCore.Components;
using JapaneseLearner.Models;
using JapaneseLearner.Services;
using JapaneseLearner.Tests.TestHelpers;
using Moq;

namespace JapaneseLearner.Tests;

public class KanjiQuizTests : BunitTestBase
{
    private readonly Mock<IKanjiService> _mockService;
    private readonly List<JapaneseKanji> _testKanji;

    public KanjiQuizTests()
    {
        _mockService = new Mock<IKanjiService>();
        _testKanji = new List<JapaneseKanji>
        {
            new() { Id = 1, Kanji = "一", OnYomi = "イチ・イツ", KunYomi = "ひと・ひと.つ", Meaning = "một", StrokeCount = 1, JLPTLevel = "N5" },
            new() { Id = 2, Kanji = "二", OnYomi = "ニ", KunYomi = "ふた・ふた.つ", Meaning = "hai", StrokeCount = 2, JLPTLevel = "N5" },
            new() { Id = 3, Kanji = "三", OnYomi = "サン", KunYomi = "み・み.つ", Meaning = "ba", StrokeCount = 3, JLPTLevel = "N5" },
            new() { Id = 4, Kanji = "四", OnYomi = "シ", KunYomi = "よ・よ.つ・よっ.つ", Meaning = "bốn", StrokeCount = 5, JLPTLevel = "N5" },
            new() { Id = 5, Kanji = "五", OnYomi = "ゴ", KunYomi = "いつ・いつ.つ", Meaning = "năm", StrokeCount = 4, JLPTLevel = "N5" },
            new() { Id = 6, Kanji = "六", OnYomi = "ロク", KunYomi = "む・む.つ", Meaning = "sáu", StrokeCount = 4, JLPTLevel = "N5" },
            new() { Id = 7, Kanji = "大", OnYomi = "ダイ・タイ", KunYomi = "おお.きい", Meaning = "lớn", StrokeCount = 3, JLPTLevel = "N5" },
            new() { Id = 8, Kanji = "小", OnYomi = "ショウ", KunYomi = "ちい.さい・こ", Meaning = "nhỏ", StrokeCount = 3, JLPTLevel = "N5" },
        };

        _mockService.Setup(s => s.GetByLevelAsync("All")).ReturnsAsync(_testKanji);
        _mockService.Setup(s => s.GetByLevelAsync("N5")).ReturnsAsync(_testKanji.Where(k => k.JLPTLevel == "N5").ToList());
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
        var cut = Context.Render<JapaneseLearner.Pages.KanjiQuiz>();
        Assert.Contains("Trắc nghiệm Kanji", cut.Markup);
    }

    [Fact]
    public void Render_DisplaysKanji_WhenDataExists()
    {
        Context.Services.AddScoped(_ => _mockService.Object);
        var cut = Context.Render<JapaneseLearner.Pages.KanjiQuiz>();
        var hasAnyKanji = _testKanji.Any(k => cut.Markup.Contains(k.Kanji));
        Assert.True(hasAnyKanji, "Expected at least one test kanji to be rendered");
    }

    [Fact]
    public void Render_ShowsFourOptions()
    {
        Context.Services.AddScoped(_ => _mockService.Object);
        var cut = Context.Render<JapaneseLearner.Pages.KanjiQuiz>();
        var optionBtns = cut.FindAll(".option-btn");
        Assert.Equal(4, optionBtns.Count);
    }

    [Fact]
    public void Options_IncludeCorrectAnswer()
    {
        Context.Services.AddScoped(_ => _mockService.Object);
        var cut = Context.Render<JapaneseLearner.Pages.KanjiQuiz>();
        var currentKanji = (JapaneseKanji?)GetField(cut.Instance, "currentKanji");
        Assert.NotNull(currentKanji);
        var optionTexts = cut.FindAll(".option-text").Select(e => e.TextContent).ToList();
        Assert.Contains(currentKanji.Meaning, optionTexts);
    }

    [Fact]
    public void AllOptions_HaveDistinctMeanings()
    {
        Context.Services.AddScoped(_ => _mockService.Object);
        var cut = Context.Render<JapaneseLearner.Pages.KanjiQuiz>();
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
        var cut = Context.Render<JapaneseLearner.Pages.KanjiQuiz>();

        await cut.InvokeAsync(() =>
        {
            var correct = FindFirstOption(cut.Instance, true);
            typeof(JapaneseLearner.Pages.KanjiQuiz)
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
        var cut = Context.Render<JapaneseLearner.Pages.KanjiQuiz>();

        await cut.InvokeAsync(() =>
        {
            var wrong = FindFirstOption(cut.Instance, false);
            typeof(JapaneseLearner.Pages.KanjiQuiz)
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
        var cut = Context.Render<JapaneseLearner.Pages.KanjiQuiz>();

        await cut.InvokeAsync(() =>
        {
            var correct = FindFirstOption(cut.Instance, true);
            typeof(JapaneseLearner.Pages.KanjiQuiz)
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
        var cut = Context.Render<JapaneseLearner.Pages.KanjiQuiz>();

        await cut.InvokeAsync(() =>
        {
            var wrong = FindFirstOption(cut.Instance, false);
            typeof(JapaneseLearner.Pages.KanjiQuiz)
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
        var cut = Context.Render<JapaneseLearner.Pages.KanjiQuiz>();

        await cut.InvokeAsync(() =>
        {
            var correct = FindFirstOption(cut.Instance, true);
            typeof(JapaneseLearner.Pages.KanjiQuiz)
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
        var cut = Context.Render<JapaneseLearner.Pages.KanjiQuiz>();

        await cut.InvokeAsync(() =>
        {
            var correct = FindFirstOption(cut.Instance, true);
            typeof(JapaneseLearner.Pages.KanjiQuiz)
                .GetMethod("SelectAnswer", BindingFlags.NonPublic | BindingFlags.Instance)!
                .Invoke(cut.Instance, new[] { correct });
        });
        cut.Render();
        var correctBtns = cut.FindAll(".opt-correct");
        Assert.Single(correctBtns);
    }

    [Fact]
    public void SwitchLevel_CallsServiceWithCorrectLevel()
    {
        Context.Services.AddScoped(_ => _mockService.Object);
        var cut = Context.Render<JapaneseLearner.Pages.KanjiQuiz>();
        var n5Btn = cut.FindAll("button.filter-btn").First(b => b.TextContent.Contains("N5"));
        n5Btn.Click();
        _mockService.Verify(s => s.GetByLevelAsync("N5"), Times.AtLeastOnce);
    }

    [Fact]
    public void EmptyState_ShowsMessage_WhenNoData()
    {
        var emptyMock = new Mock<IKanjiService>();
        emptyMock.Setup(s => s.GetByLevelAsync("All")).ReturnsAsync(new List<JapaneseKanji>());

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

        var cut = ctx.Render<JapaneseLearner.Pages.KanjiQuiz>();
        Assert.Contains("Chưa có dữ liệu", cut.Markup);
    }

    [Fact]
    public void Stats_InitiallyZero()
    {
        Context.Services.AddScoped(_ => _mockService.Object);
        var cut = Context.Render<JapaneseLearner.Pages.KanjiQuiz>();
        Assert.Contains("0", cut.FindAll(".stat-num")[0].TextContent);
        Assert.Contains("0", cut.FindAll(".stat-num")[1].TextContent);
    }
}
