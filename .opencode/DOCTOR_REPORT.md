# Doctor Report

**Generated:** 2026-08-01 00:56:56
**Mode:** evolve
**Doctor:** v2.0.0

---

## Health Score

| Category | Score | Status |
|----------|-------|--------|
| Agents | 100/100 | PASS |
| CapabilityEngine | 84/100 | PASS |
| Commands | 100/100 | PASS |
| Compatibility | 70/100 | WARNING |
| Contracts | 100/100 | PASS |
| Environment | 90/100 | PASS |
| HealthScore | 76/100 | WARNING |
| Knowledge | 90/100 | PASS |
| KnowledgeMigrate | 70/100 | WARNING |
| Migration | 10/100 | ERROR |
| RuntimeEngine | 88/100 | WARNING |
| SemanticDiff | 55/100 | WARNING |
| Skills | 96/100 | PASS |
| Stress | 50/100 | ERROR |
| Workflow | 100/100 | PASS |
| **OVERALL** | **87/100** | |

## Runtime Health (Simulation Engine)

| Metric | Value |
|--------|-------|
| Runtime Health | 88/100 |
| Verdict | WARNING |

- Review loi SKILL_DEPRECATED_CONTENT (2x)
- Review loi COMMAND_TRIGGER_ROUTING (1x)

---

## Capability Benchmark

| Metric | Value |
|--------|-------|
| Capability Score | 84/100 |
| Verdict | STRONG |
| Task simulation pass | 100% |

### Domain Capabilities

| Domain | Score | Agents |
|--------|-------|--------|
| Git | 93/100 | 3 |
| Planning | 93/100 | 7 |
| Security | 90/100 | 4 |
| Testing | 90/100 | 5 |
| Blazor | 87/100 | 5 |
| UI/UX | 83/100 | 7 |
| Orchestration | 82/100 | 13 |
| Scripting | 76/100 | 9 |
| Docs | 74/100 | 7 |
| Database | 67/100 | 8 |

---

## Stress Test

| Metric | Value |
|--------|-------|
| Tasks | 20 |
| Success rate | 40% |
| Verdict | UNSTABLE |

### Weakest steps

- test: 15% failure (3x)
- analyze: 15% failure (3x)
- static_analysis: 10% failure (2x)
- build: 10% failure (2x)
- skill_validation: 5% failure (1x)
- design: 5% failure (1x)

---

## Evolution Health Score

| Category | Score |
|----------|-------|
| Agents | 15/100 |
| Capability | 84/100 |
| Compatibility | 70/100 |
| Knowledge | 70/100 |
| Learning | 90/100 |
| Runtime | 88/100 |
| Scripts | 84/100 |
| Skills | 85/100 |
| Tests | 100/100 |
| Workflow | 100/100 |
| **Overall** | **76/100** |

- Compatibility score low (70/100) - check contract mismatches

---

## Suggested Actions

### HIGH

- Migration score low (10/100)
- Migration tasks required - run /team-syncdocs --migration

### MEDIUM

- SemanticDiff score moderate (55/100)
- Stress score moderate (50/100)
- KnowledgeMigrate score moderate (70/100)
- Compatibility score moderate (70/100)
- HealthScore score moderate (76/100)
- MISSING_CONTRACT: Agent failure-agent has no contract definition
- MISSING_CONTRACT: Agent learning-agent has no contract definition
- MISSING_CONTRACT: Agent root-cause-agent has no contract definition
- 9 migration task(s), 8 affected agent(s)
- SKILL_DEPRECATED_CONTENT: Skill dev-team chua tu 'deprecated/outdated/legacy' trong noi dung
- SKILL_DEPRECATED_CONTENT: Skill impeccable chua tu 'deprecated/outdated/legacy' trong noi dung
- COMMAND_TRIGGER_ROUTING: Command /impeccable dung opencode.json agent 'ui-beautifier' thay cho frontmatter agent
- Stress test success rate 40% (verdict UNSTABLE)
- Runtime health 88/100 (WARNING)
- Compatibility issues - run /team-syncdocs --compatibility for details

### LOW

