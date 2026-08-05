---
name: decision-log
description: DECISION_LOG — ghi mọi quyết định kiến trúc (ADR) trong quá trình nâng cấp lên v4.
agent: general
---

# DECISION_LOG.md — Architecture Decision Records

> Mỗi quyết định kiến trúc ghi theo format ADR (Hướng dẫn cho v5 và cho người mới tham gia).
> Format: Lý do · Các phương án đã cân nhắc · Quyết định · Hệ quả.

---

## ADR-001: Chuyển Workflow từ hard-code sang Workflow Runtime

- **Lý do**: Workflow điều phối dính agent theo tên, không tuyến tính, khó đổi. Nếu thêm Phase mới phải sửa code.
- **Các phương án đã cân nhắc**:
  - Giữ nguyên hardcode (không làm) — không scale.
  - Xây Workflow Runtime với definitions YAML + engine interpretable — chọn.
  - Dùng third-party workflow engine — không phù hợp ê cụ Agent claude.
- **Quyết định**: Xây Workflow Runtime (v4) với 8 module: engine, loader, validator, executor, phase-runner, state-machine, recovery; definitions khai báo YAML; `default_workflow: default`.
- **Hệ quả**: Workflows được định nghĩa bằng dữ liệu, đổi workflow không cần đụng code engine. Tốn chi phí xây ban đầu.

---

## ADR-002 — Giới thiệu Capability Registry

- **Lý do**: Workflow Runtime "chưa biết Agent" → cần trung gian giữa yêu cầu người dùng và Agent thực thi muốn.
- **Các phương án đã cân nhắc**:
  - Gọi Agent trực tiếp theo tên (giữ cứng) — không scale.
  - Xây Capability Registry (capabilities.yaml + agent/skill/command registry + resolver/matcher/scorer) — chọn.
- **Quyết định**: Registry phiên bản thủ công (explicit), 14 category taxonomy, mapping thủ công; validator CR-001..009 bảo đảm nhất quán; `registry = source of truth (29 skills)`. Non-invasive, không đụng engine v3.
- **Hệ quả**: Engine sau (Phase 3+) đọc registry để routing Agent theo capability thay tên cứng; coverage report sinh bởi validator.

## ADR-003 — Thêm Context Engine

- **Lý do**: Khi Agent có metadata, context build thủ công trong từng agent trùng lặp và wasteful token. Cần 1 nơi quản lý context chuẩn.
- **Các phương án**:
  - Giữ build thủ công — không kiểm soát được token.
  - Context Engine với 7 loại context (Project/Workflow/Task/Artifact/Knowledge/Memory/Runtime) + cache/diff/compression/profile — chọn.
- **Quyết định**: Build Context Engine ở Phase 4, sau Phase 3 (cần metadata agent).
- **Hệ quả**: Context nhất quán, giảm token, hỗ trợ compression với nhiều Phase tiếp.

---

## ADR-004 — Baseline là điểm tham chiếu (không chỉ backup)

- **Lý do**: Doctor/Simulation/Evolution cần so sánh "hiện tại vs baseline", không nên parse lại project mỗi lần.
- **Các phương án**:
  - Backup tĩnh trước nâng cấp — chỉ lưu, không dùng để so.
  - `baseline.json` (numbers) + `SYSTEM_STATISTICS.md` → Doctor đọc để so sánh — chọn.
- **Quyết định**: Phase 0.1 tạo 14 file .md + baseline.json; máy đọc được.
- **Hệ quả**: Doctor/Evolution đọc baseline.json nhanh, không parse toàn project; baseline cập nhật mỗi Phase.

---

## ADR-005 — Nhận đợt nữa, không xóa agent/skill cứ

- **Lý do**: Migration lên v4 cần minh bạch, không phái vóng he hệ thống đang chạy.
- **Các phương án**: reset sạch tay (nhanh, mất data) vs non-invasive từng phase (an toàn, giữ v3 chạy) — chọn non-invasive.
- **Quyết định**: Tất cả Phase theo hướng non-invasive; rollback = giữ baseline. Mỗi bước convention điểm đều có đồng trước (usability).
- **Hệ quả**: v3 vẫn chạy được trong khi v4 build song song; migrate được kiểm soát.