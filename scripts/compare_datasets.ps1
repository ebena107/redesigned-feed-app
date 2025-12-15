# Compare ingredient datasets
$old = Get-Content 'assets\raw\initial_ingredients.json' | ConvertFrom-Json
$new = Get-Content 'assets\raw\initial_ingredients_.json' | ConvertFrom-Json

$oldNames = $old | ForEach-Object { $_.name.Trim() }
$newNames = $new | ForEach-Object { $_.name.Trim() }

$missing = $oldNames | Where-Object { $_ -notin $newNames }
$added = $newNames | Where-Object { $_ -notin $oldNames }

Write-Output "=== DATASET COMPARISON ==="
Write-Output ""
Write-Output "Old Dataset: $($old.Count) ingredients"
Write-Output "New Dataset: $($new.Count) ingredients"
Write-Output ""
Write-Output "Missing in New Dataset: $($missing.Count) ingredients"
Write-Output "Added in New Dataset: $($added.Count) ingredients"
Write-Output ""
Write-Output "=== MISSING INGREDIENTS ==="
$missing | Sort-Object | ForEach-Object { Write-Output $_ }
Write-Output ""
Write-Output "=== ADDED INGREDIENTS ==="
$added | Sort-Object | ForEach-Object { Write-Output $_ }
