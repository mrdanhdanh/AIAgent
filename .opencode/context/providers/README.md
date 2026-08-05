# providers/ — Context Providers
# Mỗi nguồn dữ liệu là một Provider. Plugin có thể đăng ký thêm Provider.
version: "4.0"
schema: 1

provider_interface:
  - method: discover
    description: Liệt kê candidate (không load), trả list item
  - method: resolve
    description: "Lấy/load nội dung thực, nếu có"
  - method: size
    description: "Uớc tính token/byte để budget"
  - method: validate
    description: "Xác nhận content hợp lệ"

# 5 provider chuẩn:
# Quan chi tiết tại các file cùng thư mục:
#   project.md     — Project Context
#   workflow.md    — Workflow Context
#   task.md        — Task Context
#   artifact.md    — Artifact Context
#   knowledge.md   — Knowledge Provider
#   memory.md      — Memory Provider
#   runtime.md     — Runtime Provider

# ============================================================
# LƯU Ý: Project Context Provider cũng phục vụ Context Cache.
# Nếu plugin cần nguồn mới → thêm file provider mới ở đây.