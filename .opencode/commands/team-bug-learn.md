---
name: team-bug-learn
description: "Learning Pipeline 1 lệnh duy nhất sau khi fix bug — chuẩn hóa lỗi (failure-analyzer.ps1) → failure-agent classify + search memory → root-cause-agent (nếu cần) → learning-agent ghi failure record + sinh lessons/patterns → self-improver đề xuất. Gọi sau khi fix bug."
trigger: bug-learn
agent: general
args: "Bug context: error message / file log + task description + root cause (nếu đã biết) + fix đã áp dụng"
output: |
  learning_report: YAML contract
---

## HELP — Hướng dẫn sử dụng `/team-bug-learn`

**Mục đích:** Chạy TOÀN BỘ Learning Pipeline sau khi fix bug bằng 1 lệnh duy nhất — tổng hợp 4 bước trước đây phải gọi rời (`/team-analyze-failure` → `/team-root-cause` → `/team-learn` → `/team-selfimprove`). Dùng sau khi bug đã fix xong (test PASS) để hệ thống **ghi nhớ bài học** và **tự học** từ lỗi.

**Cách dùng:** `/team-bug-learn <mô tả bug + error message> [--root-cause <nguyên nhân>] [--fix <fix đã áp dụng>] [--task <mô tả task>]`

**Ví dụ:**
- `/team-bug-learn "Quiz bị treo khi bấm Next: System.NullReferenceException tại WordQuiz.NextAsync" --root-cause "QuizService chưa AddScoped trong Program.cs" --fix "Thêm DI registration" --task "Fix bug /words quiz hang"`
- `/team-bug-learn --file "artifacts/11_test.md" --task "Fix bug kanji detail loading"`

**Khi nào gợi ý:** Sau khi `/team-bugfix` hoàn tất Phase 6, hoặc sau mỗi lần fix bug thủ công — assistant nên chủ động gợi ý `/team-bug-learn`.

---

Bạn là **Learning Pipeline Orchestrator** — điều phối 4 agent chuyên biệt theo thứ tự.

## WORKFLOW

### STEP 1: NORMALIZE + CLASSIFY (failure-agent)

1. Xác định raw error:
   - `--file <path>` → đọc file log (≤10KB, truncate + marker nếu lớn hơn)
   - Argument trực tiếp → raw error message
   - `--root-cause` + `--fix` có sẵn nhưng không có error → bỏ qua classify, qua STEP 2
2. Chạy deterministic script (KHÔNG tự tính hash):
   ```powershell
   & .opencode/scripts/failure-analyzer.ps1 -RawError "<raw error>"
   # hoặc: & .opencode/scripts/failure-analyzer.ps1 -FilePath <log-file>
   ```
3. Nhận `error_normalized` + `error_hash` từ script — đây là field bắt buộc cho dedup/search
4. Gọi `failure-agent` classify (`error_type` + `error_detail`) + search memory (3 nơi: failures/, lessons/, patterns/)
5. Kết quả: `memory_search.found` — nếu đã có lesson/pattern tương tự → học từ đó, báo `reuse`

### STEP 2: ROOT CAUSE (root-cause-agent — optional)

- Nếu user đã cung cấp `--root-cause` → dùng luôn, skip agent
- Nếu chưa có → gọi `root-cause-agent`: tìm evidence trong codebase, sinh hypotheses ranked by confidence
- Output: `most_likely` + `fix_suggestion`

### STEP 3: GHI FAILURE RECORD (learning-agent)

1. Tạo failure record mới: `.opencode/memory/failures/BUG-{NNNN}.md` (next id, đọc từ failures/ hiện có)
2. Format theo `.opencode/memory/failures/README.md` (frontmatter YAML):
   ```yaml
   failure_id: BUG-{NNNN}
   task: "..."
   attempts:
     - attempt: 1
       error: "..."
       error_hash: "{16-hex SHA256 | legacy-slug}"
       error_type: "..."
   error_detail: "..."
   final_solution: "..."
   root_cause: "..."
   lesson: "..."
   tags: ["blazor", ...]
   reusable: true
   created_at: "..."
   resolved_at: "..."
   ```
