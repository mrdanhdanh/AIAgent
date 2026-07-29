using Bunit;
using Microsoft.AspNetCore.Components;
using Microsoft.Extensions.DependencyInjection;
using JapaneseLearner.Tests.TestHelpers;

namespace JapaneseLearner.Tests;

public class HomeTests : BunitTestBase
{
    [Fact]
    public void Render_ShowsWelcomeTitle()
    {
        var cut = Context.Render<JapaneseLearner.Pages.Home>();

        Assert.Contains("Japanese Learner", cut.Markup);
    }

    [Fact]
    public void Render_ShowsNavigationCards()
    {
        var cut = Context.Render<JapaneseLearner.Pages.Home>();

        // Should have 8 navigation cards
        Assert.Contains("Bảng chữ cái", cut.Markup);
        Assert.Contains("Từ vựng", cut.Markup);
        Assert.Contains("Luyện viết", cut.Markup);
        Assert.Contains("Tập luyện", cut.Markup);
        Assert.Contains("Quiz từ vựng", cut.Markup);
        Assert.Contains("Kanji", cut.Markup);
        Assert.Contains("Ngữ pháp N5", cut.Markup);
        Assert.Contains("Quản trị", cut.Markup);
    }

    [Fact]
    public void Render_HasEightNavButtons()
    {
        var cut = Context.Render<JapaneseLearner.Pages.Home>();

        var buttons = cut.FindAll("fluent-button, button");

        Assert.Equal(8, buttons.Count);
    }

    [Fact]
    public void ClickAlphabet_NavigatesToAlphabet()
    {
        var navMan = Context.Services.GetRequiredService<NavigationManager>();
        var cut = Context.Render<JapaneseLearner.Pages.Home>();

        cut.FindAll("fluent-button, button")[0].Click();

        Assert.EndsWith("/alphabet", navMan.Uri);
    }

    [Fact]
    public void ClickWords_NavigatesToWords()
    {
        var navMan = Context.Services.GetRequiredService<NavigationManager>();
        var cut = Context.Render<JapaneseLearner.Pages.Home>();

        cut.FindAll("fluent-button, button")[1].Click();

        Assert.EndsWith("/words", navMan.Uri);
    }

    [Fact]
    public void ClickKanji_NavigatesToKanji()
    {
        var navMan = Context.Services.GetRequiredService<NavigationManager>();
        var cut = Context.Render<JapaneseLearner.Pages.Home>();

        cut.FindAll("fluent-button, button")[5].Click();

        Assert.EndsWith("/kanji", navMan.Uri);
    }

    [Fact]
    public void ClickAdmin_NavigatesToAdmin()
    {
        var navMan = Context.Services.GetRequiredService<NavigationManager>();
        var cut = Context.Render<JapaneseLearner.Pages.Home>();

        cut.FindAll("fluent-button, button")[7].Click();

        Assert.EndsWith("/admin", navMan.Uri);
    }
}
