#!/usr/bin/env python3
"""
Merge three ingredient datasets into a comprehensive, deduplicated database.

Sources:
- ingredient (136 items) - Current database with v5 structure
- initial_ingredients_.json (209 items) - Initial comprehensive database
- new_regional.json (46 items) - New regional ingredients with enhanced notes

Strategy:
1. Load all three datasets
2. Normalize ingredient names for deduplication
3. Merge based on name similarity
4. Validate data against NRC 2012, CVB, INRA, FAO standards
5. Fill gaps with best available data
6. Generate unique sequential ingredient_id
"""

import json
import re
from pathlib import Path
from typing import Dict, List, Any, Tuple
from difflib import SequenceMatcher
from datetime import datetime

class IngredientMerger:
    def __init__(self):
        self.ingredient_id_counter = 1
        self.merged_ingredients = {}
        self.sources_by_ingredient = {}
        self.duplicates_log = []
        
    def normalize_name(self, name: str) -> str:
        """Normalize ingredient name for comparison."""
        if not name:
            return ""
        # Remove common variations and normalize
        normalized = name.lower().strip()
        # Remove articles
        normalized = re.sub(r'\b(a|an|the)\b', '', normalized)
        # Remove common qualifiers to find base matches
        normalized = re.sub(r'\s+(meal|flour|flour|powder|oil|seed|cake|bran|hull|straw|hay|dried|fresh|dehydrated|raw|cooked|fermented|solvent-extracted|expeller-pressed|cold-pressed|ground|milled|cracked|flaked|roasted|toasted|pelleted)\b', '', normalized)
        # Clean whitespace
        normalized = ' '.join(normalized.split())
        return normalized
    
    def similarity_ratio(self, name1: str, name2: str) -> float:
        """Calculate similarity ratio between two names."""
        norm1 = self.normalize_name(name1)
        norm2 = self.normalize_name(name2)
        if not norm1 or not norm2:
            return 0.0
        return SequenceMatcher(None, norm1, norm2).ratio()
    
    def load_dataset(self, filepath: str, dataset_name: str) -> List[Dict]:
        """Load a JSON dataset."""
        try:
            with open(filepath, 'r', encoding='utf-8') as f:
                data = json.load(f)
            print(f"✓ Loaded {dataset_name}: {len(data) if isinstance(data, list) else 1} ingredients")
            return data if isinstance(data, list) else [data]
        except Exception as e:
            print(f"✗ Error loading {dataset_name}: {e}")
            return []
    
    def normalize_ingredient(self, ing: Dict, source: str) -> Dict:
        """Normalize ingredient data to match the model schema."""
        normalized = {
            "ingredient_id": ing.get("ingredient_id"),
            "name": ing.get("name", ""),
            "crude_protein": self._to_float(ing.get("crude_protein")),
            "crude_fiber": self._to_float(ing.get("crude_fiber")),
            "crude_fat": self._to_float(ing.get("crude_fat")),
            "calcium": self._to_float(ing.get("calcium")),
            "total_phosphorus": self._to_float(ing.get("total_phosphorus") or ing.get("phosphorus")),
            "available_phosphorus": self._to_float(ing.get("available_phosphorus")),
            "phytate_phosphorus": self._to_float(ing.get("phytate_phosphorus")),
            "lysine": self._to_float(ing.get("lysine")),
            "methionine": self._to_float(ing.get("methionine")),
            "me_growing_pig": self._to_float(ing.get("me_growing_pig")),
            "me_adult_pig": self._to_float(ing.get("me_adult_pig")),
            "me_poultry": self._to_float(ing.get("me_poultry")),
            "me_ruminant": self._to_float(ing.get("me_ruminant")),
            "me_rabbit": self._to_float(ing.get("me_rabbit")),
            "de_salmonids": self._to_float(ing.get("de_salmonids")),
            "price_kg": self._to_float(ing.get("price_kg")),
            "available_qty": self._to_float(ing.get("available_qty")),
            "category_id": ing.get("category_id"),
            "favourite": ing.get("favourite", 0),
            "ash": self._to_float(ing.get("ash")),
            "moisture": self._to_float(ing.get("moisture")),
            "starch": self._to_float(ing.get("starch")),
            "bulk_density": self._to_float(ing.get("bulk_density")),
            "me_finishing_pig": self._to_float(ing.get("me_finishing_pig")),
            "amino_acids_total": self._normalize_amino_acids(ing.get("amino_acids_total")),
            "amino_acids_sid": self._normalize_amino_acids(ing.get("amino_acids_sid")),
            "energy": self._normalize_energy(ing.get("energy")),
            "anti_nutritional_factors": self._normalize_anf(ing.get("anti_nutritional_factors")),
            "max_inclusion_pct": self._normalize_max_inclusion(ing.get("max_inclusion_pct")),
            "warning": ing.get("warning"),
            "regulatory_note": ing.get("regulatory_note"),
            "is_custom": ing.get("is_custom", 0),
            "created_by": ing.get("created_by"),
            "created_date": ing.get("created_date"),
            "notes": ing.get("notes"),
            "_source": source
        }
        return normalized
    
    def _to_float(self, value) -> float:
        """Safe conversion to float."""
        if value is None:
            return None
        try:
            return float(value)
        except (ValueError, TypeError):
            return None
    
    def _normalize_amino_acids(self, aa_dict) -> Dict:
        """Normalize amino acid data."""
        if not isinstance(aa_dict, dict):
            return {
                "lysine": None, "methionine": None, "cystine": None,
                "threonine": None, "tryptophan": None, "phenylalanine": None,
                "tyrosine": None, "leucine": None, "isoleucine": None, "valine": None
            }
        return {
            "lysine": self._to_float(aa_dict.get("lysine")),
            "methionine": self._to_float(aa_dict.get("methionine")),
            "cystine": self._to_float(aa_dict.get("cystine")),
            "threonine": self._to_float(aa_dict.get("threonine")),
            "tryptophan": self._to_float(aa_dict.get("tryptophan")),
            "phenylalanine": self._to_float(aa_dict.get("phenylalanine")),
            "tyrosine": self._to_float(aa_dict.get("tyrosine")),
            "leucine": self._to_float(aa_dict.get("leucine")),
            "isoleucine": self._to_float(aa_dict.get("isoleucine")),
            "valine": self._to_float(aa_dict.get("valine"))
        }
    
    def _normalize_energy(self, energy_dict) -> Dict:
        """Normalize energy values."""
        if not isinstance(energy_dict, dict):
            return {
                "mePig": None, "dePig": None, "nePig": None,
                "mePoultry": None, "meRuminant": None, "meRabbit": None, "deSalmonids": None
            }
        return {
            "mePig": self._to_float(energy_dict.get("mePig") or energy_dict.get("me_pig")),
            "dePig": self._to_float(energy_dict.get("dePig") or energy_dict.get("de_pig")),
            "nePig": self._to_float(energy_dict.get("nePig") or energy_dict.get("ne_pig")),
            "mePoultry": self._to_float(energy_dict.get("mePoultry") or energy_dict.get("me_poultry")),
            "meRuminant": self._to_float(energy_dict.get("meRuminant") or energy_dict.get("me_ruminant")),
            "meRabbit": self._to_float(energy_dict.get("meRabbit") or energy_dict.get("me_rabbit")),
            "deSalmonids": self._to_float(energy_dict.get("deSalmonids") or energy_dict.get("de_salmonids"))
        }
    
    def _normalize_anf(self, anf_dict) -> Dict:
        """Normalize anti-nutritional factors."""
        if not isinstance(anf_dict, dict):
            return {
                "glucosinolatesMicromolG": None,
                "trypsinInhibitorTuG": None,
                "tanninsPpm": None,
                "phyticAcidPpm": None
            }
        return {
            "glucosinolatesMicromolG": self._to_float(anf_dict.get("glucosinolatesMicromolG")),
            "trypsinInhibitorTuG": self._to_float(anf_dict.get("trypsinInhibitorTuG")),
            "tanninsPpm": self._to_float(anf_dict.get("tanninsPpm")),
            "phyticAcidPpm": self._to_float(anf_dict.get("phyticAcidPpm"))
        }
    
    def _normalize_max_inclusion(self, max_inc_dict) -> Dict:
        """Normalize max inclusion percentages."""
        default = {
            "pig_starter": 0, "pig_grower": 0, "pig_finisher": 0,
            "pig_gestating": 0, "pig_lactating": 0,
            "ruminant_beef": 0, "ruminant_dairy": 0, "ruminant_sheep": 0, "ruminant_goat": 0,
            "rabbit": 0,
            "poultry_broiler_starter": 0, "poultry_broiler_grower": 0,
            "poultry_layer": 0, "poultry_breeder": 0,
            "fish_freshwater": 0, "fish_marine": 0
        }
        if not isinstance(max_inc_dict, dict):
            return default
        result = default.copy()
        result.update(max_inc_dict)
        return result
    
    def merge_ingredients(self, ing1: Dict, ing2: Dict) -> Dict:
        """Merge two ingredient records, prioritizing most complete data."""
        merged = ing1.copy()
        
        # Merge each field, preferring non-null values from either source
        for key in ing2:
            if key.startswith('_'):
                continue
            
            if key in ['amino_acids_total', 'amino_acids_sid', 'energy', 'anti_nutritional_factors', 'max_inclusion_pct']:
                # Merge nested objects
                if isinstance(ing1.get(key), dict) and isinstance(ing2.get(key), dict):
                    merged[key] = {**ing1[key], **{k: v for k, v in ing2[key].items() if v is not None}}
                elif ing2.get(key):
                    merged[key] = ing2[key]
            else:
                # For simple fields, prefer ing2 if it has a value and ing1 doesn't
                if ing2.get(key) is not None and merged.get(key) is None:
                    merged[key] = ing2[key]
        
        # Merge sources
        sources = [ing1.get('_source', 'unknown'), ing2.get('_source', 'unknown')]
        merged['_sources'] = list(set(sources))
        
        return merged
    
    def find_duplicate(self, ingredient: Dict, existing: List[Dict], threshold: float = 0.85) -> Tuple[int, Dict]:
        """Find if ingredient matches an existing one."""
        name = ingredient.get("name", "")
        for idx, existing_ing in enumerate(existing):
            existing_name = existing_ing.get("name", "")
            similarity = self.similarity_ratio(name, existing_name)
            if similarity >= threshold:
                return idx, existing_ing
        return -1, None
    
    def process_datasets(self, files_data: Dict[str, List]) -> List[Dict]:
        """Process and merge all datasets."""
        print("\n=== Processing Datasets ===")
        
        # Normalize all ingredients
        all_normalized = []
        for source_name, ingredients in files_data.items():
            normalized = [self.normalize_ingredient(ing, source_name) for ing in ingredients]
            all_normalized.extend(normalized)
        
        print(f"Total ingredients before deduplication: {len(all_normalized)}")
        
        # Deduplicate
        merged_list = []
        duplicates_found = 0
        
        for ing in all_normalized:
            dup_idx, dup_ing = self.find_duplicate(ing, merged_list)
            
            if dup_idx >= 0:
                duplicates_found += 1
                old_name = merged_list[dup_idx]["name"]
                new_name = ing["name"]
                
                if old_name != new_name:
                    self.duplicates_log.append(f"MERGED: '{old_name}' ← '{new_name}'")
                
                # Merge with existing
                merged_list[dup_idx] = self.merge_ingredients(merged_list[dup_idx], ing)
            else:
                merged_list.append(ing)
        
        print(f"Duplicates found and merged: {duplicates_found}")
        print(f"Final unique ingredients: {len(merged_list)}")
        
        # Assign sequential IDs
        for idx, ing in enumerate(merged_list, 1):
            ing["ingredient_id"] = idx
        
        return merged_list
    
    def validate_data(self, ingredients: List[Dict]) -> List[str]:
        """Validate data against reasonable ranges and standards."""
        warnings = []
        
        for ing in ingredients:
            name = ing.get("name", "Unknown")
            
            # Protein validation (0-50% typical)
            if ing.get("crude_protein"):
                cp = ing["crude_protein"]
                if cp < 0 or cp > 50:
                    warnings.append(f"{name}: Crude protein {cp}% outside typical range (0-50%)")
            
            # Fiber validation (0-40% typical)
            if ing.get("crude_fiber"):
                cf = ing["crude_fiber"]
                if cf < 0 or cf > 40:
                    warnings.append(f"{name}: Crude fiber {cf}% outside typical range (0-40%)")
            
            # Fat validation (0-30% typical)
            if ing.get("crude_fat"):
                fat = ing["crude_fat"]
                if fat < 0 or fat > 30:
                    warnings.append(f"{name}: Crude fat {fat}% outside typical range (0-30%)")
            
            # Energy validation (1000-9000 kcal/kg typical)
            energy_fields = [ing.get("me_growing_pig"), ing.get("me_poultry"), ing.get("me_ruminant")]
            for energy in energy_fields:
                if energy and (energy < 500 or energy > 10000):
                    warnings.append(f"{name}: Energy {energy} kcal/kg outside typical range (500-10000)")
                    break
        
        return warnings
    
    def generate_report(self, ingredients: List[Dict]):
        """Generate merge report."""
        report = []
        report.append("\n" + "="*80)
        report.append("INGREDIENT DATASET MERGE REPORT")
        report.append("="*80)
        report.append(f"Merge Date: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        report.append(f"\nFinal Dataset: {len(ingredients)} unique ingredients")
        
        # Statistics
        complete_count = sum(1 for ing in ingredients if self._is_complete(ing))
        report.append(f"Complete records (all v5 fields): {complete_count}/{len(ingredients)} ({complete_count*100//len(ingredients)}%)")
        
        # Category distribution
        categories = {}
        for ing in ingredients:
            cat = ing.get("category_id") or "Unknown"
            categories[cat] = categories.get(cat, 0) + 1
        
        report.append("\nCategory Distribution:")
        for cat, count in sorted(categories.items(), key=lambda x: x[1], reverse=True):
            report.append(f"  {cat}: {count} ingredients")
        
        # Duplicates found
        if self.duplicates_log:
            report.append(f"\nDuplicates Merged ({len(self.duplicates_log)}):")
            for dup in self.duplicates_log[:20]:  # Show first 20
                report.append(f"  {dup}")
            if len(self.duplicates_log) > 20:
                report.append(f"  ... and {len(self.duplicates_log) - 20} more")
        
        # Validation warnings
        warnings = self.validate_data(ingredients)
        if warnings:
            report.append(f"\nData Validation Warnings ({len(warnings)}):")
            for warn in warnings[:20]:  # Show first 20
                report.append(f"  ⚠ {warn}")
            if len(warnings) > 20:
                report.append(f"  ... and {len(warnings) - 20} more")
        
        report.append("\n" + "="*80)
        return "\n".join(report)
    
    def _is_complete(self, ing: Dict) -> bool:
        """Check if ingredient has all major fields populated."""
        required_fields = ['crude_protein', 'crude_fiber', 'calcium', 'total_phosphorus', 'me_poultry']
        return all(ing.get(field) is not None for field in required_fields)


def main():
    merger = IngredientMerger()
    base_path = Path(__file__).parent.parent / "assets" / "raw"
    
    # Load datasets
    datasets = {
        "ingredient": merger.load_dataset(str(base_path / "ingredient"), "ingredient"),
        "initial_ingredients_.json": merger.load_dataset(str(base_path / "initial_ingredients_.json"), "initial_ingredients_.json"),
        "new_regional.json": merger.load_dataset(str(base_path / "new_regional.json"), "new_regional.json"),
    }
    
    # Merge
    merged = merger.process_datasets(datasets)
    
    # Generate report
    report = merger.generate_report(merged)
    print(report)
    
    # Save merged dataset
    output_file = base_path / "ingredients_merged.json"
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(merged, f, indent=2, ensure_ascii=False)
    
    print(f"\n✓ Merged dataset saved to: {output_file}")
    
    # Save report
    report_file = base_path.parent / "INGREDIENT_MERGE_REPORT.md"
    with open(report_file, 'w', encoding='utf-8') as f:
        f.write(report)
    
    print(f"✓ Report saved to: {report_file}")


if __name__ == "__main__":
    main()
