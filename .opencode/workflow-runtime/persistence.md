---
name: workflow-runtime-persistence
description: persistence — Thành phần 9: lưu instance, history, state, runtime log theo thư mục WF-*. Dashboard (Phase 12) đọc.
agent: general
---

# persistence.md — Persistence

> Thành phần 9. Runtime phải **lưu** — để Dashboard (Phase 12) đọc.

## 1. Cấu trúc lưu trữ

```text
workflow/
└── WF-<YYYYMMDD>-<XXX>/
    ├── instance.json   # workflow instance (có lifecycle)
    ├── history.json    # lịch sử các phase + sự kiện
    ├── state.json      # state machine hiện tại
    └── runtime.log        # log runtime
```

`WF-<id>` do runtime sinh khi `CreateInstance`.

## 2. Nội dung file

| File | Nội dung | Tham chiếu |
|------|-----------|-----------|
| `instance.json` | id, workflow, status, current_phase, completed, failed, artifacts | instance.schema.yaml |
| `history.json` | danh sách event + phase transition | runtime event |
| `state.json` | trạng thái state-machine hiện tại | state-machine.md |
| `workflow.log` | runtime log + errors + metrics | OBSERVABILITY.md |

## 3. Thao tác

| Thao tác | Mô tả |
|----------|-------|
| `Create(dir, instance)` | tạo thư mục + file ban đầu |
| `SaveInstance(instance)` | ghi instance.json sau mỗi phase |
| `AppendEvent(event)` | ghi history.json |
| `SaveState(state)` | ghi state.json |
| `LoadInstance(id)` | đọc instance.json |
| `Archive(id)` | chuyển workflow Archived |

## 4. ⭐ Update-atomic

- Ghi file nguyên tử (temp rồi rename) tránh mất dữ liệu.
- Persistence không nằm trong `/team` — runtime tự lo.

## 5. Dashboard (Phase 12)

- Đọc `instance.json` + `history.json` để vẽ trạng thái/quá trình.
- Đọc `runtime.log` để quan sát.

## 6. Tương tác

- Được dùng bởi `runtime.md`, `executor.md`, `recovery.md`.
- Reference: `architecture/DIRECTORY_STANDARD.md` (workflow/WF-* do engine tạo, không sửa tay).