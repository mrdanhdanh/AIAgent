---
name: spec-000-principles
description: SPEC-000 Part II — Core Principles (P-001..015), Architectural Constraints, Quality Attributes.
agent: general
---

# Part II — Architecture Principles

## Chương 5 — Core Principles

Trái tim của AIOS. 15 nguyên tắc bất biến.

### P-001 — Runtime First
Runtime là trung tâm. Mọi thứ chạy qua Runtime. Agent chỉ là thành phần chạy trên Runtime.

### P-002 — Everything is Metadata
Mọi thực thể (workflow, agent, artifact, capability) được mô hình hóa bằng metadata. Không hard-code đặc tính trong code. Metadata là nguồn cho resolver/scheduler/doctor/dashboard.

### P-003 — Everything is Versioned
Không ghi đè. Mọi thực thể có version. Version cho phép rollback, A/B, backtest, migration.

### P-004 — Everything is Contract
Mọi giao tiếp qua contract + schema. Contract versioned, backward compatible. Không giao tiếp tự do ngoài contract.

### P-005 — Everything Emits Events
Thay đổi trạng thái đều phát event. Event immutable, có lineage. Event là nguồn sự thật (source of truth).

### P-006 — Stateless Agents
Agent không giữ trạng thái giữa các lần gọi. Mọi trạng thái thuộc Runtime. Stateless → scale/replay/test/failover dễ.

### P-007 — Capability Driven
Workflow gọi capability, không gọi agent. Agent là implementation của capability. Resolver chọn agent phù hợp.

### P-008 — Plugin First
Mở rộng qua plugin, không sửa core. Core đóng, extension mở.

### P-009 — Single Source of Truth
Mỗi thông tin chỉ có một nguồn chính thức. Không duplicate state ở nhiều nơi. Graph/Registry là nguồn.

### P-010 — Simulation Before Execution
Thay đổi lớn phải mô phỏng trước khi thực thi. Proposal phải backtest trước apply. Giảm rủi ro/cost.

### P-011 — Observable by Default
Mọi hoạt động đo được (metrics, traces, events). Observability là mặc định, không phải add-on.

### P-012 — Fail Explicitly
Lỗi được phân loại rõ (recoverable/retryable/fatal/ignored). Không nuốt lỗi. Lỗi có mã + context.

### P-013 — Configuration over Coding
Hành vi cấu hình bằng metadata/config, không viết code. Policy, budget, rules = dữ liệu.

### P-014 — Machine Readable by Default
Output dạng schema/json. AI đọc được. Không chỉ prose.

### P-015 — Backward Compatible by Default
Thay đổi phải giữ backward compatibility. Breaking cần deprecation window + migration.

## Chương 6 — Architectural Constraints

Các luật bắt buộc:

- **Core không được phụ thuộc Plugin.**
- **Agent không gọi Agent** — giao tiếp qua Runtime/Event.
- **Không truy cập Artifact trực tiếp** — qua Artifact Store/API.
- **Không đọc file bypass Runtime.**
- **Không sửa Metadata lúc Runtime.**
- **Không bypass Event Bus** — state change phải phát event.
- **Không bypass Contract** — mọi giao tiếp qua contract.
- **Mọi thay đổi trạng thái đều versioned + evented.**

Vi phạm constraint = vi phạm Hiến pháp → phải sửa.

## Chương 7 — Quality Attributes

Framework luôn tối ưu cho:

| Attribute | Mô tả |
|-----------|-------|
| Reliability | không crash core, recovery tự động |
| Scalability | stateless → scale ngang |
| Extensibility | plugin-first |
| Maintainability | metadata-driven, spec-first |
| Observability | event/metrics/traces mặc định |
| Testability | deterministic, replayable |
| Determinism | cùng input → cùng output |
| Performance | cache, budget, lazy load |

Khi xung đột → ưu tiên theo Decision Hierarchy (chương 23).