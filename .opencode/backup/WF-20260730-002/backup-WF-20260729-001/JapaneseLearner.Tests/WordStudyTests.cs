using System.Reflection;
using Bunit;
using Microsoft.Extensions.DependencyInjection;
using MudBlazor.Services;
using JapaneseLearner.Models;
using JapaneseLearner.Services;
using JapaneseLearner.Tests.TestHelpers;
using Moq;

namespace JapaneseLearner.Tests;

public class WordStudyTests : BunitTestBase
{
    private readonly Mock<IWordService> _mockService;
    private readonly List<JapaneseWord> _testWords;

    public WordStudyTests()
    {
        _mockService = new Mock<IWordService>();
        _testWords = new List<JapaneseWord>
        {
            new() { Id = 1, Characters = "あさ", Romaji = "asa", Meaning = "sáng", Type = "Seion" },
        };

        _mockService.Setup(s => s.GetByTypeAsync("All")).ReturnsAsync(_testWords);
        _mockService.Setup(s => s.GetByTypeAsync("Seion")).ReturnsAsync(_testWords.Where(w => w.Type == "Seion").ToList());
        _mockService.Setup(s => s.GetByTypeAsync("Sokuon")).ReturnsAsync(_testWords.Where(w => w.Type == "Sokuon").ToList());
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
        var cut = Context.Render<JapaneseLearner.Pages.WordStudy>();
        Assert.Contains("Luyện từ vựng", cut.Markup);
    }

    [Fact]
    public void Render_DisplaysWord_WhenDataExists()
    {
        Context.Services.AddScoped(_ => _mockService.Object);
        var cut = Context.Render<JapaneseLearner.Pages.WordStudy>();
        var hasAnyWord = _testWords.Any(w => cut.Markup.Contains(w.Characters));
        Assert.True(hasAnyWord, "Expected at least one test word to be rendered");
    }

    [Fact]
    public async Task CheckAnswer_CorrectInput_ShowsCorrectFeedback()
    {
        Context.Services.AddScoped(_ => _mockService.Object);
        var cut = Context.Render<JapaneseLearner.Pages.WordStudy>();

        Task checkTask = null!;
        await cut.InvokeAsync(() =>
        {
            SetField(cut.Instance, "userInput", "asa");
            checkTask = RunAsync(cut.Instance, "CheckAnswer");
        });
        cut.Render();
        Assert.Contains("Chính xác", cut.Markup);
        await checkTask;
    }

    [Fact]
    public async Task CheckAnswer_WrongInput_ShowsCorrectRomaji()
    {
        Context.Services.AddScoped(_ => _mockService.Object);
        var cut = Context.Render<JapaneseLearner.Pages.WordStudy>();

        await cut.InvokeAsync(() =>
        {
            SetField(cut.Instance, "userInput", "xxx");
            RunAsync(cut.Instance, "CheckAnswer");
        });
        cut.Render();
        Assert.Contains("Đáp án đúng", cut.Markup);
    }

    [Fact]
    public async Task CheckAnswer_ShowsMeaning_OnCorrect()
    {
        Context.Services.AddScoped(_ => _mockService.Object);
        var cut = Context.Render<JapaneseLearner.Pages.WordStudy>();

        Task checkTask = null!;
        await cut.InvokeAsync(() =>
        {
            SetField(cut.Instance, "userInput", "asa");
            checkTask = RunAsync(cut.Instance, "CheckAnswer");
        });
        cut.Render();
        Assert.Contains("sáng", cut.Markup);
        await checkTask;
    }

    [Fact]
    public async Task CheckAnswer_IsCaseInsensitive()
    {
        Context.Services.AddScoped(_ => _mockService.Object);
        var cut = Context.Render<JapaneseLearner.Pages.WordStudy>();

        Task checkTask = null!;
        await cut.InvokeAsync(() =>
        {
            SetField(cut.Instance, "userInput", "ASA");
            checkTask = RunAsync(cut.Instance, "CheckAnswer");
        });
        await checkTask;
        var correctCount = (int)GetField(cut.Instance, "correctCount")!;
        Assert.Equal(1, correctCount);
    }

