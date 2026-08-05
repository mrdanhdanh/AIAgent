---
name: distributed-nodes
description: Node Registry + Failover — đăng ký node, phân tải, failover khi node chết.
agent: general
---

# Distributed Nodes & Failover

## 1. Node registry

```yaml
nodes:
  - { id: node-a, role: coordinator, capabilities: [planning.*], healthy: true }
  - { id: node-b, role: worker, capabilities: [implementation.*], healthy: true }
  - { id: node-c, role: storage, healthy: true }
```

## 2. Scheduling

- Kernel gửi task → node có capability.
- Load balancing (idle node trước).
- Affinity: agent chạy trên node quen.

## 3. Distributed Event Bus

- Event publish → broadcast to all nodes.
- Subscription per node (filter).
- Event ordering qua correlation_id.

## 4. Failover

- Node health check (heartbeat).
- Node chết → re-schedule task sang node khác.
- State recover từ distributed state store.

## 5. Tương tác

- `distributed.schema.yaml`.
- `events/` — distributed bus.
- `kernel/recovery.md` — failover.