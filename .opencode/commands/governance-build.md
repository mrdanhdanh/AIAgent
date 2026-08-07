---
description: Build/rebuild Runtime Enforcement cho AIOS Governance Engine v26 + Policy Engine v15 — sinh governance.rules.yaml, policies.yaml, 3 engine scripts, optional workflow gate. Idempotent.
agent: general
schema_version: "1.0"
---

## HELP — Hướng dẫn sử dụng `/governance-build`

**Mục đích:** Chạy quy trình build lại (rebuild) toàn bộ runtime enforcement cho Governance khi cần — khi file bị mất/hỏng/sai version, hoặc khi muốn kích hoạt workflow gate.

**Các bước script thực hiện (6 phase, idempotent — chạy lại an toàn):**
1. **P0 Preflight** — kiểm tra môi trường
2. **P1 Foundation** — tạo `.opencode/governance/governance.rules.yaml` (rule store) + `.opencode/policy/policies.yaml` (policy store) nếu thiếu
3. **P2 Engine core** — tạo 3 scripts tại `.opencode/scripts/governance/`:
   - `governance-check.ps1` — Rule Checker (GOV-001..007)
   - `audit-log.ps1` — Auditor (append-only + hash-chain)
   - `policy-evaluate.ps1` — Policy Evaluator (default-deny)
4. **P3 Integration** (chỉ khi `--workflow-gate`) — chèn phase `governance_check` vào `default.workflow.yaml` trước phase `build`
5. **P4 Validate** — chạy 4 validators có sẵn (governance, policy, governance-framework, workflow)
6. **P5 Selftest** — test 3 engine scripts với data mẫu (policy allow/deny, naming, secret scan, audit tamper detect)
7. **P6 Report** — ghi JSON report vào `.opencode/scripts/governance/reports/`

**Cách dùng:**
- `/governance-build` — build mặc định (sinh file thiếu + validate + selftest)
- `/governance-build --workflow-gate` — build + chèn governance gate vào workflow (có backup trước)
- `/governance-build --force` — ghi đè file bằng template (có backup vào `.opencode/backup/governance-build/`)
- `/governance-build --dry-run` — chỉ báo cáo, không ghi gì
- `/governance-build --skip-selftest` — bỏ qua selftest

**Lưu ý:** Script chỉ tạo file còn thiếu (không đè file có sẵn) trừ khi `--force`. Template là single source of truth nhúng trong script — build lại = khôi phục nguyên trạng.

## NỘI DUNG

Bạn là **Governance Build Agent**. Thực thi build pipeline với tham số:

$ARGUMENTS

## QUY TRÌNH

1. **Phân tích tham số** — `--workflow-gate`, `--force`, `--dry-run`, `--skip-selftest`
2. **Gọi script**:
   ```powershell
   & ".opencode\scripts\governance-build.ps1" -ProjectRoot (Get-Location).Path <flags>
   ```
3. **Kiểm tra output** — từng phase P0..P6 PASS/FAIL/SKIP, số artifact tạo/đè, kết quả selftest
4. **Báo cáo** — overall (PASS/FAIL), đường dẫn report JSON, bước tiếp theo

## QUY TẮC

- Luôn gọi script `governance-build.ps1` — không tự tạo file thủ công
- Nếu P5 selftest FAIL → báo lỗi kèm test nào fail, gợi ý chạy lại với `--force`
- Không ghi đè file tồn tại trừ khi người dùng yêu cầu `--force`
- Sau build có thay đổi workflow gate → đề xuất chạy `/team-gitguard` trước khi push

## Output Contract

```yaml
status: "PASS | FAIL"
build_id: "GB-20260807-103000"
phases:
  P0: "PASS"
  P1: "PASS"
  P2: "PASS"
  P3: "SKIP | PASS"
  P4: "PASS"
  P5: "PASS"
  P6: "PASS"
artifacts_written: ["..."]
selftests: { total: 14, failed: 0 }
report_path: ".opencode/scripts/governance/reports/governance-build-<id>.json"
next_action: "Chạy /team-gitguard trước khi push nếu workflow thay đổi"
```

Xem thêm: `.opencode/governance/architecture.md`, `.opencode/governance/README.md`, `.opencode/policy/architecture.md`
