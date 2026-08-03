---
name: rule-versioning
description: R-VER — Luật versioning. Version bất biến, không ghi đè, backward compatible.
agent: general
---

# R-VER — Versioning

## Rule

Mọi entity (Workflow, Agent, Artifact, Capability, Plugin, Contract) **bắt buộc** có version.

## Bắt buộc

- Version bất biến sau khi publish — không ghi đè, tạo version mới (P004).
- SemVer (MAJOR.MINOR.PATCH) cho public interface (G-001).
- Không phá consumer: backward compatible (P018).
- Artifact immutable + checksum (P010).

| Version | Thay đổi |
|---------|----------|
| MAJOR | breaking change |
| MINOR | thêm tính năng, backward compatible |
| PATCH | sửa lỗi |

## Kiểm tra

- Registry từ chối overwrite version đã tồn tại.
- Doctor báo entity thiếu version.

**Nguồn**: P004 · P010 · P018 · G-001 · G-003