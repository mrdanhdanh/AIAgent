---
name: spec-000-glossary
description: SPEC-000 Appendix A — Glossary. Thuật ngữ chuẩn, mỗi từ một nghĩa.
agent: general
---

# Appendix A — Glossary

Mỗi thuật ngữ **một nghĩa duy nhất** — không hiểu nhiều cách (Chương 5).

## Core

| Thuật ngữ | Định nghĩa |
|-----------|-----------|
| AIOS | AI Operating System — nền tảng điều hành cho AI Agent |
| Runtime | trung tâm điều phối; mọi thứ chạy qua Runtime |
| Agent | thực thể thực thi capability; stateless |
| Capability | khả năng hệ thống làm được; không phụ thuộc agent |
| Workflow | chuỗi phase có trạng thái |
| Phase | bước trong workflow |
| Task | đơn vị công việc |
| Command | lệnh cài sẵn framework |
| Skill | kiến thức/kỹ năng cho agent |
| Plugin | gói mở rộng |

## Dữ liệu

| Thuật ngữ | Định nghĩa |
|-----------|-----------|
| Metadata | thông tin thực thể (id/type/version/status) |
| Artifact | output versioned + checksum + lineage |
| Context | package dữ liệu cho agent |
| Knowledge | lessons/patterns/graph |
| Memory | working/session/failure |
| Contract | hợp đồng giao tiếp |

## Trạng thái

| Thuật ngữ | Định nghĩa |
|-----------|-----------|
| State | trạng thái runtime (thuộc Runtime) |
| Status | mức trưởng thành khai báo |
| Event | thông báo bất biến, có lineage |

## Tài liệu

| Thuật ngữ | Định nghĩa |
|-----------|-----------|
| SPEC | đặc tả chi tiết |
| ADR | quyết định kiến trúc |
| RFC | đề xuất thay đổi |
| Constitution | hiến pháp (SPEC-000) |