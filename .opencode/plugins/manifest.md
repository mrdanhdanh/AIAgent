---
name: plugin-manifest
description: Plugin Manifest — export counts + metadata; Doctor đọc ngay.
agent: general
---

# Plugin Manifest

## 1. Vai trò

Bổ sung `manifest.yaml` — tổng kết exports để Doctor/registry biết nhanh.

## 2. manifest.yaml

```yaml
manifest:
  id: oracle
  version: 1.0.0
  exports:
    agents: 3
    skills: 2
    commands: 1
    capabilities: 5
    workflows: 1
    knowledge: 12
    doctor_rules: 2
    events: 4
    widgets: 1
    policies: 1
```

## 3. Lợi ích

- **Doctor** đọc nhanh plugin mở rộng gì.
- **Loader** xác minh exports count khớp thực tế.
- **Dashboard** hiển thị tóm tắt plugin.

## 4. Verification

Loader so manifest count vs file thực tế trong package → PLG-007 mismatch warning.

## 5. Tương tác

- `loader.md` — verify.
- `validator.md` — PLG-007.
- Doctor (Phase 8) — đọc plugin health.
- Dashboard (Phase 12) — hiển thị.