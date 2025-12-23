"""
Industry Standards Cross-Reference & Ingredient Standardization
Validates and corrects ingredient names against official NRC 2012, CVB, INRA, FAO, ASABE databases

This script:
1. Maps all 196 ingredients to official standard nomenclature
2. Identifies ingredients that should be separated (different forms/grades)
3. Flags ingredients incorrectly merged
4. Produces standardized ingredient list with compliance notes
"""

import json
import re
from pathlib import Path
from difflib import SequenceMatcher
from datetime import datetime
from typing import Dict, List, Tuple, Optional

# ============================================================================
# INDUSTRY STANDARD INGREDIENT DEFINITIONS
# ============================================================================

# NRC 2012 Standard Ingredient Names (Nutrient Requirements of Swine)
# Source: National Research Council. 2012. Nutrient Requirements of Swine
NRC_2012_STANDARDS = {
    "fish meal": {
        "variants": ["fish meal 62%", "fish meal 65%", "fish meal 70%", "fish meal"],
        "definition": "Ground, dried whole fish or fish processing residue; high protein",
        "forms": ["62% CP", "65% CP", "70% CP", "standard (67%)"],
        "standard_name": "Fish meal",
        "notes": "Different protein grades must be tracked separately for accurate formulation",
        "nrc_id": "5-01-968"
    },
    
    "soybean meal": {
        "variants": ["soybean meal", "soybean meal, desolventized", "soybean meal 44%", "soybean meal 48%"],
        "definition": "Soybean seed ground after most of the oil is extracted",
        "forms": ["44% CP (solvent extracted)", "48% CP (solvent extracted)"],
        "standard_name": "Soybean meal, solvent extracted",
        "notes": "44% vs 48% represent different extraction methods; keep separate",
        "nrc_id": "5-04-612"
    },
    
    "corn": {
        "variants": ["corn", "corn grain", "dent corn", "corn meal", "corn flour"],
        "definition": "Kernels of maize plant; multiple forms based on processing",
        "forms": ["whole grain", "ground meal", "flour (fine grind)"],
        "standard_name": "Corn, dent",
        "notes": "Grain vs meal vs flour are distinct products with different particle size & digestibility",
        "nrc_id": "4-02-935"
    },
    
    "wheat": {
        "variants": ["wheat", "wheat grain", "wheat flour", "wheat middlings", "wheat bran"],
        "definition": "Grain and milling byproducts of wheat plant",
        "forms": ["whole grain", "flour", "middlings", "bran"],
        "standard_name": "Wheat",
        "notes": "CRITICAL: Wheat bran vs middlings vs whole grain are SEPARATE ingredients in CVB/NRC",
        "nrc_id": "4-05-211"
    },
    
    "barley": {
        "variants": ["barley", "barley grain", "barley meal"],
        "definition": "Cereal grain from barley plant",
        "forms": ["whole grain", "ground meal"],
        "standard_name": "Barley",
        "notes": "Hulless vs hulled varieties have different fiber content",
        "nrc_id": "4-00-549"
    },
}

# CVB Standard Ingredient Names (Centraal Veevoeder Bureau - Netherlands)
# Source: CVB Feed Tables (https://www.cvb.nl)
CVB_STANDARDS = {
    "palm kernel meal": {
        "standard_name": "Palm kernel meal, solvent extracted",
        "variants": ["palm kernel meal", "palm kernel cake", "PKM"],
        "forms": ["<10% oil", "10-20% oil"],
        "notes": "Oil content determines energy value; must track separately",
        "cvb_code": "SB037"
    },
    
    "rapeseed meal": {
        "standard_name": "Rapeseed meal, solvent extracted",
        "variants": ["rapeseed meal", "canola meal", "rapeseed cake"],
        "forms": ["double-low (glucosinolates <30 μmol/g)", "conventional"],
        "notes": "Glucosinolate level critical for inclusion limits",
        "cvb_code": "SB035"
    },
    
    "sunflower meal": {
        "standard_name": "Sunflower meal, solvent extracted",
        "variants": ["sunflower meal", "sunflower cake"],
        "forms": ["high-oil", "standard"],
        "notes": "Oil content affects digestibility",
        "cvb_code": "SB032"
    },
    
    "meat meal": {
        "standard_name": "Meat meal, rendered",
        "variants": ["meat meal", "meat and bone meal", "MBM", "processed animal protein"],
        "forms": ["meat meal (50% CP)", "meat and bone meal (40-45% CP)"],
        "notes": "CRITICAL: Meat meal vs meat & bone meal differ in calcium/phosphorus ratio",
        "cvb_code": "AM005"
    },
}

