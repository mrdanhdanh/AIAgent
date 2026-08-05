---
name: architecture-principles
description: PRINCIPLES — nguyên tắc bắt buộc (10) cho mọi Phase của Agent Framework v4.
agent: general
---

# PRINCIPLES.md — Nguyên tắc bắt buộc

> 10 nguyên tắc. Mọi Phase sau phải tuân thủ. Vi phạm phải được ghi ADR.

| # | Nguyên tắc | Mô tả | Phạm vi |
|---|-----------|-------|---------|
| 1 | **Single Responsibility** | Mỗi component/agent/skill làm đúng một việc | Component |
| 2 | **Configuration over Prompt** | Logic qua config (yaml/json), không nhét vào prompt | Workflow, Agent |
| 3 | **Capability First** | Mô tả năng lực, không mô tả tên; engine route theo capability | Routing |
| 4 | **Contract First** | Input/Output có contract rõ ràng, validate trước khi chạy | Agent, Skill, Command |
| 5 | **Artifact Driven** | Kết quả là artifact có checksum/version; không phụ thuộc file rác | Workflow |
| 6 | **Context Isolation** | Context tách biệt theo scope, không trộn | Context Engine |
| 7 | **Event Driven** | Phản ứng sự kiện (Phase Done, Build Finished) thay vì gọi cứng | Runtime |
| 8 | **Backward Compatible** | v3→v4 migration an toàn, không phá file có trước | Versioning |
| 9 | **Stateless Agent** | Agent không giữ state nội bộ; state ở Context/Artifact | Agent |
| 10 | **Observable** | Mọi thứ đo được (metric, log, trace) | Mọi component |

## Chi tiết & lý do

1. **Single Responsibility** — tránh component vừa route vừa thực thi. Có `agent-registry` route riêng, `builder` thực thi riêng.
2. **Configuration over Prompt** — workflow definitions YAML thay vì nhét toàn bộ trong command .md. Prompt chỉ nói "làm gì", config nói "chạy như thế nào".
3. **Capability First** — `analysis.requirement`, `implementation.code`... Resolver map capability → agent phù hợp, không gọi `planner` cứng.
4. **Contract First** — mỗi skill/agent khai báo input/output contract; validator kiểm tra trước khi chạy (CR-00x cho registry).
5. **Artifact Driven** — mọi phase sinh artifact được track (checksum, version, dependency). Phase sau chỉ đọc artifact dependency, không đoán.
6. **Context Isolation** — 7 loại context (Project/Workflow/Task/Artifact/Knowledge/Memory/Runtime) tách biệt; không trộn task context vào project context.
7. **Event Driven** — `BUILD_FINISHED` → trigger TEST phase; thay vì executor gọi cứng phase kế.
8. **Backward Compatible** — v3 vẫn chạy trong khi v4 build; baseline giữ để rollback; migration không xóa.
9. **Stateless Agent** — agent không nhớ; trạng thái nằm trong Context/Artifact. Điều này giúp simulation và parallel dễ.
10. **Observable** — metric (workflow success rate, token, exec time) ghi liên tục; Doctor/Evolution đọc.

## Enforcement

- `capability-validator.ps1` bảo đảm Capability First + Contract (CR-001..009).
- `ARCHITECTURE.md` bảo đảm layer trách nhiệm.
- ADR mới khi đổi bất kỳ nguyên tắc nào.