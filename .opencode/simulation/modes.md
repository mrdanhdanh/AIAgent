---
name: simulation-modes
description: 5 Execution Modes — dry-run, mock, predict, replay, what-if.
agent: general
---

# Simulation Modes

## 1. Mode list

| Mode | Mô tả | Side-effect |
|------|-------|-------------|
| `dry-run` | read-only, không sửa gì | none |
| `mock` | sinh dữ liệu giả (fake plan) | none (temp) |
| `predict` | ước lượng token/time/risk | none |
| `replay` | phát lại workflow từ history | none |
| `what-if` | mô phỏng nhánh lỗi/rollback | none |

## 2. dry-run

```text
Read Only
```

- Resolve tất cả nhưng không persist.
- Check đủ capability/context/artifact.
- Output: readiness + risk.

## 3. mock

```text
Plan → Fake Plan
```

- Sinh artifact giả để test pipeline shape.
- Không lưu file thật.

## 4. predict

- Ước lượng: token, duration, artifact count, event count.
- Dựa trên workflow phases + profile budget.

## 5. replay

- Đọc event history → chạy lại timeline.
- Không gọi AI.

## 6. what-if

```text
Nếu Builder lỗi → Retry? Abort? Impact?
```

- Đảo nhánh scenario.
- Kiểm tra rollback khả thi.

## 7. Tương tác

- `simulator.md` — chọn mode.
- `scenario.md` — scenario variants.
- `replay.md` (events/) — replay mode.