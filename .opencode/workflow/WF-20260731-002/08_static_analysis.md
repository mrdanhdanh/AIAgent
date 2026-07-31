# 08 — Static Analysis

**Workflow:** WF-20260731-002
**Status:** PASS

## Summary

Static analysis bằng PowerShell 5.1 parser (file .ps1 không có YAML frontmatter — chỉ cần parse-clean + AST check). Cả 3 file đều parse-clean, BOM chuẩn UTF-8, cấu trúc hợp lệ.

## Kết quả

| file | parse errors | functions | BOM | CRLF |
|------|-------------|-----------|-----|------|
| sync-system-docs.ps1 | 0 | 1 | True | 811 CRLF, 0 lone-LF |
| schema-validator.ps1 | 0 | 4 | True | 122 CRLF, 0 lone-LF |
| cross-ref-validator.ps1 | 0 | 4 | True | 143 CRLF, 0 lone-LF |

## Kiểm tra AST
- **Functions:** sync-system-docs (Parse-Frontmatter), schema-validator (4 test functions), cross-ref-validator (Test-CommandReferenced, Get-AgentNames, Get-CommandNames, Get-SkillNames) — tất cả khai báo hợp lệ, không trùng tên.
- **Param blocks:** không còn trùng tên biến/switch (`$report` switch đã rename thành `$evolutionReport`).
- **Regex:** `"^${field}:"` hợp lệ; `agent:\s*([\w-]+)` hỗ trợ dash.

## Encoding
- Cả 3 file: UTF-8 có BOM (EF BB BF) — an toàn cho PS 5.1.
- Không còn non-ASCII trong schema-validator (chỉ còn 3 bytes BOM) và cross-ref-validator (chỉ còn 3 bytes BOM).
- sync-system-docs giữ nguyên 2 em-dash (file đã có BOM sẵn từ trước → không mojibake; không thuộc phạm vi fix).

## Git diff scope
- Chỉ 3 file script được sửa + 2 file report JSON được sinh tự động bởi script + workflow artifacts.
- Không đụng file ngoài phạm vi.

## issues
- (không có)
- Ghi chú: `sync-last-report.json` thay đổi là output runtime của sync-system-docs.ps1 (hành vi bình thường của script khi chạy).

## next_action
UI Audit — theo yêu cầu: **SKIP** (không đụng UI/.NET)
## artifacts
- [08_static_analysis.md]
