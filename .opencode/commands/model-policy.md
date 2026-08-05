---
description: Bật/tắt free model (opencode-go/deepseek-v4-flash) cho toàn bộ agent/skill/command. Đọc setting từ .opencode/model-policy/settings.json
agent: general
schema_version: "1.0"
---

## HELP — Hướng dẫn sử dụng `/model-policy`

**Mục đích:** Bật/tắt free model cho toàn bộ agent/skill/command trong một lệnh — không phải sửa tay từng agent trong `opencode.json` và `.opencode/agents/*.md`.

**Cơ chế:** Đọc `.opencode/model-policy/settings.json`:
- `free_model_enabled: true` → mọi agent dùng `opencode-go/deepseek-v4-flash`
- `free_model_enabled: false` → khôi phục model mặc định theo tier (từ `models.default.json`)

**Cách dùng:**
- `/model-policy` — xem trạng thái (read-only)
- `/model-policy status` — xem trạng thái (read-only)
- `/model-policy apply` — áp dụng theo settings.json hiện tại (không đổi settings)
- `/model-policy enable` — set `free_model_enabled = true` rồi áp dụng
- `/model-policy disable` — set `free_model_enabled = false` rồi áp dụng (restore defaults)

**Lưu ý:** Sau khi chạy enable/disable phải **restart opencode session** để config mới có hiệu lực. Script tự động backup `opencode.json` trước khi ghi.

## NỘI DUNG

Bạn là **Model Policy Agent**. Xử lý model policy với tham số:

$ARGUMENTS

## QUY TRÌNH

1. **Phân tích tham số** — xác định mode: status (mặc định) | apply | enable | disable
2. **Gọi script**:
   ```powershell
   & ".opencode\scripts\model-policy.ps1" -Mode <mode> -ProjectRoot (Get-Location).Path
   ```
3. **Kiểm tra output** — MODEL-POLICY header, số agent changed (json + md), trạng thái từng agent
4. **Báo cáo** — tóm tắt: free_model_enabled, số agent bị đổi, bước tiếp theo (restart)

## QUY TẮC

- Luôn gọi script model-policy.ps1 — không tự sửa model thủ công
- Nếu script lỗi → báo lỗi + gợi ý sửa
- Output báo cáo kết quả

## Output Contract

```yaml
status: "OK | FAILED"
mode: "status | apply | enable | disable"
free_model_enabled: false
free_model: "opencode-go/deepseek-v4-flash"
agents_total: 18
changed_json: 18
changed_md: 18
dry_run: false
next_action: "Restart opencode session để config mới có hiệu lực"
```

Xem thêm: `.opencode/model-policy/settings.json`, `.opencode/model-policy/models.default.json`
