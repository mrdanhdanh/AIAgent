---
name: runtime-implementation-plan
description: >
  Kế hoạch triển khai AIOS ở mức "hệ điều hành" chạy code thật — xây .opencode/runtime/
  (kernel, scheduler, state-machine, event-bus, artifact-store, context, SDK) kèm test,
  validator, certification. File này vừa là kế hoạch chi tiết vừa là nơi lưu tiến trình.
agent: general
---

# AIOS Runtime — Kế hoạch triển khai "hệ điều hành chạy code"

> Mục tiêu: biến AIOS từ khung đặc tả (docs + validator + prompt-driven) thành **runtime
> có code thật chạy**, thay thế dần phần "LLM đóng vai engine" — không phá vỡ hệ thống hiện tại.

## 1. Bối cảnh

- 72 scripts hiện có là công cụ đứng độc lập (validator, doctor, sync) — **không có kernel điều phối**.
- Workflow chạy qua prompt-driven (General Agent đọc engine.md rồi tự đóng vai) — `AIOS_IMPLEMENTATION.md:48`.
- Lỗi checkpoint đã ghi nhận: state.json thiếu artifact cuối, logs/ rỗng (WF-20260810-001).
- Mục tiêu cuối: `/team` gọi `aios.ps1 run <workflow>` → runtime thật điều phối, agent vẫn là executor.

## 2. Kiến trúc đích

```text
aios.ps1 (entry point — CLI: init/run/status/version/validate)
runtime/
├── kernel.ps1            # single entry — mọi hoạt động đi qua đây
├── scheduler.psm1        # hàng đợi task, priority, worker loop
├── state-machine.psm1    # phase states, transition guard, checkpoint
├── event-bus.psm1        # publish/subscribe, queue, priority, dead-letter
├── artifact-store.psm1   # CRUD + version + checksum + lineage
├── context.psm1          # providers, cache, budget
├── capability.psm1       # agent -> capability lookup (capabilities.yaml)
└── transaction.psm1      # commit/rollback log
sdk/                      # public API — core không truy cập trực tiếp
tests/                    # test case/module, chạy bằng runtime-tests.ps1
```

## 3. Quyết định kỹ thuật (mặc định — có thể đổi)

| # | Quyết định | Mặc định | Lý do |
|---|-----------|----------|-------|
| D1 | Ngôn ngữ | PowerShell 5.1 (`.ps1`/`.psm1`) | Nhất quán 72 scripts, chạy được trong agent env |
| D2 | Vị trí | `.opencode/runtime/` + `.opencode/sdk/` | Tách khỏi `scripts/` (công cụ) |
| D3 | Lưu trữ artifact | JSON file (nhất quán hiện tại) | Chưa đổi SQLite — đánh giá ở Phase 3 |
| D4 | Chiến lược | Chạy song song prompt-driven, thay dần | Không phá workflow đang hoạt động |
| D5 | Entry point | `aios.ps1` CLI | Một cửa duy nhất (đúng nguyên tắc kernel) |

## 4. 6 Phase chi tiết

### Phase 0 — Foundation (nền tảng)

Mục tiêu: bộ khung chuẩn để mọi module sau dựa vào.

- [x] Tạo `.opencode/runtime/` + `.opencode/sdk/` + `.opencode/runtime/tests/`
- [x] Viết `runtime-tests.ps1` — test runner dùng chung (pattern: Assert + PASS/FAIL + exit code, giống module-tests.ps1)
- [x] Viết `runtime-validator.ps1` — kiểm tra cấu trúc runtime/ (đủ module, schema, test)
- [x] Quy ước code: ASCII-only, UTF-8 no-BOM, 2-space, `param()` đầu file, `$ErrorActionPreference`
- [x] Smoke test `runtime/tests/smoke.test.ps1` — verify runner + Assert/Assert-Throw (5/5 PASS)

**Gate:** `runtime-tests.ps1` chạy 0-fail · `runtime-validator.ps1` PASS · doctor không vỡ → **ĐẠT (5/5 PASS, validator PASS 5 warning chờ Phase 1-2)**

---

### Phase 1 — Core lõi (kernel + event-bus + state-machine)

Mục tiêu: bộ khung điều phối + giao tiếp + trạng thái.

- [ ] `event-bus.psm1`: `Publish`, `Subscribe`, `Unsubscribe`, queue priority, dead-letter (theo `events/bus.md:41-42`, `dispatcher.md:45-46`)
- [ ] `state-machine.psm1`: states, transition guard, `Checkpoint` (ghi đủ artifact + log — **fix lỗi WF-20260810-001**)
- [ ] `kernel.ps1`: route mọi lời gọi qua kernel, log entry + metrics JSON
- [ ] Tests: event-bus ≥12 case (publish/subscribe/unsubscribe/priority/history/replay/filter/routing/dead-letter/lineage/contract/overflow), state-machine ≥8 case (transition/guard/checkpoint/rollback)
- [ ] Cập nhật `runtime-validator.ps1` check module mới

**Gate:** tests PASS · `kernel.ps1 status` chạy được · doctor PASS

---

### Phase 2 — Scheduler + Executor (workflow runtime thật)

Mục tiêu: máy chạy workflow từ definition YAML **bằng code** — bước thay thế prompt-driven.

