# Doctor Report

**Generated:** 2026-08-02 22:23:07
**Mode:** full
**Doctor:** v2.0.0

---

## Health Score

| Category | Score | Status |
|----------|-------|--------|
| Compatibility | 100/100 | PASS |
| RuntimeEngine | 100/100 | PASS |
| Knowledge | 90/100 | PASS |
| Workflow | 100/100 | PASS |
| Commands | 100/100 | PASS |
| Environment | 90/100 | PASS |
| Agents | 100/100 | PASS |
| CapabilityEngine | 85/100 | PASS |
| Benchmark | 83/100 | PASS |
| Runtime | 100/100 | PASS |
| SemanticDiff | 55/100 | WARNING |
| Contracts | 100/100 | PASS |
| Skills | 80/100 | PASS |
| KnowledgeMigrate | 100/100 | PASS |
| Simulation | 100/100 | PASS |
| Migration | 100/100 | PASS |
| Stress | 50/100 | ERROR |
| **OVERALL** | **93/100** | |

## Runtime Health (Simulation Engine)

| Metric | Value |
|--------|-------|
| Runtime Health | 100/100 |
| Verdict | STABLE |


---

## Capability Benchmark

| Metric | Value |
|--------|-------|
| Capability Score | 85/100 |
| Verdict | STRONG |
| Task simulation pass | 100% |

### Domain Capabilities

| Domain | Score | Agents |
|--------|-------|--------|
| Git | 93/100 | 3 |
| Planning | 93/100 | 7 |
| Testing | 91/100 | 5 |
| Security | 90/100 | 4 |
| Blazor | 89/100 | 6 |
| Orchestration | 82/100 | 14 |
| UI/UX | 82/100 | 8 |
| Scripting | 79/100 | 8 |
| Docs | 79/100 | 8 |
| Database | 71/100 | 9 |

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

## Suggested Actions

### HIGH

- knowledge: missing SKILL.md

### MEDIUM

- SemanticDiff score moderate (55/100)
- Stress score moderate (50/100)
- Stress test success rate 40% (verdict UNSTABLE)

### LOW

- Skills minor gaps (80/100)
- Benchmark minor gaps (83/100)
- Knowledge minor gaps (90/100)
- CapabilityEngine minor gaps (85/100)
- Environment minor gaps (90/100)
- OpenCode version not detectable
- No API keys in environment - check OpenCode auth
- approve-test: not registered in opencode.json
- approve-test: no flags/modes documented
- approve-test: no output contract section
- ask: not registered in opencode.json
- ask: no flags/modes documented
- ask: no output contract section
- compare-doc: not registered in opencode.json
- compare-doc: no flags/modes documented
- compare-doc: no output contract section
- doctor-test: not registered in opencode.json
- doctor-test: no flags/modes documented
- doctor-test: no output contract section
- explain: not registered in opencode.json
- explain: no flags/modes documented
- flow: not registered in opencode.json
- flow: no flags/modes documented
- flow: no output contract section
- impact: not registered in opencode.json
- impact: no flags/modes documented
- impact: no output contract section
- knowledge-ask: no flags/modes documented
- knowledge-compare-doc: no flags/modes documented
- knowledge-explain: no flags/modes documented
- knowledge-flow: no flags/modes documented
- knowledge-health: no flags/modes documented
- knowledge-impact: no flags/modes documented
- knowledge-trace: no flags/modes documented
- knowledge-where: no flags/modes documented
- knowledge-why: no flags/modes documented
- knowledge: no flags/modes documented
- team-capabilities: not registered in opencode.json
- team-capabilities: no flags/modes documented
- team-capabilities: no output contract section
- team-runtime-benchmark: not registered in opencode.json
- team-runtime-benchmark: no flags/modes documented
- team: no flags/modes documented
- team: no output contract section
- test-accessibility: not registered in opencode.json
- test-accessibility: no flags/modes documented
- test-accessibility: no output contract section
- test-audit: not registered in opencode.json
- test-audit: no flags/modes documented
- test-audit: no output contract section
- test-bootstrap: not registered in opencode.json
- test-bootstrap: no output contract section
- test-cross-browser: not registered in opencode.json
- test-cross-browser: no output contract section
- test-e2e: not registered in opencode.json
- test-e2e: no output contract section
- test-evolve: not registered in opencode.json
- test-evolve: no flags/modes documented
- test-evolve: no output contract section
- test-plan: not registered in opencode.json
- test-plan: no flags/modes documented
- test-plan: no output contract section
- test-regression: not registered in opencode.json
- test-regression: no flags/modes documented
- test-regression: no output contract section
- test-ui: not registered in opencode.json
- test-ui: no output contract section
- test-visual: not registered in opencode.json
- test-visual: no output contract section
- trace: not registered in opencode.json
- trace: no flags/modes documented
- trace: no output contract section
- where: not registered in opencode.json
- where: no flags/modes documented
- where: no output contract section
- why: not registered in opencode.json
- why: no flags/modes documented
- why: no output contract section
- Missing topic coverage: react, angular, oracle, sql, python, git, dotnet, powerapps
- 2 file(s) reference deprecated frameworks
- Run /doctor --health for evolution-aligned Health Score

