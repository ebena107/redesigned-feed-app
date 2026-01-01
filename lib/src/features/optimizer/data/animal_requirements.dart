import '../model/nutrient_requirement.dart';

/// Industry-standard nutrient requirements for different animal categories
/// Sources: NRC (National Research Council), CVB (Centraal Veevoeder Bureau),
/// INRA-AFZ (Institut National de la Recherche Agronomique)

// ============================================================================
// POULTRY REQUIREMENTS (NRC 1994 Poultry Nutrient Requirements)
// ============================================================================

final poultryBroilerStarter = AnimalCategory(
  species: 'Poultry',
  stage: 'Broiler Starter (0-10 days)',
  description: 'High protein and energy for rapid early growth',
  requirements: [
    NutrientRequirement(
      nutrientName: 'crudeProtein',
      minValue: 21.0,
      maxValue: 24.0,
      targetValue: 23.0,
      unit: '%',
      source: 'NRC 1994 Poultry',
      notes: 'Critical for early muscle development',
    ),
    NutrientRequirement(
      nutrientName: 'energy',
      minValue: 2900,
      maxValue: 3100,
      targetValue: 3000,
      unit: 'kcal/kg',
      source: 'NRC 1994 Poultry',
    ),
    NutrientRequirement(
      nutrientName: 'calcium',
      minValue: 0.9,
      maxValue: 1.2,
      unit: '%',
      source: 'NRC 1994 Poultry',
    ),
    NutrientRequirement(
      nutrientName: 'phosphorus',
      minValue: 0.4,
      maxValue: 0.7,
      unit: '%',
      source: 'NRC 1994 Poultry',
    ),
    NutrientRequirement(
      nutrientName: 'crudeFiber',
      maxValue: 4.0,
      unit: '%',
      source: 'NRC 1994 Poultry',
      notes: 'Keep low for digestibility',
    ),
  ],
);

final poultryBroilerGrower = AnimalCategory(
  species: 'Poultry',
  stage: 'Broiler Grower (11-24 days)',
  description: 'Moderate protein for continued growth',
  requirements: [
    NutrientRequirement(
      nutrientName: 'crudeProtein',
      minValue: 19.0,
      maxValue: 22.0,
      targetValue: 20.0,
      unit: '%',
      source: 'NRC 1994 Poultry',
    ),
    NutrientRequirement(
      nutrientName: 'energy',
      minValue: 3000,
      maxValue: 3200,
      targetValue: 3100,
      unit: 'kcal/kg',
      source: 'NRC 1994 Poultry',
    ),
    NutrientRequirement(
      nutrientName: 'calcium',
      minValue: 0.8,
      maxValue: 1.0,
      unit: '%',
      source: 'NRC 1994 Poultry',
    ),
    NutrientRequirement(
      nutrientName: 'phosphorus',
      minValue: 0.35,
      maxValue: 0.6,
      unit: '%',
      source: 'NRC 1994 Poultry',
    ),
  ],
);

final poultryBroilerFinisher = AnimalCategory(
  species: 'Poultry',
  stage: 'Broiler Finisher (25+ days)',
  description: 'Lower protein, focus on feed efficiency',
  requirements: [
    NutrientRequirement(
      nutrientName: 'crudeProtein',
      minValue: 18.0,
      maxValue: 20.0,
      targetValue: 19.0,
      unit: '%',
      source: 'NRC 1994 Poultry',
    ),
    NutrientRequirement(
      nutrientName: 'energy',
      minValue: 3100,
      maxValue: 3300,
      targetValue: 3200,
      unit: 'kcal/kg',
      source: 'NRC 1994 Poultry',
    ),
    NutrientRequirement(
      nutrientName: 'calcium',
      minValue: 0.7,
      maxValue: 0.9,
      unit: '%',
      source: 'NRC 1994 Poultry',
    ),
    NutrientRequirement(
      nutrientName: 'phosphorus',
      minValue: 0.3,
      maxValue: 0.5,
      unit: '%',
      source: 'NRC 1994 Poultry',
    ),
  ],
);

