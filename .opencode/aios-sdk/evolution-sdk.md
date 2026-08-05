---
name: sdk-evolution
description: Evolution SDK — proposals, backtest, apply.
agent: general
---

# Evolution SDK

## 1. Vai trò

Giao diện Self Evolution Engine.

## 2. API

| Method | Mô tả |
|--------|-------|
| `Evolution.Propose(proposal)` | tạo proposal |
| `Evolution.ListProposals(filter)` | danh sách |
| `Evolution.Backtest(proposalId)` | backtest |
| `Evolution.Approve(proposalId, decision)` | approve/reject |
| `Evolution.Apply(proposalId)` | áp dụng |
| `Evolution.GetHistory()` | lịch sử |

## 3. DTO

```yaml
EvolutionProposal:
  id, category, title, status, risk, confidence, migration
```

## 4. Permission

- Propose/List: `evolution.*` (read).
- Backtest: `simulation.run`.
- Approve/Apply: `evolution.write` (administrator).

## 5. Tương tác

- `evolution/` (Phase 10).
- Dashboard Evolution Center dùng evolution-sdk.