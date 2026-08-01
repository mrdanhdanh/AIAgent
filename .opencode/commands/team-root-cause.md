---
name: team-root-cause
description: "Phân tích nguyên nhân gốc từ failure analysis. Tìm evidence trong codebase, tạo hypotheses, đề xuất fix. Gọi root-cause-agent."
trigger: root-cause
agent: root-cause-agent
args: "failure_analysis YAML (từ team-analyze-failure)"
output: |
  root_cause_analysis: YAML contract
---

# team-root-cause

## Usage

```
/team-root-cause <failure-analysis-yaml hoặc error_hash>
```

## Flow

1. Nhận failure_analysis từ team-analyze-failure (hoặc error_hash + context)
2. Gọi root-cause-agent: truyền error_analysis + context codebase
3. root-cause-agent trả về hypotheses ranked by confidence
4. Output root_cause_analysis YAML

## Output

```yaml
status: "READY"
hypotheses_count: 2
most_likely: "H-001"
conclusion: "ServiceB chưa được DI registration"
fix_suggestion: "Thêm builder.Services.AddScoped<IServiceB, ServiceB>() trong Program.cs"
```

## Integration

Sau khi có root cause, builder sẽ:
1. Nếu fix đơn giản → execute ngay
2. Nếu fix phức tạp → gửi cho planner để thiết kế
3. Nếu retryable → retry step
4. Luôn ghi failure record sau khi fix thành công

## Flags

**Flags:**

Không có flag bổ sung — nhận failure_analysis YAML từ `/team-analyze-failure`.

