# Test Results - /doctor (WF-20260731-001)

> Buoc 11 trong workflow. ID: TR-20260731-001
> Ngay: 2026-07-31 | Runner: builder agent (dua tren test plan 05_testplan.md)

## Summary

| TC | Mo ta | Ket qua |
|----|-------|---------|
| TC-01 | Parse-validate 11 scripts | **PASS** - 11/11 clean, 0 errors |
| TC-02 | 11 modes exit 0 | **PASS** - quick=0, full=0, runtime=0, workflow=0, agent=0, skill=0, command=0, knowledge=0, contracts=0, simulation=0, benchmark=0 |
| TC-03 | Full mode health score + JSON | **PASS** - OVERALL 93/100 (10 categories), JSON valid |
| TC-04 | Repair dry-run an toan | **PASS** - DRY_RUN, repairs=0, manual review=47 |
| TC-05 | Alias team-doctor | **PASS** - exit 0 |
| TC-06 | opencode.json valid | **PASS** - 20 commands, co doctor + team-doctor |
| TC-07 | Regression (khong pha vo file co) | **PASS** - 5 file trong plan + 2 thu muc moi |
| TC-08 | Ghi nhan loi pre-existing | **PASS** - 3 loi ghi nhan, khong sua ngoai pham vi |

**Verdict: PASS (8/8)** — khong co loi blocking, khong can retry loop.

## Health score chi tiet (full mode)

```
  Commands         100
  Workflow         100
  Benchmark        86
  Agents           85
  Runtime          100
  Simulation       100
  Skills           92
  Knowledge        90
  Contracts        100
  Environment      85
  OVERALL          93/100
```

## Chi tiet thuc thi

- 11 scripts: `doctor.ps1` + `doctor/{environment,agents,commands,skills,workflows,runtime,simulation,benchmark,repair,report}.ps1`
- Kiem tra ASCII-only (sweep): 0 ky tu non-ASCII trong tat ca script
- Parser API: 0 errors toan bo
- All 11 modes chay qua `Start-Job` (PowerShell 5.1, Windows): exit code 0, khong hang (>120s timeout khong bi trigger)
- Report file: `scripts/doctor/reports/doctor-report-*.json` (moi lan chay tao moi)
- `-Mode full -Json` exit 0

## Phat hien (khong blocking, ghi nhan cho follow-up)

1. **sync-system-docs.ps1** bi loi tu truoc: `[switch]$report` (line 11) trung ten bien `$report` (line 17) -> script khong chay duoc. SYSTEM_MAP duoc cap nhat thu cong trong workflow nay.
2. **schema-validator.ps1** bi loi parse tu truoc: ky tu non-ASCII `?` trong chuoi (line 27) -> PS 5.1 khong parse duoc.
3. **cross-ref-validator.ps1** bug tu truoc: double `team-` prefix (`team-team-*.md`) + UTF-8 mojibake khi quet anchor -> 90 false-positive WARN.

Cac loi nay de xuat xu ly trong workflow rieng (dung /doctor de phat hien, /team-syncdocs de sua sau khi fix script).
