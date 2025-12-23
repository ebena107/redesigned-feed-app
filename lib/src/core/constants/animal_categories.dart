/// Animal categories and taxonomy for feed formulation
///
/// Defines standardized animal types and their granular categories,
/// enabling precise inclusion limits and nutrient recommendations.
/// Used by InclusionValidator to resolve per-animal category limits.
library;

/// Animal type IDs (legacy, from AnimalTypeRepository)
class AnimalTypeId {
  static const int pig = 1;
  static const int poultry = 2;
  static const int rabbit = 3;
  static const int ruminant = 4;
  static const int fish = 5;
}

/// Granular animal categories for inclusion limits
/// Maps to keys in `max_inclusion_json` from Ingredient model
abstract class AnimalCategory {
  // ===== SWINE =====
  static const String pigNursery = 'pig_nursery';
  static const String pigStarter = 'pig_starter';
  static const String pigGrower = 'pig_grower';
  static const String pigFinisher = 'pig_finisher';
  static const String pigGestating = 'pig_gestating';
  static const String pigLactating = 'pig_lactating';
  static const String pigSow = 'pig_sow';
  static const String pig = 'pig'; // Generic fallback

  // ===== POULTRY =====
  static const String broilerStarter = 'poultry_broiler_starter';
  static const String broilerGrower = 'poultry_broiler_grower';
  static const String broilerFinisher = 'poultry_broiler_finisher';
  static const String layer = 'poultry_layer';
  static const String breeder = 'poultry_breeder';
  static const String broiler = 'broiler'; // Generic
  static const String poultry = 'poultry'; // Generic fallback

  // ===== RUMINANTS =====
  static const String ruminantDairy = 'ruminant_dairy';
  static const String ruminantBeef = 'ruminant_beef';
  static const String ruminantSheep = 'ruminant_sheep';
  static const String ruminantGoat = 'ruminant_goat';
  static const String ruminant = 'ruminant'; // Generic fallback

  // ===== RABBITS =====
  static const String rabbit = 'rabbit';
  static const String rabbitGrower = 'rabbit_grower';
  static const String rabbitBreeder = 'rabbit_breeder';

  // ===== FISH & AQUACULTURE =====
  static const String fishFreshwater = 'fish_freshwater';
  static const String fishMarine = 'fish_marine';
  static const String fishSalmonids = 'salmonids';
  static const String fishTilapia = 'tilapia';
  static const String fishCatfish = 'catfish';
  static const String fish = 'fish'; // Generic fallback
  static const String aquaculture = 'aquaculture'; // Generic

  // ===== FALLBACK =====
  static const String defaultCategory = 'default';
  static const String allCategories = 'all';
}

