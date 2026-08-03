---
name: aios-manifest
description: >
  AIOS Manifest v1.0 Enterprise — Human-readable. Đây là "package.json" của AIOS:
  AIOS là gì, tồn tại để làm gì, giá trị gì, mục tiêu dài hạn.
  Machine-readable: AIOS_MANIFEST.yaml. Validator: manifest.schema.json.
agent: general
---

# AIOS Manifest

> **v1.0 Enterprise** · Đây là file đầu tiên của toàn bộ Framework.
> Manifest là **Executable Specification** thu nhỏ — máy đọc YAML, người đọc đây, validator kiểm tra schema.

## AIOS là gì?

**AIOS (AI Operating System)** là nền tảng điều hành cho AI Agent. **Runtime là trung tâm** — Agent chỉ là thành phần chạy trên Runtime.

Manifest trả lời:
- **AIOS là gì?** → Identity, Mission
- **Tồn tại để làm gì?** → Vision, Goals
- **Có những giá trị nào?** → Design Values
- **Mục tiêu dài hạn là gì?** → Deliverables, Maturity target

## Cấu trúc Manifest

| Nhóm | Nội dung |
|------|----------|
| **Identity** | domain, type, architecture, deployment |
| **Metadata** | kind, apiVersion, manifestVersion, specVersion, constitution |
| **Mission & Vision** | vì sao tồn tại, đích đến |
| **Scope** | included / excluded |
| **Goals** | 6 mục tiêu (không phụ thuộc Principle) |
| **Design Values** | 6 giá trị văn hóa |
| **Quality Attributes** | 8 thuộc tính chất lượng |
| **Architecture Style** | 6 phong cách kiến trúc |
| **Source of Truth** | nơi Runtime/Doctor đọc dữ liệu gốc |
| **Deliverables** | roadmap sản phẩm |
| **Governance** | quy trình ADR/RFC/Release/Review/Approval |
| **Lifecycle** | Draft → Review → Approved → Deprecated |
| **Compatibility** | backward required, forward preferred |
| **Ownership** | owners, license |

## Goals (6 mục tiêu)

- **Standardized Runtime** — Runtime chuẩn hóa, một cách điều phối.
- **Declarative Workflow** — Workflow khai báo, không code.
- **Capability Routing** — gọi Capability, không gọi Agent cụ thể.
- **AI Native** — mọi thứ machine-readable + human-readable.
- **Extensible Architecture** — mở rộng qua Plugin/SDK, không sửa core.
- **Observable Execution** — mọi hoạt động có vết.

## Design Values (6 giá trị)

- **Simplicity** — đơn giản trước, đủ dùng.
- **Explicitness** — khai báo rõ, không ẩn.
- **Consistency** — nhất quán mọi nơi.
- **Predictability** — hành xử đoán trước được.
- **Composability** — ghép được thành phần.
- **Reusability** — tái sử dụng được.

## Thư mục

```text
docs/manifest/
├── AIOS_MANIFEST.yaml    # Machine-readable (Runtime đọc)
├── README.md             # Human-readable (bạn đang đọc)
├── manifest.schema.json  # Validator kiểm tra
└── CHANGELOG.md          # Theo dõi thay đổi
```

## Tham chiếu

- Glossary: `docs/glossary/`
- Core Principles: `docs/principles/`
- Constitution: `docs/specs/SPEC-000/`
- Manifest schema: `manifest.schema.json`
