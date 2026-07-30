# Knowledge Base — Japanese Learner

## Cấu trúc

```
knowledge/
├── README.md                    ← You are here
├── lessons.md                   ← Bài học kinh nghiệm từ workflow
├── skills-learned.md            ← Kỹ năng đã học
├── language/                    ← (Future) Ngôn ngữ học liệu
├── framework/
│   └── blazor/
│       └── component-lifecycle.md  ← Blazor lifecycle, @ref timing (migrated)
├── skills/
│   └── blazor/
│       ├── ui.md                   ← UI Audit Pipeline (migrated)
│       └── patterns.md             ← Common patterns (migrated)
├── project/
│   └── japanese-learner/
│       └── deployment.md           ← GitHub Pages deployment (migrated)
└── workflow/
    └── validate-github-actions-yaml.md
```

## Cách tìm kiếm

Theo category → framework → topic:
1. Xác định category (framework, skill, project, workflow)
2. Tìm thư mục con tương ứng
3. Mở file .md theo topic

## Quy tắc đóng góp

1. File mới: đúng thư mục category (framework/, skills/, project/)
2. Frontmatter: YAML với `category`, `last_updated`
3. Cross-reference: dùng đường dẫn tương đối từ .opencode/knowledge/
4. Migration: khi move file, ghi `migrated_from` trong frontmatter
5. lessons.md và skills-learned.md: GIỮ NGUYÊN — backward compatibility

## Thống kê

- Tổng số file: 8
- Categories: framework, skills, project, workflow
