---
name: aios-governance-review-workflow
description: >
  AIOS Governance Review Workflow v2.0 — hệ thống review 2-pass cho hàng trăm SPEC.
  2 trục trạng thái (Document Lifecycle + Review Lifecycle), 6 review types,
  severity chuẩn hóa + decision matrix, score, cascade, triggers, SLA, metrics.
  Điều hành qua lệnh /review.
agent: general
---

# AIOS Governance Review Workflow v2.0

> D005 — Mỗi mục bắt buộc review **tối thiểu 2 lần**. Review là subsystem riêng,
> **tách khỏi** Document Lifecycle — review xong chưa có nghĩa tài liệu Approved.

## 1. Hai trục trạng thái (tách bạch)

| Trục | Ladder | Ý nghĩa |
|------|--------|---------|
| **Document Lifecycle** | `Draft → Review → Approved → Frozen → Deprecated → Archived` | Vòng đời tài liệu |
| **Review Lifecycle** | `NotReviewed → Rev1 → Completed` | Trạng thái review (số lần) |

```yaml
# Ví dụ tracker — không trộn 2 trục
items:
  SPEC-001:
    S010:
      name: Runtime Execution Flow
      lifecycle: Review          # Document Lifecycle
      review:
        status: Rev1             # Review Lifecycle — đã review 1 lần
        count: 1
        inherited: false
      history: [REV-...]
```

**Quan hệ (mapping):**
- `lifecycle: Approved` → bắt buộc `review.status: Completed` (tiền đề).
- `lifecycle: Frozen` → đến từ **revfull PASS + Completed (auto-freeze)** hoặc từ Approved — không trực tiếp khi chưa đủ 2-pass.
- Mục inherited (Freeze từ trước) giữ nguyên **cả hai** trạng thái — health check không đổi gì.

## 2. Review Types (6)

| Type | Tính count | Dùng khi | Matrix |
|------|-----------|----------|--------|
| `rev1` | ✔ | Mặc định, review lần 1 | coverage + governance |
| `revfull` | ✔ | Review cuối / mục quan trọng — deep research. **PASS + Completed → auto-freeze** | cả 6 dimension |
| `health` | ✘ | Kiểm tra định kỳ (TRG-007) — **không tăng count, không đổi status** | governance + architecture + dependency |
| `compliance` | ✔ | Constitution/Policy thay đổi (TRG-003/004) | coverage + governance + traceability + schema |
| `migration` | ✔ | Đổi cấu trúc/format (TRG-005/008) | coverage + architecture + dependency + schema |
| `regression` | ✔ | SPEC/dependency thay đổi (TRG-001/002) | coverage + architecture + traceability + dependency |

## 3. Review ID

- Format: `REV-<YYYYMMDD>-<NNN>` — sequence toàn cục, `NNN = review-history.yaml entries.length + 1`.
- Mỗi review 1 ID duy nhất → Dashboard trace toàn bộ: report ↔ history ↔ tracker.

## 4. Severity chuẩn hóa + Decision Matrix

| Severity | Verdict |
|----------|---------|
| CRITICAL | FAIL |
| MAJOR | CONDITIONAL |
| MINOR / INFO | PASS |

**Decision Matrix (loại bỏ chủ quan):**

| CRITICAL | MAJOR | Verdict |
|----------|-------|---------|
| 0 | 0 | **PASS** |
| 0 | ≥ 1 | **CONDITIONAL** |
| ≥ 1 | * | **FAIL** |

Deduction điểm: CRITICAL −30 · MAJOR −10 · MINOR −3 · INFO 0 (chi tiết `review-severity.yaml`).

## 5. Score (0–100) + Coverage

```yaml
score:
  coverage: 95      # matrix dimension coverage
  quality: 97       # content/structure
  consistency: 100  # traceability + dependency (cross-reference 2 chiều)
  governance: 92    # matrix dimension governance
  overall: 96       # weighted mean (25/25/25/25)
coverage:
  direct_reference: 100
  cross_reference: 94
  governance: 100
  schemas: 100
```

