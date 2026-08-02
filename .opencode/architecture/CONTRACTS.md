---
name: architecture-contracts
description: CONTRACTS — quy ước thống nhất Input/Output Contract, versioning, validation, compatibility cho Workflow/Agent/Capability/Context/Artifact.
agent: general
---

# CONTRACTS.md — Quy ước Contract

> Tham chiếu xuyên suốt: Phase 1 (Workflow Runtime), Phase 2 (Capability Registry), Phase 5 (Artifact Store) dùng chung chuẩn này.

## 1. Định nghĩa

Contract = khai báo **Input** và **Output** của một đối tượng (Workflow, Agent, Capability, Context, Artifact), kèm quy tắc validation.

| Field | Type | Required | Mô tả |
|-------|------|----------|-------|
| id | string | ✅ | `contract-<object>-<name>` |
| version | string | ✅ | MAJOR.MINOR theo VERSIONING |
| input | Schema | ✅ | cấu trúc đầu vào |
| output | Schema | ✅ | cấu trúc đầu ra |
| validation | enum | ✅ | `strict` / `lenient` |
| error_code | string | ❌ | mã lỗi khi vi phạm (AG-003...) |

## 2. Schema

Schema dùng cú pháp JSON-Schema-lite:

```yaml
input:
  required:
    - requirement
  properties:
    requirement: string
    priority: integer
    context_id: string
output:
  required:
    - plan
  properties:
    plan: artifact
```

## 3. Quy tắc

- **Strict**: output bắt buộc đúng schema; sai → lỗi contract (AG-003 cho agent, ART-003 cho artifact).
- **Lenient**: thiếu field optional được phép, chỉ warning.
- Mọi object có `contracts` field trong data model (DATA_MODEL.md).
- Contract version tăng MINOR khi thêm field optional, MAJOR khi phá schema.

## 4. Contract theo đối tượng

| Object | Contract bắt buộc | Validation |
|--------|-------------------|------------|
| Workflow | input: definition; output: status + artifacts | strict |
| Phase | input: context + dependencies; output: artifact | strict |
| Capability | input/output schema (CR-00x) | strict |
| Agent | input task; output theo capability | strict |
| Skill | input params; output result | lenient |
| Context | scope + data; token count | lenient |
| Artifact | type + checksum + version | strict |

## 5. Validation flow

```text
Component khai báo contract
        ▼
Registry/validator đọc contract
        ▼
Trước khi chạy: validate input (early fail)
        ▼
Chạy
        ▼
Sau khi chạy: validate output
        ▼
Sai → mã lỗi contract → retry/rollback theo ERROR_HANDLING
```

## 6. File tham chiếu

- `contract-registry.yaml` (`.opencode/registry/`)
- `capability-registry.yaml` → mỗi capability khai báo input/output