# 11 — Skill Validation Report

**Workflow:** WF-20260726-001
**Step:** 11 — Skill Validation
**Agent:** self-improver
**Timestamp:** 2026-07-26

## Output YAML (Skill Validation)

```yaml
status: "READY"
summary: |
  3 suggestions được tạo: 1 workflow improvement (cập nhật team-analyze.md đồng bộ),
  1 coding_pattern (chuẩn hóa agent YAML contracts), 1 workflow_improvement (thêm 
  assumptions validation vào review checklist). Impact: 2 LOW (auto-approve), 1 MEDIUM 
  (cần approval).
suggestions:
  - category: "WORKFLOW_IMPROVEMENT"
    content: >
      Cập nhật team-analyze.md command để đồng bộ với output contract mới của analyst.md.
      Hiện tại team-analyze.md (command prompt) vẫn dùng schema cũ (design_proposal là
      string, tasks không có depends_on/why). Cần cập nhật để analyst dùng đúng schema
      mới ngay từ command prompt.
    evidence: >
      Phân tích cho thấy analyst.md đã được nâng cấp output contract nhưng
      team-analyze.md (dòng 56-63) vẫn giữ schema cũ. Điều này có thể gây lỗi khi
      analyst parse prompt và output theo format khác.
    impact: "MEDIUM"
    requires_approval: true
  - category: "CODING_PATTERN"
    content: >
      Chuẩn hóa tất cả agent YAML contracts trong .opencode/agents/ dùng chung
      base schema với assumptions field, depends_on/why, và risk level definitions.
      Áp dụng pattern từ analyst.md mới cho planner.md, reviewer.md, builder.md,
      tester.md — đồng bộ output contracts.
    evidence: >
      Workflow này chỉ nâng cấp analyst.md. planner.md, reviewer.md, builder.md
      vẫn dùng schema cũ. Nếu các agent không đồng bộ, thông tin giữa các bước
      có thể bị mất (ví dụ: assumptions từ analyst không được planner đọc).
    impact: "LOW"
    requires_approval: false
  - category: "WORKFLOW_IMPROVEMENT"
    content: >
      Thêm assumptions validation vào review checklist của reviewer.md. Khi reviewer
      đánh giá plan, nên kiểm tra: "Các assumptions từ analysis có được xử lý trong
      design/plan không?".
    evidence: >
      analyst.md giờ có assumptions field. Nếu reviewer không kiểm tra assumptions
      có được giải quyết trong plan, workflow có thể gặp rủi ro.
    impact: "LOW"
    requires_approval: false
```

## Approval Gate

| # | Suggestion | Impact | Requires Approval | Auto-approve |
|---|-----------|--------|-------------------|-------------|
| 1 | Cập nhật team-analyze.md đồng bộ | MEDIUM | ✅ Yes | ❌ Cần user |
| 2 | Chuẩn hóa agent YAML contracts | LOW | ✅ Yes | ✅ Auto (impact LOW) |
| 3 | Assumptions validation trong review | LOW | ✅ Yes | ✅ Auto (impact LOW) |