final poultryLayerProduction = AnimalCategory(
  species: 'Poultry',
  stage: 'Layer Production',
  description: 'High calcium for egg shell formation',
  requirements: [
    NutrientRequirement(
      nutrientName: 'crudeProtein',
      minValue: 16.0,
      maxValue: 18.0,
      targetValue: 17.0,
      unit: '%',
      source: 'NRC 1994 Poultry',
    ),
    NutrientRequirement(
      nutrientName: 'energy',
      minValue: 2700,
      maxValue: 2900,
      targetValue: 2800,
      unit: 'kcal/kg',
      source: 'NRC 1994 Poultry',
    ),
    NutrientRequirement(
      nutrientName: 'calcium',
      minValue: 3.5,
      maxValue: 4.5,
      targetValue: 4.0,
      unit: '%',
      source: 'NRC 1994 Poultry',
      notes: 'Critical for egg shell quality',
    ),
    NutrientRequirement(
      nutrientName: 'phosphorus',
      minValue: 0.3,
      maxValue: 0.5,
      unit: '%',
      source: 'NRC 1994 Poultry',
    ),
  ],
);

// ============================================================================
// SWINE REQUIREMENTS (NRC 2012 Swine Nutrient Requirements)
// ============================================================================

final swinePiglet = AnimalCategory(
  species: 'Swine',
  stage: 'Piglet (Weaning - 25kg)',
  description: 'High digestibility, high protein for post-weaning growth',
  requirements: [
    NutrientRequirement(
      nutrientName: 'crudeProtein',
      minValue: 18.0,
      maxValue: 22.0,
      targetValue: 20.0,
      unit: '%',
      source: 'NRC 2012 Swine',
    ),
    NutrientRequirement(
      nutrientName: 'energy',
      minValue: 3300,
      maxValue: 3500,
      targetValue: 3400,
      unit: 'kcal/kg',
      source: 'NRC 2012 Swine',
    ),
    NutrientRequirement(
      nutrientName: 'calcium',
      minValue: 0.6,
      maxValue: 0.9,
      unit: '%',
      source: 'NRC 2012 Swine',
    ),
    NutrientRequirement(
      nutrientName: 'phosphorus',
      minValue: 0.4,
      maxValue: 0.7,
      unit: '%',
      source: 'NRC 2012 Swine',
    ),
    NutrientRequirement(
      nutrientName: 'crudeFiber',
      maxValue: 5.0,
      unit: '%',
      source: 'NRC 2012 Swine',
    ),
  ],
);

final swineGrower = AnimalCategory(
  species: 'Swine',
  stage: 'Grower (25-60kg)',
  description: 'Balanced nutrition for steady growth',
  requirements: [
    NutrientRequirement(
      nutrientName: 'crudeProtein',
      minValue: 15.0,
      maxValue: 18.0,
      targetValue: 16.5,
      unit: '%',
      source: 'NRC 2012 Swine',
    ),
    NutrientRequirement(
      nutrientName: 'energy',
      minValue: 3200,
      maxValue: 3400,
      targetValue: 3300,
      unit: 'kcal/kg',
      source: 'NRC 2012 Swine',
    ),
    NutrientRequirement(
      nutrientName: 'calcium',
      minValue: 0.5,
      maxValue: 0.8,
      unit: '%',
      source: 'NRC 2012 Swine',
    ),
    NutrientRequirement(
      nutrientName: 'phosphorus',
      minValue: 0.35,
      maxValue: 0.6,
      unit: '%',
      source: 'NRC 2012 Swine',
    ),
  ],
);

