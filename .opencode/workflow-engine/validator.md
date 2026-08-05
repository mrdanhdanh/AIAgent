---
name: workflow-engine-validator
description: >
  Validator cho Workflow Engine v4 — checklist validate khop workflow-validator.ps1,
  bang ma loi WF-ERR-001..009 va quy tac dung workflow.
agent: general
---

# Validator

Validate definition workflow truoc khi chay. Checklist nay phai khop
`.opencode/scripts/workflow-validator.ps1` (parser YAML subset).

## 1. Checklist validate

1. **Required keys top-level**: `id`, `name`, `version`, `description`, `phases`.
2. **Moi phase required**: `id`, `title`, va dung 1 trong `agent` | `command`.
3. **Phase id khong trung lap** trong cung workflow.
4. **depends_on** tro phase id ton tai.
5. **Khong cycle** (DFS — detect chuoi cycle).
6. **agent** thuoc 18 agents (`.opencode/agents/*.md`, BaseName khong duoi).
   - Khong hardcode 18 — scan dir dong (validator.ps1 cung vay).
7. **command** thuoc 53 commands (`.opencode/commands/*.md`, BaseName bo dau '/'),
   cho phep them `backup`.

## 2. Bang ma loi

| Code | Y nghia | Muc do | Dung workflow? |
|------|---------|--------|----------------|
| WF-ERR-001 | file missing (definition khong ton tai) | CRITICAL | Dung |
| WF-ERR-002 | YAML parse fail | CRITICAL | Dung |
| WF-ERR-003 | missing required key (top-level hoac phase) | MAJOR | Dung |
| WF-ERR-004 | duplicate phase id | CRITICAL | Dung |
| WF-ERR-005 | depends_on khong ton tai | CRITICAL | Dung |
| WF-ERR-006 | cycle detected | CRITICAL | Dung |
| WF-ERR-007 | agent khong ton tai | CRITICAL | Dung |
| WF-ERR-008 | command khong ton tai | MAJOR | Dung (hoac bo qua phase) |
| WF-ERR-009 | invalid --workflow id (kem danh sach 6 definitions) | MAJOR | Dung (engine) |

Loi CRITICAL (001, 002, 004, 005, 006, 007) -> dung workflow ngay.

## 3. Format loi

Moi loi ghi:

```yaml
error:
  code: WF-ERR-005
  description: "depends_on tro phase id khong ton tai"
  file: ".opencode/workflow/definitions/docs.workflow.yaml"
  line: 14
  suggestion: "Sua 'depends_on: [analysis]' thanh [analyze]"
```

## 4. Output contract

```yaml
validation_output:
  status: "PASS" | "FAIL"
  file: string
  errors:
    - code: string
      description: string
      file: string
      line: int | null
      suggestion: string | null
  summary:
    total_errors: int
    critical_count: int
```

## 5. Checklist

- [ ] 7 muc checklist validate duoc thuc hien day du.
- [ ] Bang ma loi WF-ERR-001..009 day du, dung nghia.
- [ ] KHONG viet `#` truoc WF-ERR-00x.
- [ ] Loi CRITICAL -> dung workflow.
- [ ] Validator.ps1 khop: no-tab, no-BOM, required keys, dups, depends_on, cycle, agent, command.
