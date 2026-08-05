---
name: policy-engine
description: >
  Policy Engine v15.0 — quy tắc allow/deny cho agent/plugin/workflow/evolution/doctor/dashboard.
  Không hardcode. Policy khai báo theo subject.
agent: general
---

# Policy Engine v15.0

## 1. Vai trò

Thay hardcode permission bằng **policy khai báo**.

```yaml
policy:
  planner:
    allow: [planning.*]
    deny: [artifact.delete]
  reviewer:
    allow: [review.*]
```

## 2. Áp dụng cho

| Subject | Ví dụ |
|---------|-------|
| Agent | planner chỉ planning.* |
| Plugin | oracle chỉ read knowledge |
| Workflow | bugfix chỉ các phase liên quan |
| Evolution | proposal architecture cần review |
| Doctor | rule chỉ read |
| Dashboard | role-based control |

## 3. Policy format

```yaml
policies:
  planner:
    allow: [planning.*, architecture.design]
    deny: [artifact.delete, event.publish]
  plugin-oracle:
    allow: [knowledge.read, artifact.read]
    deny: [knowledge.write]
```

## 4. Evaluation

```text
request(actor, action)
  → PolicyEngine.Evaluate(actor, action)
  → deny rule match? → deny
  → allow rule match? → allow
  → default deny
```

## 5. Tương tác

- `policy.schema.yaml` — format.
- `plugins/permissions.md` — integrate.
- `kernel/` — enforce policy khi execute.
- `dashboard/security.md` — roles.