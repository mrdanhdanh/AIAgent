---
name: aios-rules
description: >
  AIOS Architecture Rules (D004) — 13 rules kiến trúc bắt buộc (RULE-001..013).
  Không mô tả implementation — chỉ luật: được phép / không được phép / phụ thuộc /
  giao tiếp. Đây là điểm bắt đầu của kiến trúc thực sự.
agent: general
---

# AIOS Architecture Rules

> **D004** — D001–D003 trả lời "là gì", D004 trả lời:
> **"Các thành phần được phép tương tác với nhau như thế nào."**
> Đây là tài liệu mà Runtime, Doctor, Validator, Dashboard đều sử dụng.

## Index (13 Rules)

| ID | File | Category | Luật (tóm tắt) |
|----|------|----------|-----------------|
| RULE-001 | `RULE-001-layering.md` | Architecture | Phân tầng một chiều; chỉ gọi layer ngay dưới |
| RULE-002 | `RULE-002-dependency.md` | Architecture | Mọi dependency explicit; Runtime chỉ đọc Registry |
| RULE-003 | `RULE-003-communication.md` | Architecture | Mọi giao tiếp qua Contract; 4 loại |
| RULE-004 | `RULE-004-execution.md` | Execution | Execution theo sequence chuẩn |
| RULE-005 | `RULE-005-state.md` | State | State chỉ tồn tại Runtime |
| RULE-006 | `RULE-006-data-flow.md` | Data | Context→Agent→Artifact; không Agent→Agent |
| RULE-007 | `RULE-007-event.md` | Event | Mọi thay đổi phát Event; Event immutable |
| RULE-008 | `RULE-008-security.md` | Security | Quyền tối thiểu theo thành phần |
| RULE-009 | `RULE-009-versioning.md` | Data | Mọi object có version; không overwrite |
| RULE-010 | `RULE-010-extension.md` | Architecture | Không sửa Core; mở rộng qua Plugin |
| RULE-011 | `RULE-011-resource-ownership.md` | Data | Mỗi thành phần chỉ sở hữu tài nguyên của mình |
| RULE-012 | `RULE-012-failure-isolation.md` | Reliability | Agent lỗi không làm sập Runtime |
| RULE-013 | `RULE-013-deterministic-execution.md` | Reliability | Cùng input → cùng output |

## Layering (RULE-001)

```text
Presentation
    ↓
Command
    ↓
Workflow
    ↓
Runtime
    ↓
Capability
    ↓
Registry
    ↓
Agent
    ↓
Skill
    ↓
Infrastructure
```

Chỉ được gọi xuống. Không được gọi ngược. Không vượt tầng. Không circular dependency.

## Template

Mọi rule dùng chung template:

```yaml
id: RULE-001
name: Layering
status: Stable
version: 1.0.0
category: Architecture
statement:
purpose:
rules:
constraints:
  allowed:
  forbidden:
examples:
related_principles:
related_rules:
verification:
```

## Machine-readable

- **`architecture.yaml`** — 9 layers + `depends_on` + `term_layer` map. Doctor sinh Dependency Graph + Layer Diagram từ đây.
- **`INDEX.yaml`** — 13 rules + category + dependencies. Doctor kiểm tra vi phạm, Dashboard hiển thị tuân thủ.
- **`rules.schema.json`** — validate rule template.

## Tham chiếu

- Glossary: `docs/glossary/` (16 terms)
- Principles: `docs/principles/` (P001–P020)
- Manifest: `docs/manifest/AIOS_MANIFEST.yaml`
