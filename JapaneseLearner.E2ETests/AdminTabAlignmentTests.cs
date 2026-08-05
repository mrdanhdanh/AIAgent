using Microsoft.Playwright;
using System.Text.Json;

namespace JapaneseLearner.E2ETests;

/// <summary>
/// Reproduction tests for BUG-20260801-001:
/// "Các button trong admin-tab-bar đều đang bị lỗi lệch chữ"
/// Root-cause lead: Admin.razor tab bar was refactored from native &lt;button&gt;
/// to FluentButton (web component with shadow DOM) in commit 13bdf53, while the
/// .admin-tab-btn CSS (display:flex; align-items:center) kept targeting the host
/// element — it can no longer align icon + text inside the shadow content slot.
///
/// RED: the icon and the text inside each .admin-tab-btn are NOT vertically
/// aligned (delta Y exceeds tolerance) → bug is reproduced.
/// GREEN: all deltas within tolerance → alignment fixed.
/// </summary>
public class AdminTabAlignmentTests : E2ETestBase
{
    private const double TolerancePx = 2.0;

    public AdminTabAlignmentTests(AppFixture fixture) : base(fixture)
    {
        Console.OutputEncoding = System.Text.Encoding.UTF8;
    }

    [Fact]
    public async Task Tab_Buttons_Icon_And_Text_Are_Vertically_Aligned()
    {
        await using var pw = await GotoAsync($"{Fixture.ServerUrl}/admin", ".admin-tab-btn");
        // Give fonts + FluentUI web components time to settle.
        await Task.Delay(2500);

        // Save a screenshot for visual diagnosis.
        var shotDir = @"C:\Users\nguye\AppData\Local\Temp\opencode";
        var shotPath = Path.Combine(shotDir, "BUG-20260801-001-admin-tabbar.png");
        await pw.Page.ScreenshotAsync(new() { Path = shotPath, FullPage = true });

        // Dump DOM structure + computed styles + alignment metrics per tab button.
        var json = await pw.Page.Locator(".admin-tab-btn").EvaluateAllAsync<string>(@"
            (btns) => JSON.stringify(btns.map(b => {
                const host = b.getBoundingClientRect();
                const cs = getComputedStyle(b);
                const icon = b.querySelector('svg');                 // FluentIcon renders inline <svg>
                const iconRect = icon ? icon.getBoundingClientRect() : null;
                const control = b.shadowRoot ? b.shadowRoot.querySelector('.control') : null;
                const controlCs = control ? getComputedStyle(control) : null;
                const controlRect = control ? control.getBoundingClientRect() : null;
                const content = b.shadowRoot ? b.shadowRoot.querySelector('[part=content]') : null;
                const contentRect = content ? content.getBoundingClientRect() : null;

                // Collect light-DOM text node info.
                const textNodes = [];
                let top = Infinity, bottom = -Infinity;
                try {
                    const walker = document.createTreeWalker(b, NodeFilter.SHOW_TEXT);
                    let n;
                    while ((n = walker.nextNode())) {
                        const t = n.textContent || '';
                        if (!t.trim()) continue;
                        const parent = n.parentElement;
                        if (parent && parent.closest && parent.closest('svg, fluent-icon')) continue;
                        let r = null;
                        try {
                            const range = document.createRange();
                            range.selectNodeContents(n);
                            r = range.getBoundingClientRect();
                        } catch (e) {}
                        if (r && r.width > 0 && r.height > 0) {
                            top = Math.min(top, r.top);
                            bottom = Math.max(bottom, r.bottom);
                            textNodes.push({ text: t.trim().slice(0, 20), rect: { top: Math.round(r.top), bottom: Math.round(r.bottom), w: Math.round(r.width), h: Math.round(r.height) } });
                        }
                    }
                } catch (e) {}

                const iconCenter = iconRect ? (iconRect.top + iconRect.bottom) / 2 : null;
                const textCenter = top === Infinity ? null : (top + bottom) / 2;
                return {
                    label: (b.textContent || '').trim().slice(0, 40),
                    hostTop: Math.round(host.top),
                    hostBottom: Math.round(host.bottom),
                    hostDisplay: cs.display,
                    hostAlignItems: cs.alignItems,
                    hostPadding: cs.padding,
                    hostGap: cs.gap,
                    iconTop: iconRect ? Math.round(iconRect.top) : null,
                    iconBottom: iconRect ? Math.round(iconRect.bottom) : null,
                    controlClass: control ? control.className : null,
                    controlTop: controlRect ? Math.round(controlRect.top) : null,
                    controlBottom: controlRect ? Math.round(controlRect.bottom) : null,
                    controlDisplay: controlCs ? controlCs.display : null,
                    controlAlign: controlCs ? controlCs.alignItems : null,
                    controlJustify: controlCs ? controlCs.justifyContent : null,
                    controlPadding: controlCs ? controlCs.padding : null,
                    controlGap: controlCs ? controlCs.gap : null,
                    contentTop: contentRect ? Math.round(contentRect.top) : null,
                    contentBottom: contentRect ? Math.round(contentRect.bottom) : null,
                    textNodeCount: textNodes.length,
                    textNodes: textNodes,
                    textTop: top === Infinity ? null : Math.round(top),
                    textBottom: bottom === -Infinity ? null : Math.round(bottom),
                    deltaYpx: (iconCenter !== null && textCenter !== null) ? Math.round((iconCenter - textCenter) * 100) / 100 : null
                };
            }))");

        using var doc = JsonDocument.Parse(json);
        var rows = doc.RootElement.EnumerateArray().ToList();

        Console.WriteLine($"[BUG-20260801-001] Admin tab-bar alignment metrics ({rows.Count} buttons):");
        var deltas = new List<double>();
        foreach (var r in rows)
        {
            var label = r.GetProperty("label").GetString() ?? "?";
            Console.WriteLine($"  '{label}'");
            Console.WriteLine($"    host:        {R(r, "hostTop")}..{R(r, "hostBottom")} (display={r.GetProperty("hostDisplay").GetString()}, " +
                              $"align={r.GetProperty("hostAlignItems").GetString()}, padding={r.GetProperty("hostPadding").GetString()}, gap={r.GetProperty("hostGap").GetString()})");
            Console.WriteLine($"    icon(svg):   {R(r, "iconTop")}..{R(r, "iconBottom")}");
            Console.WriteLine($"    control:     class={r.GetProperty("controlClass").GetString()} {R(r, "controlTop")}..{R(r, "controlBottom")} " +
                              $"(display={r.GetProperty("controlDisplay").GetString()}, align={r.GetProperty("controlAlign").GetString()}, " +
                              $"justify={r.GetProperty("controlJustify").GetString()}, padding={r.GetProperty("controlPadding").GetString()}, gap={r.GetProperty("controlGap").GetString()})");
            Console.WriteLine($"    content:     {R(r, "contentTop")}..{R(r, "contentBottom")}");
            Console.WriteLine($"    text:        {R(r, "textTop")}..{R(r, "textBottom")} (deltaY icon-text = {R(r, "deltaYpx")}px)");
            foreach (var tn in r.GetProperty("textNodes").EnumerateArray())
            {
                var rect = tn.GetProperty("rect");
                Console.WriteLine($"      textNode: '{tn.GetProperty("text").GetString()}' {rect.GetProperty("top").GetInt32()}..{rect.GetProperty("bottom").GetInt32()} ({rect.GetProperty("w").GetInt32()}x{rect.GetProperty("h").GetInt32()})");
            }
            if (r.GetProperty("deltaYpx").ValueKind == JsonValueKind.Number)
                deltas.Add(r.GetProperty("deltaYpx").GetDouble());
        }

        Assert.Equal(4, rows.Count);
        Assert.NotEmpty(deltas); // guard: icons must be measurable
        Assert.All(deltas, d => Assert.True(
            Math.Abs(d) <= TolerancePx,
            $"BUG-20260801-001: icon and text of an admin tab button are NOT vertically aligned (deltaY = {d}px > {TolerancePx}px). Screenshot: {shotPath}"));
    }

    private static string R(JsonElement r, string prop)
        => r.GetProperty(prop).ValueKind == JsonValueKind.Number
            ? r.GetProperty(prop).GetDouble().ToString("0.##")
            : "null";
}
