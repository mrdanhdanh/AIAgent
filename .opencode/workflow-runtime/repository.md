---
name: workflow-runtime-repository
description: repository — Phase 1.6: abstraction truy cập nguồn lưu trữ (File → DB → Cloud). Load/Save/Find/Compile/Delete.
agent: general
---

# repository.md — Workflow Repository

> **Runtime không đọc file trực tiếp.** Abstraction để sau này File → Database → Cloud không sửa Runtime.

## 1. Giao diện

```text
interface WorkflowRepository {
    Load(id)    -> definition | compiled
    Save(def)   -> ok
    Find(query) -> list
    Compile()   -> compiled.workflow.json (gọi compiler)
    Delete(id)  -> ok
}
```

## 2. Lý do abstraction

```text
File → Database → Cloud
        ▲    ▲    ▲
        └────┴────┘
           Repository
```

Phần ngoài Runtime không biết nguồn thật là gì. Đổi nguồn chỉ cần thay implementation repo, không sửa compiler/scheduler/executor.

## 3. Nguồn lưu trữ lý thuyết

| Backend | Ví dụ | Dùng khi |
|---------|-------|---------|
| File system | `.opencode/workflow/definitions/` | Phase 1 (hiện tại) |
| Database | SQLite/JSON file | Phase sau |
| Cloud | object storage | v5 / multi-machine |

## 4. Repository API + Kernel

```text
Repository ← (adapter) ← Kernel.WorkflowService
                           ↑
                          api/sdk
```

Repository nằm tầng hạ tầng; Kernel gói qua WorkflowService.

## 5. Cache

Repository cache compiled workflow theo id + version để tránh re-compile mỗi lần chạy (PERFORMANCE.md: registry lookup < 20ms).

## 6. Contract

- `Load(id)` trả `CompiledWorkflow` nếu có cached, ngược lại gọi `Compile()`.
- `Delete(id)` chỉ xóa khi workflow không còn instance đang chạy (check lock-manager).

## 7. Module liên hệ

- `compiler.md` ← gọi bởi repo.Compile().
- `persistence.md` ← repo backend file.
- `lock-manager.md` ← copy trước delete.