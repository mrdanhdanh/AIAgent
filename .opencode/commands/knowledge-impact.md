---
description: Phân tích ảnh hưởng khi sửa một symbol/file — affected screens, services, models, tests kèm mức độ
agent: knowledge-agent
---

## HELP — Hướng dẫn sử dụng `/knowledge-impact`

**Mục đích:** Phân tích "Nếu sửa X thì ảnh hưởng những gì?" — liệt kê affected screens, services, models, tests kèm mức độ ảnh hưởng.

**Cách dùng:** `/knowledge-impact <symbol|file>`

**Ví dụ:** `/knowledge-impact WordService`, `/knowledge-impact Package XXX`, `/knowledge-impact JapaneseWord`

## NỘI DUNG

Bạn là **Knowledge Agent**. Phân tích ảnh hưởng khi sửa:

$ARGUMENTS

## QUY TRÌNH

1. **Xác định target** — symbol/file cần sửa
2. **Tìm dependents** (skill `dependency-analyzer` + `search-engine`):
   - `@inject <Interface>` trong Pages/
   - reference trong Services/, Models/, Tests/, E2ETests/
   - DI registration trong Program.cs
3. **Phân loại mức độ** (skill `impact-analyzer`):
   - HIGH: breaking change signature
   - MEDIUM: behavior change
   - LOW: nội bộ
4. **Nhóm theo type** — screens / services / models / tests / config
5. **Tổng hợp** (skill `answer-builder`) — kèm recommendation

## QUY TẮC

- Mọi affected file có `reason` dựa trên evidence
- Gợi ý số file cần cập nhật
- Phân biệt tests riêng

## Output Contract

```yaml
status: "READY | NO_RESULT"
intent: "impact"
entity: "Target cần sửa"
impact_summary: "Sửa X ảnh hưởng N files"
affected:
  - { type: "screen|service|model|test|config", file: "...", impact_level: "HIGH|MEDIUM|LOW", reason: "..." }
dependency_path: "A → B → C"
recommendation: "Ước tính số file cần cập nhật"
sources: ["Pages/WordStudy.razor:5"]
```

## Flags:

| Flag | Y nghia |
|------|---------|
| `--api` | Chi affected API |
| `--screen` | Chi affected screens |
| `--all` | Toan bo affected |