- [ ] `scheduler.psm1`: nhận workflow id + request → đọc `.opencode/workflow/definitions/<id>.workflow.yaml` (parser YAML subset giống workflow-validator)
- [ ] Executor loop: load → validate → resolve deps (topological) → run phase → validate output → save artifact `<NN>_<phase>.md` → update state.json
- [ ] `aios.ps1 run <workflow> <request>` — CLI end-to-end
- [ ] Decision tree theo `engine.md`: retry (max 3, same-error 2) / skip / abort / rollback + WF-ERR codes
- [ ] Chạy thử 1 workflow `default` end-to-end — so sánh artifacts vs lần prompt-driven (WF-20260810-001)
- [ ] Migration: `/team` đổi từ "đọc docs + tự đóng vai" sang "gọi aios.ps1" (giữ fallback)

**Gate:** 1 workflow chạy thật PASS · state.json đầy đủ (cả 14 artifacts + logs) · doctor PASS

---

### Phase 3 — Data Layer (artifact-store + context)

- [ ] `artifact-store.psm1`: CRUD, version bump, checksum (SHA256), history, lineage (theo `artifacts/*.md` — ART-002..009)
- [ ] `context.psm1`: providers (artifact/knowledge/memory/project/runtime/task/workflow), cache (theo profiles builder/planner/tester), budget limit
- [ ] Đánh giá D3: JSON đủ dùng hay chuyển SQLite (query lớn, >1000 artifacts)
- [ ] Tests: artifact ≥13 case (theo `artifacts/tests.md`), context ≥10 case (theo `context/tests/tests.md`)
- [ ] SDK wrapper đầu tiên: `sdk/artifact-sdk.psm1` + `sdk/context-sdk.psm1`

**Gate:** tests PASS · sdk gọi được qua core · doctor PASS

---

### Phase 4 — SDK (lớp API công khai)

- [ ] `sdk/` đủ: agent-sdk, event-sdk, workflow-sdk, registry-sdk, doctor-sdk, simulation-sdk, evolution-sdk, plugin-sdk, dashboard-sdk (theo `aios-sdk/README.md`)
- [ ] Rule: core không truy cập trực tiếp — mọi tool/plugin/CLI gọi qua SDK (`aios-sdk/README.md:11`)
- [ ] SDK error contract: SDK-ERR-401/403/404 (theo `aios-sdk/security.md`)
- [ ] Versioning + backward compat test (theo `aios-sdk/versioning.md`)
- [ ] Audit log mọi SDK call

**Gate:** 8 SDK test case PASS (theo `aios-sdk/tests.md`) · doctor PASS

---

### Phase 5 — Ops (dashboard + metrics + governance thật)

- [ ] `aios.ps1 dashboard` — report từ metrics JSON thật (workflow runs, durations, retries, errors)
- [ ] `aios.ps1 status` — trạng thái runtime: đang chạy/hoàn tất, artifact count
- [ ] Governance gate: chạy validators + module-tests tự động trong pipeline runtime
- [ ] Metrics: ghi vào `.opencode/runtime/metrics/<date>.json` (retention theo audit-policy)

**Gate:** dashboard report đọc đúng dữ liệu thật · doctor đọc metrics runtime · PASS

---

### Phase 6 — Certification

- [ ] Re-certify: `RUNTIME_CERTIFICATE.md` mới (Architecture/Reliability/Performance/Maintainability/Compatibility đo trên code thật)
- [ ] Stress test **trên runtime thật** (không fake task) — mục tiêu ≥98%
- [ ] Cập nhật `AIOS_IMPLEMENTATION.md`: GĐ2/3 từ "✅ docs" → "✅ runtime code", SPEC-001/003/004/005/020 trỏ runtime/
- [ ] Cập nhật SYSTEM_MAP, SYSTEM_STATISTICS, AGENTS.md (nếu cần)
- [ ] CI: thêm gate `runtime-tests` vào deploy.yml quality job

**Gate:** Doctor ≥98/100 · stress runtime ≥98% · toàn bộ validator + test PASS

---

## 5. Bảng tiến trình (cập nhật sau mỗi bước)

| Phase | Trạng thái | Ngày bắt đầu | Ngày hoàn tất | Ghi chú |
|-------|-----------|-------------|---------------|---------|
| 0 — Foundation | ✅ | 2026-08-11 | 2026-08-11 | runner + validator + smoke test 5/5 |
| 1 — Core lõi | ⬜ | | | |
| 2 — Scheduler + Executor | ⬜ | | | |
| 3 — Data Layer | ⬜ | | | |
| 4 — SDK | ⬜ | | | |
| 5 — Ops | ⬜ | | | |
| 6 — Certification | ⬜ | | | |

## 6. Checklist tổng (luôn luôn)

- [ ] Trước mỗi phase: đọc đặc tả module tương ứng (.opencode/<module>/*.md)
- [ ] Sau mỗi bước: chạy runtime-tests + validator liên quan
- [ ] Sau mỗi phase: chạy doctor -Mode full, không để điểm giảm
- [ ] Mọi file mới: UTF-8 no-BOM, ASCII-only (PS 5.1), frontmatter nếu là .md
- [ ] Không sửa tay runtime context WF-* của engine cũ (chỉ chạy song song)

## 7. Nhật ký thực hiện

| Ngày | Công việc | Kết quả |
|------|-----------|---------|
| 2026-08-11 | Tạo kế hoạch này | ✅ |
| 2026-08-11 | Phase 0: runtime/, sdk/, tests/ + runtime-tests.ps1 + runtime-validator.ps1 + smoke.test.ps1 | ✅ 5/5 PASS, validator PASS, doctor không vỡ |
