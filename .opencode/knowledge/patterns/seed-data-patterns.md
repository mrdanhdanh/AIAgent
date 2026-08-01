---
category: pattern
last_updated: 2026-08-01
---

# Seed Data Patterns

## Khái niệm

Seed data load **lần đầu** khi localStorage chưa có dữ liệu. Mỗi service (Char, Word, Kanji, Grammar)
có dataset riêng; `WordService`/`KanjiService` nhận optional `IProgress<int>` khi seed data lớn.

## Pattern cache-first + seed

```csharp
var stored = await _storage.GetItemAsync<List<T>>(Key);
if (stored is null)
{
    stored = SeedData.GetAll();           // first load → seed
    await _storage.SetItemAsync(Key, stored);
}
_cache = stored;
```

## GetAllAsync với progress

```csharp
public async Task<List<T>> GetAllAsync(IProgress<int>? progress = null)
{
    // seed data lớn → report progress 0..100 cho UI hiện FluentProgressRing
}
```

## Quy tắc

- Seed CHỈ chạy khi key chưa tồn tại — không ghi đè dữ liệu user
- Write-through: mọi mutation đều persist ngay
- Admin CRUD sửa dữ liệu → persist và cập nhật cache cùng lúc
