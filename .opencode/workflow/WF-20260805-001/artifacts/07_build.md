---
name: workflow-phase-build
description: Thuc thi thay doi code — landing page link + deploy.yml publish AIHub
agent: builder
---

# Phase 07 — Build (WF-20260805-001)

## Changed files

| File | Thay doi | Trang thai |
|------|----------|------------|
| `gh-pages-root/index.html` | Them card AIHub (href /AIAgent/AIHub/) sau card JapaneseLearner | DONE |
| `.github/workflows/deploy.yml` | Them Publish AIHub step, deploy/AIHub structure, base href rewrite, hashed js copy | DONE |

## Chi tiet thay doi

### gh-pages-root/index.html

- Them block:
```html
    <br />
    <a class="card" href="/AIAgent/AIHub/">
        <h2>AIHub</h2>
        <p>Khám phá các công cụ AI và repository trending</p>
    </a>
```
- Giu nguyen card JapaneseLearner + style CSS

### .github/workflows/deploy.yml

1. **Them step "Publish AIHub"** (dong 27-28):
   `dotnet publish AIHub/AIHub.csproj -c Release -o release-aihub --nologo`
2. **Add .nojekyll** cho ca 2 (dong 31): `touch release/wwwroot/.nojekyll release-aihub/wwwroot/.nojekyll`
3. **Prepare deploy structure** (dong 38-39): `mkdir -p deploy/AIHub` + `cp -r release-aihub/wwwroot/* deploy/AIHub/`
4. **Hashed blazor.webassembly.js copy cho AIHub** (dong 48-54): loop giong JapaneseLearner
5. **Base href rewrite cho AIHub** (dong 57): `sed -i 's|<base href="/" />|<base href="/AIAgent/AIHub/" />|' deploy/AIHub/index.html`

## Build verification

- `dotnet publish AIHub/AIHub.csproj -c Release -o <temp>` — **PASS** (AIHub -> AIHub.dll, Blazor output OK)
- Publish output co: `_framework/blazor.webassembly.js`, `index.html` voi `<base href="/" />` (se duoc rewrite luc deploy)
- Deploy loop `blazor.webassembly.*.js` robust: match ca unhashed (local) lan hashed (CI .NET 10)

```yaml
status: "PASS"
changed_files:
  - "gh-pages-root/index.html"
  - ".github/workflows/deploy.yml"
created_files: []
build_verified: true
```

## Checklist

- [x] Landing page co 2 cards, valid HTML
- [x] deploy.yml publish ca 2 app
- [x] Base href rewrite rieng cho tung app
- [x] Hashed js copy cho ca 2 app
- [x] AIHub build PASS local
- [x] Khong pha JapaneseLearner deploy flow
