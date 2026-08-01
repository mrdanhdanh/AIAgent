using Microsoft.Playwright;

namespace JapaneseLearner.E2ETests;

/// <summary>
/// Shared base for E2E page tests: navigation, computed-style assertions,
/// CSS-var lookups and deterministic quiz answer helpers (seed data is read
/// from localStorage which is written by the app on first load).
/// </summary>
[Collection("E2E")]
public abstract class E2ETestBase
{
    protected readonly AppFixture Fixture;
    protected E2ETestBase(AppFixture fixture) => Fixture = fixture;

    protected static async Task<PlaywrightFixture> GotoAsync(string url, string waitSelector = ".app-layout", int timeout = 15000)
    {
        var pw = await PlaywrightFixture.CreateAsync();
        await pw.Page.GotoAsync(url);
        await pw.Page.WaitForSelectorAsync(waitSelector, new() { Timeout = timeout });
        return pw;
    }

    /// <summary>Read a resolved CSS custom property from an element's computed style.</summary>
    protected static async Task<string?> GetCssVarAsync(IPage page, string selector, string varName)
    {
        return await page.Locator(selector).First.EvaluateAsync<string?>(
            $"el => getComputedStyle(el).getPropertyValue('{varName}').trim()");
    }

    /// <summary>Read a computed style property (e.g. maxWidth, color, borderTopLeftRadius).</summary>
    protected static async Task<string?> GetStyleAsync(IPage page, string selector, string property)
    {
        return await page.Locator(selector).First.EvaluateAsync<string?>($"el => getComputedStyle(el).{property}");
    }

    protected static async Task<int> CountTrackColumnsAsync(IPage page, string selector)
    {
        var cols = await page.Locator(selector).First.EvaluateAsync<string>("el => getComputedStyle(el).gridTemplateColumns");
        return cols.Split(' ', StringSplitOptions.RemoveEmptyEntries).Length;
    }

    /// <summary>Click the quiz option whose text equals the target value (exact match).</summary>
    protected static async Task ClickOptionByExactTextAsync(IPage page, string text)
    {
        var count = await page.Locator(".option-btn").CountAsync();
        for (int i = 0; i < count; i++)
        {
            var btn = page.Locator(".option-btn").Nth(i);
            var txt = (await btn.InnerTextAsync()).Trim();
            if (txt == text.Trim())
            {
                await btn.ClickAsync();
                return;
            }
        }
        Assert.Fail($"Không tìm thấy option '{text}'");
    }

    /// <summary>Look up the Romaji of a displayed kana from the seed stored in localStorage.</summary>
    protected static async Task<string?> LookupCharRomajiAsync(IPage page, string displayed)
    {
        return await page.EvaluateAsync<string?>(@"(displayed) => {
            for (let i = 0; i < localStorage.length; i++) {
                const k = localStorage.key(i);
                try {
                    const v = JSON.parse(localStorage.getItem(k));
                    if (Array.isArray(v)) {
                        const found = v.find(x => x && x.Character === displayed);
                        if (found && found.Romaji) return found.Romaji;
                    }
                } catch (e) {}
            }
            return null;
        }", displayed);
    }

    /// <summary>Look up the Meaning of a displayed word from the seed stored in localStorage.</summary>
    protected static async Task<string?> LookupWordMeaningAsync(IPage page, string displayed)
    {
        return await page.EvaluateAsync<string?>(@"(displayed) => {
            for (let i = 0; i < localStorage.length; i++) {
                const k = localStorage.key(i);
                try {
                    const v = JSON.parse(localStorage.getItem(k));
                    if (Array.isArray(v)) {
                        const found = v.find(x => x && x.Characters === displayed);
                        if (found && found.Meaning) return found.Meaning;
                    }
                } catch (e) {}
            }
            return null;
        }", displayed);
    }

    /// <summary>Look up the Characters of a word whose Romaji matches from the seed in localStorage.</summary>
    protected static async Task<string?> LookupWordCharactersByRomajiAsync(IPage page, string romaji)
    {
        return await page.EvaluateAsync<string?>(@"(romaji) => {
            for (let i = 0; i < localStorage.length; i++) {
                const k = localStorage.key(i);
                try {
                    const v = JSON.parse(localStorage.getItem(k));
                    if (Array.isArray(v)) {
                        const found = v.find(x => x && x.Romaji === romaji);
                        if (found && found.Characters) return found.Characters;
                    }
                } catch (e) {}
            }
            return null;
        }", romaji);
    }

    /// <summary>Look up an On-yomi reading of a displayed kanji from the seed stored in localStorage.</summary>
    protected static async Task<string?> LookupKanjiOnYomiAsync(IPage page, string displayed)
    {
        return await page.EvaluateAsync<string?>(@"(displayed) => {
            for (let i = 0; i < localStorage.length; i++) {
                const k = localStorage.key(i);
                try {
                    const v = JSON.parse(localStorage.getItem(k));
                    if (Array.isArray(v)) {
                        const found = v.find(x => x && x.Kanji === displayed);
                        if (found && found.OnYomi) return found.OnYomi;
                    }
                } catch (e) {}
            }
            return null;
        }", displayed);
    }

    /// <summary>
    /// Set a value on the fluent-text-field Web Component and trigger Enter keydown.
    /// Sets value at the Web Component level (not the inner input) so Blazor's
    /// @bind-Value picks it up, then dispatches keydown on the component for @onkeydown.
    /// </summary>
    protected static async Task SetValueAndPressEnterAsync(IPage page, string text)
    {
        var field = page.Locator(".romaji-input");
        await field.First.EvaluateAsync($$"""
            (el) => {
                el.value = '{{text.Replace("'", "\\'")}}';
                el.dispatchEvent(new Event('change', { bubbles: true }));
            }
            """);
        await Task.Delay(200);
        await field.First.EvaluateAsync("""
            (el) => {
                el.dispatchEvent(new KeyboardEvent('keydown', {
                    key: 'Enter', code: 'Enter', keyCode: 13, which: 13,
                    bubbles: true, cancelable: true, composed: true
                }));
            }
            """);
        await Task.Delay(300);
    }
}
