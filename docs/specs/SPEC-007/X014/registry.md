---
name: spec-007-x014-registry
description: SPEC-007 X014 - Artifact Registry. Dang ky Artifact definition qua SPEC-005.
agent: general
---

# X014 - Artifact Registry

> **SPEC-007**: Artifact Manager - **Version**: 1.0.0 - **Trang thai**: Draft

## Cau hoi duy nhat

> **Artifact definition dang ky va resolve nhu the nao?**

## XR001 - Philosophy

- Artifact KHONG co registry rieng - dung Registry chung (SPEC-005).
- Registry luu DEFINITION, khong luu runtime content (o Store).
- Registry resolve, Runtime thuc thi (RB004).
- Artifact definition la Entry cua Registry (SPEC-005).

## XR002 - Entry Types (4)

1. **ArtifactDefinition** - dac ta Artifact (schema, metadata).
2. **ArtifactSchema** - artifact.schema.json.
3. **ArtifactPolicy** - XPOL-* (S012).
4. **ArtifactStateMachine** - X009 (XSTM-001).

## XR003 - Registry Flow

```text
Declare (SPEC-007 doc) -> Validate (R009) -> Publish (SPEC-005)
  -> Resolve (SPEC-005) -> Runtime thuc thi (S010)
```

## XR004 - Resolution

- Artifact Manager goi Registry resolve Entry truoc khi thuc thi.
- Khong resolve duoc -> BLOCK (khong auto-fix).
- Resolution co trace + event (S011).

## XR005 - KHONG nam trong Registry

- Runtime Artifact content (Store, checksum-addressed).
- ArtifactVersion (runtime object).
- Artifact Event (S011 Event Store).

## Tham chieu

- SPEC-005 Registry
- RB004 - Registry resolve, Runtime thuc thi
- X009 State Machine - SPEC-007
