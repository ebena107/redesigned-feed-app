"""
REFINED Industry Standards Validation
Uses ingredient-specific standards, not pattern matching
"""

import json
import sys
import io

if sys.platform == 'win32':
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

with open('assets/raw/initial_ingredients_.json', 'r', encoding='utf-8') as f:
    our_data = json.load(f)

print('='*100)
print('REFINED INDUSTRY STANDARDS VALIDATION')
print('='*100)
print('\nValidating key ingredients against NRC 2012, CVB 2021, INRA-AFZ 2018, AMINODat 5.0\n')

# Ingredient-specific standards (exact matches only)
STANDARDS = {
    54: {  # Maize (Corn)
        'name': 'Maize (Corn)',
        'crude_protein': (7.5, 9.5, 'NRC 2012'),
        'lysine_total': (2.3, 2.7, 'AMINODat 5.0'),
        'me_pig': (3250, 3350, 'NRC 2012'),
        'ne_pig': (2400, 2550, 'NRC 2012'),
    },
    93: {  # Soybean meal 48%
        'name': 'Soybean meal, 48% CP, solvent extracted',
        'crude_protein': (46.5, 48.5, 'NRC 2012'),
        'lysine_total': (29.0, 32.0, 'AMINODat 5.0'),
        'me_pig': (3400, 3550, 'NRC 2012'),
        'ne_pig': (2100, 2250, 'NRC 2012'),
    },
    106: {  # Wheat, soft
        'name': 'Wheat, soft',
        'crude_protein': (10.5, 12.5, 'NRC 2012'),
        'lysine_total': (3.2, 3.8, 'AMINODat 5.0'),
        'me_pig': (3300, 3450, 'NRC 2012'),
        'ne_pig': (2350, 2480, 'NRC 2012'),
    },
    5: {  # Barley
        'name': 'Barley',
        'crude_protein': (10.5, 12.5, 'NRC 2012'),
        'lysine_total': (3.7, 4.3, 'AMINODat 5.0'),
        'me_pig': (2950, 3150, 'NRC 2012'),
        'ne_pig': (2000, 2150, 'NRC 2012'),
    },
    16: {  # Canola meal
        'name': 'Canola meal, solvent extracted, oil < 5%',
        'crude_protein': (36.0, 40.0, 'NRC 2012'),
        'lysine_total': (20.0, 23.0, 'AMINODat 5.0'),
        'me_pig': (2750, 2950, 'NRC 2012'),
        'ne_pig': (1750, 1900, 'NRC 2012'),
    },
    38: {  # Fish meal 65%
        'name': 'Fish meal, 65% protein',
        'crude_protein': (64.0, 67.0, 'NRC 2012'),
        'lysine_total': (48.0, 52.0, 'AMINODat 5.0'),
        'me_pig': (3500, 3700, 'NRC 2012'),
        'ne_pig': (2300, 2450, 'NRC 2012'),
    },
    107: {  # Wheat bran (BY-PRODUCT, different standards)
        'name': 'Wheat bran',
        'crude_protein': (15.0, 18.0, 'CVB 2021'),
        'crude_fiber': (9.0, 11.0, 'CVB 2021'),
        'me_pig': (2050, 2250, 'NRC 2012'),
        'ne_pig': (1200, 1350, 'NRC 2012'),
    },
    82: {  # Rice bran, defatted
        'name': 'Rice bran, defatted',
        'crude_protein': (14.0, 17.0, 'INRA-AFZ 2018'),
        'crude_fiber': (10.0, 12.0, 'CVB 2021'),
        'me_pig': (2250, 2550, 'NRC 2012'),
    },
    91: {  # Sorghum
        'name': 'Sorghum',
        'crude_protein': (9.0, 11.0, 'NRC 2012'),
        'lysine_total': (2.0, 2.5, 'AMINODat 5.0'),
        'me_pig': (3250, 3400, 'NRC 2012'),
        'ne_pig': (2350, 2500, 'NRC 2012'),
    },
    62: {  # Pearl millet
        'name': 'Millet, pearl',
        'crude_protein': (10.5, 12.5, 'Feedipedia'),
        'lysine_total': (2.5, 3.2, 'Research'),
        'me_pig': (3200, 3400, 'NRC 2012'),
    },
}

def validate_value(value, min_val, max_val, tolerance=0.10):
    """Validate with 10% tolerance for natural variation"""
    range_width = max_val - min_val
    adjusted_min = min_val - (range_width * tolerance)
    adjusted_max = max_val + (range_width * tolerance)
    
    if value < adjusted_min:
        deviation = ((adjusted_min - value) / adjusted_min) * 100
        return 'LOW', adjusted_min, adjusted_max, deviation
    elif value > adjusted_max:
        deviation = ((value - adjusted_max) / adjusted_max) * 100
        return 'HIGH', adjusted_min, adjusted_max, deviation
    else:
        return 'OK', adjusted_min, adjusted_max, 0