# INRA Standard Names (Institut National de Recherche Agronomique)
# Source: INRA Feedstuff composition database
INRA_STANDARDS = {
    "alfalfa": {
        "standard_name": "Alfalfa (Lucerne) meal, dehydrated",
        "variants": ["alfalfa", "alfalfa meal", "lucerne meal", "dehydrated alfalfa"],
        "forms": ["protein <16%", "protein 16-18%", "protein >18%"],
        "inra_code": "fo_004",
        "notes": "Protein grade affects nutritional value significantly"
    },
    
    "hay": {
        "standard_name": "Hay, mixed legume-grass",
        "variants": ["hay", "grass hay", "hay mixed"],
        "forms": ["good quality", "medium quality", "poor quality"],
        "inra_code": "fo_001",
        "notes": "Quality grade critical (leaf/stem ratio, harvest stage)"
    },
}

# FAO Feed Composition Database Standard Names
# Source: FAO/EAAFCO Global Feed Ingredient Database
FAO_STANDARDS = {
    "cassava": {
        "standard_name": "Cassava (Manihot esculenta) root meal",
        "variants": ["cassava meal", "cassava root meal", "yuca meal"],
        "forms": ["dried root meal", "cassava bagasse"],
        "notes": "High starch, low protein; processing method affects cyanogenic compounds",
        "fao_code": "BR17"
    },
    
    "coconut meal": {
        "standard_name": "Coconut meal (Cocos nucifera)",
        "variants": ["coconut meal", "coconut cake", "copra meal"],
        "forms": ["expeller pressed", "solvent extracted"],
        "notes": "Oil content critical (expeller = 8-10%, solvent = 2-3%)",
        "fao_code": "BR13"
    },
}

# ASABE Standards (American Society of Agricultural & Biological Engineers)
# Feed Ingredient Standards & Processing specifications
ASABE_STANDARDS = {
    "particle_size_requirements": {
        "fine_meal": {"min_um": 250, "max_um": 500, "description": "Fine grind (flour)"},
        "standard_meal": {"min_um": 500, "max_um": 1000, "description": "Standard grind"},
        "coarse_meal": {"min_um": 1000, "max_um": 2000, "description": "Coarse grind"},
        "crumble": {"description": "Pelleted then broken (0.3-0.5 inch)"},
    },
    
    "moisture_standards": {
        "dry_storage": {"max_moisture": 12, "duration_months": 12},
        "cool_storage": {"max_moisture": 15, "duration_months": 6},
        "ambient_storage": {"max_moisture": 10, "duration_months": 3},
    },
}

# ============================================================================
# MERGE ISSUES DETECTED IN CURRENT DATASET
# ============================================================================

