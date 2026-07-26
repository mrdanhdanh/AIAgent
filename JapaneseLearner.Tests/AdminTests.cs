using Bunit;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.FluentUI.AspNetCore.Components;
using JapaneseLearner.Models;
using JapaneseLearner.Services;
using JapaneseLearner.Tests.TestHelpers;
using Moq;

namespace JapaneseLearner.Tests;

public class AdminTests : BunitTestBase
{
    private readonly Mock<ICharService> _mockCharService;
    private readonly Mock<IWordService> _mockWordService;
    private readonly Mock<IKanjiService> _mockKanjiService;
    private readonly List<JapaneseChar> _testChars;

    public AdminTests()
    {
        _mockCharService = new Mock<ICharService>();
        _mockWordService = new Mock<IWordService>();
        _mockKanjiService = new Mock<IKanjiService>();
        _testChars = new List<JapaneseChar>
        {
            new() { Id = 1, Character = "あ", Romaji = "a", Type = "Hiragana" },
            new() { Id = 2, Character = "ア", Romaji = "a", Type = "Katakana" },
        };

        _mockCharService.Setup(s => s.GetAllAsync()).ReturnsAsync(_testChars);
        _mockWordService.Setup(s => s.GetAllAsync()).ReturnsAsync(new List<JapaneseWord>());
        _mockKanjiService.Setup(s => s.GetAllAsync()).ReturnsAsync(new List<JapaneseKanji>());
        Context.Services.AddScoped(_ => _mockCharService.Object);
        Context.Services.AddScoped(_ => _mockWordService.Object);
        Context.Services.AddScoped(_ => _mockKanjiService.Object);
    }

    [Fact]
    public void Render_DisplaysTitle()
    {
        var cut = Context.Render<JapaneseLearner.Pages.Admin>();
        Assert.Contains("Quản lý bảng chữ cái", cut.Markup);
    }

    [Fact]
    public void Render_ShowsChars()
    {
        var cut = Context.Render<JapaneseLearner.Pages.Admin>();
        Assert.Contains("あ", cut.Markup);
        Assert.Contains("ア", cut.Markup);
    }

    [Fact]
    public void Render_HasAddButton()
    {
        var cut = Context.Render<JapaneseLearner.Pages.Admin>();
        var addBtn = cut.FindAll(".add-btn").FirstOrDefault(b => b.TextContent.Contains("Thêm chữ"));
        Assert.NotNull(addBtn);
    }

    [Fact]
    public void AddBtn_ExistsAndHasCorrectClass()
    {
        var cut = Context.Render<JapaneseLearner.Pages.Admin>();
        var addBtn = cut.Find(".add-btn");
        Assert.NotNull(addBtn);
        Assert.Contains("Thêm chữ", addBtn.TextContent);
    }

    [Fact]
    public void EditAndDeleteBtns_Exist()
    {
        var cut = Context.Render<JapaneseLearner.Pages.Admin>();
        var actionBtns = cut.FindAll(".action-btn-icon");
        Assert.True(actionBtns.Count >= 2, "Expected at least edit and delete buttons");
    }

    [Fact]
    public void EmptyState_WhenNoChars()
    {
        var emptyMockChar = new Mock<ICharService>();
        emptyMockChar.Setup(s => s.GetAllAsync()).ReturnsAsync(new List<JapaneseChar>());
        var emptyMockWord = new Mock<IWordService>();
        emptyMockWord.Setup(s => s.GetAllAsync()).ReturnsAsync(new List<JapaneseWord>());
        var emptyMockKanji = new Mock<IKanjiService>();
        emptyMockKanji.Setup(s => s.GetAllAsync()).ReturnsAsync(new List<JapaneseKanji>());

        var ctx = new BunitContext();
        ctx.Services.AddFluentUIComponents();
        ctx.Services.AddScoped(_ => emptyMockChar.Object);
        ctx.Services.AddScoped(_ => emptyMockWord.Object);
        ctx.Services.AddScoped(_ => emptyMockKanji.Object);

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

        var cut = ctx.Render<JapaneseLearner.Pages.Admin>();
        Assert.Contains("Danh sách trống", cut.Markup);
    }

    [Fact]
    public void ClickAddBtn_DoesNotThrow()
    {
        var cut = Context.Render<JapaneseLearner.Pages.Admin>();
        var addBtn = cut.Find(".add-btn");
        var ex = Record.Exception(() => addBtn.Click());
        Assert.Null(ex);
    }

    [Fact]
    public void ClickDeleteBtn_DoesNotThrow()
    {
        var cut = Context.Render<JapaneseLearner.Pages.Admin>();
        var deleteBtns = cut.FindAll(".action-btn-icon");
        if (deleteBtns.Count > 1)
        {
            var ex = Record.Exception(() => deleteBtns[1].Click());
            Assert.Null(ex);
        }
    }
}