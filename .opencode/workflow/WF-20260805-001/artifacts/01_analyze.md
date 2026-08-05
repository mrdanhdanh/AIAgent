---
name: workflow-phase-analyze
description: Phan tich yeu cau — fix landing page link + publish AIHub len GitHub Pages
agent: analyst
---

# Phase 01 — Analyze (WF-20260805-001)

## Requirement

```
status: "READY"
summary: >
  Repo co 2 Blazor WASM apps (JapaneseLearner + AIHub). Landing page
  gh-pages-root/index.html chi co link cho JapaneseLearner, thieu link AIHub.
  Workflow deploy (.github/workflows/deploy.yml) chi publish JapaneseLearner,
  AIHub chua duoc public len gh-pages. Can (1) them card AIHub vao landing
  page, (2) cap nhat deploy.yml de publish ca 2 app.
scanned_paths:
  - "gh-pages-root/index.html"
  - "gh-pages-root/404.html"
  - ".github/workflows/deploy.yml"
  - "AIHub/"
  - "JapaneseLearner/"
  - "git ls-tree origin/gh-pages"
ignored_paths:
  - "AIHub/bin/"
  - "AIHub/obj/"
  - "JapaneseLearner/bin/"
  - "JapaneseLearner/obj/"
discovered_modules:
  - JapaneseLearner (Blazor WASM, FluentUI)
  - AIHub (Blazor WASM, FluentUI)
structure:
  root: "AgentAI"
  language: "C# / Razor"
  framework: "Blazor WebAssembly (.NET 10)"
  entry_points:
    - path: "gh-pages-root/index.html"
      type: "config (landing page)"
    - path: ".github/workflows/deploy.yml"
      type: "config (CI/CD)"
  main_directories:
    - path: "gh-pages-root/"
      description: "Root files deployed len gh-pages (404.html, index.html)"
      relevance: "HIGH"
    - path: ".github/workflows/"
      description: "CI/CD deploy len GitHub Pages"
      relevance: "HIGH"
    - path: "AIHub/"
      description: "App Blazor WASM thu 2, chua duoc publish"
      relevance: "HIGH"
requirements:
  - id: "REQ-001"
    description: "Them card link cho AIHub vao landing page gh-pages-root/index.html (href /AIAgent/AIHub/)"
    priority: "HIGH"
  - id: "REQ-002"
    description: "Cap nhat deploy.yml de publish AIHub (dotnet publish AIHub/AIHub.csproj)"
    priority: "HIGH"
  - id: "REQ-003"
    description: "Deploy structure phai tao deploy/AIHub va copy wwwroot cua AIHub"
    priority: "HIGH"
  - id: "REQ-004"
    description: "Rewrite base href cho AIHub index.html thanh /AIAgent/AIHub/"
    priority: "HIGH"
  - id: "REQ-005"
    description: "Copy hashed blazor.webassembly.js cho AIHub (gio nhu JapaneseLearner)"
    priority: "MEDIUM"
  - id: "REQ-006"
    description: "Dam bao JapaneseLearner van deploy dung (khong pha vo luong hien tai)"
    priority: "HIGH"
risks:
  - id: "RISK-001"
    description: "Base href sai -> Blazor WASM khong load duoc resources"
    severity: "HIGH"
    mitigation: "Rewrite base href thanh /AIAgent/AIHub/ nhu JL, kiem tra index.html output"
  - id: "RISK-002"
    description: "Thieu copy blazor.webassembly.js hashed -> app khong chay tren .NET 10"
    severity: "HIGH"
    mitigation: "Copy hashed file giong loop cua JapaneseLearner"
  - id: "RISK-003"
    description: "Landing page link sai path -> 404 tren git pages"
    severity: "MEDIUM"
    mitigation: "Dung chuan /AIAgent/AIHub/ nhu /AIAgent/JapaneseLearner/"
  - id: "RISK-004"
    description: "Publish ca 2 app lam tang thoi gian build CI"
    severity: "LOW"
    mitigation: "Publish song song, cach nhau (KHONG dung '&' nhu trong shell notes)"
assumptions:
  - id: "ASM-001"
    description: "URL public cua AIHub se la https://mrdanhdanh.github.io/AIAgent/AIHub/ (cung pattern voi JL)"
dependencies:
  - from: "deploy.yml"
    to: "AIHub.csproj"
    type: "build"
    evidence_file: ".github/workflows/deploy.yml"
    evidence_line: 25
    reason: "deploy.yml can goi dotnet publish cho AIHub.csproj"
  - from: "gh-pages-root/index.html"
    to: "AIHub published output"
    type: "link"
    evidence_file: "gh-pages-root/index.html"
    evidence_line: 20
    reason: "Landing page can tro link den /AIAgent/AIHub/"
impact_scope:
  - file: "gh-pages-root/index.html"
    level: "DIRECT"
    notes: "Them card AIHub sau card JapaneseLearner"
  - file: ".github/workflows/deploy.yml"
    level: "DIRECT"
    notes: "Them publish AIHub + deploy/AIHub structure + base href rewrite + hashed js copy"
  - file: "AIHub/wwwroot/index.html"
    level: "INDIRECT"
    notes: "Base href se duoc rewrite luc deploy, khong sua source"
design_proposal:
  approach: >
    (1) Them card AIHub vao gh-pages-root/index.html voi href /AIAgent/AIHub/.
    (2) Trong deploy.yml: them buoc dotnet publish AIHub, them cp -r vao
    deploy/AIHub, them sed rewrite base href cho deploy/AIHub/index.html,
    them loop copy hashed blazor.webassembly.js cho deploy/AIHub.
  affected_modules: ["gh-pages-root", ".github/workflows"]
  new_files: []
  modified_files:
    - "gh-pages-root/index.html"
    - ".github/workflows/deploy.yml"
  integration_points: ["GitHub Actions deploy pipeline"]
tasks:
  - id: "TASK-001"
    description: "Them card AIHub vao gh-pages-root/index.html"
    files: ["gh-pages-root/index.html"]
    depends_on: []
    why: "Requirement chinh REQ-001"
  - id: "TASK-002"
    description: "Them dotnet publish AIHub vao deploy.yml"
    files: [".github/workflows/deploy.yml"]
    depends_on: []
    why: "REQ-002 — AIHub chua duoc build/publish"
  - id: "TASK-003"
    description: "Them deploy/AIHub structure + base href rewrite + hashed js copy"
    files: [".github/workflows/deploy.yml"]
    depends_on: ["TASK-002"]
    why: "REQ-003/004/005 — can co publish truoc roi moi copy"
conclusion:
  status: "READY"
  reason: "Yeu cau ro rang, pham vi nho (2 files), codebase da duoc khao sat day du"
  missing_info: []
```

## Evidence collected

- `gh-pages-root/index.html:20-23` — chi co 1 card JapaneseLearner, thieu AIHub
- `.github/workflows/deploy.yml:25` — chi publish JapaneseLearner
- `deploy.yml:33` — chi tao `deploy/JapaneseLearner`
- `deploy.yml:36-42` — chi copy hashed blazor.webassembly.js cho JL
- `deploy.yml:44` — chi rewrite base href cho JL
- `AIHub/AIHub.csproj:1` — Blazor WASM net10.0, FluentUI 4.14.3
- `AIHub/wwwroot/index.html:7` — `<base href="/" />`
- `git ls-tree origin/gh-pages` — khong co thu muc AIHub (chua duoc public)

## Checklist

- [x] Doc codebase: landing page, deploy.yml, AIHub structure
- [x] Xac dinh pham vi anh huong DIRECT (2 files)
- [x] REQ-001..006 day du
- [x] Risk cao nhat: base href + hashed js copy
- [x] Conclusion: READY
