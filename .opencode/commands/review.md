---
description: "AIOS Review v2.0 — review SPEC/mục theo chuẩn 2-pass. 6 types: rev1, revfull, health, compliance, migration, regression. Tách Document Lifecycle khỏi Review Lifecycle, severity + decision matrix, score, cascade, trigger, SLA."
agent: general
schema_version: "2.0"
---

## HELP — Hướng dẫn sử dụng `/review` (v2.0)

**Mục đích:** Review tài liệu AIOS theo chuẩn bắt buộc **2 lần review**, với 2 trục trạng thái tách bạch:
- **Document Lifecycle**: `Draft → Review → Approved → Frozen → Deprecated → Archived`
- **Review Lifecycle**: `NotReviewed → Rev1 → Completed`

Mục đã review/Freeze (vd: SPEC-000, S001–S008) **giữ nguyên cả hai trạng thái** (inherited).

**Cách dùng:**

| Lệnh | Ý nghĩa |
|------|---------|
| `/review SPEC-001 S010` | Review mục S010 — type mặc định `rev1` |
| `/review SPEC-001/S010 revfull` | Deep research |
| `/review S010 health` | Health check — **không tăng review count, không đổi trạng thái** |
| `/review SPEC-001` | Review toàn bộ SPEC (lần lượt mục chưa hoàn thành) |
| `/review status` | Bảng trạng thái 2 trục + metrics từ tracker |
| `/review scan` | Quét hệ thống: gaps, SLA, triggers, gợi ý thứ tự review |

**Type:** `rev1` (mặc định) · `revfull` · `health` · `compliance` · `migration` · `regression` — ma trận check theo `review-matrix.yaml`.

**Verdict (Decision Matrix — không chủ quan):**

| CRITICAL | MAJOR | Verdict |
|----------|-------|---------|
| 0 | 0 | **PASS** |
| 0 | ≥ 1 | **CONDITIONAL** |
| ≥ 1 | * | **FAIL** |

**Luật:**
- Review PASS/CONDITIONAL → tăng count (trừ `health`) → `NotReviewed → Rev1 → Completed`.
- Review FAIL → không đổi trạng thái.
- Frozen chỉ đến từ Approved (Completed review + POLICY-001) — không bao giờ trực tiếp.
- Cascade: mục bị ảnh hưởng được đánh dấu `recheck_required` — KHÔNG tự đổi review.status.
- Tracker `review-tracker.yaml` + History `review-history.yaml` = nguồn sự thật (chỉ /review cập nhật).

## NỘI DUNG

Bạn là **AIOS Review Agent v2.0**. Thực hiện review với tham số:

$ARGUMENTS

## QUY TRÌNH

### P1 — Parse input

1. Xác định **target**: SPEC + mục (chấp nhận `SPEC-001 S010`, `SPEC-001/S010`, `S010` — dò trong `docs/specs/`).
2. Xác định **type**: positional thứ 2 (`rev1 | revfull | health | compliance | migration | regression`); mặc định `rev1`.
3. Lệnh đặc biệt: `status` → in bảng trạng thái + metrics; `scan` → quét toàn hệ thống (không review cụ thể).

### P2 — Load context

1. `docs/governance/review-tracker.yaml` — trạng thái hiện tại (lifecycle + review.status + count + history).
2. `docs/governance/review-history.yaml` — xác định `review_id` = `REV-<YYYYMMDD>-<NNN>`, NNN = entries.length + 1.
3. `review-rules.yaml` (SLA/counting/freeze) · `review-matrix.yaml` (check theo type) · `review-severity.yaml` (decision matrix) · `review-score.yaml` (weights) · `review-status.yaml` (ladder/mapping) · `review-trigger.yaml` (cascade).
4. `docs/specs/SPEC-INDEX.md` + `SPEC.yaml` của target (dependencies) + target files (md + artifact YAML/JSON).

### P3 — Kiểm tra trạng thái + SLA

- Target **không tồn tại** → báo lỗi + chạy `scan` (gợi ý mục gần nhất + mục thiếu: S015–S020, SPEC-002+).
- Target **inherited** (Frozen/Approved cũ) → giữ nguyên 2 trục. Cho phép `health`/`revfull` như health-check — report ghi `lifecycle/review.status: giữ nguyên`.
- Target **Completed + type tính count** → không review lại; chỉ chấp nhận `health`/`regression` (regression vẫn không đổi status).
- Kiểm tra **SLA**: Draft quá 30 ngày (TRG-006) → nhắc review ngay; Completed quá 180 ngày (TRG-007) → khuyến nghị health.
- Ngược lại → review bình thường.

