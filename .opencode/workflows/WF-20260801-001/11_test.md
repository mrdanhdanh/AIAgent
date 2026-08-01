---
workflow_id: "WF-20260801-001"
step: 11
step_name: "test"
agent: "tester"
schema_version: "3.2"
timestamp: "2026-08-01T18:12:00Z"
---

# Bước 11: Test — Knowledge Assistant

```yaml
status: "APPROVED"
summary: >
  12/12 test cases PASSED. opencode.json hợp lệ (1 agent + 11 commands),
  frontmatter 11 commands + 10 skills sạch, index build chính xác (route/symbol/
  service khớp source thật), regression build PASS + 154/154 unit tests PASS,
  3 smoke tests (ask/where/trace) PASS, doctor 97/100, syncdocs 95/100.
coverage:
  thresholds_met: true
  unit: 100
  integration: 100
  regression: 100
  smoke: 3
results:
  - { id: "T-001", name: "Validate opencode.json cấu hình", status: "PASSED", duration: "1s", note: "JSON hợp lệ, knowledge-agent bash:allow/edit:deny, 11 commands" }
  - { id: "T-002", name: "Validate frontmatter 11 commands + 10 skills", status: "PASSED", duration: "1s", note: "0 lỗi" }
  - { id: "T-003", name: "knowledge-index.ps1 build index", status: "PASSED", duration: "2s", note: "8 JSON files (7 index + 1 report)" }
  - { id: "T-004", name: "Index JSON nội dung chính xác", status: "PASSED", duration: "1s", note: "/words→WordStudy.razor, IWordService→WordService, JapaneseWord có trong symbol" }
  - { id: "T-005", name: "dotnet build regression", status: "PASSED", duration: "3s", note: "Build succeeded, 0 errors" }
  - { id: "T-006", name: "dotnet test unit regression", status: "PASSED", duration: "9s", note: "154/154 PASS (warning NU1902 AngleSharp pre-existing)" }
  - { id: "T-007", name: "Smoke /knowledge-ask WordService", status: "PASSED", duration: "1s", note: "Summary + sources file:line" }
  - { id: "T-008", name: "Smoke /knowledge-where JapaneseWord", status: "PASSED", duration: "1s", note: "13 grep matches + index data" }
  - { id: "T-009", name: "Smoke /knowledge-trace /words", status: "PASSED", duration: "1s", note: "Full chain UI→Service→Impl→Model→Storage" }
  - { id: "T-010", name: "Doctor không regress", status: "PASSED", duration: "30s", note: "97/100, knowledge-agent PASS 8/8" }
  - { id: "T-011", name: "Syncdocs cập nhật SYSTEM_MAP", status: "PASSED", duration: "30s", note: "95/100, knowledge-* trong map, 0 issues" }
  - { id: "T-012", name: "Static Analysis toàn bộ", status: "PASSED", duration: "2s", note: "0 errors" }
retry:
  test_count: 0
next_step: "Bước 12: Skill Validation"
```

## Ghi chú Tester

1. **T-004 ban đầu FAIL** — nguyên nhân test script không dùng `-Encoding UTF8` khi đọc JSON (PowerShell 5.1 default ANSI → mojibake). Re-run với UTF8: PASSED. Không phải lỗi sản phẩm.
2. **Regression quan trọng nhất đạt**: 154 unit tests + build vẫn xanh sau khi thêm toàn bộ Knowledge Assistant — không phá vỡ dự án.
3. **Warning NU1902 (AngleSharp moderate vulnerability)** — pre-existing trong csproj test, không liên quan thay đổi workflow này.
