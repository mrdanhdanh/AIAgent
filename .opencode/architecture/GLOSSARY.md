---
name: architecture-glossary
description: GLOSSARY — thuật ngữ thống nhất của Agent Framework v4. Toàn bộ framework dùng cùng định nghĩa.
agent: general
---

# GLOSSARY.md — Thuật Ngữ

> Thuật ngữ thống nhất. Mọi tài liệu trong framework dùng cùng định nghĩa này.

## A

- **Agent** — thành phần thực thi một tập capability; stateless, đăng ký trong agent-registry. (18 agents)
- **Artifact** — sản phẩm của một phase, có type/checksum/version/dependency. (plan, report, test result...)
- **Approval Gate** — cơ chế bắt buộc xác nhận user trước hành động rủi ro cao.

## C

- **Capability** — năng lực khai báo (id, contract, provider, priority). Resolver route theo capability, không theo tên agent. (38 capabilities)
- **Capability Registry** — registry đăng ký capability/agent/skill/command/contract; validate theo CR-001..009.
- **Command** — lối vào hệ thống (`/team`, `/ask`, `/test-e2e`...). (54 commands)
- **Context** — dữ liệu scope theo phiên, isolation; có token count, version.
- **Context Engine** — quản lý context: tạo/lưu/compress/theo scope.
- **Contract** — khai báo input/output + validation của một đối tượng.

## D

- **Doctor** — chương trình chẩn đoán sức khỏe framework (health score + self-repair).

## E

- **Event** — thông điệp phản ứng (`BUILD_FINISHED`), có source/payload; emit ở mọi chuyển pha.
- **Event System** — nhận sự kiện, route handler, phòng loop (EVT-002).

## K

- **Knowledge** — kiến thức khóa học/lesson trong `.opencode/knowledge/`; đánh index bởi Knowledge Index.
- **Knowledge Index** — 7 loại index để truy vấn nhanh.

## M

- **Memory** — failure memory, lessons, patterns trong `.opencode/memory/`; learning-agent ghi.

## P

- **Phase** — đơn vị thực thi trong workflow, có state/retry/dependency.
- **Phase Runner** — thành phần chạy một phase.

## R

- **Registry** — nơi đăng ký metadata thống nhất (capability/agent/skill/command/contract).
- **Runtime** — môi trường thực thi workflow (Workflow Runtime / engine).

## S

- **Skill** — kỹ năng tái sử dụng, cung cấp capability, có SKILL.md. (29 skills)
- **Simulation** — chạy thử workflow/agent không đụng file thật; dùng để verify trước khi deploy.
- **State Machine** — bảng chuyển trạng thái chuẩn (WORKFLOW/PHASE/AGENT/ARTIFACT).

## W

- **Workflow** — chuỗi phase điều phối bởi runtime; định nghĩa bằng YAML. (5 definitions)
- **Workflow Runtime** — engine đọc definition, validate, chạy phase, quản lý state/retry/rollback.

## Thuật ngữ so sánh nhanh

| Thuật ngữ | Không nên nhầm với |
|-----------|---------------------|
| Capability | Command (capability = năng lực, command = lối vào) |
| Agent | Workflow (agent thực thi, workflow điều phối) |
| Context | Artifact (context = trạng thái, artifact = sản phẩm) |
| Skill | Agent (skill thuộc agent, không tự chạy) |