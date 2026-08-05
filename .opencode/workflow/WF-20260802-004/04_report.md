---
name: sprint2-capability-registry-report
description: Báo cáo hoàn tất Sprint 2 — Capability Registry (WF-20260802-004).
agent: general
---

# WF-20260802-004 — Sprint 2 · Capability Registry · Báo cáo hoàn tất

## Kết quả tổng quan
Xây **Capability Registry** (non-invasive layer trên Workflow Engine v4). Không sửa engine/definitions.
- Số file mới: `.opencode/registry/` (10 file) + `commands/team-capabilities.md` + `scripts/capability-validator.ps1` + `reports/CAPABILITY_COVERAGE.md` = **13 file**.
- Validator: **PASS exit 0** — 0 error.

## Entity counts
| Entity | Count | Ghi chú |
|--------|-------|---------|
| Capabilities | 38 | 14 category |
| Agents | 18 | 1 capability orphan được map (knowledge.management → knowledge-agent) |
| Skills | 29 | mapping thủ công; registry = source of truth |
| Commands | 54 | gồm /team-capabilities mới |

## Bug phát hiện & fix
- **capability-validator.ps1**: `return ,$entities` (unary comma) + caller `@(...)` → `.Count=1`. Fix: bỏ unary comma → `return $entities`. BUG WSF đã ghi tài liệu.
- **skill-registry.yaml**: `dependency-analyzer.supports` l.i `impact-analyzer` (skill) → sửa `architecture.impact` (capability).
- **agent-registry.yaml**: `knowledge-agent` bổ sung capability `knowledge.management` (trước đây orphan).

## Warning còn lại (chủ ý, không block)
- 5 orphan capability `Partial` — được skill/command phục vụ, không có agent chuyên trách:
  `architecture.impact`, `review.architecture`, `security.audit`, `documentation.write`, `documentation.review`.
- CR-009 info: skills registry=29 vs nested SKILL.md trên đĩa=38 — registry thủ công, non-invasive, chủ ý giữ.

## Test thực hiện (B10/B11)
1. `capability-validator.ps1` không có lỗi: PASS exit 0 ✓
2. CR-008 category sai taxonomy — path negative verified (166 errors cũ rồi giảm 0) ✓
3. CR-002 refs không tồn tại — verified (impact-analyzer bug) ✓
4. CR-003 orphan — qualification như warning ✓
5. Report CAPABILITY_COVERAGE no-BOM, 38 data rows ✓
6. B8 static: no BOM/no tab/frontmatter/balanced code fence trên 13 file ✓

## Rollback
- DELETE toàn bộ `registry/`, `commands/team-capabilities.md`, `scripts/capability-validator.ps1`, `reports/CAPABILITY_COVERAGE.md`.
- Không modify file có before → reset nhanh.