---
description: 'Đồng bộ toàn bộ system docs: quét agents, commands, skills, scripts, knowledge → cập nhật SYSTEM_MAP.md, cross-references, fix lỗi. Chạy định kỳ khi thêm/sửa/xóa file hệ thống.'
agent: general
---

## HELP — Hướng dẫn sử dụng `/team-syncdocs`

**Mục đích:** Quét và đồng bộ toàn bộ tài liệu hệ thống `.opencode/` — cập nhật sơ đồ tổng thể (SYSTEM_MAP.md), cross-references, phát hiện agent/command bị orphan hoặc thiếu.

**Khi nào chạy:**
- Sau khi thêm agent mới
- Sau khi thêm/xóa command mới
- Sau khi thêm skill mới
- Trước khi giới thiệu người mới vào dự án
- Định kỳ để đảm bảo hệ thống đồng bộ

**Cách dùng:** `/team-syncdocs [--dry-run] [--force]`

**Flags:**
- `--dry-run` — Chỉ xem trước những gì sẽ thay đổi, không ghi file
- `--force` — Ghi đè mà không cần xác nhận

**Đầu ra:** 
- `SYSTEM_MAP.md` — Sơ đồ tổng thể toàn bộ hệ thống
- Cập nhật bảng cross-reference trong `team.md` và `SKILL.md`
- Báo cáo phát hiện vấn đề (orphan agents, missing files)

**Vị trí trong workflow:** Chạy standalone, không thuộc dev-team workflow.

---

Bạn đang vận hành **System Documentation Sync** — quét và đồng bộ toàn bộ cấu trúc `.opencode/`.

## MỤC ĐÍCH

Lập bản đồ toàn bộ hệ thống `.opencode/` để người mới dễ hiểu, và đảm bảo mọi cross-reference giữa các file đều chính xác.

## CÁC FILE SẼ TÁC ĐỘNG

| File | Hành động | Mô tả |
|------|-----------|-------|
| `.opencode/SYSTEM_MAP.md` | Tạo/Cập nhật | Sơ đồ tổng thể: agents, commands, skills, scripts, knowledge, cross-refs |
| `.opencode/commands/team.md` | Cập nhật | Bảng command → agent mapping (TÍCH HỢP VỚI COMMANDS RIÊNG LẺ) |
| `.opencode/skills/dev-team/SKILL.md` | Cập nhật | Bảng command integration (TÍCH HỢP VỚI COMMANDS RIÊNG LẺ) |

## QUY TRÌNH

### Bước 1: Scan Agents
- Đọc tất cả file `.opencode/agents/*.md`
- Parse YAML frontmatter → lấy: name, description, mode, model, permissions
- Ghi nhận agent nào không được command nào tham chiếu (orphan)

### Bước 2: Scan Commands
- Đọc tất cả file `.opencode/commands/*.md`
- Parse YAML frontmatter → lấy: name, description, agent mapping, deprecated flag
- Phát hiện command tham chiếu agent không tồn tại

### Bước 3: Scan Skills
- Đọc tất cả file `.opencode/skills/*/SKILL.md`
- Parse YAML frontmatter → lấy: name, description, schema_version
- Map skills với commands dựa trên nội dung tham chiếu

### Bước 4: Scan Scripts
- Đọc tất cả file `.opencode/scripts/*.ps1`
- Lấy synopsis + file size

### Bước 5: Scan Knowledge
- Liệt kê tất cả file trong `.opencode/knowledge/`

### Bước 6: Cross-Reference Analysis
- Build ma trận: Command → Agent, Agent → Commands, Skill → Commands
- Phát hiện: orphan agents, missing agent references, deprecated commands

### Bước 7: Generate SYSTEM_MAP.md
- Ghi file `.opencode/SYSTEM_MAP.md` với đầy đủ:
  - Cấu trúc thư mục
  - Bảng agents (kèm permissions, commands)
  - Bảng commands (kèm agent, deprecated flag)
  - Bảng skills
  - Bảng scripts
  - Knowledge base file list
  - Ma trận cross-reference (Command→Agent, Agent→Commands, Skill→Commands)
  - Workflow diagram
  - Phát hiện vấn đề

### Bước 8: Update Cross-References
- Cập nhật bảng "TÍCH HỢP VỚI COMMANDS RIÊNG LẺ" trong `team.md`
- Cập nhật bảng tương tự trong `dev-team/SKILL.md`

### Bước 9: Report
- Output báo cáo tổng kết:
  ```
  ╔══════════════════════════════════════════╗
  ║       SYSTEM DOCS SYNC REPORT            ║
  ╠══════════════════════════════════════════╣
  ║ Agents scanned:  X                       ║
  ║ Commands scanned: X                      ║
  ║ Skills scanned:   X                      ║
  ║ Scripts scanned:  X                      ║
  ║ Knowledge files:  X                      ║
  ║──────────────────────────────────────────║
  ║ Issues found:     X                      ║
  ║   • Orphan agents: X                     ║
  ║   • Missing refs:  X                     ║
  ║──────────────────────────────────────────║
  ║ SYSTEM_MAP.md:    ✅ Updated             ║
  ║ team.md:          ✅ Updated             ║
  ║ SKILL.md:         ✅ Updated             ║
  ╚══════════════════════════════════════════╝
  ```

## SCRIPT

Script thực thi: `.opencode\scripts\sync-system-docs.ps1`

```powershell
# Dry run (xem trước)
& ".opencode\scripts\sync-system-docs.ps1" -dryRun

# Thực thi
& ".opencode\scripts\sync-system-docs.ps1" [-force]
```

## OUTPUT CONTRACT

```yaml
status: SUCCESS | PARTIAL | FAILED
summary: "Đã quét X agents, Y commands, Z skills. Cập nhật SYSTEM_MAP.md, team.md, SKILL.md"
files_updated:
  - ".opencode/SYSTEM_MAP.md"
  - ".opencode/commands/team.md"
  - ".opencode/skills/dev-team/SKILL.md"
issues:
  - type: ORPHAN_AGENT | MISSING_AGENT | UPDATE_FAILED
    detail: "Mô tả vấn đề"
    severity: WARNING | ERROR
stats:
  agents: 12
  commands: 13
  skills: 4
  scripts: 3
  knowledge: X
details: "Chi tiết nếu FAILED"
```

## QUY TẮC

- Không xóa file — chỉ tạo/cập nhật
- Nếu SYSTEM_MAP.md chưa tồn tại → tạo mới
- Nếu không tìm thấy bảng cross-ref trong team.md/SKILL.md → báo lỗi, không phá hỏng file
- --dry-run: chỉ scan và hiển thị, không ghi file
- Phát hiện orphan agent (agent không command nào dùng) → WARNING
- Phát hiện command tham chiếu agent không tồn tại → ERROR
