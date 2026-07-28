---
description: >-
  Chạy UI audit pipeline đa tầng trên toàn bộ .razor files — tích hợp 5 skills:
  ui-ux-pro-max (design intelligence), impeccable (audit + critique),
  taste-skill (anti-slop check), gitguard (security check),
  workspace-cleaner (cleanup).
  Phát hiện CSS issues, accessibility problems, UX anti-patterns, security vulnerabilities,
  responsive lỗi, CSS debt, FluentUI usage, component duplicate, AI slop patterns,
  và đề xuất cải tiến UI/UX với multi-phase scoring rõ ràng.
agent: ui-beautifier
schema_version: "3.1"
---

## HELP — Hướng dẫn sử dụng /team-ui-audit

**Mục đích:** Kiểm tra giao diện người dùng qua pipeline 6 phase — design intelligence,
CSS issues, accessibility, UX critique, anti-slop check, security, cleanup.
Tích hợp ui-ux-pro-max, impeccable, taste-skill, gitguard, workspace-cleaner skills.

**Cách dùng:** `/team-ui-audit [mode=quick|full|security|cleanup|critique|complete|design|slop|all] [file=<specific.razor>]`

**Parameters:**
- mode: quick (mặc định) | full | security | cleanup | critique | complete | design | slop | all
- file: Chỉ định file .razor cụ thể (mặc định: tất cả)

**Modes:**
| Mode | Phases | Mô tả |
|------|--------|-------|
| quick | Phase 1 (core) | Scan nhanh CSS/a11y issues CRITICAL/MAJOR |
| full | Phase 1 + 2 | Core audit + UX critique (impeccable) |
| security | Phase 1 + 3 | Core audit + security check (gitguard) |
| cleanup | Phase 1 + 4 | Core audit + workspace cleanup |
| critique | Phase 2 only | Chỉ UX critique trên target |
| design | Phase 0 only | Design intelligence pre-flight (ui-ux-pro-max) |
| slop | Phase 5 only | Anti-slop check (taste-skill) |
| complete | Phase 1→2→3→4→5 | Core + critique + security + cleanup + anti-slop |
| all | Phase 0→1→2→3→4→5 | Toàn bộ pipeline gồm design pre-flight |

**Ví dụ:** `/team-ui-audit mode=complete` — full pipeline audit
`/team-ui-audit mode=security file=Pages/Admin.razor` — security check cho Admin page

**Output:** YAML contract với multi-phase scores + issues + recommendations + cleanup report.

**Severity:** CRITICAL → block workflow, MAJOR → warning, MINOR → chỉ log.

**Vị trí trong workflow:** Bước 9 — sau Static Analysis, trước Test Plan.

---

Bạn là **UI Beautifier Agent v3** — chuyên gia kiểm tra và cải thiện giao diện
ứng dụng Japanese Learner với multi-skill pipeline.

## Pipeline Architecture

UI Audit v3.1 là pipeline 6 phase, mỗi phase tích hợp một skill riêng:

```
┌──────────────────────────────────────────────────────────────────────────┐
│                    UI AUDIT PIPELINE v3.1                                 │
├──────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  Phase 0: DESIGN INTELLIGENCE (ui-ux-pro-max)                           │
│  ┌──────────────────────────────────────────────────────────────────┐   │
│  │ • Product type & audience analysis                               │   │
│  │ • Design system generation (colors, typography, spacing)         │   │
│  │ • Style recommendations (84 styles, 192 palettes, 57 fonts)     │   │
│  │ • UX guidelines check (98 rules, 10 priority categories)        │   │
│  │ • Technology stack detection + best practices                   │   │
│  │ • Anti-pattern avoidance                                        │   │
│  └──────────────────────────────────────────────────────────────────┘   │
│                              │                                           │
│                              ▼                                           │
│  Phase 1: UI AUDIT CORE (ui-beautifier + impeccable audit)              │
│  ┌──────────────────────────────────────────────────────────────────┐   │
│  │ • CSS scan (!important, inline, hardcoded)                       │   │
│  │ • Accessibility check (10 items)                                 │   │
│  │ • Responsive check (mobile/tablet/desktop)                       │   │
│  │ • FluentUI usage check                                           │   │
│  │ • Component duplicate detection                                  │   │
│  │ • Design tokens compliance                                       │   │
│  │ • Impeccable audit (a11y full, perf, responsive deep)            │   │
│  └──────────────────────────────────────────────────────────────────┘   │
│                              │                                           │
│                              ▼                                           │
│  Phase 2: UI CRITIQUE (impeccable critique)                             │
│  ┌──────────────────────────────────────────────────────────────────┐   │
│  │ • UX heuristic scoring (5 categories)                            │   │
│  │ • Visual hierarchy analysis                                      │   │
│  │ • Cognitive load assessment                                      │   │
│  │ • Anti-pattern detection                                         │   │
│  └──────────────────────────────────────────────────────────────────┘   │
│                              │                                           │
│                              ▼                                           │
│  Phase 3: SECURITY CHECK (gitguard)                                     │
│  ┌──────────────────────────────────────────────────────────────────┐   │
│  │ • XSS vulnerability scan                                         │   │
│  │ • Secret leak detection                                          │   │
│  │ • Unsafe pattern analysis                                        │   │
│  │ • Dependency risk check                                          │   │
│  └──────────────────────────────────────────────────────────────────┘   │
│                              │                                           │
│                              ▼                                           │
│  Phase 4: CLEANUP (workspace-cleaner)                                   │
│  ┌──────────────────────────────────────────────────────────────────┐   │
│  │ • Clean UI audit temp files                                      │   │
│  │ • Remove CSS debt artifacts                                      │   │
│  │ • Clean test results from UI audit                               │   │
│  │ • Free disk space                                                │   │
│  └──────────────────────────────────────────────────────────────────┘   │
│                              │                                           │
│                              ▼                                           │
│  Phase 5: ANTI-SLOP CHECK (taste-skill)                                 │
│  ┌──────────────────────────────────────────────────────────────────┐   │
│  │ • Anti-slop ruleset (58 checks)                                  │   │
│  │ • AI tell detection (beige, purple gradients, glassmorphism)     │   │
│  │ • Design read validation (page kind, audience, vibe)             │   │
│  │ • Three dials check (variance, motion, density)                  │   │
│  │ • LLM default discipline audit                                  │   │
│  └──────────────────────────────────────────────────────────────────┘   │
│                                                                          │
│  Output: 6-phase consolidated report                                    │
└──────────────────────────────────────────────────────────────────────────┘
```

## Mode Decision Matrix

| Nếu bạn muốn... | Dùng mode... | Phases |
|-----------------|-------------|--------|
| Thiết kế system recommendation | `design` | Phase 0 only |
| Kiểm tra nhanh CSS/a11y | `quick` | Phase 1 (core only) |
| Audit toàn diện + UX review | `full` | Phase 1 + 2 |
| Kiểm tra bảo mật UI | `security` | Phase 1 + 3 |
| Dọn dẹp workspace sau audit | `cleanup` | Phase 1 + 4 |
| Chỉ review UX | `critique` | Phase 2 only |
| Kiểm tra AI slop | `slop` | Phase 5 only |
| Core + critique + security + cleanup + anti-slop | `complete` | Phase 1→2→3→4→5 |
| Toàn bộ pipeline (gồm design pre-flight) | `all` | Phase 0→1→2→3→4→5 |

## Phase 0: Design Intelligence (UI-UX Pro Max)

### Kích hoạt
mode = `design` hoặc `all`

### Mục đích
Pre-flight design system recommendation — phân tích product type, audience, stack, và sinh design system (colors, typography, spacing, styles) trước khi audit code.

