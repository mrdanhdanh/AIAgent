---
name: answer-builder
description: Ghép toàn bộ thông tin từ các skill thành câu trả lời hoàn chỉnh — có nguồn, không suy đoán. Format: Nguồn → Phân tích → Kết luận. Dùng trong mọi command knowledge.
schema_version: "1.0"
---

# Answer Builder — Xây Dựng Câu Trả Lời

Skill cuối cùng trong pipeline — tổng hợp evidence từ các skill thành câu trả lời rõ ràng, có nguồn, không suy đoán.

## MỤC LỤC

- [TỔNG QUAN](#tổng-quan)
- [NGUYÊN TẮC](#nguyên-tắc)
- [CẤU TRÚC CÂU TRẢ LỜI](#cấu-trúc-câu-trả-lời)
- [CHUỖI NGUỒN](#chuỗi-nguồn)
- [OUTPUT CONTRACT](#output-contract)
- [QUY TẮC BẮT BUỘC](#quy-tắc-bắt-buộc)

---

## TỔNG QUAN

Nhận input từ các skill (code-understanding, dependency-analyzer, impact-analyzer, search-engine...) và ghép thành câu trả lời hoàn chỉnh theo chuẩn thống nhất.

### Command liên quan

| Command | Mô tả |
|---------|-------|
| Tất cả commands | Bước cuối — `/ask`, `/where`, `/why`, `/flow`, `/impact`, `/explain`, `/trace`, `/compare-doc` |

---

## NGUYÊN TẮC

1. **Không suy đoán**: Chỉ trả lời những gì có evidence.
2. **Có nguồn**: Mỗi luận điểm kèm file:line.
3. **Trả lời trực tiếp**: Trả lời câu hỏi trước, chi tiết sau.
4. **Trung thực**: Nếu không biết → nói rõ, gợi ý cách tìm.
5. **Đúng phạm vi**: Không lan man ngoài câu hỏi.

---

## CẤU TRÚC CÂU TRẢ LỜI

```markdown
## Câu trả lời

**Trả lời ngắn gọn:** <1-2 câu trả lời trực tiếp>

## Chi tiết

### <Mục 1>
- Điểm A (evidence: file:line)
- Điểm B (evidence: file:line)

### <Mục 2>
- ...

## Chuỗi nguồn (từ đầu đến cuối)
README → Screen → Repository → Procedure → Kết luận

## Kết luận
<Tóm tắt + khuyến nghị nếu cần>

## Nguồn tham khảo
1. file:line — mô tả
2. file:line — mô tả
```

---

## CHUỖI NGUỒN

Ví dụ trả lời /trace Login:

```
UI (Login.razor:45 — form submit)
  ↓
API/Service (AuthService.LoginAsync:12 — gọi qua DI)
  ↓
Repository (UserRepository.cs:30 — query)
  ↓
Oracle (SP_GET_USER:1 — stored procedure)
  ↓
Response (LoginResponse — data contract)
```

Mỗi bước kèm evidence. Nếu bước nào không có trong codebase → ghi "không tìm thấy".

---

## OUTPUT CONTRACT

```yaml
status: "READY | PARTIAL"
summary: "Tóm tắt câu trả lời"
answer: |
  <Câu trả lời markdown đầy đủ>
answer_type: "EXPLAIN | WHERE | WHY | FLOW | IMPACT | TRACE | COMPARE | HEALTH | GENERAL"
confidence: "HIGH | MEDIUM | LOW"
sources:
  - file: "path/to/file"
    line: 42
    role: "Mô tả vai trò nguồn này"
gaps:
  - "Điểm chưa có evidence — cần kiểm tra thêm"
issues: []
next_action: "Hành động tiếp theo"
```

---

## QUY TẮC BẮT BUỘC

1. **Confidence theo evidence**: Đủ evidence → HIGH. Thiếu → MEDIUM/LOW kèm lý do.
2. **Gaps công khai**: Không giấu điểm thiếu — liệt kê trong `gaps`.
3. **Format thống nhất**: Mọi command trả lời theo cấu trúc trên.
4. **Nếu không tìm thấy gì**: `status: PARTIAL`, nói rõ + hướng dẫn `/knowledge-index --update`.
