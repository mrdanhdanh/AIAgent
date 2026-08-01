# 02_design.md — WF-20260801-002

```yaml
status: READY
summary: >
  Thiết kế Knowledge Assistant gồm 3 lớp: (1) Knowledge Skills — 10 skill chuyên biệt,
  (2) Commands — 10 command hỏi đáp, (3) Knowledge Index layer — 7 loại index + script
  build. Kiến trúc pipeline: User → Assistant → Intent Analyzer → Knowledge Planner →
  Code/Doc Skill → Dependency Skill → Search/Impact → Answer Builder. Effort: Large.
details: >
  Thiết kế nhấn mạnh nguyên tắc evidence-based: câu trả lời luôn kèm nguồn (file:line).
  Knowledge Index không thay thế việc đọc file gốc — chỉ định vị nhanh và giảm chi phí
  token. Mỗi command map tới 1-3 skill cụ thể. Script build-knowledge-index.ps1 quét
  source .cs/.razor/.csproj + knowledge docs để sinh 7 index dạng JSON.
blocking_issues: []
non_blocking_issues:
  - id: "#01"
    severity: MINOR
    category: CONSISTENCY
    description: "Tên skill database-reader nhắm Oracle nhưng dự án hiện tại dùng LocalStorage — cần ghi chú tổng quát"
    suggestion: "Thiết kế skill tổng quát (table/view/procedure), ghi chú rằng JapaneseLearner dùng Blazored.LocalStorage"
open_questions: []
next_action: "Chuyển sang Plan phase"
artifacts: ["02_design.md"]
effort: Large
design:
  architecture: >
    Pipeline 9 tầng: Assistant (điểm vào) → Intent Analyzer (phân loại câu hỏi) →
    Knowledge Planner (chọn skill) → Code Skill / Document Skill (song song) →
    Dependency Skill (call/reference graph) → Search Skill / Impact Analyzer →
    Answer Builder (ghép câu trả lời có nguồn). Tầng Knowledge Index nằm dưới tất cả
    các skill: câu hỏi truy vấn index trước (nhanh, rẻ), rồi đọc file gốc để lấy
    evidence chi tiết. Mỗi skill có input/output contract YAML chuẩn.
  components:
    - name: "knowledge-assistant skill"
      path: ".opencode/skills/knowledge-assistant/SKILL.md"
      action: "CREATE"
      description: "Orchestrator: intent analyzer + knowledge planner + điều phối pipeline"
    - name: "code-understanding skill"
      path: ".opencode/skills/code-understanding/SKILL.md"
      action: "CREATE"
      description: "Đọc C#/Razor/JS/SQL — class, method, call graph, DI, interface, inheritance"
    - name: "document-understanding skill"
      path: ".opencode/skills/document-understanding/SKILL.md"
      action: "CREATE"
      description: "Đọc README/SPEC/design/wiki — requirement, business rule, flow, constraint, decision"
    - name: "dependency-analyzer skill"
      path: ".opencode/skills/dependency-analyzer/SKILL.md"
      action: "CREATE"
      description: "Xây call graph, module graph, reference graph, service graph (DI)"
    - name: "workflow-reader skill"
      path: ".opencode/skills/workflow-reader/SKILL.md"
      action: "CREATE"
      description: "Đọc flow/diagram/mermaid/sequence — user flow, business flow, API flow"
    - name: "search-engine skill"
      path: ".opencode/skills/search-engine/SKILL.md"
      action: "CREATE"
      description: "Semantic search — tìm đoạn xử lý, nơi dùng symbol"
    - name: "architecture-reader skill"
      path: ".opencode/skills/architecture-reader/SKILL.md"
      action: "CREATE"
      description: "Xác định layer/pattern — phát hiện vi phạm architecture"
    - name: "database-reader skill"
      path: ".opencode/skills/database-reader/SKILL.md"
      action: "CREATE"
      description: "Đọc table/view/package/procedure/trigger/index/FK"
    - name: "git-history skill"
      path: ".opencode/skills/git-history/SKILL.md"
      action: "CREATE"
      description: "git log/blame — ai sửa, khi nào, lý do"
    - name: "impact-analyzer skill"
      path: ".opencode/skills/impact-analyzer/SKILL.md"
      action: "CREATE"
      description: "Phân tích ảnh hưởng — sửa X ảnh hưởng API/screen/batch/report"
    - name: "answer-builder skill"
      path: ".opencode/skills/answer-builder/SKILL.md"
      action: "CREATE"
      description: "Ghép evidence thành câu trả lời có nguồn"
    - name: "/ask command"
      path: ".opencode/commands/ask.md"
      action: "CREATE"
      description: "Hỏi đáp tự do — module/API/screen/workflow"
    - name: "/where command"
      path: ".opencode/commands/where.md"
      action: "CREATE"
      description: "Tìm mọi nơi sử dụng symbol"
    - name: "/why command"
      path: ".opencode/commands/why.md"
      action: "CREATE"
      description: "Giải thích lý do thiết kế"
    - name: "/flow command"
      path: ".opencode/commands/flow.md"
      action: "CREATE"
      description: "Sinh sequence/mermaid"
    - name: "/impact command"
      path: ".opencode/commands/impact.md"
      action: "CREATE"
      description: "Sinh affected list"
    - name: "/explain command"
      path: ".opencode/commands/explain.md"
      action: "CREATE"
      description: "Giải thích từng method"
    - name: "/trace command"
      path: ".opencode/commands/trace.md"
      action: "CREATE"
      description: "Truy vết UI→API→Service→DB→Response"
    - name: "/compare-doc command"
      path: ".opencode/commands/compare-doc.md"
      action: "CREATE"
      description: "So sánh code vs design doc"
    - name: "/knowledge-health command"
      path: ".opencode/commands/knowledge-health.md"
      action: "CREATE"
      description: "Đánh giá thiếu README/diagram/flow/ADR"
    - name: "/knowledge-index command"
      path: ".opencode/commands/knowledge-index.md"
      action: "CREATE"
      description: "Build/update 7 loại index"
    - name: "build-knowledge-index script"
      path: ".opencode/scripts/build-knowledge-index.ps1"
      action: "CREATE"
      description: "PowerShell — quét source sinh index JSON"
    - name: "knowledge-index data"
      path: ".opencode/knowledge-index/"
      action: "CREATE"
      description: "7 loại index: code, symbol, api, database, dependency, document, business-rule"
  data_flow: >
    User → /ask (command) → knowledge-assistant skill → Intent Analyzer (xác định loại
    câu hỏi: explain/where/why/flow/impact/trace/compare) → Knowledge Planner (chọn skill
    phù hợp) → skill đọc Knowledge Index (định vị file) → skill đọc file gốc (evidence) →
    dependency-analyzer/impact-analyzer tính graph → answer-builder ghép câu trả lời
    (kèm nguồn file:line). Khi source thay đổi, chạy /knowledge-index --update để tái lập.
  security_concerns:
    - description: "Index chứa thông tin nhạy cảm (connection string, secret) nếu quét nhầm"
      severity: MEDIUM
      mitigation: "Script exclude config secret files (appsettings*.json production), chỉ index symbol"
    - description: "Prompt injection qua câu hỏi user"
      severity: LOW
      mitigation: "Skill instruction cứng — user input là tham số, không phải instruction"
  edge_cases:
    - description: "Symbol không tồn tại trong codebase"
      handling: "Trả về 'Không tìm thấy' kèm gợi ý từ khóa tương tự + hướng dẫn /knowledge-index --update"
    - description: "Index chưa build (folder rỗng)"
      handling: "Tự động nhắc chạy /knowledge-index trước, hoặc fallback quét trực tiếp grep"
    - description: "Câu hỏi mơ hồ (vừa hỏi module vừa hỏi flow)"
      handling: "Intent Analyzer chọn intent chính, trả lời theo intent chính + note các intent phụ"
    - description: "Database câu hỏi nhưng dự án không có DB"
      handling: "Trả về cấu trúc lưu trữ thực tế (Blazored.LocalStorage keys, models) kèm ghi chú"
    - description: "Git repo không có history"
      handling: "git-history skill báo 'không có git' thay vì trả lời rỗng"
  issues:
    blocking_issues: []
    non_blocking_issues:
      - id: "#01"
        severity: MINOR
        category: CONSISTENCY
        description: "database-reader nhắm Oracle nhưng project dùng LocalStorage"
        suggestion: "Skill tổng quát + ghi chú adapt cho dự án hiện tại"
    open_questions: []
  effort: Large
```
