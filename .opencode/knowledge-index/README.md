# Knowledge Index — WF-20260801-002

Knowledge Index là tầng chỉ mục giúp Knowledge Assistant trả lời câu hỏi **nhanh và rẻ** (không phải đọc toàn bộ source mỗi lần).

## 7 Loại Index

| File | Nội dung | Phục vụ |
|------|----------|---------|
| `code-index.json` | File → classes/methods/fields | `/explain`, `/trace` |
| `symbol-index.json` | Symbol → files | `/where` |
| `api-index.json` | Public methods → callers | `/impact`, `/trace` |
| `database-index.json` | Storage keys / DB objects | `/where`, `/impact` |
| `dependency-graph.json` | Nodes + edges (DI graph) | `/impact`, `/trace`, `/where` |
| `document-index.json` | Docs → sections/headings | `/why`, `/compare-doc` |
| `business-rule-index.json` | Business rules → sources | `/why`, `/compare-doc` |

## Build / Update

```powershell
# Build lần đầu hoặc rebuild
powershell -ExecutionPolicy Bypass -File .opencode/scripts/build-knowledge-index.ps1 -Rebuild

# Cập nhật sau khi source thay đổi
powershell -ExecutionPolicy Bypass -File .opencode/scripts/build-knowledge-index.ps1 -Update

# Xem trạng thái
powershell -ExecutionPolicy Bypass -File .opencode/scripts/build-knowledge-index.ps1 -Status
```

Hoặc dùng command: `/knowledge-index`, `/knowledge-index --update`, `/knowledge-index --rebuild`, `/knowledge-index --status`.

## Nguyên tắc

1. **Index = định vị nhanh. File gốc = bằng chứng.** Luôn đọc file gốc trước khi kết luận.
2. Chạy `--update` sau mỗi lần source code thay đổi.
3. Không index file nhạy cảm (secret, connection string).
4. Lưu ý: `--rebuild` xóa toàn bộ thư mục — không đặt file khác ngoài index JSON ở đây.
