---
name: artifact-tags
description: Artifact Tags — gắn tag cho artifact để query/lọc/group, Knowledge Graph reuse.
agent: general
---

# Artifact Tags

## 1. Mục đích

Tag bổ sung metadata cho filter/query nhanh, Knowledge Graph dùng để cluster artifact.

## 2. Tag chuẩn

| Tag | Mô tả |
|-----|-------|
| planning | artifact về kế hoạch |
| review | artifact về review |
| implementation | source code |
| testing | test result |
| deployment | deploy artifact |
| knowledge | lesson/pattern |
| blazor | liên quan Blazor |
| fluentui | liên quan FluentUI |
| oracle | liên quan Oracle DB |
| csharp | code C# |
| playwright | test E2E |
| security | bảo mật |

## 3. Query with tag

```text
FindByTag(security) → REV-003 (guardian review of code)
FindByTag(blazor) + FindByType(code) → CODE-001, CODE-002
```

## 4. Auto-tag

Manager tự gán tag dựa trên:
- Context type (`types.yaml` → auto tag).
- Agent capability (nếu agent có tag `security` → artifact nhận tag `security`).

## 5. Tương tác

- Knowledge Graph (Phase 9) dùng tag cluster + tạo edge.
- `query.md` hỗ trợ FindByTag.