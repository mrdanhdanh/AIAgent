Sau khi xem các tài liệu, tôi nghĩ **không nên nâng cấp theo kiểu thêm agent hoặc thêm command nữa**. Framework hiện tại đã khá đầy đủ về chức năng. Điểm yếu nằm ở **kiến trúc (architecture)**, khiến việc bảo trì sẽ ngày càng khó khi số agent, skill và command tiếp tục tăng.  

Tôi đề xuất roadmap **Agent Framework v4** kéo dài khoảng 6–8 tuần, tập trung vào việc biến framework thành một nền tảng có thể mở rộng.

---

# Giai đoạn 0 – Baseline (1-2 ngày)

## Mục tiêu

Đóng băng phiên bản hiện tại để có thể rollback.

### Công việc

* Đánh tag v3.x
* Xuất sơ đồ toàn bộ Agent/Command/Skill
* Thống kê

  * số Agent
  * số Command
  * số Skill
  * số Workflow
  * số Contract
* Sinh Architecture Report

Output

```
SYSTEM_BASELINE.md
ARCHITECTURE_MAP.md
DEPENDENCY_GRAPH.md
```

---

# Phase 1 — Workflow Engine

Đây là phần quan trọng nhất.

Hiện tại

```
/team

↓

Analyze

↓

Plan

↓

Review

↓

Build

↓

...
```

được viết cứng trong command. 

Mục tiêu:

```
workflow.yaml

↓

Workflow Engine

↓

Phase Runner
```

Ví dụ

```yaml
workflow:

- analyze

- design

- plan

- review

- guardrail

- backup

- build

- static_analysis

- ui_audit

- test
```

Workflow Engine chỉ đọc YAML.

Sau này chỉ cần tạo

```
workflow-web.yaml

workflow-mobile.yaml

workflow-api.yaml

workflow-doc.yaml
```

không sửa code.

---

### Thư mục mới

```
.opencode/

workflow-engine/

engine.md

executor.md

validator.md

phase-runner.md
```

---

# Phase 2 — Capability Registry

Hiện giờ

```
Planner

Builder

Tester
```

được gọi theo tên.

Nên chuyển thành

```
Capability

↓

Agent

↓

Skill

↓

Command
```

Ví dụ

```
Design UI

↓

ui-beautifier

↓

ui-ux-pro-max

↓

team-ui-audit
```

Sinh

```
registry.yaml
```

Ví dụ

```yaml
capability:

id: ui.design

agents:

- ui-beautifier

skills:

- ui-ux-pro-max

commands:

- team-ui-audit
```

Lợi ích

* Dynamic Routing
* Không hardcode tên Agent

---

# Phase 3 — Agent Metadata

Mỗi agent hiện chỉ là prompt.

Nên thêm

```
agent.yaml
```

Ví dụ

```yaml
name:

version:

owner:

priority:

capabilities:

supported_languages:

input_contract:

output_contract:

dependencies:

estimated_tokens:

estimated_time:
```

Engine sẽ tự chọn agent phù hợp.

---

# Phase 4 — Context Engine

Đây là nâng cấp giúp tiết kiệm token nhiều nhất.

Hiện tại

```
Analysis

↓

Design

↓

Plan
```

toàn bộ context truyền tiếp.

Nên chia thành

```
Project Context

Task Context

Knowledge Context

Memory Context

Workflow Context

Artifact Context
```

Mỗi Agent chỉ nhận phần cần.

Ví dụ

Builder không cần

```
Knowledge

History

Review Detail
```

chỉ cần

```
Plan

Files

Task
```

Có thể giảm 40–70% token.

---

# Phase 5 — Artifact Manager

Hiện artifact chỉ là

```
01_analysis.md

02_design.md

03_plan.md
```

Nên thêm metadata

```yaml
id:

version:

author:

agent:

workflow:

schema:

checksum:

depends_on:

generated_at:
```

Tạo

```
artifact-index.json
```

Lợi ích

* Version
* Dependency
* Rollback
* Diff

---

# Phase 6 — Event Bus

Hiện tại

```
Planner

↓

Builder
```

được gọi trực tiếp.

Đổi thành

```
Planner

↓

PLAN_READY

↓

Builder
```

Ví dụ

```
BUILD_FINISHED

TEST_FAILED

REVIEW_APPROVED

KNOWLEDGE_UPDATED

ROLLBACK_REQUESTED
```

