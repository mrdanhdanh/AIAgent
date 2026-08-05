---
name: team-analyze-failure
description: "Phân tích lỗi trong workflow. Chạy failure-analyzer.ps1 (normalize+SHA256 deterministic) rồi gọi failure-agent classify + search failure memory. Output YAML contract v2."
trigger: analyze-failure
agent: failure-agent
args: "Chuỗi error message hoặc file path chứa error log"
output: |
  failure_analysis: YAML contract v2
---

# team-analyze-failure

## Usage

```
/team-analyze-failure <error-message-or-file-path>
```

## Flow

1. **Collect raw error** — từ argument hoặc output của step trước
2. **Detect input type** (heuristic):
   - Là file path nếu: bắt đầu drive letter (`C:\`, `D:\`), hoặc tồn tại relative path từ workspace root, hoặc đuôi `.log|.txt|.err|.out|.json|.md`
   - Ngược lại → raw error message
3. **Nếu file path** → đọc file (≤10KB, nếu >10KB → truncate + marker). File không tồn tại → `status: FILE_NOT_FOUND`
4. **Deterministic step** — chạy `& .opencode/scripts/failure-analyzer.ps1 -RawError "<error>"` (hoặc `-FilePath`) → `error_normalized` + `error_hash`
5. **Gọi failure-agent** — truyền: raw error (truncated) + `error_normalized` + `error_hash` + context có cấu trúc `{workflow_id, step, phase, source}`
6. **failure-agent trả về** — classify (error_type + error_detail), retryable (decision table), memory match (failures/lessons/patterns), suggestions, same_error
7. **Output YAML contract v2** cho bước tiếp theo (root-cause / learning / retry / escalate)

## Output

```yaml
status: "READY"
summary: "Phân tích lỗi: BuildFailed — nuget restore 403"
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

## Integration (downstream)

| memory_search.found | same_error.escalate | Hành động tiếp |
|---|---|---|
| true | false | `apply_lesson` → retry/build kèm lesson |
| false | false | `consult_root_cause` → `/team-root-cause` |
| false | true | `escalate` → rollback/hỏi user (same_error_max=2) |
| - | - | Luôn `create_record` sau khi fix thành công (learning-agent) |

## Edge Cases

- Error message >10KB → cắt first 10KB + marker `truncated` (TRƯỚC hash)
- File path không tồn tại → `status: FILE_NOT_FOUND`
- Error rỗng → `status: EMPTY`
- Không chạy được PS script → báo `NOT_FOUND` + `escalate`, KHÔNG tự đoán hash

## Flags

Không có flag bổ sung — nhận error message hoặc file path chứa error log trực tiếp.
