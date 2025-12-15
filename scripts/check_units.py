import json

# Load the JSON file
with open('assets/raw/initial_ingredients_.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

print(f'Total ingredients: {len(data)}')
print('\n' + '='*80)
print('CHECKING UNIT CONSISTENCY (All values should be in %)')
print('='*80 + '\n')

issues = []

for ing in data:
    ing_id = ing.get('id', '?')
    ing_name = ing.get('name', 'Unknown')
    
    # Check proximate analysis - should all be percentages (0-100)
    cp = ing.get('crude_protein', 0)
    cf = ing.get('crude_fiber', 0)
    fat = ing.get('crude_fat', 0)
    ash = ing.get('ash', 0)
    moisture = ing.get('moisture', 0)
    
    if cp > 100:
        issues.append(f"ID {ing_id:3d} | {ing_name:50s} | crude_protein = {cp:8.2f} (>100%)")
    if cf > 100:
        issues.append(f"ID {ing_id:3d} | {ing_name:50s} | crude_fiber = {cf:8.2f} (>100%)")
    if fat > 100:
        issues.append(f"ID {ing_id:3d} | {ing_name:50s} | crude_fat = {fat:8.2f} (>100%)")
    if ash > 100:
        issues.append(f"ID {ing_id:3d} | {ing_name:50s} | ash = {ash:8.2f} (>100%)")
    if moisture > 100:
        issues.append(f"ID {ing_id:3d} | {ing_name:50s} | moisture = {moisture:8.2f} (>100%)")
    
    # Check if total exceeds 100% (allowing some tolerance for DM basis)
    total = cp + cf + fat + ash + moisture
    if total > 105:  # Allow 5% tolerance
        issues.append(f"ID {ing_id:3d} | {ing_name:50s} | TOTAL = {total:8.2f}% (sum exceeds 100%)")

if issues:
    print(f'Found {len(issues)} UNIT ISSUES:\n')
    for issue in issues:
        print(issue)
else:
    print('✓ All ingredients have consistent units (percentages)')
    print('✓ No values exceed 100%')
    print('✓ No totals exceed 105%')

print('\n' + '='*80)
print('SUMMARY')
print('='*80)
print(f'Total ingredients checked: {len(data)}')
print(f'Issues found: {len(issues)}')
