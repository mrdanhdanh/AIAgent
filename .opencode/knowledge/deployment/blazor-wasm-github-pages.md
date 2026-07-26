# Blazor WASM — GitHub Pages Deployment

## Pattern

### Problem
Blazor WASM app chạy localhost nhưng không hoạt động trên GitHub Pages do:
1. `base href="/"` — sai khi deploy sub-path (`https://user.github.io/repo/`)
2. Thiếu `404.html` — SPA routing không hoạt động
3. Thiếu `.nojekyll` — GitHub Pages không serve file `_framework/`
4. Build thiếu `dotnet publish -c Release` — thiếu file tĩnh

### Solution

**1. Dynamic base href** — phải chạy trong `<head>` TRƯỚC các `<link>` CSS:
```javascript
<script>
  (function() {
    var base = document.querySelector('base');
    if (base) {
      var segments = window.location.pathname.split('/').filter(Boolean);
      if (segments.length >= 2) {
        base.href = '/' + segments.slice(0, 2).join('/') + '/';
      }
    }
  })();
</script>
```
Không dùng cách đọc `blazor.webassembly.js` src (chạy muộn, CSS đã load sai).
Dùng `window.location.pathname` — chạy ngay, đúng với mọi URL.

**2. 404.html SPA fallback (root-level, multi-project):**
```html
<script>
    var segments = window.location.pathname.split('/').filter(Boolean);
    if (segments.length >= 2) {
        var baseHref = '/' + segments.slice(0, 2).join('/') + '/';
        var redirect = '/' + segments.slice(2).join('/');
        window.location.replace(baseHref + '?redirect=' + encodeURIComponent(redirect));
    }
</script>
```
Lưu ý:
- `segmentCount = 2` vì path có dạng `/repo/project/`
- Dùng query param `?redirect=` thay vì sessionStorage (reliable hơn)
- index.html cần script đọc `?redirect=` và dùng `history.replaceState()`

**3. deploy.yml:**
- Trigger: push master (or main) + workflow_dispatch
- .NET version matching project
- `dotnet publish -c Release`
- JamesIves/action-deploy-pages@v4 → branch `gh-pages`
- Multi-project: dùng `target-folder` + copy root-level files (404.html, index.html) từ `gh-pages-root/`
- .NET 10 không gen `blazor.webassembly.js` — cần copy từ hashed version trong deploy step

Xem thêm workflow validation: `.opencode/knowledge/workflow/validate-github-actions-yaml.md`

**4. .nojekyll**: Tạo file rỗng hoặc dùng action flag `--nojekyll`

## Files cần tạo/sửa
- `.github/workflows/deploy.yml`
- `wwwroot/index.html` (thêm script)
- `wwwroot/404.html`
- `.nojekyll` (optional, action tự tạo)

## Test checklist
- [ ] Build thành công: `dotnet build -c Release`
- [ ] Publish thành công: `dotnet publish -c Release`
- [ ] 404 redirect không vòng lặp
- [ ] base href đúng trên localhost (`/`) và sub-path (`/repo/`)
- [ ] E2E: Playwright kiểm tra app load được sau deploy
  - [ ] HTTP 200 cho index.html, CSS, JS (blazor.webassembly.js)
  - [ ] 404 redirect: truy cập route ảo → redirect về app + giữ đúng path
  - [ ] Nav links dùng relative paths (không absolute) — hoạt động cả localhost lẫn sub-path

## Cross-reference
- `.opencode/knowledge/workflow/validate-github-actions-yaml.md` — validate workflow YAML trước deploy
- `AGENTS.md` — project conventions (FluentUI, DI, tri-state)

## Related issues
- `.NET 10`: `dotnet publish` không gen `blazor.webassembly.js` → cần copy từ hashed version
- `FluentNavLink Href="/xxx"`: absolute path bỏ qua base href → dùng relative path `Href="xxx"`
