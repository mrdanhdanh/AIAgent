---
name: architecture-security
description: SECURITY — bảo mật Agent Framework v4: permission, sandbox, approval, dangerous command, trusted script.
agent: general
---

# SECURITY.md — Bảo mật

> Bảo mật là nguyên tắc xuyên suốt. Mã lỗi liên quan: SEC-001..003.

## 1. Các chủ thể

| Chủ thể | Mô tả |
|---------|-------|
| User | con người điều khiển |
| Agent | thực thi capability |
| Command | lối vào hệ thống |
| Script | code chạy trong shell |
| Workflow | chuỗi thao tác |

## 2. Permission

| Mức | Mô tả | Ví dụ |
|-----|-------|-------|
| ReadOnly | chỉ đọc, không ghi | doctor, ask, knowledge query |
| Scoped | ghi trong phạm vi được phép | thư mục workflow, artifact |
| Full | quyền tối đa | user quyết |

- Mỗi command khai báo mức quyền trong frontmatter.
- Agent không được vượt quyền command gọi nó.

## 3. Sandbox

- Script không tin cậy chạy trong môi trường cách ly (`$env:TEMP` smoke-test, dry-run trước).
- Không cho script chạm ngoài phạm vi khai báo.
- Workflow simulation chạy sandbox, không đụng file thật.

## 4. Approval Gate

- Hành động nguy hiểm → bắt buộc xác nhận user.
- Nhóm hành động: `--force`, xóa file, git push, rollback, thay đổi registry/schema.
- Quy tắc: không tự ý thực thi khi mức rủi ro HIGH mà chưa có approval.

## 5. Dangerous Command

- Danh sách chặn mặc định: `rm -rf`, xóa registry, force-push, sửa baseline thủ công.
- Gặp → SEC-002, chặn và báo user.
- Muốn cho phép → khai báo rõ trong workflow + approval.

## 6. Trusted Script

- Script trong `.opencode/scripts/` được review (GitGuard) trước khi dùng.
- Script lạ (ngoài thư mục) → chặn hoặc xác nhận.
- Mọi script phải có ASCII-only source (PS 5.1 ANSI) và chạy `-WhatIf`/dry-run khi có flag.

## 7. Quy tắc GitGuard (kế thừa)

- Trước push: secrets scan, convention check, security scan, build/test.
- CRITICAL → BLOCKED. Chi tiết `.opencode/skills/gitguard/SKILL.md`.

## 8. Không làm

- Không commit secret/token/password.
- Không chạy script chưa review.
- Không cho agent tự do chạy shell không qua sandbox.