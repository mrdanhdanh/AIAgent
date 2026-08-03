---
name: aios-principles
description: >
  AIOS Principles — index danh sách Core Principles (P001-P015), Architecture
  Principles (A-001..006), Governance Principles (G-001..007). Mỗi principle
  được định nghĩa chi tiết trong file riêng (P001-runtime-first.md...).
agent: general
---

# AIOS Principles

> Sprint 0.0 / Milestone 0. Danh sách nguyên tắc bất biến của AIOS.
> Mọi SPEC/ADR/Code phải tuân theo. Không mâu thuẫn.
> Sau khi freeze, mỗi principle được viết chi tiết thành file riêng
> (`P001-runtime-first.md`, `P002-contract-first.md`, ...).

## Core Principles (P001–P015)

| ID | Tên | Mô tả ngắn |
|----|-----|-----------|
| P001 | Runtime First | Runtime là trung tâm điều phối; Agent không điều phối Agent |
| P002 | Contract First | Mọi giao tiếp qua Contract, có thể kiểm tra |
| P003 | Metadata First | Mọi object có metadata, machine-readable |
| P004 | Event Driven | Mọi state change đều phát Event |
| P005 | Stateless Agents | Agent không giữ state; state thuộc Runtime |
| P006 | Capability Driven | Tách "cần làm gì" khỏi "ai làm" |
| P007 | Discoverable | Không hard-code tham chiếu; tìm qua Registry |
| P008 | Observable | Mọi hoạt động đo được |
| P009 | Versioned | Không ghi đè; tạo version mới, rollback được |
| P010 | Plugin First | Mở rộng qua Plugin, không sửa core |
| P011 | Simulation Before Execution | Dự đoán trước khi chạy thật |
| P012 | Single Source of Truth | Không duplicate state |
| P013 | Immutable Artifacts | Artifact toàn vẹn + reproducible |
| P014 | Least Privilege | An toàn, quyền tối thiểu |
| P015 | Backward Compatible | Không phá consumer khi thay đổi |

## Architecture Principles (A-001..A-006)

| ID | Tên | Mô tả ngắn |
|----|-----|-----------|
| A-001 | Layer Model | Phân tầng rõ ràng, phụ thuộc một chiều |
| A-002 | Dependency Rules | Không vòng lặp dependency |
| A-003 | Execution Model | Cơ chế thực thi thống nhất |
| A-004 | Communication Model | Giao tiếp qua Runtime, không trực tiếp |
| A-005 | Data Model | Metadata-first, data machine-readable |
| A-006 | Object Model | Entity thống nhất (id/type/version/status) |

## Governance Principles (G-001..G-007)

| ID | Tên | Mô tả ngắn |
|----|-----|-----------|
| G-001 | Versioning | SemVer, backward compatible |
| G-002 | Naming | Quy ước tên nhất quán |
| G-003 | Compatibility | Không phá consumer |
| G-004 | Deprecation | Có window, có replacement |
| G-005 | RFC | Đề xuất thay đổi qua RFC |
| G-006 | ADR | Quyết định kiến trúc ghi ADR |
| G-007 | Decision Hierarchy | Thứ tự ưu tiên quyết định |

## Tham chiếu

- Chi tiết Core Principles: `principles.md`
- Chi tiết Architecture: `architecture-principles.md`
- Chi tiết Governance: `governance.md`
- Manifest liệt kê P001–P015: `docs/manifest/AIOS_MANIFEST.yaml`
