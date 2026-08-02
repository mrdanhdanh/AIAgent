# Appendix E — Error Catalog
Thuộc SPEC-000 Constitution. Danh mục mã lỗi chuẩn.

## Nhóm lỗi
| Mã nhóm | Phạm vi | Ví dụ |
|---------|---------|-------|
| CXT | Context | CXT-002 missing required |
| AG | Agent | AG-002 capability not found |
| EVT | Event | EVT-003 contract mismatch |
| ART | Artifact | ART-003 checksum fail |
| REG | Registry | REG-002 duplicate |
| SIM | Simulation | SIM-003 no agent |
| DOC | Doctor | DOC-004 rule fail |
| EVO | Evolution | EVO-004 simulation missing |
| PLG | Plugin | PLG-001 schema fail |
| TST | Trust | TST-004 sensitive data |
| GOV | Governance | GOV-001 naming fail |

## Phân loại (Chương 23)
| Loại | Hành vi |
|-------|---------|
| Recoverable | tiếp tục |
| Retryable | retry backoff |
| Fatal | fail fast + rollback |
| Ignored | log + continue |

Mọi lỗi: mã + message + context + severity (P012/Ch23).