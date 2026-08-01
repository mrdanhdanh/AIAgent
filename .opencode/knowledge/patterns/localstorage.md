---
category: pattern
last_updated: 2026-08-01
---

# Local Storage Patterns (Blazored.LocalStorage)

## Khái niệm

Japanese Learner persist dữ liệu bằng **Blazored.LocalStorage** thông qua `ILocalStorageService`.
Services (IWordService, IKanjiService, ...) cache in-memory + write-through khi mutation.

## Cache-first

```
GetAllAsync:
  check _cache → hit → return
  miss → load từ localStorage → fallback → seed data → save cache

Add/Update/Delete:
  sửa _cache → persist xuống localStorage (write-through)
```

## Ví dụ khởi tạo

```csharp
if (_cache is null)
{
    var stored = await _storage.GetItemAsync<List<T>>("key");
    _cache = stored ?? SeedData.GetAll();   // seed on first load
    await SaveAsync();
}
```

## Lưu ý

- Tránh đọc/ghi localStorage liên tục — luôn qua cache
- Seed data chỉ chạy khi key chưa tồn tại (first load)
- Mock bằng `MockStorageService` khi test service layer
