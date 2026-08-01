---
name: dependency-analyzer
description: Xây dựng và phân tích dependency graph — Call Graph, Module Graph, Reference Graph, Database Graph, Service Graph (DI). Dùng trong /where, /impact, /trace.
schema_version: "1.0"
---

# Dependency Analyzer — Phân Tích Phụ Thuộc

Skill chuyên xây dựng đồ thị phụ thuộc giữa các thành phần trong hệ thống — nền tảng cho impact analysis và trace.

## MỤC LỤC

- [TỔNG QUAN](#tổng-quan)
- [CÁC LOẠI GRAPH](#các-loại-graph)
- [QUY TRÌNH](#quy-trình)
- [VÍ DỤ](#ví-dụ)
- [OUTPUT CONTRACT](#output-contract)
- [QUY TẮC BẮT BUỘC](#quy-tắc-bắt-buộc)

---

## TỔNG QUAN

Xây dựng đồ thị phụ thuộc để trả lời "thành phần này kết nối với những gì" và "sửa cái này ảnh hưởng gì".

### Command liên quan

| Command | Mô tả |
|---------|-------|
| `/where <symbol>` | Tìm mọi nơi sử dụng symbol |
| `/impact <component>` | Sinh affected list |
| `/trace <flow>` | Truy vết luồng |

### Nguồn dữ liệu

- `dependency-graph.json` — Knowledge Index
- `Program.cs` — DI registrations
- Grep toàn bộ source cho references

---

## CÁC LOẠI GRAPH

| Graph | Mô tả | Ví dụ |
|-------|-------|-------|
| **Call Graph** | Method A gọi method B | `WordService.AddAsync` → `GetCachedAsync` |
| **Module Graph** | Module/namespace phụ thuộc | `Pages` → `Services` → `Models` |
| **Reference Graph** | Symbol X được tham chiếu ở đâu | `JapaneseWord` dùng ở 5 files |
| **Database Graph** | Table/SP liên kết (Oracle) | `SP_GET_CUSTOMER` → `Repository` → `Service` → `API` → `Screen` |
| **Service Graph** | DI relationships | `IWordService` ← `WordService` ← `Admin.razor` |

---

## QUY TRÌNH

### Bước 1: Định vị node gốc
Xác định symbol/file cần phân tích từ index hoặc input.

### Bước 2: Quét references
```powershell
# Tìm tất cả nơi dùng symbol
rg -l "SymbolName" JapaneseLearner --glob '!**/bin/**' --glob '!**/obj/**'
```

### Bước 3: Xây graph
- **Upstream** (ai gọi/ref X): grep X trong toàn dự án
- **Downstream** (X gọi gì): đọc file X, tìm calls/injections
- **DI chain**: đọc Program.cs cho service registrations

### Bước 4: Trả lời
Trình bày graph dạng text tree hoặc mermaid, mỗi edge kèm evidence.

---

## VÍ DỤ

```
Sửa WordService.AddAsync
    ↓ ảnh hưởng
  Admin.razor (CRUD từ vựng — tab 1)
    ↓ gọi
  WordService (service layer)
    ↓ phụ thuộc
  ILocalStorageService (Blazored)
    ↓
  Models/JapaneseWord.cs (data model)
```

**Trả lời:** "Sửa `WordService.AddAsync` ảnh hưởng `Admin.razor` (nơi gọi), phụ thuộc `ILocalStorageService`, model `JapaneseWord`. Các quiz pages đọc qua `GetAllAsync` — ảnh hưởng gián tiếp."

---

## OUTPUT CONTRACT

```yaml
status: "READY | NOT_FOUND"
summary: "Tóm tắt graph"
target: "Node gốc được phân tích"
graph:
  type: "CALL_GRAPH | MODULE_GRAPH | REFERENCE_GRAPH | DATABASE_GRAPH | SERVICE_GRAPH"
  nodes:
    - name: "Tên thành phần"
      type: "PAGE | SERVICE | INTERFACE | MODEL | API | DB_OBJECT"
      location: "file:line"
  edges:
    - from: "Nguồn"
      to: "Đích"
      direction: "UPSTREAM | DOWNSTREAM"
      type: "CALL | INJECT | IMPORT | REFERENCE | QUERY"
      evidence: "file:line"
upstream: ["Ai ref X — kèm evidence"]
downstream: ["X ref gì — kèm evidence"]
issues: []
next_action: "Hành động tiếp theo"
```

---

## QUY TẮC BẮT BUỘC

1. **Evidence mỗi edge**: Mỗi quan hệ kèm file:line — không vẽ graph bịa.
2. **Phân biệt DIRECT/INDIRECT**: Đánh dấu mức độ ảnh hưởng.
3. **DI chain đầy đủ**: Interface → Implementation → Registration → Caller.
4. Nếu dùng index cũ (stale) → kiểm tra lại bằng grep thực tế.
