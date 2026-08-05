---
name: workflow-phase-design
description: Thiet ke giai phap — them AIHub vao landing page + publish AIHub trong deploy.yml
agent: planner
---

# Phase 02 — Design (WF-20260805-001)

## Architecture

```
GitHub Actions (deploy.yml)
  ├── dotnet publish JapaneseLearner ──> release/wwwroot ──> deploy/JapaneseLearner/  (base href /AIAgent/JapaneseLearner/)
  └── dotnet publish AIHub ────────────> release-aihub/wwwroot ──> deploy/AIHub/       (base href /AIAgent/AIHub/)
          │
          └── gh-pages-root/* (404.html, index.html) ──> deploy/ (landing page với 2 cards)
                      │
                      ▼
              JamesIves/github-pages-deploy-action ──> branch gh-pages
```

## Component design

| Component | Thay đổi | Chi tiết |
|-----------|----------|----------|
| `gh-pages-root/index.html` | Thêm 1 card | Card AIHub sau card JapaneseLearner, cùng style `.card`, href `/AIAgent/AIHub/` |
| `deploy.yml` | Thêm publish AIHub | `dotnet publish AIHub/AIHub.csproj -c Release -o release-aihub --nologo` |
| `deploy.yml` | Thêm copy AIHub | `cp -r release-aihub/wwwroot/* deploy/AIHub/` |
| `deploy.yml` | Thêm base href rewrite | `sed -i 's|<base href="/" />|<base href="/AIAgent/AIHub/" />|' deploy/AIHub/index.html` |
| `deploy.yml` | Thêm hashed js copy | Loop `deploy/AIHub/_framework/blazor.webassembly.*.js` → copy sang `blazor.webassembly.js` |
| `AIHub/wwwroot/index.html` | KHÔNG đổi | Base href `/` được rewrite tại deploy (giữ source sạch, chạy local OK) |

## Data flow / Luồng

1. Push lên `master` (hoặc workflow_dispatch) → trigger deploy.yml
2. Build + publish 2 apps riêng biệt
3. Copy vào cấu trúc `deploy/`
4. Rewrite base href cho từng app
5. Push toàn bộ lên `gh-pages` branch
6. Landing page (`/AIAgent/`) hiển thị 2 cards → link tới 2 app

## Security concerns

- Không có secret mới, không thay đổi permissions (đã có `contents: write`, `pages: write`)
- KHÔNG dùng `&` để chạy 2 publish song song (theo convention shell notes — dùng tuần tự `&&` trong bash runner)
- Giữ nguyên cấu trúc deploy hiện tại để không phá JapaneseLearner

## Output contract

```yaml
status: "PASS"
architecture: >
  deploy.yml publish ca 2 app vao deploy/{JapaneseLearner,AIHub}, moi app co
  base href rieng (/AIAgent/<App>/), landing page link toi ca 2.
components:
  - "gh-pages-root/index.html"
  - ".github/workflows/deploy.yml"
```

## Checklist

- [x] Thiet ke component day du (landing page + deploy.yml)
- [x] Luong du lieu ro rang (publish → copy → rewrite → push)
- [x] Security concerns duoc ghi nhan
- [x] Khong pha luong deploy JapaneseLearner hien tai
- [x] Base href rieng cho tung app
