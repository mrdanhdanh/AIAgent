---
name: gitguard
description: Review source code trước khi push lên git — phát hiện secret, lỗi convention, lỗ hổng bảo mật, vi phạm quy tắc dự án. Tích hợp cơ chế blocking CRITICAL, cảnh báo MAJOR. Sử dụng câu lệnh /team-gitguard.
schema_version: "1.0"
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

### Bước 1: Xác định phạm vi

- Chạy `git status --short` lấy danh sách file thay đổi
- Nếu user truyền đường dẫn cụ thể, chỉ review các file đó
- Nếu không có file thay đổi → PASS ngay, không cần review

### Bước 2: Secrets scan (CRITICAL)

Quét từng file với regex patterns:

| Pattern | Mục tiêu |
|---------|----------|
| `(API[_-]?KEY|SECRET|TOKEN|PASSWORD|PASSWD|CONNECTION_STRING)\s*[:=]\s*["'][^"']+["']` | Hardcoded credentials |
| `-----BEGIN\s+(RSA|EC|DSA|OPENSSH|PGP)\s+PRIVATE\s+KEY-----` | Private keys |
| `ghp_[[:alnum:]]{36,}` | GitHub personal access tokens |
| `sk-[[:alnum:]]{32,}` | OpenAI API keys |
| `https?://[^:]+:[^@]+@` | URL-embedded credentials |
| File extension `.env`, `*.key`, `*.pem`, `*.pfx`, `*.jks`, `secrets.json` | Sensitive files |

Nếu tìm thấy bất kỳ secret nào → **BLOCKED** ngay lập tức.

### Bước 3: Convention check (MAJOR)

Đối chiếu với AGENTS.md và knowledge base:

| Rule | Kiểm tra |
|------|----------|
| FluentUI, không MudBlazor | `grep -i "Mud\|MudBlazor"` trên file .razor/.cs |
| Service-Interface DI | Kiểm tra `AddScoped<I.*, .*>` trong Program.cs |
| Cache-first storage | Kiểm tra in-memory cache pattern |
| Tri-state rendering | `isLoading` + `list.Count == 0` pattern |
| Inline style blocks | `<style>` trong .razor (không CSS isolation) |
| Vietnamese meanings | Vocabulary Meaning field |

### Bước 4: Security scan (CRITICAL/MAJOR)

| Type | Pattern | Severity |
|------|---------|----------|
| XSS | `@Html.Raw(`, `dangerouslySetInnerHTML`, `innerHTML\s*=` | CRITICAL |
| SQL injection | `"SELECT.*\+"`, `$"SELECT.*{`, `ExecuteSqlRaw(` | CRITICAL |
| Unsafe deserialization | `BinaryFormatter`, `SoapFormatter`, `LosFormatter` | CRITICAL |
| Path traversal | `Path.Combine\(.*userInput`, `MapPath(` | MAJOR |
| Debug leftover | `console\.log`, `Debug\.Write`, `print(` | MINOR |
| Hardcoded IP/URL | `https?://\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}` | MAJOR |

### Bước 5: Code quality check (MAJOR/MINOR)

- Magic strings/numbers không có tên hằng
- Dead code: comment block toàn bộ method, unused using/import
- Empty catch block: `catch\s*(\[.*\])?\s*\{\s*\}`
- Deep nesting: `if` lồng > 4 level
- Long method: > 100 lines trong 1 method
- Missing null check: `.` access trên parameter không check null

### Bước 6: Build & test check

- Nếu file `.cs` hoặc `.razor` thay đổi → chạy `dotnet build`
- Nếu build FAIL → **BLOCKED**
- Nếu có test project tương ứng → chạy `dotnet test`
- Nếu test FAIL → **WARNING** (không block, nhưng khuyến nghị sửa)

---

## 6 KÊNH KIỂM TRA

