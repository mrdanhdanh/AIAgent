---
name: gitpush
description: Pre-push safety validation + git push execution — kiểm tra secret, convention, build, test, sau đó push lên remote với xác nhận từ user. Sử dụng câu lệnh /team-gitpush.
schema_version: "1.0"
---

# GitPush — Safe Git Push Skill

Skill chuyên thực hiện git push an toàn: kiểm tra source code trước khi push, xác nhận với user, push lên remote, xác nhận thành công.

## MỤC LỤC

- [TỔNG QUAN](#tổng-quan)
- [ARCHITECTURE](#architecture)
- [QUY TRÌNH GITPUSH](#quy-trình-gitpush)
- [7 KÊNH KIỂM TRA AN TOÀN](#7-kênh-kiểm-tra-an-toàn)
- [ĐỊNH DẠNG ĐẦU RA](#định-dạng-đầu-ra)
- [SƠ ĐỒ QUYẾT ĐỊNH](#sơ-đồ-quyết-định)
- [TÍCH HỢP VỚI DEV TEAM WORKFLOW](#tích-hợp-với-dev-team-workflow)
- [XỬ LÝ NGOẠI LỆ](#xử-lý-ngoại-lệ)

---

## TỔNG QUAN

GitPush là skill thực hiện toàn bộ quy trình push code lên git remote một cách an toàn. Khác với `team-gitguard` (chỉ review, read-only), GitPush thực hiện:

1. **Auto-commit** — tự động tạo commit message từ phân tích diff (hoặc dùng message do user cung cấp)
2. **Pre-push safety checks** — secret scan, convention, security, code quality
3. **Build validation** — code compile được không
4. **Test validation** — test có pass không
5. **Git status analysis** — branch, remote, commits, ahead/behind
6. **Diff summary** — file nào thay đổi, thêm/dòng/xóa
7. **Confirmation gate** — hỏi user trước khi push
8. **Push execution** — git push lên remote
9. **Post-push verification** — confirm thành công

### Khi nào dùng GitPush?

- **Khi cần push code lên remote** — thay thế `git push` thủ công
- **Khi muốn đảm bảo code an toàn trước khi push** — tích hợp GitGuard checks
- **Khi cần kiểm tra build/test trước push** — tránh push code hỏng
- **Khi push lên branch shared** — cần cảnh báo nếu force push

### Agent

| Vai trò | Agent | File |
|---------|-------|------|
| Pusher (thực thi push) | `pusher` | `.opencode/agents/pusher.md` |

### Command

| Command | Mô tả |
|---------|-------|
| `/team-gitpush` | Chạy toàn bộ quy trình gitpush với safety checks |
| `/team-gitpush --skip-checks` | Bỏ qua safety checks, chỉ push |
| `/team-gitpush --force` | Force push (cảnh báo kỹ) |
| `/team-gitpush --branch <name>` | Push lên branch cụ thể |
| `/team-gitpush --cur` | Chỉ stage file có unstaged changes (`git add -u`), bỏ qua untracked files |
| `/team-gitpush --message "<msg>"` | Dùng message này thay vì auto-generate |
| `/team-gitpush --no-commit` | Bỏ qua auto-commit, chỉ push commit đã có |

---

## ARCHITECTURE

```
User request (/team-gitpush)
        │
        ▼
┌───────────────────────┐
│   Pusher Agent        │
│   (pusher.md)         │
└──────────┬────────────┘
           │
           ├── 0. Auto-commit
           │      ├── Phân tích diff (git diff --stat)
           │      ├── Xác định type/scope/summary
           │      ├── Tạo commit message tự động
           │      ├── git add -A && git commit
           │      └── (hoặc dùng --message / --no-commit)
           │
           ├── 1. Git status analysis
           │      └── git status, branch, remote, ahead/behind
           │
           ├── 2. Safety checks (GitGuard integration)
           │      ├── Secrets scan
           │      ├── Convention check
           │      ├── Security scan
           │      └── Code quality check
           │
           ├── 3. Build validation
           │      └── dotnet build
           │
           ├── 4. Test validation (optional)
           │      └── dotnet test
           │
           ├── 5. Diff summary
           │      └── git diff --stat + commit message preview
           │
           ├── 6. Confirmation gate
           │      └── Hiển thị summary + commit message → user confirm Y/N
           │
           ├── 7. Push execution
           │      └── git push origin <branch>
           │
           └── 8. Post-push verification
                  └── Verify remote ref + log
```

---

## QUY TRÌNH GITPUSH

### Bước 0: Auto-commit

Mặc định: tự động stage tất cả thay đổi và tạo commit message từ phân tích diff.

**Cách auto-generate commit message:**

1. **Phân tích diff** — `git diff --stat` và `git diff --cached` để xác định:
   - Các file thay đổi (đuôi mở rộng, tên file)
   - Nội dung thay đổi (thêm function, sửa logic, xóa code)
   - Scope (component, service, test, config, ...)

2. **Xác định type** dựa trên nội dung diff:

   | Pattern | Type |
   |---------|------|
   | Thêm class/interface/component mới | `feat` |
   | Sửa logic, fix bug | `fix` |
   | Sửa tên biến, refactor code | `refactor` |
   | Thêm/xóa comment, doc | `docs` |
   | Thêm/xóa test | `test` |
   | Sửa CSS/style/giao diện | `style` |
   | Sửa config, build, CI | `chore` |
   | Sửa performance | `perf` |

3. **Xác định scope** từ tên file:
   - `Pages/*.razor` → scope là tên page
   - `Services/*.cs` → scope là tên service
   - `.opencode/**/*` → scope là `opencode`

4. **Tạo summary** (≤ 72 ký tự):
   - 1 file: `"{verb} {FileName}"`
   - 2-3 file: `"{verb} {FileA}, {FileB}"`
   - Nhiều file: `"{verb} {n} files in {scope}"`

5. **Output**:
   ```
   {type}({scope}): {summary}

   - {file1}: {change description}
   - {file2}: {change description}
   ```

**Các flag liên quan:**
- `--message "<msg>"`: dùng message này thay vì auto-generate
- `--no-commit`: bỏ qua auto-commit, chỉ push commit đã có

### Bước 1: Git status analysis

Chạy các lệnh để hiểu trạng thái hiện tại:

```powershell
git status --short
git branch --show-current
git remote -v
git log --oneline -5
git rev-list --left-right --count origin/<branch>...<branch>
```

Output:
```yaml
git_status:
  branch: "main"
  remote: "origin"
  remote_url: "https://github.com/user/repo.git"
  ahead: 3
  behind: 0
  staged: 5
  unstaged: 2
  untracked: 1
  last_commit: "abc1234 - Commit message"
  has_commits_to_push: true
```

### Bước 2: Safety checks

Thực hiện các kiểm tra an toàn tương tự GitGuard. Nếu `--skip-checks` thì bỏ qua.

### Bước 3: Build validation

```powershell
dotnet build JapaneseLearner\JapaneseLearner.csproj
```

Nếu build FAIL → BLOCKED (không push được).

### Bước 4: Test validation

```powershell
dotnet test JapaneseLearner.Tests\JapaneseLearner.Tests.csproj --no-build
```

Nếu test FAIL → WARNING (hỏi user có muốn push tiếp không).

### Bước 5: Diff summary

```powershell
git diff --stat origin/<branch>...<branch>
git diff --stat --cached
```

Hiển thị commit message đã tạo (nếu auto-commit).

### Bước 6: Confirmation gate

Hiển thị bảng tổng kết cho user (bao gồm commit message):

```
╔══════════════════════════════════════════╗
║         GIT PUSH CONFIRMATION            ║
╠══════════════════════════════════════════╣
║ Repository: JapaneseLearner              ║
║ Branch:     main                         ║
║ Commit:     feat(char): Add new feature  ║
║ Remote:     origin (github.com)          ║
║ Commits:    1 ahead, 0 behind            ║
║ Files:      5 changed (+120/-30)         ║
║ Build:      ✅ PASS                      ║
║ Tests:      ✅ PASS (42/42)              ║
║ Safety:     ✅ PASS                      ║
╠══════════════════════════════════════════╣
║ Push to origin/main? (Y/N):              ║
╚══════════════════════════════════════════╝
```

User nhập Y để push, N để hủy.

### Bước 7: Push execution

```powershell
git push origin <branch>
```

Nếu `--force`: `git push --force-with-lease origin <branch>`

### Bước 8: Post-push verification

```powershell
git log --oneline origin/<branch> -1
```

Xác nhận commit cuối trên remote khớp với local.

---

## 7 KÊNH KIỂM TRA AN TOÀN

| # | Kênh | Mô tả | Severity | Hành động nếu lỗi |
|---|------|-------|----------|-------------------|
| 1 | **Secrets scan** | API keys, tokens, passwords, private keys, .env | CRITICAL | BLOCKED — không push |
| 2 | **Convention check** | FluentUI, DI, cache-first, tri-state, style | MAJOR | WARNING — hỏi user |
| 3 | **Security scan** | XSS, SQL injection, unsafe deserialization | CRITICAL | BLOCKED — không push |
| 4 | **Code quality** | Magic values, dead code, empty catch, deep nesting | MAJOR/MINOR | WARNING — hỏi user |
| 5 | **Build** | dotnet build | CRITICAL | BLOCKED — không push |
| 6 | **Test** | dotnet test | MAJOR | WARNING — hỏi user |
| 7 | **Git safety** | Force push, push to protected branch, merge conflicts | CRITICAL/MAJOR | Cảnh báo đặc biệt |

### Git safety checks

```yaml
git_safety:
  is_force_push: false                           # --force flag?
  is_protected_branch: false                     # main/master?
  has_diverged: false                            # remote ahead of local?
  has_uncommitted: false                         # có uncommitted changes?
  has_untracked: false                           # có untracked files?
  warnings:
    - "Bạn sắp force push lên branch 'main' — hành động nguy hiểm!"
    - "Remote branch có 2 commit mà local không có — cần pull trước"
```

---

## ĐỊNH DẠNG ĐẦU RA (YAML CONTRACT)

```yaml
status: SUCCESS | BLOCKED | CANCELLED | FAILED
summary: "Tổng kết gitpush (2-3 câu)"

auto_commit:
  enabled: true
  mode: "auto"                          # auto | manual | skipped
  message: "feat(char-service): Add kanji stroke order data"
  type: "feat"
  scope: "char-service"
  files_count: 3

git_status:
  branch: "main"
  remote: "origin"
  ahead: 1
  behind: 0
  last_commit: "abc1234"

safety:
  status: PASS | BLOCKED | WARNING
  secrets_found: 0
  convention_violations: 0
  security_vulnerabilities: 0
  build_failed: false
  test_failed: false

diff_summary:
  files_changed: 5
  insertions: 120
  deletions: 30
  files:
    - file: "src/Program.cs"
      insertions: 10
      deletions: 2
    - file: "src/Pages/Home.razor"
      insertions: 50
      deletions: 20

confirmation:
  requested: true
  response: "Y"
  timestamp: "2026-07-26T08:00:00Z"

push:
  status: SUCCESS | FAILED | CANCELLED
  command: "git push origin main"
  output: "..."
  remote_commit: "def5678"
  duration_seconds: 3.5

post_push:
  remote_synced: true
  new_remote_commit: "def5678 - New commit message"
```

---

## SƠ ĐỒ QUYẾT ĐỊNH

```yaml
bước_0_auto_commit:
  working tree sạch + ahead == 0: → CANCELLED "Không có gì để commit/push"
  --no-commit + ahead == 0: → CANCELLED "Không có commit để push"
  --no-commit + ahead > 0: → bỏ qua, tiếp tục
  --message "..." + có thay đổi: → git add -A + commit với message
  không có --message + có thay đổi: → auto-gen message → git add -A + commit
  auto-gen thất bại: → hỏi user nhập message tay hoặc CANCEL

bước_1_git_status:
  không có git repo: → BLOCKED "Không tìm thấy git repository"
  không có remote: → BLOCKED "Chưa cấu hình remote, thêm remote trước"
  không có commit để push (ahead == 0): → CANCELLED "Không có gì để push"

bước_2_safety:
  secrets_found > 0: → BLOCKED "Secret bị lộ — không push"
  security_vulnerabilities > 0: → BLOCKED "Lỗ hổng bảo mật — không push"
  build_failed: → BLOCKED "Build lỗi — không push"
  chỉ có convention/code_quality warning: → WARNING, hỏi user
  sạch: → PASS, tiếp tục

bước_3_confirmation:
  user Y: → push
  user N: → CANCELLED "User hủy push"
  timeout 60s không phản hồi: → CANCELLED "Timeout chờ xác nhận"

bước_4_push:
  git push success: → SUCCESS
  git push failed (rejected): → FAILED "Push bị từ chối — fetch/pull trước"
  git push failed (network): → FAILED "Lỗi mạng — thử lại sau"
  force push không được phép: → BLOCKED "Force push bị cấm trên branch này"

bước_5_xác_nhận:
  remote commit khớp local: → ✅ SUCCESS
  remote commit không khớp: → WARNING "Push có vẻ thành công nhưng không xác nhận được"
```

---

## TÍCH HỢP VỚI DEV TEAM WORKFLOW

GitPush có thể chạy độc lập hoặc tích hợp vào Dev Team workflow:

### Chạy độc lập

```powershell
/team-gitpush                          # Auto-commit + safety checks + push (mặc định)
/team-gitpush --skip-checks            # Auto-commit + push, bỏ qua kiểm tra
/team-gitpush --force                  # Force push (cảnh báo kỹ)
/team-gitpush --branch feature-xyz     # Push lên branch khác
/team-gitpush --message "Fix bug"      # Dùng message này, stage all + commit + push
/team-gitpush --no-commit              # Chỉ push commit đã có, không auto-commit
```

### Tích hợp vào Dev Team workflow

Có thể thêm GitPush ở cuối workflow (sau Test, trước hoặc thay Self-Improve):

```
... → TEST → GITPUSH → SELF_IMPROVE → COMPLETE
```

Khi đó orchestrator sẽ:
1. Sau khi test PASS → chạy GitPush để push code
2. Nếu BLOCKED → dừng, yêu cầu sửa
3. Nếu SUCCESS → tiếp tục workflow

---

## XỬ LÝ NGOẠI LỆ

| Vấn đề | Cách xử lý |
|--------|------------|
| Git chưa init | BLOCKED, hướng dẫn `git init` |
| Chưa có remote | BLOCKED, hướng dẫn `git remote add origin <url>` |
| Remote không truy cập được | FAILED, kiểm tra network/credentials |
| Working tree sạch + ahead == 0 | CANCELLED, không có gì để commit/push |
| --no-commit + ahead == 0 | CANCELLED, không có commit để push |
| Auto-commit không thể gen message | HỎI user nhập message tay (hoặc CANCEL) |
| Push bị reject (diverged) | FAILED, hướng dẫn `git pull --rebase` trước |
| Build FAIL | BLOCKED, sửa lỗi build trước |
| Test FAIL | WARNING, hỏi user có muốn push không |
| Force push bị cấm | BLOCKED, dùng `git switch` tạo branch khác |
| User không phản hồi (timeout 60s) | CANCELLED tự động |
| Proxy/VPN block | FAILED, kiểm tra kết nối mạng |

### Auto-commit (mặc định)

```powershell
/team-gitpush
```

Mặc định tự động:
1. Phân tích diff → auto-generate commit message
2. `git add -A` + `git commit -m "<auto message>"`
3. Chạy safety checks + Build + Test
4. Confirmation gate → Push

### Dùng message tùy chỉnh

```powershell
/team-gitpush --message "fix(char-service): correct kanji stroke order mapping"
```

Ghi đè auto-generate: stage all + commit với message chỉ định + safety checks + push.

### Chỉ push (bỏ qua auto-commit)

```powershell
/team-gitpush --no-commit
```

Chỉ push các commit đã có lên remote (không stage/commit gì thêm).

### Force push safety

Force push (`--force` hoặc `--force-with-lease`) chỉ được phép khi:
- `--force` flag được truyền rõ ràng
- Không phải branch protected (main/master)
- Có cảnh báo và xác nhận kép từ user

```
⚠️  CẢNH BÁO: Bạn sắp FORCE PUSH lên branch 'main'
  Việc này sẽ GHI ĐÈ lịch sử commit trên remote.
  Nhập 'FORCE' để xác nhận (hoặc 'N' để hủy): 
```

## GHI CHÚ

- Mặc định: auto-commit từ diff + safety checks + push (tất cả trong 1 lệnh)
- `--no-commit` để bỏ qua auto-commit, chỉ push commit đã có
- `--message "..."` để ghi đè commit message (vẫn stage all)
- Luôn chạy safety checks trước khi push (trừ `--skip-checks`)
- Build và test bắt buộc chạy nếu có file .cs/.razor thay đổi
- Confirmation gate bắt buộc — không tự động push
- Force push yêu cầu xác nhận kép
- Working tree clean + ahead == 0 → CANCELLED (không có gì để làm)
- Nếu push bị reject, hướng dẫn cụ thể cách khắc phục
- Khi tích hợp vào dev-team workflow, GitPush là bước cuối trước Complete
