---
name: context-diff
description: diff — giảm token giữa các iteration bằng gửi change thay vì gửi toàn bộ.
agent: general
---

# Context Diff

## 1. Vấn đề

Iteration 2 lại gửi cả plan 900 token → lãng phí. Chỉ nên gửi phần thay đổi.

## 2. Cơ chế

- Lưu hash của nội dung từng artifact.
- Giữa iteration: so sánh bản mới/mới? → tính diff (line-level).
- Package mới chỉ chứa `diff`.

## 3. Ví dụ

Node:
```
plan.md v1 (900 tok) → v2 (950 tok)
```

- send v1 full (900) once
- iteration2: chỉ gửi diff (+50 tok) → tiết 850.

## 4. Điều kiện

- Cần giữ reference cũ trong cache (per session).
- Nếu cache miss (new session/artifact changed ngoài session) → fallback gửi full.
- Diff chỉ hợp với text/markdown, không cho binary.

## 5. Khi nào KHÔNG dùng

- Vi khi mới start (không có bản trước) → full.
- Ở context thay đổi hoàn toàn → full (so sánh size > 50% → full).

## 6. Metrics

- diff.save_tokens = full_size - diff_size → quant impact.
- `save_tokens = full_size - diff_size` → đo lợi ích.

## 7. Tương tác

- `cache/cache.md` (hash key)
- `compression/` (nén nội dung).
- Key diff plans md.