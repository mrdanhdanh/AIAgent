---
name: git
description: >
  Git workflow và conventions cho AIOS dev — branches, commit style, push rules.
  Áp dụng khi commit/push/review thay đổi trên repo AgentAI.
tags: [git, github, commit, branch, push]
---

# Git

## Repo conventions

- Remote: `https://github.com/mrdanhdanh/AIAgent.git`.
- Active dev trên nhánh tính năng (vd `NewVersion`) — KHÔNG push thẳng `master` trừ khi release.
- Deploy GitHub Pages chạy khi push `master` (workflow `.github/workflows/deploy.yml`).

## Commit style

- Message tiếng Anh, prefix theo type: `feat(...)`, `fix(...)`, `docs(...)`, `test(...)`.
- Body ghi chi tiết theo nhóm đã làm (vd `(1) ... (2) ... (3) ...`).
- Trước commit: kiểm tra `git status`, `git diff`, `git log --oneline -10` — chỉ stage file có chủ đích.

## Trước khi push

- Chạy `/team-gitguard` — review secrets, convention, security, build, test.
- Verdict: `PASS` → push; `BLOCKED` (CRITICAL) → không push.

## Bài học đã ghi nhận

- Windows FS case-insensitive: rename file đổi case phải qua tên tạm (`zzz-`) — verify bằng `git ls-files`.
- PowerShell `-replace` không phân biệt hoa/thường — kiểm tra prefix sau transform (sdk-sdk, cli-cli).
- E2E browser path hardcode `PlaywrightFixture.cs:24` — sẽ fail trên máy khác.
