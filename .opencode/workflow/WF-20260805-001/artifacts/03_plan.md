---
name: workflow-phase-plan
description: Lap ke hoach thuc thi — 2 buoc chinh (landing page + deploy.yml)
agent: planner
---

# Phase 03 — Plan (WF-20260805-001)

## Ke hoach thuc thi

| Step | Mo ta | File | Expected result |
|------|-------|------|-----------------|
| 1 | Them card AIHub vao landing page (sau card JapaneseLearner, cung style, href /AIAgent/AIHub/) | `gh-pages-root/index.html` | Landing page co 2 cards, valid HTML |
| 2 | Cap nhat deploy.yml: them publish AIHub + copy deploy/AIHub + base href rewrite + hashed js copy | `.github/workflows/deploy.yml` | Deploy pipeline publish ca 2 app, base href dung cho moi app |
| 3 | Validate YAML deploy.yml (indentation, keys) | `.github/workflows/deploy.yml` | YAML hop le, khong vo structure |
| 4 | Kiem tra lai build ca 2 project local (dotnet build) | `JapaneseLearner/`, `AIHub/` | Build pass ca 2 |

## Chi tiet buoc 1 — Landing page

Them sau dong card JapaneseLearner (index.html:23):

```html
    <a class="card" href="/AIAgent/AIHub/">
        <h2>AI Hub</h2>
        <p>Khám phá các công cụ AI và repository trending</p>
    </a>
```

## Chi tiet buoc 2 — deploy.yml

Them 3 khoi sau buoc "Publish" hien tai (deploy.yml:25):

```yaml
      - name: Publish AIHub
        run: dotnet publish AIHub/AIHub.csproj -c Release -o release-aihub --nologo
```

Trong buoc "Prepare deploy structure" (deploy.yml:31), them:

```bash
          mkdir -p deploy/AIHub
          cp -r release-aihub/wwwroot/* deploy/AIHub/
          # Copy hashed blazor.webassembly.<hash>.js cho AIHub
          for f in deploy/AIHub/_framework/blazor.webassembly.*.js; do
            if [[ "$f" != *".gz" && "$f" != *".br" ]]; then
              cp "$f" deploy/AIHub/_framework/blazor.webassembly.js
              break
            fi
          done
          sed -i 's|<base href="/" />|<base href="/AIAgent/AIHub/" />|' deploy/AIHub/index.html
```

## Dependency

- Step 1 (landing page) độc lập với step 2 (deploy.yml)
- Step 3, 4 phụ thuộc step 1, 2 (validate sau khi sửa)

## Output contract

```yaml
status: "PASS"
steps:
  - order: 1
    description: "Them card AIHub vao gh-pages-root/index.html"
    file: "gh-pages-root/index.html"
    expected_result: "2 cards tren landing page"
  - order: 2
    description: "Them publish + deploy AIHub trong deploy.yml"
    file: ".github/workflows/deploy.yml"
    expected_result: "Pipeline publish ca 2 app, base href /AIAgent/AIHub/"
  - order: 3
    description: "Validate YAML deploy.yml"
    file: ".github/workflows/deploy.yml"
    expected_result: "YAML hop le"
  - order: 4
    description: "Build ca 2 project local de xac nhan"
    file: "JapaneseLearner/, AIHub/"
    expected_result: "Build PASS"
```

## Checklist

- [x] Ke hoach co it nhat 1 buoc, co expected_result moi buoc
- [x] Buoc 1 (landing page) + buoc 2 (deploy.yml) ro rang
- [x] Validate + build sau khi thay doi
- [x] Khong thay doi source AIHub (chinh base href luc deploy)
