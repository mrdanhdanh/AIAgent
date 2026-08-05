# He Thong .opencode - So Do Tong The

> **Tu dong tao luc:** 2026-08-05 00:15:04
> **Workflow ID:** WF-20260805-SYNC
> **Cap nhat:** Toan bo agents, commands, skills, scripts, knowledge

---

## Muc luc

- [Cau truc thu muc](#cau-truc-thu-muc)
- [Agents](#agents)
- [Commands](#commands)
- [Skills](#skills)
- [Scripts](#scripts)
- [Knowledge Base](#knowledge-base)
- [Ma tran Cross-Reference](#ma-tran-cross-reference)
- [Workflow Overview](#workflow-overview)
- [Phat hien van de](#phat-hien-van-de)

---

## Cau truc thu muc

```
.opencode/
|-- agents/           # 18 agent definitions
|-- commands/         # 56 command templates
|-- skills/           # 28 skill packages
|-- scripts/          # 54 utility scripts
|-- knowledge/        # Knowledge base
|-- backup/           # Backup artifacts
|-- workflow/         # Workflow artifacts
'-- workflows/        # Workflow snapshots
```

---

## Agents

| Agent | Description | Model | Permissions | Commands |
|-------|-------------|-------|-------------|----------|
| analyst | Phân tích yêu cầu người dùng, xác định phạm vi, rủi ro và các task cần thực hiện | opencode-go/deepseek-v4-flash |  | team-analyze |
| backup-agent | Backup và rollback file dùng Backup Utility. Hỗ trợ: backup trước khi sửa file, rollback khi catastrophic failure, liệt kê backup history, verify backup integrity. | opencode-go/deepseek-v4-flash |  | backup |
| builder | Thực thi kế hoạch đã được đánh giá, viết code và thực hiện thay đổi | opencode-go/deepseek-v4-flash |  | team-build |
| cleaner | Workspace Cleaner Agent v2.0 — quét rác theo tiêu chí cấu hình chi tiết, phân loại LOW/MEDIUM/HIGH, backup workflow-linked, dry-run bắt buộc, protected list 4 nhóm. | opencode-go/deepseek-v4-flash |  | team-cleanup |
| codebase-explorer | Khám phá cấu trúc dự án, phân tích codebase, mapping dependencies và patterns. Agent read-only chạy trước khi thực hiện thay đổi. | opencode-go/deepseek-v4-flash |  | team-explore |
| failure-agent | Chuyên gia phân tích và chuẩn hóa lỗi — normalize+hash do failure-analyzer.ps1 tính, agent chỉ classify, search failure/lesson/pattern memory, score và đề xuất. Read-only (bash chỉ chạy failure-analyzer.ps1). | opencode-go/deepseek-v4-flash |  | team-analyze-failure |
| general | General-purpose orchestrator agent — điều phối workflow, triệu hồi sub-agents, quản lý state machine | opencode-go/deepseek-v4-flash |  | team-runtime-benchmark, team-syncdocs, model-policy, team-doctor, doctor, team-bugfix, trace, test-bootstrap, ask, explain, team-capabilities, flow, why, compare-doc, test-cross-browser, doctor-test, test-e2e, where, impact, approve-test, team |
| guardian | Chuyên gia review source code trước khi push lên git — phát hiện secret, lỗi convention, lỗ hổng bảo mật, vi phạm quy tắc dự án | opencode-go/deepseek-v4-flash |  | team-gitguard |
| knowledge-agent | Intent Analyzer + Router cho Knowledge Assistant — phân loại câu hỏi, chọn skill pipeline, tổng hợp trả lời có nguồn | opencode-go/deepseek-v4-flash |  | knowledge-compare-doc, knowledge, knowledge-trace, knowledge-impact, knowledge-health, knowledge-ask, knowledge-index, knowledge-why, knowledge-explain, knowledge-flow, knowledge-where |
| learning-agent | Chuyên gia Learning Pipeline — đọc failure records từ memory, phân tích patterns xuyên suốt, auto-generate lessons và patterns mới. Ghi trực tiếp vào memory/. Cần approval gate cho MEDIUM/HIGH impact. | opencode-go/deepseek-v4-flash |  | team-learn |
| planner | Mở rộng: Thiết kế giải pháp + Lập kế hoạch thực thi chi tiết. Đảm nhiệm cả Design phase và Plan phase. | opencode-go/deepseek-v4-flash |  | team-plan |
| pusher | Chuyên gia thực hiện git push an toàn — auto-commit từ diff, safety checks, build, test, confirmation gate, push execution, post-push verify | opencode-go/deepseek-v4-flash |  | team-gitpush |
| reviewer | Đánh giá kế hoạch thực thi, kiểm tra tính đúng đắn, đầy đủ và hiệu quả | opencode-go/deepseek-v4-flash |  | team-review |
| root-cause-agent | Chuyên gia phân tích nguyên nhân gốc (Root Cause Analysis) — nhận error đã normalized, tìm kiếm trong codebase, tạo hypotheses với confidence score, đề xuất hướng fix. Agent read + suggest. | opencode-go/deepseek-v4-flash |  | team-root-cause |
| self-improver | Sau khi workflow hoàn tất, đọc lại quá trình, phân tích kỹ năng đã dùng và thiếu, đề xuất cải tiến (chỉ suggestion, không ghi KB). Cần qua approval gate trước khi ghi knowledge base. | opencode-go/deepseek-v4-flash |  | team-selfimprove |
| tester | Thực thi kiểm thử, validate tính năng và báo cáo kết quả kèm coverage (v3.0) | opencode-go/deepseek-v4-flash |  | team-test |
| test-planner | Tạo kế hoạch kiểm thử chi tiết, chống overlap, có impact analysis, coverage matrix, risk-based testing | opencode-go/deepseek-v4-flash |  | team-testplan, test-regression, test-plan, test-audit, test-evolve |
| ui-beautifier | >- | opencode-go/deepseek-v4-flash |  | test-accessibility, test-visual, test-ui, team-ui-audit, impeccable |

---

## Commands

| Command | Description | Agent | Deprecated |
|---------|-------------|-------|------------|
| /approve-test | Approve Test Gate — gate cuối trước merge. Chặn nếu coverage < 80%, flaky, accessibility error, visual diff, failed E2E, broken responsive, missing critical scenario | general |  |
| /ask | Hỏi đáp tự do về codebase — module, API, màn hình, workflow. Điều phối Knowledge Assistant pipeline với intent analyzer | general |  |
| /backup | Backup và rollback file dùng Backup Utility. Gọi khi cần backup trước khi sửa file, rollback lỗi, kiểm tra backup. | backup-agent |  |
| /compare-doc | So sánh code hiện tại với tài liệu thiết kế — phát hiện lệch pha, lỗi thời, và thay đổi chưa được tài liệu hóa | general |  |
| /doctor | Doctor — kiểm tra sức khỏe hệ thống AI Agent Framework: Environment, Agents, Commands, Skills, Knowledge, Workflow, Contracts, Runtime (simulation), Capability (benchmark). Tích hợp health score, self-repair an toàn. Dùng /doctor hoặc /team-doctor. | general |  |
| /doctor-test | QA Doctor — kiểm tra sức khỏe bộ test: thiếu test, duplicate, flaky, timeout, coverage thấp, screenshot cũ, selector dễ hỏng, hardcode wait, missing assertion, missing cleanup, dead test, orphan page object. Health Score + Risk | general |  |
| /explain | Giải thích từng method trong một file source — input, output, logic, side-effect, dependencies | general |  |
| /flow | Sinh mô tả luồng hoạt động (sequence, mermaid) cho một nghiệp vụ hoặc màn hình — từ code thực tế | general |  |
| /impact | Phân tích ảnh hưởng khi sửa một component — sửa X ảnh hưởng API/Screen/Batch/Report/SP nào. Quan trọng nhất cho thay đổi an toàn | general |  |
| /impeccable | Design, redesign, shape, critique, audit, polish, or improve frontend UI. Sub-commands: init, shape, document, critique, audit, polish, bolder, quieter, distill, harden, onboard, animate, colorize, typeset, layout, delight, overdrive, clarify, adapt, optimize, live, hooks, doctor, extract. | ui-beautifier |  |
| /knowledge | Help + routing cho Knowledge Assistant — liệt kê 10 commands, intent mapping, ví dụ sử dụng | knowledge-agent |  |
| /knowledge-ask | Hỏi Knowledge Assistant — module/component/service này hoạt động thế nào, dùng để làm gì | knowledge-agent |  |
| /knowledge-compare-doc | So sánh code hiện tại với tài liệu thiết kế — phát hiện lệch lạc giữa code và docs | knowledge-agent |  |
| /knowledge-explain | Giải thích từng method của một file — class summary, method list, DI dependencies, lifecycle | knowledge-agent |  |
| /knowledge-flow | Mô tả workflow của một chức năng/màn hình — user flow, business flow, sinh mermaid sequence diagram | knowledge-agent |  |
| /knowledge-health | Đánh giá sức khỏe kiến thức hệ thống — phát hiện thiếu README, diagram, flow, ADR, comment, tài liệu lỗi thời | knowledge-agent |  |
| /knowledge-impact | Phân tích ảnh hưởng khi sửa một symbol/file — affected screens, services, models, tests kèm mức độ | knowledge-agent |  |
| /knowledge-index | Build/update Knowledge Index — quét source code + tài liệu sinh 7 loại index (code, symbol, api, database, dependency, document, business-rule). Chạy sau mỗi lần source thay đổi | knowledge-agent |  |
| /knowledge-trace | Trace luồng hoạt động end-to-end — UI → Service → Model → LocalStorage, sinh chuỗi trace dạng cây | knowledge-agent |  |
| /knowledge-where | Tìm toàn bộ nơi sử dụng một symbol/pattern — class, method, property, LocalStorage key | knowledge-agent |  |
| /knowledge-why | Giải thích lý do tồn tại của một symbol/thiết kế — đọc tài liệu, git history, code context | knowledge-agent |  |
| /model-policy | Bật/tắt free model (opencode-go/deepseek-v4-flash) cho toàn bộ agent/skill/command. Đọc setting từ .opencode/model-policy/settings.json | general |  |
| /team | Chạy toàn bộ team workflow: analyze → design/plan → review → backup → build → static analysis → ui audit → testplan → test → skill validation → complete | general |  |
| /team-analyze | Chỉ chạy bước phân tích yêu cầu (dùng agent analyst) | analyst |  |
| /team-analyze-failure | Phân tích lỗi trong workflow. Chạy failure-analyzer.ps1 (normalize+SHA256 deterministic) rồi gọi failure-agent classify + search failure memory. Output YAML contract v2. | failure-agent |  |
| /team-bugfix | Quy trình nhận và fix bug — nhận báo cáo → tái hiện bug → root cause → đề xuất chỉnh sửa → kiểm tra sau sửa → test bUnit + E2E → báo cáo. Dùng agent general (orchestrator) + agents chuyên biệt | general |  |
| /team-build | Thực thi kế hoạch đã duyệt (dùng agent builder) | builder |  |
| /team-capabilities | Khám phá năng lực System — liệt kê capability theo category, reset agent/skill/command maps từ capability. Là giao diện discovery của Capability Registry. | general |  |
| /team-cleanup | Dọn rác Workspace tự động — xóa build artifacts, backup cũ, temp files, cache. Tích hợp dry-run, backup trước khi xóa, confirmation gate. | cleaner |  |
| /team-doctor | Doctor (alias /team-doctor) — kiểm tra sức khỏe hệ thống AI Agent Framework. Tương đương /doctor: Environment, System, Runtime, Capability, health score, self-repair an toàn. | general |  |
| /team-explore | [DEPRECATED] Explore step đã được gộp vào Analyze. Dùng team-analyze thay thế. | codebase-explorer | Yes |
| /team-gitguard | Review source code trước khi push lên git — phát hiện secret, lỗi convention, lỗ hổng bảo mật, vi phạm quy tắc dự án | guardian |  |
| /team-gitpush | Auto-commit từ diff, pre-push safety validation + git push execution — kiểm tra secret, convention, build, test, xác nhận user, push lên remote | pusher |  |
| /team-learn | Chạy Learning Pipeline — quét failure records, auto-generate lessons và patterns, cập nhật memory. Gọi learning-agent. | learning-agent |  |
| /team-plan | Mở rộng: Thiết kế (Design) + Lập kế hoạch (Plan) — dùng agent planner | planner |  |
| /team-review | Đánh giá thiết kế hoặc kế hoạch (dùng agent reviewer) — nâng cấp v4.0: decision thresholds, score_rationale, blocking issues, consistency, edge cases | reviewer |  |
| /team-root-cause | Phân tích nguyên nhân gốc từ failure analysis. Tìm evidence trong codebase, tạo hypotheses, đề xuất fix. Gọi root-cause-agent. | root-cause-agent |  |
| /team-runtime-benchmark | Chạy benchmark Workflow Runtime — đo Compile/Execution/Retry/Recovery/Persistence/Validation. Không cần AI, dùng mock dispatcher. Output: benchmark report + cập nhật Runtime Certificate. | general |  |
| /team-selfimprove | Phân tích workflow và đề xuất cải tiến (chỉ suggestion, không ghi KB) | self-improver |  |
| /team-syncdocs | System Evolution Engine — đồng bộ system docs + semantic diff + compatibility check + migration + self-healing + health score + simulation (runtime validation) + capability benchmark + stress test + evolution report. Chạy định kỳ để duy trì sức khỏe hệ thống. | general |  |
| /team-test | Thực thi kiểm thử theo kế hoạch (dùng agent tester, v3.0) | tester |  |
| /team-testplan | Tạo kế hoạch kiểm thử chi tiết — impact analysis, risk-based, validation rules (schema v3.0) | test-planner |  |
| /team-ui-audit | >- | ui-beautifier |  |
| /test-accessibility | Accessibility testing — Run Axe → Generate Report → Fix Suggestion. Tích hợp skill accessibility | ui-beautifier |  |
| /test-audit | Audit chất lượng tổng thể bộ test — coverage theo chức năng, duplication, maintainability, thời gian chạy, flaky rate → kế hoạch cải thiện theo ưu tiên | test-planner |  |
| /test-bootstrap | Bootstrap QA — phân tích dự án (Blazor, React, Angular...), tự phát hiện framework UI, route structure, sinh cấu hình Playwright + Page Object + Fixture + thư mục test ban đầu | general |  |
| /test-cross-browser | Cross-browser testing — Chrome, Edge, Firefox, Safari + iPhone/Android. Tích hợp skill browser-compatibility | general |  |
| /test-e2e | Chạy pipeline E2E — Requirement → Playwright → Fixture → Run → Report. Sinh test Playwright tự động theo skill playwright-e2e | general |  |
| /test-evolve | Evolve test suite — so sánh thay đổi source code với test hiện có, xác định test cần cập nhật, test lỗi thời, sinh test mới cho chức năng mới | test-planner |  |
| /test-plan | Sinh toàn bộ kế hoạch test — Requirement → Test Matrix → Scenario → Boundary → Edge Case → Priority | test-planner |  |
| /test-regression | Regression testing — tự động chọn module bị ảnh hưởng, sinh regression cases, chạy và báo cáo | test-planner |  |
| /test-ui | Review UI tổng hợp — đọc project, đánh giá UI/UX/Consistency/Responsive/Accessibility. Tích hợp skills ui-review, design-system-validator, responsive-layout, accessibility | ui-beautifier |  |
| /test-visual | Visual regression testing — Take Screenshot → Compare → Generate Diff → Generate Report. Tích hợp skills visual-regression, screenshot-analyzer | ui-beautifier |  |
| /trace | Truy vết luồng xử lý từ đầu đến cuối — UI → API → Service → Repository → DB → Response, kèm evidence từng bước | general |  |
| /where | Tìm toàn bộ nơi sử dụng một symbol (class, method, field, storage key, db object) trong codebase — kèm file:line và phân loại | general |  |
| /why | Giải thích lý do tồn tại / thiết kế của một component — từ tài liệu, git history, và code | general |  |

---

## Skills

| Skill | Name | Description | Schema Version |
|-------|------|-------------|----------------|
| accessibility | accessibility | Kiểm tra accessibility — ARIA, Tab Order, Screen Reader, Keyboard, Color Contrast, Alt, Label, Focus Ring. Sinh báo cáo WCAG AA/AAA. Sử dụng câu lệnh /test-accessibility. | 1.0 |
| answer-builder | answer-builder | Ghép toàn bộ thông tin từ các skill thành câu trả lời hoàn chỉnh — có nguồn, không suy đoán. Format: Nguồn → Phân tích → Kết luận. Dùng trong mọi command knowledge. | 1.0 |
| architecture-reader | architecture-reader | Hiểu kiến trúc hệ thống — Layer, DDD, Clean, CQRS, MVC, MVVM. Xác định module nằm layer nào, phát hiện vi phạm architecture. Dùng trong /ask, /explain. | 1.0 |
| browser-compatibility | browser-compatibility | Kiểm tra tương thích trình duyệt — Chrome, Edge, Firefox, Safari + iPhone/Android. Phát hiện API/code không tương thích. Sử dụng câu lệnh /test-cross-browser. | 1.0 |
| code-understanding | code-understanding | Hiểu source code — đọc C#, Razor, VB, SQL, PL/SQL, JS, TS, CSS. Trả lời Class, Method, Call Graph, Dependency, Lifecycle, DI, Interface, Inheritance. Dùng trong /explain, /trace, /where. | 1.0 |
| database-reader | database-reader | Đọc và phân tích database — Table, View, Package, Procedure, Trigger, Index, FK. Trả lời bảng dùng ở đâu, procedure gọi bởi ai, field nullable. Dùng trong /where, /impact, /trace. | 1.0 |
| dependency-analyzer | dependency-analyzer | Xây dựng và phân tích dependency graph — Call Graph, Module Graph, Reference Graph, Database Graph, Service Graph (DI). Dùng trong /where, /impact, /trace. | 1.0 |
| design-system-validator | design-system-validator | Kiểm tra source code tuân thủ Design System FluentUI — Primary/Secondary/Danger Button, Text Size, Border Radius, Elevation, Shadow, spacing tokens. Sử dụng câu lệnh /test-ui --validate. | 1.0 |
| dev-team | dev-team | Hướng dẫn sử dụng Dev Agent Team gồm 12 agents (10 core + 2 support). Dùng khi cần phân tích, lập kế hoạch, đánh giá, code, kiểm thử một yêu cầu phát triển. Tích hợp cơ chế Self-Improvement với approval gate, Failure Learning System với Root Cause Analysis và Learning Pipeline. Sử dụng câu lệnh team hoặc team-*. | 3.2 |
| document-understanding | document-understanding | Đọc và hiểu tài liệu — README, SPEC, Design, Wiki, Markdown, PDF, Excel, Word. Trích xuất Requirement, Business Rule, Flow, Constraint, Decision. Dùng trong /why, /compare-doc, /knowledge-health. | 1.0 |
| flaky-test-detector | flaky-test-detector | Phân tích test flaky — retry, timeout, animation, network, wait, race condition. Đưa ra nguyên nhân gốc và cách khắc phục. Sử dụng trong /doctor-test, /test-audit. | 1.0 |
| gitguard | gitguard | Review source code trước khi push lên git — phát hiện secret, lỗi convention, lỗ hổng bảo mật, vi phạm quy tắc dự án. Tích hợp cơ chế blocking CRITICAL, cảnh báo MAJOR. Sử dụng câu lệnh /team-gitguard. | 2.0 |
| git-history | git-history | Truy vấn lịch sử git — ai sửa, khi nào, lý do, commit nào. Dùng git log/blame. Dùng trong /why, /ask. | 1.0 |
| gitpush | gitpush | Pre-push safety validation + git push execution — kiểm tra secret, convention, build, test, sau đó push lên remote với xác nhận từ user. Sử dụng câu lệnh /team-gitpush. | 1.0 |
| impact-analyzer | impact-analyzer | Phân tích ảnh hưởng khi sửa component — sửa X ảnh hưởng API/Screen/Batch/Report/SP nào. Quan trọng nhất trong Knowledge Assistant. Dùng trong /impact. | 1.0 |
| impeccable | impeccable | Use when the user wants to design, redesign, shape, critique, audit, polish, clarify, distill, harden, optimize, adapt, animate, colorize, extract, or otherwise improve a frontend interface. Covers websites, landing pages, dashboards, product UI, app shells, components, forms, settings, onboarding, and empty states. Handles UX review, visual hierarchy, information architecture, cognitive load, accessibility, performance, responsive behavior, theming, anti-patterns, typography, fonts, spacing, layout, alignment, color, motion, micro-interactions, UX copy, error states, edge cases, i18n, and reusable design systems or tokens. Also use for bland designs that need to become bolder or more delightful, loud designs that should become quieter, live browser iteration on UI elements, or ambitious visual effects that should feel technically extraordinary. Not for backend-only or non-UI tasks. | 1.0 |
| knowledge-assistant | knowledge-assistant | Knowledge Assistant — điều phối pipeline trả lời mọi câu hỏi về codebase: Intent Analyzer → Knowledge Planner → Code/Doc Skill → Dependency → Search/Impact → Answer Builder. Hỗ trợ /ask, /where, /why, /flow, /impact, /explain, /trace, /compare-doc, /knowledge-health. | 1.0 |
| playwright-component | playwright-component | Sinh test component-level cho FluentUI — button, textbox, dropdown, dialog, grid, form. Kiểm tra validation, keyboard, focus, tab order, shortcut. Dùng bUnit cho Blazor component. Sử dụng câu lệnh /test-e2e kèm --component. | 1.0 |
| playwright-e2e | playwright-e2e | Sinh test E2E Playwright hoàn chỉnh — Playwright Test, Page Object, Test Fixture, Mock API, Login Helper. Input: Screen/API/Requirement. Output: tests/, page-object/, fixtures/. Sử dụng câu lệnh /test-e2e. | 1.0 |
| responsive-layout | responsive-layout | Kiểm tra layout responsive — viewports 320/375/768/1024/1366/1920, overflow, horizontal scroll, hidden control, broken layout, flex, grid. Sử dụng câu lệnh /test-ui --responsive. | 1.0 |
| screenshot-analyzer | screenshot-analyzer | Đọc và phân tích screenshot — layout, alignment, color, missing icon, wrong font, blur, cropped, wrong spacing. Hỗ trợ Vision Model. Sử dụng câu lệnh /test-visual --analyze. | 1.0 |
| search-engine | search-engine | Semantic search trong codebase — tìm đoạn xử lý, nơi dùng symbol, export/import. Kết hợp Knowledge Index + grep. Dùng trong /where, /ask. | 1.0 |
| test-data-generator | test-data-generator | Sinh dữ liệu test — User, Customer, Order, Invoice, Large Dataset, Boundary Value, Invalid Data, Random Data. Không dùng credential/secret thật. Sử dụng trong /test-e2e, /test-plan. | 1.0 |
| test-report | test-report | Sinh báo cáo kiểm thử — HTML, Markdown, JSON, JUnit, Allure. Gồm coverage, failed, passed, skipped, screenshot, video, trace. Sử dụng trong /test-e2e, /doctor-test, /approve-test. | 1.0 |
| ui-review | ui-review | Đánh giá UI tĩnh (không chạy code) — đọc HTML, Razor, CSS, Tailwind, FluentUI. Kiểm tra spacing, padding, margin, alignment, font, icon, white space, consistency. Sử dụng câu lệnh /test-ui. | 1.0 |
| visual-regression | visual-regression | Visual regression testing — expect(page).toHaveScreenshot(), multi-viewport (Desktop/Tablet/Mobile/Dark/Light), pixel diff, threshold, ignore animation và dynamic content. Sử dụng câu lệnh /test-visual. | 1.0 |
| workflow-reader | workflow-reader | Đọc và mô tả luồng hoạt động — Flow, Diagram, Mermaid, Sequence, State Machine. Trả lời User Flow, Business Flow, API Flow. Dùng trong /flow, /trace. | 1.0 |
| workspace-cleaner | workspace-cleaner | Dọn rác Workspace tự động — xóa build artifacts, backup cũ, temp files, cache không cần thiết. Tích hợp dry-run bắt buộc, backup trước khi xóa, confirmation gate, protected list cấu trúc, và output contract chi tiết. Sử dụng câu lệnh /team-cleanup. | 2.1 |

---

## Scripts

| Script | Summary | Size |
|--------|---------|------|
| agent-validator | Validate Agent Definition packages (agents/metadata/*.yaml). | 5 KB |
| architecture-validator | Validate AIOS 7-layer architecture doc. | 3 KB |
| artifact-validator | Validate Artifact Store structure and schemas. | 3 KB |
| autonomous-validator | Utility script | 1 KB |
| backup-utility | Backup Utility — backup, list và verify snapshot trước khi sửa file. | 13 KB |
| baseline-scan | Utility script | 5 KB |
| build-knowledge-index | Build/Update Knowledge Index - scan source code + docs to generate 7 index JSON files. | 8 KB |
| capability-validator | Validate Capability Registry (registry/) cho tính nhất quán + sinh coverage report. | 9 KB |
| catalog-builder | Utility script | 5 KB |
| constitution-doctor | Utility script | 6 KB |
| constitution-validator | Utility script | 4 KB |
| context-validator | Validate Context Engine structure: profiles/, schemas/, budget. | 3 KB |
| cost-validator | Utility script | 1 KB |
| cross-ref-validator | Cross-Reference Validator — kiểm tra tham chiếu chéo trong .opencode (agents, commands, skills, contracts). | 6 KB |
| dashboard-validator | Validate Dashboard structure + schema. | 2 KB |
| distributed-validator | Utility script | 1 KB |
| doctor | Doctor v2.0 - System health checker for AI Agent Framework | 9 KB |
| doctor-validator | Validate Doctor v2 structure + schema + rules. | 3 KB |
| evaluation-validator | Utility script | 1 KB |
| event-validator | Validate Event System structure. | 3 KB |
| evolution-validator | Validate Evolution Engine structure + schema + policy + objectives. | 3 KB |
| experiments-validator | Utility script | 1 KB |
| failure-analyzer | Utility script | 4 KB |
| gitpush-utility | GitPush Utility — thực hiện git push an toàn với auto-commit, safety checks, confirmation gate. | 18 KB |
| glossary-validator | Validate AIOS Glossary. | 5 KB |
| governance-framework-validator | Validate AIOS Governance Framework (D005). | 6 KB |
| governance-validator | Utility script | 1 KB |
| kernel-validator | Utility script | 1 KB |
| knowledge-graph-validator | Validate System Knowledge Graph structure + schemas. | 3 KB |
| knowledge-index | Utility script | 10 KB |
| manifest-validator | Validate AIOS Manifest. | 3 KB |
| marketplace-validator | Utility script | 1 KB |
| memory-validator | Utility script | 1 KB |
| model-policy | Utility script | 10 KB |
| model-router-validator | Utility script | 1 KB |
| observability-validator | Utility script | 1 KB |
| plugins-validator | Validate Plugin Architecture structure + schema + permissions. | 3 KB |
| policy-validator | Utility script | 1 KB |
| principles-validator | Validate AIOS Constitution Principles. | 6 KB |
| prompts-validator | Utility script | 1 KB |
| release-validator | Utility script | 1 KB |
| resources-validator | Utility script | 1 KB |
| rollback-utility | Rollback Utility — rollback file từ backup snapshot khi catastrophic failure. | 9 KB |
| rules-validator | Validate AIOS Architecture Rules. | 5 KB |
| schema-validator | Schema Validator — validate YAML schema của agent definitions. | 5 KB |
| sdk-validator | Validate AIOS SDK structure + schema. | 2 KB |
| simulation-validator | Validate Simulation Engine structure + schema. | 3 KB |
| spec000-validator | Validate SPEC-000 Constitution. | 5 KB |
| spec001-validator | Validate SPEC-001 Runtime Kernel. | 5 KB |
| spec-validator | Validate AIOS Implementation control file. | 2 KB |
| sync-system-docs | System Docs Sync — đồng bộ system docs + System Evolution Engine (9 engines). | 51 KB |
| trust-validator | Utility script | 1 KB |
| workflow-validator | Workflow Validator v4 — validate 5 workflow definitions (.opencode/workflow/definitions/*.yaml). | 14 KB |
| workspaces-validator | Utility script | 1 KB |

---

## Knowledge Base

| File | Size |
|------|------|
| knowledge/framework\blazor\component-lifecycle.md | 3 KB |
| knowledge/framework\fluentu\design-tokens.md | 1 KB |
| knowledge/framework\fluentu\fluentu.md | 1 KB |
| knowledge/knowledge-assistant\index\_index-report.json | 1 KB |
| knowledge/knowledge-assistant\index\code-index.json | 7 KB |
| knowledge/knowledge-assistant\index\data-model-index.json | 5 KB |
| knowledge/knowledge-assistant\index\dependency-graph.json | 5 KB |
| knowledge/knowledge-assistant\index\document-index.json | 20 KB |
| knowledge/knowledge-assistant\index\route-index.json | 2 KB |
| knowledge/knowledge-assistant\index\service-index.json | 0 KB |
| knowledge/knowledge-assistant\index\symbol-index.json | 7 KB |
| knowledge/knowledge-assistant\README.md | 3 KB |
| knowledge/lessons.md | 23 KB |
| knowledge/patterns\localstorage.md | 1 KB |
| knowledge/patterns\seed-data-patterns.md | 1 KB |
| knowledge/project\japanese-learner\deployment.md | 4 KB |
| knowledge/README.md | 4 KB |
| knowledge/skills\blazor\patterns.md | 5 KB |
| knowledge/skills\blazor\ui.md | 4 KB |
| knowledge/skills-learned.md | 14 KB |
| knowledge/testing\playwright-e2e.md | 2 KB |
| knowledge/testing\xunit-bunit-testing.md | 1 KB |
| knowledge/ui\dark-mode-theming.md | 1 KB |
| knowledge/ui\design-system-tokens.md | 5 KB |
| knowledge/ui\fluentui-components.md | 1 KB |
| knowledge/ui\tri-state-rendering.md | 1 KB |
| knowledge/workflow\validate-github-actions-yaml.md | 1 KB |

---

## Ma tran Cross-Reference

### Command -> Agent Mapping

| Command | Agent | Agent File |
|---------|-------|------------|
| /team | general | commands/team.md |
| /team-syncdocs | general | commands/team-syncdocs.md |
| /team-analyze | analyst | agents/analyst.md |
| /team-plan | planner | agents/planner.md |
| /team-review | reviewer | agents/reviewer.md |
| /team-build | builder | agents/builder.md |
| /team-ui-audit | ui-beautifier | agents/ui-beautifier.md |
| /team-testplan | test-planner | agents/test-planner.md |
| /team-test | tester | agents/tester.md |
| /team-selfimprove | self-improver | agents/self-improver.md |
| /team-gitguard | guardian | agents/guardian.md |
| /team-gitpush | pusher | agents/pusher.md |
| /team-cleanup | cleaner | agents/cleaner.md |
| /backup | backup-agent | commands/backup.md |

### Agent -> Commands

| Agent | Commands |
|-------|----------|
| analyst | team-analyze |
| backup-agent | backup |
| builder | team-build |
| cleaner | team-cleanup |
| codebase-explorer | team-explore |
| failure-agent | team-analyze-failure |
| general | team-runtime-benchmark, team-syncdocs, model-policy, team-doctor, doctor, team-bugfix, trace, test-bootstrap, ask, explain, team-capabilities, flow, why, compare-doc, test-cross-browser, doctor-test, test-e2e, where, impact, approve-test, team |
| guardian | team-gitguard |
| knowledge-agent | knowledge-compare-doc, knowledge, knowledge-trace, knowledge-impact, knowledge-health, knowledge-ask, knowledge-index, knowledge-why, knowledge-explain, knowledge-flow, knowledge-where |
| learning-agent | team-learn |
| planner | team-plan |
| pusher | team-gitpush |
| reviewer | team-review |
| root-cause-agent | team-root-cause |
| self-improver | team-selfimprove |
| tester | team-test |
| test-planner | team-testplan, test-regression, test-plan, test-audit, test-evolve |
| ui-beautifier | test-accessibility, test-visual, test-ui, team-ui-audit, impeccable |

---

## Workflow Overview

```
                    +---------+
                    |  START  |
                    +----+----+
                         |
                         v
                    +---------+
                    |ANALYZE  |
                    +----+----+
                         |
                         v
                    +---------+
                    | DESIGN  |
                    +----+----+
                         |
                         v
                    +---------+
                    |  PLAN   |
                    +----+----+
                         |
                         v
                    +---------+
                    | REVIEW  |
                    +----+----+
                    +----+----+
                    |         |
                    v         v
             +---------+  +--------------+
             |APPROVED |  |CHANGES_REQ   |
             +----+----+  +------+-------+
                  |              |
                  v              v
             +---------+   +---------+
             | BACKUP  |   |  PLAN   |
             +----+----+   +---------+
                  |
                  v
             +---------+
             |  BUILD  |
             +----+----+
                  |
                  v
             +-------+----+
             | STATIC ANALYSIS |
             +-----+------+
                   |
                   v
             +-------+----+
             |  UI AUDIT  |
             +-----+------+
                   |
                   v
             +---------+
             | TESTPLAN|
             +----+----+
                   |
                   v
             +---------+
             |  TEST   |
             +----+----+
              +---+---+
              |       |
              v       v
          +--------+ +--------+
          | PASS   | | FAIL   |
          +---+----+ +--------+
              |
         +-----------+
         |SELF_IMPRV.|
         +-----+-----+
               |
         +----------+
         | APPROVAL |
         +----+-----+
              |
       +------+------+
       |             |
       v             v
  +---------+  +---------+
  |COMPLETE |  |COMPLETE |
  +---------+  +---------+
```

### Buoc theo Command

| Buoc | Command | Agent | File |
|------|---------|-------|------|
| 1 | /team-analyze | analyst | commands/team-analyze.md |
| 2-3 | /team-plan | planner (m rong) | commands/team-plan.md |
| 4 | /team-review | reviewer | commands/team-review.md |
| 5 | Backup (utility) | --- | scripts/backup-utility.ps1 |
| 6 | /team-build | builder | commands/team-build.md |
| 7 | Static Analysis | --- | skills/dev-team/SKILL.md |
| 8 | /team-ui-audit | ui-beautifier | commands/team-ui-audit.md |
| 9 | /team-testplan | test-planner | commands/team-testplan.md |
| 10 | /team-test | tester | commands/team-test.md |
| 11 | /team-selfimprove | self-improver | commands/team-selfimprove.md |
| 12 | /team-gitpush | pusher | commands/team-gitpush.md |

### Pre/Post Steps

| Step | Command | Agent | File |
|------|---------|-------|------|
| Pre-push | /team-gitguard | guardian | commands/team-gitguard.md |
| Cleanup | /team-cleanup | cleaner | skills/workspace-cleaner/SKILL.md |
| Backup | /backup | backup-agent | commands/backup.md |

---

## Phat hien van de

| # | Loai | Chi tiet |
|---|------|----------|
| --- | OK | Khong phat hien van de. He thong dong bo hoan chinh. |

---

> **Tong so:** 18 agents . 56 commands . 28 skills . 54 scripts . 27 knowledge files
> **Sinh boi:** sync-system-docs.ps1