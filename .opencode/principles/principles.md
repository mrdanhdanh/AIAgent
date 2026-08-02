---
name: core-principles
description: >
  Core Principles (Sprint 1) — 15 nguyên tắc bất biến của AIOS.
  Mỗi principle: ID/Purpose/Statement/Rationale/Implications/Exceptions/Related.
  Building block — SPEC-000 Constitution ghép từ đây.
agent: general
---

# Core Principles

> Sprint 1. 15 nguyên tắc bất biến. Mỗi principle ~1 trang.
> Mọi SPEC/ADR/Code phải tuân theo. Không mâu thuẫn.

---

## P001 — Runtime First

**Purpose**: Runtime là trung tâm điều phối mọi hoạt động.

**Statement**: Không Agent nào được điều phối Agent khác. Mọi điều phối qua Runtime.

**Rationale**: Tách điều phối khỏi logic agent → agent đơn giản, thay thế được, scale được.

**Implications**:
- Agent không gọi agent trực tiếp.
- Context/Artifact/Event truy cập qua Runtime API.
- Không bypass Runtime.

**Exceptions**: Không có (bất biến tuyệt đối).

**Related**: P005, P009, P011.

---

## P002 — Contract First

**Purpose**: Giao tiếp có thể kiểm tra được.

**Statement**: Mọi giao tiếp phải thông qua Contract.

**Rationale**: Contract versioned, backward compatible → thay đổi không vỡ.

**Implications**:
- Mọi interface có input/output contract.
- Không truyền dữ liệu tùy ý ngoài contract.

**Exceptions**: Internal helper (không qua biên giới module).

**Related**: P003, P015.

---

## P003 — Metadata First

**Purpose**: Mọi object có metadata.

**Statement**: Workflow, Agent, Artifact, Capability đều được mô hình hóa bằng metadata.

**Rationale**: Metadata là nguồn cho resolver/scheduler/doctor/dashboard.

**Implications**:
- Không hard-code đặc tính trong code.
- Mọi entity có id/type/version/status.

**Exceptions**: Không có.

**Related**: P002, P007, P012.

---

## P004 — Event Driven

**Purpose**: Thay đổi trạng thái đều có vết.

**Statement**: Mọi state change đều phát Event.

**Rationale**: Event immutable + lineage → replay/simulate/audit không cần chạy lại.

**Implications**:
- Mọi transition phát event.
- Không bypass Event Bus.

**Exceptions**: Log nội bộ không phải event.

**Related**: P008, P012.

---

## P005 — Stateless Agents

**Purpose**: Agent scale/ replay/ test dễ.

**Statement**: Agent không giữ trạng thái giữa các lần gọi. Mọi state thuộc Runtime.

**Rationale**: Stateless → failover, scale ngang, deterministic.

**Implications**:
- Agent nhận context, trả artifact.
- Không có state bên trong agent.

**Exceptions**: Cache cục bộ được phép (không phải state nghiệp vụ).

**Related**: P001, P009.

---

## P006 — Capability Driven

**Purpose**: Tách "cần làm gì" khỏi "ai làm".

**Statement**: Workflow gọi capability, không gọi agent.

**Rationale**: Nhiều agent có thể thực hiện 1 capability → chọn linh hoạt.

**Implications**:
- Agent là implementation của capability.
- Resolver chọn agent theo score.

**Exceptions**: Không có.

**Related**: P001, P007.

---

## P007 — Discoverable

**Purpose**: Không hard-code tham chiếu.

**Statement**: Mọi capability/agent/skill/command tìm được qua Registry.

**Rationale**: Registry cho phép plugin thêm/thay mà không sửa core.

**Implications**:
- Đăng ký trước khi dùng.
- Query qua Registry API.

**Exceptions**: Không có.

**Related**: P003, P010.

---

## P008 — Observable

**Purpose**: Mọi hoạt động đo được.

**Statement**: Metrics, traces, events là mặc định, không phải add-on.

**Rationale**: Debug/profiling/evolution cần dữ liệu thực.

