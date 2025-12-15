import json
import sys

# Set UTF-8 encoding for output
if sys.platform == 'win32':
    import io
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

# Load the JSON file
with open('assets/raw/initial_ingredients_.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

print('='*80)
print('COMPREHENSIVE INGREDIENT DATA VALIDATION REPORT')
print('='*80)
print(f'\nTotal ingredients: {len(data)}')
print(f'File: initial_ingredients_.json\n')

# 1. Check for duplicate IDs
ids = [ing.get('id') for ing in data]
duplicate_ids = [id for id in set(ids) if ids.count(id) > 1]

# 2. Check for missing required fields
required_fields = ['id', 'name', 'crude_protein', 'crude_fiber', 'crude_fat', 
                   'ash', 'moisture', 'energy', 'category', 'category_id']
missing_fields = []
for ing in data:
    for field in required_fields:
        if field not in ing:
            missing_fields.append(f"ID {ing.get('id', '?')}: missing '{field}'")

# 3. Check unit consistency
unit_issues = []
acceptable_exceptions = []

for ing in data:
    ing_id = ing.get('id', '?')
    ing_name = ing.get('name', 'Unknown')
    
    cp = ing.get('crude_protein', 0)
    cf = ing.get('crude_fiber', 0)
    fat = ing.get('crude_fat', 0)
    ash = ing.get('ash', 0)
    moisture = ing.get('moisture', 0)
    total = cp + cf + fat + ash + moisture
    
    # Urea is a special case - nitrogen equivalent
    if ing_id == 144:
        acceptable_exceptions.append(
            f"ID {ing_id:3d} | {ing_name:50s} | CP={cp:6.1f}% (N equivalent: 46% N x 6.25)"
        )
        continue
    
    # Check for values >100%
    if cp > 100:
        unit_issues.append(f"ID {ing_id:3d} | {ing_name:50s} | crude_protein = {cp:6.2f}%")
    if cf > 100:
        unit_issues.append(f"ID {ing_id:3d} | {ing_name:50s} | crude_fiber = {cf:6.2f}%")
    if fat > 100:
        unit_issues.append(f"ID {ing_id:3d} | {ing_name:50s} | crude_fat = {fat:6.2f}%")
    if ash > 100:
        unit_issues.append(f"ID {ing_id:3d} | {ing_name:50s} | ash = {ash:6.2f}%")
    if moisture > 100:
        unit_issues.append(f"ID {ing_id:3d} | {ing_name:50s} | moisture = {moisture:6.2f}%")
    
    # Check totals (allowing 5% tolerance for rounding/DM basis)
    if total > 105:
        unit_issues.append(f"ID {ing_id:3d} | {ing_name:50s} | TOTAL = {total:6.2f}%")

# 4. Check energy values
energy_issues = []
for ing in data:
    if 'energy' not in ing:
        continue
    energy = ing['energy']
    required_energy_fields = ['de_pig', 'me_pig', 'ne_pig', 'me_poultry', 
                               'me_ruminant', 'me_rabbit', 'de_salmonids']
    for field in required_energy_fields:
        if field not in energy:
            energy_issues.append(f"ID {ing.get('id', '?')}: missing energy.{field}")

# 5. Check amino acids structure
aa_issues = []
for ing in data:
    if 'amino_acids_total' in ing:
        aa_total = ing['amino_acids_total']
        if 'amino_acids_sid' not in ing:
            aa_issues.append(f"ID {ing.get('id', '?')}: has amino_acids_total but missing amino_acids_sid")

print('\n' + '='*80)
print('1. DUPLICATE ID CHECK')
print('='*80)
if duplicate_ids:
    print(f'[FAIL] Found {len(duplicate_ids)} duplicate IDs: {duplicate_ids}')
else:
    print('[PASS] No duplicate IDs found')

print('\n' + '='*80)
print('2. REQUIRED FIELDS CHECK')
print('='*80)
if missing_fields:
    print(f'[FAIL] Found {len(missing_fields)} missing required fields:')
    for issue in missing_fields[:10]:
        print(f'  {issue}')
else:
    print('[PASS] All ingredients have required fields')

print('\n' + '='*80)
print('3. UNIT CONSISTENCY CHECK')
print('='*80)
if unit_issues:
    print(f'[FAIL] Found {len(unit_issues)} unit consistency issues:')
    for issue in unit_issues:
        print(f'  {issue}')
else:
    print('[PASS] All ingredients have consistent units (percentages)')

if acceptable_exceptions:
    print(f'\n[INFO] Acceptable exceptions ({len(acceptable_exceptions)}):')
    for exc in acceptable_exceptions:
        print(f'  {exc}')

print('\n' + '='*80)
print('4. ENERGY VALUES CHECK')
print('='*80)
if energy_issues:
    print(f'[FAIL] Found {len(energy_issues)} energy field issues:')
    for issue in energy_issues[:10]:
        print(f'  {issue}')
else:
    print('[PASS] All ingredients have complete energy values')

print('\n' + '='*80)
print('5. AMINO ACIDS STRUCTURE CHECK')
print('='*80)
if aa_issues:
    print(f'[FAIL] Found {len(aa_issues)} amino acid structure issues:')
    for issue in aa_issues[:10]:
        print(f'  {issue}')
else:
    print('[PASS] All ingredients with amino acids have both total and SID values')

print('\n' + '='*80)
print('FINAL SUMMARY')
print('='*80)
total_issues = len(duplicate_ids) + len(missing_fields) + len(unit_issues) + len(energy_issues) + len(aa_issues)
if total_issues == 0:
    print('[SUCCESS] ALL VALIDATION CHECKS PASSED!')
    print(f'[SUCCESS] {len(data)} ingredients are ready for production use')
else:
    print(f'[WARNING] Found {total_issues} total issues that need attention')

print('='*80)
