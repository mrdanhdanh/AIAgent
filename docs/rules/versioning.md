---
name: rule-versioning
description: R-VER — Luật versioning. Version bất biến, không ghi đè, backward compatible.
agent: general
---

# R-VER — Versioning

## Rule

Mọi entity (Workflow, Agent, Artifact, Capability, Plugin, Contract) **bắt buộc** có version.

## Bắt buộc

- Version bất biến sau khi publish — không ghi đè, tạo version mới (P009).
- SemVer (MAJOR.MINOR.PATCH) cho public interface (G-001).
- Không phá consumer: backward compatible (P015).
- Artifact immutable + checksum (P013).

| Version | Thay đổi |
|---------|----------|
| MAJOR | breaking change |
| MINOR | thêm tính năng, backward compatible |
| PATCH | sửa lỗi |

## Kiểm tra

- Registry từ chối overwrite version đã tồn tại.
- Doctor báo entity thiếu version.

**Nguồn**: P009 · P013 · P015 · G-001 · G-003