**Implications**:
- Instrument mọi module.
- Health/error/cost track.

**Exceptions**: Không có.

**Related**: P004, P012.

---

## P009 — Versioned

**Purpose**: Không ghi đè, dễ rollback.

**Statement**: Mọi thực thể có version.

**Rationale**: Version cho phép A/B, backtest, migration, recovery.

**Implications**:
- Không overwrite — tạo version mới.
- Immutable content.

**Exceptions**: Ephemeral (working memory) không version.

**Related**: P013, P015.

---

## P010 — Plugin First

**Purpose**: Mở rộng không phá lõi.

**Statement**: Mở rộng qua Plugin, không sửa core.

**Rationale**: Core đóng băng → ổn định; extension qua plugin.

**Implications**:
- Core không phụ thuộc plugin.
- Plugin sandbox + certified.

**Exceptions**: Core change chỉ khi kiến trúc lớn.

**Related**: P007, P014.

---

## P011 — Simulation Before Execution

**Purpose**: Dự đoán trước khi chạy.

**Statement**: Thay đổi lớn phải mô phỏng trước khi thực thi.

**Rationale**: Giảm rủi ro, chi phí, lỗi.

**Implications**:
- Workflow lớn → simulation.
- Proposal → backtest.

**Exceptions**: Thay đổi nhỏ/trình không cần.

**Related**: P009, P015.

---

## P012 — Single Source of Truth

**Purpose**: Không duplicate state.

**Statement**: Mỗi thông tin chỉ có một nguồn chính thức.

**Rationale**: Tránh mâu thuẫn, đồng bộ phức tạp.

**Implications**:
- Event = nguồn sự thật cho state.
- Registry = nguồn cho capability/agent.
- Graph = nguồn cho knowledge.

**Exceptions**: Read model (cache) được phép — không phải nguồn.

**Related**: P003, P004, P008.

---

## P013 — Immutable Artifacts

**Purpose**: Toàn vẹn + reproducible.

**Statement**: Artifact không sửa sau khi tạo.

**Rationale**: Checksum + immutable → tin cậy, rollback an toàn.

**Implications**:
- Thay đổi = tạo version mới.
- Checksum verify.

**Exceptions**: Không có.

**Related**: P009, P015.

---

## P014 — Least Privilege

**Purpose**: An toàn.

**Statement**: Chỉ cấp quyền tối thiểu cần thiết.

**Rationale**: Giảm bề mặt tấn công, giới hạn hậu quả.

**Implications**:
- Plugin/agent sandbox.
- Permission qua Policy, không hard-code.

**Exceptions**: Core có quyền hệ thống.

**Related**: P010.

---

## P015 — Backward Compatible

**Purpose**: Không phá consumer.

**Statement**: Thay đổi phải giữ tương thích ngược.

**Rationale**: Plugin/integration cũ vẫn chạy.

**Implications**:
- Breaking → deprecation window + migration.
- Contract versioned.

**Exceptions**: Security fix bắt buộc có thể breaking (có ADR).

**Related**: P002, P009, P013.

---

## Bảng tóm tắt

| ID | Nguyên tắc | Câu hỏi kiểm tra |
|----|-----------|------------------|
| P001 | Runtime First | Agent có tự điều phối agent khác? |
| P002 | Contract First | Giao tiếp qua contract? |
| P003 | Metadata First | Object có metadata? |
| P004 | Event Driven | State change có phát event? |
| P005 | Stateless | Agent có giữ state? |
| P006 | Capability Driven | Gọi capability hay agent? |
| P007 | Discoverable | Tìm qua Registry? |
| P008 | Observable | Đo được? |
| P009 | Versioned | Có ghi đè? |
| P010 | Plugin First | Mở rộng qua plugin? |
| P011 | Simulate First | Đã mô phỏng trước? |
| P012 | Single Source | Duplicate source of truth? |
| P013 | Immutable Artifacts | Sửa artifact sau tạo? |
| P014 | Least Privilege | Quyền tối thiểu? |
| P015 | Backward Compat | Breaking có deprecation? |