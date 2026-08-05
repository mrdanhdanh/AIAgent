---
name: context-provider-artifact
description: Artifact Provider — cung cấp đầu ra trung gian (analysis, plan, review, code, test result) cho agent.
agent: general
---

# Artifact Provider

## 1. Vai trò

Cung cấp **Artifact Context** — đầu ra của các phase trước, là một phần gây token lớn nhất.

## 2. Nguồn (Phase 5)

- Rồi `/artifacts/` hoặc Artifact Store (Phase 5) với version/checksum/dependency.
- Phase 4 tạm đọc từ `workflow/WF-*/artifacts` + `context/cache`.

## 3. Artifact reference

```yaml
artifacts:
  - id: plan
    source: WF-0421/plan.md
    type: markdown
    hash: sha256:...
    cached: true
```

## 4. Lazy load

Artifact chỉ load nội dung khi agent profile có `artifact.plan` hoặc `artifact.code`. Không gửi toàn bộ mọi artifact.

## 5. Cache & Diff

- Artifact Cache theo hash (không đổi thì không đọc lại).
- Iteration sau: chỉ gửi **diff** từ bản trước (cache/diff.md), không gửi lại toàn bộ.
- Đây là lợi ích **40–70% token** lớn nhất.

## 6. Với Phase 5

Phase 5 (Artifact Store) nâng cấp provider này thành artifact store client (version, checksum, dependency). Giao diện đo chậm.

## 7. Tương tác

- Builder `required: [artifact.plan]`.
- Tester `required: [artifact.code, artifact.test_result]`.