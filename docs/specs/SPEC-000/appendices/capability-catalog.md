# Appendix G — Capability Catalog
Thuộc SPEC-000 Constitution. Danh mục capability chuẩn.

## Categories
| Category | Ví dụ |
|----------|-------|
| analysis | analysis.requirement, analysis.codebase |
| architecture | architecture.design, architecture.impact |
| planning | planning.task, planning.test |
| implementation | implementation.code, implementation.fix |
| review | review.code, review.security |
| testing | testing.unit, testing.e2e |
| knowledge | knowledge.learn, knowledge.retrieve |
| memory | memory.record |
| deployment | deployment.git, deployment.backup |
| ui | ui.design, ui.audit |
| security | security.audit |
| orchestration | orchestration.orchestrate |

## Format
```
id: <category>.<specific>   (implementation.code)
```

Workflow gọi capability (P008), không gọi agent. Resolver chọn agent phù hợp.