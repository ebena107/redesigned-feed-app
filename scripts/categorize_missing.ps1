# Compare datasets and categorize missing ingredients
$old = Get-Content 'assets\raw\initial_ingredients.json' | ConvertFrom-Json
$new = Get-Content 'assets\raw\initial_ingredients_.json' | ConvertFrom-Json

$oldNames = $old | ForEach-Object { $_.name.Trim() }
$newNames = $new | ForEach-Object { $_.name.Trim() }

$missing = $oldNames | Where-Object { $_ -notin $newNames }

# Get full details of missing ingredients
$missingDetails = $old | Where-Object { $_.name.Trim() -in $missing }

# Group by category
$grouped = $missingDetails | Group-Object -Property category_id | Sort-Object Name

Write-Output "=== MISSING INGREDIENTS BY CATEGORY ==="
Write-Output ""

foreach ($group in $grouped) {
    $categoryName = switch ($group.Name) {
        "1" { "Cereal grains" }
        "2" { "Cereal by-products" }
        "3" { "Legume grains" }
        "4" { "Protein meals" }
        "5" { "Animal proteins" }
        "6" { "Fats and oils" }
        "7" { "Fats \u0026 oils" }
        "8" { "Minerals" }
        "9" { "Concentrates" }
        "10" { "Amino acids" }
        "11" { "Root and tuber products" }
        "12" { "Fruit by-products" }
        "13" { "Forages \u0026 roughages" }
        default { "Unknown ($($group.Name))" }
    }
    
    Write-Output "Category: $categoryName ($($group.Count) ingredients)"
    Write-Output "----------------------------------------"
    $group.Group | Sort-Object name | ForEach-Object {
        Write-Output "  - $($_.name)"
    }
    Write-Output ""
}

# Summary statistics
Write-Output "=== SUMMARY ==="
Write-Output "Total missing: $($missing.Count) ingredients"
Write-Output "Categories affected: $($grouped.Count)"
