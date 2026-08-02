---
name: plugin-certification
description: Plugin Certification — gate trước khi enable: simulation, doctor, compat, security, performance.
agent: general
---

# Plugin Certification

## 1. Vai trò

Plugin mới phải **certified** trước khi enable. Không đạt → không enable.

## 2. Certification pipeline

```text
Plugin mới
  → Simulation (chạy thử với plugin)
  → Doctor (static + health)
  → Compatibility (framework/dependency)
  → Security (permission scan)
  → Performance (benchmark)
  → Certified? → enable : block
```

## 3. Levels

| Level | Mô tả |
|-------|-------|
| none | chưa certify — không enable |
| basic | pass core checks — enable thử nghiệm |
| certified | pass đầy đủ — enable production |

## 4. Checks

| Check | Tool |
|-------|------|
| Simulation | Simulation Engine (Phase 7) |
| Doctor | Doctor v2 (Phase 8) |
| Compatibility | compatibility.md |
| Security | security.md scan |
| Performance | runtime-benchmark |

## 5. Certificate

```yaml
certificate:
  plugin: oracle
  version: 1.0.0
  level: certified
  issued_at: ISO8601
  checks: { simulation: pass, doctor: 92, security: pass, performance: ok }
```

## 6. Tương tác

- `manager.md` — enable gate.
- `lifecycle.md` — loaded → enabled cần certify.
- Marketplace — hiển thị badge.