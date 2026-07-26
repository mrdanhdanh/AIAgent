# Validate GitHub Actions YAML trong workflow

## Pattern

Thêm step validate YAML workflow trước khi deploy để tránh syntax error.

### Cách 1: Dùng action (recommended)
```yaml
- name: Validate workflow
  uses: github/validate-workflow@v1
```

### Cách 2: Dùng yaml-lint
```yaml
- name: Validate YAML
  run: |
    pip install yamllint
    yamllint .github/workflows/
```

## Integration
Thêm vào dev-team workflow sau step BUILD và trước DEPLOY:
```yaml
step: validate_workflow
agent: self (orchestrator)
action: chạy yamllint hoặc github/validate-workflow
on_fail: BLOCK
```

## Cross-reference
- `.opencode/knowledge/deployment/blazor-wasm-github-pages.md` — GitHub Pages deployment pattern (Blazor WASM)
- Lưu ý: kiểm tra trigger branch (`main` vs `master`) — sai branch → workflow không chạy


