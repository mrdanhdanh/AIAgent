---
name: gitguard
description: Review source code trước khi push lên git — phát hiện secret, lỗi convention, lỗ hổng bảo mật, vi phạm quy tắc dự án. Tích hợp cơ chế blocking CRITICAL, cảnh báo MAJOR. Sử dụng câu lệnh /team-gitguard.
schema_version: "2.0"
---

# GitGuard — Pre-Push Source Code Review Skill

Skill chuyên kiểm tra source code trước khi commit/push lên git repository. Đảm bảo mã nguồn tuân thủ quy tắc dự án, an toàn bảo mật, không rò rỉ secret, không lỗi build/test.

## MỤC LỤC

- [TỔNG QUAN](#tổng-quan)
- [ARCHITECTURE](#architecture)
- [QUY TRÌNH KIỂM TRA](#quy-trình-kiểm-tra)
- [6 KÊNH KIỂM TRA](#6-kênh-kiểm-tra)
- [ĐỊNH DẠNG ĐẦU RA](#định-dạng-đầu-ra)
- [PHÂN LOẠI SEVERITY & VERDICT](#phân-loại-severity--verdict)
- [SƠ ĐỒ QUYẾT ĐỊNH](#sơ-đồ-quyết-định)
- [TÍCH HỢP VỚI DEV TEAM WORKFLOW](#tích-hợp-với-dev-team-workflow)
- [SAFETY & SECURITY RULES](#safety--security-rules)
- [XỬ LÝ NGOẠI LỆ](#xử-lý-ngoại-lệ)

---

## TỔNG QUAN

GitGuard là skill review source code tự động trước khi push lên git. Khác với `team-review` (đánh giá kế hoạch/thuật toán), GitGuard tập trung vào **kiểm soát chất lượng và bảo mật source code thực tế** — phát hiện secret bị lộ, code sai convention, lỗ hổng bảo mật, lỗi build/test.

### Khi nào dùng GitGuard?

- **Trước mỗi git commit/push** — kiểm tra nhanh file thay đổi
- **Trước khi tạo Pull Request** — đảm bảo code sẵn sàng cho review
- **Khi nghi ngờ có secret trong code** — quét toàn bộ repo
- **Khi cần validation convention dự án** — đảm bảo consistency

### Agent

| Vai trò | Agent | File |
|---------|-------|------|
| Guardian (kiểm tra) | `guardian` | `.opencode/agents/guardian.md` |

### Command

| Command | Mô tả |
|---------|-------|
| `/team-gitguard` | Chạy GitGuard review, có thể kèm đường dẫn cụ thể |

---

## ARCHITECTURE

```
User request (/team-gitguard)
        │
        ▼
┌───────────────────┐
│  Guardian Agent   │
│  (guardian.md)    │
└────────┬──────────┘
         │
         ├── 1. Git diff analysis
         │      └── git status, git diff --cached
         │
         ├── 2. Secrets & credentials scan
         │      └── Regex patterns: API_KEY, TOKEN, PRIVATE KEY, .env
         │
         ├── 3. Project convention check
         │      └── AGENTS.md rules: FluentUI, DI, cache-first, tri-state, style
         │
         ├── 4. Security vulnerability scan
         │      └── XSS, SQL injection, unsafe deserialization, path traversal
         │
         ├── 5. Code quality check
         │      └── Magic values, dead code, empty catch, deep nesting
         │
         ├── 6. Build & test check (optional)
         │      └── dotnet build, dotnet test
         │
         └── Output YAML contract
               └── status: PASS | BLOCKED | WARNING
```

---

## QUY TRÌNH KIỂM TRA

### Bước 1: Xác định phạm vi — 3-tier priority

Phạm vi review được ưu tiên theo thứ tự: **staged changes → unstaged modified → untracked files**.
Chỉ review file liên quan đến diff, không quét toàn bộ repo (trừ khi có flag `--full`).

1. **Staged changes** (`git diff --cached --name-only`) — ưu tiên cao nhất
   - File đã được `git add` và chuẩn bị commit
   - Chạy `git diff --cached` để lấy nội dung thay đổi

2. **Unstaged modified** (`git diff --name-only`) — ưu tiên thứ hai
   - File đã được tracking nhưng chưa staged
   - Chạy `git diff` để lấy nội dung thay đổi

3. **Untracked files** (`git ls-files --others --exclude-standard`) — ưu tiên thấp nhất
   - File mới chưa được tracking
   - Review toàn bộ nội dung file

Nếu user truyền đường dẫn cụ thể → chỉ review các file đó (bỏ qua git diff).
Nếu không có file thay đổi → **PASS** ngay, không cần review.
Flag `--full` → review toàn bộ source code (không chỉ diff).

### Bước 2: Secrets scan (CRITICAL)

Mỗi phát hiện cần kèm: `evidence` (pattern khớp, che dấu 1 phần), `confidence` (HIGH/MEDIUM/LOW), `fix_hint` (cách sửa cụ thể).

Quét từng file với regex patterns (4 nhóm riêng biệt):

#### Nhóm 1: Secrets (API keys, tokens, private keys)

| Pattern | Mục tiêu | Severity | Confidence |
|---------|----------|----------|------------|
| `ghp_[[:alnum:]]{36,}` | GitHub personal access tokens | CRITICAL | HIGH |
| `sk-[[:alnum:]]{32,}` | OpenAI API keys | CRITICAL | HIGH |
| `-----BEGIN\s+(RSA|EC|DSA|OPENSSH|PGP)\s+PRIVATE\s+KEY-----` | Private keys | CRITICAL | HIGH |

#### Nhóm 2: Credentials (user/pass, connection strings)

| Pattern | Mục tiêu | Severity | Confidence |
|---------|----------|----------|------------|
| `(API[_-]?KEY|SECRET|TOKEN|PASSWORD|PASSWD)\s*[:=]\s*["'][^"']+["']` | Hardcoded credentials | CRITICAL | HIGH |
| `(CONNECTION_STRING|conn_string)\s*[:=]\s*["'][^"']+["']` | Database connection strings | CRITICAL | HIGH |
| `https?://[^:]+:[^@]+@` | URL-embedded credentials | CRITICAL | HIGH |

#### Nhóm 3: Sensitive files

| Extension/Path | Lý do | Severity | Confidence |
|----------------|-------|----------|------------|
| `.env` | Environment variables | CRITICAL | HIGH |
| `*.key`, `*.pem`, `*.pfx`, `*.jks` | Private key files | CRITICAL | HIGH |
| `secrets.json` | Secret configuration | CRITICAL | HIGH |

#### Nhóm 4: High-entropy strings

| Pattern | Mục tiêu | Severity | Confidence |
|---------|----------|----------|------------|
| Entropy > 4.5 (base64, hex strings) | Mã hóa/encoded credentials | MAJOR | MEDIUM |
| `[A-Za-z0-9+/=]{40,}` (base64-like) | Potential encoded secrets | MAJOR | MEDIUM |

**Nếu tìm thấy bất kỳ secret/credential nào (Nhóm 1-3)** → **BLOCKED** ngay lập tức.
**High-entropy strings (Nhóm 4)** → **WARNING** (cần kiểm tra thêm).
**False positive patterns** (xem section FALSE POSITIVE RULES) → giảm confidence xuống LOW.

### Bước 3: Convention check (MAJOR)

Mỗi vi phạm cần kèm: `evidence` (đoạn code phát hiện), `confidence` (HIGH/MEDIUM/LOW), `fix_hint` (cách sửa). Conventions được chia làm 4 nhóm: framework, architecture, testing, UI (xem chi tiết Output Contract).

Đối chiếu với AGENTS.md và knowledge base (4 nhóm conventions):

#### Framework Conventions

| Rule | Kiểm tra | Severity |
|------|----------|----------|
| FluentUI 4.14.3, không MudBlazor | `grep -i "Mud\|MudBlazor"` trên .razor/.cs | MAJOR |
| Dùng FluentButton, FluentSelect, FluentDialog | Kiểm tra component imports | MAJOR |
| Dùng Appearance enum (.Accent, .Lightweight, .Neutral) | Kiểm tra class style | MAJOR |

#### Architecture Conventions

| Rule | Kiểm tra | Severity |
|------|----------|----------|
| Service-Interface DI (`IWordService`/`WordService`) | Kiểm tra `AddScoped<I.*, .*>` trong Program.cs | MAJOR |
| Cache-first: in-memory → Blazored.LocalStorage → seed | Kiểm tra cache pattern trong service | MAJOR |
| Write-through on every mutation | Kiểm tra write sau mutation | MAJOR |

#### Testing Conventions

| Rule | Kiểm tra | Severity |
|------|----------|----------|
| xUnit + bUnit framework | Kiểm tra project references | MAJOR |
| Test class kế thừa `BunitTestBase` | Kiểm tra class declaration | MAJOR |
| FluentUI JSInterop mock (9 modules) | Kiểm tra mock setup | MAJOR |
| MockStorageService cho ILocalStorageService | Kiểm tra mock injection | MAJOR |

#### UI Conventions

| Rule | Kiểm tra | Severity |
|------|----------|----------|
| Tri-state: isLoading → list.Count==0 → data | Kiểm tra pattern trong .razor | MAJOR |
| Inline `<style>` blocks (không CSS isolation) | Kiểm tra file .razor.css | MAJOR |
| Vietnamese meanings cho vocabulary | Kiểm tra Meaning field | MINOR |

### Bước 4: Security scan (CRITICAL/MAJOR)

Mỗi lỗ hổng cần kèm: `evidence` (code pattern phát hiện), `confidence` (HIGH/MEDIUM/LOW), `fix_hint` (cách sửa, ví dụ: "Dùng paramterized query thay vì string concatenation").

| Type | Pattern | Severity |
|------|---------|----------|
| XSS | `@Html.Raw(`, `dangerouslySetInnerHTML`, `innerHTML\s*=` | CRITICAL |
| SQL injection | `"SELECT.*\+"`, `$"SELECT.*{`, `ExecuteSqlRaw(` | CRITICAL |
| Unsafe deserialization | `BinaryFormatter`, `SoapFormatter`, `LosFormatter` | CRITICAL |
| Path traversal | `Path.Combine\(.*userInput`, `MapPath(` | MAJOR |
| Debug leftover | `console\.log`, `Debug\.Write`, `print(` | MINOR |
| Hardcoded IP/URL | `https?://\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}` | MAJOR |

### Bước 5: Code quality check (MAJOR/MINOR)

Mỗi issue cần kèm: `evidence` (code pattern), `confidence` (MEDIUM mặc định), `fix_hint` (gợi ý refactor).

- Magic strings/numbers không có tên hằng
- Dead code: comment block toàn bộ method, unused using/import
- Empty catch block: `catch\s*(\[.*\])?\s*\{\s*\}`
- Deep nesting: `if` lồng > 4 level
- Long method: > 100 lines trong 1 method
- Missing null check: `.` access trên parameter không check null

### Bước 6: Build & test check (conditional)

Điều kiện hóa dựa trên loại file thay đổi — chỉ chạy khi cần thiết:

| Loại file thay đổi | Hành động | Điều kiện |
|--------------------|-----------|-----------|
| `*.cs`, `*.razor` (C# files) | Chạy `dotnet build` | Có ít nhất 1 file .cs/.razor thay đổi |
| `*Test*.cs`, `*.Tests.csproj`, test files | Chạy `dotnet test` | Có test file thay đổi + build PASS |
| Non-.NET files (`.md`, `.json`, `.yaml`, `.js`, `.ts`, `.css`) | **SKIP** build/test | Không có C# thay đổi |
| Mixed (cả .NET + non-.NET) | Chạy build + test | Kiểm tra trên .NET files |

Kết quả:
- Build FAIL → **BLOCKED** (CRITICAL)
- Test FAIL → **WARNING** (MAJOR, khuyến nghị sửa)
- Build+test PASS hoặc SKIP → tiếp tục

---

## 6 KÊNH KIỂM TRA

| # | Kênh | Mục tiêu | Severity lỗi | Verdict | Evidence req. |
|---|------|----------|-------------|---------|---------------|
| 1 | **Secrets scan** | API keys, tokens, passwords, private keys, .env | CRITICAL | BLOCKED | ✅ evidence, confidence, fix_hint |
| 2 | **Convention check** | Coding conventions từ AGENTS.md (4 nhóm) | MAJOR | WARNING | ✅ evidence, confidence, fix_hint |
| 3 | **Security scan** | XSS, SQL injection, unsafe deserialization | CRITICAL | BLOCKED | ✅ evidence, confidence, fix_hint |
| 4 | **Security scan (minor)** | Debug leftover, hardcoded IP | MAJOR/MINOR | WARNING/PASS | ✅ evidence, confidence |
| 5 | **Code quality** | Magic values, dead code, empty catch, deep nesting | MAJOR/MINOR | WARNING/PASS | ✅ evidence, confidence, fix_hint |
| 6 | **Build & test** | dotnet build, dotnet test (conditional) | CRITICAL/MAJOR | BLOCKED/WARNING | N/A (status output) |

---

## ĐỊNH DẠNG ĐẦU RA — Enhanced Contract v2.0

Output contract mở rộng với bằng chứng (evidence), phân loại chi tiết, và tổng hợp rủi ro.

### Evidence & Confidence Schema

Mỗi finding trong output contract có thể kèm:

| Field | Type | Mô tả |
|-------|------|-------|
| `evidence` | string | Đoạn code/pattern khớp (trích dẫn ngắn) |
| `confidence` | string | Độ tin cậy: `HIGH` / `MEDIUM` / `LOW` |
| `fix_hint` | string | Gợi ý sửa lỗi cụ thể |

- `confidence == LOW` → có thể là false positive, cần kiểm tra thêm
- `confidence == HIGH` → pattern khớp chính xác, ít FP
- `fix_hint` cung cấp hướng dẫn sửa ngắn gọn

### YAML Contract

```yaml
status: PASS | BLOCKED | WARNING
summary: "Tổng kết review (2-3 câu)"

# === REVIEW SCOPE ===
review_scope:
  staged: ["path/to/file1.cs"]       # git diff --cached
  modified: ["path/to/file2.razor"]  # git diff (unstaged)
  untracked: ["path/to/file3.ts"]    # git ls-files --others
  full_scan: false                   # true nếu --full flag

# === SECRETS (4 sub-groups) ===
secrets:
  found: 0
  items:
    - file: "path/to/file"
      line: 42
      pattern: "API_KEY"
      severity: CRITICAL
      evidence: "api_key = \"sk-...abcd\""    # che dấu 1 phần
      confidence: HIGH
      fix_hint: "Dùng environment variable thay vì hardcode"

credentials:
  found: 0
  items:
    - file: "path/to/file"
      line: 15
      pattern: "PASSWORD"
      severity: CRITICAL
      evidence: "password = \"***\""
      confidence: HIGH
      fix_hint: "Dùng secret manager hoặc Windows Auth"

sensitive_files:
  found: 0
  items:
    - file: ".env"
      line: 1
      extension: ".env"
      severity: CRITICAL
      confidence: HIGH
      fix_hint: "Thêm .env vào .gitignore và xóa khỏi git history"

high_entropy_strings:
  found: 0
  items:
    - file: "path/to/file"
      line: 30
      entropy: 4.8
      severity: MAJOR
      confidence: MEDIUM
      evidence: "aGVsbG8gd29ybGQ="
      fix_hint: "Xác nhận đây không phải token/credential"

# === CONVENTIONS (4 sub-groups) ===
framework_conventions:
  violations:
    - file: "path/to/file.razor"
      line: 10
      rule: "Dùng FluentUI, không dùng MudBlazor"
      detected: "MudButton"
      expected: "FluentButton"
      severity: MAJOR
      evidence: "<MudButton>"
      confidence: HIGH
      fix_hint: "Thay MudButton bằng FluentButton"

architecture_conventions:
  violations:
    - file: "path/to/Program.cs"
      line: 20
      rule: "Service-Interface DI — AddScoped trong Program.cs"
      detected: "Thiếu registration cho IWordService"
      expected: "builder.Services.AddScoped<IWordService, WordService>();"
      severity: MAJOR
      evidence: "Không tìm thấy AddScoped<IWordService"
      confidence: HIGH
      fix_hint: "Thêm dòng AddScoped<IWordService, WordService>() trong Program.cs"

testing_conventions:
  violations:
    - file: "path/to/TestFile.cs"
      line: 5
      rule: "Test class kế thừa BunitTestBase"
      detected: "Không thấy : BunitTestBase"
      expected: "class MyTest : BunitTestBase"
      severity: MAJOR
      evidence: "class MyTest {"
      confidence: MEDIUM
      fix_hint: "Kế thừa BunitTestBase để có mock JSInterop"

ui_conventions:
  violations:
    - file: "path/to/Page.razor"
      line: 1
      rule: "Tri-state rendering: isLoading + list.Count == 0"
      detected: "Thiếu isLoading check"
      expected: "@if (isLoading) { ... } else if (list.Count == 0) { ... } else { ... }"
      severity: MAJOR
      evidence: "Thiếu pattern isLoading"
      confidence: HIGH
      fix_hint: "Thêm isLoading state và tri-state rendering"

# === SECURITY ===
security:
  vulnerabilities:
    - file: "path/to/file"
      line: 25
      type: "XSS | SQL_INJECTION | HARDCODED_CREDENTIAL | UNSAFE_DESERIALIZATION | PATH_TRAVERSAL | DEBUG_LEFTOVER | HARDCODED_IP"
      severity: CRITICAL | MAJOR | MINOR
      description: "Mô tả ngắn gọn"
      evidence: "Đoạn code vi phạm"
      confidence: HIGH
      fix_hint: "Cách sửa cụ thể"

# === CODE QUALITY ===
code_quality:
  issues:
    - file: "path/to/file"
      line: 50
      type: "MAGIC_VALUE | DEAD_CODE | EMPTY_CATCH | DEEP_NESTING | LONG_METHOD | MISSING_NULL_CHECK | MISSING_VALIDATION"
      severity: MAJOR | MINOR
      description: "Mô tả"
      evidence: "Đoạn code vi phạm"
      confidence: MEDIUM
      fix_hint: "Gợi ý refactor"

# === BUILD ===
build:
  status: PASS | FAIL | SKIPPED
  command: "dotnet build JapaneseLearner\JapaneseLearner.csproj"
  error: "Chi tiết lỗi nếu FAIL"
  triggered_by: ["*.cs", "*.razor"]    # Chạy khi có file C# thay đổi

# === TESTS ===
tests:
  status: PASS | FAIL | SKIPPED
  command: "dotnet test JapaneseLearner.Tests\JapaneseLearner.Tests.csproj"
  details: "n/m passed, x% coverage"
  triggered_by: ["*Test*.cs", "*Test*.razor", "*Tests*"]  # Chạy khi có test files

# === RISK SUMMARY ===
risk_summary:
  critical: 0
  major: 0
  minor: 0
  risk_score: 0                    # = critical*10 + major*3 + minor*1
needs_manual_review: false         # true nếu có LOW confidence findings

# === FINAL VERDICT ===
final_verdict: PASS | BLOCKED | WARNING
blocking_issues: 0
warning_issues: 0
recommendation: "Hành động đề xuất cho người dùng"
```

---

## PHÂN LOẠI SEVERITY & VERDICT

### Severity-verdict mapping

| Severity | Ý nghĩa | Ví dụ | Verdict | Hành động |
|----------|---------|-------|---------|-----------|
| **CRITICAL** | Rủi ro cao nhất — secret, lỗ hổng bảo mật, build FAIL | API key, SQL injection, compile error | **BLOCKED** | KHÔNG được push. Phải sửa trước |
| **MAJOR** | Vi phạm convention, code quality nghiêm trọng | Sai FluentUI, missing null check, test FAIL | **WARNING** | Có thể push, nhưng khuyến nghị sửa |
| **MINOR** | Code quality nhẹ, style, warning | Magic number, long method, unused import | **PASS** | Tự động PASS, chỉ log warning, không block |

### Risk Score

Điểm rủi ro tổng thể giúp orchestrator dễ quyết định hành động:

```
risk_score = (critical_count × 10) + (major_count × 3) + (minor_count × 1)
```

| risk_score | Ý nghĩa | Verdict |
|-----------|---------|---------|
| 0 | Không có issue nào | PASS |
| 1-5 | Chỉ có MINOR issues | PASS (minor warning) |
| 6-20 | Có MAJOR issues | WARNING |
| > 20 | Có CRITICAL issues | BLOCKED |

Ví dụ: 1 CRITICAL + 2 MAJOR + 3 MINOR = 1×10 + 2×3 + 3×1 = 19 → WARNING

---

## SƠ ĐỒ QUYẾT ĐỊNH

```yaml
secrets.found > 0:
  → BLOCKED (CRITICAL: nguy cơ rò rỉ thông tin)
  → Hành động: Xóa secret, thêm .gitignore, xoay key

security.vulnerabilities có CRITICAL:
  → BLOCKED (CRITICAL: lỗ hổng bảo mật)
  → Hành động: Sửa theo suggestion, dùng parameterized/sanitize

build.status == FAIL:
  → BLOCKED (CRITICAL: code không compile)
  → Hành động: Sửa lỗi build, chạy lại

conventions.violations có MAJOR:
  → WARNING (MAJOR: sai convention)
  → Hành động: Sửa theo expected value

code_quality.issues có MAJOR:
  → WARNING (MAJOR: code quality)
  → Hành động: Cân nhắc refactor

tests.status == FAIL:
  → WARNING (MAJOR: test fail)
  → Hành động: Sửa test trước khi push

chỉ có MINOR issues hoặc không có issue gì:
  → PASS (sạch)
  → ✅ An toàn để push
```

---

## TÍCH HỢP VỚI DEV TEAM WORKFLOW

GitGuard có thể chạy độc lập hoặc tích hợp vào Dev Team workflow:

### Chạy độc lập
```powershell
/team-gitguard                      # Review tất cả file thay đổi
/team-gitguard path/to/file.cs      # Review file cụ thể
/team-gitguard --full               # Review toàn bộ source (không chỉ diff)
```

### Tích hợp vào Dev Team workflow

Có thể thêm GitGuard như bước 4.5 (sau Review, trước Backup) trong quy trình dev-team:

```
ANALYZE → DESIGN → PLAN → REVIEW → GITGUARD → BACKUP → BUILD → ...
```

Khi đó orchestrator sẽ:
1. Sau khi plan được APPROVED → chạy GitGuard trên codebase
2. Nếu BLOCKED → dừng, yêu cầu sửa
3. Nếu PASS/WARNING → tiếp tục workflow

---

## SAFETY & SECURITY RULES

Các quy tắc an toàn bảo mật được GitGuard kiểm tra, tổng hợp từ OWASP Top 10, CWE Top 25 và quy tắc dự án:

### A. Secret Management
1. **Không hardcode secret** — API key, token, password phải dùng environment variable / secret manager
2. **Không commit file .env, *.key, *.pem, *.pfx** — thêm vào .gitignore
3. **Xoay key ngay khi phát hiện secret bị commit** — giả sử secret đã compromised
4. **Không dùng connection string với plain-text password** — dùng Managed Identity / Windows Auth

### B. Input Validation
5. **Validate tất cả input từ user** — kiểm tra type, length, range, format
6. **Parameterized query cho database** — không dùng string concatenation
7. **Sanitize output** — tránh XSS: dùng encoding, không `@Html.Raw()` với user input
8. **Validate file path** — tránh path traversal: không dùng input trực tiếp trong Path.Combine

### C. Authentication & Authorization
9. **Không tự implement authentication** — dùng framework built-in
10. **Kiểm tra authorization ở server-side** — không chỉ dựa vào client-side check
11. **Không lưu password plain-text** — luôn hash + salt

### D. Error Handling
12. **Không để lộ stack trace trong production** — dùng custom error page
13. **Không empty catch block** — luôn log hoặc xử lý lỗi
14. **Graceful degradation** — không crash app khi có lỗi nhỏ

### E. Dependency & Configuration
15. **Không dùng dependency với known CVE** — kiểm tra `dotnet list package --vulnerable`
16. **CORS restrict** — không dùng `AllowAnyOrigin()` trong production
17. **HTTPS enforcement** — không cho phép HTTP trong production
18. **Debug mode tắt trong production** — `ASPNETCORE_ENVIRONMENT=Production`

### F. Code Quality
19. **Không dead code** — xóa code không dùng thay vì comment
20. **Không magic value** — dùng hằng số có tên ý nghĩa
21. **Xử lý null** — kiểm tra null trước khi access member
22. **Single Responsibility** — method/class chỉ làm một việc

---

## XỬ LÝ NGOẠI LỆ

| Vấn đề | Cách xử lý |
|--------|------------|
| Git chưa init / không có git | Bỏ qua git diff, scan toàn bộ working directory |
| Không có file thay đổi | PASS — không có gì để review |
| Build lệnh không có trong dự án | SKIP build check |
| Test project không tồn tại | SKIP test check |
| Regex false positive | Ghi log "Có thể false positive: ..." nhưng vẫn BLOCKED nếu CRITICAL |
| File nhị phân (.dll, .exe, .png) | Chỉ check tên file, không check nội dung |
| File quá lớn (>1MB) | Skip nội dung, chỉ check tên file + extension |

## FALSE POSITIVE RULES

Các pattern dễ báo nhầm (false positive) và cách xử lý:

| Pattern | Context dễ FP | Flag | Hành động |
|---------|--------------|------|-----------|
| `sk-` (OpenAI key pattern) | Test fixtures, sample code | `ignore_if_test_fixture: true` | Giảm confidence → LOW, thêm `manual_review_required: true` |
| `pk-` (private key pattern) | Documentation, example config | `ignore_if_placeholder: true` | Giảm confidence → LOW nếu value là "your-key-here" |
| `token` | Variable name, test token | `ignore_if_test_fixture: true` | Chỉ báo nếu value khớp regex `ghp_\|gho_\|ghu_` |
| `password` | Test data, placeholder | `ignore_if_placeholder: true` | Bỏ qua nếu value là "password123", "changeme" |
| `api_key = "..."` | Hardcoded trong source | `manual_review_required: true` | Vẫn BLOCKED, nhưng ghi log "Cần kiểm tra thêm" |
| Connection string | appsettings.json (đã .gitignore) | `manual_review_required: true` | Kiểm tra file có trong .gitignore không |
| High-entropy string (base64) | Serialized data, encoded content | `ignore_if_test_fixture: true` | Giảm confidence → MEDIUM, cần xác nhận |

### Flags chi tiết

| Flag | Ý nghĩa | Khi nào dùng |
|------|---------|--------------|
| `ignore_if_test_fixture: true` | Bỏ qua nếu pattern xuất hiện trong file test (path chứa `Test`, `test`, `spec`, `fixture`) | Test files, sample data, mock data |
| `ignore_if_placeholder: true` | Bỏ qua nếu value là placeholder (chứa "your", "example", "changeme", "xxxx") | Config mẫu, documentation, hướng dẫn |
| `manual_review_required: true` | Vẫn báo cáo nhưng cần người kiểm tra thủ công | Edge cases không chắc chắn, pattern gần đúng |

### Decision tree cho FP

```
Pattern match found?
├── File trong test directory? → ignore_if_test_fixture = true → confidence LOW, manual review
├── Value là placeholder? → ignore_if_placeholder = true → SKIP, không báo
├── Pattern chính xác (HIGH confidence)? → BLOCKED
└── Pattern gần đúng (MEDIUM confidence)? → manual_review_required = true → WARNING
```

## GHI CHÚ

- GitGuard là read-only agent — chỉ phát hiện và báo cáo, không tự sửa file
- CRITICAL findings luôn BLOCK push — không có ngoại lệ
- MAJOR findings → WARNING — khuyến nghị sửa nhưng không bắt buộc
- Che dấu secret trong báo cáo: chỉ hiện 4 ký tự đầu + 4 ký tự cuối
- Có thể chạy với `--full` flag để scan toàn bộ codebase (không chỉ diff)
- Quy tắc safety/security dựa trên OWASP Top 10 (2021) và CWE Top 25 (2024)
