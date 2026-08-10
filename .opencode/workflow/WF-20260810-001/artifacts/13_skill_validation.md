---
name: skill_validation
description: >
  Self-improver de xuat cai tien skill/knowledge sau workflow homepage Gaming
  Console. Optional phase — co the tra NO_SUGGESTIONS.
agent: self-improver
---

# Phase 13 — De xuat cai tien skill (WF-20260810-001)

## 1. Danh gia workflow vua chay

| Kien thuc | Danh gia |
|-----------|----------|
| Test template HTML doc lap (khong thuoc .NET project) | Workflow van chay dung: plan -> build -> test theo pattern WF-20260808-001 |
| Playwright cho static template | Phai dung channel msedge vi khong co browser cache dung version; smoke script can thiet ke lai cho mailto |

## 2. De xuat

| Category | De xuat | Muc do |
|----------|---------|--------|
| knowledge | Ghi lai pattern "standalone HTML template workflow" vao knowledge base — file cau truc, cach test bang Playwright file:// + channel msedge | Low |
| skill | Test report skill co the them template cho static-site smoke test (khong can dev server) | Low |

Khong co de xuat bat buoc — workflow chay muot, 10/10 test PASS, khong retry.

## Output

```yaml
status: PASS
summary: >
  Workflow chay thanh cong voi 0 retry. De xuat Low-priority: ghi pattern template
  HTML standalone + Playwright file:// channel msedge vao knowledge base.
suggestions:
  - category: knowledge
    suggestion: "Ghi pattern standalone HTML template + Playwright file:// msedge"
    priority: Low
  - category: skill
    suggestion: "Test report skill: template static-site smoke test"
    priority: Low
```
