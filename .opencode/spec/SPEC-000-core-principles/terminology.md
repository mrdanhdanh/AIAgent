---
name: spec-000-terminology
description: SPEC-000 terminology — thuật ngữ chuẩn AIOS, dùng chung cho mọi SPEC.
agent: general
---

# SPEC-000 — Terminology

## 1. Core terms

| Thuật ngữ | Định nghĩa |
|-----------|-----------|
| AIOS | AI Operating System — nền tảng điều phối AI agent/workflow |
| Agent | thực thể thực thi một capability; stateless, nhận input → trả output |
| Capability | khả năng hệ thống làm được; không phụ thuộc agent |
| Workflow | chuỗi phase có trạng thái, điều phối agent theo capability |
| Phase | bước trong workflow (analysis, planning, build...) |
| Context | package dữ liệu cấp cho agent trước khi chạy |
| Artifact | object có version/checksum/lineage; output của agent |
| Event | thông báo bất biến về state change; có lineage |
| Contract | hợp đồng giao tiếp (input/output) giữa các thành phần |
| Entity | thực thể cơ bản: id + type + version + status + metadata |
| Registry | nơi đăng ký capability/agent/skill/command |
| Kernel | lõi điều phối: scheduler, state machine, resource |

## 2. State terms

| Thuật ngữ | Định nghĩa |
|-----------|-----------|
| State | trạng thái runtime (thuộc Runtime, không thuộc agent) |
| Status | mức trưởng thành khai báo (draft/stable/deprecated) |
| Transition | thay đổi state, luôn phát event |
| Lifecycle | vòng đời thực thể (created → archived) |

## 3. Version terms

| Thuật ngữ | Định nghĩa |
|-----------|-----------|
| Version | số nguyên tăng dần, immutable |
| Supersede | version mới thay thế version cũ |
| Backward compatible | consumer cũ vẫn chạy với version mới |
| Migration | chuyển từ version cũ sang mới |

## 4. Nguyên tắc từ vựng

- Viết hoa entity/event type (WORKFLOW_STARTED, PLAN_COMPLETED).
- id lowercase, hyphen (planner, implementation.code).
- Không dùng thuật ngữ trùng nghĩa — mỗi khái niệm một tên.