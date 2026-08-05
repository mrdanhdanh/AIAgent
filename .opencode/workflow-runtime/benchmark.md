---
name: workflow-runtime-benchmark
description: benchmark — Phase 1.24: /team-runtime-benchmark đo Compile/Execution/Retry/Recovery/Persistence/Validation. Không cần AI.
agent: general
---

# benchmark.md — Runtime Benchmark

> Command mới `/team-runtime-benchmark`. Đo hiệu năng Runtime, **không cần AI**.

## 1. Command

```text
/team-runtime-benchmark [--workflow feature] [--repeat 3]
```

## 2. Đo gì

| Metric | Định nghĩa |
|--------|-----------|
| Compile Time | thời gian compile workflow → plan |
| Execution Time | thời gian chạy 1 workflow |
| Retry | số retry thực tế |
| Recovery | số recovery thực tế |
| Persistence | thời gian lưu instance |
| Validation | thời gian validate definition/output |

## 3. Quy trình

```text
Load sample workflows (feature/bugfix/ui/documentation)
   ↓
Compile benchmark
   ↓
Execute benchmark (fake agent qua dispatcher mock)
   ↓
Persistence benchmark
   ↓
Validation benchmark
   ↓
Report
```

- Dùng **mock dispatcher** (không AI, không agent thật).
- Repeat N lần lấy trung bình.

## 4. Output

- Báo cáo markdown vào `.opencode/reports/benchmark-<date>.md`.
- So sánh ngưỡng PERFORMANCE.md → pass/fail.

## 5. Gate

- Kết quả benchmark nuôi `RUNTIME_CERTIFICATE.md` (Performance score).
- Nếu vượt ngưỡng (vd Compile > 1s) → certificate giảm, cân nhắc không release.

## 6. Tương tác

- `configuration.md` (cấu hình chạy)
- `RUNTIME_ACCEPTANCE.md` (acceptance run)
- `RUNTIME_CERTIFICATE.md` (điểm)