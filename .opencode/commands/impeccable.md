---
description: "Design, redesign, shape, critique, audit, polish, or improve frontend UI. Sub-commands: init, shape, document, critique, audit, polish, bolder, quieter, distill, harden, onboard, animate, colorize, typeset, layout, delight, overdrive, clarify, adapt, optimize, live, hooks, doctor, extract."
---

Bạn đang thực thi lệnh `/impeccable` với tham số: $ARGUMENTS

Đây là skill thiết kế UI/UX cao cấp. Đọc toàn bộ hướng dẫn tại: `.opencode/skills/impeccable/SKILL.md`

## Routing

1. Nếu không có tham số: load `.opencode/skills/impeccable/reference/routing.md` và present context-aware menu
2. Nếu tham số là `init`: load `.opencode/skills/impeccable/reference/init.md` và execute init flow
3. Nếu tham số là sub-command khác (`shape`, `document`, `critique`, `audit`, `polish`, `bolder`, `quieter`, `distill`, `harden`, `onboard`, `animate`, `colorize`, `typeset`, `layout`, `delight`, `overdrive`, `clarify`, `adapt`, `optimize`, `live`, `hooks`, `doctor`, `extract`): load reference tương ứng tại `.opencode/skills/impeccable/reference/<subcommand>.md` và follow nó
4. Khác: treat as general design work, load SKILL.md và reference tương ứng

## Bước đầu tiên

Chạy `node .opencode/skills/impeccable/scripts/context.mjs` với `--target` nếu có target path.
