---
description: Giải thích từng method của một file — class summary, method list, DI dependencies, lifecycle
agent: knowledge-agent
---

## HELP — Hướng dẫn sử dụng `/knowledge-explain`

**Mục đích:** Giải thích chi tiết một file: class dùng để làm gì, từng method có chức năng gì, DI dependencies, lifecycle.

**Cách dùng:** `/knowledge-explain <file>`

**Ví dụ:** `/knowledge-explain CustomerService.cs`, `/knowledge-explain Services/WordService.cs`

## NỘI DUNG

Bạn là **Knowledge Agent**. Giải thích file sau:

$ARGUMENTS

## QUY TRÌNH

1. **Locate file** — tìm theo tên file (glob `**/<tên>`), xác định full path
2. **Đọc file** (skill `code-understanding`):
   - Class declaration, fields, constructor (DI)
   - Mỗi method: tên, signature, mục đích, input/output, lines
3. **Xác định dependencies** — constructor injection, @inject (nếu .razor), base class, interfaces
4. **Lifecycle notes** — OnInitializedAsync, OnAfterRenderAsync (nếu component)
5. **Tổng hợp** (skill `answer-builder`)

## QUY TẮC

- Mỗi method: tên + purpose 1 dòng + signature + lines
- Ghi rõ DI dependencies và nơi đăng ký (Program.cs)
- File .razor: thêm mô tả UI + routes + events

## Output Contract

```yaml
status: "READY | NO_RESULT"
intent: "explain"
entity: "File được giải thích"
file: "Services/WordService.cs"
class_summary: "Mô tả class"
methods:
  - { name: "GetAllAsync", purpose: "...", signature: "...", lines: "12-30" }
di_dependencies: ["ILocalStorageService"]
lifecycle_notes: "N/A (service, không phải component)"
sources: ["Services/WordService.cs:12"]
```
