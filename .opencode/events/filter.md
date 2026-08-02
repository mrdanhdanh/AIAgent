---
name: event-filter
description: Event Filter — subscriber lọc event theo điều kiện (workflow, phase, agent, tag).
agent: general
---

# Event Filter

## 1. Vai trò

Subscriber không muốn nhận tất cả event cùng type. Filter bổ sung điều kiện.

## 2. Filter conditions

| Condition | Ví dụ |
|-----------|-------|
| workflow_id | chỉ event trong WF-0421 |
| phase | chỉ event phase planning |
| agent | chỉ event từ planner |
| artifact_type | chỉ event plan artifact |
| tag | chỉ event có tag "security" |

## 3. Đăng ký

```text
Builder.Subscribe("ARTIFACT_CREATED", filter: { artifact_type: "plan" })
```

Chỉ nhận `ARTIFACT_CREATED` với artifact_type == "plan".

## 4. Filter precedence

1. Match event type trước.
2. Sau đó check filter.
3. Filter fail → không deliver.

## 5. Tương tác

- `dispatcher.md` — apply filter trước deliver.
- `routing.md` — routing + filter.
- `subscriber.md` — đăng ký filter.