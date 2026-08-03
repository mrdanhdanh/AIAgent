# Appendix F — Event Catalog
Thuộc SPEC-000 Constitution. Danh mục event chuẩn.

## Workflow
| Event | Nghĩa |
|-------|-------|
| WORKFLOW_CREATED | tạo |
| WORKFLOW_STARTED | bắt đầu |
| WORKFLOW_COMPLETED | hoàn thành |
| WORKFLOW_FAILED | lỗi |

## Phase
| Event | Nghĩa |
|-------|-------|
| PHASE_STARTED | bắt đầu phase |
| PHASE_COMPLETED | xong phase |
| PHASE_SKIPPED | bỏ qua |
| PHASE_FAILED | lỗi phase |

## Agent
| Event | Nghĩa |
|-------|-------|
| AGENT_STARTED | agent chạy |
| AGENT_COMPLETED | agent xong |
| AGENT_FAILED | agent lỗi |
| AGENT_RETRYING | retry |

## Artifact
| Event | Nghĩa |
|-------|-------|
| ARTIFACT_CREATED | tạo |
| ARTIFACT_UPDATED | version mới |
| ARTIFACT_ARCHIVED | lưu trữ |

## Context
| Event | Nghĩa |
|-------|-------|
| CONTEXT_CREATED | tạo context |
| CONTEXT_DELIVERED | giao cho agent |

Event base: id, type, timestamp, source, payload, parent_event (P005).