---
name: team-analyze-failure
description: "Phân tích lỗi trong workflow — 2 MODE. Mode analyze-error (có args): chạy failure-analyzer.ps1 (normalize+SHA256 deterministic) + failure-agent classify + search failure memory → failure_analysis YAML v2. Mode self-learn (KHÔNG args hoặc --self-learn): quét failure records đã phát hiện & chỉnh sửa trong memory, tự tạo bài học (lessons) + mô tả (patterns) qua learning-agent → learning_report YAML."
trigger: analyze-failure
agent: general
args: "Rỗng (mode self-learn — tự học từ các bug đã fix) HOẶC chuỗi error message / file path chứa error log (mode analyze-error)"
output: |
  failure_analysis: YAML contract v2 (mode analyze-error)
  learning_report: YAML contract (mode self-learn)
---

# team-analyze-failure

## Usage

```
/team-analyze-failure                          # Mode SELF-LEARN — tự học từ bugs đã phát hiện & fix
/team-analyze-failure --self-learn             # Tương đương, tường minh
/team-analyze-failure <error-message-or-file-path>   # Mode ANALYZE-ERROR — phân tích 1 lỗi cụ thể
/team-analyze-failure --analyze <error>        # Mode ANALYZE-ERROR, tường minh
```

## MODE DISPATCH (bắt buộc — ngay khi nhận command)

Kiểm tra `$ARGUMENTS`:

| Điều kiện | Mode | Agent thực thi |
|---|---|---|
| Rỗng (chỉ gõ `/team-analyze-failure`) | **SELF-LEARN** | general → triệu hồi `learning-agent` (ghi memory) |
| `--self-learn` | **SELF-LEARN** | general → triệu hồi `learning-agent` |
| Có error message / file path | **ANALYZE-ERROR** | general → triệu hồi `failure-agent` |
| `--analyze <error>` | **ANALYZE-ERROR** | general → triệu hồi `failure-agent` |

**Nguyên tắc:** general (orchestrator) KHÔNG tự normalize/classify/ghi — luôn triệu hồi sub-agent chuyên trách đúng mode. Ngược lại, nếu user chỉ gõ command không kèm gì → KHÔNG hỏi lại, chuyển thẳng sang SELF-LEARN.

---

## MODE A — ANALYZE-ERROR (phân tích 1 lỗi cụ thể)

**Agent:** `failure-agent` (read-only — bash chỉ chạy failure-analyzer.ps1)

### Flow

