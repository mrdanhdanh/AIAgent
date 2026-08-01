---
name: answer-builder
description: Ghép toàn bộ evidence thành câu trả lời cuối — markdown có nguồn trích dẫn. KHÔNG tự suy đoán, mọi phát biểu có nguồn file:line. Sử dụng cuối pipeline của mọi /knowledge-* command.
schema_version: "1.0"
---

# Answer Builder — Skill

## TỔNG QUAN

Skill cuối pipeline: nhận `evidence[]` từ các skill khác, tổng hợp thành câu trả lời markdown mạch lạc, có nguồn trích dẫn rõ ràng.

## NGUYÊN TẮC VÀNG

1. **Không tự suy đoán** — mọi phát biểu phải bám evidence
2. **Có nguồn** — mỗi luận điểm kèm `file:line`
3. **Nói rõ khi không biết** — "Không tìm thấy" thay vì bịa
4. **Ngắn gọn** — tối đa ~500 từ, ưu tiên bảng + bullet

## CẤU TRÚC CÂU TRẢ LỜI

```markdown
## Tóm tắt
(2-3 câu trả lời thẳng vào câu hỏi)

## Chi tiết
- Luận điểm 1 [nguồn: Services/WordService.cs:12]
- Luận điểm 2 [nguồn: Pages/WordStudy.razor:5]
...

## Nguồn
| File | Line | Nội dung |
|------|------|----------|
| Services/WordService.cs | 12 | GetAllAsync... |

## Gợi ý tiếp theo
- /knowledge-trace <entity> — trace luồng
- /knowledge-impact <entity> — xem ảnh hưởng
```

## CHUẨN NGUỒN (Evidence Chain)

```
README/docs ──→ Screen (.razor) ──→ Repository/Service ──→ Model ──→ LocalStorage
      │               │                    │                  │            │
    PRODUCE        RENDER               PROCESS            STRUCTURE      PERSIST
```

## QUY TRÌNH

1. Nhận `evidence[]` (file, line, snippet, skill nguồn)
2. Sắp xếp logic: trả lời trực tiếp → chi tiết → nguồn
3. Mỗi luận điểm gắn source (file:line)
4. Xác định mức độ tin cậy: có evidence / ước lượng / không tìm thấy
5. Gợi ý command tiếp theo phù hợp

## ĐỊNH DẠNG ĐẦU RA

```yaml
answer: "Markdown hoàn chỉnh (tóm tắt + chi tiết + bảng nguồn)"
sources:
  - { file: "Services/WordService.cs", line: 12, snippet: "GetAllAsync" }
  - { file: "Pages/WordStudy.razor", line: 5, snippet: "@inject IWordService" }
confidence: "HIGH | MEDIUM | LOW"
uncertainty: "Ghi rõ phần nào ước lượng / không chắc"
not_found: []   # Câu hỏi phụ không có evidence
suggested_commands: ["/knowledge-impact WordService", "/knowledge-trace /words"]
```

## QUY TẮC

- `confidence: HIGH` chỉ khi mọi luận điểm có nguồn trực tiếp
- `confidence: MEDIUM/LOW` kèm `uncertainty` giải thích
- KHÔNG trả nội dung raw dài (>30 dòng) — chỉ trích context + nguồn

## XỬ LÝ NGOẠI LỆ

- Không có evidence nào → trả "Không tìm thấy thông tin về X" + danh sách file đã scan
- Evidence mâu thuẫn → trình bày cả 2 bên, không phán quyết
- Câu hỏi quá rộng → trả tóm tắt + gợi ý làm rõ
