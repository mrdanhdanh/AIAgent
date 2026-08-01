---
description: Đánh giá sức khỏe kiến thức hệ thống — phát hiện thiếu README, diagram, flow, ADR, comment, tài liệu lỗi thời
agent: knowledge-agent
schema_version: "1.0"
---

## HELP — Hướng dẫn sử dụng `/knowledge-health`

**Mục đích:** Đánh giá "sức khỏe kiến thức" của codebase — tài liệu thiếu (README, diagram, flow, ADR, comment), coverage docs so với code. Output Health Score.

**Cách dùng:** `/knowledge-health` (quét toàn bộ) hoặc `/knowledge-health <module>`

**Đầu ra:** Health score + danh sách thiếu sót + gợi ý cải thiện.

## NỘI DUNG

Bạn là **Knowledge Agent**. Đánh giá sức khỏe kiến thức của codebase:

$ARGUMENTS

## QUY TRÌNH

1. **Quét code** — glob Pages/, Services/, Models/, đếm files, ghi chú module
2. **Quét docs** — glob .md: AGENTS.md, PRODUCT.md, .opencode/knowledge/**, docs theo module
3. **Checklist đánh giá**:

| Hạng mục | Tiêu chí |
|----------|----------|
| README | Có README gốc + knowledge/README.md? |
| Diagram | Có sơ đồ kiến trúc/flow trong docs? |
| Flow | Module có mô tả workflow không? |
| ADR | Có ghi quyết định thiết kế + lý do? |
| Comment | Code có comment giải thích "why" không? |
| Coverage | Mỗi module/service có doc tương ứng? |

4. **Tính Health Score** — 0-100 (mỗi hạng mục 0-20)
5. **Tổng hợp** (skill `answer-builder`)

## QUY TẮC

- Score dựa trên evidence thực tế (file tồn tại hay không)
- Liệt kê cụ thể file thiếu, không chung chung
- Gợi ý hành động ưu tiên

## Output Contract

```yaml
status: "READY"
intent: "health"
health_score: 72
categories:
  - { name: "README", score: 20, detail: "Có AGENTS.md + knowledge/README.md" }
  - { name: "Diagram", score: 10, detail: "Thiếu sơ đồ kiến trúc" }
  - { name: "Flow", score: 15, detail: "Một số module thiếu flow doc" }
  - { name: "ADR", score: 5, detail: "Thiếu ADR cho quyết định cache-first" }
  - { name: "Coverage", score: 22, detail: "5/5 services có doc pattern" }
missing:
  - "Thiếu: diagram kiến trúc, ADR cache-first"
recommendations:
  - "Thêm architecture diagram vào knowledge/"
  - "Ghi ADR cho quyết định cache-first storage"
```
