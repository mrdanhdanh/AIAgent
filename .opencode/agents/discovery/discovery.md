---
name: agent-discovery
description: discovery — cơ chế registry truy vấn "agent nào hỗ trợ capability X" + mở rộng cho Phase 11 Plugin.
agent: general
---

# Agent Discovery

## 1. Mục đích

Registry trả lời: **"Agent nào hỗ trợ capability X?"**

```text
planning.feature → Planner, Planner-v2, Planning-Pro
```

## 2. API

| API | Vai trò |
|-----|---------|
| `FindAgentsByCapability(cap)` | list agent supports cap |
| `FindAgent(id)` | một agent |
| `FindByTag(tag)` | agent theo tag |
| `FindByFramework(fw)` | agent theo framework |

## 3. Discovery quy trình

```text
capability
   ↓
Scan agent-registry (supports)
   ↓
Filter: enabled=true, status != disabled/deprecated(no replacement)
   ↓
Verify agent.yaml tồn tại (metadata/)
   ↓
Return list candidate
```

## 4. Plugin (Phase 11)

- Plugin cung cấp agent.yaml mới → Registry scan thư mục plugin.
- Agent plugin override Behavior (prompt) mà giữ Identity + Capability.
- Discovery quét cả core + plugin folder.

## 5. Ví dụ

```text
capability=implementation.code
→ builder (priority 90)
→ general (fallback 50)
```

## 6. Lưu ý

- Quét theo `supports` trong agent-registry.yaml (canonical), metadata/ là nguồn chi tiết.
- Đảm bảo 2 nguồn (agent-registry.yaml vs metadata/*.yaml) không drift — validator AG-010.