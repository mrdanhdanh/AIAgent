---
name: architecture-performance
description: PERFORMANCE — KPI hiệu năng của Agent Framework v4. Dùng làm mốc đo lường.
agent: general
---

# PERFORMANCE.md — KPI Hiệu Năng

> Đặt ngưỡng hiệu năng. OBSERVABILITY đo, báo cáo vi phạm ngưỡng.

## 1. Bảng KPI

| Metric | Ngưỡng | Nhóm |
|--------|--------|------|
| Workflow tổng | < 30s | Workflow |
| Single phase | < 15s | Phase |
| Context size | < 8000 token | Context |
| Registry lookup | < 20ms | Registry |
| Simulation run | < 10s | Simulation |
| Artifact checksum | < 5ms | Artifact |
| Event dispatch | < 5ms | Event |
| Agent cold start | < 2s | Agent |
| Doctor health scan | < 10s | Diagnostics |

## 2. Giải thích

- **Workflow < 30s**: toàn bộ chuỗi phase của một workflow thường; workflow dài (13 bước) được phép > ngưỡng nhưng phải log.
- **Context < 8000 token**: trước khi nạp vào model, Context Engine compress nếu vượt (CTX-002).
- **Registry lookup < 20ms**: capability resolve phải nhanh, cache in-memory.
- **Simulation < 10s**: dry-run không được lâu hơn chạy thật.

## 3. Quy tắc

- Vượt ngưỡng → WARN log + metric ghi nhận.
- Vượt 2x ngưỡng liên tục → cảnh báo, đề xuất tối ưu (Phase 8 Diagnostics).
- Ngưỡng đo bằng OBSERVABILITY metric, lưu vào report.

## 4. Tối ưu

- Registry: cache in-memory + hash lookup.
- Context: compression (token summarize) + LRU.
- Artifact: checksum lazy tính, cache theo path.
- Event: queue không blocking.