- Skills minor gaps (96/100)
- Knowledge minor gaps (90/100)
- RuntimeEngine minor gaps (88/100)
- CapabilityEngine minor gaps (84/100)
- Environment minor gaps (90/100)
- OpenCode version not detectable
- No API keys in environment - check OpenCode auth
- backup: no flags/modes documented
- impeccable: no flags/modes documented
- impeccable: no output contract section
- team-analyze-failure: no flags/modes documented
- team-analyze: no flags/modes documented
- team-analyze: no output contract section
- team-build: no flags/modes documented
- team-build: no output contract section
- team-cleanup: no output contract section
- team-doctor: no flags/modes documented
- team-doctor: no output contract section
- team-explore: no flags/modes documented
- team-explore: no output contract section
- team-gitguard: no flags/modes documented
- team-gitguard: no output contract section
- team-gitpush: no flags/modes documented
- team-gitpush: no output contract section
- team-learn: no flags/modes documented
- team-plan: no flags/modes documented
- team-plan: no output contract section
- team-review: no flags/modes documented
- team-root-cause: no flags/modes documented
- team-selfimprove: no flags/modes documented
- team-test: no flags/modes documented
- team-test: no output contract section
- team-testplan: no flags/modes documented
- team-testplan: no output contract section
- dev-team: contains deprecated/outdated markers
- impeccable: contains deprecated/outdated markers
- Missing topic coverage: react, angular, oracle, sql, python, git, dotnet, powerapps
- 2 file(s) reference deprecated frameworks
- 2 deprecated knowledge file(s)
- Runtime suggestion: Review loi SKILL_DEPRECATED_CONTENT (2x)
- Runtime suggestion: Review loi COMMAND_TRIGGER_ROUTING (1x)

---

## Issues

- [WARNING] Environment: OpenCode version not detectable
- [WARNING] Environment: No API keys in environment - check OpenCode auth
- [WARNING] Commands: backup: no flags/modes documented
- [WARNING] Commands: impeccable: no flags/modes documented
- [WARNING] Commands: impeccable: no output contract section
- [WARNING] Commands: team-analyze-failure: no flags/modes documented
- [WARNING] Commands: team-analyze: no flags/modes documented
- [WARNING] Commands: team-analyze: no output contract section
- [WARNING] Commands: team-build: no flags/modes documented
- [WARNING] Commands: team-build: no output contract section
- [WARNING] Commands: team-cleanup: no output contract section
- [WARNING] Commands: team-doctor: no flags/modes documented
- [WARNING] Commands: team-doctor: no output contract section
- [WARNING] Commands: team-explore: no flags/modes documented
- [WARNING] Commands: team-explore: no output contract section
- [WARNING] Commands: team-gitguard: no flags/modes documented
- [WARNING] Commands: team-gitguard: no output contract section
- [WARNING] Commands: team-gitpush: no flags/modes documented
- [WARNING] Commands: team-gitpush: no output contract section
- [WARNING] Commands: team-learn: no flags/modes documented
- [WARNING] Commands: team-plan: no flags/modes documented
- [WARNING] Commands: team-plan: no output contract section
- [WARNING] Commands: team-review: no flags/modes documented
- [WARNING] Commands: team-root-cause: no flags/modes documented
- [WARNING] Commands: team-selfimprove: no flags/modes documented
- [WARNING] Commands: team-test: no flags/modes documented
- [WARNING] Commands: team-test: no output contract section
- [WARNING] Commands: team-testplan: no flags/modes documented
- [WARNING] Commands: team-testplan: no output contract section
- [WARNING] Skills: dev-team: contains deprecated/outdated markers
- [WARNING] Skills: impeccable: contains deprecated/outdated markers
- [WARNING] Knowledge: Missing topic coverage: react, angular, oracle, sql, python, git, dotnet, powerapps
- [WARNING] Knowledge: 2 file(s) reference deprecated frameworks
- [MAJOR] Compatibility: MISSING_CONTRACT: Agent failure-agent has no contract definition
- [MAJOR] Compatibility: MISSING_CONTRACT: Agent learning-agent has no contract definition
- [MAJOR] Compatibility: MISSING_CONTRACT: Agent root-cause-agent has no contract definition
- [MAJOR] Migration: 9 migration task(s), 8 affected agent(s)
- [WARNING] KnowledgeMigrate: 2 deprecated knowledge file(s)
- [MAJOR] RuntimeEngine: SKILL_DEPRECATED_CONTENT: Skill dev-team chua tu 'deprecated/outdated/legacy' trong noi dung
- [MAJOR] RuntimeEngine: SKILL_DEPRECATED_CONTENT: Skill impeccable chua tu 'deprecated/outdated/legacy' trong noi dung
- ... and 2 more

---

> Generated by Doctor v2.0.0 | Run /doctor --full --markdown to refresh
