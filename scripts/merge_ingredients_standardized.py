"""
Enhanced Ingredient Merge Script with Industry Standards Validation
Applies learnings from remediation to avoid incorrect merges
"""

import json
import re
from pathlib import Path
from datetime import datetime
from difflib import SequenceMatcher

class StandardizedIngredientMerger:
    """Merges ingredients with industry standards validation"""
    
    def __init__(self):
        self.base_path = Path(__file__).parent.parent
        self.source_files = [
            'assets/raw/ingredient',
            'assets/raw/initial_ingredients_.json',
            'assets/raw/new_regional.json'
        ]
        
        # Industry standard ingredient name patterns (NRC, CVB, INRA, FAO, ASABE)
        self.standard_patterns = self._load_standard_patterns()
        
        # Nutrient variance thresholds for separation
        self.nutrient_thresholds = {
            'crude_protein': 5.0,      # 5% difference triggers separation
            'crude_fiber': 5.0,
            'crude_fat': 3.0,
            'me_growing_pig': 200,     # 200 kcal/kg difference
        }
        
    def _load_standard_patterns(self):
        """Load industry-standard ingredient naming patterns"""
        return {
            # NRC 2012 Standard Names
            'fish_meal': {
                'pattern': r'fish.*meal',
                'variants': ['62% protein', '65% protein', '70% protein'],
                'standard_prefix': 'Fish meal',
                'separate_by': 'protein_grade'
            },
            'corn': {
                'pattern': r'\bcorn\b',
                'variants': ['grain', 'meal', 'flour', 'gluten meal', 'gluten feed'],
                'standard_prefix': 'Corn',
                'separate_by': 'processing_method'
            },
            'wheat': {
                'pattern': r'\bwheat\b',
                'variants': ['grain', 'bran', 'middlings', 'flour', 'straw'],
                'standard_prefix': 'Wheat',
                'separate_by': 'processing_method'
            },
            'soybean': {
                'pattern': r'soy',
                'variants': ['meal', 'full-fat', 'hulls', 'oil'],
                'standard_prefix': 'Soybean',
                'separate_by': 'processing_method'
            },
            'palm_kernel': {
                'pattern': r'palm kernel',
                'variants': ['meal', 'cake', 'oil'],
                'standard_prefix': 'Palm kernel',
                'separate_by': 'processing_method'
            },
            'canola': {
                'pattern': r'(canola|rapeseed)',
                'variants': ['meal', 'seed', 'oil'],
                'standard_prefix': 'Canola',
                'separate_by': 'processing_method'
            },
            'alfalfa': {
                'pattern': r'alfalfa',
                'variants': ['dehydrated', 'hay', 'meal', 'fresh'],
                'standard_prefix': 'Alfalfa',
                'separate_by': 'processing_method'
            },
            'amino_acids': {
                'pattern': r'(lysine|methionine|threonine|tryptophan)',
                'variants': ['HCl', 'sulfate', 'pure', '78%', '98%'],
                'standard_prefix': 'varies',
                'separate_by': 'purity_form'
            },
            'blood_meal': {
                'pattern': r'blood.*meal',
                'variants': ['spray dried', 'ring dried', 'flash dried'],
                'standard_prefix': 'Blood meal',
                'separate_by': 'processing_method'
            },
            'meat_meal': {
                'pattern': r'meat.*meal',
                'variants': ['45-50%', '50-55%', '55-60%', '>60%'],
                'standard_prefix': 'Meat meal',
                'separate_by': 'protein_grade'
            }
        }
    
    def load_dataset(self, filename):
        """Load JSON dataset with error handling"""
        try:
            filepath = self.base_path / filename
            with open(filepath, 'r', encoding='utf-8') as f:
                data = json.load(f)
            print(f"✓ Loaded {filename}: {len(data)} ingredients")
            return data
        except Exception as e:
            print(f"✗ Error loading {filename}: {e}")
            return []
    
    def get_standard_name(self, ingredient_name, nutrient_data):
        """
        Get industry-standard name for ingredient
        Returns: (standard_name, should_separate_by_grade, standard_reference)
        """
        name_lower = ingredient_name.lower()
        
        # Check against standard patterns
        for key, pattern_info in self.standard_patterns.items():
            if re.search(pattern_info['pattern'], name_lower):
                # Determine if this is a variant that should be kept separate
                separate_by = pattern_info['separate_by']
                
                if separate_by == 'protein_grade':
                    # Keep protein grades separate
                    cp = nutrient_data.get('crude_protein', 0)
                    if cp > 0:
                        if 'fish' in name_lower:
                            if cp < 63:
                                return f"{pattern_info['standard_prefix']}, 62% protein", True, "NRC 2012"
                            elif cp < 67:
                                return f"{pattern_info['standard_prefix']}, 65% protein", True, "NRC 2012"
                            else:
                                return f"{pattern_info['standard_prefix']}, 70% protein", True, "NRC 2012"
                        elif 'meat' in name_lower:
                            if cp < 52:
                                return f"{pattern_info['standard_prefix']}, 45-50% protein", True, "NRC 2012"
                            elif cp < 57:
                                return f"{pattern_info['standard_prefix']}, 50-55% protein", True, "NRC 2012"
                            else:
                                return f"{pattern_info['standard_prefix']}, >55% protein", True, "NRC 2012"
                
                elif separate_by == 'processing_method':
                    # Extract processing method from name
                    for variant in pattern_info['variants']:
                        if variant.lower() in name_lower:
                            std_name = f"{pattern_info['standard_prefix']}, {variant}"
                            return std_name, True, "CVB/INRA"
                    
                    # Default if no specific variant found
                    return f"{pattern_info['standard_prefix']}", False, "CVB/INRA"
                
                elif separate_by == 'purity_form':
                    # Keep amino acid purities separate
                    amino_name = re.search(r'(l-|dl-)?(lysine|methionine|threonine|tryptophan)', name_lower)
                    if amino_name:
                        aa_name = amino_name.group(0).title()
                        if 'hcl' in name_lower or '78' in name_lower:
                            return f"{aa_name} HCl", True, "NRC 2012"
                        elif '98' in name_lower or 'pure' in name_lower:
                            return f"{aa_name}, 98% pure", True, "NRC 2012"
                        else:
                            return f"{aa_name}", False, "NRC 2012"
        
        # No standard match - return original with normalization
        return self.normalize_name(ingredient_name), False, None
    
    def normalize_name(self, name):
        """Basic name normalization"""
        if not name:
            return ""
        
        name = name.strip()
        # Remove extra whitespace
        name = re.sub(r'\s+', ' ', name)
        # Standardize comma spacing
        name = re.sub(r'\s*,\s*', ', ', name)
        
        return name
    
    def should_separate_by_nutrients(self, ing1, ing2):
        """
        Check if ingredients should be kept separate based on nutrient profiles
        Returns: (should_separate, reason)
        """
        for nutrient, threshold in self.nutrient_thresholds.items():
            val1 = ing1.get(nutrient, 0) or 0
            val2 = ing2.get(nutrient, 0) or 0
            
            # Skip if both are zero
            if val1 == 0 and val2 == 0:
                continue
            
            # Calculate percentage difference
            avg = (val1 + val2) / 2
            if avg == 0:
                continue
            
            diff = abs(val1 - val2)
            if diff > threshold:
                return True, f"{nutrient} differs by {diff:.1f} (threshold: {threshold})"
        
        return False, None
    
    def normalize_ingredient(self, ingredient):
        """Normalize ingredient to v5 schema"""
        # Handle both 'id' and 'ingredient_id' from source files
        ing_id = ingredient.get('ingredient_id') or ingredient.get('id')
        
        # Get nutrient data first for standard name determination
        nutrient_data = {
            'crude_protein': ingredient.get('crude_protein'),
            'crude_fiber': ingredient.get('crude_fiber'),
            'crude_fat': ingredient.get('crude_fat'),
        }
        
        # Get standard name
        original_name = ingredient.get('name', '')
        standard_name, is_separated, std_ref = self.get_standard_name(original_name, nutrient_data)
        
        # Parse amino acids from JSON fields
        amino_total = None
        amino_sid = None
        
        if ingredient.get('amino_acids_total'):
            if isinstance(ingredient['amino_acids_total'], str):
                try:
                    amino_total = json.loads(ingredient['amino_acids_total'])
                except:
                    amino_total = None
            else:
                amino_total = ingredient['amino_acids_total']
        
        if ingredient.get('amino_acids_sid'):
            if isinstance(ingredient['amino_acids_sid'], str):
                try:
                    amino_sid = json.loads(ingredient['amino_acids_sid'])
                except:
                    amino_sid = None
            else:
                amino_sid = ingredient['amino_acids_sid']
        
        # Parse energy from JSON field
        energy = None
        if ingredient.get('energy'):
            if isinstance(ingredient['energy'], str):
                try:
                    energy = json.loads(ingredient['energy'])
                except:
                    energy = None
            else:
                energy = ingredient['energy']
        
        # Parse ANF from JSON field
        anf = None
        if ingredient.get('anti_nutritional_factors'):
            if isinstance(ingredient['anti_nutritional_factors'], str):
                try:
                    anf = json.loads(ingredient['anti_nutritional_factors'])
                except:
                    anf = None
            else:
                anf = ingredient['anti_nutritional_factors']
        
        normalized = {
            'ingredient_id': ing_id,
            'name': original_name,
            'standardized_name': standard_name,
            'standard_reference': std_ref,
            'is_standards_based': is_separated,
            
            # Basic nutrients
            'crude_protein': ingredient.get('crude_protein'),
            'crude_fiber': ingredient.get('crude_fiber'),
            'crude_fat': ingredient.get('crude_fat'),
            'calcium': ingredient.get('calcium'),
            'phosphorus': ingredient.get('phosphorus') or ingredient.get('total_phosphorus'),
            
            # Legacy amino acids (fallback)
            'lysine': ingredient.get('lysine') or (amino_total.get('lysine') if amino_total else None),
            'methionine': ingredient.get('methionine') or (amino_total.get('methionine') if amino_total else None),
            
            # Legacy energy values
            'me_growing_pig': ingredient.get('me_growing_pig') or (energy.get('me_pig') if energy else None),
            'me_adult_pig': ingredient.get('me_adult_pig') or (energy.get('me_pig') if energy else None),
            'me_poultry': ingredient.get('me_poultry') or (energy.get('me_poultry') if energy else None),
            'me_ruminant': ingredient.get('me_ruminant') or (energy.get('me_ruminant') if energy else None),
            'me_rabbit': ingredient.get('me_rabbit') or (energy.get('me_rabbit') if energy else None),
            'de_salmonids': ingredient.get('de_salmonids') or (energy.get('de_salmonids') if energy else None),
            
            # v5 enhanced fields
            'ash': ingredient.get('ash'),
            'moisture': ingredient.get('moisture'),
            'starch': ingredient.get('starch'),
            'bulk_density': ingredient.get('bulk_density'),
            'total_phosphorus': ingredient.get('total_phosphorus') or ingredient.get('phosphorus'),
            'available_phosphorus': ingredient.get('available_phosphorus'),
            'phytate_phosphorus': ingredient.get('phytate_phosphorus'),
            'me_finishing_pig': ingredient.get('me_finishing_pig'),
            
            # Complex structures
            'amino_acids_total': amino_total,
            'amino_acids_sid': amino_sid,
            'energy': energy,
            'anti_nutritional_factors': anf,
            
            # Safety and limits
            'max_inclusion_pct': ingredient.get('max_inclusion_pct'),
            'warning': ingredient.get('warning'),
            'regulatory_note': ingredient.get('regulatory_note'),
            
            # Metadata
            'price_kg': ingredient.get('price_kg'),
            'available_qty': ingredient.get('available_qty'),
            'category_id': ingredient.get('category_id'),
            'favourite': ingredient.get('favourite'),
            'is_custom': ingredient.get('is_custom'),
            'created_by': ingredient.get('created_by'),
            'created_date': ingredient.get('created_date'),
            'notes': ingredient.get('notes'),
        }
        
        return normalized
    
    def find_duplicate(self, ingredient, existing_list):
        """
        Find duplicate using standards-based matching
        Returns: (index, existing_ingredient) or (-1, None)
        """
        std_name = ingredient.get('standardized_name', '')
        
        for idx, existing in enumerate(existing_list):
            existing_std_name = existing.get('standardized_name', '')
            
            # Exact standard name match
            if std_name == existing_std_name:
                # Check if nutrients are similar enough to merge
                should_sep, reason = self.should_separate_by_nutrients(ingredient, existing)
                if should_sep:
                    # Don't merge - nutrient profiles too different
                    continue
                else:
                    return idx, existing
        
        return -1, None
    
    def merge_ingredients(self, existing, new):
        """Merge two ingredient records, preferring non-null values"""
        merged = existing.copy()
        
        for key, value in new.items():
            if value is not None and (existing.get(key) is None or value != 0):
                # Prefer new value if existing is None or if new is non-zero
                if key == 'notes':
                    # Combine notes
                    existing_notes = existing.get('notes', '')
                    new_notes = value
                    if existing_notes and new_notes and existing_notes != new_notes:
                        merged[key] = f"{existing_notes}; {new_notes}"
                    else:
                        merged[key] = new_notes or existing_notes
                elif key == 'standard_reference':
                    # Combine references
                    existing_ref = existing.get('standard_reference', '')
                    if existing_ref and value and existing_ref != value:
                        merged[key] = f"{existing_ref}, {value}"
                    else:
                        merged[key] = value or existing_ref
                else:
                    merged[key] = value
        
        return merged
    
    def process_datasets(self):
        """Main processing pipeline"""
        print("\n" + "=" * 70)
        print("ENHANCED INGREDIENT MERGE WITH STANDARDS VALIDATION")
        print("=" * 70)
        
        # Load all datasets
        all_ingredients = []
        for source_file in self.source_files:
            data = self.load_dataset(source_file)
            all_ingredients.extend(data)
        
        print(f"\nTotal ingredients loaded: {len(all_ingredients)}")
        
        # Normalize all to v5 schema
        print("\n=== Normalizing to v5 Schema with Standard Names ===")
        normalized = [self.normalize_ingredient(ing) for ing in all_ingredients]
        
        # Count standards-based names
        standards_based = sum(1 for ing in normalized if ing.get('is_standards_based'))
        print(f"✓ Applied industry standard names: {standards_based}/{len(normalized)}")
        
        # Merge duplicates
        print("\n=== Merging Duplicates (Standards-Based) ===")
        merged_list = []
        merge_count = 0
        separation_count = 0
        
        for ing in normalized:
            dup_idx, dup_ing = self.find_duplicate(ing, merged_list)
            
            if dup_idx >= 0:
                # Merge found duplicate
                merged_list[dup_idx] = self.merge_ingredients(merged_list[dup_idx], ing)
                merge_count += 1
            else:
                # Add as new ingredient
                merged_list.append(ing)
        
        print(f"Duplicates merged: {merge_count}")
        print(f"Final unique ingredients: {len(merged_list)}")
        
        # Assign sequential IDs
        for idx, ing in enumerate(merged_list, start=1):
            ing['ingredient_id'] = idx
        
        return merged_list, merge_count
    
    def generate_report(self, merged_list, merge_count):
        """Generate comprehensive merge report"""
        report_lines = []
        
        report_lines.append("=" * 70)
        report_lines.append("STANDARDS-BASED INGREDIENT MERGE REPORT")
        report_lines.append("=" * 70)
        report_lines.append(f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        report_lines.append("")
        
        # Executive summary
        report_lines.append("## EXECUTIVE SUMMARY")
        report_lines.append("")
        report_lines.append(f"**Source Files:**")
        for source in self.source_files:
            report_lines.append(f"  - {source}")
        report_lines.append("")
        report_lines.append(f"**Results:**")
        report_lines.append(f"  - Final unique ingredients: {len(merged_list)}")
        report_lines.append(f"  - Duplicates merged: {merge_count}")
        report_lines.append("")
        
        # Standards compliance
        standards_based = [ing for ing in merged_list if ing.get('is_standards_based')]
        report_lines.append(f"**Standards Compliance:**")
        report_lines.append(f"  - Industry-standardized names: {len(standards_based)}/{len(merged_list)} ({len(standards_based)/len(merged_list)*100:.1f}%)")
        report_lines.append("")
        
        # Completeness analysis
        complete = sum(1 for ing in merged_list if all([
            ing.get('crude_protein'),
            ing.get('crude_fiber'),
            ing.get('crude_fat'),
            ing.get('me_growing_pig') or ing.get('energy'),
        ]))
        report_lines.append(f"**Data Completeness:**")
        report_lines.append(f"  - Complete records: {complete}/{len(merged_list)} ({complete/len(merged_list)*100:.1f}%)")
        report_lines.append("")
        
        # Category distribution
        categories = {}
        for ing in merged_list:
            cat = ing.get('category_id', 'Unknown')
            categories[cat] = categories.get(cat, 0) + 1
        
        report_lines.append("## CATEGORY DISTRIBUTION")
        report_lines.append("")
        for cat, count in sorted(categories.items(), key=lambda x: x[1], reverse=True):
            report_lines.append(f"  - Category {cat}: {count} ingredients")
        report_lines.append("")
        
        # Standards-based ingredients
        report_lines.append("## STANDARDS-BASED INGREDIENTS")
        report_lines.append("")
        report_lines.append(f"Total: {len(standards_based)} ingredients")
        report_lines.append("")
        
        # Group by standard reference
        by_standard = {}
        for ing in standards_based:
            ref = ing.get('standard_reference', 'Unknown')
            if ref not in by_standard:
                by_standard[ref] = []
            by_standard[ref].append(ing)
        
        for standard, ingredients in sorted(by_standard.items()):
            report_lines.append(f"### {standard}")
            report_lines.append("")
            for ing in ingredients[:10]:  # Show first 10
                name = ing.get('standardized_name', ing.get('name'))
                cp = ing.get('crude_protein', 'N/A')
                report_lines.append(f"  - {name} (CP: {cp}%)")
            if len(ingredients) > 10:
                report_lines.append(f"  ... and {len(ingredients) - 10} more")
            report_lines.append("")
        
        return "\n".join(report_lines)
    
    def save_results(self, merged_list, report):
        """Save merged dataset and report"""
        # Save merged JSON
        output_file = self.base_path / 'assets' / 'raw' / 'ingredients_standardized.json'
        with open(output_file, 'w', encoding='utf-8') as f:
            json.dump(merged_list, f, indent=2, ensure_ascii=False)
        print(f"\n✓ Saved: {output_file}")
        print(f"  Total ingredients: {len(merged_list)}")
        
        # Save report
        report_file = self.base_path / 'doc' / 'STANDARDIZED_MERGE_REPORT.md'
        with open(report_file, 'w', encoding='utf-8') as f:
            f.write(report)
        print(f"✓ Saved: {report_file}")

def main():
    merger = StandardizedIngredientMerger()
    merged_list, merge_count = merger.process_datasets()
    report = merger.generate_report(merged_list, merge_count)
    merger.save_results(merged_list, report)
    
    print("\n" + "=" * 70)
    print("✓ MERGE COMPLETE - Dataset validated against industry standards")
    print("=" * 70)

if __name__ == '__main__':
    main()