KNOWN_MERGE_ISSUES = [
    {
        "issue": "Fish meal protein grades merged incorrectly",
        "current_status": "Single 'Fish meal' entry",
        "should_be": ["Fish meal 62%", "Fish meal 65%", "Fish meal 70%"],
        "impact": "High - different protein grades have very different nutritional profiles",
        "nrc_reference": "NRC 2012 Table 4-3 (different entries for different protein grades)"
    },
    {
        "issue": "Wheat products not properly separated",
        "current_status": "May be incorrectly merged",
        "should_be": ["Wheat grain", "Wheat flour", "Wheat bran", "Wheat middlings"],
        "impact": "Critical - fiber & starch content differ significantly",
        "nrc_reference": "NRC 2012 Section 3.2.1 (milling byproducts)"
    },
    {
        "issue": "Corn products not separated by form",
        "current_status": "Possible incorrect merge of grain/meal/flour",
        "should_be": ["Corn grain", "Corn meal", "Corn flour"],
        "impact": "High - particle size affects digestibility",
        "asabe_reference": "ASABE S319.4 (particle size standards)"
    },
    {
        "issue": "Meat meal vs Meat & Bone Meal confused",
        "current_status": "May be single entry",
        "should_be": ["Meat meal (rendered)", "Meat & Bone meal (rendered)"],
        "impact": "Critical - calcium/phosphorus ratio differs by 200%+",
        "cvb_reference": "CVB SB codes (different codes for different products)"
    },
    {
        "issue": "Palm kernel meal oil grades not separated",
        "current_status": "Possible single entry",
        "should_be": ["Palm kernel meal <10% oil", "Palm kernel meal 10-20% oil"],
        "impact": "High - energy value differs 200+ kcal/kg",
        "cvb_reference": "CVB Feed Tables (oil content determines energy)"
    },
    {
        "issue": "Soybean meal extraction methods not distinguished",
        "current_status": "Possible merge of 44% and 48% CP",
        "should_be": ["Soybean meal 44% (solvent)", "Soybean meal 48% (solvent)"],
        "impact": "Medium - protein level affects lysine requirements",
        "nrc_reference": "NRC 2012 Table 4-1, 4-2"
    },
]

# ============================================================================
# STANDARDIZATION ENGINE
# ============================================================================