3. Nếu `error_hash` đã tồn tại trong records → KHÔNG tạo mới, cập nhật attempts + final_solution (dedup)
4. Gọi `learning-agent` — quét failures chưa có lesson/pattern, sinh:
   - Lesson: `.opencode/memory/lessons/{framework}/LSN-{TAG}-{NNN}.md`
   - Pattern: `.opencode/memory/patterns/PAT-{NNN}.md` (nếu ≥ 2 failures cùng error_type)
5. Cập nhật failure record với `lesson_id`/`pattern_id` reference

### STEP 4: SELF-IMPROVE (self-improver — optional)

- Gọi `self-improver`: đối chiếu failure memory với workflow vừa chạy, đề xuất cải tiến (chỉ suggestion, không ghi KB)
- Suggestion có `impact: MEDIUM/HIGH` → chờ user APPROVE trước khi ghi knowledge base

## QUY TẮC

- Mọi phép tính deterministic (hash/normalize) do `failure-analyzer.ps1` — KHÔNG tự tính SHA256
- Ghi failure record chỉ khi có root cause xác định (theo failures/README.md)
- Dedup: `error_hash` tồn tại → cập nhật, không tạo trùng
- Chỉ tạo lesson/pattern khi có evidence thật (không bịa)
- UTF-8 no-BOM khi ghi file

## Output

```yaml
status: "READY | NO_CHANGES | FAIL"
summary: "Đã ghi BUG-0005, tạo 1 lesson, 1 pattern"
pipeline:
  normalize: { error_hash: "3f2a9c1e8b4d6f21", error_type: "NullReferenceException" }
  memory_search: { found: true, reuse: "LSN-BLZ-001", similarity: 0.90 }
  root_cause: { most_likely: "H-001", conclusion: "Thiếu DI registration" }
record:
  failure_id: "BUG-0005"
  path: ".opencode/memory/failures/BUG-0005.md"
  created: true
  dedup: false
created:
  lessons:
    - id: "LSN-BLZ-004"
      path: ".opencode/memory/lessons/blazor/LSN-BLZ-004.md"
  patterns:
    - id: "PAT-004"
      path: ".opencode/memory/patterns/PAT-004.md"
suggestions:
  - { action: "update_knowledge_base", impact: MEDIUM, requires_approval: true }
sources: [".opencode/memory/failures/BUG-0005.md"]
```

## Flags

| Flag | Mô tả |
|------|-------|
| `--file <path>` | Đọc error từ file log thay vì argument |
| `--task <text>` | Mô tả task gây lỗi (bắt buộc cho failure record) |
| `--root-cause <text>` | Nguyên nhân gốc đã biết (skip STEP 2) |
| `--fix <text>` | Fix đã áp dụng (dùng làm final_solution) |
| `--framework <name>` | Chỉ xử lý failures của framework cụ thể |
| `--force` | Xử lý lại cả failures đã có lesson |
| `--skip-selfimprove` | Bỏ qua STEP 4 (chỉ record + learn) |
| `--dry-run` | Mô phỏng pipeline, KHÔNG ghi file |

## Integration

- **Tự gợi ý:** Sau khi `/team-bugfix` hoàn tất hoặc fix bug thủ công → chủ động gợi ý `/team-bug-learn`
- **Trong workflow:** tương đương 2 phase `failure_analysis` + `learning` của `default.workflow.yaml` (chạy tự động qua engine)
- Chạy riêng lẻ thay thế: `/team-analyze-failure`, `/team-root-cause`, `/team-learn`, `/team-selfimprove`

## Edge Cases

| Tình huống | Xử lý |
|------------|-------|
| Không có error message + không có file | `status: FAIL`, yêu cầu input |
| File log không tồn tại | `status: FILE_NOT_FOUND` |
| error_hash đã tồn tại | Dedup — cập nhật attempts, không tạo record mới |
| Memory rỗng (chưa có failure records) | Tạo BUG-0001 + lesson đầu tiên |
| Không có root cause xác định | KHÔNG ghi record — báo thiếu thông tin |
| Script failure-analyzer.ps1 lỗi | KHÔNG tự đoán hash — báo NOT_FOUND + escalate |