final swineFinisher = AnimalCategory(
  species: 'Swine',
  stage: 'Finisher (60-100kg)',
  description: 'Lower protein, focus on feed conversion',
  requirements: [
    NutrientRequirement(
      nutrientName: 'crudeProtein',
      minValue: 13.0,
      maxValue: 16.0,
      targetValue: 14.5,
      unit: '%',
      source: 'NRC 2012 Swine',
    ),
    NutrientRequirement(
      nutrientName: 'energy',
      minValue: 3200,
      maxValue: 3400,
      targetValue: 3300,
      unit: 'kcal/kg',
      source: 'NRC 2012 Swine',
    ),
    NutrientRequirement(
      nutrientName: 'calcium',
      minValue: 0.45,
      maxValue: 0.7,
      unit: '%',
      source: 'NRC 2012 Swine',
    ),
    NutrientRequirement(
      nutrientName: 'phosphorus',
      minValue: 0.3,
      maxValue: 0.5,
      unit: '%',
      source: 'NRC 2012 Swine',
    ),
  ],
);

// ============================================================================
// CATTLE REQUIREMENTS (NRC 2001 Dairy, NRC 2016 Beef)
// ============================================================================

final cattleDairyLactation = AnimalCategory(
  species: 'Cattle',
  stage: 'Dairy Lactation',
  description: 'High energy and protein for milk production',
  requirements: [
    NutrientRequirement(
      nutrientName: 'crudeProtein',
      minValue: 16.0,
      maxValue: 18.0,
      targetValue: 17.0,
      unit: '%',
      source: 'NRC 2001 Dairy',
    ),
    NutrientRequirement(
      nutrientName: 'energy',
      minValue: 1600,
      maxValue: 1800,
      targetValue: 1700,
      unit: 'kcal/kg',
      source: 'NRC 2001 Dairy',
      notes: 'NEL (Net Energy Lactation)',
    ),
    NutrientRequirement(
      nutrientName: 'calcium',
      minValue: 0.6,
      maxValue: 1.0,
      unit: '%',
      source: 'NRC 2001 Dairy',
    ),
    NutrientRequirement(
      nutrientName: 'phosphorus',
      minValue: 0.3,
      maxValue: 0.5,
      unit: '%',
      source: 'NRC 2001 Dairy',
    ),
    NutrientRequirement(
      nutrientName: 'crudeFiber',
      minValue: 17.0,
      maxValue: 25.0,
      unit: '%',
      source: 'NRC 2001 Dairy',
      notes: 'Essential for rumen function',
    ),
  ],
);

final cattleBeefGrower = AnimalCategory(
  species: 'Cattle',
  stage: 'Beef Grower',
  description: 'Moderate protein for frame development',
  requirements: [
    NutrientRequirement(
      nutrientName: 'crudeProtein',
      minValue: 12.0,
      maxValue: 14.0,
      targetValue: 13.0,
      unit: '%',
      source: 'NRC 2016 Beef',
    ),
    NutrientRequirement(
      nutrientName: 'energy',
      minValue: 2400,
      maxValue: 2700,
      targetValue: 2550,
      unit: 'kcal/kg',
      source: 'NRC 2016 Beef',
    ),
    NutrientRequirement(
      nutrientName: 'calcium',
      minValue: 0.4,
      maxValue: 0.7,
      unit: '%',
      source: 'NRC 2016 Beef',
    ),
    NutrientRequirement(
      nutrientName: 'phosphorus',
      minValue: 0.25,
      maxValue: 0.45,
      unit: '%',
      source: 'NRC 2016 Beef',
    ),
  ],
);

// ============================================================================
// SHEEP/GOAT REQUIREMENTS (NRC 2007 Small Ruminants)
// ============================================================================

final sheepGrowing = AnimalCategory(
  species: 'Sheep',
  stage: 'Growing Lamb',
  description: 'Moderate protein for growth',
  requirements: [
    NutrientRequirement(
      nutrientName: 'crudeProtein',
      minValue: 14.0,
      maxValue: 16.0,
      targetValue: 15.0,
      unit: '%',
      source: 'NRC 2007 Small Ruminants',
    ),
    NutrientRequirement(
      nutrientName: 'energy',
      minValue: 2500,
      maxValue: 2800,
      targetValue: 2650,
      unit: 'kcal/kg',
      source: 'NRC 2007 Small Ruminants',
    ),
    NutrientRequirement(
      nutrientName: 'calcium',
      minValue: 0.4,
      maxValue: 0.8,
      unit: '%',
      source: 'NRC 2007 Small Ruminants',
    ),
    NutrientRequirement(
      nutrientName: 'phosphorus',
      minValue: 0.25,
      maxValue: 0.5,
      unit: '%',
      source: 'NRC 2007 Small Ruminants',
    ),
  ],
);

