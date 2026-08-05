---
name: context-resolver
description: resolver — khớp agent metadata required_context → provider → source. Không hard-code.
agent: general
---

# Context Resolver

## 1. Vai trò

Resolver là bước **Resolve** trong pipeline: đọc metadata → quyết định nguồn context nào cần.

## 2. Input → Output

```text
Agent Metadata (required_context, forbidden_context)
        ↓
Resolver
        ↓
Provider candidates (list of {type, provider, required})
```

## 3. Nguyên tắc

- **Không hard-code** per-agent; đọc từ `agents/metadata/*.yaml` + `context/profiles/*.yaml`.
- Khớp context-type (context.schema) → provider đăng ký.
- Trả về danh sách sau Filter (loại forbidden + irrelevant).

## 4. Bình thường flow

1. Lấy `required_context` + `forbidden_context` từ profile.
2. Map mỗi context-type → provider (từ providers/).
3. Bỏ `forbidden` ngay.
4. Resolve mỗi provider → candidate.
5. Trả list candidate cho Intelligence/Builder.

## 5. Ví dụ builder

| required_context | provider | required? |
|------------------|----------|-----------|
| project          | project  | yes |
| task             | task     | yes |
| artifact.plan    | artifact | yes |
| knowledge        | knowledge| optional |

## 6. Fallback

- Provider không có candidate → nếu required → missing (validator báo), optional → bỏ.
- Provider lỗi → warning, không crash (artifact có thể null).

## 7. Code

- Provider registry: `providers/` đăng ký map type→method.
- Resolver tái sử dụng cache (nếu provider hỗ trợ).