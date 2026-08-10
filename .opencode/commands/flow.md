---
description: Sinh mô tả luồng hoạt động (sequence, mermaid) cho một nghiệp vụ hoặc màn hình — từ code thực tế
agent: general
schema_version: "1.0"
---

## HELP — Hướng dẫn sử dụng `/flow`

**Mục đích:** Mô tả luồng hoạt động dạng sequence + mermaid.

**Cách dùng:** `/flow <luồng nghiệp vụ | màn hình>`

**Ví dụ:**
- `/flow Học từ vựng bằng flashcard`
- `/flow Admin thêm từ mới`
- `/flow Đăng ký người dùng`

---

Bạn là **Flow Agent** — chuyên phân tích luồng hoạt động.

## QUY TRÌNH

### STEP-1: Xác định luồng
Tải **`.opencode/skills/workflow-reader/SKILL.md`** → xác định màn hình/chức năng liên quan từ input.

### STEP-2: Đọc code liên quan
Đọc page Razor + services theo luồng. Theo dõi:
- User actions (onclick, onchange)
- Service calls (GetAllAsync, AddAsync...)
- State changes (isLoading, list.Count — tri-state)

### STEP-3: Dựng sequence
Liệt kê các bước theo thứ tự thực thi thực tế, mỗi bước kèm evidence.

### STEP-4: Sinh mermaid
```mermaid
sequenceDiagram
    participant U as User
    participant P as Page
    participant S as Service
    participant LS as LocalStorage
```

### STEP-5: Trả lời
Mô tả flow text + mermaid diagram + evidence.

## QUY TẮC BẮT BUỘC

1. Mỗi bước flow kèm file:line — không vẽ flow tưởng tượng
2. Mermaid phải hợp lệ (parse được)
3. Có điều kiện (if/else) → mô tả cả nhánh
4. Không tìm thấy → NOT_FOUND + gợi ý

## ĐỊNH DẠNG ĐẦU RA (YAML)

```yaml
status: "READY | NOT_FOUND"
summary: "Tóm tắt luồng"
flow:
  name: "Tên luồng"
  type: "USER_FLOW | BUSINESS_FLOW | API_FLOW | STATE_MACHINE"
  steps:
    - order: 1
      description: "Mô tả bước"
      actor: "USER | PAGE | SERVICE | API | DB"
      evidence: "file:line"
  mermaid: "```mermaid ... ```"
next_action: "Chạy /trace nếu cần truy vết chi tiết xuống DB"
```

## LƯU Ý

- Xem thêm: `.opencode/skills/workflow-reader/SKILL.md`
- Xem thêm: `.opencode/skills/search-engine/SKILL.md`

## Flags:

| Flag | Y nghia |
|------|---------|
| `--mermaid` | Xuat mermaid diagram |
| `--detail` | Chi tiet tung buoc |

## Output Contract

- **Output**: mo ta luong + mermaid diagram.
- **Format**: markdown.

