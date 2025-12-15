"""
Industry Standards Validation for Feed Ingredients
Compares ingredient data against:
- NRC 2012 (Swine)
- NRC 2016 (Poultry)
- CVB 2021 (Netherlands Feed Tables)
- INRA-AFZ 2018 (France)
- AMINODat 5.0 (Evonik)
"""

import json
import sys
import io

# Set UTF-8 encoding for output
if sys.platform == 'win32':
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

# Load our ingredient data
with open('assets/raw/initial_ingredients_.json', 'r', encoding='utf-8') as f:
    our_data = json.load(f)

print('='*100)
print('INDUSTRY STANDARDS VALIDATION REPORT')
print('='*100)
print(f'\nValidating {len(our_data)} ingredients against industry standards:')
print('  - NRC 2012 (Swine Nutrient Requirements)')
print('  - NRC 2016 (Poultry Nutrient Requirements)')
print('  - CVB 2021 (Netherlands Feed Tables)')
print('  - INRA-AFZ 2018 (France Feed Tables)')
print('  - AMINODat 5.0 (Evonik Amino Acid Database)\n')

# Define expected ranges for common ingredients based on industry standards
# Format: ingredient_name_pattern: {field: (min, max, source)}
INDUSTRY_STANDARDS = {
    'Maize': {
        'crude_protein': (7.0, 10.0, 'NRC 2012'),
        'crude_fiber': (1.8, 2.8, 'NRC 2012'),
        'crude_fat': (3.0, 4.5, 'NRC 2012'),
        'lysine_total': (2.2, 2.8, 'AMINODat 5.0'),
        'me_pig': (3200, 3400, 'NRC 2012'),
        'ne_pig': (2350, 2550, 'NRC 2012'),
    },
    'Corn': {
        'crude_protein': (7.0, 10.0, 'NRC 2012'),
        'crude_fiber': (1.8, 2.8, 'NRC 2012'),
        'crude_fat': (3.0, 4.5, 'NRC 2012'),
        'lysine_total': (2.2, 2.8, 'AMINODat 5.0'),
        'me_pig': (3200, 3400, 'NRC 2012'),
        'ne_pig': (2350, 2550, 'NRC 2012'),
    },
    'Soybean meal, 48%': {
        'crude_protein': (46.0, 49.0, 'NRC 2012'),
        'crude_fiber': (3.0, 4.5, 'NRC 2012'),
        'lysine_total': (29.0, 32.0, 'AMINODat 5.0'),
        'methionine_total': (6.5, 7.2, 'AMINODat 5.0'),
        'me_pig': (3300, 3550, 'NRC 2012'),
        'ne_pig': (2050, 2250, 'NRC 2012'),
    },
    'Wheat': {
        'crude_protein': (10.0, 13.5, 'NRC 2012'),
        'crude_fiber': (2.0, 3.0, 'CVB 2021'),
        'lysine_total': (3.0, 4.0, 'AMINODat 5.0'),
        'me_pig': (3250, 3450, 'NRC 2012'),
        'ne_pig': (2300, 2500, 'NRC 2012'),
    },
    'Barley': {
        'crude_protein': (10.0, 13.0, 'NRC 2012'),
        'crude_fiber': (4.5, 6.0, 'CVB 2021'),
        'lysine_total': (3.5, 4.5, 'AMINODat 5.0'),
        'me_pig': (2900, 3200, 'NRC 2012'),
        'ne_pig': (1950, 2150, 'NRC 2012'),
    },
    'Fish meal, 65%': {
        'crude_protein': (63.0, 68.0, 'NRC 2012'),
        'lysine_total': (48.0, 52.0, 'AMINODat 5.0'),
        'methionine_total': (17.5, 19.5, 'AMINODat 5.0'),
        'me_pig': (3400, 3800, 'NRC 2012'),
    },
    'Canola meal': {
        'crude_protein': (36.0, 40.0, 'NRC 2012'),
        'crude_fiber': (10.0, 13.0, 'CVB 2021'),
        'lysine_total': (19.0, 22.0, 'AMINODat 5.0'),
        'me_pig': (2700, 3000, 'NRC 2012'),
    },
    'Rice bran': {
        'crude_protein': (13.0, 17.0, 'INRA-AFZ 2018'),
        'crude_fiber': (9.0, 13.0, 'CVB 2021'),
        'me_pig': (2200, 2600, 'NRC 2012'),
    },
}

def find_matching_standard(ingredient_name):
    """Find matching industry standard for an ingredient"""
    for pattern, standards in INDUSTRY_STANDARDS.items():
        if pattern.lower() in ingredient_name.lower():
            return standards
    return None

def validate_value(value, min_val, max_val, tolerance=0.15):
    """
    Validate if value is within acceptable range
    tolerance: allow 15% deviation from standards (industry variation)
    """
    range_width = max_val - min_val
    adjusted_min = min_val - (range_width * tolerance)
    adjusted_max = max_val + (range_width * tolerance)
    
    if value < adjusted_min:
        return 'LOW', adjusted_min, adjusted_max
    elif value > adjusted_max:
        return 'HIGH', adjusted_min, adjusted_max
    else:
        return 'OK', adjusted_min, adjusted_max

# Validation results
validation_results = {
    'total_checked': 0,
    'passed': 0,
    'warnings': [],
    'critical': []
}

print('='*100)
print('VALIDATING KEY INGREDIENTS AGAINST STANDARDS')
print('='*100)
print('(Allowing 15% tolerance for natural variation)\n')