1. **Collect raw error** — từ argument hoặc output của step trước
2. **Detect input type** (heuristic):
   - Là file path nếu: bắt đầu drive letter (`C:\`, `D:\`), hoặc tồn tại relative path từ workspace root, hoặc đuôi `.log|.txt|.err|.out|.json|.md`
   - Ngược lại → raw error message
3. **Nếu file path** → đọc file (≤10KB, nếu >10KB → truncate + marker). File không tồn tại → `status: FILE_NOT_FOUND`
4. **Deterministic step** — chạy `& .opencode/scripts/failure-analyzer.ps1 -RawError "<error>"` (hoặc `-FilePath`) → `error_normalized` + `error_hash`
5. **Gọi failure-agent** — truyền: raw error (truncated) + `error_normalized` + `error_hash` + context có cấu trúc `{workflow_id, step, phase, source}`
6. **failure-agent trả về** — classify (error_type + error_detail), retryable (decision table), memory match (failures/lessons/patterns), suggestions, same_error
7. **Output YAML contract v2** cho bước tiếp theo (root-cause / learning / retry / escalate)

### Output (mode analyze-error)

```yaml
status: "READY"
summary: "Phân tích lỗi: BuildFailed — nuget restore 403"
mode: "analyze-error"
analysis:
  error_type: "BuildFailed"
  error_detail: "nuget-restore-403"
  error_hash: "3f2a9c1e8b4d6f21"
  retryable: true
  retry_reason: "transient network"
  same_error: { count: 1, escalate: false }
memory_search:
  found: true
  records:
    - failure_id: "BUG-0001"
      similarity: 0.90
      lesson_id: "LSN-BLZ-001"
      pattern_id: "PAT-001"
  confidence: "HIGH"
suggestions:
  - action: "retry"
    reason: "transient network error"
artifact: "11a_failure_analysis.md"
```

---

## MODE B — SELF-LEARN (tự học hỏi lại các bug đã phát hiện & chỉnh sửa)

**Kích hoạt:** `$ARGUMENTS` rỗng hoặc `--self-learn`.

**Agent:** `learning-agent` (edit: allow — ghi trực tiếp vào memory). failure-agent KHÔNG tham gia mode này (edit: deny → không tạo được lessons/patterns).

**Ý nghĩa:** user không cung cấp lỗi mới → quét lại toàn bộ failure records đã phát hiện & chỉnh sửa trong `.opencode/memory/failures/`, tự tạo bài học (lessons) + mô tả (patterns) cho các bug chưa được học, cập nhật failure records — không cần chạy riêng `/team-learn`.

### Flow

1. **Scan failures** — glob/read `.opencode/memory/failures/*.md`, lọc records có `resolved_at` (đã fix)
2. **Phát hiện gaps** — với mỗi failure đã fix:
   - Thiếu `lesson_id` / `lesson` → cần tạo bài học
   - `reusable: true` nhưng thiếu `pattern_id` → cần tạo pattern
   - Đã có đủ lesson + pattern → skip
3. **Tự tạo bài học (lessons)** — `.opencode/memory/lessons/{framework}/LSN-{tag}-{NNN}.md` theo LESSON FORMAT (frontmatter YAML)
4. **Tự tạo mô tả (patterns)** — `.opencode/memory/patterns/PAT-{NNN}.md` theo PATTERN FORMAT (frontmatter YAML) — tạo khi ≥ 2 failures cùng error_type/tag hoặc failure đơn có confidence đủ
5. **Cập nhật failure records** — thêm `lesson_id`, `pattern_id`, `reusable`
6. **Output learning_report YAML** (contract learning-agent) kèm `mode: self-learn`

### LESSON FORMAT

```yaml
---
lesson_id: LSN-BLZ-001
failure_id: BUG-0004
error_hash: "a1b2c3d4e5f6"
error_type: "NullReferenceException"
rule: "Luôn kiểm tra DI registration trước khi gọi service trong constructor"
applies_to: ["service", "program.cs"]
tags: ["blazor", "wasm", "di"]
severity: HIGH
created_at: "2026-07-30T22:00:00Z"
---
```

### PATTERN FORMAT

```yaml
---
pattern_id: PAT-001
name: "Missing DI Registration"
category: "debugging"
description: "NullReferenceException khi gọi service mà không có DI registration"
related_failures: ["BUG-0004", "BUG-0005"]
related_lessons: ["LSN-BLZ-001"]
confidence: HIGH
tags: ["blazor", "di", "null-ref"]
detected_at: "2026-07-30T22:00:00Z"
---
```

### Output (mode self-learn)

```yaml
status: "READY | NO_CHANGES | FAIL"
summary: "Đã tạo 2 lessons, 1 pattern mới"
mode: "self-learn"
trigger: "no-args | --self-learn"
scan:
  total_failures: 10
  resolved: 8
  processed: 3
  skipped: 5
  skip_reasons:
    - "BUG-0001: đã có lesson + pattern"
created:
  lessons:
    - id: "LSN-BLZ-002"
      path: ".opencode/memory/lessons/blazor/LSN-BLZ-002.md"
      failure_id: "BUG-0005"
  patterns:
    - id: "PAT-002"
      path: ".opencode/memory/patterns/PAT-002.md"
      related_failures: ["BUG-0005", "BUG-0006"]
updated:
  - file: ".opencode/memory/failures/BUG-0005.md"
    changes: ["lesson: LSN-BLZ-002", "pattern: PAT-002", "reusable: true"]
suggestions:
  - action: "update_knowledge_base"
    impact: MEDIUM
    requires_approval: true
```

### Edge cases (mode self-learn)

- Không có failure records nào (memory rỗng) → `status: NO_CHANGES`, summary: "No failure records to process"
- Tất cả failures đã có lesson + pattern → `status: NO_CHANGES`
- Failure chưa `resolved_at` (chưa fix xong) → skip, không học
- Lesson file lỗi format YAML → bỏ qua, báo `FAIL_ENTRY` trong issues
- Framework không xác định (tag thiếu blazor/angular/react) → dùng `lessons/generic/`

---

## Integration (downstream — chung cả 2 mode)

| memory_search.found | same_error.escalate | Hành động tiếp |
|---|---|---|
| true | false | `apply_lesson` → retry/build kèm lesson |
| false | false | `consult_root_cause` → `/team-root-cause` |
| false | true | `escalate` → rollback/hỏi user (same_error_max=2) |
| - | - | Luôn `create_record` sau khi fix thành công (learning-agent) |

## Edge Cases (mode analyze-error)

- Error message >10KB → cắt first 10KB + marker `truncated` (TRƯỚC hash)
- File path không tồn tại → `status: FILE_NOT_FOUND`
- Error rỗng (truyền args rỗng) → KHÔNG vào analyze-error; chuyển sang **SELF-LEARN mode**
- Không chạy được PS script → báo `NOT_FOUND` + `escalate`, KHÔNG tự đoán hash

## Flags

| Flag | Mô tả |
|------|-------|
| (không có args) | Mode SELF-LEARN — tự học từ bugs đã fix (mặc định khi không nhập gì) |
| `--self-learn` | Mode SELF-LEARN tường minh (tương đương không có args) |
| `--analyze <error>` | Mode ANALYZE-ERROR tường minh |
| `<error-message-or-file-path>` | Mode ANALYZE-ERROR (mặc định khi có input) |
