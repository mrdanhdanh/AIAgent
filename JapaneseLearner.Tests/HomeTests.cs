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

        // Should have 7 navigation cards
        Assert.Contains("Bảng chữ cái", cut.Markup);
        Assert.Contains("Từ vựng", cut.Markup);
        Assert.Contains("Luyện viết", cut.Markup);
        Assert.Contains("Quiz từ vựng", cut.Markup);
        Assert.Contains("Kanji", cut.Markup);
        Assert.Contains("Ngữ pháp N5", cut.Markup);
        Assert.Contains("Quản trị", cut.Markup);
    }

    [Fact]
    public void Render_HasNavigationButtons()
    {
        var cut = Context.Render<JapaneseLearner.Pages.Home>();

        // 2 hero CTAs + 7 card buttons
        var buttons = cut.FindAll("fluent-button, button");

        Assert.Equal(9, buttons.Count);
    }

    [Fact]
    public void ClickAlphabet_NavigatesToAlphabet()
    {
        var navMan = Context.Services.GetRequiredService<NavigationManager>();
        var cut = Context.Render<JapaneseLearner.Pages.Home>();

        var button = cut.FindAll("fluent-button, button").First(b => b.TextContent.Contains("Bắt đầu học"));
        button.Click();

        Assert.EndsWith("/alphabet", navMan.Uri);
    }

    [Fact]
    public void ClickWords_NavigatesToWords()
    {
        var navMan = Context.Services.GetRequiredService<NavigationManager>();
        var cut = Context.Render<JapaneseLearner.Pages.Home>();

        var wordsCard = cut.FindAll(".nav-card").First(c => c.TextContent.Contains("Từ vựng"));
        wordsCard.QuerySelector("fluent-button")!.Click();

        Assert.EndsWith("/words", navMan.Uri);
    }

    [Fact]
    public void ClickKanji_NavigatesToKanji()
    {
        var navMan = Context.Services.GetRequiredService<NavigationManager>();
        var cut = Context.Render<JapaneseLearner.Pages.Home>();

        var kanjiCard = cut.FindAll(".nav-card").First(c => c.TextContent.Contains("Kanji"));
        kanjiCard.QuerySelector("fluent-button")!.Click();

        Assert.EndsWith("/kanji", navMan.Uri);
    }

    [Fact]
    public void ClickAdmin_NavigatesToAdmin()
    {
        var navMan = Context.Services.GetRequiredService<NavigationManager>();
        var cut = Context.Render<JapaneseLearner.Pages.Home>();

        var adminCard = cut.FindAll(".nav-card").First(c => c.TextContent.Contains("Quản trị"));
        adminCard.QuerySelector("fluent-button")!.Click();

        Assert.EndsWith("/admin", navMan.Uri);
    }
}
