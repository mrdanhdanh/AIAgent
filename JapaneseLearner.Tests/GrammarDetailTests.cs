using Bunit;
using Microsoft.AspNetCore.Components;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.FluentUI.AspNetCore.Components;
using JapaneseLearner.Models;
using JapaneseLearner.Services;
using JapaneseLearner.Tests.TestHelpers;
using Moq;

namespace JapaneseLearner.Tests;

public class GrammarDetailTests : BunitTestBase
{
    private readonly Mock<IGrammarService> _mockService;
    private readonly List<JapaneseGrammar> _testGrammar;

    public GrammarDetailTests()
    {
        _mockService = new Mock<IGrammarService>();
        _testGrammar = new List<JapaneseGrammar>
        {
            new()
            {
                Id = 1,
                Pattern = "〜は〜です",
                Meaning = "Là...",
                Explanation = "Cấu trúc câu cơ bản nhất.",
                JLPTLevel = "N5",
                Examples = new List<string> { "これは本です。", "彼は学生です。" }
            },
            new()
            {
                Id = 2,
                Pattern = "〜ます / 〜ません",
                Meaning = "Làm / Không làm",
                Explanation = "Dạng lịch sự của động từ.",
                JLPTLevel = "N5",
                Examples = new List<string> { "毎日勉強します。" }
            }
        };

        _mockService.Setup(s => s.GetAllAsync()).ReturnsAsync(_testGrammar);
    }

    [Fact]
    public void Renders_LoadingState()
    {
        var tcs = new TaskCompletionSource<List<JapaneseGrammar>>();
        var mockDelay = new Mock<IGrammarService>();
        mockDelay.Setup(s => s.GetAllAsync()).Returns(tcs.Task);
        Context.Services.AddScoped(_ => mockDelay.Object);

        var cut = Context.Render<JapaneseLearner.Pages.GrammarDetail>(
            parameters => parameters.Add(p => p.Id, 1));

        Assert.Contains("loading-wrap", cut.Markup);

        tcs.SetResult(new List<JapaneseGrammar>());
    }

    [Fact]
    public void Renders_Detail_ValidId()
    {
        Context.Services.AddScoped(_ => _mockService.Object);
        var cut = Context.Render<JapaneseLearner.Pages.GrammarDetail>(
            parameters => parameters.Add(p => p.Id, 1));

        Assert.Contains("〜は〜です", cut.Markup);
        Assert.Contains("Là...", cut.Markup);
        Assert.Contains("Cấu trúc câu cơ bản nhất.", cut.Markup);
        Assert.Contains("N5", cut.Markup);
        Assert.Contains("これは本です。", cut.Markup);
        Assert.Contains("彼は学生です。", cut.Markup);
    }

    [Fact]
    public void Renders_NotFound_InvalidId()
    {
        Context.Services.AddScoped(_ => _mockService.Object);
        var cut = Context.Render<JapaneseLearner.Pages.GrammarDetail>(
            parameters => parameters.Add(p => p.Id, 999));

        Assert.Contains("Không tìm thấy mẫu ngữ pháp", cut.Markup);
    }

    [Fact]
    public void BackButton_Navigates()
    {
        Context.Services.AddScoped(_ => _mockService.Object);
        var cut = Context.Render<JapaneseLearner.Pages.GrammarDetail>(
            parameters => parameters.Add(p => p.Id, 1));

        var navMan = Context.Services.GetRequiredService<NavigationManager>();
        var backBtn = cut.Find(".back-btn");
        backBtn.Click();

        Assert.EndsWith("/grammar", navMan.Uri);
    }
}
