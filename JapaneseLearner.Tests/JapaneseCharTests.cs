using JapaneseLearner.Models;

namespace JapaneseLearner.Tests;

public class JapaneseCharTests
{
    [Fact]
    public void JapaneseChar_HasDefaultTypeHiragana()
    {
        var c = new JapaneseChar();

        Assert.Equal("Hiragana", c.Type);
    }

    [Fact]
    public void JapaneseChar_CanSetProperties()
    {
        var c = new JapaneseChar
        {
            Id = 1,
            Character = "あ",
            Romaji = "a",
            Type = "Hiragana"
        };

        Assert.Equal(1, c.Id);
        Assert.Equal("あ", c.Character);
        Assert.Equal("a", c.Romaji);
        Assert.Equal("Hiragana", c.Type);
    }

    [Fact]
    public void JapaneseChar_Defaults_AreEmptyStrings()
    {
        var c = new JapaneseChar();

        Assert.Equal(string.Empty, c.Character);
        Assert.Equal(string.Empty, c.Romaji);
    }

    [Fact]
    public void JapaneseChar_DefaultId_IsZero()
    {
        var c = new JapaneseChar();
        Assert.Equal(0, c.Id);
    }

    [Fact]
    public void JapaneseChar_CanHaveEmptyRomaji()
    {
        var c = new JapaneseChar { Id = 1, Character = "あ", Romaji = "", Type = "Hiragana" };
        Assert.Equal("", c.Romaji);
    }

    [Fact]
    public void JapaneseWord_Defaults()
    {
        var w = new JapaneseWord();

        Assert.Equal(string.Empty, w.Characters);
        Assert.Equal(string.Empty, w.Romaji);
        Assert.Equal(string.Empty, w.Meaning);
        Assert.Equal("N5", w.Type);
    }

    [Fact]
    public void JapaneseWord_CanSetProperties()
    {
        var w = new JapaneseWord
        {
            Id = 1,
            Characters = "こんにちは",
            Romaji = "konnichiwa",
            Meaning = "xin chào",
            Type = "Seion"
        };

        Assert.Equal(1, w.Id);
        Assert.Equal("こんにちは", w.Characters);
        Assert.Equal("konnichiwa", w.Romaji);
        Assert.Equal("xin chào", w.Meaning);
        Assert.Equal("Seion", w.Type);
    }

    [Fact]
    public void JapaneseWord_DefaultId_IsZero()
    {
        var w = new JapaneseWord();
        Assert.Equal(0, w.Id);
    }

    [Fact]
    public void JapaneseWord_HasAllTypes()
    {
        var seion = new JapaneseWord { Type = "Seion" };
        var dakuon = new JapaneseWord { Type = "Dakuon" };
        var handakuon = new JapaneseWord { Type = "Handakuon" };
        var yoon = new JapaneseWord { Type = "Yoon" };
        var sokuon = new JapaneseWord { Type = "Sokuon" };
        var choon = new JapaneseWord { Type = "Choon" };

        Assert.Equal("Seion", seion.Type);
        Assert.Equal("Dakuon", dakuon.Type);
        Assert.Equal("Handakuon", handakuon.Type);
        Assert.Equal("Yoon", yoon.Type);
        Assert.Equal("Sokuon", sokuon.Type);
        Assert.Equal("Choon", choon.Type);
    }

    [Fact]
    public void JapaneseWord_AcceptsValidLengths()
    {
        var w1 = new JapaneseWord { Characters = "あ" };
        var w2 = new JapaneseWord { Characters = "あいう" };
        var w3 = new JapaneseWord { Characters = "あいうえお" };

        Assert.InRange(w1.Characters.Length, 1, 5);
        Assert.InRange(w2.Characters.Length, 1, 5);
        Assert.InRange(w3.Characters.Length, 1, 5);
    }

    [Fact]
    public void JapaneseWord_CanHaveLongerCharsLength()
    {
        var w = new JapaneseWord { Characters = "がいこくご" };
        Assert.Equal(5, w.Characters.Length);
    }

    [Fact]
    public void JapaneseWord_CanSetTypeToAnyValidType()
    {
        var types = new[] { "Seion", "Dakuon", "Handakuon", "Yoon", "Sokuon", "Choon" };
        foreach (var t in types)
        {
            var w = new JapaneseWord { Type = t };
            Assert.Equal(t, w.Type);
        }
    }
}