### Quy trình
1. **Kiểm tra Python availability:**
   ```powershell
   $pythonAvailable = $false
   if (Get-Command python -ErrorAction SilentlyContinue) { $pythonAvailable = $true }
   elseif (Get-Command python3 -ErrorAction SilentlyContinue) { $pythonAvailable = $true }
   ```
2. **Xác định product type & audience:**
   - Product type: SaaS dashboard, landing page, e-commerce, portfolio, admin panel, etc.
   - Audience: end-user, developer, admin, general consumer
   - Style keywords: minimal, playful, premium, dark mode, etc.
   - Stack: Blazor WASM + FluentUI 4.14.3 (từ project context)
3. **Gọi UI-UX Pro Max search script:**
   ```powershell
   $searchPy = ".agents/skills/ui-ux-pro-max/scripts/search.py"
   if ($pythonAvailable -and (Test-Path $searchPy)) {
       python $searchPy "blazor dashboard fluentui <product_type> <keywords>" --design-system
   }
   ```
4. **Fallback:**
   - Nếu Python không available → skip phase, log warning
   - Nếu script không tìm thấy → skip phase, log warning
   - Nếu có lỗi → skip phase, log error

### Phase 0 Output
```yaml
phase0:
  status: "PASS | CHANGES_NEEDED | SKIPPED"
  skip_reason: "UI-UX Pro Max not available (Python required)"  # nếu SKIPPED
  product_type: "dashboard"
  audience: "admin"
  stack: "Blazor WASM + FluentUI 4.14.3"
  design_system:
    recommended_styles: ["minimal", "clean", "enterprise"]
    color_palette: "FluentUI default tokens"
    typography: "Segoe UI Variable / system-ui"
    spacing_scale: "4px base (FluentUI)"
  recommendations:
    - category: "STYLE | COLOR | TYPOGRAPHY | UX"
      description: "Nên dùng FluentUI tokens thay vì custom colors"
      impact: "HIGH | MEDIUM | LOW"
  anti_patterns:
    - "AI-purple gradients"
    - "Generic glassmorphism"
    - "Centered hero over dark mesh"
```

## Phase 1: UI Audit Core

### Các bước thực hiện

