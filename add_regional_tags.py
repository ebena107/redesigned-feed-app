#!/usr/bin/env python3
"""
Add regional tags to ingredients based on naming patterns.
Phase 4.6: Ingredient Database Regional Expansion
"""

import json
import re

# Regional patterns (name patterns -> region)
REGIONAL_PATTERNS = {
    # Africa & Asia
    r'(azolla|lemna|wolffia|cassava|moringa|cowpea|pigeon pea|bambara|locust bean|shea|plantain|banana)': 
        'Africa, Asia',
    
    # Africa specific
    r'(yam peel|teff|sesbania|gliricidia|elephant grass|napier|guinea grass|brachiaria)':
        'Africa',
    
    # Asia specific
    r'(rice bran|rice polish|taro|mung bean|water spinach|hyacinth)':
        'Asia',
    
    # Europe & Americas
    r'(barley|rapeseed|wheat|oats|rye|lupin|linseed|alfalfa|timothy|clover)':
        'Europe, Americas',
    
    # Americas & Global
    r'(corn|soybean|ddgs|sorghum|field pea)':
        'Americas, Global',
    
    # Global/Widespread
    r'(fishmeal|fish oil|meat and bone|feather meal|blood meal|premix|mineral|vitamin|limestone|phosphate|salt)':
        'Global',
    
    # Oceania & Seaweed
    r'(seaweed|kelp|copra|coconut|palm kernel)':
        'Oceania, Global',
}

def get_region(ingredient_name):
    """Determine region based on ingredient name."""
    name_lower = ingredient_name.lower()
    
    for pattern, region in REGIONAL_PATTERNS.items():
        if re.search(pattern, name_lower):
            return region
    
    return 'Global'  # Default

def main():
    # Load ingredients
    input_file = 'assets/raw/ingredients_standardized.json'
    output_file = 'assets/raw/ingredients_standardized.json'
    
    with open(input_file, 'r', encoding='utf-8') as f:
        ingredients = json.load(f)
    
    # Add region to each ingredient
    count = 0
    for ing in ingredients:
        region = get_region(ing.get('name', ''))
        ing['region'] = region
        count += 1
    
    # Save back
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(ingredients, f, indent=2, ensure_ascii=False)
    
    print(f'✅ Tagging complete! Updated {count} ingredients with regional tags.')
    
    # Show sample
    print('\nSample regional assignments:')
    for i, ing in enumerate(ingredients[:5]):
        print(f"  {ing['name']:40} → {ing['region']}")

if __name__ == '__main__':
    main()
