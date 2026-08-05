---
name: workflow-runtime-acceptance
description: RUNTIME_ACCEPTANCE — Phase 1.25: tài liệu chấp nhận Runtime (Architecture/Execution/Performance/Compatibility). Gate trước Phase 2.
agent: general
---

# RUNTIME_ACCEPTANCE.md — Runtime Acceptance

> Checklist chấp nhận Runtime. **Đạt toàn bộ** mới chuyển sang Phase 2.

## Architecture

- [ ] Runtime không biết Agent
- [ ] Runtime không biết Prompt
- [ ] Runtime không biết Skill
- [ ] Runtime không biết Capability
- [ ] Runtime không biết AI/LLM

## Execution

- [ ] Workflow chạy được
- [ ] Retry
- [ ] Rollback
- [ ] Pause
- [ ] Resume
- [ ] Skip / Abort / Escalate

## Performance

- [ ] Compile < 1s
- [ ] Validation < 300ms
- [ ] Execute < Target (theo PERFORMANCE.md)
- [ ] Memory ổn định

## Compatibility

- [ ] Workflow v3
- [ ] Workflow v4
- [ ] Schema (compile schema hợp lệ)
- [ ] Migration (v3 → v4 không phá)

## Reliability

- [ ] Persistence atomic
- [ ] Recovery giữ nhất quán
- [ ] Lock chống race
- [ ] Test suite độc lập AI PASS

## Cách chạy

```text
1. dotnet/script test suite (runtime test)
2. /team-runtime-benchmark (performance)
3. chạy workflow mẫu feature/bugfix (execution)
4. nạp workflow v3 (compatibility)
```

Mọi box ✅ → tạo `RUNTIME_CERTIFICATE.md`.