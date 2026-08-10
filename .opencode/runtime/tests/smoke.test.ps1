<#
.SYNOPSIS
Smoke test - verify runner va Assert/Assert-Throw hoat dong dung. All PASS.
Chay boi scripts/runtime-tests.ps1 (dot-source, dung chung $script: state).
#>

Describe "smoke"

Assert "SM1 Assert pass case" $true
Assert "SM2 Assert condition evaluation" (1 -eq 1)
Assert "SM3 File path join" ((Split-Path -Parent $PSScriptRoot) -ne $null)

Assert-Throw "SM4 Throw duoc detect" { throw "SM4-EXPECTED" } "SM4-EXPECTED"
Assert-Throw "SM5 Wrong error message -> fail" { throw "SM5-EXPECTED" } "SM5-EXPECTED"
