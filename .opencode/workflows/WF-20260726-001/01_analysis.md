---
step: 1
step_name: analyze
timestamp: 2026-07-26T00:00:00Z
workflow_id: WF-20260726-001
---

## PHÂN TÍCH YÊU CẦU NÂNG CẤP HỆ THỐNG AGENT

### Yêu cầu gốc
Đề xuất nâng cấp hệ thống Agent theo 7 hướng:
1. Chuẩn hóa schema đầu ra
2. Tách rõ "plan" và "design"
3. Thêm mức độ ưu tiên cho lỗi
4. Có cơ chế diff giữa các vòng lặp
5. Thêm checkpoint theo từng artifact
6. Bổ sung guardrail cho chất lượng kế hoạch
7. Tạo báo cáo cuối cùng ngắn gọn theo mẫu

### Phân tích hiện trạng

**Files bị ảnh hưởng:**
- `.opencode/skills/dev-team/SKILL.md` (1400 dòng) — file chính chứa toàn bộ workflow
- `.opencode/agents/analyst.md`, `planner.md`, `reviewer.md`, `self-improver.md`, `backup-agent.md` — agent definitions
- `.opencode/scripts/backup-utility.ps1` — backup script

**Phân tích từng hướng:**

| # | Hướng | Hiện trạng | Phân tích |
|---|-------|-----------|-----------|
| 1 | Chuẩn hóa schema | Mỗi agent có schema riêng, chưa có format `status/summary/issues/next_action/artifacts` chung | Cần thêm base schema + normalize tất cả agent output |
| 2 | Tách Design/Plan | Planner đảm nhiệm cả Design+Plan trong 1 agent, 2 prompt khác nhau | Cần tách thành 2 phase riêng, có thể giữ 1 agent với 2 prompt contracts |
| 3 | Error priority | Reviewer đã có CRITICAL/MAJOR/MINOR, Builder có failure_type, nhưng chưa có hành động cố định | Cần thêm action map cho từng severity |
| 4 | Diff giữa vòng lặp | Chưa có cơ chế diff, chỉ có error_hash + same_error_count | Cần thêm diff_snapshot cho mỗi lần retry |
| 5 | Checkpoint artifact | Đã có checkpoint_snapshots trong tracking variables nhưng chưa lưu artifact files riêng | Cần lưu artifact có version+timestamp |
| 6 | Guardrail plan quality | Chưa có guardrail tự động trước khi build | Cần thêm pre-build validation checklist |
| 7 | Final report | Đã có mẫu report nhưng chưa đủ 5 phần (kết quả, đã làm, lỗi, artefact, cần xác nhận) | Cần chuẩn hóa theo 5-section template |

### Rủi ro

| Severity | Mô tả | Mitigation |
|----------|-------|------------|
| HIGH | Breaking changes nếu đổi schema đột ngột | Backward compatibility mode |
| MEDIUM | Tăng complexity của SKILL.md | Giữ cấu trúc module, không flatten |
| LOW | Planner vẫn giữ cả Design+Plan — dễ confusion | Tách rõ 2 section trong cùng file agent |

### Kết luận
**READY** — 7 hướng đều khả thi, tập trung vào SKILL.md + agent definitions.

### Tasks
1. Chuẩn hóa output schema — thêm base agent schema
2. Tách Design phase — sửa planner.md
3. Thêm error priority + action map
4. Thêm diff mechanism giữa retry loops
5. Thêm checkpoint artifact versioning
6. Thêm pre-build guardrail
7. Chuẩn hóa final report template
