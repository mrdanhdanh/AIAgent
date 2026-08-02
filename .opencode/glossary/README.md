---
name: glossary
description: >
  Glossary — nền tảng từ vựng AIOS (Sprint 0). Mỗi thuật ngữ MỘT nghĩa duy nhất.
  Mọi SPEC/ADR/RFC phải dùng đúng thuật ngữ này. Đây là building block đầu tiên.
agent: general
---

# Glossary — Từ vựng AIOS

> Sprint 0. Nếu thuật ngữ không thống nhất, toàn bộ SPEC sau sẽ rối.
> Mỗi thuật ngữ chỉ có **một nghĩa duy nhất**.

## Format

Mỗi thuật ngữ một file, theo cấu trúc:

```yaml
Term: <name>
Definition: <định nghĩa chính xác>
Owns:        # thứ thuật ngữ này sở hữu
- ...
Does not own:  # thứ thuật ngữ này KHÔNG sở hữu
- ...
```

## Index

| Thuật ngữ | File | Định nghĩa ngắn |
|-----------|------|-----------------|
| Agent | `agent.md` | thực thể thực thi capability; stateless |
| Capability | `capability.md` | khả năng hệ thống; không phụ thuộc agent |
| Workflow | `workflow.md` | chuỗi phase có trạng thái |
| Phase | `phase.md` | bước trong workflow |
| Task | `task.md` | đơn vị công việc |
| Command | `command.md` | lệnh cài sẵn framework |
| Skill | `skill.md` | kiến thức/kỹ năng cho agent |
| Artifact | `artifact.md` | output versioned + checksum |
| Context | `context.md` | package dữ liệu cho agent |
| Knowledge | `knowledge.md` | lessons/patterns/graph |
| Memory | `memory.md` | working/session/failure |
| Runtime | `runtime.md` | trung tâm điều phối |
| Event | `event.md` | thông báo bất biến, có lineage |
| Plugin | `plugin.md` | gói mở rộng |

## Quy tắc

- Không từ nào hiểu theo nhiều nghĩa.
- Mọi tài liệu khác (SPEC-000..020, ADR, RFC) phải dùng đúng glossary này.
- Thêm thuật ngữ mới → cập nhật glossary trước, rồi mới dùng trong SPEC.