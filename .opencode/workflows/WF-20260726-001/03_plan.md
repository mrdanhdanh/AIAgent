---
step: 3
step_name: plan
timestamp: 2026-07-26T00:00:00Z
workflow_id: WF-20260726-001
---

## KẾ HOẠCH THỰC THI — NÂNG CẤP HỆ THỐNG AGENT THEO 7 HƯỚNG

### Step 1: Chuẩn hóa schema đầu ra (Hướng 1)
- **File**: SKILL.md
- **Logic**: 
  1. Thêm section "Base Agent Schema" với 5 field chung: `status`, `summary`, `issues`, `next_action`, `artifacts`
  2. Sửa 7 agent schemas để extends base
  3. Thêm backward compatibility note
- **Check**: YAML parse được, orchestrator read được
- **Chunk**: 1
- **requires_backup**: true

### Step 2: Tách rõ Design và Plan (Hướng 2)
- **File**: planner.md + SKILL.md
- **Logic**:
  1. planner.md: Tách thành 2 section rõ — `## DESIGN PHASE` và `## PLAN PHASE`
  2. SKILL.md: Bước 2 (Design) dùng prompt Design, Bước 3 (Plan) dùng prompt Plan
  3. Thêm 2 output contracts riêng: design_contract / plan_contract
- **Check**: planner.md có 2 phase rõ ràng
- **Chunk**: 1
- **requires_backup**: true

### Step 3: Thêm mức độ ưu tiên cho lỗi (Hướng 3)
- **File**: SKILL.md
- **Logic**:
  1. Thêm section "Error Priority & Action Map"
  2. Định nghĩa: critical → stop/rollback | major → rebuild | minor → log
  3. Cập nhật decision tree để xử lý mỗi severity
- **Check**: Mỗi error type có action tương ứng
- **Chunk**: 2
- **requires_backup**: false

### Step 4: Cơ chế diff giữa vòng lặp (Hướng 4)
- **File**: SKILL.md
- **Logic**:
  1. Thêm `diff_snapshots` vào tracking variables: `[{loop, timestamp, changes, old_errors, new_errors}]`
  2. Thêm section "Diff Mechanism" giải thích cách phát hiện same error
  3. Cập nhật error_history để lưu cả diff context
- **Check**: Mỗi retry có snapshot riêng
- **Chunk**: 2
- **requires_backup**: false

### Step 5: Checkpoint artifact (Hướng 5)
- **File**: SKILL.md + backup-utility.ps1
- **Logic**:
  1. Mỗi artifact lưu với version + timestamp: `01_analysis_v1.md`
  2. Thêm checkpoint manifest: `checkpoint_manifest.json` mapping step → artifact → version
  3. Cập nhật backup-utility.ps1 để hỗ trợ checkpoint
- **Check**: Checkpoint có thể rollback đến bất kỳ step nào
- **Chunk**: 3
- **requires_backup**: false

### Step 6: Guardrail cho chất lượng kế hoạch (Hướng 6)
- **File**: SKILL.md
- **Logic**:
  1. Thêm section "Pre-Build Guardrail Checklist"
  2. Guardrail: có test case? có rollback? có dep file?
  3. Thêm vào decision tree: trước build → guardrail check
  4. Nếu guardrail FAIL → block build
- **Check**: Guardrail chạy trước mỗi build
- **Chunk**: 3
- **requires_backup**: false

### Step 7: Báo cáo cuối cùng (Hướng 7)
- **File**: SKILL.md
- **Logic**:
  1. Chuẩn hóa BÁO CÁO CUỐI CÙNG thành 5 phần:
     - Kết quả tổng
     - Những gì đã làm
     - Lỗi/rủi ro còn lại
     - Artefact đã tạo
     - Việc cần user xác nhận
  2. Thêm template markdown mới
- **Check**: 5 phần đều có trong template
- **Chunk**: 4
- **requires_backup**: false

### Validate
- `dotnet build` không liên quan (SKILL.md thuần markdown + YAML)
- Validate: Parse YAML sections, check internal links, check code block balance
- Kiểm tra: Mỗi hướng có artifact tương ứng

### Rollback strategy
```yaml
enabled: true
conditions:
  - "catastrophic failure"
  - "max retry reached"
  - "user request"
steps:
  - "Bước 1: Restore SKILL.md từ backup"
  - "Bước 2: Restore planner.md từ backup"
  - "Bước 3: Xóa artifacts mới tạo"
```
