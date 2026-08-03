# Appendix B — Object Catalog
Thuộc SPEC-000 Constitution. Danh mục object chuẩn AIOS.

| Object | Base fields | Ghi chú |
|--------|-------------|---------|
| Workflow | id, version, status, phases, metadata | chuỗi phase |
| Phase | id, name, capability, depends_on | bước workflow |
| Task | id, phase, goal, inputs, outputs | đơn vị công việc |
| Capability | id, name, category, version | khả năng |
| Agent | id, name, version, supports, behavior | stateless |
| Artifact | id, type, version, checksum, lineage | immutable |
| Event | id, type, timestamp, source, parent | immutable |
| Contract | id, direction, fields | giao tiếp |
| Context | agent_id, budget, package | cấp cho agent |
| Plugin | id, name, version, exports, permissions | gói mở rộng |

Mọi object kế thừa base: `id · type · version · status · metadata` (P003).