    [Fact]
    public async Task CheckAnswer_TrimsWhitespace()
    {
        Context.Services.AddScoped(_ => _mockService.Object);
        var cut = Context.Render<JapaneseLearner.Pages.WordStudy>();

        Task checkTask = null!;
        await cut.InvokeAsync(() =>
        {
            SetField(cut.Instance, "userInput", " asa ");
            checkTask = RunAsync(cut.Instance, "CheckAnswer");
        });
        await checkTask;
        var correctCount = (int)GetField(cut.Instance, "correctCount")!;
        Assert.Equal(1, correctCount);
    }

    [Fact]
    public async Task CorrectAnswer_IncrementsCorrectStat()
    {
        Context.Services.AddScoped(_ => _mockService.Object);
        var cut = Context.Render<JapaneseLearner.Pages.WordStudy>();

        Task checkTask = null!;
        await cut.InvokeAsync(() =>
        {
            SetField(cut.Instance, "userInput", "asa");
            checkTask = RunAsync(cut.Instance, "CheckAnswer");
        });
        await checkTask;
        var correctCount = (int)GetField(cut.Instance, "correctCount")!;
        Assert.Equal(1, correctCount);
    }

    [Fact]
    public async Task WrongAnswer_IncrementsWrongStat()
    {
        Context.Services.AddScoped(_ => _mockService.Object);
        var cut = Context.Render<JapaneseLearner.Pages.WordStudy>();

        await cut.InvokeAsync(() =>
        {
            SetField(cut.Instance, "userInput", "xxx");
            RunAsync(cut.Instance, "CheckAnswer");
        });
        var wrongCount = (int)GetField(cut.Instance, "wrongCount")!;
        Assert.Equal(1, wrongCount);
    }

    [Fact]
    public void SwitchTab_CallsServiceWithCorrectType()
    {
        Context.Services.AddScoped(_ => _mockService.Object);
        var cut = Context.Render<JapaneseLearner.Pages.WordStudy>();
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
        ctx.Services.AddMudServices();
        ctx.JSInterop.SetupVoid("mudElementRef.addOnBlurEvent", _ => true);
        ctx.JSInterop.SetupVoid("mudPopover.connect", _ => true);
        ctx.JSInterop.SetupVoid("mudPopover.disconnect", _ => true);
        ctx.JSInterop.SetupVoid("mudPopover.initialize", _ => true);
        ctx.Services.AddScoped(_ => emptyMock.Object);

        var cut = ctx.Render<JapaneseLearner.Pages.WordStudy>();
        Assert.Contains("Chưa có dữ liệu", cut.Markup);
    }

    [Fact]
    public async Task AfterCorrect_ShowsNextButton()
    {
        Context.Services.AddScoped(_ => _mockService.Object);
        var cut = Context.Render<JapaneseLearner.Pages.WordStudy>();

        Task checkTask = null!;
        await cut.InvokeAsync(() =>
        {
            SetField(cut.Instance, "userInput", "asa");
            checkTask = RunAsync(cut.Instance, "CheckAnswer");
        });
        cut.Render();
        var nextBtn = cut.FindAll("button.action-btn").FirstOrDefault(b => b.TextContent.Contains("Tiếp →"));
        Assert.NotNull(nextBtn);
        await checkTask;
    }

    [Fact]
    public void TypeBadge_DisplaysCorrectLabel()
    {
        Context.Services.AddScoped(_ => _mockService.Object);
        var cut = Context.Render<JapaneseLearner.Pages.WordStudy>();
        var labels = new[] { "Âm cơ bản", "Âm ngắt" };
        var hasAnyLabel = labels.Any(l => cut.Markup.Contains(l));
        Assert.True(hasAnyLabel, "Expected a type badge label to be displayed");
    }
}
