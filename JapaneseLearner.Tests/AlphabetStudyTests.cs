using System.Reflection;
using Bunit;
using Microsoft.Extensions.DependencyInjection;
using JapaneseLearner.Models;
using JapaneseLearner.Services;
using JapaneseLearner.Tests.TestHelpers;
using Moq;

namespace JapaneseLearner.Tests;

public class AlphabetStudyTests : BunitTestBase
{
    private static Mock<ICharService> CreateMockCharService(string romaji = "a")
    {
        var mock = new Mock<ICharService>();
        mock.Setup(s => s.GetByTypeAsync("All"))
            .ReturnsAsync(new List<JapaneseChar> { new() { Id = 1, Character = "あ", Romaji = romaji, Type = "Hiragana" } });
        return mock;
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
    public void Render_ShowsLoading()
    {
        var mockCharService = new Mock<ICharService>();
        mockCharService.Setup(s => s.GetByTypeAsync("All"))
            .ReturnsAsync(new List<JapaneseChar> { new() { Id = 1, Character = "あ", Romaji = "a", Type = "Hiragana" } });
        Context.Services.AddScoped(_ => mockCharService.Object);

        var cut = Context.Render<JapaneseLearner.Pages.AlphabetStudy>();

        Assert.Contains("Bảng chữ cái", cut.Markup);
    }

    [Fact]
    public void Render_ShowsEmptyState_WhenNoChars()
    {
        var mockCharService = new Mock<ICharService>();
        mockCharService.Setup(s => s.GetByTypeAsync("All"))
            .ReturnsAsync(new List<JapaneseChar>());
        Context.Services.AddScoped(_ => mockCharService.Object);

        var cut = Context.Render<JapaneseLearner.Pages.AlphabetStudy>();

        Assert.Contains("Chưa có dữ liệu", cut.Markup);
    }

    [Fact]
    public void Render_DisplaysChar_WhenDataExists()
    {
        var mockCharService = new Mock<ICharService>();
        mockCharService.Setup(s => s.GetByTypeAsync("All"))
            .ReturnsAsync(new List<JapaneseChar> { new() { Id = 1, Character = "あ", Romaji = "a", Type = "Hiragana" } });
        Context.Services.AddScoped(_ => mockCharService.Object);

        var cut = Context.Render<JapaneseLearner.Pages.AlphabetStudy>();

        Assert.Contains("あ", cut.Markup);
    }

    [Fact]
    public async Task CheckAnswer_CorrectInput_ShowsCorrectFeedback()
    {
        var mock = CreateMockCharService();
        Context.Services.AddScoped(_ => mock.Object);
        var cut = Context.Render<JapaneseLearner.Pages.AlphabetStudy>();

        Task checkTask = null!;
        await cut.InvokeAsync(() =>
        {
            SetField(cut.Instance, "userInput", "a");
            checkTask = RunAsync(cut.Instance, "CheckAnswer");
        });
        cut.Render();
        Assert.Contains("Chính xác", cut.Markup);
        await checkTask;
    }

    [Fact]
    public async Task CheckAnswer_WrongInput_ShowsWrongFeedback()
    {
        var mock = CreateMockCharService();
        Context.Services.AddScoped(_ => mock.Object);
        var cut = Context.Render<JapaneseLearner.Pages.AlphabetStudy>();

        await cut.InvokeAsync(() =>
        {
            SetField(cut.Instance, "userInput", "wrong");
            RunAsync(cut.Instance, "CheckAnswer");
        });
        cut.Render();
        Assert.Contains("Đáp án đúng", cut.Markup);
    }

    [Fact]
    public async Task CorrectAnswer_IncrementsStat()
    {
        var mock = CreateMockCharService();
        Context.Services.AddScoped(_ => mock.Object);
        var cut = Context.Render<JapaneseLearner.Pages.AlphabetStudy>();

        Task checkTask = null!;
        await cut.InvokeAsync(() =>
        {
            SetField(cut.Instance, "userInput", "a");
            checkTask = RunAsync(cut.Instance, "CheckAnswer");
        });
        await checkTask;
        var correctCount = (int)GetField(cut.Instance, "correctCount")!;
        Assert.Equal(1, correctCount);
    }

    [Fact]
    public async Task WrongAnswer_IncrementsWrongStat()
    {
        var mock = CreateMockCharService();
        Context.Services.AddScoped(_ => mock.Object);
        var cut = Context.Render<JapaneseLearner.Pages.AlphabetStudy>();

        await cut.InvokeAsync(() =>
        {
            SetField(cut.Instance, "userInput", "wrong");
            RunAsync(cut.Instance, "CheckAnswer");
        });
        var wrongCount = (int)GetField(cut.Instance, "wrongCount")!;
        Assert.Equal(1, wrongCount);
    }
}
