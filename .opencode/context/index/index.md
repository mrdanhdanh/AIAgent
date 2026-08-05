---
name: context-index
description: Context Index — đánh chỉ mục project/knowledge để lookup rẻ, không scan toàn bộ. Chuẩn bị cho Knowledge Graph.
agent: general
---

# Context Index

## 1. Vấn đề

Scan toàn bộ project mỗi lần resolve → tốn token/lâu. Thay vào đó dùng **index**.

## 2. Nguồn

- Nên dùng sẵn `.opencode/knowledge-index/` (7 loại index).
- Context Index = lớp lookup trên top; không tạo trùng.

## 3. Lookup

```text
request context type (project/artifact/knowledge)
   ↓
Index → hash map / path lookup
   ↓
Provider resolve nội dung đúng file (lazy)
```

## 4. Lợi ích

- Không mở toàn bộ project.
- O(1) lookup theo key.
- Nền tảng cho Knowledge Graph (Phase 9).

## 5. Format (đề xuất)

```
context.index.json:
  {
    "agents": {"planner": "agents/planner.md"},
    "views":   {"plan": "workflow/WF-0421/plan.md"},
    "rules":   {"AGENTS": "AGENTS.md"},
    "lessons": {"lesson-blazor-cache-first": ".opencode/knowledge/.../L-041.md"}
  }
```

## 6. Tương tác

- `cache/` dùng index làm key lookup.
- `providers/knowledge.md` dùng index thay scan.
- Plugin đăng ký index mới.