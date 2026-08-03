# Appendix C — Metadata Catalog
Thuộc SPEC-000 Constitution. Danh mục metadata chuẩn.

| Field | Loại | Mô tả |
|-------|------|-------|
| id | string | định danh duy nhất |
| type | string | loại entity |
| version | integer | tăng dần, immutable |
| status | string | draft/stable/deprecated... |
| owner | string | chủ sở hữu (core/plugin/...) |
| created_at | timestamp | thời điểm tạo |
| updated_at | timestamp | thời điểm cập nhật |
| tags | array | nhãn |
| checksum | string | SHA256 (artifact) |
| capability | string | capability gốc |

Nguyên tắc: metadata là nguồn cho resolver/scheduler/doctor (P003, P012).