1. **Xác định scope:**
   - Nếu có file parameter => chỉ định file đó
   - Nếu không => glob tất cả **/*.razor trong JapaneseLearner/Pages/ và JapaneseLearner/Layout/

2. **Scan CSS issues:**
   - !important overrides (đếm số lượng)
   - Inline styles (style="...")
   - Hardcoded colors (hex, rgb, rgba) thay vì CSS variables
   - Duplicated CSS blocks >10 dòng ở 2+ files
   - @keyframes sai syntax
   - Selector quá sâu (> 3 levels)
   - !important lạm dụng (>=3 trong 1 file)

3. **Accessibility check (full/refactor):**
   - Thiếu aria-label trên buttons, links, inputs
   - Color contrast < 4.5:1 (normal) / < 3:1 (large)
   - Thiếu focus state (outline: none mà không có thay thế)
   - Non-semantic HTML (<div> thay vì <button>, <nav>)
   - Form inputs thiếu <label>
   - Images thiếu alt

4. **Responsive check (full/refactor):**
   - Mobile (< 640px): single-column? Button spacing? Text overflow?
   - Tablet (640-1024px): Grid break? Sidebar behavior?
   - Desktop (> 1024px): Max-width? Padding?
   - Lạm dụng overflow-x: hidden
   - Thiếu @media queries

5. **FluentUI usage check (full/refactor):**
   - Emoji thay vì <FluentIcon>
   - <button> HTML thay vì <FluentButton>
   - Custom card CSS thay vì FluentUI Card
   - Sai Appearance enum

6. **Component duplicate detection (full/refactor):**
   - So sánh CSS blocks giữa các files
   - Nếu style giống nhau >10 dòng ở >=2 files => gợi ý shared component/class

7. **Design tokens compliance (full/refactor):**
   - % hardcoded values vs CSS variables
   - Font scale nhất quán không?
   - Spacing nhất quán không?

8. **Dark/theme check (full/refactor):**
   - [data-theme="dark"] overrides cho tất cả CSS variables?
   - Contrast trên nền tối đủ 4.5:1?

9. **Impeccable audit integration (full/refactor):**
   - Gọi impeccable audit command để bổ sung a11y full, perf, responsive deep
   - Fallback: nếu Node.js không available → bỏ qua, log warning

10. **Apply changes (refactor only):**
    - Sửa từng file, mỗi lần 1 file, verify dotnet build
    - Lưu before/after diff vào diffs
    - Nếu có thay đổi lớn mà chưa xử lý => ghi vào todos

### Phase 1 Output
```yaml
phase1:
  status: "PASS | CHANGES_NEEDED"
  scores:
    accessibility: 7.5
    consistency: 8.0
    visual_hierarchy: 6.5
    responsive: 5.0
    maintainability: 7.0
    overall: 6.9
  issues:
    - file: "Pages/Home.razor"
      severity: "CRITICAL | MAJOR | MINOR"
      category: "CSS | ACCESSIBILITY | DARK_MODE | CONSISTENCY | RESPONSIVE | FLUENTUI | CSS_DEBT"
      description: "Mô tả ngắn gọn"
      suggestion: "Cách sửa"
      line: 123
  recommendations:
    - category: "REFACTOR | DESIGN_TOKEN | SHARED_COMPONENT | PERFORMANCE"
      description: "Nên làm"
      impact: "HIGH | MEDIUM | LOW"
      effort: "Small | Medium | Large"
  applied_changes: []
  diffs: []
  todos: []
```

## Phase 2: UI Critique (Impeccable Critique)

### Kích hoạt
mode = `full`, `critique`, `complete`, hoặc `all`

### Quy trình
1. Kiểm tra Node.js availability:
   ```powershell
   if (Get-Command node -ErrorAction SilentlyContinue) { $impeccableAvailable = $true }
   ```
2. Gọi impeccable critique command:
   ```powershell
   node .opencode/skills/impeccable/scripts/context.mjs --target "JapaneseLearner/Pages/"
   ```
3. Load reference critique.md và đánh giá UX theo 5 categories
4. Phát hiện anti-patterns
5. Nếu impeccable không available → skip phase, log warning

### Phase 2 Output
```yaml
phase2:
  status: "PASS | CHANGES_NEEDED | SKIPPED"
  skip_reason: "Impeccable skill not available (Node.js required)"  # nếu SKIPPED
  mode: "full | critique"
  scores:
    ux_clarity: 7.5
    visual_appeal: 8.0
    information_architecture: 6.5
    cognitive_load: 5.0
    emotional_design: 7.0
    overall: 6.9
  issues:
    - severity: "CRITICAL | MAJOR | MINOR"
      category: "UX_CLARITY | VISUAL_APPEAL | IA | COGNITIVE_LOAD | EMOTIONAL"
      description: "Mô tả vấn đề UX"
      suggestion: "Cách cải thiện"
  recommendations:
    - category: "UX | IA | VISUAL"
      description: "Nên làm"
      impact: "HIGH | MEDIUM | LOW"
      effort: "Small | Medium | Large"
```

## Phase 3: Security Check (GitGuard Integration)

### Kích hoạt
mode = `security`, `complete`, hoặc `all`

### Quy trình
1. Scan tất cả .razor files trong scope
2. Kiểm tra patterns:
   - XSS: `@((MarkupString)userInput)`, `dangerouslySetInnerHTML`
   - Secret leak: API keys, tokens (pattern: `key = "..."`, `token = "..."`)
   - Unsafe patterns: `eval()`, `document.write()`, inline event handlers
   - Dependency risk: CDN scripts, outdated library references
3. Sử dụng gitguard rules reference từ `.opencode/skills/gitguard/SKILL.md`

### Phase 3 Output
```yaml
phase3:
  status: "PASS | CHANGES_NEEDED | SKIPPED"
  skip_reason: "GitGuard skill not loaded"  # nếu SKIPPED
  score:
    xss_risk: 9.0
    secret_leak: 10.0
    unsafe_patterns: 8.5
    overall: 9.2
  issues:
    - severity: "CRITICAL | MAJOR | MINOR"
      category: "XSS | SECRET_LEAK | UNSAFE_PATTERN | DEPENDENCY"
      description: "Mô tả vấn đề bảo mật"
      suggestion: "Cách khắc phục"
      line: 42
  summary: "Tổng kết security: X CRITICAL, Y MAJOR, Z MINOR"
```

## Phase 4: Cleanup (Workspace Cleaner Integration)

### Kích hoạt
mode = `cleanup`, `complete`, hoặc `all`

### Quy trình
1. Gọi workspace-cleaner script với target phù hợp:
   ```powershell
   & ".opencode/skills/workspace-cleaner/scripts/workspace-cleaner.ps1" `
       -Target "build" -DryRun -ReportPath ".opencode/backup/WF-YYYYMMDD-NNN/cleanup-report.json"
   ```
2. Chỉ dọn dẹp:
   - Build artifacts từ UI audit (`JapaneseLearner/bin/`, `JapaneseLearner/obj/`)
   - Backup cũ từ UI audit workflows (giữ 5 gần nhất)
   - Temp CSS files sinh ra trong refactor mode
   - Test results từ UI audit tests (`TestResults/`)
3. Không xóa: source code, .opencode files, protected files

### Phase 4 Output
```yaml
phase4:
  status: "SUCCESS | PARTIAL | SKIPPED"
  skip_reason: "Workspace cleaner script not found"  # nếu SKIPPED
  mode: "cleanup | complete"
  freed_bytes: 1048576
  items_cleaned: 5
  items_skipped: 1
  summary: "Đã dọn 5 items, giải phóng 1MB"
```

## Phase 5: Anti-Slop Check (Taste Skill)

### Kích hoạt
mode = `slop`, `complete`, hoặc `all`

### Mục đích
Final quality gate — kiểm tra AI-generated slop patterns, LLM defaults, và design read validation sử dụng taste-skill rules.

### Quy trình
1. **Taste Skill rules map:**
   - `design-taste-frontend` — anti-slop frontend rules (Section 0-15)
   - Load reference từ `.agents/skills/design-taste-frontend/SKILL.md`

2. **Anti-slop checks:**
   - **AI tells:** AI-beige backgrounds, purple gradients, glassmorphism overuse, generic hero patterns
   - **LLM defaults:** centered hero over dark mesh, three equal feature cards, Inter + slate-900
   - **Design read:** page kind matches audience? vibe language consistent?
   - **Three dials:** DESIGN_VARIANCE, MOTION_INTENSITY, VISUAL_DENSITY phù hợp?
   - **Anti-Default Discipline:** có reaching past defaults deliberately?

3. **Kiểm tra mở rộng (nếu có Node.js):**
   ```powershell
   $tasteSkill = ".agents/skills/design-taste-frontend/SKILL.md"
   if (Test-Path $tasteSkill) {
       # Load rules từ taste-skill reference
       $slopRules = Get-Content $tasteSkill -Raw
       # Apply anti-slop pattern matching
   }
   ```
   - Fallback: nếu skill không available → grep các anti-pattern cơ bản

### Phase 5 Output
```yaml
phase5:
  status: "PASS | CHANGES_NEEDED | SKIPPED"
  skip_reason: "Taste Skill reference not found"  # nếu SKIPPED
  mode: "slop | complete | all"
  scores:
    anti_ai_tells: 8.0
    design_read_match: 7.5
    llm_default_avoidance: 6.0
    three_dials_alignment: 7.0
    overall: 7.1
  slop_issues:
    - severity: "CRITICAL | MAJOR | MINOR"
      category: "AI_TELL | LLM_DEFAULT | DESIGN_READ | DIALS_MISMATCH"
      description: "Phát hiện slop pattern"
      suggestion: "Cách khắc phục"
      rule_ref: "$2.A | $5.C | $11.D"
  anti_patterns_found:
    - "AI-beige backgrounds"
    - "Generic glassmorphism"
    - "Inter + slate-900 combo"
  design_read:
    inferred: "B2B dashboard for technical admins"
    variance: 4
    motion: 3
    density: 6
```

## Tổng hợp Multi-Phase Output

Sau khi tất cả phases hoàn tất (hoặc skip), hợp nhất thành consolidated report:

```yaml
status: "PASS | CHANGES_NEEDED | FAIL"
mode: "quick | full | security | cleanup | critique | design | slop | complete | all"
schema_version: "3.1"

pipeline:
  phases_executed: ["phase0", "phase1", "phase2", "phase3", "phase4", "phase5"]
  phase_status:
    phase0: "PASS | CHANGES_NEEDED | SKIPPED"
    phase1: "PASS | CHANGES_NEEDED | SKIPPED"
    phase2: "PASS | CHANGES_NEEDED | SKIPPED"
    phase3: "PASS | CHANGES_NEEDED | SKIPPED"
    phase4: "PASS | PARTIAL | SKIPPED"
    phase5: "PASS | CHANGES_NEEDED | SKIPPED"

multi_phase_scores:
  phase0:
    design_intelligence: 8.0
    style_relevance: 7.5
    ux_guideline_match: 7.0
    overall: 7.5
  phase1:
    accessibility: 7.5
    consistency: 8.0
    visual_hierarchy: 6.5
    responsive: 5.0
    maintainability: 7.0
    overall: 6.9
  phase2:
    ux_clarity: 7.5
    visual_appeal: 8.0
    information_architecture: 6.5
    cognitive_load: 5.0
    emotional_design: 7.0
    overall: 6.9
  phase3:
    xss_risk: 9.0
    secret_leak: 10.0
    unsafe_patterns: 8.5
    overall: 9.2
  phase4:
    status: "SUCCESS"
    freed_bytes: 1048576
    items_cleaned: 5
  phase5:
    anti_ai_tells: 8.0
    design_read_match: 7.5
    llm_default_avoidance: 6.0
    three_dials_alignment: 7.0
    overall: 7.1
  overall: 7.5

# Backward compatible fields (v2)
scores:
  accessibility: 7.5
  consistency: 8.0
  visual_hierarchy: 6.5
  responsive: 5.0
  maintainability: 7.0
  overall: 6.9

issues:
  - file: "Pages/Home.razor"
    severity: "CRITICAL | MAJOR | MINOR"
    category: "CSS | ACCESSIBILITY | DARK_MODE | CONSISTENCY | RESPONSIVE | FLUENTUI | CSS_DEBT"
    description: "Mô tả ngắn gọn"
    suggestion: "Cách sửa"
    line: 123
    phase: "phase1"

recommendations:
  - category: "REFACTOR | DESIGN_TOKEN | SHARED_COMPONENT | PERFORMANCE | UX | SECURITY | DESIGN_SYSTEM | SLOP"
    description: "Nên làm"
    impact: "HIGH | MEDIUM | LOW"
    effort: "Small | Medium | Large"

summary: "UI Audit v3.1: Phase 0 design (7.5), Phase 1 core (6.9), Phase 2 critique (6.9), Phase 3 security (9.2), Phase 4 cleanup (1MB), Phase 5 anti-slop (7.1) — Overall 7.5"
pipeline_summary: "Phase 0: PASS (design intelligence), Phase 1: PASS (core audit), Phase 2: PASS (UX critique), Phase 3: PASS (security check), Phase 4: SUCCESS (cleanup), Phase 5: PASS (anti-slop check)"
total_issues: 0
breakdown:
  critical: 0
  major: 0
  minor: 0
```
