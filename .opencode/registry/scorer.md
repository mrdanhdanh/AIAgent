---
name: capability-scorer
description: Scorer — xếp hạng candidate agents/entities theo score để chọn agent cuối.
agent: general
---

# Capability Scorer

## 1. Mục đích

Một capability có thể có nhiều agent/skill/command. Scorer ranking để chọn ra candidate tối ưu nhất.

## 2. Scoring formula

```
Score = w_c * CapabilityMatch
      + w_l * LanguageMatch
      + w_f * FrameworkMatch
      + w_p * Priority
      + w_a * Availability
      + w_h * HistoricalSuccess
```

Trọng số mặc định (0..1):

| Thành phần | w | Mô tả |
|-----------|----|-------|
| CapabilityMatch | 0.30 | độ khớp capability với request |
| LanguageMatch | 0.15 | agent có ngôn ngữ phù hợp (csharp...)? |
| FrameworkMatch | 0.15 | agent có framework phù hợp (blazor...)? |
| Priority | 0.20 | giá trị `priority` trong registry (0..100) |
| Availability | 0.10 | agent enabled + không bận/local |
| HistoricalSuccess | 0.10 | tỉ lệ thành công trong quá khứ (mặc định 1.0) |

Tổng score quy về 0..100.

## 3. Ví dụ (capability=implementation.code, lang=csharp, framework=blazor)

| Agent | CapMatch | Lang | Fw | Prio | Avail | Hist | Score |
|-------|----------|------|----|------|-------|------|------:|
| builder | 1.0 | 1.0 | 1.0 | 80 | 1.0 | 1.0 | **97** |
| general | 1.0 | 0.5 | 0.5 | 30 | 1.0 | 1.0 | **81** |
| learning-agent | 0.5 | 0.5 | 0.5 | 40 | 1.0 | 0.9 | **40** |

Builder thắng.

## 4. Tie-break

Khi score bằng → ưu tiên: entity có `priority` cao hơn; nếu vẫn bằng → agent có `version` mới hơn.

## 5. Fallback

Nếu agent được chọn không tồn tại/disabled → engine tìm candidate kế tiếp trong list, và cuối cùng
fallback `orchestration.fallback` (general). KHÔNG crash.

## 6. Lưu ý

Sprint 2 chỉ định nghĩa formula + ví dụ. Engine v4 hiện KHÔNG gọi scorer khi chạy
(non-invasive). Scoring được áp dụng trong /team-capabilities và tài liệu cho Sprint 3 routing.