---
name: baseline
description: BASELINE — index và hướng dẫn của bộ baseline Agent Framework v3.
agent: general
---

# BASELINE.md — Agent Framework v3

> Mục lục và hướng dẫn sử dụng bộ baseline Phase 0.1.
> Baseline = điểm tham chiếu: Doctor/Simulation/Evolution so sánh ở đây.

## 1. Mục đích

Khóa trạng thái hiện tại của Agent Framework v3 trước khi nâng cấp lên v4. Mọi thay đổi sau này đối chiếu với baseline này.

## 2. File trong baseline/

| File | Loại | Mô tả |
|------|------|-------|
| `BASELINE.md` | index | (file này) |
| `SYSTEM_BASELINE.md` | spec | version, summary, dirs, features, limitations |
| `ARCHITECTURE_MAP.md` | diag | sơ đồ luồng command/knowledge/failure |
| `DEPENDENCY_GRAPH.md` | diag | graph sang phụ thuộc component |
| `SYSTEM_STATISTICS.md` | auto | số liệu entities (Doctor dùng) |
| `COMPONENT_INVENTORY.md` | list | inventory component |
| `AGENT_CATALOG.md` | catalog | 18 agent + purpose + capabilities |
| `COMMAND_CATALOG.md` | catalog | 54 command + purpose |
| `SKILL_CATALOG.md` | catalog | 29 skill + supports + priority |
| `WORKFLOW_CATALOG.md` | catalog | 5 workflow |
| `CONTRACT_CATALOG.md` | catalog | 2 schema contract |
| `TECH_DEBT.md` | list | nợ kỹ thuật theo severity |
| `RISK_ASSESSMENT.md` | list | rủi ro component + phase |
| `MIGRATION_PLAN.md` | roadmap | lộ trình v3 → v4 |
| `DECISION_LOG.md` | ADR | quyết định kiến trúc |
| `baseline.json` | data | máy đọc được (Doctor/Evolution) |

## 3. Cách Doctor dùng

1. Đọc `baseline.json` (không cần parse lại project).
2. So sánh baseline vs hiện tại: số count diff → alert.
3. `SYSTEM_STATISTICS.md` là ban trình bày của baseline.json.

## 4. Cập nhật

- `baseline-scan.ps1` sinh lại `baseline.json` + `SYSTEM_STATISTICS.md`.
- `catalog-builder.ps1` sinh `AGENT/COMMAND/SKILL/WORKFLOW/CONTRACT_CATALOG.md`.
- Các file spec/catalog chạy tay giữ thủ công linear với trạng thái thật.
- Sau mỗi Phase hoàn tất, cập nhật baseline + baseline.json.