---
name: artifact-checksum
description: Artifact Checksum — SHA256 integrity check, phát hiện file bị sửa tay.
agent: general
---

# Artifact Checksum

## 1. Mục đích

Đảm bảo file artifact không bị sửa ngoài Manager. Doctor phát hiện ngay khi checksum mismatch.

## 2. Cơ chế

- Mỗi artifact → SHA256(content).
- Lưu trong metadata + `artifacts/checksum.json`.
- Doctor verify định kỳ (so sánh checksum hiện tại vs đã lưu).

## 3. checksum.json

```json
{
  "PLAN-001": "sha256:abc123def456...",
  "CODE-001": "sha256:789xyz..."
}
```

## 4. Mismatch → action

- Doctor báo ART-ERR-001 (tampered).
- Context Engine từ chối deliver artifact bị tamper.
- Manager tự cập nhật checksum mới nếu version bump.

## 5. Tương tác

- `manager.md` compute checksum mỗi lần save.
- `repository.md` compute raw SHA256.
- Phase 8 (Doctor) verify integrity.