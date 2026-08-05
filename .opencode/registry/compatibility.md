---
name: capability-compatibility
description: compatibility — kiểm tra tương thích Capability Version ↔ Agent Version ↔ Contract Version. Reject nếu không khớp.
agent: general
---

# Capability Compatibility

> Kiểm tra tương thích trước khi chọn agent. **Không tương thích → Reject.**

## 1. Pipeline check

```text
Capability Version
       ↓
Agent Version
       ↓
Contract Version
       ↓
Compatible? → Select | Reject
```

## 2. Bảng compatibility

| Check | Điều kiện pass |
|-------|----------------|
| Capability vs Agent | agent `supports` capability + agent.version >= capability.since |
| Capability vs Contract | capability.contracts tồn tại trong contract-registry |
| Framework | capability.requires_framework ⊆ agent.frameworks |
| Deprecated | capability deprecated → cảnh báo, chỉ dùng nếu replacement trống |

## 3. Ví dụ version

```yaml
# implementation.code 1.0
version: 1.0.0
since: 4.0.0

# sau này
version: 2.0.0
```

Agent cũ (support 1.0) **vẫn chạy** với capability 2.0 nếu version policy cho phép (semver: MAJOR tăng = breaking).

## 4. Version policy

| Capability version | Agent support | Kết quả |
|---------------------|---------------|---------|
| 1.0.0 | `>=1.0.0` | ✅ |
| 2.0.0 (MAJOR bump) | `>=1.0.0` | ⚠️ check breaking |
| 2.0.0 | `>=2.0.0` | ✅ |
| 2.0.0 | `1.x` only | ❌ Reject |

## 5. Reject → xử lý

- Reject → matcher tìm candidate kế tiếp.
- Hết candidate → CAP-002 (no provider) → recovery.

## 6. Lỗi

| Mã | Mô tả |
|----|-------|
| CAP-001 | Capability not found |
| CAP-002 | No compatible provider |
| CAP-003 | Registry invalid |

## 7. Tương tác

- `scorer.md` (trước khi chọn, compatibility là bước cuối)
- `registry.md` (API)
- `VERSIONING.md` (semver chung)