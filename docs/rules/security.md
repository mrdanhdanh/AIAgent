---
name: rule-security
description: R-SEC — Luật bảo mật. Least privilege, kiểm tra quyền trước khi thực thi.
agent: general
---

# R-SEC — Security

## Rule

Mọi hành động chạy với **quyền tối thiểu** (P014).

## Bắt buộc

- Kiểm tra quyền trước khi thực thi — không sau.
- Agent/Plugin không được truy cập tài nguyên ngoài scope khai báo.
- Plugin chạy trong sandbox với permission khai báo trong manifest.
- Không log secret, key, credential.
- Input luôn được validate theo contract (P002).
- Mọi quyền thay đổi phát Event (P004) để audit.

## Kiểm tra

- Doctor kiểm tra plugin quá quyền.
- Cross-ref scan secret trong code/docs.
- Deny by default, allow theo khai báo.

**Nguồn**: P002 · P004 · P010 · P014 · A-005