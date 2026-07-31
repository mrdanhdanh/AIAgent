# Test Plan - /doctor (WF-20260731-001)

> Buoc 10 trong workflow. ID: TP-20260731-001
> Pham vi: kiem thu chi tiet lenh `/doctor` va `/team-doctor` (11 scripts + 2 command files + registration).

## Test cases

### TC-01: Parse-validate tat ca 11 scripts
- **Cach**: Parser API `[System.Management.Automation.Language.Parser]::ParseFile`
- **Tieu chi PASS**: 0 parse errors tren tat ca scripts; khong co ky tu non-ASCII trong code (ASCII-only).
- **Result**: PASS (11/11 clean)

### TC-02: Tat ca modes exit code 0
- **Cach**: chay `doctor.ps1 -Mode <mode>` cho 11 modes: quick, full, runtime, workflow, agent, skill, command, knowledge, contracts, simulation, benchmark
- **Tieu chi PASS**: moi mode `$LASTEXITCODE = 0`, khong throw
- **Result**: PASS (11/11 modes = 0)

### TC-03: Full mode tra ve health score + JSON report
- **Cach**: `doctor.ps1 -Mode full -Json` + kiem tra report file trong `scripts/doctor/reports/*.json`
- **Tieu chi PASS**: overall score 0-100, 10 categories, issues list; JSON parse duoc bang ConvertFrom-Json
- **Result**: PASS (OVERALL 93/100, categories=10, issues=47, JSON valid)

### TC-04: Repair mode mac dinh la dry-run (an toan)
- **Cach**: `doctor.ps1 -Mode repair` (khong co -Force)
- **Tieu chi PASS**: `repairs = 0`, `dry_run = True`, khong sua file nao
- **Result**: PASS (DRY_RUN, repairs=0, manual review required=47)

### TC-05: Alias /team-doctor tra ve exit 0
- **Cach**: chay `doctor.ps1 -Mode quick` lan thu 2 (alias khong phai script rieng, la command file tro den doctor.md)
- **Tieu chi PASS**: exit 0
- **Result**: PASS

### TC-06: opencode.json re-parse hop le sau khi them commands
- **Cach**: `ConvertFrom-Json` tren opencode.json; kiem tra `command` chua /doctor va /team-doctor
- **Tieu chi PASS**: JSON hop le, co 2 commands moi
- **Result**: PASS (20 commands, bao gom doctor + team-doctor)

### TC-07: Regression - khong lam hong file he thong co
- **Cach**: `git status` + `git diff HEAD` so sanh truoc/sau build
- **Tieu chi PASS**: chi co dung 5 file MODIFY + 2 thu muc moi (scripts/doctor/, workflows/WF-20260731-001/); khong co file ngoai plan bi doi
- **Result**: PASS (dung 5 file trong plan: opencode.json, general.md, AGENTS.md, SYSTEM_MAP.md, doctor.ps1 + scripts/doctor/)

### TC-08: Ghi nhan phat hien (khong sua) loi pre-existing
- **Cach**: chay sync-system-docs.ps1, schema-validator.ps1, cross-ref-validator.ps1
- **Tieu chi**: khong doi file ngoai plan; ghi nhan vao SYSTEM_MAP "Phat hien van de" + bao cao cuoi
- **Result**: PASS (3 loi pre-existing ghi nhan: sync [switch]$report, schema-validator non-ASCII, cross-ref double prefix)

## Out of scope (khong test)
- UI (khong co UI thay doi - Step 9 N/A)
- Build/test .NET (khong dong cham toi JapaneseLearner)
