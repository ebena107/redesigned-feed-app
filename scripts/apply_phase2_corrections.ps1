# Phase 2: Apply Tier 1 Corrections to initial_ingredients.json
# This script updates fish meal methionine values and sunflower hulls fiber

param(
    [string]$FilePath = "assets/raw/initial_ingredients.json",
    [switch]$DryRun = $false
)

Write-Host "Phase 2: Applying Ingredient Corrections" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Load JSON
Write-Host "Loading $FilePath..." -ForegroundColor Yellow
$json = Get-Content $FilePath | ConvertFrom-Json

# Track changes
$changes = @()

# Define corrections
$corrections = @(
    @{
        name = "Fish meal, protein 62%"
        field = "methionine"
        oldValue = 16.6
        newValue = 13.5
        reason = "Align with NRC standard (lysine ratio)"
    },
    @{
        name = "Fish meal, protein 65%"
        field = "methionine"
        oldValue = 17.7
        newValue = 14.5
        reason = "Align with NRC standard (lysine ratio)"
    },
    @{
        name = "Fish meal, protein 70%"
        field = "methionine"
        oldValue = 19.2
        newValue = 16.0
        reason = "Align with NRC standard (lysine ratio)"
    },
    @{
        name = "Sunflower hulls"
        field = "crude_fiber"
        oldValue = 52.3
        newValue = 50.0
        reason = "Within ASABE standard max (50%)"
    }
)

# Apply corrections
foreach ($correction in $corrections) {
    $ing = $json | Where-Object { $_.name -eq $correction.name }
    
    if ($ing) {
        $currentValue = $ing.($correction.field)
        $change = @{
            name = $correction.name
            field = $correction.field
            oldValue = $currentValue
            newValue = $correction.newValue
            reason = $correction.reason
            status = "FOUND"
        }
        
        if ($null -eq $currentValue) {
            $change.status = "FIELD NOT FOUND"
            Write-Host "✗ $($correction.name): Field '$($correction.field)' not found" -ForegroundColor Red
        } elseif ([math]::Abs($currentValue - $correction.oldValue) > 0.01) {
            $change.status = "VALUE MISMATCH"
            Write-Host "⚠ $($correction.name): Expected $($correction.oldValue), found $($currentValue)" -ForegroundColor Yellow
        } else {
            if (-not $DryRun) {
                $ing.($correction.field) = $correction.newValue
                Write-Host "✓ $($correction.name): $($correction.field) $($correction.oldValue) → $($correction.newValue)" -ForegroundColor Green
                $change.status = "CORRECTED"
            } else {
                Write-Host "→ [DRY RUN] Would correct $($correction.name): $($correction.field) $($correction.oldValue) → $($correction.newValue)" -ForegroundColor Cyan
                $change.status = "DRY RUN"
            }
        }
        
        $changes += $change
    } else {
        Write-Host "✗ $($correction.name): Ingredient not found" -ForegroundColor Red
        $changes += @{
            name = $correction.name
            field = $correction.field
            oldValue = $correction.oldValue
            newValue = $correction.newValue
            reason = $correction.reason
            status = "NOT FOUND"
        }
    }
}

Write-Host ""
Write-Host "Summary:" -ForegroundColor Cyan
Write-Host "--------" -ForegroundColor Cyan
$changes | ForEach-Object {
    $statusColor = switch ($_.status) {
        "CORRECTED" { "Green" }
        "DRY RUN" { "Cyan" }
        "NOT FOUND" { "Red" }
        "FIELD NOT FOUND" { "Red" }
        "VALUE MISMATCH" { "Yellow" }
        default { "Gray" }
    }
    Write-Host "$($_.status): $($_.name) - $($_.field)" -ForegroundColor $statusColor
}

# Save if not dry run
if (-not $DryRun) {
    Write-Host ""
    Write-Host "Saving changes to $FilePath..." -ForegroundColor Yellow
    
    # Convert to JSON with proper formatting
    $jsonOutput = $json | ConvertTo-Json -Depth 100
    
    # Ensure proper JSON formatting (the default is readable)
    Set-Content -Path $FilePath -Value $jsonOutput -Encoding UTF8
    
    Write-Host "✓ File saved successfully" -ForegroundColor Green
    
    # Verify
    Write-Host ""
    Write-Host "Verification - Updated values:" -ForegroundColor Cyan
    $json = Get-Content $FilePath | ConvertFrom-Json
    $json | Where-Object { $_.name -like "*Fish meal*" -or $_.name -like "*Sunflower hulls*" } | Select-Object name, crude_fiber, lysine, methionine | ConvertTo-Json
} else {
    Write-Host ""
    Write-Host "DRY RUN: No changes were made" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Done!" -ForegroundColor Green