### P4 — Chạy check theo Matrix + scoring

Lấy danh sách dimension bắt buộc cho type từ `review-matrix.yaml` và chạy:

- **coverage**: scope/structure/content đủ theo chuỗi SPEC (Vision → Responsibilities → Architecture → Behavior → Data → Contracts → Events)
- **governance**: naming (POLICY-007), version (POLICY-002), quality (POLICY-010), traceability (POLICY-011)
- **architecture**: phân tầng, Behavior Before Data, không định nghĩa lại (POLICY-006)
- **traceability**: cross-reference 2 chiều file:line chính xác
- **dependency**: upstream + downstream (grep toàn hệ thống) + cascade impact
- **schema**: YAML artifact hợp lệ, khớp schema.json, metadata nhất quán

Mỗi finding gán **severity chuẩn** (CRITICAL/MAJOR/MINOR/INFO — `review-severity.yaml`). Tính **score** (coverage/quality/consistency/governance/overall theo weights 25/25/25/25, trừ deduction theo severity) và **coverage** (direct_reference/cross_reference/governance/schemas — 0–100).

Mode `revfull` bổ sung bắt buộc: đọc **toàn bộ dependency chain**, **git history** (`git log`/`git blame`), **schema validation** thực tế, và **phân tích cấp hệ thống** (cascade impact, upgrade suggestions kèm priority P1–P3, missing items, thứ tự review tiếp theo).

### P5 — Verdict + cascade + cập nhật

1. **Verdict = Decision Matrix** (đếm CRITICAL/MAJOR):

```yaml
verdict:
  - { critical: 0, major: 0,      result: PASS }
  - { critical: 0, major: ">=1",  result: CONDITIONAL }
  - { critical: ">=1", major: "*", result: FAIL }
```

2. **Cascade review**: tìm mọi mục tham chiếu target (grep toàn hệ thống + SPEC.yaml dependencies + thứ tự mục) → sinh `cascade_review`. Gắn `recheck_required: true` vào tracker cho các mục đó — **không** đổi review.status của chúng (Doctor lập task regression TRG-002).
3. **Cập nhật tracker** (chỉ khi type tính count và verdict PASS/CONDITIONAL):
   - count + 1; status: NotReviewed → Rev1 → Completed (theo ladder).
   - lifecycle: tự động Draft → Review khi count ≥ 1 (giữ nguyên nếu đã Approved/Frozen).
   - Thêm entry vào `history[]`.
4. **Cập nhật history** `review-history.yaml` — append 1 entry (review_id, spec, item, type, verdict, score, severity_counts, started/finished, cascade_review, report_path).
5. **Ghi report** `docs/governance/reviews/REV-<SPEC>-<ITEM>-<YYYYMMDD-HHMMSS>.md` (template mục 15 `review-workflow.md`).
6. **Đồng bộ `docs/specs/SPEC-INDEX.md`** — BẮT BUỘC mỗi lần review kết thúc (kể cả `health`/`regression` nếu trạng thái tracker đổi, và `status`/`scan` chỉ đọc không đổi):
   - Cập nhật **marker từng mục** trong cây SPEC theo tracker sau khi review (map từ `review-tracker.yaml`):
     - `✅` = lifecycle Frozen/Approved hoặc `review.status: Completed` (kể cả inherited — giữ nguyên).
     - `🚧` = lifecycle Draft/Review + `review.status: NotReviewed/Rev1` (đang làm).
     - `⬜` = chưa khởi tạo / không tồn tại trong SPEC.
   - Cập nhật dòng `> **Trạng thái**: ...` của SPEC tương ứng (chỉ mục vừa review): toàn bộ mục `✅` → `✅ <lifecycle tối đa>`; còn mục `🚧` → `In progress`; SPEC chưa khởi tạo → `⬜`.
   - Mục inherited/Frozen **giữ nguyên marker** — chỉ đổi marker mục vừa review khi status/count thực sự thay đổi.
   - Không sửa nội dung SPEC, không đổi quy ước/chú thích trong index — chỉ cập nhật trạng thái.