---

## Issues

- [WARNING] Environment: OpenCode version not detectable
- [WARNING] Environment: No API keys in environment - check OpenCode auth
- [WARNING] Commands: approve-test: not registered in opencode.json
- [WARNING] Commands: approve-test: no flags/modes documented
- [WARNING] Commands: approve-test: no output contract section
- [WARNING] Commands: ask: not registered in opencode.json
- [WARNING] Commands: ask: no flags/modes documented
- [WARNING] Commands: ask: no output contract section
- [WARNING] Commands: compare-doc: not registered in opencode.json
- [WARNING] Commands: compare-doc: no flags/modes documented
- [WARNING] Commands: compare-doc: no output contract section
- [WARNING] Commands: doctor-test: not registered in opencode.json
- [WARNING] Commands: doctor-test: no flags/modes documented
- [WARNING] Commands: doctor-test: no output contract section
- [WARNING] Commands: explain: not registered in opencode.json
- [WARNING] Commands: explain: no flags/modes documented
- [WARNING] Commands: flow: not registered in opencode.json
- [WARNING] Commands: flow: no flags/modes documented
- [WARNING] Commands: flow: no output contract section
- [WARNING] Commands: impact: not registered in opencode.json
- [WARNING] Commands: impact: no flags/modes documented
- [WARNING] Commands: impact: no output contract section
- [WARNING] Commands: knowledge-ask: no flags/modes documented
- [WARNING] Commands: knowledge-compare-doc: no flags/modes documented
- [WARNING] Commands: knowledge-explain: no flags/modes documented
- [WARNING] Commands: knowledge-flow: no flags/modes documented
- [WARNING] Commands: knowledge-health: no flags/modes documented
- [WARNING] Commands: knowledge-impact: no flags/modes documented
- [WARNING] Commands: knowledge-trace: no flags/modes documented
- [WARNING] Commands: knowledge-where: no flags/modes documented
- [WARNING] Commands: knowledge-why: no flags/modes documented
- [WARNING] Commands: knowledge: no flags/modes documented
- [WARNING] Commands: team-capabilities: not registered in opencode.json
- [WARNING] Commands: team-capabilities: no flags/modes documented
- [WARNING] Commands: team-capabilities: no output contract section
- [WARNING] Commands: team-runtime-benchmark: not registered in opencode.json
- [WARNING] Commands: team-runtime-benchmark: no flags/modes documented
- [WARNING] Commands: team: no flags/modes documented
- [WARNING] Commands: team: no output contract section
- [WARNING] Commands: test-accessibility: not registered in opencode.json
- ... and 37 more

---

> Generated by Doctor v2.0.0 | Run /doctor --full --markdown to refresh