- Score phục vụ **Dashboard trend** + `metrics.average_score` — **không** quyết định verdict.
- Verdict luôn do Decision Matrix quyết định.

## 6. Review Matrix (check bắt buộc theo type)

| Dimension | rev1 | revfull | health | compliance | migration | regression |
|-----------|:----:|:-------:|:------:|:----------:|:---------:|:----------:|
| Coverage | ✔ | ✔ | — | ✔ | ✔ | ✔ |
| Governance | ✔ | ✔ | ✔ | ✔ | — | — |
| Architecture | — | ✔ | ✔ | — | ✔ | ✔ |
| Traceability | — | ✔ | — | ✔ | — | ✔ |
| Dependency | — | ✔ | ✔ | — | ✔ | ✔ |
| Schema | — | ✔ | — | ✔ | ✔ | — |

## 7. Review History (append-only)

- `review-tracker.yaml` — per-item: `history: [{review, type, verdict, date}, ...]` + latest status.
- `review-history.yaml` — **global log**: mỗi review 1 entry (`review_id`, spec, item, type, verdict, score, severity_counts, started/finished, cascade_review, report_path).
- Report file per review — không ghi đè (POLICY-011).

## 8. Cascade Review (auto dependency)

```
Review S007 ──► tìm upstream + downstream (grep toàn hệ thống + SPEC.yaml deps + thứ tự mục)
       │
       ▼
cascade_review: [S008, S010, S013]
       │
       ▼
Tracker: recheck_required: true (các mục bị ảnh hưởng) → Doctor lập task regression (TRG-002)
```

- Cascade **không tự đổi** review.status — chỉ đánh dấu chờ regression.

## 9. Freeze Rule

```text
Review Completed + revfull PASS ──► Frozen (auto-freeze, không cần Approved)
Review Completed ──► POLICY-001 approval ──► Approved ──► Quyết định freeze ──► Frozen
```

- **Auto-freeze**: review `revfull` verdict PASS + `review.status = Completed` → lifecycle về **Frozen trực tiếp** (bỏ qua Approved/POLICY-001).
- revfull PASS chưa đủ 2-pass → chỉ advance count/status, không freeze.
- revfull trên mục đã Frozen (inherited) → health-check, giữ nguyên 2 trục.
- Các type khác (rev1/health/compliance/migration/regression) không auto-freeze; đường Approved → Frozen cũ vẫn giữ cho quyết định freeze thủ công.

## 10. Review Trigger + SLA

| Trigger | Event | Action |
|---------|-------|--------|
| TRG-001 | SPEC changed | regression mục đó |
| TRG-002 | Dependency changed | cascade regression |
| TRG-003 | Constitution changed | compliance toàn bộ |
| TRG-004 | Policy changed | compliance ảnh hưởng |
| TRG-005 | Schema changed | migration |
| TRG-006 | Draft quá 30 ngày | rev1 ngay |
| TRG-007 | Completed quá 180 ngày | health |
| TRG-008 | Migration cấu trúc | migration nhóm |

Doctor đọc `review-trigger.yaml` + `review-rules.yaml` để tự tạo task.

## 11. Metrics

```yaml
reviewed_items: 20          # review.status != NotReviewed
pending_reviews: 6          # NotReviewed/Rev1 + lifecycle Draft/Review
failed_reviews: 0           # FAIL trong 30 ngày
average_score: 96.0         # 30 ngày
average_duration: 1.5       # giờ
stale_reviews: 0            # Completed quá 180 ngày chưa health
overdue_drafts: 0           # Draft quá 30 ngày
```

## 12. Review Graph (dữ liệu chảy 1 chiều)

```text
SPEC (nội dung)
   ↓
Review (/review — sinh report)
   ↓
Report (docs/governance/reviews/REV-*.md, append-only)
   ↓
Tracker (review-tracker.yaml) + History (review-history.yaml)
   ↓
Index (docs/specs/SPEC-INDEX.md — marker ✅/🚧/⬜ + dòng Trạng thái, /review đồng bộ sau mỗi lần review)
   ↓
Dashboard (trend, metrics) · Doctor (SLA, trigger, health) · Evolution (cải tiến)
```