7. Không tự sửa nội dung mục — chỉ report + gợi ý. Áp dụng fix chỉ khi được chấp thuận, sau đó chạy lại review.

## OUTPUT CONTRACT (v2.0)

```yaml
review_id: "REV-20260807-001"
type: "rev1 | revfull | health | compliance | migration | regression"
target: "SPEC-001/S010"
target_file: "docs/specs/SPEC-001/S010/execution-flow.md"

document:
  lifecycle_before: "Draft"
  lifecycle_after: "Review | giữ nguyên"
review:
  status_before: "NotReviewed | Rev1 | Completed | Completed(inherited)"
  status_after: "Rev1 | Completed | giữ nguyên"
  count_before: 0
  count_after: 1

verdict: "PASS | CONDITIONAL | FAIL"          # từ Decision Matrix
severity_counts: { CRITICAL: 0, MAJOR: 0, MINOR: 2, INFO: 3 }

score:
  coverage: 95
  quality: 97
  consistency: 100
  governance: 92
  overall: 96

coverage:
  direct_reference: 100
  cross_reference: 94
  governance: 100
  schemas: 100

matrix_checks:                    # theo review-matrix.yaml cho type
  coverage: "PASS"
  governance: "PASS"

findings:
  - id: "#01"
    severity: "CRITICAL | MAJOR | MINOR | INFO"
    category: "CONTENT | STRUCTURE | CONSISTENCY | TRACEABILITY | COMPLIANCE | SECURITY | STALE | ARCHITECTURE | DEPENDENCY | SCHEMA"
    location: "file:line hoặc section"
    description: "Vấn đề"
    suggestion: "Gợi ý sửa cụ thể"

cascade_review: ["S008", "S010", "S013"]     # mục bị ảnh hưởng (recheck_required)
trigger_notice: ["TRG-006: Draft quá 30 ngày", "TRG-007: sắp stale 180 ngày"]

system_analysis:                  # bắt buộc revfull, khuyến khích rev1
  cascade_impact: [...]
  upgrade_suggestions:
    - target: "..."
      priority: "P1 | P2 | P3"
      reason: "..."
  missing_items: [...]
  recommended_next: [...]

sla: { draft_days: 12, stale_in_days: 168 }

summary: "Tổng quan 2-3 câu"
next_step: "Hành động cụ thể tiếp theo"
report_path: "docs/governance/reviews/REV-SPEC-001-S010-<ts>.md"
index_synced: true                       # đã đồng bộ docs/specs/SPEC-INDEX.md sau review
index_changes:
  - item: "SPEC-001/S010"
    marker: "✅ | 🚧 | ⬜"                # marker cũ → mới trong cây index
    spec_status: "In progress | ✅ Frozen | ⬜"   # dòng Trạng thái của SPEC
```

## QUY TẮC

- **Bắt buộc 2 lần review** — tracker + history là nguồn sự thật duy nhất (append-only).
- Mục inherited (Frozen/Approved cũ) → **giữ nguyên 2 trục trạng thái**.
- Verdict = Decision Matrix — không theo cảm tính; CONDITIONAL phải kèm MAJOR + `next_step`.
- `health` không tăng count, không đổi status; `revfull` phải đọc dependency chain + git history + system analysis trước khi kết luận.
- Cascade gắn `recheck_required` — **không tự đổi** review.status của mục khác.
- Khi review kết thúc → **bắt buộc cập nhật `docs/specs/SPEC-INDEX.md`** (marker mục + dòng Trạng thái SPEC) khớp tracker; không bỏ qua.
- Không sửa nội dung mục khi review; sau khi cập nhật tracker/history/index → nhắc user chạy `/doctor` nếu cần kiểm tra health.

## Tham chiếu

- Quy trình: `docs/governance/review-workflow.md` · Tracker: `docs/governance/review-tracker.yaml`
- History: `docs/governance/review-history.yaml` · Schema: `docs/governance/review.schema.json`
- Rules/Trigger/Metrics: `docs/governance/review-{rules,trigger,metrics}.yaml`
- Status/Severity/Matrix/Score: `docs/governance/review-{status,severity,matrix,score}.yaml`
- Lifecycle: `docs/governance/lifecycle/specification-lifecycle.md` · Index: `docs/specs/SPEC-INDEX.md`
