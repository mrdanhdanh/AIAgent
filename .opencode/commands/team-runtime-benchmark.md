---
description: Chạy benchmark Workflow Runtime — đo Compile/Execution/Retry/Recovery/Persistence/Validation. Không cần AI, dùng mock dispatcher. Output: benchmark report + cập nhật Runtime Certificate.
agent: general
schema_version: "1.0"
---

## HELP — Hướng dẫn sử dụng `/team-runtime-benchmark`

**Mục đích:** Đo hiệu năng Workflow Runtime (`.opencode/workflow-runtime/`). Không cần AI — dùng mock dispatcher.

**Cách dùng:** `/team-runtime-benchmark [--workflow <id>] [--repeat <N>]`

**Ví dụ:**
- `/team-runtime-benchmark` — benchmark toàn bộ workflow mẫu (feature/bugfix/ui/documentation), repeat 3
- `/team-runtime-benchmark --workflow feature-development` — chỉ 1 workflow
- `/team-runtime-benchmark --repeat 5` — 5 lần lấy trung bình

---

Bạn là **Runtime Benchmark Runner**. Tham chiếu `.opencode/workflow-runtime/benchmark.md`.

## QUY TRÌNH

### STEP-1: Kiểm tra nguồn
Đảm bảo tồn tại:
- `.opencode/workflow-runtime/benchmark.md` (định nghĩa metric)
- `.opencode/workflow/definitions/` (feature/bugfix/ui/documentation.workflow.yaml)

### STEP-2: Chạy benchmark
- Compile Time: đo thời gian biên dịch workflow → execution plan.
- Execution Time: chạy workflow với **mock dispatcher** (không gọi agent thật).
- Validation: đo thời gian validate definition/output.
- Persistence: đo thời gian lưu/đọc instance (JSON tạm).
- Retry/Recovery: mô phỏng phase fail → đo recovery.

Không gọi AI. Không sửa file definition gốc.

### STEP-3: Báo cáo
- Ghi `.opencode/reports/benchmark-<YYYYMMDD>.md` (markdown).
- So sánh với `architecture/PERFORMANCE.md`:
  - Compile < 1s, Validation < 300ms, ...
- Mỗi metric: `giá trị đo | ngưỡng | PASS/FAIL`.

### STEP-4: Cập nhật Certificate (nếu PASS)
- Cập nhật `RUNTIME_CERTIFICATE.md` Performance score.
- Nếu điểm giảm → **báo BLOCKED, không release**.

## Ràng buộc
- Benchmark **không được** gọi AI/agent thật.
- Không hard-code kết quả — đo thật trên Runtime hiện tại.
- Sử dụng config `features.*` trong `runtime-manifest.yaml`.

## Flags:

| Flag | Y nghia |
|------|---------|
| `--quick` | Benchmark nhanh |
| `--full` | Toan bo |
| `--json` | Xuat JSON |