/// Maps animalTypeId (legacy) to preferred category keys
/// Returns a priority list of keys to check in max_inclusion_json,
/// with most specific first and generic fallback last.
class AnimalCategoryMapper {
  /// Get category preference list for an animal type
  ///
  /// Parameters:
  /// - animalTypeId: 1=pig, 2=poultry, 3=rabbit, 4=ruminant, 5=fish
  /// - productionStage: (Optional) stage like 'starter', 'grower', 'finisher'
  ///
  /// Returns: List of preferred category keys in order of specificity
  static List<String> getCategoryPreferences({
    required num animalTypeId,
    String? productionStage,
  }) {
    final stage = productionStage?.toLowerCase() ?? '';

    switch (animalTypeId.toInt()) {
      case 1: // Pig
        if (stage.contains('nursery')) {
          return [
            AnimalCategory.pigNursery,
            AnimalCategory.pigStarter,
            AnimalCategory.pig,
          ];
        } else if (stage.contains('starter')) {
          return [
            AnimalCategory.pigStarter,
            AnimalCategory.pigNursery,
            AnimalCategory.pigGrower,
            AnimalCategory.pig,
          ];
        } else if (stage.contains('grower')) {
          return [
            AnimalCategory.pigGrower,
            AnimalCategory.pigStarter,
            AnimalCategory.pigFinisher,
            AnimalCategory.pig,
          ];
        } else if (stage.contains('finisher')) {
          return [
            AnimalCategory.pigFinisher,
            AnimalCategory.pigGrower,
            AnimalCategory.pig,
          ];
        } else if (stage.contains('gestating') || stage.contains('pregnant')) {
          return [
            AnimalCategory.pigGestating,
            AnimalCategory.pigSow,
            AnimalCategory.pig,
          ];
        } else if (stage.contains('lactating') || stage.contains('nursing')) {
          return [
            AnimalCategory.pigLactating,
            AnimalCategory.pigSow,
            AnimalCategory.pig,
          ];
        } else {
          // Generic pig
          return [
            AnimalCategory.pigGrower,
            AnimalCategory.pigStarter,
            AnimalCategory.pigFinisher,
            AnimalCategory.pig,
          ];
        }

      case 2: // Poultry
        if (stage.contains('starter')) {
          return [
            AnimalCategory.broilerStarter,
            AnimalCategory.broiler,
            AnimalCategory.poultry,
          ];
        } else if (stage.contains('grower')) {
          return [
            AnimalCategory.broilerGrower,
            AnimalCategory.broilerStarter,
            AnimalCategory.broiler,
            AnimalCategory.poultry,
          ];
        } else if (stage.contains('finisher')) {
          return [
            AnimalCategory.broilerFinisher,
            AnimalCategory.broilerGrower,
            AnimalCategory.broiler,
            AnimalCategory.poultry,
          ];
        } else if (stage.contains('layer') || stage.contains('laying')) {
          return [
            AnimalCategory.layer,
            AnimalCategory.poultry,
          ];
        } else if (stage.contains('breeder') || stage.contains('breeding')) {
          return [
            AnimalCategory.breeder,
            AnimalCategory.layer,
            AnimalCategory.poultry,
          ];
        } else {
          // Generic broiler progression
          return [
            AnimalCategory.broilerStarter,
            AnimalCategory.broilerGrower,
            AnimalCategory.broilerFinisher,
            AnimalCategory.broiler,
            AnimalCategory.poultry,
          ];
        }

      case 3: // Rabbit
        if (stage.contains('grower')) {
          return [
            AnimalCategory.rabbitGrower,
            AnimalCategory.rabbit,
          ];
        } else if (stage.contains('breeder') || stage.contains('breeding')) {
          return [
            AnimalCategory.rabbitBreeder,
            AnimalCategory.rabbit,
          ];
        } else {
          return [
            AnimalCategory.rabbit,
            AnimalCategory.rabbitGrower,
            AnimalCategory.rabbitBreeder,
          ];
        }

      case 4: // Ruminant
        if (stage.contains('dairy')) {
          return [
            AnimalCategory.ruminantDairy,
            AnimalCategory.ruminant,
          ];
        } else if (stage.contains('beef')) {
          return [
            AnimalCategory.ruminantBeef,
            AnimalCategory.ruminant,
          ];
        } else if (stage.contains('sheep')) {
          return [
            AnimalCategory.ruminantSheep,
            AnimalCategory.ruminant,
          ];
        } else if (stage.contains('goat')) {
          return [
            AnimalCategory.ruminantGoat,
            AnimalCategory.ruminant,
          ];
        } else {
          // Generic ruminant with dairy preference (larger market)
          return [
            AnimalCategory.ruminantDairy,
            AnimalCategory.ruminantBeef,
            AnimalCategory.ruminantSheep,
            AnimalCategory.ruminantGoat,
            AnimalCategory.ruminant,
          ];
        }

      case 5: // Fish & Aquaculture
        if (stage.contains('salmonid')) {
          return [
            AnimalCategory.fishSalmonids,
            AnimalCategory.fishMarine,
            AnimalCategory.fish,
            AnimalCategory.aquaculture,
          ];
        } else if (stage.contains('tilapia')) {
          return [
            AnimalCategory.fishTilapia,
            AnimalCategory.fishFreshwater,
            AnimalCategory.fish,
            AnimalCategory.aquaculture,
          ];
        } else if (stage.contains('catfish')) {
          return [
            AnimalCategory.fishCatfish,
            AnimalCategory.fishFreshwater,
            AnimalCategory.fish,
            AnimalCategory.aquaculture,
          ];
        } else if (stage.contains('marine')) {
          return [
            AnimalCategory.fishMarine,
            AnimalCategory.fish,
            AnimalCategory.aquaculture,
          ];
        } else if (stage.contains('freshwater')) {
          return [
            AnimalCategory.fishFreshwater,
            AnimalCategory.fish,
            AnimalCategory.aquaculture,
          ];
        } else {
          // Generic aquaculture
          return [
            AnimalCategory.fishFreshwater,
            AnimalCategory.fishMarine,
            AnimalCategory.fish,
            AnimalCategory.aquaculture,
          ];
        }

      default:
        // Unknown animal type
        return [
          AnimalCategory.defaultCategory,
          AnimalCategory.allCategories,
        ];
    }
  }

