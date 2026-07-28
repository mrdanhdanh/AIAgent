using Bunit;
using Microsoft.AspNetCore.Components;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.FluentUI.AspNetCore.Components;
using JapaneseLearner.Models;
using JapaneseLearner.Services;
using JapaneseLearner.Tests.TestHelpers;
using Moq;

namespace JapaneseLearner.Tests;

public class GrammarStudyTests : BunitTestBase
{
    private readonly Mock<IGrammarService> _mockService;
    private readonly List<JapaneseGrammar> _testGrammar;

    public GrammarStudyTests()
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

        _mockService.Setup(s => s.GetByLevelAsync("N5")).ReturnsAsync(_testGrammar);
        _mockService.Setup(s => s.GetByLevelAsync("All")).ReturnsAsync(_testGrammar);
    }

    [Fact]
    public void Renders_LoadingState()
    {
        var tcs = new TaskCompletionSource<List<JapaneseGrammar>>();
        var mockDelay = new Mock<IGrammarService>();
        mockDelay.Setup(s => s.GetByLevelAsync("N5")).Returns(tcs.Task);
        Context.Services.AddScoped(_ => mockDelay.Object);

        var cut = Context.Render<JapaneseLearner.Pages.GrammarStudy>();

        Assert.Contains("loading-wrap", cut.Markup);

        tcs.SetResult(new List<JapaneseGrammar>());
    }

    [Fact]
    public void Renders_EmptyState()
    {
        var emptyMock = new Mock<IGrammarService>();
        emptyMock.Setup(s => s.GetByLevelAsync("N5")).ReturnsAsync(new List<JapaneseGrammar>());

        var ctx = new BunitContext();
        ctx.Services.AddFluentUIComponents();
        ctx.Services.AddScoped(_ => emptyMock.Object);

        var ver = "?v=4.14.3.26174";
        var js = ctx.JSInterop;
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

        var cut = ctx.Render<JapaneseLearner.Pages.GrammarStudy>();
        Assert.Contains("Chưa có dữ liệu", cut.Markup);
    }

    [Fact]
    public void Renders_DataState()
    {
        Context.Services.AddScoped(_ => _mockService.Object);
        var cut = Context.Render<JapaneseLearner.Pages.GrammarStudy>();

        Assert.Contains("〜は〜です", cut.Markup);
        Assert.Contains("Là...", cut.Markup);
        Assert.Contains("Cấu trúc câu cơ bản nhất.", cut.Markup);
        Assert.Contains("〜ます / 〜ません", cut.Markup);
        Assert.Contains("Làm / Không làm", cut.Markup);
    }

    [Fact]
    public void Filter_JLPTLevel()
    {
        Context.Services.AddScoped(_ => _mockService.Object);
        var cut = Context.Render<JapaneseLearner.Pages.GrammarStudy>();

        var allBtn = cut.FindAll(".filter-btn").First(b => b.TextContent.Contains("All"));
        allBtn.Click();
        _mockService.Verify(s => s.GetByLevelAsync("All"), Times.AtLeastOnce);

        var n5Btn = cut.FindAll(".filter-btn").First(b => b.TextContent.Contains("N5"));
        n5Btn.Click();
        _mockService.Verify(s => s.GetByLevelAsync("N5"), Times.AtLeastOnce);
    }

    [Fact]
    public void Navigate_ToDetail()
    {
        Context.Services.AddScoped(_ => _mockService.Object);
        var cut = Context.Render<JapaneseLearner.Pages.GrammarStudy>();

        var navMan = Context.Services.GetRequiredService<NavigationManager>();
        var firstCard = cut.Find(".grammar-card");
        firstCard.Click();

        Assert.Contains("/grammar/1", navMan.Uri);
    }
}
