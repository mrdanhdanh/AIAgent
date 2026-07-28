# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

## Users

Người Việt Nam tự học tiếng Nhật để thi JLPT (N5–N1). Người dùng chính đã có kiến thức cơ bản, cần công cụ ôn luyện mặt chữ, từ vựng và kanji hàng ngày với nghĩa tiếng Việt.

## Product Purpose

Japanese Learner là công cụ ôn luyện JLPT toàn diện trên nền web, giúp người học tiếng Nhật ghi nhớ Hiragana, Katakana, từ vựng và Kanji thông qua flashcard và quiz. Sản phẩm tập trung vào hiệu quả ôn luyện hơn là giảng dạy — người dùng đã học qua tài liệu và cần một công cụ để kiểm tra, củng cố kiến thức hàng ngày.

## Positioning

Một công cụ học tiếng Nhật miễn phí, chạy hoàn toàn trên trình duyệt, không cần cài đặt, không thu thập dữ liệu cá nhân. Khác biệt chính: nghĩa tiếng Việt cho toàn bộ từ vựng và kanji, phù hợp với người Việt tự học JLPT.

## Operating Context

- Chạy trên trình duyệt desktop và mobile (Blazor WebAssembly, responsive)
- Người dùng tự học, không cần tài khoản — toàn bộ dữ liệu lưu trong localStorage
- Phiên học ngắn (5–15 phút), phù hợp ôn luyện hàng ngày
- Người dùng cần kiến thức cơ bản về tiếng Nhật trước khi sử dụng (biết Hiragana/Katakana là lợi thế)

## Capabilities and Constraints

### Capabilities

- Hiragana/Katakana flashcard quiz
- Từ vựng flashcard quiz với 7 type tabs
- Multiple-choice word quiz
- Kanji study list với detail view
- Admin CRUD cho characters, words, kanji
- Dark mode toggle (persisted trong localStorage)

### Constraints

- Cache-first: dữ liệu seed có sẵn trong app, lưu localStorage, không có backend API
- Không hỗ trợ tài khoản người dùng hay đồng bộ dữ liệu giữa các thiết bị
- Blazor WASM — Single Page Application, không SSR
- Dùng FluentUI 4.14.3, không phải MudBlazor
- Nghĩa tiếng Việt cho từ vựng và kanji (không hỗ trợ ngôn ngữ khác ở thời điểm hiện tại)

## Brand Commitments

- Tên sản phẩm: **Japanese Learner**
- Không có logo, màu sắc chủ đạo, hay tài sản thương hiệu cố định nào khác
- Font: dùng font mặc định của FluentUI (Segoe UI trên Windows, system-ui trên nền tảng khác)

## Evidence on Hand

- Codebase hoàn chỉnh: Blazor WASM app với Services, Models, Pages, Tests
- Deployed tại GitHub Pages (`.github/workflows/deploy.yml`)
- Unit tests (xUnit + bUnit) và E2E tests (Playwright)
- Vocabulary meanings bằng tiếng Việt
- FluentUI 4.14.3 dark mode đã tích hợp

## Product Principles

1. **Offline-first, privacy-first**: Toàn bộ dữ liệu trong localStorage; không cần tài khoản, không gửi dữ liệu ra ngoài.
2. **Ôn luyện, không giảng dạy**: App là công cụ kiểm tra và củng cố, không thay thế tài liệu học.
3. **Tiếng Việt làm ngôn ngữ nền**: Nghĩa tiếng Việt là first-class citizen trong toàn bộ từ vựng và kanji.
4. **Không đồng bộ, không tài khoản**: Mỗi thiết bị là một phiên độc lập; không có server-side state.
5. **Tiến hoá từ flashcard**: Mọi tính năng mới phải phục vụ mục tiêu ôn luyện JLPT; tránh bloating thành wiki hay từ điển.