  /// Get category preference list for legacy animalTypeId only
  /// (without production stage info)
  static List<String> getCategoryPreferencesForAnimalType(
    num animalTypeId,
  ) {
    return getCategoryPreferences(animalTypeId: animalTypeId);
  }

  /// Get human-readable name for an animal type
  static String getAnimalTypeName(num animalTypeId) {
    switch (animalTypeId.toInt()) {
      case 1:
        return 'Swine (Pig)';
      case 2:
        return 'Poultry';
      case 3:
        return 'Rabbit';
      case 4:
        return 'Ruminant';
      case 5:
        return 'Fish & Aquaculture';
      default:
        return 'Unknown';
    }
  }

  /// Get human-readable name for a category key
  static String getCategoryName(String categoryKey) {
    const Map<String, String> categoryNames = {
      // Pig
      'pig_nursery': 'Pig - Nursery (3-10 kg)',
      'pig_starter': 'Pig - Starter (10-25 kg)',
      'pig_grower': 'Pig - Grower (25-50 kg)',
      'pig_finisher': 'Pig - Finisher (50+ kg)',
      'pig_gestating': 'Pig - Gestating Sow',
      'pig_lactating': 'Pig - Lactating Sow',
      'pig_sow': 'Pig - Sow (Generic)',
      'pig': 'Pig (Generic)',
      // Poultry
      'poultry_broiler_starter': 'Broiler - Starter (0-2 weeks)',
      'poultry_broiler_grower': 'Broiler - Grower (2-6 weeks)',
      'poultry_broiler_finisher': 'Broiler - Finisher (6+ weeks)',
      'broiler': 'Broiler (Generic)',
      'poultry_layer': 'Layer / Pullet',
      'poultry_breeder': 'Breeder / Breeding Stock',
      'poultry': 'Poultry (Generic)',
      // Ruminant
      'ruminant_dairy': 'Dairy Cattle',
      'ruminant_beef': 'Beef Cattle',
      'ruminant_sheep': 'Sheep',
      'ruminant_goat': 'Goat',
      'ruminant': 'Ruminant (Generic)',
      // Rabbit
      'rabbit': 'Rabbit (Generic)',
      'rabbit_grower': 'Rabbit - Grower',
      'rabbit_breeder': 'Rabbit - Breeder',
      // Fish
      'fish_freshwater': 'Freshwater Fish',
      'fish_marine': 'Marine Fish',
      'salmonids': 'Salmonids (Salmon, Trout)',
      'tilapia': 'Tilapia',
      'catfish': 'Catfish',
      'fish': 'Fish (Generic)',
      'aquaculture': 'Aquaculture (Generic)',
      // Fallback
      'default': 'Default Category',
      'all': 'All Categories',
    };

    return categoryNames[categoryKey] ?? 'Unknown ($categoryKey)';
  }
}
