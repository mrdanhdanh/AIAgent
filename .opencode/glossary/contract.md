---
name: glossary-contract
description: Thuật ngữ Contract — hợp đồng giao tiếp.
agent: general
---

# Term: Contract

**Definition**: A versioned agreement defining input and output of an interface.

**Owns**:
- direction (input/output)
- fields (name, type, required)
- version

**Does not own**:
- Implementation
- State

**Quan hệ**:
- Mọi giao tiếp qua contract (P002).
- Contract versioned + backward compatible (P015).
- Agent tuân theo input/output contract.

**Ví dụ**: `planning-output`, `build-input`.

**Tham chiếu**: P002, P009, P015.