---
name: workflow-runtime-manifest
description: manifest — Phase 1.20 + 1.23: Workflow Runtime tự khai báo (version, schema, supports, dependencies) + Runtime Manifest Generator (runtime-manifest.json).
agent: general
---

# manifest.md — Runtime Manifest & Generator

> Runtime **tự khai báo** năng lực + sinh `runtime-manifest.json` để Doctor đọc.

## 1. Runtime Manifest (1.20)

```yaml
runtime:
  version: 4.0
  schema: 1.0
  supports:
    - workflow
    - compiler
    - recovery
    - persistence
  dependencies:
    - registry >= 1.0
    - context >= 1.0
```

| Field | Mô tả |
|-------|-------|
| version | framework version |
| schema | schema version |
| supports | module runtime hỗ trợ |
| dependencies | yêu cầu ngoài (registry/context) |

Doctor kiểm tra compatibility: workflow.manifest.required_components ↔ runtime.supports.

## 2. Manifest Generator (1.23)

Runtime tự sinh:

```json
{
  "runtime": "4.0",
  "schema": "1.0",
  "compiler": true,
  "scheduler": true,
  "recovery": true,
  "state_machine": true,
  "features": {
    "events": false,
    "simulation": false
  },
  "dependencies": {
    "registry": ">=1.0",
    "context": ">=1.0"
  }
}
```

- Sinh tại boot / khi chạy Doctor.
- Phản ánh `features` hiện bật (feature-flags.md).

## 3. Quy tắc

- Manifest là **nguồn sự thật** để Doctor/Plugin kiểm tra.
- Không hard-code manifest — luôn sinh từ runtime thực (thuộc tính thật).
- Khi thêm module → manifest tự thêm (generator đọc registry module).

## 4. Tương tác

- `feature-flags.md` (features bật/tắt)
- `compatibility.md` (so khớp với workflow manifest)
- `health.md`/Doctor (đọc manifest)