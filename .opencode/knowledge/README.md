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

## Knowledge Index

Ngoài knowledge base này, hệ thống có **Knowledge Index** tại `.opencode/knowledge-index/` — 7 loại index JSON được sinh tự động từ source code + tài liệu:

| Index | Nội dung | Phục vụ |
|-------|----------|---------|
| `code-index.json` | File → classes/methods/fields | `/explain`, `/trace` |
| `symbol-index.json` | Symbol → files | `/where` |
| `api-index.json` | Public methods → callers | `/impact`, `/trace` |
| `database-index.json` | Storage keys / DB objects | `/where`, `/impact` |
| `dependency-graph.json` | Nodes + edges (DI graph) | `/impact`, `/trace`, `/where` |
| `document-index.json` | Docs → sections/headings | `/why`, `/compare-doc` |
| `business-rule-index.json` | Business rules → sources | `/why`, `/compare-doc` |

**Cách dùng:**
- Build lần đầu: `/knowledge-index` hoặc `/knowledge-index --rebuild`
- Cập nhật sau khi source thay đổi: `/knowledge-index --update`
- Xem trạng thái: `/knowledge-index --status`

**Nguyên tắc:** Index = định vị nhanh; knowledge base + file gốc = bằng chứng. Luôn đọc nguồn gốc trước khi kết luận. Chi tiết: `.opencode/knowledge-index/README.md`, script `.opencode/scripts/build-knowledge-index.ps1`.
