---
name: team-analyze-failure
description: "Phân tích lỗi trong workflow. Thu thập raw error, normalize, classify, search failure memory, output phân tích. Gọi failure-agent."
trigger: analyze-failure
agent: failure-agent
args: "Chuỗi error message hoặc file path chứa error log"
output: |
  failure_analysis: YAML contract
---

# team-analyze-failure

## Usage

```
/team-analyze-failure <error-message-or-file-path>
```

## Flow

1. Collect raw error — từ argument hoặc từ output của step trước
2. Nếu là file path → read file để lấy error content
3. Gọi failure-agent: truyền raw error + context (workflow step hiện tại)
4. failure-agent trả về phân tích: error_hash, error_type, retryable, memory match
5. Output YAML contract for next steps

## Output

```yaml
analysis_status: "READY"
error_type: "BuildFailed"
error_hash: "a1b2c3d4e5f6"
retryable: false
memory: { found: true, failure_id: "BUG-0001" }
```

## Edge Cases

- Error message too long (>10KB) → chỉ lấy first 10KB + "TRUNCATED"
- File path không tồn tại → báo lỗi "FILE_NOT_FOUND"

## Flags

**Flags:**

Không có flag bổ sung — nhận error message hoặc file path chứa error log trực tiếp.

