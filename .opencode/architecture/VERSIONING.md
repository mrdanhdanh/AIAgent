---
name: architecture-versioning
description: VERSIONING — quy ước version cho Framework, Schema, Workflow, Agent, Capability, Contract, Artifact.
agent: general
---

# VERSIONING.md — Quy ước Version

> Mọi version tuân theo bảng. Dùng cho so sánh và compatibility.

## 1. Quy ước tổng

| Loại | Format | Ví dụ | Thay đổi khi |
|------|--------|-------|---------------|
| Framework | `MAJOR.MINOR.PATCH` | 4.0.0 | v4 major |
| Workflow Schema | `MAJOR.MINOR` | 1.0 | phá schema / thêm field |
| Capability | `MAJOR.MINOR` | 1.0 | contract đổi / thêm provider |
| Agent | `MAJOR.MINOR.PATCH` | 1.0.0 | behavior thay đổi / sửa lỗi |
| Contract | `MAJOR.MINOR` | 1.0 | break input/output |
| Artifact | `vN` | v1, v2 | mỗi lần thay đổi nội dung |
| Workflow run | `WF-YYYYMMDD-XXX` | WF-20260802-004 | mỗi lần chạy |

## 2. Ngữ nghĩa MAJOR.MINOR.PATCH

| Phần | Tăng khi |
|------|----------|
| MAJOR | breaking change, phá tương thích |
| MINOR | thêm tính năng tương thích ngược |
| PATCH | sửa lỗi, không đổi API |

## 3. Version hiện tại

| Loại | Version | Nguồn |
|------|---------|-------|
| Framework | 4.0.0 | roadmap v4 |
| Workflow Schema | 1.0 | workflow.schema.yaml |
| Capability | 1.0 | capability-registry.yaml |
| Agent | 1.0.0 | agent-registry.yaml |
| Contract | 1.0 | contract-registry.yaml |

## 4. Quy tắc

- Không tăng MAJOR nếu không có ADR.
- Mọi file versioned phải khai báo version trong frontmatter.
- Framework version ghi ở `VERSION.md` hoặc README chính (nếu có).
- Thay đổi schema → tăng MINOR và thêm migration note.