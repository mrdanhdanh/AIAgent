---
name: workflow-engine-loader
description: >
  Loader cho Workflow Engine v4 — doc + parse definition YAML, map phase -> node,
  topological sort (Kahn), phat hien cycle, resolve workflow id.
agent: general
---

# Loader

Doc va parse definition workflow thanh phase graph truoc khi validate/chay.

## 1. Procedure

1. **Doc file** `.opencode/workflow/definitions/<name>.workflow.yaml` bang UTF-8 no-BOM.
   - File khong ton tai -> WF-ERR-001 (kem duong dan day du).
2. **Parse YAML** theo schema v4 (2-space indent, no tab).
   - Parse loi -> WF-ERR-002 (kem so dong loi).
3. **Map phase -> node**: moi phase thanh node:
   `id, title, agent|command, depends_on, optional, retry, timeout_seconds, continue_on_error, inputs, outputs`.
4. **Topological sort** theo `depends_on` (thuat toan Kahn):
   - Node khong dep vao hang doi truoc, pop -> append ket qua, giam bac cac node phu thuoc.
5. **Cycle detection**: neu con node chua xep va khong con node bac 0 -> cycle.
   - WF-ERR-004 (kem chuoi cycle, vd `analyze -> design -> analyze`).
6. **Output phase graph YAML**: thu tu thuc thi, leaf nodes, root.

## 2. Resolve workflow id

- Khong truyen `--workflow` -> dung `default_workflow` cua schema (mac dinh `default`).
- `--workflow <invalid>` -> WF-ERR-009 kem danh sach 6 definitions:
  `default, bugfix, feature, ui, docs, documentation`.
- KHONG tu fallback mu khi invalid — bao loi ro rang de user chon.

## 3. Bang loi

| Code | Dieu kien | Ghi chu |
|------|-----------|---------|
| WF-ERR-001 | file missing | kem duong dan |
| WF-ERR-002 | YAML parse fail | kem dong |
| WF-ERR-004 | cycle detected | kem chuoi cycle |
| WF-ERR-009 | invalid --workflow id | kem danh sach 5 definitions |

## 4. Sample YAML (parse duoc)

```yaml
definition:
  id: docs
  name: Docs Workflow
  version: 1.0.0
  phases:
    - id: analyze
      title: Phan tich tai lieu
      agent: analyst
      command: team-analyze
      depends_on: []
    - id: write
      title: Viet tai lieu
      agent: general
      depends_on: [analyze]
```

Topological sort output:

```yaml
execution_order:
  - analyze
  - write
leaf_nodes:
  - write
root_nodes:
  - analyze
```

## 5. Output contract

```yaml
loader_output:
  definition:
    id: string
    name: string
    version: string
    description: string
  phases:
    - id: string
      title: string
      agent: string | null
      command: string | null
      depends_on: [string]
      optional: bool
      retry: int
      timeout_seconds: int
      continue_on_error: bool
      inputs: object
      outputs: object
  execution_order: [string]
  leaf_nodes: [string]
  root_nodes: [string]
  status: "OK" | "WF-ERR-00x"
  error:
    code: string
    message: string
    file: string
    line: int | null
```

## 6. Checklist

- [ ] Doc file UTF-8 no-BOM truoc khi parse.
- [ ] File missing -> WF-ERR-001 kem duong dan.
- [ ] YAML parse loi -> WF-ERR-002 kem dong loi.
- [ ] Map phase -> node day du 10 field.
- [ ] Topological sort bang Kahn dung thu tu.
- [ ] Cycle -> WF-ERR-004 kem chuoi cycle.
- [ ] Resolve workflow id: default khi khong truyen, WF-ERR-009 khi invalid.
- [ ] Output phase graph YAML: execution_order, leaf_nodes, root_nodes.
