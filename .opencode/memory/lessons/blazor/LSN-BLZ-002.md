---
lesson_id: LSN-BLZ-002
failure_id: BUG-0001
error_hash: "fragmented_edits"
error_type: "FragmentedFileEdit"
rule: "Gộp nhiều edit trên cùng file vào 1 batch Edit tool call. Mỗi file không quá 3-4 edits riêng lẻ. Nếu cần >4 changes → tách thành file con hoặc dùng Write lại toàn bộ section."
applies_to: ["builder", "orchestrator"]
tags: ["workflow", "edit-pattern", "performance"]
severity: MEDIUM
created_at: "2026-07-30T23:05:00Z"
---
