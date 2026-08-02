---
name: spec-000-terminology
description: SPEC-000 Glossary — bảng thuật ngữ chuẩn AIOS, dùng chung cho mọi SPEC.
agent: general
---

# SPEC-000 — Glossary

Bảng thuật ngữ thống nhất (tham chiếu từ Chương 16).

## 1. Core terms

| Thuật ngữ | Định nghĩa |
|-----------|-----------|
| AIOS | AI Operating System — nền tảng điều hành cho AI Agent |
| Runtime | trung tâm điều phối; mọi thứ chạy qua Runtime |
| Agent | thực thể thực thi capability; stateless |
| Capability | khả năng hệ thống làm được; không phụ thuộc agent |
| Workflow | chuỗi phase có trạng thái, điều phối agent theo capability |
| Phase | bước trong workflow (analysis, planning, build...) |
| Task | đơn vị công việc cụ thể |
| Context | package dữ liệu cấp cho agent trước khi chạy |
| Artifact | object có version/checksum/lineage; output của agent |
| Event | thông báo bất biến về state change; có lineage |
| Contract | hợp đồng giao tiếp (input/output) giữa các thành phần |
| Entity | thực thể cơ bản: id + type + version + status + metadata |
| Registry | nơi đăng ký capability/agent/skill/command |
| Kernel | lõi điều phối: scheduler, state machine, resource |

## 2. State & Status

| Thuật ngữ | Định nghĩa |
|-----------|-----------|
| State | trạng thái runtime (thuộc Runtime, không thuộc agent) |
| Status | mức trưởng thành khai báo (draft/stable/deprecated) |
| Transition | thay đổi state, luôn phát event |
| Lifecycle | vòng đời thực thể (created → archived) |

## 3. Version & Compatibility

| Thuật ngữ | Định nghĩa |
|-----------|-----------|
| Version | số nguyên tăng dần, immutable |
| Supersede | version mới thay thế version cũ |
| Backward compatible | consumer cũ vẫn chạy với version mới |
| Migration | chuyển từ version cũ sang mới |
| Deprecation | đánh dấu cũ, giữ window rồi gỡ |

## 4. Error

| Thuật ngữ | Định nghĩa |
|-----------|-----------|
| Recoverable | lỗi có thể tiếp tục |
| Retryable | transient, retry có thể thành công |
| Fatal | không thể tiếp tục, abort |
| Ignored | không ảnh hưởng kết quả |

## 5. Nguyên tắc từ vựng

- Entity/event type: UPPER_SNAKE.
- id: lowercase-hyphen.
- Không trùng nghĩa — mỗi khái niệm một tên.
- Viết hoa khi là tên riêng (SPEC, ADR, RFC, AIOS).