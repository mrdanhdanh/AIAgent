# 02 — Design Report

**Workflow:** WF-20260726-001
**Step:** 2 — Design
**Agent:** planner (Design Phase)
**Timestamp:** 2026-07-26

## Output YAML (Design)

```yaml
status: "READY"
summary: "Thiết kế giải pháp nâng cấp Analyst Agent — mở rộng output contract, thêm ràng buộc đầu vào, assumptions, evidence, risk levels, task dependencies, design proposal cấu trúc, YAML safety rules. Giữ nguyên permission read-only."
issues: []
next_action: "Chuyển sang Plan phase"
artifacts: ["02_design.md"]
effort: "Small"
design:
  architecture: >
    Sửa trực tiếp file .opencode/agents/analyst.md với các thay đổi cục bộ.
    Giữ nguyên frontmatter (mode: subagent, permission read-only).
    Mở rộng instructions ở Bước 1, 3, 4, 6, 7 và QUY TẮC.
    Mở rộng output contract và EDGE CASES section.
    Backward compatible: thêm field mới, KHÔNG xóa field cũ.
  components:
    - name: "analyst.md"
      path: ".opencode/agents/analyst.md"
      action: "MODIFY"
  data_flow: >
    Analysis input ($ARGUMENTS) → Bước 1-7 (mở rộng) → Output YAML contract (mở rộng)
    → Planner đọc design_proposal mới → Reviewer đánh giá plan
  security_concerns:
    - description: "YAML injection nếu $ARGUMENTS chứa ký tự đặc biệt"
      severity: "LOW"
      mitigation: "Luôn dùng YAML string quoting, không trust user input trực tiếp"
  edge_cases:
    - description: "Output contract quá dài do nhiều field mới"
      handling: "Giữ thiết yếu, không冗余. affected_modules, new_files, modified_files là lists"
    - description: "Backward compatibility với planner cũ"
      handling: "Thêm field mới, KHÔNG xóa field cũ. design_proposal cũ vẫn tồn tại song song"
    - description: "YAML format phức tạp với multiline strings"
      handling: "Dùng | cho literal block, > cho folded block — ghi rõ trong instructions"
```
