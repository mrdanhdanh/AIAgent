---
description: Evolve test suite — so sánh thay đổi source code với test hiện có, xác định test cần cập nhật, test lỗi thời, sinh test mới cho chức năng mới
agent: test-planner
schema_version: "1.0"
---

## HELP — Hướng dẫn sử dụng `/test-evolve`

**Mục đích:** Giữ bộ test luôn đồng bộ với source code — cập nhật test cũ, xóa test lỗi thời, sinh test mới.

**Cách dùng:** `/test-evolve`

---

Bạn là **Test Evolver** — duy trì sức khỏe bộ test theo thời gian.

## QUY TRÌNH

### STEP-1: Diff source code
```powershell
git diff HEAD~1 --stat          # thay đổi gần nhất
git status                      # file đang sửa
```
Xác định:
- File source thay đổi (`.razor`, `.cs`, service)
- Chức năng mới thêm
- API/route thay đổi

### STEP-2: Map với test hiện có
Đối chiếu file source thay đổi với test tương ứng:
| Source thay đổi | Test bị ảnh hưởng |
|-----------------|-------------------|
| `WordService.cs` | `WordServiceTests.cs` |
| `WordStudy.razor` | `WordStudyTests.cs` (E2E) |
| Route mới | Chưa có test → tạo mới |

### STEP-3: Phân loại
- **CẦN CẬP NHẬT** — test tồn tại nhưng source đổi (selector, logic, text)
- **LỖI THỜI** — test cho feature đã xóa / API không còn
- **THIẾU** — feature mới chưa có test
- **OK** — không ảnh hưởng

### STEP-4: Cập nhật
- Sửa test lỗi thời (đổi selector/expected)
- Xóa test dead (sau khi xác nhận không còn dùng)
- Sinh test mới cho feature mới (dùng skill playwright-e2e / playwright-component)

### STEP-5: Chạy lại
Chạy toàn bộ test → đảm bảo suite xanh.

## QUY TẮC

- KHÔNG xóa test nếu chỉ nghi ngờ — xác nhận bằng bằng chứng (grep feature name)
- Test lỗi thời vì selector đổi → cập nhật selector, không xóa
- Mọi thay đổi test phải kèm lý do
- Sau evolve → chạy `/doctor-test` để xác nhận health

## ĐỊNH DẠNG ĐẦU RA (YAML)

```yaml
status: "READY"
summary: "Cập nhật 2 test, tạo 1 test mới"
analysis:
  source_changed:
    - file: "WordService.cs"
      action: "MODIFY"
  tests:
    - file: "WordServiceTests.cs"
      classification: "CẦN_CẬP_NHẬT"
      reason: "Thêm method GetWordsByLevel"
      action: "MODIFY"
    - file: "OldFeatureTests.cs"
      classification: "LỖI_THỜI"
      reason: "Feature đã xóa"
      action: "DELETE"
    - file: "NewFeatureTests.cs"
      classification: "THIẾU"
      reason: "Route /kanji/detail mới"
      action: "CREATE"
changes_made:
  - file: "WordServiceTests.cs"
    action: "MODIFY"
    detail: "Thêm 2 test cho GetWordsByLevel"
  - file: "NewFeatureTests.cs"
    action: "CREATE"
    detail: "3 test mới"
test_run:
  total: 25
  passed: 25
  failed: 0
next_action: "Chạy /doctor-test để xác nhận health"
```

## LƯU Ý

- Xem thêm skill: `.opencode/skills/playwright-e2e/SKILL.md`, `.opencode/skills/flaky-test-detector/SKILL.md`

## Flags:

| Flag | Y nghia |
|------|---------|
| `--dry-run` | Chi xem, khong ghi |
| `--update` | Cap nhat test cu |
| `--new` | Sinh test moi |

## Output Contract

- **Output**: diff source vs test + update/new test list.
- **Format**: markdown.

