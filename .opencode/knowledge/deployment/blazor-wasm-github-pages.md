# Blazor WASM — GitHub Pages Deployment

## Pattern

### Problem
Blazor WASM app chạy localhost nhưng không hoạt động trên GitHub Pages do:
1. `base href="/"` — sai khi deploy sub-path (`https://user.github.io/repo/`)
2. Thiếu `404.html` — SPA routing không hoạt động
3. Thiếu `.nojekyll` — GitHub Pages không serve file `_framework/`
4. Build thiếu `dotnet publish -c Release` — thiếu file tĩnh

### Solution

**1. Dynamic base href** (trong `index.html`):
```javascript
<script>
  (function() {
    var base = document.querySelector('base');
    if (base) {
      var scripts = document.getElementsByTagName('script');
      for (var i = 0; i < scripts.length; i++) {
        var src = scripts[i].src;
        if (src && src.includes('blazor.webassembly.js')) {
          var path = new URL(src).pathname;
          var basePath = path.substring(0, path.lastIndexOf('/') + 1);
          base.href = basePath;
          break;
        }
      }
    }
  })();
</script>
```

**2. 404.html SPA fallback:**
```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Redirecting...</title>
  <script>
    var segmentCount = 1; // 1 for username.github.io/repo
    var path = location.pathname;
    path = path.split('/').slice(0, segmentCount + 1).join('/') + '/';
    var redirect = encodeURIComponent(location.pathname.replace(path, '/'));
    sessionStorage.setItem('redirect', redirect);
    location.replace(path);
  </script>
</head>
<body></body>
</html>
```

**3. deploy.yml:**
- Trigger: push main + workflow_dispatch
- .NET version matching project
- `dotnet publish -c Release`
- JamesIves/action-deploy-pages@v4 → branch `gh-pages`

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
