---
lesson_id: LSN-GEN-001
failure_id: BUG-0004
error_hash: "llm-deterministic-gap"
error_type: "LLMDeterministicComputeGap"
rule: "KHÔNG để LLM agent thực hiện phép tính deterministic (SHA256, regex normalize, parse số). Đưa vào script/utility (VD: failure-analyzer.ps1), agent chỉ gọi script và dùng kết quả. LLM 'tính hash' = hallucinate mỗi lần khác nhau → phá vỡ dedup/search/state-machine."
applies_to: ["agent", "orchestrator", "scripting"]
tags: ["workflow", "determinism", "scripting", "failure-system"]
severity: HIGH
created_at: "2026-08-05T00:30:00Z"
---
