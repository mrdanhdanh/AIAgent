---
description: Chạy toàn bộ team workflow: analyze → design/plan → review → backup → build → static analysis → ui audit → testplan → test → skill validation → complete
agent: general
---

## HELP — Hướng dẫn sử dụng `/team`

**Mục đích:** Thin launcher chạy Dev Agent Team workflow qua **Workflow Engine v4** — pipeline 8 module
(engine, loader, validator, executor, phase-runner, state-machine, recovery) thay cho body 13 bước cũ.

**Cách dùng:** `/team <yêu cầu> [--workflow <default|bugfix|feature|ui|docs>]` — mặc định `default`.

**Đầu vào:** Mô tả yêu cầu phát triển (tiếng Việt hoặc tiếng Anh), ví dụ:
`/team Thêm chức năng reset password --workflow feature`

**Đầu ra:** Báo cáo cuối cùng gồm phân tích, kế hoạch, kết quả build, kết quả test,
coverage, skill validation suggestions, kèm artifacts trong `.opencode/workflow/<WF-ID>/`.

**Các lệnh thành phần (chạy riêng lẻ):**
- `/team-analyze` — Phân tích yêu cầu
- `/team-plan` — Thiết kế + Lập kế hoạch
- `/team-review` — Đánh giá kế hoạch
- `/team-build` — Thực thi code
- `/team-ui-audit` — Kiểm tra UI
- `/team-testplan` — Lập kế hoạch test
- `/team-test` — Chạy kiểm thử
- `/team-selfimprove` — Đề xuất cải tiến
- `/team-bug-learn` — Học từ bug vừa fix (Learning Pipeline 1 lệnh: failure record + lessons/patterns)
- `/team-gitguard` — Review security trước push
- `/team-gitpush` — Push an toàn lên git
- `/team-syncdocs` — Đồng bộ system docs

**Xem thêm:** `.opencode/workflow-engine/README.md`, `.opencode/workflow/MIGRATION_GUIDE.md`,
`.opencode/skills/dev-team/SKILL.md` (bản 13 bước đầy đủ cũ)

---

## WORKFLOW ENGINE (v4)

Bạn là General Agent đóng vai Workflow Engine. Làm theo `.opencode/workflow-engine/engine.md`.

1. Parse `$ARGUMENTS`: regex `--workflow\s+([\w-]+)` → workflowName (mặc định `default`).
2. Đọc engine docs theo thứ tự: `README.md` → `engine.md` → `loader.md` → `validator.md` → `executor.md` → `phase-runner.md` → `recovery.md` → `state-machine.md`.
3. Load definitions: `.opencode/workflow/definitions/<workflowName>.workflow.yaml`.
4. Thực thi theo `executor.md`: load → validate (validator.md, WF-ERR-00x kèm file:line) → resolve deps → run từng phase qua phase-runner → validate output → save artifact (`.opencode/workflow/<WF-ID>/`) → update state (`.opencode/workflow/<WF-ID>/state.json`).
5. Hỗ trợ `WF_CONTEXT_ROOT` override context root (cho smoke-test).
6. FALLBACK: thiếu engine docs/definitions/lỗi bất kỳ → BÁO LỖI có file:line, gợi ý `/team-syncdocs`. TUYỆT ĐỐI KHÔNG tự fallback về quy trình cũ (đã xóa).

---

Yêu cầu: $ARGUMENTS

## Flags:

| Flag | Y nghia |
|------|---------|
| `--workflow <type>` | Loai workflow (default/bugfix/feature/ui/docs) |
| `--analyze` | Chi phan tich |
| `--plan` | Chi lap ke hoach |
| `--build` | Chi code |
| `--test` | Chi test |
| `--gitpush` | Push sau khi xong |

## Output Contract

- **Output**: workflow report (analyze/plan/build/test artifacts).
- **Format**: markdown artifacts.