Sau này thêm agent không cần sửa workflow.

---

# Phase 7 — Simulation Engine

Đây là nâng cấp tôi đánh giá rất đáng giá.

Command mới

```
/team-simulate
```

Nó sẽ

```
Mock User

↓

Workflow

↓

Mock Agent

↓

Validate

↓

Report
```

Không sửa file.

Không build.

Không test.

Chỉ giả lập.

Phát hiện

* deadlock
* retry vô hạn
* context mất
* contract sai
* phase thiếu
* artifact lỗi

---

# Phase 8 — Doctor v2

Doctor hiện thiên về

* schema
* command
* yaml
* workflow
* skill

Nên bổ sung

## Behavioral Test

```
Planner

↓

Sample Input

↓

Output

↓

Validator
```

## Capability Coverage

Ví dụ

```
Capability

↓

Agent

↓

Skill

↓

Command
```

thiếu mắt xích nào sẽ báo.

## Token Analysis

Ví dụ

```
Workflow

↓

ước lượng token

↓

phase nào tốn nhất
```

---

# Phase 9 — Knowledge Graph

Hiện tại

```
knowledge/

memory/

lesson/
```

là markdown.

Sinh

```
knowledge-index.json
```

Ví dụ

```yaml
topic:

framework:

language:

tags:

confidence:

references:
```

Có thể thêm graph

```
Blazor

↓

FluentUI

↓

Dark Mode

↓

Pattern
```

---

# Phase 10 — Self Evolution Engine

Hiện Self Improve mới dừng ở suggestion. 

Nâng thành

```
Workflow

↓

Metrics

↓

Suggestion

↓

Simulation

↓

Approval

↓

Migration

↓

Version
```

Tự tạo

```
migration.md

change-log.md

compatibility-report.md
```

---

# Phase 11 — Plugin Architecture

Cho phép người khác cài Agent.

Ví dụ

```
plugins/

security/

review/

python/

aws/

oracle/

blazor/
```

Chỉ cần

```
plugin.yaml

agent.md

skill.md
```

Engine tự nhận.

---

# Phase 12 — Dashboard

Sinh

```
SYSTEM_DASHBOARD.md
```

hiển thị

```
Health

Workflow

Agent

Skill

Knowledge

Memory

Doctor

Coverage

Token

Performance
```

---

# Cấu trúc v4 đề xuất

```
.opencode/

agents/

skills/

commands/

contracts/

workflow-engine/

registry/

context/

artifacts/

events/

knowledge/

memory/

plugins/

doctor/

simulator/

metrics/

dashboard/
```

---

# Các command mới

| Command           | Mục đích                                                            |
| ----------------- | ------------------------------------------------------------------- |
| `/team-simulate`  | Giả lập toàn bộ workflow mà không sửa mã nguồn                      |
| `/team-profile`   | Phân tích token, thời gian và chi phí theo từng phase               |
| `/team-registry`  | Kiểm tra Capability Registry và dependency giữa Agent/Skill/Command |
| `/team-context`   | Phân tích luồng context, phát hiện truyền dư hoặc thiếu             |
| `/team-graph`     | Sinh sơ đồ Agent, Workflow và Dependency                            |
| `/team-migrate`   | Nâng cấp schema, workflow và contract giữa các phiên bản            |
| `/team-plugin`    | Quản lý plugin Agent/Skill                                          |
| `/team-benchmark` | Chạy benchmark nhiều workflow để đánh giá hiệu năng                 |
| `/team-replay`    | Phát lại một workflow cũ để debug hoặc so sánh kết quả              |
| `/team-profiler`  | Phân tích hiệu năng chi tiết của từng agent, phase và artifact      |

## Thứ tự ưu tiên triển khai

1. **Workflow Engine** (nền tảng)
2. **Capability Registry**
3. **Context Engine**
4. **Artifact Manager**
5. **Simulation Engine**
6. **Doctor v2**
7. **Knowledge Graph**
8. **Plugin Architecture**
9. **Dashboard**
10. **Self Evolution Engine**

Nếu hoàn thành đầy đủ các hạng mục này, framework sẽ chuyển từ một hệ thống điều phối dựa trên prompt sang một **AI Agent Platform** có kiến trúc module hóa, workflow khai báo (declarative), khả năng tự kiểm tra, tự mô phỏng và dễ mở rộng cho nhiều dự án khác nhau.
