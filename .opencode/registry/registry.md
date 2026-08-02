---
name: capability-registry-md
description: registry — tài liệu trung tâm Phase 2 Capability Registry: object, resolver pipeline, cache, metrics, API, test. Nâng cấp từ Sprint 2.
agent: general
---

# registry.md — Capability Registry (Phase 2)

> Biến Framework từ **Workflow-driven** thành **Capability-driven**.
> Workflow không biết Agent. Agent không biết Command. Mọi thứ kết nối qua **Capability**.

## 1. Kiến trúc mới

```text
Trước:                     Sau:
Workflow                   Workflow
    ↓                          ↓
Planner                    Capability
    ↓                          ↓
Builder                    Capability Resolver
    ↓                          ↓
Tester                     Agent
                               ↓
                            Skill
```

**Agent chỉ là một implementation của Capability.**

## 2. Capability là gì

Capability = **khả năng**, không phải Agent.

```text
analysis.requirement · planning.feature · implementation.code · review.code
testing.plan · testing.e2e · ui.audit · git.push · knowledge.learn
```

Workflow chỉ gọi `implementation.code` — **không gọi `builder`**.

## 3. Resolver Pipeline

```text
Capability
    ↓
Registry
    ↓
Matcher
    ↓
Scorer
    ↓
Compatibility
    ↓
Selected Agent
```

| Bước | Module |
|------|--------|
| Capability → candidates | `matcher.md` |
| Ranking nhiều agent | `scorer.md` |
| Version/contract check | `compatibility.md` |
| Validate registry | `validator.md` + `capability-validator.ps1` |

## 4. Capability Object (mở rộng)

```yaml
id: implementation.code
version: 1.0.0
owner: core
stability: stable
deprecated: false
replacement:
visibility: public
since: 4.0.0
category: implementation
description: Generate production code
inputs: [plan, requirements]
outputs: [source_code]
contracts: [implementation-contract]
requires: [implementation.plan]
requires_framework: [blazor]
tags: [blazor, fluentui]
```

- Capability **không biết Agent**.
- Thêm **Capability Manifest** (owner/stability/deprecated/since...) → Phase 10 Evolution + Phase 11 Plugin dùng.

## 5. Registry Cache

```text
registry.yaml → Cache (memory) → Resolver
```

- Load 1 lần khi boot, không parse YAML liên tục.
- Invalidate khi registry file thay đổi (mtime/hash).
- Lookup qua hash map: O(1).

## 6. Registry Metrics

| Metric | Mô tả |
|--------|-------|
| lookup_time | thời gian tìm capability |
| hit_rate / miss_rate | cache hit/miss |
| compatibility_failure | số lần reject vì version |
| resolution_time | thời gian resolve đầy đủ |
| orphan_count | capability không agent (CR-003) |

## 7. Registry API

| API | Vai trò |
|-----|---------|
| `FindCapability(id)` | tìm capability |
| `Resolve(capability, context)` | pipeline matcher→scorer→compat |
| `FindAgent(id)` | tìm agent |
| `FindSkill(id)` | tìm skill |
| `Validate()` | chạy validator |
| `Register(def)` | đăng ký (plugin) |
| `Unregister(id)` | gỡ |

## 8. Registry Test (độc lập)

| Test | Kỳ vọng |
|------|---------|
| Capability tồn tại | FindCapability trả về |
| Capability không tồn tại | CAP-001 / null |
| 2 Agent cùng capability | scorer chọn đúng |
| Version conflict | compatibility reject |
| Registry cache | lookup nhanh, không re-parse |
| Resolver performance | lookup < 20ms |

## 9. Tương tác

- Workflow Runtime (`workflow-runtime/dispatcher.md`) → Phase 2 thay dispatcher bằng Resolver.
- `/team-capabilities` → discovery qua registry.
- Doctor → coverage + health.
- `command-registry.yaml` → `team` map workflow definition (không logic).