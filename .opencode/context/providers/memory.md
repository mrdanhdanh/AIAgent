---
name: context-provider-memory
description: Memory Provider — cung cấp Memory Context (failure history, lessons, previous success).
agent: general
---

# Memory Provider

## 1. Vai trò

Cung cấp lịch sử failure/lesson từ quá khứ, giúp agent tránh lỗi trước.

## 2. Nguồn

- `.opencode/memory/failure-records/*.json`
- `.opencode/knowledge/lessons/*.md`
- Learning pipeline output.

## 3. Interface

- `discover()`: list failure liên quan (theo tag).
- `resolve()`: content.
- `size()`: size.
- `count()`: số record.

## 4. Compress

Memory score thấp (30) → **bị loại đầu tiên** khi budget hẹp. Chỉ giữ `summary` (1 dòng) nếu giữ.

## 5. Deterministic

Failure record có thể nhạy cảm → không giao đầy đủ content cho task không liên quan. Chỉ gửi `summary`.

## 6. Ví dụ chunk

```
memory:
  - { id: MF-0421, type: failure, summary: "Remember UTF-8 no-BOM for .ps1" }
```

## 7. Tương tác

- Profile builder: forbidden [review] nhưng cho memory.
- Intelligence Layer score=30 → thấp nhất.