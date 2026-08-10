---
name: database-migration-patterns
description: >
  Database migration patterns cho dự án .NET — entity model, EF Core migration,
  SQL schema, CRUD repository, seed data. Áp dụng khi làm việc với database/storage.
tags: [database, sql, migration, entity, model, storage, crud]
---

# Database Migration Patterns

## Entity & Data Model

- **Entity**: model dữ liệu (class) — thuộc Models/ (JapaneseLearner).
- **Data model** là nguồn sự thật cho schema — schema sinh từ model (EF Core).
- **CRUD**: Create → Read → Update → Delete qua Repository pattern.
- **Seed data**: dữ liệu khởi tạo — tách khỏi migration, nạp khi app start.

## SQL & Storage

- **SQL**: ngôn ngữ truy vấn database — SELECT/INSERT/UPDATE/DELETE.
- **Storage**: nơi lưu dữ liệu (database, blob, file system).
- **Index**: tăng tốc truy vấn — đặt trên cột WHERE/ORDER thường dùng.
- **Transaction**: đảm bảo atomic — commit/rollback khi nhiều bước.

## Migration

- **Migration**: thay đổi schema qua version — không sửa trực tiếp bảng.
- **Add**: thêm cột/bảng — backward compatible.
- **Change**: đổi kiểu — kiểm tra data hiện có.
- **Remove**: xóa cột — cần backup + migration guide.
- **Downgrade**: rollback migration khi cần.

## Repository Pattern

```text
Repository (interface)
  +- Read (Get/GetAll)
  +- Write (Add/Update/Delete)
  +- Transaction (Unit of Work)
```

- Không để SQL trực tiếp trong UI layer.
- Repository ẩn chi tiết storage khỏi service.

## Seed Data Pattern

- Seed dữ liệu reference (không phải business data).
- Chạy khi database mới tạo / app start.
- Kiểm tra tồn tại trước khi insert (idempotent).

## Checklist

- [ ] Model khớp schema (entity ↔ bảng)
- [ ] Migration có up + down
- [ ] CRUD hoạt động đầy đủ
- [ ] Seed data idempotent
- [ ] Index trên cột truy vấn thường