final goatDairy = AnimalCategory(
  species: 'Goat',
  stage: 'Dairy Lactation',
  description: 'High protein and energy for milk production',
  requirements: [
    NutrientRequirement(
      nutrientName: 'crudeProtein',
      minValue: 15.0,
      maxValue: 18.0,
      targetValue: 16.5,
      unit: '%',
      source: 'NRC 2007 Small Ruminants',
    ),
    NutrientRequirement(
      nutrientName: 'energy',
      minValue: 2600,
      maxValue: 2900,
      targetValue: 2750,
      unit: 'kcal/kg',
      source: 'NRC 2007 Small Ruminants',
    ),
    NutrientRequirement(
      nutrientName: 'calcium',
      minValue: 0.6,
      maxValue: 1.0,
      unit: '%',
      source: 'NRC 2007 Small Ruminants',
    ),
    NutrientRequirement(
      nutrientName: 'phosphorus',
      minValue: 0.3,
      maxValue: 0.5,
      unit: '%',
      source: 'NRC 2007 Small Ruminants',
    ),
  ],
);

// ============================================================================
// FISH/AQUACULTURE REQUIREMENTS (NRC 2011 Nutrient Requirements of Fish)
// ============================================================================

final fishTilapia = AnimalCategory(
  species: 'Fish',
  stage: 'Tilapia Grower',
  description: 'High protein for aquaculture',
  requirements: [
    NutrientRequirement(
      nutrientName: 'crudeProtein',
      minValue: 28.0,
      maxValue: 35.0,
      targetValue: 32.0,
      unit: '%',
      source: 'NRC 2011 Fish',
    ),
    NutrientRequirement(
      nutrientName: 'crudeFat',
      minValue: 5.0,
      maxValue: 10.0,
      unit: '%',
      source: 'NRC 2011 Fish',
    ),
    NutrientRequirement(
      nutrientName: 'energy',
      minValue: 3000,
      maxValue: 3500,
      targetValue: 3250,
      unit: 'kcal/kg',
      source: 'NRC 2011 Fish',
    ),
    NutrientRequirement(
      nutrientName: 'calcium',
      minValue: 0.6,
      maxValue: 1.2,
      unit: '%',
      source: 'NRC 2011 Fish',
    ),
    NutrientRequirement(
      nutrientName: 'phosphorus',
      minValue: 0.5,
      maxValue: 0.9,
      unit: '%',
      source: 'NRC 2011 Fish',
    ),
  ],
);

// ============================================================================
// CATEGORY REGISTRY
// ============================================================================

/// Map of all available animal categories
final Map<String, List<AnimalCategory>> animalCategoryRegistry = {
  'Poultry': [
    poultryBroilerStarter,
    poultryBroilerGrower,
    poultryBroilerFinisher,
    poultryLayerProduction,
  ],
  'Swine': [
    swinePiglet,
    swineGrower,
    swineFinisher,
  ],
  'Cattle': [
    cattleDairyLactation,
    cattleBeefGrower,
  ],
  'Sheep/Goat': [
    sheepGrowing,
    goatDairy,
  ],
  'Fish': [
    fishTilapia,
  ],
};

/// Get all species names
List<String> getAllSpecies() => animalCategoryRegistry.keys.toList();

/// Get all stages for a species
List<AnimalCategory> getStagesForSpecies(String species) =>
    animalCategoryRegistry[species] ?? [];

/// Find category by species and stage
AnimalCategory? findCategory(String species, String stage) {
  final categories = animalCategoryRegistry[species];
  if (categories == null) return null;

  return categories.firstWhere(
    (cat) => cat.stage == stage,
    orElse: () => categories.first,
  );
}
