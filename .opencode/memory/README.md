# Failure Learning System — Memory

## Mục đích

Lưu trữ và tái sử dụng kiến thức từ các lỗi đã gặp trong workflow. Giúp agent không lặp lại cùng một lỗi hai lần.

## Cấu trúc

```
memory/
├── README.md              ← You are here
├── failures/              ← Failure records (BUG-XXXX)
│   └── README.md
├── lessons/blazor/        ← Bài học theo framework
│   └── README.md
├── lessons/powershell/    ← Bài học về PowerShell scripting
│   └── README.md
└── patterns/              ← Pattern phát hiện từ failures
    └── README.md
```

## Quy tắc

1. Mỗi failure record format BUG-XXXX
2. error_hash = SHA256(error_normalized) 12 ký tự đầu
3. Reference chéo: failures ↔ lessons ↔ patterns qua error_hash + failure_id
4. Chỉ ghi record khi fix thành công (hoặc catastrophic failure)

## Flow

```
Error → Normalize → Hash → Search memory → Found? → Apply lesson
                                                 → Not found? → Root Cause → Fix → Record
```
