# Knowledge Base — Japanese Learner

## Cấu trúc

```
knowledge/
├── README.md                    ← You are here
├── lessons.md                   ← Bài học kinh nghiệm từ workflow
├── skills-learned.md            ← Kỹ năng đã học
├── language/                    ← (Future) Ngôn ngữ học liệu
├── framework/
│   ├── blazor/
│   │   └── component-lifecycle.md  ← Blazor lifecycle, @ref timing (migrated)
│   └── fluentu/
│       ├── fluentu.md              ← FluentUI 4.14.3 overview
│       └── design-tokens.md        ← Design tokens, FluentDesignTheme
├── skills/
│   └── blazor/
│       ├── ui.md                   ← UI Audit Pipeline (migrated)
│       └── patterns.md             ← Common patterns (migrated)
├── patterns/
│   ├── localstorage.md             ← Cache-first + Blazored.LocalStorage
│   └── seed-data-patterns.md       ← Seed data on first load
├── testing/
│   ├── xunit-bunit-testing.md      ← xUnit + bUnit + MockStorageService
│   └── playwright-e2e.md           ← Playwright E2E (port 5173)
├── ui/
│   ├── fluentui-components.md      ← Components dùng trong project
│   ├── dark-mode-theming.md        ← ThemeService dark mode
│   └── tri-state-rendering.md      ← Loading → Empty → Data
├── project/
│   └── japanese-learner/
│       └── deployment.md           ← GitHub Pages deployment (migrated)
└── workflow/
    └── validate-github-actions-yaml.md
```

## Cách tìm kiếm

Theo category → framework → topic:
1. Xác định category (framework, skill, project, workflow, pattern, testing, ui)
2. Tìm thư mục con tương ứng
3. Mở file .md theo topic

## Quy tắc đóng góp

1. File mới: đúng thư mục category (framework/, skills/, patterns/, testing/, ui/, project/)
2. Frontmatter: YAML với `category`, `last_updated`
3. Cross-reference: dùng đường dẫn tương đối từ .opencode/knowledge/
4. Migration: khi move file, ghi `migrated_from` trong frontmatter
5. lessons.md và skills-learned.md: GIỮ NGUYÊN — backward compatibility

## Thống kê

- Tổng số file: 17
- Categories: framework, skills, patterns, testing, ui, project, workflow
