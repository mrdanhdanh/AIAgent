---
name: impact-analyzer
description: Phân tích ảnh hưởng khi sửa component — sửa X ảnh hưởng API/Screen/Batch/Report/SP nào. Quan trọng nhất trong Knowledge Assistant. Dùng trong /impact.
schema_version: "1.0"
---

# Impact Analyzer — Phân Tích Ảnh Hưởng

Skill **quan trọng nhất** — xác định toàn bộ phạm vi ảnh hưởng khi sửa một thành phần, dựa trên dependency graph + usage analysis.

## MỤC LỤC

- [TỔNG QUAN](#tổng-quan)
- [CÁC DẠNG ẢNH HƯỞNG](#các-dạng-ảnh-hưởng)
- [QUY TRÌNH](#quy-trình)
- [VÍ DỤ](#ví-dụ)
- [OUTPUT CONTRACT](#output-contract)
- [QUY TẮC BẮT BUỘC](#quy-tắc-bắt-buộc)

---

## TỔNG QUAN

Trả lời câu hỏi: **"Nếu sửa X thì những gì bị ảnh hưởng?"** — từ API, Screen, Batch, Report đến SP. Kết quả là danh sách affected với mức độ ảnh hưởng và lý do.

### Command liên quan

| Command | Mô tả |
|---------|-------|
| `/impact <component>` | Sinh affected list |
| `/where <symbol>` | Chi tiết nơi dùng |
| `/trace <flow>` | Truy vết luồng liên quan |

---

## CÁC DẠNG ẢNH HƯỞNG

| Dạng | Mô tả | JapaneseLearner |
|------|-------|-----------------|
| **API / Service** | Public methods bị gọi | `WordService.GetAllAsync` |
| **Screen / Page** | UI phụ thuộc | `WordStudy.razor`, `WordQuiz.razor` |
| **Batch / Job** | Xử lý nền | Không có |
| **Report** | Xuất báo cáo | Không có |
| **SP / DB** | Stored procedure | Không có (LocalStorage) |
| **Model** | Data contract | `JapaneseWord` |

---

## QUY TRÌNH

### Bước 1: Xác định thành phần
Symbol/file cần phân tích.

### Bước 2: Tìm direct dependents
Grep toàn bộ code → ai gọi/ref trực tiếp.

```powershell
rg -ln "ComponentName" JapaneseLearner --glob '!**/bin/**' --glob '!**/obj/**'
```

### Bước 3: Tìm indirect dependents
Với mỗi dependent → tìm dependent tiếp (chuỗi ảnh hưởng).

### Bước 4: Phân loại mức độ
- **DIRECT**: Gọi/ref trực tiếp
- **INDIRECT**: Ảnh hưởng qua trung gian
- **DEPENDENCY**: Component phụ thuộc (thay đổi sẽ vỡ)

### Bước 5: Trả lời
Liệt kê affected theo dạng, kèm mức độ + evidence.

---

## VÍ DỤ

**/impact WordService.GetByTypeAsync**

```
Affected:
  DIRECT:
    - WordStudy.razor:342 — tab filter gọi GetByTypeAsync
  INDIRECT:
    - WordQuiz.razor:87 — quiz lấy danh sách qua GetAllAsync (không dùng GetByType trực tiếp)
  DEPENDENCY:
    - IWordService (interface contract — đổi signature vỡ mọi impl)
    - JapaneseWord (model — nếu đổi property)
  TEST:
    - WordServiceTests.cs — test cho GetByTypeAsync
    - AdminTests.cs — gián tiếp
```

---

## OUTPUT CONTRACT

```yaml
status: "READY | NOT_FOUND"
summary: "Tóm tắt phân tích ảnh hưởng"
target: "Thành phần được phân tích"
affected:
  - component: "Tên"
    type: "API | SCREEN | BATCH | REPORT | SP | MODEL | TEST | CONFIG"
    level: "DIRECT | INDIRECT | DEPENDENCY"
    evidence: "file:line"
    reason: "Lý do ảnh hưởng"
  - component: "IWordService"
    type: "API"
    level: "DEPENDENCY"
    evidence: "Services/IWordService.cs:1"
    reason: "Interface contract — đổi signature vỡ mọi implementation"
risk_summary:
  total_direct: 3
  total_indirect: 2
  critical_risk: false | true
  description: "Mô tả rủi ro tổng"
recommendations:
  - "Kiểm tra X trước khi sửa..."
issues: []
next_action: "Hành động tiếp theo"
```

---

## QUY TẮC BẮT BUỘC

1. **Không bỏ sót indirect**: Theo chuỗi ảnh hưởng đến hết, đừng dừng ở direct.
2. **Mỗi affected có evidence**: file:line — không liệt kê bịa.
3. **Interface là dependency**: Đổi contract → liệt kê interface + tất cả implementation.
4. **Phân biệt mức độ**: DIRECT ≠ INDIRECT — đừng gộp chung.