for ingredient in our_data:
    ing_id = ingredient.get('id')
    ing_name = ingredient.get('name', 'Unknown')
    
    # Find matching standard
    standards = find_matching_standard(ing_name)
    if not standards:
        continue
    
    validation_results['total_checked'] += 1
    has_issues = False
    issues = []
    
    print(f"\n{'='*100}")
    print(f"ID {ing_id}: {ing_name}")
    print(f"{'='*100}")
    
    # Check crude protein
    if 'crude_protein' in standards:
        cp = ingredient.get('crude_protein', 0)
        min_cp, max_cp, source = standards['crude_protein']
        status, adj_min, adj_max = validate_value(cp, min_cp, max_cp)
        
        print(f"  Crude Protein: {cp:6.2f}% | Expected: {min_cp:5.1f}-{max_cp:5.1f}% ({source}) | Status: {status}")
        if status != 'OK':
            issue = f"ID {ing_id} ({ing_name}): CP={cp:.1f}% outside range {adj_min:.1f}-{adj_max:.1f}% ({source})"
            issues.append(issue)
            has_issues = True
    
    # Check crude fiber
    if 'crude_fiber' in standards:
        cf = ingredient.get('crude_fiber', 0)
        min_cf, max_cf, source = standards['crude_fiber']
        status, adj_min, adj_max = validate_value(cf, min_cf, max_cf)
        
        print(f"  Crude Fiber:   {cf:6.2f}% | Expected: {min_cf:5.1f}-{max_cf:5.1f}% ({source}) | Status: {status}")
        if status != 'OK':
            issue = f"ID {ing_id} ({ing_name}): CF={cf:.1f}% outside range {adj_min:.1f}-{adj_max:.1f}% ({source})"
            issues.append(issue)
            has_issues = True
    
    # Check lysine
    if 'lysine_total' in standards:
        aa_total = ingredient.get('amino_acids_total', {})
        lys = aa_total.get('lysine', 0)
        min_lys, max_lys, source = standards['lysine_total']
        status, adj_min, adj_max = validate_value(lys, min_lys, max_lys)
        
        print(f"  Lysine (total):{lys:6.2f}  | Expected: {min_lys:5.1f}-{max_lys:5.1f}  ({source}) | Status: {status}")
        if status != 'OK':
            issue = f"ID {ing_id} ({ing_name}): Lysine={lys:.1f} outside range {adj_min:.1f}-{adj_max:.1f} ({source})"
            issues.append(issue)
            has_issues = True
    
    # Check ME pig
    if 'me_pig' in standards:
        energy = ingredient.get('energy', {})
        me = energy.get('me_pig', 0)
        min_me, max_me, source = standards['me_pig']
        status, adj_min, adj_max = validate_value(me, min_me, max_me)
        
        print(f"  ME Pig:      {me:7.0f}  | Expected: {min_me:5.0f}-{max_me:5.0f}  ({source}) | Status: {status}")
        if status != 'OK':
            issue = f"ID {ing_id} ({ing_name}): ME={me:.0f} outside range {adj_min:.0f}-{adj_max:.0f} ({source})"
            issues.append(issue)
            has_issues = True
    
    # Check NE pig
    if 'ne_pig' in standards:
        energy = ingredient.get('energy', {})
        ne = energy.get('ne_pig', 0)
        min_ne, max_ne, source = standards['ne_pig']
        status, adj_min, adj_max = validate_value(ne, min_ne, max_ne)
        
        print(f"  NE Pig:      {ne:7.0f}  | Expected: {min_ne:5.0f}-{max_ne:5.0f}  ({source}) | Status: {status}")
        if status != 'OK':
            issue = f"ID {ing_id} ({ing_name}): NE={ne:.0f} outside range {adj_min:.0f}-{adj_max:.0f} ({source})"
            issues.append(issue)
            has_issues = True
    
    if not has_issues:
        validation_results['passed'] += 1
        print(f"\n  [PASS] All values within acceptable ranges")
    else:
        # Categorize severity
        critical_keywords = ['lysine', 'methionine', 'me_pig', 'ne_pig', 'crude_protein']
        is_critical = any(keyword in issue.lower() for issue in issues for keyword in critical_keywords)
        
        if is_critical:
            validation_results['critical'].extend(issues)
            print(f"\n  [CRITICAL] {len(issues)} value(s) significantly outside expected ranges")
        else:
            validation_results['warnings'].extend(issues)
            print(f"\n  [WARNING] {len(issues)} value(s) outside expected ranges")

# Summary
print('\n' + '='*100)
print('VALIDATION SUMMARY')
print('='*100)
print(f"\nIngredients validated against standards: {validation_results['total_checked']}")
print(f"Passed all checks: {validation_results['passed']}")
print(f"Warnings: {len(validation_results['warnings'])}")
print(f"Critical issues: {len(validation_results['critical'])}")

if validation_results['critical']:
    print(f"\n{'='*100}")
    print('CRITICAL ISSUES (require immediate attention)')
    print('='*100)
    for issue in validation_results['critical']:
        print(f"  - {issue}")

if validation_results['warnings']:
    print(f"\n{'='*100}")
    print('WARNINGS (review recommended)')
    print('='*100)
    for issue in validation_results['warnings'][:10]:  # Show first 10
        print(f"  - {issue}")
    if len(validation_results['warnings']) > 10:
        print(f"  ... and {len(validation_results['warnings']) - 10} more warnings")

print(f"\n{'='*100}")
print('CONCLUSION')
print('='*100)

if validation_results['critical'] == 0 and validation_results['warnings'] == 0:
    print('[SUCCESS] All validated ingredients conform to industry standards!')
elif validation_results['critical'] == 0:
    print('[GOOD] No critical issues. Minor warnings are within acceptable variation.')
else:
    print('[ACTION REQUIRED] Critical issues found that should be reviewed.')

print('='*100)
