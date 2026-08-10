<#
.SYNOPSIS
Runtime Tests - test runner dung chung cho toan bo module AIOS runtime.
.DESCRIPTION
Chay tat ca test file trong .opencode/runtime/tests/ (moi module 1 file .ps1).
Moi test file goi Assert/Assert-Throw tu runner nay.
Usage: powershell -File runtime-tests.ps1 [-Filter <pattern>] [-Json]
Exit 0 = all PASS, exit 1 = co FAIL.
.DESCRIPTION
ASCII-only (PS 5.1 ANSI). UTF-8 no BOM.
#>
param(
    [string]$Filter = "*",
    [switch]$Json
)

$ErrorActionPreference = "Continue"
$root = Split-Path -Parent $PSScriptRoot

# === Shared state (test files dung chung qua dot-source) ===
$script:Passed = @()
$script:Failed = @()
$script:CurrentSuite = ""

function Assert {
    param([string]$Name, [bool]$Cond, [string]$Detail = "")
    if ($Cond) {
        $script:Passed += "$($script:CurrentSuite)/$Name"
        Write-Host "  [PASS] $Name"
    } else {
        $script:Failed += "$($script:CurrentSuite)/$Name"
        Write-Host "  [FAIL] $Name $Detail"
    }
}

function Assert-Throw {
    param([string]$Name, [scriptblock]$Block, [string]$Expected = "")
    try {
        & $Block *> $null
        $script:Failed += "$($script:CurrentSuite)/$Name"
        Write-Host "  [FAIL] $Name (khong throw; expected: $Expected)"
    } catch {
        $msg = $_.Exception.Message
        if ($Expected -and $msg -notmatch $Expected) {
            $script:Failed += "$($script:CurrentSuite)/$Name"
            Write-Host "  [FAIL] $Name (throw sai: $msg; expected: $Expected)"
        } else {
            $script:Passed += "$($script:CurrentSuite)/$Name"
            Write-Host "  [PASS] $Name"
        }
    }
}

function Describe {
    param([string]$Name)
    $script:CurrentSuite = $Name
    Write-Host ""
    Write-Host "=== Suite: $Name ==="
}

function Run-SuiteFile {
    param([string]$Path)
    $name = [System.IO.Path]::GetFileNameWithoutExtension($Path)
    Write-Host ""
    Write-Host "########## Test file: $name ##########"
    $script:CurrentSuite = $name
    . $Path
}

# === Collect test files ===
$testsDir = Join-Path $root "runtime\tests"
$files = @(Get-ChildItem -LiteralPath $testsDir -Filter "*.test.ps1" -File -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -like $Filter } | Sort-Object Name)

if ($files.Count -eq 0) {
    Write-Host "No test files found in $testsDir (pattern: $Filter)"
    Write-Host "Runner OK - 0 test files, 0 pass, 0 fail"
    exit 0
}

foreach ($f in $files) {
    Run-SuiteFile $f.FullName
}

# === Summary ===
Write-Host ""
Write-Host "============================================="
Write-Host "  RUNTIME TESTS RESULT"
Write-Host "  Files: $($files.Count)  Passed: $($script:Passed.Count)  Failed: $($script:Failed.Count)"
Write-Host "============================================="
if ($script:Failed.Count -gt 0) {
    Write-Host "  Failed:"
    $script:Failed | ForEach-Object { Write-Host "    [FAIL] $_" }
    exit 1
} else {
    Write-Host "  ALL PASS"
    exit 0
}
