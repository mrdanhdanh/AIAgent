---
lesson_id: LSN-PS-001
failure_id: BUG-0003
error_hash: "args_param_shadowing"
error_type: "AutomaticVariableShadowing"
rule: "KHÔNG dùng tên automatic variable của PowerShell (Args, Error, Host, HOME, PID, PWD, PSItem, etc.) làm tên tham số/biến. PowerShell không báo lỗi — param âm thầm không binding, splatting trở thành rỗng → command chạy sai (VD: `& python` mở REPL treo vô hạn)."
applies_to: [".opencode/scripts", "powershell-scripts", "doctor"]
tags: ["powershell", "scripting", "variable-shadowing", "doctor"]
severity: HIGH
created_at: "2026-08-01T00:25:00Z"
---
