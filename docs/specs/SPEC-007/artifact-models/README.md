---
name: spec-007-artifact-models
description: SPEC-007 Appendix - Artifact Canonical Models. 8 AM, Aggregate Root = Artifact.
agent: general
---

# Appendix - Artifact Canonical Models

> **SPEC-007**: Artifact Manager - **Version**: 1.0.0

## Models (8)

| AM | Name | Kind | Owner | Immutable |
|----|------|------|-------|-----------|
| AM-001 | Artifact | AggregateRoot | Artifact Store | - |
| AM-002 | ArtifactDefinition | Entity | Artifact Store | yes |
| AM-003 | ArtifactVersion | Entity | Artifact Store | yes |
| AM-004 | ArtifactMetadata | Entity | Artifact Store | yes |
| AM-005 | ArtifactChecksum | Value | Artifact Store | yes |
| AM-006 | ArtifactState | Transient | Artifact Store | - |
| AM-007 | ArtifactReference | Value | Artifact Store | yes |
| AM-008 | ArtifactResult | Entity | Artifact Store | yes |

`aggregate_root: AM-001 Artifact`

## Relationships

```text
Artifact (AM-001)
  +- ArtifactDefinition (AM-002)
  +- ArtifactVersion (AM-003)
  +- ArtifactMetadata (AM-004)
  +- ArtifactChecksum (AM-005)
  +- ArtifactState (AM-006)
  +- ArtifactReference (AM-007)
  +- ArtifactResult (AM-008)
```

## Validation

- Model co schema (artifact-models.schema.json).
- Immutable model khong doi (P010).
- Aggregate Root doc nhat: Artifact.

## Tham chieu

- S008 ENT-008 - SPEC-001
- P010 Immutable Artifact