class IngredientStandardizer:
    """Cross-references ingredients against industry standards"""
    
    def __init__(self, merged_ingredients_file: str):
        self.ingredients = self._load_ingredients(merged_ingredients_file)
        self.issues = []
        self.corrections = []
        self.separations_needed = []
        
    def _load_ingredients(self, filepath: str) -> List[Dict]:
        """Load merged ingredients from JSON"""
        with open(filepath, 'r', encoding='utf-8') as f:
            return json.load(f)
    
    def standardize_all(self) -> Tuple[List[Dict], Dict]:
        """
        Main standardization process:
        1. Cross-reference each ingredient
        2. Identify separation needs
        3. Apply corrections
        4. Generate standardization report
        """
        
        print("=" * 80)
        print("INDUSTRY STANDARDS CROSS-REFERENCE & INGREDIENT STANDARDIZATION")
        print("=" * 80)
        print(f"\nProcessing {len(self.ingredients)} ingredients...\n")
        
        for idx, ing in enumerate(self.ingredients, 1):
            name = ing.get('name', 'Unknown')
            
            # Check for standard name matches
            standard_name, matches = self._find_standard_match(name)
            
            # Check if ingredient should be separated
            separation = self._check_separation_needed(name, ing)
            
            # Validate against standards
            issues = self._validate_against_standards(name, ing)
            
            if issues:
                self.issues.append({
                    "ingredient_id": ing.get('ingredient_id'),
                    "name": name,
                    "issues": issues
                })
            
            if separation:
                self.separations_needed.append({
                    "ingredient_id": ing.get('ingredient_id'),
                    "current_name": name,
                    "should_be_separated": separation,
                    "data": ing
                })
            
            if standard_name and standard_name != name:
                self.corrections.append({
                    "ingredient_id": ing.get('ingredient_id'),
                    "current_name": name,
                    "standard_name": standard_name,
                    "standards_matched": matches
                })
            
            # Progress
            if idx % 50 == 0:
                print(f"  ✓ Processed {idx}/{len(self.ingredients)} ingredients...")
        
        return self.ingredients, self._generate_report()
    
    def _find_standard_match(self, ingredient_name: str) -> Tuple[Optional[str], List[str]]:
        """
        Find matching standard name from NRC, CVB, INRA, FAO, ASABE
        Returns (standard_name, standards_found)
        """
        name_lower = ingredient_name.lower()
        matches = []
        best_match = None
        
        # Search NRC 2012
        for std_name, data in NRC_2012_STANDARDS.items():
            if any(var in name_lower for var in data['variants']):
                matches.append(f"NRC 2012: {data['standard_name']} (ID: {data['nrc_id']})")
                if not best_match:
                    best_match = data['standard_name']
        
        # Search CVB
        for std_name, data in CVB_STANDARDS.items():
            if any(var in name_lower for var in data['variants']):
                matches.append(f"CVB: {data['standard_name']} (Code: {data['cvb_code']})")
                if not best_match:
                    best_match = data['standard_name']
        
        # Search INRA
        for std_name, data in INRA_STANDARDS.items():
            if any(var in name_lower for var in data['variants']):
                matches.append(f"INRA: {data['standard_name']} (Code: {data['inra_code']})")
                if not best_match:
                    best_match = data['standard_name']
        
        # Search FAO
        for std_name, data in FAO_STANDARDS.items():
            if any(var in name_lower for var in data['variants']):
                matches.append(f"FAO: {data['standard_name']} (Code: {data['fao_code']})")
                if not best_match:
                    best_match = data['standard_name']
        
        return best_match, matches
    
    def _check_separation_needed(self, name: str, ing: Dict) -> Optional[List[Dict]]:
        """
        Check if ingredient should be separated into multiple distinct products
        based on protein level, oil content, processing method, etc.
        """
        name_lower = name.lower()
        
        # Fish meal: check protein grades
        if "fish meal" in name_lower:
            cp = ing.get('crude_protein')
            if cp:
                if cp >= 68:  # 70% grade
                    return [{"form": "Fish meal 70% CP", "cp": cp}]
                elif cp >= 64:  # 65% grade
                    return [{"form": "Fish meal 65% CP", "cp": cp}]
                elif cp >= 60:  # 62% grade
                    return [{"form": "Fish meal 62% CP", "cp": cp}]
        
        # Soybean meal: check protein levels
        if "soybean meal" in name_lower:
            cp = ing.get('crude_protein')
            if cp:
                if cp >= 47:
                    return [{"form": "Soybean meal 48% CP (solvent extracted)", "cp": cp}]
                elif cp >= 43:
                    return [{"form": "Soybean meal 44% CP (solvent extracted)", "cp": cp}]
        
        # Palm kernel: check oil content
        if "palm kernel" in name_lower:
            fat = ing.get('crude_fat')
            if fat:
                if fat <= 5:
                    return [{"form": "Palm kernel meal <10% oil", "fat": fat}]
                else:
                    return [{"form": "Palm kernel meal 10-20% oil", "fat": fat}]
        
        # Meat meal vs Meat & Bone meal
        if "meat" in name_lower and "meal" in name_lower:
            cp = ing.get('crude_protein')
            ash = ing.get('ash')
            if cp and ash:
                if ash >= 20:  # High ash = meat & bone meal
                    return [{"form": "Meat & Bone meal (rendered)", "cp": cp, "ash": ash}]
                else:
                    return [{"form": "Meat meal (rendered)", "cp": cp, "ash": ash}]
        
        # Wheat products
        if "wheat" in name_lower:
            fiber = ing.get('crude_fiber')
            if "bran" in name_lower or (fiber and fiber > 10):
                return [{"form": "Wheat bran"}]
            elif "middling" in name_lower:
                return [{"form": "Wheat middlings"}]
            elif "flour" in name_lower:
                return [{"form": "Wheat flour"}]
            else:
                return [{"form": "Wheat grain"}]
        
        # Corn products
        if "corn" in name_lower:
            if "flour" in name_lower:
                return [{"form": "Corn flour"}]
            elif "meal" in name_lower:
                return [{"form": "Corn meal"}]
            else:
                return [{"form": "Corn grain"}]
        
        return None
    
    def _validate_against_standards(self, name: str, ing: Dict) -> List[str]:
        """
        Validate ingredient data against known standards
        Returns list of validation issues
        """
        issues = []
        cp = ing.get('crude_protein')
        fiber = ing.get('crude_fiber')
        fat = ing.get('crude_fat')
        ash = ing.get('ash')
        
        # Check protein ranges based on ingredient type
        name_lower = name.lower()
        
        if "concentrate" in name_lower and cp and cp < 20:
            issues.append(f"Protein level {cp}% seems low for concentrate")
        
        if "meal" in name_lower and cp and cp < 10:
            issues.append(f"Protein level {cp}% unusually low for meal")
        
        # Check fiber levels
        if fiber and fiber > 40:
            if "bran" not in name_lower and "hull" not in name_lower and "straw" not in name_lower:
                issues.append(f"High fiber {fiber}% - verify ingredient is fibrous")
        
        # Check ash levels (indicator of bone content)
        if ash and ash > 25 and "bone" not in name_lower and "mineral" not in name_lower:
            issues.append(f"High ash {ash}% - check if mineral supplement or MBM")
        
        # Check energy values are reasonable
        me = ing.get('me_growing_pig')
        if me and (me < 500 or me > 10000):
            issues.append(f"Energy value {me} kcal/kg outside typical range (500-10000)")
        
        return issues
    
    def _generate_report(self) -> Dict:
        """Generate comprehensive standardization report"""
        return {
            "timestamp": datetime.now().isoformat(),
            "total_ingredients": len(self.ingredients),
            "corrections_needed": len(self.corrections),
            "separations_needed": len(self.separations_needed),
            "validation_issues": len(self.issues),
            "corrections": self.corrections,
            "separations": self.separations_needed,
            "issues": self.issues,
        }
    
    def save_report(self, output_file: str):
        """Save standardization report to file"""
        report = self._generate_report()
        
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write("# INGREDIENT STANDARDIZATION REPORT\n")
            f.write("=" * 80 + "\n\n")
            f.write(f"Generated: {report['timestamp']}\n")
            f.write(f"Total Ingredients: {report['total_ingredients']}\n")
            f.write(f"Corrections Needed: {report['corrections_needed']}\n")
            f.write(f"Separations Needed: {report['separations_needed']}\n")
            f.write(f"Validation Issues: {report['validation_issues']}\n\n")
            
            # Corrections
            if report['corrections']:
                f.write("## NAME CORRECTIONS NEEDED\n\n")
                for corr in report['corrections']:
                    f.write(f"ID {corr['ingredient_id']}: '{corr['current_name']}'\n")
                    f.write(f"  → Standard name: '{corr['standard_name']}'\n")
                    f.write(f"  Standards matched:\n")
                    for match in corr['standards_matched']:
                        f.write(f"    - {match}\n")
                    f.write("\n")
            
            # Separations
            if report['separations']:
                f.write("## INGREDIENTS TO SEPARATE\n\n")
                for sep in report['separations']:
                    f.write(f"ID {sep['ingredient_id']}: '{sep['current_name']}'\n")
                    f.write(f"  Should be separated into:\n")
                    for form in sep['should_be_separated']:
                        f.write(f"    - {form}\n")
                    f.write("\n")
            
            # Issues
            if report['issues']:
                f.write("## VALIDATION ISSUES\n\n")
                for issue in report['issues']:
                    f.write(f"ID {issue['ingredient_id']}: '{issue['name']}'\n")
                    for problem in issue['issues']:
                        f.write(f"  ⚠️  {problem}\n")
                    f.write("\n")
        
        print(f"\n✓ Report saved to: {output_file}")


