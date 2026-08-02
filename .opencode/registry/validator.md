---
name: capability-validator
description: Validator — checklist + bảng mã lỗi để capability-registry nhất quán. Document tham chiếu capability-validator.ps1.
agent: general
---

# Capability Validator

## 1. Mục đích

Đảm bảo Capability Registry hợp lệ, phản ánh hiện trạng agents/skills/commands. Chạy qua
`.opencode/scripts/capability-validator.ps1`. Mọi capability/agent/skill/command id unique.

## 2. Bảng mã lỗi

| Code | Mô tả | Mức |
|------|-------|-----|
| CR-001 | Capability id bị trùng trong capabilities.yaml | error |
| CR-002 | Agent/Skill/Command tham chiếu capability không tồn tại | error |
| CR-003 | Capability không có agent nào xử lý (orphan) | warning |
| CR-004 | Agent không khai báo capability nào (empty) | warning |
| CR-005 | Skill/Command có `supports` rỗng | warning |
| CR-006 | Agent/Skill/Command id bị trùng trong registry riêng | error |
| CR-007 | Vòng phụ thuộc giữa các agent (nếu dùng `dependencies`) | error |
| CR-008 | Category không khớp taxonomy | error |
| CR-009 | Registry phản ánh lệch số entity (agent khác 18, skill khác 29 ...) | info |

## 3. Quy tắc

- Capability `id` theo format `<category>.<specific>`, category phải trong taxonomy.
- Mọi id unique toàn vault (nếu có `dependencies` → check acyclic).
- Entity `enabled: true` mặc định được tính vào coverage.
- Report xuất `.opencode/reports/CAPABILITY_COVERAGE.md` (UTF-8 no-BOM).

## 4. Usage

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .opencode\scripts\capability-validator.ps1
# --silent   chỉ exit code
# --report   xuất coverage report
# --fix      tự gợi ý sửa an toàn (không áp tự động)
```

## 5. Exit code
- 0 = PASS (không error)
- 1 = có error