## 13. Machine-readable

| File | Nội dung |
|------|----------|
| `review-status.yaml` | 2 trục trạng thái + mapping + inheritance |
| `review-matrix.yaml` | Ma trận check theo type |
| `review-severity.yaml` | Severity + decision matrix + deduction |
| `review-score.yaml` | Score model + weights |
| `review-rules.yaml` | SLA + counting + freeze + report rules |
| `review-trigger.yaml` | Triggers + cascade rule |
| `review-metrics.yaml` | Metrics + aggregation |
| `review-history.yaml` | Global log append-only |
| `review.schema.json` | Schema validate tracker/history/report |

## 14. Pipeline

```text
/review <SPEC> <mục> [type]      type: rev1|revfull|health|compliance|migration|regression
        │
        ▼
P1 Parse (target + type) → P2 Load (tracker + history + rules + matrix)
        │
        ▼
P3 Kiểm tra trạng thái (NotReviewed/Rev1/Completed/inherited/missing) + SLA
        │
        ▼
P4 Chạy check theo matrix → findings (severity) → score + coverage
        │
        ▼
P5 Decision Matrix → verdict → cascade_review → cập nhật tracker+history → ghi report
        │
        ▼
P6 Đồng bộ docs/specs/SPEC-INDEX.md (marker mục ✅/🚧/⬜ + dòng Trạng thái SPEC)
        │
        ▼
Output contract v2.0
```

## 15. Template report

```markdown
---
name: review-report
description: >
  <review_id> — review <type> cho <SPEC>/<ITEM>. Không tự sửa — do /review tạo.
agent: general
---

# Review Report — <SPEC>/<ITEM>

- **review_id**: REV-<YYYYMMDD>-<NNN>
- **type**: rev1 | revfull | health | compliance | migration | regression
- **verdict**: PASS | CONDITIONAL | FAIL
- **lifecycle**: <trước> → <sau> · **review.status**: <trước> → <sau> · **count**: <N>
- **score**: coverage / quality / consistency / governance / overall
- **coverage**: direct_reference / cross_reference / governance / schemas

## Findings (severity: CRITICAL/MAJOR/MINOR/INFO)

| # | Severity | Category | Location | Mô tả | Gợi ý |
|---|----------|----------|----------|-------|-------|

## Cascade Review

- cascade_review: [mục bị ảnh hưởng] — recheck_required: true

## Trigger nhắc

- SLA: draft còn N ngày / stale sau M ngày · triggers: TRG-xxx

## Summary & Next Step

...
```

## 16. Quy tắc vận hành

- Chỉ `/review` cập nhật tracker + history; mọi entry append-only.
- Sau mỗi review, `/review` **bắt buộc đồng bộ** `docs/specs/SPEC-INDEX.md` (marker mục theo tracker: ✅ Frozen/Completed · 🚧 Draft/Rev1 · ⬜ chưa bắt đầu) + dòng `Trạng thái` của SPEC — index không bao giờ lệch tracker.
- Review PASS/CONDITIONAL → tăng count (trừ `health`); FAIL → không đổi trạng thái.
- revfull PASS + Completed → **auto-freeze** (Frozen trực tiếp, không qua Approved/POLICY-001).
- Mục inherited (Frozen cũ) giữ nguyên 2 trục — revfull chỉ là health-check.
- Verdict = Decision Matrix — không theo cảm tính reviewer.
- Tracker + history + metrics nhất quán — Doctor validate theo `review.schema.json` (POLICY-010).

## Tham chiếu

- Command: `.opencode/commands/review.md`
- Tracker: `review-tracker.yaml` · History: `review-history.yaml` · Schema: `review.schema.json`
- Rules: `review-rules.yaml` · Trigger: `review-trigger.yaml` · Metrics: `review-metrics.yaml`
- Status: `review-status.yaml` · Severity: `review-severity.yaml` · Matrix: `review-matrix.yaml` · Score: `review-score.yaml`
- Lifecycle: `lifecycle/specification-lifecycle.md` · Master index: `docs/specs/SPEC-INDEX.md`
