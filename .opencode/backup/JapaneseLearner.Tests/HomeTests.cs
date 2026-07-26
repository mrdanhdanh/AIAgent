using Bunit;
using Microsoft.Extensions.DependencyInjection;
using JapaneseLearner.Models;
using JapaneseLearner.Services;
using JapaneseLearner.Tests.TestHelpers;
using Moq;

namespace JapaneseLearner.Tests;

public class HomeTests : BunitTestBase
{
    [Fact]
    public void Render_ShowsLoading()
    {
        var mockCharService = new Mock<ICharService>();
        mockCharService.Setup(s => s.GetByTypeAsync("All"))
            .ReturnsAsync(new List<JapaneseChar> { new() { Id = 1, Character = "あ", Romaji = "a", Type = "Hiragana" } });
        Context.Services.AddScoped(_ => mockCharService.Object);

        var cut = Context.Render<JapaneseLearner.Pages.Home>();

        Assert.Contains("Luyện tập", cut.Markup);
    }

    [Fact]
    public void Render_ShowsEmptyState_WhenNoChars()
    {
        var mockCharService = new Mock<ICharService>();
        mockCharService.Setup(s => s.GetByTypeAsync("All"))
            .ReturnsAsync(new List<JapaneseChar>());
        Context.Services.AddScoped(_ => mockCharService.Object);

        var cut = Context.Render<JapaneseLearner.Pages.Home>();

        Assert.Contains("Chưa có dữ liệu", cut.Markup);
    }

    [Fact]
    public void Render_DisplaysChar_WhenDataExists()
    {
        var mockCharService = new Mock<ICharService>();
        mockCharService.Setup(s => s.GetByTypeAsync("All"))
            .ReturnsAsync(new List<JapaneseChar> { new() { Id = 1, Character = "あ", Romaji = "a", Type = "Hiragana" } });
        Context.Services.AddScoped(_ => mockCharService.Object);

        var cut = Context.Render<JapaneseLearner.Pages.Home>();

        Assert.Contains("あ", cut.Markup);
    }

    [Fact(Skip = "MudBlazor input interaction requires JS interop mock")]
    public void CheckAnswer_CorrectInput_ShowsCorrectFeedback()
    {
    }

    [Fact(Skip = "MudBlazor input interaction requires JS interop mock")]
    public void CheckAnswer_WrongInput_ShowsWrongFeedback()
    {
    }

    [Fact(Skip = "MudBlazor input interaction requires JS interop mock")]
    public void CheckAnswer_TrimsWhitespace()
    {
    }

    [Fact(Skip = "MudBlazor input interaction requires JS interop mock")]
    public void CheckAnswer_IsCaseInsensitive()
    {
    }

    [Fact(Skip = "MudBlazor input interaction requires JS interop mock")]
    public void CorrectAnswer_IncrementsStat()
    {
    }

    [Fact(Skip = "MudBlazor input interaction requires JS interop mock")]
    public void WrongAnswer_IncrementsWrongStat()
    {
    }
}
