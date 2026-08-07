<#
.SYNOPSIS
    Policy Evaluator - quyet dinh allow/deny theo .opencode/policy/policies.yaml.

.DESCRIPTION
    Match: exact ("planning.task") hoac wildcard ("planning.*", "*").
    Deny thang allow (neu overlap). Default deny khi khong match.
    Exit 0 = allow, exit 1 = deny.

.EXAMPLE
    .opencode/scripts/governance/policy-evaluate.ps1 -Actor planner -Action planning.task     # allow
    .opencode/scripts/governance/policy-evaluate.ps1 -Actor planner -Action artifact.delete   # deny
    .opencode/scripts/governance/policy-evaluate.ps1 -Actor hacker -Action planning.task      # deny (default)
#>
param(
    [string]$Actor        = "",
    [string]$Action       = "",
    [string]$PoliciesPath = "",
    [switch]$Silent,
    [switch]$JsonOut
)
$ErrorActionPreference = "Stop"

function Read-Utf8([string]$path) {
    return [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8)
}

function ConvertFrom-SimpleYaml {
    param([string]$Text)
    $root = @{}
    $stack = New-Object System.Collections.ArrayList
    foreach ($line in ($Text -split "`r?`n")) {
        if ($line.Trim() -eq "") { continue }
        if ($line.Trim().StartsWith("#")) { continue }
        $indent = 0
        while ($indent -lt $line.Length -and $line[$indent] -eq " ") { $indent++ }
        $trimmed = $line.Trim()
        if ($trimmed -notmatch "^([^:]+):\s*(.*)$") { continue }
        $key = $Matches[1].Trim()
        $val = $Matches[2].Trim()
        while ($stack.Count -gt 0 -and $stack[$stack.Count-1].indent -ge $indent) {
            $stack.RemoveAt($stack.Count - 1)
        }
        $parent = if ($stack.Count -gt 0) { $stack[$stack.Count-1].node } else { $root }
        if ($val -eq "" -or $val -eq "|") {
            $child = @{}
            $parent[$key] = $child
            $null = $stack.Add(@{ indent = $indent; node = $child })
        }
        elseif ($val.StartsWith("[") -and $val.EndsWith("]")) {
            $items = @()
            foreach ($item in ($val.Substring(1, $val.Length - 2) -split ",")) {
                $items += $item.Trim().Trim('"').Trim("'")
            }
            $parent[$key] = $items
        }
        else {
            $parent[$key] = $val.Trim('"').Trim("'")
        }
    }
    return $root
}

function Test-Pattern {
    param([string]$Pattern, [string]$Action)
    if ($Pattern -eq "*") { return $true }
    if ($Pattern.EndsWith(".*")) {
        return $Action.StartsWith($Pattern.Substring(0, $Pattern.Length - 1))
    }
    return $Pattern -eq $Action
}

if (-not $Actor)  { Write-Error "Actor is required"; exit 1 }
if (-not $Action) { Write-Error "Action is required"; exit 1 }

$rootDir = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)   # .opencode/
if (-not $PoliciesPath) { $PoliciesPath = Join-Path $rootDir "policy\policies.yaml" }
if (-not (Test-Path -LiteralPath $PoliciesPath)) { Write-Error "policies not found: $PoliciesPath"; exit 1 }

$pol = ConvertFrom-SimpleYaml (Read-Utf8 $PoliciesPath)
if (-not $pol.ContainsKey("policies")) { Write-Error "no 'policies' key in $PoliciesPath"; exit 1 }

$subject = $pol.policies[$Actor]
if (-not $subject) {
    if (-not $Silent) { Write-Host "POLICY-EVALUATE deny actor='$Actor' action='$Action' (no policy for subject)" }
    exit 1
}

$deny = @($subject.deny | Where-Object { Test-Pattern $_ $Action })
if ($deny.Count -gt 0) {
    if (-not $Silent) { Write-Host "POLICY-EVALUATE deny actor='$Actor' action='$Action' matched='$($deny[0])'" }
    exit 1
}

$allow = @($subject.allow | Where-Object { Test-Pattern $_ $Action })
if ($allow.Count -gt 0) {
    if (-not $Silent) { Write-Host "POLICY-EVALUATE allow actor='$Actor' action='$Action' matched='$($allow[0])'" }
    exit 0
}

if (-not $Silent) { Write-Host "POLICY-EVALUATE deny actor='$Actor' action='$Action' (default deny)" }
exit 1