# 12 — Skill Validation (Self-Improver)

**Workflow:** WF-20260731-002
**Status:** READY (chỉ suggestion — theo yêu cầu: "Skill Validation: chỉ suggestion, không ghi KB nếu impact MEDIUM/HIGH (cần approval)")

## Summary

3 suggestions phát sinh từ quá trình fix 3 bug script. Tất cả đều có impact MEDIUM trở lên → chỉ đề xuất, KHÔNG ghi knowledge base khi chưa được approval.

## suggestions

| # | category | content | evidence | impact | requires_approval |
|---|----------|---------|----------|--------|-------------------|
| 1 | coding_pattern | **PowerShell 5.1 + UTF-8: mọi file .ps1 mới trong .opencode/scripts/ phải lưu UTF-8 có BOM.** PS 5.1 đọc file không BOM theo ANSI → non-ASCII bị mojibake → vỡ string literal → parse error toàn file | Bug 2: schema-validator.ps1 em-dash `—` U+2014 → `Unexpected token 'ensure'`; Bug 3: cross-ref-validator 12 arrow `→` → mojibake | HIGH | true |
| 2 | coding_pattern | **Không đặt tên biến/switch trùng với hashtable data container trong cùng scope.** PS không cho gán hashtable lên SwitchParameter → crash `Cannot create object of type SwitchParameter`; đồng thời switch bị shadow làm sai logic rẽ nhánh | Bug 1: `[switch]$report` + `$report = @{...}` → crash dòng 17 + report-mode luôn bật | MEDIUM | true |
| 3 | workflow_improvement | **Thêm lệnh chạy 3 validator scripts (schema-validator, cross-ref-validator, sync-system-docs -dryRun) vào /team-syncdocs pipeline** để phát hiện sớm regression encoding/prefix khi thêm command/agent/skill mới | Bug 3: double prefix `team-team-` gây hàng loạt `Cannot find path` mà không ai phát hiện vì script không bao giờ chạy được | MEDIUM | true |

## Ghi chú
- Không có suggestion impact LOW (auto-approve) trong workflow này.
- KHÔNG ghi gì vào `.opencode/knowledge/` — chờ approval từ user.

## next_action
Chờ user approval cho 3 suggestions (nếu approve, có thể ghi KB trong workflow sau)
## artifacts
- [12_skill_validation.md]
