---
name: agent-validation
description: validator — checklist kiểm tra Agent Object: schema, capability, prompt, contract, dependency, compatibility.
agent: general
---

# Agent Validation

> Mỗi Agent là package 4 lớp. Trước khi Runtime dùng, phải validate.
> Gate Phase 3 chạy `.opencode/scripts/agent-validator.ps1`.

## 1. Checklist

| # | Mã | Kiểm tra | Lỗi nếu |
|---|-----|----------|---------|
| 1 | AG-001 | Schema | thiếu required field (id, name, version, status, priority) |
| 2 | AG-002 | Capability | `supports` ref id capability không tồn tại trong capabilities.yaml |
| 3 | AG-003 | Entry prompt | `behavior.entry_prompt` file không tồn tại |
| 4 | AG-004 | Contract | contract ref không tồn tại trong input/output.schema.yaml |
| 5 | AG-005 | Dependency | `requires` ref capability chưa có trong capabilities.yaml |
| 6 | AG-006 | Compatibility | compatibility constraint sai format |
| 7 | AG-007 | Status | status không nằm trong enum |
| 8 | AG-008 | Duplicate | id agent trùng trong metadata/ |
| 9 | AG-009 | Framework | requires_framework ⊆ frameworks (nếu khai) |

## 2. Validation sequence

```text
Parse agent.yaml
   ↓
Identity check (AG-001, AG-007, AG-008)
   ↓
Capability check (AG-002, AG-005)
   ↓
Behavior check (AG-003, AG-004)
   ↓
Compatibility check (AG-006, AG-009)
   ↓
PASS → Ready / FAIL → CRITICAL
```

## 3. Mức độ

- CRITICAL → agent bị Bỏ (exclude) khoi resolver, workflow không chọn.
- WARNING → agent được dùng nhưng báo trong report.

## 4. Output

Validator xuất:
- Số agent PASS / FAIL / WARNING.
- Enum `exit 0` (agent hợp lệ), `exit 1` (có CRITICAL).
- Report JSON tại `.opencode/reports/```.

## 5. Tương tác

- `state-machine.md` T2 (Validated) dùng checklist này.
- Doctor (Phase 8) gọi lại validator để tính health.
- CLI: `agent-validator.ps1`.