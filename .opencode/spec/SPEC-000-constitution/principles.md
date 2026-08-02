---
name: spec-000-principles
description: SPEC-000 Part II — Constitutional Principles P001-P015. Trái tim của AIOS.
agent: general
---

# Part II — Constitutional Principles

15 nguyên tắc hiến pháp. Mọi SPEC/ADR/Code phải tuân theo. Không mâu thuẫn.

## P001 — Runtime First
Runtime là trung tâm. **Không Agent nào được điều phối Agent khác** — mọi điều phối qua Runtime.

## P002 — Contract First
Mọi giao tiếp phải thông qua **Contract**. Không gọi trực tiếp, không truyền tùy ý.

## P003 — Metadata First
Mọi object đều có **metadata** (id, type, version, status). Không hard-code đặc tính trong code.

## P004 — Everything is Versioned
Không ghi đè. Mọi thực thể có version. Version cho phép rollback, A/B, backtest, migration.

## P005 — Everything Emits Events
Mọi thay đổi trạng thái đều phát **Event**. Event immutable, có lineage, là nguồn sự thật.

## P006 — Everything is Discoverable
Mọi capability/agent/skill/command có thể được **tìm thấy** qua Registry. Không hard-code tham chiếu.

## P007 — Everything is Observable
Mọi hoạt động **đo được** (metrics, traces, events). Observability là mặc định.

## P008 — Capability Driven
Workflow gọi **capability**, không gọi agent. Agent là implementation của capability; Resolver chọn.

## P009 — Stateless Agents
Agent không giữ trạng thái giữa các lần gọi. Mọi trạng thái thuộc Runtime. Stateless → scale/replay/test/failover dễ.

## P010 — Plugin First
Mở rộng qua **Plugin**, không sửa core. Core đóng, extension mở.

## P011 — Simulation Before Execution
Thay đổi lớn phải **mô phỏng trước** khi thực thi. Proposal phải backtest trước apply.

## P012 — Single Source of Truth
Mỗi thông tin chỉ có **một nguồn chính thức**. Không duplicate state ở nhiều nơi.

## P013 — Immutable Artifacts
Artifact **không sửa sau khi tạo**. Thay đổi = tạo version mới. Checksum đảm bảo toàn vẹn.

## P014 — Least Privilege
Chỉ cấp **quyền tối thiểu** cần thiết. Plugin/agent chạy trong sandbox theo permission.

## P015 — Backward Compatibility
Thay đổi phải **giữ tương thích ngược**. Breaking cần deprecation window + migration.

## Bảng tóm tắt

| # | Nguyên tắc | Câu hỏi kiểm tra |
|---|-----------|------------------|
| P001 | Runtime First | Agent có tự điều phối agent khác? |
| P002 | Contract First | Giao tiếp có qua contract? |
| P003 | Metadata First | Object có metadata? |
| P004 | Versioned | Có ghi đè không? |
| P005 | Events | State change có phát event? |
| P006 | Discoverable | Tìm qua Registry được không? |
| P007 | Observable | Đo được không? |
| P008 | Capability Driven | Gọi capability hay agent? |
| P009 | Stateless | Agent có giữ state? |
| P010 | Plugin First | Mở rộng qua plugin? |
| P011 | Simulate First | Đã mô phỏng trước khi chạy? |
| P012 | Single Source | Có duplicate source of truth? |
| P013 | Immutable Artifacts | Có sửa artifact sau khi tạo? |
| P014 | Least Privilege | Cấp quyền tối thiểu chưa? |
| P015 | Backward Compat | Breaking có deprecation? |