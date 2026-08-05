---
name: capability-matcher
description: Matcher — từ một capability, tìm candidate agents/skills/commands trong registry.
agent: general
---

# Capability Matcher

## 1. Mục đích

Với mỗi Capability, matcher tìm tất cả agents, skills, commands có `supports`/`capabilities`
chứa capability đó → danh sách candidate + graph.

## 2. Nguồn dữ liệu

- `capabilities.yaml` — id hợp lệ.
- `agent-registry.yaml` — `agents[].capabilities`.
- `skill-registry.yaml` — `skills[].supports`.
- `command-registry.yaml` — `commands[].supports`.

## 3. Procedure

1. Đối chiếu các registry, build index `capabilityId → {agents[], skills[], commands[]}`.
2. Chỉ lấy entity `enabled: true`.
3. Sinh graph dạng:

```
implementation.code
├── builder   (agent)
├── impeccable (skill)
└── team-build (command)
```

4. Trả candidate set cho scorer. Nếu capability không có agent → ghi orphan (severity: warning).

## 4. Cách dùng

- `/team-capabilities --capability implementation.code` → xuất graph của capability đó.
- `/team-capabilities --all` → toàn bộ graph.
- Doctor/CAPABILITY_COVERAGE dùng matcher để tính coverage.