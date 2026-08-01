---
name: test-data-generator
description: Sinh dữ liệu test — User, Customer, Order, Invoice, Large Dataset, Boundary Value, Invalid Data, Random Data. Không dùng credential/secret thật. Sử dụng trong /test-e2e, /test-plan.
schema_version: "1.0"
---

# Test Data Generator — Sinh Dữ Liệu Kiểm Thử

Skill sinh dữ liệu test phù hợp cho nhiều tình huống: positive, negative, boundary, large dataset, invalid.

## MỤC LỤC

- [TỔNG QUAN](#tổng-quan)
- [LOẠI DỮ LIỆU](#loại-dữ-liệu)
- [QUY TẮC AN TOÀN](#quy-tắc-an-toàn)
- [SINH DỮ LIỆU CHO JAPANESELEARNER](#sinh-dữ-liệu-cho-japaneselearner)
- [ĐỊNH DẠNG ĐẦU RA](#định-dạng-đầu-ra)

---

## TỔNG QUAN

Test Data Generator sinh dữ liệu đầu vào cho test case. Dữ liệu phải realistic nhưng không bao giờ dùng dữ liệu thật (PII, credential).

### Command liên quan

| Command | Vai trò |
|---------|---------|
| `/test-plan` | Xác định data cần sinh cho từng TC |
| `/test-e2e` | Sinh mock data cho Playwright |

---

## LOẠI DỮ LIỆU

### User
```
{ id: 1, name: "Nguyễn Văn A", email: "user1@test.local", role: "admin" }
```
Quy tắc: email dùng `@test.local`, không dùng địa chỉ thật, password `Test@123` dạng fake.

### Customer / Order / Invoice
```
{ orderId: "ORD-1001", customer: "KH-001", amount: 250000, status: "pending" }
```

### Large Dataset
- Sinh 1.000 / 10.000 / 100.000 records để test performance
- Dùng vòng lặp sinh, không hardcode từng dòng
- Dữ liệu có pattern deterministic (để test lặp lại được)

### Boundary Value
Cho input có giới hạn (min/max), sinh:
- `min - 1`, `min`, `min + 1`
- `max - 1`, `max`, `max + 1`
- Ví dụ password (6-32 ký tự): 5, 6, 7, 31, 32, 33

### Invalid Data
- Email sai format: `abc`, `a@b`, `@gmail`
- Số âm, số 0, số quá lớn
- String rỗng, chỉ space, null
- Unicode: emoji, ký tự tiếng Việt có dấu
- XSS payload: `<script>alert(1)</script>`, `"><img onerror=alert(1)>`

### Random Data
- Faker-like sinh ngẫu nhiên (tên, email, số điện thoại)
- Seed cố định để tái lập: `Random(seed)`

---

## QUY TẮC AN TOÀN

1. **KHÔNG BAO GIỜ** dùng credential thật (API key, token, mật khẩu thật)
2. Email/phone là fake: `@test.local`, số 09xxxx giả
3. KHÔNG dùng dữ liệu khách hàng thật (GDPR)
4. Nếu cần test login → tạo test account, không dùng account production
5. Dữ liệu nhạy cảm sinh ngẫu nhiên, không liên kết người thật

---

## SINH DỮ LIỆU CHO JAPANESELEARNER

Dự án Blazor WASM với seed data:

| Model | Dữ liệu cần sinh |
|-------|------------------|
| JapaneseChar | hiragana/katakana + romaji + meaning |
| JapaneseWord | từ vựng + meaning (tiếng Việt) + level |
| JapaneseKanji | kanji + onyomi/kunyomi + meaning |
| GrammarPattern | pattern + explanation + example |

Lưu ý:
- Meaning luôn tiếng Việt (theo convention dự án)
- `JapaneseWord.Level` chỉ display, không dùng filter
- Dùng `IProgress<int>` cho large seed load (GetAllAsync)

---

## ĐỊNH DẠNG ĐẦU RA

```yaml
status: "READY"
summary: "Sinh 25 records test data"
datasets:
  - name: "users"
    type: "boundary"
    count: 7
    records:
      - { email: "user@test.local", password: "Test@123", valid: true }
      - { email: "abc", password: "12345", valid: false }
  - name: "orders"
    type: "large"
    count: 10000
    format: "json"
security_notes:
  - "Không chứa credential thật"
  - "Email dùng @test.local"
issues: []
next_action: "Sử dụng dữ liệu trong test cases"
```
