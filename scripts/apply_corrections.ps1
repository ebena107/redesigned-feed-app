# Phase 2: Apply Tier 1 Corrections to initial_ingredients.json

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
        name = "Fish meal, protein 62`%"
        field = "methionine"
        oldValue = 16.6
        newValue = 13.5
        reason = "Align with NRC standard"
    },
    @{
        name = "Fish meal, protein 65`%"
        field = "methionine"
        oldValue = 17.7
        newValue = 14.5
        reason = "Align with NRC standard"
    },
    @{
        name = "Fish meal, protein 70`%"
        field = "methionine"
        oldValue = 19.2
        newValue = 16.0
        reason = "Align with NRC standard"
    },
    @{
        name = "Sunflower hulls"
        field = "crude_fiber"
        oldValue = 52.3
        newValue = 50.0
        reason = "Within ASABE standard max"
    }
)

# Apply corrections
foreach ($correction in $corrections) {
    $ing = $json | Where-Object { $_.name -eq $correction.name }
    
    if ($ing) {
        $currentValue = $ing.($correction.field)
        
        if ($null -eq $currentValue) {
            Write-Host "FIELD NOT FOUND: $($correction.name): Field '$($correction.field)'" -ForegroundColor Red
        } elseif ([math]::Abs($currentValue - $correction.oldValue) -gt 0.01) {
            Write-Host "VALUE MISMATCH: $($correction.name): Expected $($correction.oldValue), found $($currentValue)" -ForegroundColor Yellow
        } else {
            if (-not $DryRun) {
                $ing.($correction.field) = $correction.newValue
                Write-Host "CORRECTED: $($correction.name): $($correction.field) $($correction.oldValue) to $($correction.newValue)" -ForegroundColor Green
            } else {
                Write-Host "DRY RUN: Would correct $($correction.name): $($correction.field) $($correction.oldValue) to $($correction.newValue)" -ForegroundColor Cyan
            }
        }
    } else {
        Write-Host "NOT FOUND: $($correction.name)" -ForegroundColor Red
    }
}

# Save if not dry run
if (-not $DryRun) {
    Write-Host ""
    Write-Host "Saving changes to $FilePath..." -ForegroundColor Yellow
    
    # Convert to JSON
    $jsonOutput = $json | ConvertTo-Json -Depth 100
    Set-Content -Path $FilePath -Value $jsonOutput -Encoding UTF8
    
    Write-Host "SAVED: File updated successfully" -ForegroundColor Green
    
    # Verify
    Write-Host ""
    Write-Host "Verification:" -ForegroundColor Cyan
    $json = Get-Content $FilePath | ConvertFrom-Json
    $json | Where-Object { $_.name -like "*Fish meal*" -or $_.name -like "*Sunflower*" } | ForEach-Object {
        Write-Host "$($_.name): fiber=$($_.crude_fiber) lysine=$($_.lysine) methionine=$($_.methionine)" -ForegroundColor Gray
    }
} else {
    Write-Host ""
    Write-Host "DRY RUN COMPLETE: No changes were made" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Done!" -ForegroundColor Green