| # | Kênh | Mục tiêu | Severity lỗi | Hành động |
|---|------|----------|-------------|-----------|
| 1 | **Secrets scan** | API keys, tokens, passwords, private keys, .env | CRITICAL | BLOCKED |
| 2 | **Convention check** | Coding conventions từ AGENTS.md | MAJOR | WARNING |
| 3 | **Security scan** | XSS, SQL injection, unsafe deserialization | CRITICAL | BLOCKED |
| 4 | **Security scan (minor)** | Debug leftover, hardcoded IP | MAJOR/MINOR | WARNING/PASS |
| 5 | **Code quality** | Magic values, dead code, empty catch, deep nesting | MAJOR/MINOR | WARNING/PASS |
| 6 | **Build & test** | dotnet build, dotnet test | CRITICAL/MAJOR | BLOCKED/WARNING |

---

## ĐỊNH DẠNG ĐẦU RA

```yaml
status: PASS | BLOCKED | WARNING
summary: "Tổng kết review (2-3 câu)"

secrets:
  found: 0
  items:
    - file: "path/to/file"
      line: 42
      pattern: "API_KEY | TOKEN | PRIVATE_KEY | PASSWORD | CONNECTION_STRING | ENV_FILE"
      snippet: "api_key = \"sk-...abcd\""    # che dấu 1 phần
      severity: CRITICAL

conventions:
  violations:
    - file: "path/to/file"
      line: 10
      rule: "Dùng FluentUI, không dùng MudBlazor"
      detected: "MudButton"
      expected: "FluentButton"
      severity: MAJOR

security:
  vulnerabilities:
    - file: "path/to/file"
      line: 25
      type: "XSS | SQL_INJECTION | HARDCODED_CREDENTIAL | UNSAFE_DESERIALIZATION | PATH_TRAVERSAL | DEBUG_LEFTOVER | HARDCODED_IP"
      severity: CRITICAL | MAJOR | MINOR
      description: "Mô tả ngắn gọn"
      suggestion: "Cách sửa cụ thể"

code_quality:
  issues:
    - file: "path/to/file"
      line: 50
      type: "MAGIC_VALUE | DEAD_CODE | EMPTY_CATCH | DEEP_NESTING | LONG_METHOD | MISSING_NULL_CHECK | MISSING_VALIDATION"
      severity: MAJOR | MINOR
      description: "Mô tả"

build:
  status: PASS | FAIL | SKIPPED
  command: "dotnet build JapaneseLearner\JapaneseLearner.csproj"
  error: "Chi tiết lỗi nếu FAIL"

tests:
  status: PASS | FAIL | SKIPPED
  command: "dotnet test JapaneseLearner.Tests\JapaneseLearner.Tests.csproj"
  details: "n/m passed, x% coverage"

final_verdict: PASS | BLOCKED | WARNING
blocking_issues: 0
warning_issues: 0
recommendation: "Hành động đề xuất cho người dùng"
```

---

## PHÂN LOẠI SEVERITY & VERDICT

### Severity

| Severity | Ý nghĩa | Ví dụ |
|----------|---------|-------|
| **CRITICAL** | Rủi ro cao nhất — secret bị lộ, lỗ hổng bảo mật, code không compile | API key trong source, SQL injection, build FAIL |
| **MAJOR** | Vi phạm convention, code quality nghiêm trọng | Sai FluentUI, missing null check, debug leftover |
| **MINOR** | Code quality nhẹ, style, warning | Magic number, long method, unused import |

### Verdict

| Verdict | Điều kiện | Hành động |
|---------|-----------|-----------|
| **BLOCKED** | Có CRITICAL issue (secrets, security vuln, build FAIL) | KHÔNG được push. Phải sửa trước |
| **WARNING** | Không có CRITICAL, nhưng có MAJOR issue | Có thể push, nhưng khuyến nghị sửa |
| **PASS** | Không có CRITICAL hoặc MAJOR issue | ✅ An toàn để push |

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

## GHI CHÚ

- GitGuard là read-only agent — chỉ phát hiện và báo cáo, không tự sửa file
- CRITICAL findings luôn BLOCK push — không có ngoại lệ
- MAJOR findings → WARNING — khuyến nghị sửa nhưng không bắt buộc
- Che dấu secret trong báo cáo: chỉ hiện 4 ký tự đầu + 4 ký tự cuối
- Có thể chạy với `--full` flag để scan toàn bộ codebase (không chỉ diff)
- Quy tắc safety/security dựa trên OWASP Top 10 (2021) và CWE Top 25 (2024)
