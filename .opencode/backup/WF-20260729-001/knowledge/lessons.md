---
last_updated: 2026-07-23
total_lessons: 3
---

# Lessons Learned

Kho bài học kinh nghiệm được tích lũy qua các workflow.

## Cấu trúc entry

```yaml
- lesson_id: LSN-{number}
  type: "success | failure | improvement | warning"
  workflow: "Yêu cầu gốc"
  situation: "Bối cảnh xảy ra"
  observation: "Điều đã quan sát được"
  action: "Hành động đã làm hoặc sẽ làm"
  tags: ["tag1", "tag2"]
```

## Danh sách bài học

- lesson_id: LSN-001
  type: "failure"
  workflow: "Fix build lỗi Blazor WASM"
  situation: "Build gặp 5 lỗi: FontWeight int→string, App type not found, Defaults namespace"
  observation: "MudBlazor 9.7.0 dùng string cho FontWeight thay vì int; Program.cs cần `using JapaneseLearner;` để tìm App type; `using MudBlazor;` cần thiết cho Defaults.Classes"
  action: "Đổi FontWeight thành string (\"400\", \"700\", \"600\"), thêm using JapaneseLearner và using MudBlazor trong Program.cs"
  tags: ["blazor", "mudblazor", "build-error", "fontweight"]

- lesson_id: LSN-002
  type: "failure"
  workflow: "Fix runtime IndexOutOfRangeException trong MudThemeProvider"
  situation: "App crash với System.IndexOutOfRangeException khi MudThemeProvider.GenerateTheme chạy"
  observation: "Shadow.Elevation array trong MudBlazor 9.7.0 phải có đúng 25 phần tử (index 0-24), nếu khai báo thiểu sẽ gây IndexOutOfRangeException vì MudBlazor truy cập tất cả indices để tạo CSS variables"
  action: "Xoá custom Shadows khỏi theme, dùng `Shadows = new Shadow()` mặc định"
  tags: ["blazor", "mudblazor", "runtime-error", "shadow", "theme"]

- lesson_id: LSN-003
  type: "failure"
  workflow: "Fix runtime missing MudPopoverProvider"
  situation: "PopoverService báo lỗi Missing <MudPopoverProvider /> trong render tree"
  observation: "MudBlazor yêu cầu <MudPopoverProvider /> trong layout để popover/dropdown hoạt động"
  action: "Thêm <MudPopoverProvider /> sau <MudThemeProvider /> trong MainLayout.razor"
  tags: ["blazor", "mudblazor", "runtime-error", "popover"]
