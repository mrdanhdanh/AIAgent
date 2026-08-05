# Model Policy — Free Model Toggle

Bật/tắt **free model** (`opencode-go/deepseek-v4-flash`) cho toàn bộ agent/skill/command trong project.

## Cách hoạt động

| File | Vai trò |
|------|---------|
| `settings.json` | Nguồn sự thật: `free_model_enabled` (bool) + `free_model` |
| `models.default.json` | Registry model mặc định theo tier (pro/flash) cho từng agent |
| `../scripts/model-policy.ps1` | Script áp dụng setting vào `opencode.json` + `.opencode/agents/*.md` |
| `backup/` | Backup `opencode.json` tự động trước mỗi lần ghi |

## Sử dụng

```powershell
# Xem trạng thái (read-only)
& ".opencode\scripts\model-policy.ps1" -Mode status

# Bật free model
& ".opencode\scripts\model-policy.ps1" -Mode enable

# Tắt free model (restore defaults)
& ".opencode\scripts\model-policy.ps1" -Mode disable
```

Hoặc dùng command: `/model-policy status|apply|enable|disable`

**Sau khi bật/tắt phải restart opencode session** để config mới có hiệu lực.

## Thay đổi khi `free_model_enabled = true`

Mọi agent trong `opencode.json` và `.opencode/agents/*.md` chuyển sang:
`opencode-go/deepseek-v4-flash`

Khi tắt, khôi phục model mặc định theo tier:
- `opencode-go/deepseek-v4-pro` — Analyst/Planner/Reviewer/Architect tier
- `opencode-go/deepseek-v4-flash` — Coder/Tester/Routine tier

## Backup & rollback

- Backup tự động: `.opencode/model-policy/backup/opencode.<timestamp>.json.bak`
- Rollback: copy file backup về `opencode.json`
