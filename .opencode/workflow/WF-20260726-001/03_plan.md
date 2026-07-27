# 03 — Plan Report

**Workflow:** WF-20260726-001
**Step:** 3 — Plan
**Agent:** planner (Plan Phase)
**Timestamp:** 2026-07-26

## Output YAML (Plan)

```yaml
status: "READY"
summary: "Kế hoạch 7 bước cập nhật analyst.md — mỗi bước ứng với 1 điểm cải tiến, theo thứ tự: ràng buộc → mở rộng contract → quy tắc YAML. 2 chunks: chunk 1 (TASK-001→004), chunk 2 (TASK-005→007). Không cần backup (chỉ sửa 1 file agent definition)."
issues: []
next_action: "Chuyển sang Review phase"
artifacts: ["03_plan.md"]
steps:
  - order: 1
    description: "Thêm ràng buộc đầu vào — Bước 1 (Đọc yêu cầu): nếu $ARGUMENTS thiếu mục tiêu, phạm vi, file đích, hoặc tiêu chí chấp nhận → chuyển NEED_MORE_INFO ngay, không suy đoán. Thêm vào QUY TẮC."
    action: "MODIFY"
    file: ".opencode/agents/analyst.md"
    logic: >
      1. Vào Bước 1 (lines 26-28), thêm: 'Nếu $ARGUMENTS thiếu mục tiêu, phạm vi,
      file đích, hoặc tiêu chí chấp nhận → KHÔNG suy đoán, chuyển NEED_MORE_INFO ngay.
      Liệt kê câu hỏi cụ thể để user bổ sung.'
      2. Thêm vào QUY TẮC (sau line 90): '- Nếu thiếu bất kỳ field nào trong
      [mục tiêu, phạm vi, file đích, tiêu chí chấp nhận] → status: NEED_MORE_INFO'
    check: "Đọc lại file — dòng mới phải có nội dung ràng buộc rõ ràng"
    chunk: 1
    requires_backup: false
  - order: 2
    description: "Thêm assumptions — Bước 3 (Xác định phạm vi): bổ sung mục assumptions. Thêm vào output contract."
    action: "MODIFY"
    file: ".opencode/agents/analyst.md"
    logic: >
      1. Vào Bước 3 (sau 'Ngoài scope'), thêm: '- Assumptions: Các giả định đang dùng
      khi codebase chưa đủ thông tin (ví dụ: "giả định dùng FluentValidation v4.x")'
      2. Vào output contract (sau risks), thêm assumptions block:
      assumptions:
        - id: "ASM-001"
          description: "Mô tả giả định"
    check: "Output contract có assumptions field không? Có hướng dẫn ghi assumptions không?"
    chunk: 1
    requires_backup: false
  - order: 3
    description: "Thêm evidence vào details — cập nhật details instructions, yêu cầu liệt kê evidence"
    action: "MODIFY"
    file: ".opencode/agents/analyst.md"
    logic: >
      1. Vào Bước 2 (Khám phá codebase), thêm yêu cầu: 'Ghi lại evidence: tên file,
      pattern tìm thấy, module liên quan. Mỗi phát hiện phải kèm evidence.'
      2. Vào details section của output contract, thêm ghi chú: 'Trong details, liệt kê
      evidence như tên file, pattern tìm thấy, module liên quan để bám code hơn.'
    check: "Instructions có yêu cầu evidence không? Output contract có note về evidence không?"
    chunk: 1
    requires_backup: false
  - order: 4
    description: "Chuẩn hóa risk levels — thêm định nghĩa HIGH/MEDIUM/LOW vào Bước 4"
    action: "MODIFY"
    file: ".opencode/agents/analyst.md"
    logic: >
      1. Vào Bước 4 (Phân tích rủi ro), thêm:
      'Mức độ rủi ro:
      - HIGH: có thể làm hỏng luồng chính / breaking change
      - MEDIUM: ảnh hưởng một phần chức năng
      - LOW: ảnh hưởng nhỏ, dễ rollback'
    check: "Bước 4 có định nghĩa risk levels không?"
    chunk: 1
    requires_backup: false
  - order: 5
    description: "Task dependency — mở rộng task schema thêm depends_on và why"
    action: "MODIFY"
    file: ".opencode/agents/analyst.md"
    logic: >
      1. Vào Bước 6 (Liệt kê task con), cập nhật yêu cầu:
      'Mỗi task có: ID, Mô tả, File ảnh hưởng, Phụ thuộc (depends_on), Lý do (why)'
      2. Vào output contract, mở rộng task:
      tasks:
        - id: "TASK-001"
          description: "Mô tả task"
          files: ["path/to/file"]
          depends_on: ["TASK-000"]
          why: "Cần hoàn tất TASK-000 trước vì..."
    check: "Task trong output contract có depends_on và why không?"
    chunk: 2
    requires_backup: false
  - order: 6
    description: "Design proposal chi tiết — tách design_proposal thành cấu trúc mới"
    action: "MODIFY"
    file: ".opencode/agents/analyst.md"
    logic: >
      1. Vào Bước 5 (Đề xuất thiết kế), cập nhật:
      'Thiết kế chi tiết:
      - approach: Cách tiếp cận
      - affected_modules: Các module ảnh hưởng
      - new_files: File cần tạo mới
      - modified_files: File cần sửa
      - integration_points: Điểm tích hợp'
      2. Vào output contract, thay design_proposal (string) bằng:
      design_proposal:
        approach: "Cách tiếp cận"
        affected_modules: ["Module1", "Module2"]
        new_files: []
        modified_files: ["path/to/file"]
        integration_points: ["Integration1"]
    check: "design_proposal có đầy đủ 5 sub-field không? approach, affected_modules, new_files, modified_files, integration_points?"
    chunk: 2
    requires_backup: false
  - order: 7
    description: "Quy tắc YAML an toàn — thêm vào QUY TẮC cuối file"
    action: "MODIFY"
    file: ".opencode/agents/analyst.md"
    logic: >
      1. Vào QUY TẮC (cuối cùng), thêm:
      '- Output LUÔN là YAML hợp lệ (validate trước khi xuất)
      - KHÔNG dùng dấu tab — chỉ dùng spaces
      - Chuỗi nhiều dòng dùng | (literal) hoặc > (folded)
      - Nếu không đủ thông tin: status: NEED_MORE_INFO phải xuất hiện NGAY ĐẦU'
    check: "QUY TẮC có 4 dòng YAML safety không? Không có tab trong file?"
    chunk: 2
    requires_backup: false
rollback_strategy:
  enabled: true
  conditions:
    - "catastrophic failure — build lỗi nghiêm trọng"
    - "max retry reached"
    - "user request"
  steps:
    - "Bước 1: git checkout -- .opencode/agents/analyst.md (khôi phục file gốc từ git)"
    - "Bước 2: Xóa artifacts của workflow"
    - "Bước 3: Log rollback reason"
validate:
  - command: "Kiểm tra YAML frontmatter parse được không"
    expected: "YAML không lỗi"
  - command: "Kiểm tra output contract YAML mẫu có parse được không"
    expected: "YAML hợp lệ"
  - command: "Đọc lại toàn bộ file — không có dấu tab, không có cú pháp markdown lỗi"
    expected: "File sạch, không lỗi"
  - command: "Kiểm tra backward compatibility — field cũ vẫn tồn tại"
    expected: "design_proposal cũ vẫn có, assumptions mới thêm, risk severity vẫn hoạt động"
```
