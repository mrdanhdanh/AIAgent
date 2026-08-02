---
name: sdk-versioning
description: SDK Versioning — semver, stability lifecycle, deprecation policy.
agent: general
---

# SDK Versioning

## 1. Vai trò

SDK version ổn định — thay đổi implementation không phá consumer.

## 2. Version

- SDK version = framework version (13.0.0).
- Semver: MAJOR.MINOR.PATCH.

## 3. Stability lifecycle

```text
experimental → stable → frozen
```

| Level | Breaking change |
|-------|-----------------|
| experimental | cho phép, cần warning |
| stable | cần deprecation window (≥1 minor) |
| frozen | không đổi |

## 4. Deprecation

- Deprecate → warning ở log.
- Giữ tối thiểu 1 major version.
- Migration guide cho breaking.

## 5. Compatibility

- Plugin manifest khai `sdk: ">=13.0"`.
- Runtime kiểm tra compat khi load plugin/consumer.

## 6. Tương tác

- `aios-sdk.schema.yaml`.
- Plugin (Phase 11) version gate.
- Dashboard (Phase 12) SDK version.