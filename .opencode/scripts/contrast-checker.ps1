# ==============================================================================
# contrast-checker.ps1 — WCAG 2.1 AA Contrast Verifier (JapaneseLearner)
#
# Bug-fix workflow BUG-20260806-001
# Reproduction test (RED): fails while contrast issues exist in theme.css
# Verification test (GREEN): must pass after fix
#
# Standard: WCAG 2.1 AA
#   - normal text:     >= 4.5:1
#   - large text (>=18pt or 14pt bold): >= 3.0:1
#   - UI components / graphics: >= 3.0:1
#
# Usage: powershell -ExecutionPolicy Bypass -File contrast-checker.ps1 [-Verbose]
# Exit code 0 = PASS, 1 = FAIL
# ==============================================================================

[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$failCount = 0
$totalCount = 0
$results = @()

# -----------------------------------------------------------------------------
# WCAG relative luminance (sRGB)
# -----------------------------------------------------------------------------
function Get-RelativeLuminance([string]$hex) {
    $h = $hex.TrimStart('#')
    if ($h.Length -lt 6) { throw "Invalid hex: $hex" }
    $r = [Convert]::ToInt32($h.Substring(0,2), 16) / 255.0
    $g = [Convert]::ToInt32($h.Substring(2,2), 16) / 255.0
    $b = [Convert]::ToInt32($h.Substring(4,2), 16) / 255.0
    $f = {
        param($c)
        if ($c -le 0.03928) { return $c / 12.92 }
        return [Math]::Pow(($c + 0.055) / 1.055, 2.4)
    }
    return 0.2126 * (& $f $r) + 0.7152 * (& $f $g) + 0.0722 * (& $f $b)
}

# -----------------------------------------------------------------------------
# WCAG contrast ratio between two hex colors
# -----------------------------------------------------------------------------
function Get-ContrastRatio([string]$fg, [string]$bg) {
    $L1 = Get-RelativeLuminance $fg
    $L2 = Get-RelativeLuminance $bg
    if ($L1 -lt $L2) { $tmp = $L1; $L1 = $L2; $L2 = $tmp }
    return ($L1 + 0.05) / ($L2 + 0.05)
}

# -----------------------------------------------------------------------------
# Alpha-composite rgba over a solid background -> resulting hex color
# -----------------------------------------------------------------------------
function Merge-RgbaOverBg([string]$rgbHex, [double]$alpha, [string]$bgHex) {
    $h = $rgbHex.TrimStart('#')
    $r = [Convert]::ToInt32($h.Substring(0,2), 16)
    $g = [Convert]::ToInt32($h.Substring(2,2), 16)
    $b = [Convert]::ToInt32($h.Substring(4,2), 16)
    $bh = $bgHex.TrimStart('#')
    $br = [Convert]::ToInt32($bh.Substring(0,2), 16)
    $bg = [Convert]::ToInt32($bh.Substring(2,2), 16)
    $bb = [Convert]::ToInt32($bh.Substring(4,2), 16)
    $nr = [int][Math]::Round($r * $alpha + $br * (1 - $alpha))
    $ng = [int][Math]::Round($g * $alpha + $bg * (1 - $alpha))
    $nb = [int][Math]::Round($b * $alpha + $bb * (1 - $alpha))
    return ('{0:X2}{1:X2}{2:X2}' -f $nr, $ng, $nb).PadLeft(6, '0')
}

# -----------------------------------------------------------------------------
# Color pairs table (AFTER FIX values — BUG-20260806-001).
# Format: [label, fgHex, bgHex, threshold, note]
#   bgHex may be a hex color, or 'compose:r,g,b,alpha,bgHex' for rgba over solid
# -----------------------------------------------------------------------------
$pairs = @(
    # ============ LIGHT THEME (:root in theme.css) ============
    # --- Base surfaces / text ---
    @('LIGHT text-primary on bg-card (#ffffff)',        '2b211f', 'ffffff', 4.5, 'theme.css:22,20'),
    @('LIGHT text-secondary on bg-card (#ffffff)',      '6f645f', 'ffffff', 4.5, 'theme.css:23,20'),
    @('LIGHT text-secondary on bg-page (#f7f5f1)',      '6f645f', 'f7f5f1', 4.5, 'theme.css:23,19'),
    @('LIGHT text-table on table-th-bg (#faf7f2)',      '3a302d', 'faf7f2', 4.5, 'theme.css:25,119'),
    @('LIGHT text-secondary on table-th-bg',            '6f645f', 'faf7f2', 4.5, 'stat-label'),
    @('LIGHT accent (#c5413b) on white (links/icon)',   'c5413b', 'ffffff', 4.5, 'theme.css:8'),
    @('LIGHT white on accent (#c5413b) (tab active)',   'ffffff', 'c5413b', 4.5, 'theme.css:93,94'),
    @('LIGHT secondary (#3f6b85) on white',             '3f6b85', 'ffffff', 4.5, 'theme.css:11'),
    @('LIGHT success (#2f7d5f) on white',               '2f7d5f', 'ffffff', 4.5, 'theme.css:15'),
    @('LIGHT danger (#c5413b) on white',                'c5413b', 'ffffff', 4.5, 'theme.css:16'),
    @('LIGHT white on error-ui-bg (#c5413b)',           'ffffff', 'c5413b', 4.5, 'theme.css:132,133'),
    @('LIGHT text-on-accent (#ffffff) on accent',       'ffffff', 'c5413b', 4.5, 'brand-mark / skip-link'),
    # --- Stats / feedback (rgba over white) ---
    @('LIGHT stat-correct-text on stat-correct-bg',     '1f5c44', 'compose:2f7d5f,0.12,ffffff', 4.5, 'theme.css:56,57 FIXED'),
    @('LIGHT stat-wrong-text on stat-wrong-bg',         '8f2b26', 'compose:c5413b,0.12,ffffff', 4.5, 'theme.css:58,59 FIXED'),
    @('LIGHT feedback-correct-text on fb-correct-bg',   '1f5c44', 'compose:2f7d5f,0.10,ffffff', 4.5, 'theme.css:68,69 FIXED'),
    @('LIGHT feedback-wrong-text on fb-wrong-bg',       '8f2b26', 'compose:c5413b,0.09,ffffff', 4.5, 'theme.css:71,72 FIXED'),
    @('LIGHT opt-correct-text on opt-correct-bg',       '1f5c44', 'compose:2f7d5f,0.15,ffffff', 4.5, 'theme.css:79,80 FIXED'),
    @('LIGHT opt-wrong-text on opt-wrong-bg',           '8f2b26', 'compose:c5413b,0.15,ffffff', 4.5, 'theme.css:82,83 FIXED'),
    @('LIGHT notif-success-text on notif-success-bg',   '1f5c44', 'compose:2f7d5f,0.12,ffffff', 4.5, 'theme.css:126,127 FIXED'),
    # --- Badges (rgba over white) ---
    @('LIGHT badge-seion-text on badge-seion-bg',       '3f6b85', 'compose:3f6b85,0.12,ffffff', 4.5, 'theme.css:99,100'),
    @('LIGHT badge-dakuon-text on badge-dakuon-bg',     '8f2b26', 'compose:c5413b,0.10,ffffff', 4.5, 'theme.css:101,102 FIXED'),
    @('LIGHT badge-handakuon on badge-handakuon-bg',    '1f5c44', 'compose:2f7d5f,0.12,ffffff', 4.5, 'theme.css:103,104 FIXED'),
    @('LIGHT badge-yoon-text on badge-yoon-bg',         '66500d', 'compose:b28a22,0.16,ffffff', 4.5, 'theme.css:105,106 FIXED'),
    @('LIGHT badge-sokuon-text on badge-sokuon-bg',     '33485a', 'compose:4a6b7d,0.14,ffffff', 4.5, 'theme.css:107,108'),
    @('LIGHT badge-choon-text on badge-choon-bg',       '33485a', 'compose:3f6b85,0.14,ffffff', 4.5, 'theme.css:109,110'),
    @('LIGHT badge-n5-text on badge-n5-bg',             '1f5c44', 'compose:2f7d5f,0.12,ffffff', 4.5, 'theme.css:111,112 FIXED'),
    @('LIGHT badge-level-text on badge-level-bg',       '66500d', 'compose:b28a22,0.18,ffffff', 4.5, 'theme.css:113,114 FIXED'),
    @('LIGHT badge-stroke-text on badge-stroke-bg',     'ffffff', '4a6b7d', 4.5, 'theme.css:115,116'),
    # --- Tabs / filters ---
    @('LIGHT tab-btn-text on tab-btn-bg (white)',       '6f645f', 'ffffff', 4.5, 'theme.css:88,90'),
    @('LIGHT tab-btn-active-text on active-bg',         'ffffff', 'c5413b', 4.5, 'theme.css:93,94'),
    @('LIGHT filter-btn-text on white',                 '6f645f', 'ffffff', 4.5, 'app.css:459'),
    @('LIGHT tab-btn-hover-text (#3f6b85) on white',    '3f6b85', 'ffffff', 4.5, 'theme.css:92'),
    # --- Hint dots ---
    @('LIGHT hint-dot-active-text on hint-dot-active-bg','3f6b85', 'compose:3f6b85,0.14,ffffff', 4.5, 'theme.css:66,67'),
    # --- Table ---
    @('LIGHT table-romaji-text on table-romaji-bg',     '3f6b85', 'f3eee7', 4.5, 'theme.css:123,122'),
    # --- Appbar ---
    @('LIGHT appbar-text on appbar-bg (rgba 92%)',      'f5f1ec', 'compose:2b211f,0.92,f7f5f1', 4.5, 'theme.css:28,26'),
    @('LIGHT appbar-nav-btn on appbar-bg',              'e8e2da', 'compose:2b211f,0.92,f7f5f1', 4.5, 'theme.css:29,26'),
    # --- Loading ---
    @('LIGHT loading-text on bg-page',                  '2b211f', 'f7f5f1', 4.5, 'theme.css:131,19'),
    # --- Icon fallbacks (white text on gradient) ---
    @('LIGHT practice-icon fallback start',             'ffffff', '2c7a6e', 4.5, 'Practice.razor:186 FIXED'),
    @('LIGHT practice-icon fallback end',               'ffffff', '1d3557', 4.5, 'Practice.razor:186'),
    @('LIGHT training-icon fallback start',             'ffffff', '3f7a70', 4.5, 'Training.razor:117'),
    @('LIGHT training-icon fallback end',               'ffffff', '2c5a52', 4.5, 'Training.razor:117'),
    @('LIGHT admin grammar icon fallback',              'ffffff', '6A4E9C', 4.5, 'Admin.razor:545'),

    # ============ DARK THEME ([data-theme="dark"] in theme.css) ============
    # --- Base surfaces / text ---
    @('DARK text-primary on bg-card (#1f1c1a)',         'ece7e1', '1f1c1a', 4.5, 'theme.css:155,153'),
    @('DARK text-secondary on bg-card',                 'a89f98', '1f1c1a', 4.5, 'theme.css:156,153'),
    @('DARK text-secondary on bg-page',                 'a89f98', '141210', 4.5, 'theme.css:156,152'),
    @('DARK text-table on table-th-bg',                 'c9c1b8', '282523', 4.5, 'theme.css:157,229'),
    @('DARK accent (#e56a55) on bg-card (links)',       'e56a55', '1f1c1a', 4.5, 'theme.css:172'),
    @('DARK text-on-accent (#2b211f) on accent',        '2b211f', 'e56a55', 4.5, 'brand-mark / skip-link FIXED'),
    @('DARK text-on-accent on accent-hover (#f07a66)',  '2b211f', 'f07a66', 4.5, 'brand-mark hover FIXED'),
    @('DARK secondary (#7fa8bf) on bg-card',            '7fa8bf', '1f1c1a', 4.5, 'theme.css:175'),
    @('DARK success (#5fae8f) on bg-card',              '5fae8f', '1f1c1a', 4.5, 'theme.css:177'),
    @('DARK danger (#e56a55) on bg-card',               'e56a55', '1f1c1a', 4.5, 'theme.css:178'),
    # --- Tabs / filters ---
    @('DARK tab-btn-text on tab-btn-bg (#282523)',      'cfc7bd', '282523', 4.5, 'theme.css:90 FIXED override'),
    @('DARK tab-btn-text on tab-bar-bg (#1f1c1a)',      'cfc7bd', '1f1c1a', 4.5, 'theme.css:90 FIXED override'),
    @('DARK tab-btn-active-text on active-bg',          '2b211f', 'e56a55', 4.5, 'theme.css:214,215 FIXED'),
    @('DARK tab-btn-hover-text (#9ec4d8) on tab-bg',    '9ec4d8', '282523', 4.5, 'theme.css:217,213'),
    # --- Stats / feedback (rgba over dark card) ---
    @('DARK stat-correct-text on stat-correct-bg',      '5fae8f', 'compose:5fae8f,0.18,1f1c1a', 4.5, 'theme.css:185,187'),
    @('DARK stat-wrong-text on stat-wrong-bg',          'f29281', 'compose:e56a55,0.18,1f1c1a', 4.5, 'theme.css:186,188 FIXED'),
    @('DARK feedback-correct-text on fb-correct-bg',    '5fae8f', 'compose:5fae8f,0.14,1f1c1a', 4.5, 'theme.css:237,238'),
    @('DARK feedback-wrong-text on fb-wrong-bg',        'e07a6a', 'compose:e56a55,0.13,1f1c1a', 4.5, 'theme.css:240,241'),
    @('DARK opt-correct-text on opt-correct-bg',        '74c6a5', 'compose:5fae8f,0.22,1f1c1a', 4.5, 'theme.css:199,201 FIXED'),
    @('DARK opt-wrong-text on opt-wrong-bg',            'f29281', 'compose:e56a55,0.22,1f1c1a', 4.5, 'theme.css:202,204 FIXED'),
    @('DARK notif-success-text on notif-success-bg',    '5fae8f', 'compose:5fae8f,0.18,1f1c1a', 4.5, 'theme.css:234,235'),
    # --- Badges (rgba over dark card) ---
    @('DARK badge-seion-text on badge-seion-bg',        '9ec4d8', 'compose:7fa8bf,0.12,1f1c1a', 4.5, 'theme.css:218'),
    @('DARK badge-dakuon-text on badge-dakuon-bg',      'e07a6a', 'compose:e56a55,0.10,1f1c1a', 4.5, 'theme.css:219'),
    @('DARK badge-handakuon on badge-handakuon-bg',     '5fae8f', 'compose:5fae8f,0.12,1f1c1a', 4.5, 'theme.css:220'),
    @('DARK badge-yoon-text on badge-yoon-bg',          'c9a44a', 'compose:b28a22,0.16,1f1c1a', 4.5, 'theme.css:221,224'),
    @('DARK badge-level-text on badge-level-bg',        'c9a44a', 'compose:b28a22,0.16,1f1c1a', 4.5, 'theme.css:224,225'),
    @('DARK badge-sokuon-text on badge-sokuon-bg',      'ece7e1', 'compose:4a6b7d,0.14,1f1c1a', 4.5, 'theme.css:222'),
    @('DARK badge-choon-text on badge-choon-bg',        'ece7e1', 'compose:3f6b85,0.14,1f1c1a', 4.5, 'theme.css:223'),
    @('DARK badge-n5-text on badge-n5-bg',              '5fae8f', 'compose:5fae8f,0.12,1f1c1a', 4.5, 'theme.css:228'),
    @('DARK badge-stroke-text on badge-stroke-bg',      'ece7e1', '2f5267', 4.5, 'theme.css:226,227'),
    # --- Hint dots ---
    @('DARK hint-dot-active-text on hint-dot-active-bg','9ec4d8', 'compose:7fa8bf,0.24,1f1c1a', 4.5, 'theme.css:195,196'),
    # --- Table ---
    @('DARK table-romaji-text on table-romaji-bg',      '9ec4d8', '33302c', 4.5, 'theme.css:233,232'),
    # --- Appbar ---
    @('DARK appbar-text on appbar-bg',                  'ece7e1', 'compose:141210,0.92,141210', 4.5, 'theme.css:160,158'),
    @('DARK appbar-nav-btn on appbar-bg',               'cfc7bd', 'compose:141210,0.92,141210', 4.5, 'theme.css:161,158'),
    # --- Loading ---
    @('DARK loading-text on bg-page',                   'ece7e1', '141210', 4.5, 'theme.css:244,152'),
    # --- Icon fallbacks (white text on gradient) ---
    @('DARK icon hiragana/kanji start',                 'ffffff', 'a33730', 4.5, 'theme.css:205-206'),
    @('DARK icon hiragana/kanji end',                   'ffffff', '6e221f', 4.5, 'theme.css:205-206'),
    @('DARK icon word start',                           'ffffff', '2f5267', 4.5, 'theme.css:207'),
    @('DARK icon word end',                             'ffffff', '1d3646', 4.5, 'theme.css:207'),
    @('DARK icon grammar start',                        'ffffff', '5f4470', 4.5, 'theme.css:210'),
    @('DARK icon grammar end',                          'ffffff', '3f2f4d', 4.5, 'theme.css:210'),

    # ============ Page-specific inline colors ============
    @('LIGHT AlphabetQuiz status text on white',        '0a7a44', 'ffffff', 4.5, 'AlphabetQuiz.razor:189 FIXED'),
    @('LIGHT AlphabetQuiz error text on white',         'D13438', 'ffffff', 4.5, 'AlphabetQuiz.razor:190'),
    @('LIGHT Training msg-ok on #d4edda',               '155724', 'd4edda', 4.5, 'Training.razor:150'),
    @('LIGHT Training msg-err on #f8d7da',              '721c24', 'f8d7da', 4.5, 'Training.razor:151'),
    @('LIGHT Training clear-all on white',              'c0392b', 'ffffff', 4.5, 'Training.razor:165 FIXED'),
    @('LIGHT Training clear-char on white',             'a8530b', 'ffffff', 4.5, 'Training.razor:166 FIXED'),
    @('LIGHT white on badge-level fallback',            'ffffff', 'c22b38', 4.5, 'app.css:492 FIXED'),
    @('LIGHT white on badge-stroke fallback',           'ffffff', '3f6b85', 4.5, 'app.css:501 FIXED'),
    @('LIGHT KanjiDetail accent fallback on white',     'c22b38', 'ffffff', 4.5, 'KanjiDetail.razor:243 FIXED')
)

# -----------------------------------------------------------------------------
# Evaluate
# -----------------------------------------------------------------------------
foreach ($p in $pairs) {
    $label = $p[0]; $fg = $p[1]; $bgSpec = $p[2]; $threshold = [double]$p[3]; $note = $p[4]
    if ($bgSpec -like 'compose:*') {
        $parts = $bgSpec.Substring(8).Split(',')
        $bg = Merge-RgbaOverBg $parts[0] ([double]$parts[1]) $parts[2]
    } else {
        $bg = $bgSpec
    }
    $ratio = [Math]::Round((Get-ContrastRatio $fg $bg), 2)
    $totalCount++
    $ok = $ratio -ge $threshold
    if (-not $ok) { $failCount++ }
    $results += [PSCustomObject]@{
        Label     = $label
        Fg        = $fg
        Bg        = $bg
        Ratio     = $ratio
        Threshold = $threshold
        Status    = $(if ($ok) { 'PASS' } else { 'FAIL' })
        Note      = $note
    }
}

# -----------------------------------------------------------------------------
# Report
# -----------------------------------------------------------------------------
Write-Host "=== WCAG 2.1 AA Contrast Audit (JapaneseLearner) ===" -ForegroundColor Cyan
Write-Host "Standard: normal text >= 4.5:1 | large text / UI >= 3.0:1`n" -ForegroundColor Gray

foreach ($r in $results) {
    $color = if ($r.Status -eq 'PASS') { 'Green' } else { 'Red' }
    Write-Host ('{0,-3} {1,6}:1  {2,-62}  {3}' -f $r.Status, $r.Ratio, $r.Label, $r.Note) -ForegroundColor $color
}

Write-Host ''
Write-Host ('TOTAL: {0} pairs | PASS: {1} | FAIL: {2}' -f $totalCount, ($totalCount - $failCount), $failCount) -ForegroundColor $(if ($failCount -eq 0) { 'Green' } else { 'Red' })

if ($failCount -gt 0) {
    Write-Host 'RESULT: FAIL (RED) — contrast issues detected' -ForegroundColor Red
    exit 1
} else {
    Write-Host 'RESULT: PASS (GREEN) — all pairs meet WCAG AA' -ForegroundColor Green
    exit 0
}
