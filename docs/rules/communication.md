---
name: rule-communication
description: R-COMM — Luật giao tiếp. Qua Contract + Runtime, không gọi trực tiếp.
agent: general
---

# R-COMM — Communication

## Rule

Mọi giao tiếp giữa các thành phần **bắt buộc** qua Contract (P002) và Runtime (P001).

## Bắt buộc

- Không gọi Agent trực tiếp từ Agent khác — mọi điều phối qua Runtime.
- Mọi interface khai báo input/output contract, versioned.
- Không truyền dữ liệu tùy ý ngoài contract.
- 4 hình thức: Sync / Async / Event / Query — chọn đúng hình thức theo nhu cầu.

| Hình thức | Khi nào |
|-----------|---------|
| Sync | cần kết quả ngay |
| Async | xử lý lâu |
| Event | state change |
| Query | read model |

## Kiểm tra

- Contract schema validate ở biên giới module.
- Doctor kiểm tra agent/agent gọi trực tiếp → vi phạm.

**Nguồn**: A-004 · P001 · P002