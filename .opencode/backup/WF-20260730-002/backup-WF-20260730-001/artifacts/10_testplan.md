# Alphabet Quiz - Test Plan

## Test Types

| Type | Tool | Target |
|------|------|--------|
| Unit | bUnit + Moq | AlphabetQuiz.razor component + logic |
| Integration | bUnit + ICharService | Filter by type (Hiragana/Katakana) |
| E2E | Playwright | Full page lifecycle |

## Test Cases (Unit)

| ID | Description | Type |
|----|-------------|------|
| T-01 | Render shows title "Trắc nghiệm bảng chữ cái" | Render |
| T-02 | Render shows mode toggle buttons | Render |
| T-03 | Default mode is Kana → Romaji | Behavior |
| T-04 | Displays char when data exists | Render |
| T-05 | Shows 4 option buttons | Render |
| T-06 | Correct answer appears in options | Behavior |
| T-07 | All options have distinct values | Behavior |
| T-08 | Select correct increments correctCount | Interaction |
| T-09 | Select wrong increments wrongCount | Interaction |
| T-10 | Correct answer shows "Chính xác" feedback | Feedback |
| T-11 | Wrong answer shows "Đáp án đúng" | Feedback |
| T-12 | After answer all options disabled | Interaction |
| T-13 | Correct answer has .opt-correct class | Styling |
| T-14 | Shows filter dropdown with All/Hira/Kata | Render |
| T-15 | Empty state when no chars | Edge case |
| T-16 | Stats initially zero | Render |
| T-17 | Switch to Romaji→Kana mode works | Mode toggle |
| T-18 | Romaji→Kana shows char in options | Mode toggle |
| T-19 | Romaji→Kana correct shows char | Feedback |
| T-20 | Filter by type changes available chars | Integration |

## Coverage Targets

| Metric | Target | Current |
|--------|--------|---------|
| Unit (AlphabetQuiz) | 80% | 20 tests, đủ phủ logic chính |
| Overall project | 70% | 154 tests pass (no regression) |