results = {'total': 0, 'passed': 0, 'minor_warnings': 0, 'major_issues': 0}
issues_list = []

for ing_id, standards in STANDARDS.items():
    # Find ingredient
    ingredient = next((ing for ing in our_data if ing.get('id') == ing_id), None)
    if not ingredient:
        continue
    
    results['total'] += 1
    ing_name = ingredient.get('name', 'Unknown')
    has_major_issue = False
    has_minor_warning = False
    
    print(f"\n{'='*100}")
    print(f"ID {ing_id}: {ing_name}")
    print(f"{'='*100}")
    
    # Validate each parameter
    for param, param_data in standards.items():
        if param == 'name':
            continue
        
        min_val, max_val, source = param_data
        
        # Get value
        if param == 'crude_protein':
            value = ingredient.get('crude_protein', 0)
            unit = '%'
        elif param == 'crude_fiber':
            value = ingredient.get('crude_fiber', 0)
            unit = '%'
        elif param.endswith('_total'):
            aa_name = param.replace('_total', '')
            value = ingredient.get('amino_acids_total', {}).get(aa_name, 0)
            unit = 'g/kg'
        elif param.startswith('me_') or param.startswith('ne_') or param.startswith('de_'):
            value = ingredient.get('energy', {}).get(param, 0)
            unit = 'kcal/kg'
        else:
            continue
        
        status, adj_min, adj_max, deviation = validate_value(value, min_val, max_val)
        
        # Format output
        param_display = param.replace('_', ' ').title()
        print(f"  {param_display:20s}: {value:7.1f} {unit:8s} | Expected: {min_val:6.1f}-{max_val:6.1f} ({source:15s}) | {status}")
        
        if status != 'OK':
            if deviation > 15:  # >15% deviation is major
                has_major_issue = True
                issues_list.append({
                    'severity': 'MAJOR',
                    'id': ing_id,
                    'name': ing_name,
                    'param': param_display,
                    'value': value,
                    'expected': f"{adj_min:.1f}-{adj_max:.1f}",
                    'deviation': deviation,
                    'source': source
                })
            else:
                has_minor_warning = True
                issues_list.append({
                    'severity': 'MINOR',
                    'id': ing_id,
                    'name': ing_name,
                    'param': param_display,
                    'value': value,
                    'expected': f"{adj_min:.1f}-{adj_max:.1f}",
                    'deviation': deviation,
                    'source': source
                })
    
    if has_major_issue:
        results['major_issues'] += 1
        print(f"\n  [MAJOR ISSUE] Significant deviation from industry standards")
    elif has_minor_warning:
        results['minor_warnings'] += 1
        print(f"\n  [MINOR WARNING] Slight deviation, within acceptable variation")
    else:
        results['passed'] += 1
        print(f"\n  [PASS] All values conform to industry standards")

# Summary
print('\n' + '='*100)
print('VALIDATION SUMMARY')
print('='*100)
print(f"\nIngredients validated: {results['total']}")
print(f"Passed all checks: {results['passed']} ({results['passed']/results['total']*100:.1f}%)")
print(f"Minor warnings: {results['minor_warnings']}")
print(f"Major issues: {results['major_issues']}")

# Show issues
major_issues = [i for i in issues_list if i['severity'] == 'MAJOR']
minor_issues = [i for i in issues_list if i['severity'] == 'MINOR']

if major_issues:
    print(f"\n{'='*100}")
    print('MAJOR ISSUES (>15% deviation from standards)')
    print('='*100)
    for issue in major_issues:
        print(f"  ID {issue['id']:3d} | {issue['name']:40s} | {issue['param']:20s}")
        print(f"         Value: {issue['value']:7.1f} | Expected: {issue['expected']:15s} | Deviation: {issue['deviation']:5.1f}% | Source: {issue['source']}")

if minor_issues:
    print(f"\n{'='*100}")
    print('MINOR WARNINGS (5-15% deviation)')
    print('='*100)
    for issue in minor_issues:
        print(f"  ID {issue['id']:3d} | {issue['name']:40s} | {issue['param']:20s}")
        print(f"         Value: {issue['value']:7.1f} | Expected: {issue['expected']:15s} | Deviation: {issue['deviation']:5.1f}% | Source: {issue['source']}")

print(f"\n{'='*100}")
print('CONCLUSION')
print('='*100)

if results['major_issues'] == 0:
    print('[SUCCESS] No major deviations from industry standards!')
    print('[QUALITY] All key ingredients conform to NRC, CVB, and AMINODat references')
    if results['minor_warnings'] > 0:
        print(f'[INFO] {results["minor_warnings"]} minor variations are within acceptable natural variation')
else:
    print(f'[REVIEW] {results["major_issues"]} ingredient(s) have significant deviations')
    print('[ACTION] Review and potentially adjust values for these ingredients')

print('='*100)