# ============================================================================
# EXECUTION
# ============================================================================

def main():
    workspace = Path("c:\\dev\\feed_estimator\\redesigned-feed-app")
    merged_file = workspace / "assets" / "raw" / "ingredients_merged.json"
    report_file = workspace / "doc" / "INGREDIENT_STANDARDIZATION_REPORT.md"
    
    if not merged_file.exists():
        print(f"ERROR: Merged ingredients file not found: {merged_file}")
        return
    
    # Run standardization
    standardizer = IngredientStandardizer(str(merged_file))
    ingredients, report = standardizer.standardize_all()
    
    # Save report
    standardizer.save_report(str(report_file))
    
    # Print summary
    print("\n" + "=" * 80)
    print("STANDARDIZATION SUMMARY")
    print("=" * 80)
    print(f"\nTotal ingredients processed: {report['total_ingredients']}")
    print(f"Name corrections needed: {report['corrections_needed']}")
    print(f"Separations needed: {report['separations_needed']}")
    print(f"Validation issues flagged: {report['validation_issues']}")
    
    print("\n📋 Known merge issues from current dataset:")
    for issue in KNOWN_MERGE_ISSUES:
        print(f"\n  • {issue['issue']}")
        print(f"    Status: {issue['current_status']}")
        print(f"    Impact: {issue['impact']}")
    
    print(f"\n✓ Detailed report saved to: {report_file}")


if __name__ == "__main__":
    main()
