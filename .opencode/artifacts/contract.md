---
name: artifact-contract
description: Artifact Contract — định nghĩa Artifact nào agent nhận (input) và tạo (output), kết nối với agent contracts.
agent: general
---

# Artifact Contract

## 1. Mục đích

Agent không còn tham chiếu `plan.md` — thay vào đó tham chiếu **Artifact type**.

## 2. Agent mapping

| Agent | Input Artifacts | Output Artifacts |
|-------|----------------|-----------------|
| analyst | — | analysis, requirement |
| planner | requirement | design, plan |
| builder | plan, design | code |
| reviewer | code, plan | review |
| tester | code | test |
| guardian | code | review |
| pusher | review, test | deployment |

## 3. So sánh

Trước: `builder nhận plan.md`
Sau: `builder.input_contract → artifact:plan (type, không phải file)`

Manager resolve type → id cụ thể trong workflow hiện tại.

## 4. Tương tác

- `agents/contracts/input.schema.yaml` → mapping.
- `manager.md` resolve qua artifact type + workflow.
- Context Engine dùng contract để biết cần đưa artifact nào.