using Bunit;
using Microsoft.Extensions.DependencyInjection;
using MudBlazor;
using MudBlazor.Services;
using JapaneseLearner.Models;
using JapaneseLearner.Services;
using JapaneseLearner.Tests.TestHelpers;
using Moq;

namespace JapaneseLearner.Tests;

public class AdminTests : BunitTestBase
{
    private readonly Mock<ICharService> _mockCharService;
    private readonly Mock<IWordService> _mockWordService;
    private readonly Mock<ISnackbar> _mockSnackbar;
    private readonly List<JapaneseChar> _testChars;

    public AdminTests()
    {
        _mockCharService = new Mock<ICharService>();
        _mockWordService = new Mock<IWordService>();
        _mockSnackbar = new Mock<ISnackbar>();
        _testChars = new List<JapaneseChar>
        {
            new() { Id = 1, Character = "あ", Romaji = "a", Type = "Hiragana" },
            new() { Id = 2, Character = "ア", Romaji = "a", Type = "Katakana" },
        };

        _mockCharService.Setup(s => s.GetAllAsync()).ReturnsAsync(_testChars);
        _mockWordService.Setup(s => s.GetAllAsync()).ReturnsAsync(new List<JapaneseWord>());
        Context.Services.AddScoped(_ => _mockCharService.Object);
        Context.Services.AddScoped(_ => _mockWordService.Object);
        Context.Services.AddScoped(_ => _mockSnackbar.Object);
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
        var addBtn = cut.FindAll("button").FirstOrDefault(b => b.TextContent.Contains("Thêm chữ"));
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

        var ctx = new BunitContext();
        ctx.Services.AddMudServices();
        ctx.JSInterop.SetupVoid("mudElementRef.addOnBlurEvent", _ => true);
        ctx.JSInterop.SetupVoid("mudPopover.connect", _ => true);
        ctx.JSInterop.SetupVoid("mudPopover.disconnect", _ => true);
        ctx.JSInterop.SetupVoid("mudPopover.initialize", _ => true);
        ctx.Services.AddScoped(_ => emptyMockChar.Object);
        ctx.Services.AddScoped(_ => emptyMockWord.Object);
        ctx.Services.AddScoped(_ => new Mock<ISnackbar>().Object);

        var cut = ctx.Render<JapaneseLearner.Pages.Admin>();
        Assert.Contains("Danh sách trống", cut.Markup);
    }

    [Fact]
    public void ClickAddBtn_DoesNotThrow()
    {
        var cut = Context.Render<JapaneseLearner.Pages.Admin>();
        var addBtn = cut.Find(".add-btn");
        // Verify click does not throw (logic test, not dialog rendering)
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
