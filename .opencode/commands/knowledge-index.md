---
description: Build/update Knowledge Index — quét source code + tài liệu sinh 7 loại index (code, symbol, api, database, dependency, document, business-rule). Chạy sau mỗi lần source thay đổi
agent: knowledge-agent
schema_version: "1.0"
---

## HELP — Hướng dẫn sử dụng `/knowledge-index`

**Mục đích:** Xây dựng/cập nhật Knowledge Index — tầng chỉ mục giúp trả lời câu hỏi nhanh mà không cần đọc lại toàn bộ source.

**Cách dùng:**
- `/knowledge-index` — build index (xóa cũ, quét mới)
- `/knowledge-index --update` — update index khi source thay đổi
- `/knowledge-index --status` — kiểm tra trạng thái index
- `/knowledge-index --clean` — xóa index

**Khuyến nghị:** Chạy `/knowledge-index --update` sau mỗi lần sửa source để index không lỗi thời.

## NỘI DUNG

Bạn là **Knowledge Agent**. Xử lý Knowledge Index với tham số:

$ARGUMENTS

## QUY TRÌNH

1. **Phân tích tham số** — xác định mode: build (mặc định) | update | status | clean
2. **Gọi script**:
   ```powershell
   & ".opencode\scripts\knowledge-index.ps1" -Mode <mode> -ProjectRoot (Get-Location).Path
   ```
3. **Kiểm tra output** — INDEX_BUILD, FILES_SCANNED, ROUTES_FOUND, SYMBOLS_FOUND, DI_SERVICES
4. **Báo cáo** — tóm tắt kết quả + thời gian

## QUY TẮC

- Luôn gọi script knowledge-index.ps1 — không tự build index thủ công
- Nếu script lỗi → báo lỗi + gợi ý sửa
- Output báo cáo kết quả index

## Output Contract

```yaml
status: "READY"
mode: "build | update | status | clean"
result:
  files_scanned: 45
  routes_found: 13
  symbols_found: 80
  di_services: 5
  models_found: 4
  dep_edges: 10
  doc_sections: 5
  index_dir: ".opencode/knowledge/knowledge-assistant/index"
  index_files: 7
  dry_run: false
next_action: "Index sẵn sàng — các /knowledge-* command có thể truy vấn nhanh"
```
