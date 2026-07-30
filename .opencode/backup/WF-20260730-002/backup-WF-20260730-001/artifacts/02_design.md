# Alphabet Quiz - Design Document

## 1. Architecture

```
┌─────────────────────────────────────────────────────┐
│  AlphabetQuiz.razor (@page "/alphabet/quiz")         │
│  Inject: ICharService, NavigationManager             │
├─────────────────────────────────────────────────────┤
│  OnInitializedAsync → LoadChars() → PickRandomChar() │
│  GenerateOptions(correct) → distractor pool          │
│  SelectAnswer(opt) → feedback + auto-advance (3s)     │
│  SwitchMode(toKanaToRomaji) → reset                  │
└─────────────────────────────────────────────────────┘
          │
          ▼
┌─────────────────────┐
│  ICharService       │
│  GetByTypeAsync()   │ ← cache-first, localStorage
└─────────────────────┘
```

## 2. Components

| Action | Path | Description |
|--------|------|-------------|
| CREATE | `JapaneseLearner/Pages/AlphabetQuiz.razor` | Multiple-choice quiz page (như KanjiQuiz) |
| MODIFY | `JapaneseLearner/Layout/MainLayout.razor` | Thêm nav link "Alphabet Quiz" |
| CREATE | `JapaneseLearner.Tests/AlphabetQuizTests.cs` | Unit test với bUnit + Moq |

## 3. Data Flow

1. OnInitializedAsync → gọi CharService.GetByTypeAsync("All") → lấy tất cả chars
2. PickRandomChar() → chọn ngẫu nhiên 1 JapaneseChar làm câu hỏi
3. GenerateOptions(correct) → lấy 3 distractors (Romaji hoặc Character distinct) + 1 đáp án đúng → shuffle 4 options
4. User click option → SelectAnswer → set isCorrect → cập nhật score → delay 3s → tự động chuyển câu tiếp
5. SwitchMode → đảo chiều Kana⇔Romaji → reset

## 4. Security Concerns

| Risk | Severity | Mitigation |
|------|----------|------------|
| Không có input từ user (chỉ click button) | NONE | Không cần xử lý |
| XSS qua dữ liệu hiển thị | LOW | Dữ liệu từ seed data, không có user input |

## 5. Edge Cases

| Case | Handling |
|------|----------|
| Không có dữ liệu (empty) | Hiển thị empty state + nút "Đến Admin" |
| Chỉ có 1 ký tự | Distractor pool rỗng → fill với "???" |
| Score reset khi filter | Score giữ nguyên qua các lần đổi mode |
| Cùng romaji cho nhiều char | Dùng .Distinct() cho pool |

## 6. Issues

| Type | Issue | Severity |
|------|-------|----------|
| non_blocking | Cần quyết định icon cho nav link | LOW |

## 7. Effort: **Small** (1 page + nav + tests)
