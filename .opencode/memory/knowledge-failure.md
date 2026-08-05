---
name: memory-knowledge-failure
description: Knowledge + Failure Memory — bộ nhớ vĩnh viễn; merge knowledge/ và memory/ hiện có.
agent: general
---

# Knowledge & Failure Memory

## 1. Knowledge Memory

- Lessons, patterns, best practices (từ `knowledge/`).
- Query qua embedding + tags.
- Context Engine truy vấn qua Memory thay vì scan folder.

## 2. Failure Memory

- Failure records (từ `memory/failure-records/`).
- Normalized error + RCA.
- Agent tránh lỗi lặp lại.

## 3. Knowledge entry

```yaml
id: L-041
type: lesson
tags: [blazor, cache]
content: "..."
embedding_ref: vec-041
```

## 4. Failure entry

```yaml
id: F-042
error_code: ERR-123
summary: "..."
root_cause: "..."
lessons: [L-041]
```

## 5. Tương tác

- `knowledge-graph/` (Phase 9) — nodes.
- `learning-agent` — VIẾT knowledge + failure records (edit:allow).
- `failure-agent` — CHỈ phân tích lỗi (read-only): normalize/hash do `failure-analyzer.ps1`, search memory, đề xuất.