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
    private static object? GetField<T>(T instance, string name)
    {
        return typeof(T).GetField(name, BindingFlags.NonPublic | BindingFlags.Instance)!.GetValue(instance);
    }

    private object FindFirstOption<T>(T instance, bool isCorrect)
    {
        var optionsField = typeof(T).GetField("options", BindingFlags.NonPublic | BindingFlags.Instance)!;
        var options = (System.Collections.IList)optionsField.GetValue(instance)!;
        var optType = options.GetType().GetGenericArguments()[0];
        var isCorrectProp = optType.GetProperty("IsCorrect")!;
        var displayProp = optType.GetProperty("Display")!;

        foreach (var opt in options)
        {
            if ((bool)isCorrectProp.GetValue(opt)! == isCorrect)
                return opt;
        }
        throw new InvalidOperationException($"No {(isCorrect ? "correct" : "wrong")} option found");
    }

    private static string GetOptionDisplay(object opt)
    {
        var displayProp = opt.GetType().GetProperty("Display")!;
        return (string)displayProp.GetValue(opt)!;
    }

    private static string GetVocabProperty(object vocab, string propName)
    {
        return (string)vocab.GetType().GetProperty(propName)!.GetValue(vocab)!;
    }

    [Fact]
    public void Render_ShowsTitle()
    {
        var cut = Context.Render<JapaneseLearner.Pages.KanjiQuiz>();
        Assert.Contains("Trắc nghiệm Kanji", cut.Markup);
    }

    [Fact]
    public void Render_ShowsModeToggle()
    {
        var cut = Context.Render<JapaneseLearner.Pages.KanjiQuiz>();
        Assert.Contains("Kanji → Romaji", cut.Markup);
        Assert.Contains("Romaji → Kanji", cut.Markup);
    }

    [Fact]
    public void Render_DefaultModeIsKanjiToRomaji()
    {
        var cut = Context.Render<JapaneseLearner.Pages.KanjiQuiz>();
        var isKanjiToRomajiMode = (bool)GetField(cut.Instance, "isKanjiToRomajiMode")!;
        Assert.True(isKanjiToRomajiMode);
    }

    [Fact]
    public void Render_DisplaysKanjiWord_WhenDataExists_DefaultMode()
    {
        var cut = Context.Render<JapaneseLearner.Pages.KanjiQuiz>();
        var currentVocab = GetField(cut.Instance, "currentVocab");
        Assert.NotNull(currentVocab);
        var word = GetVocabProperty(currentVocab, "Word");
        Assert.Contains(word, cut.Markup);
    }

    [Fact]
    public void Render_ShowsFourOptions()
    {
        var cut = Context.Render<JapaneseLearner.Pages.KanjiQuiz>();
        var optionBtns = cut.FindAll(".option-btn");
        Assert.Equal(4, optionBtns.Count);
    }

    [Fact]
    public void Options_IncludeCorrectAnswer_DefaultMode()
    {
        var cut = Context.Render<JapaneseLearner.Pages.KanjiQuiz>();
        var currentVocab = GetField(cut.Instance, "currentVocab");
        Assert.NotNull(currentVocab);
        var correctRomaji = GetVocabProperty(currentVocab, "Romaji");
        var optionTexts = cut.FindAll(".option-text").Select(e => e.TextContent).ToList();
        Assert.Contains(correctRomaji, optionTexts);
    }

    [Fact]
    public void AllOptions_HaveDistinctValues()
    {
        var cut = Context.Render<JapaneseLearner.Pages.KanjiQuiz>();
        var optionTexts = cut.FindAll(".option-text").Select(e => e.TextContent).ToList();
        Assert.Equal(4, optionTexts.Distinct().Count());
    }

    [Fact]
    public async Task SelectCorrectAnswer_IncrementsCorrectCount()
    {
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
    public async Task SelectWrongAnswer_ShowsCorrectAnswer()
    {
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
    public void EmptyState_ShowsMessage_WhenNoData()
    {
        var cut = Context.Render<JapaneseLearner.Pages.KanjiQuiz>();
        var field = typeof(JapaneseLearner.Pages.KanjiQuiz)
            .GetField("availableVocab", BindingFlags.NonPublic | BindingFlags.Instance)!;
        var list = (System.Collections.IList)field.GetValue(cut.Instance)!;
        list.Clear();
        cut.Render();
        Assert.Contains("Chưa có dữ liệu", cut.Markup);
    }

    [Fact]
    public void Stats_InitiallyZero()
    {
        var cut = Context.Render<JapaneseLearner.Pages.KanjiQuiz>();
        Assert.Contains("0", cut.FindAll(".stat-num")[0].TextContent);
        Assert.Contains("0", cut.FindAll(".stat-num")[1].TextContent);
    }

    [Fact]
    public async Task SwitchMode_ResetsAndShowsRomajiDisplay()
    {
        var cut = Context.Render<JapaneseLearner.Pages.KanjiQuiz>();

        var romajiModeBtn = cut.FindAll(".mode-btn").First(b => b.TextContent.Contains("Romaji → Kanji"));
        romajiModeBtn.Click();
        cut.Render();

        var isKanjiToRomajiMode = (bool)GetField(cut.Instance, "isKanjiToRomajiMode")!;
        Assert.False(isKanjiToRomajiMode);

        var currentVocab = GetField(cut.Instance, "currentVocab");
        Assert.NotNull(currentVocab);
        var romaji = GetVocabProperty(currentVocab, "Romaji");
        Assert.Contains(romaji, cut.Markup);
    }

    [Fact]
    public async Task RomajiToKanjiMode_OptionsContainKanjiWords()
    {
        var cut = Context.Render<JapaneseLearner.Pages.KanjiQuiz>();

        var romajiModeBtn = cut.FindAll(".mode-btn").First(b => b.TextContent.Contains("Romaji → Kanji"));
        romajiModeBtn.Click();
        cut.Render();

        var currentVocab = GetField(cut.Instance, "currentVocab");
        Assert.NotNull(currentVocab);
        var word = GetVocabProperty(currentVocab, "Word");

        var optionTexts = cut.FindAll(".option-text").Select(e => e.TextContent).ToList();
        Assert.Contains(word, optionTexts);
    }

    [Fact]
    public async Task RomajiToKanjiMode_CorrectAnswerShowsWordInFeedback()
    {
        var cut = Context.Render<JapaneseLearner.Pages.KanjiQuiz>();

        var romajiModeBtn = cut.FindAll(".mode-btn").First(b => b.TextContent.Contains("Romaji → Kanji"));
        romajiModeBtn.Click();
        cut.Render();

        await cut.InvokeAsync(() =>
        {
            var correct = FindFirstOption(cut.Instance, true);
            typeof(JapaneseLearner.Pages.KanjiQuiz)
                .GetMethod("SelectAnswer", BindingFlags.NonPublic | BindingFlags.Instance)!
                .Invoke(cut.Instance, new[] { correct });
        });
        cut.Render();

        var currentVocab = GetField(cut.Instance, "currentVocab");
        Assert.NotNull(currentVocab);
        var word = GetVocabProperty(currentVocab, "Word");
        Assert.Contains(word, cut.Markup);
    }
}
