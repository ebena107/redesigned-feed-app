/// Animal categories and taxonomy for feed formulation
///
/// Defines standardized animal types and their granular categories,
/// enabling precise inclusion limits and nutrient recommendations.
/// Used by InclusionValidator to resolve per-animal category limits.
library;

/// Animal type IDs (from AnimalTypeRepository)
class AnimalTypeId {
  static const int pig = 1;
  static const int poultry = 2;
  static const int rabbit = 3;
  static const int dairyCattle = 4;
  static const int beefCattle = 5;
  static const int sheep = 6;
  static const int goat = 7;
  static const int fishTilapia = 8;
  static const int fishCatfish = 9;
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
  // Dairy Cattle categories
  static const String dairyCalfPreStarter = 'dairy_calf_prestarter';
  static const String dairyCalfStarter = 'dairy_calf_starter';
  static const String dairyHeiferGrowing = 'dairy_heifer_growing';
  static const String dairyHeiferFinisher = 'dairy_heifer_finisher';
  static const String dairyLactatingEarly = 'dairy_lactating_early';
  static const String dairyLactatingMid = 'dairy_lactating_mid';
  static const String dairyDry = 'dairy_dry';

  // Beef Cattle categories
  static const String beefCalfPreStarter = 'beef_calf_prestarter';
  static const String beefCalfStarter = 'beef_calf_starter';
  static const String beefGrowing = 'beef_growing';
  static const String beefFinishing = 'beef_finishing';
  static const String beefBreedingBull = 'beef_breeding_bull';
  static const String beefPregnantCow = 'beef_pregnant_cow';

  // Sheep categories
  static const String sheepLambCreep = 'sheep_lamb_creep';
  static const String sheepLambStarter = 'sheep_lamb_starter';
  static const String sheepLambGrowing = 'sheep_lamb_growing';
  static const String sheepLambFinishing = 'sheep_lamb_finishing';
  static const String sheepGrowingEwe = 'sheep_growing_ewe';
  static const String sheepLactating = 'sheep_lactating';
  static const String sheepDry = 'sheep_dry';
  static const String sheep = 'sheep';

  // Goat categories
  static const String goatDoelingCreep = 'goat_doeling_creep';
  static const String goatDoelingStarter = 'goat_doeling_starter';
  static const String goatGrowing = 'goat_growing';
  static const String goatFinisher = 'goat_finisher';
  static const String goatBreedingBuck = 'goat_breeding_buck';
  static const String goatLactating = 'goat_lactating';
  static const String goatDry = 'goat_dry';
  static const String goat = 'goat';

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
  // Tilapia (8 stages)
  static const String tilapiaMicro = 'tilapia_micro';
  static const String tilapiaFry = 'tilapia_fry';
  static const String tilapiaPreStarter = 'tilapia_pre_starter';
  static const String tilapiaStarter = 'tilapia_starter';
  static const String tilapiaGrower = 'tilapia_grower';
  static const String tilapiaFinisher = 'tilapia_finisher';
  static const String tilapiaBreeder = 'tilapia_breeder';
  static const String tilapiaMaintenance = 'tilapia_maintenance';

  // Catfish (7 stages)
  static const String catfishMicro = 'catfish_micro';
  static const String catfishFry = 'catfish_fry';
  static const String catfishPreStarter = 'catfish_pre_starter';
  static const String catfishStarter = 'catfish_starter';
  static const String catfishGrower = 'catfish_grower';
  static const String catfishFinisher = 'catfish_finisher';
  static const String catfishBreeder = 'catfish_breeder';

  // Generic fish categories
  static const String fishFreshwater = 'fish_freshwater';
  static const String fishMarine = 'fish_marine';
  static const String fishSalmonids = 'salmonids';
  static const String fishTilapia = 'tilapia'; // Generic tilapia fallback
  static const String fishCatfish = 'catfish'; // Generic catfish fallback
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
  /// - animalTypeId: 1=pig, 2=poultry, 3=rabbit, 4=dairyCattle, 5=beefCattle,
  ///                6=sheep, 7=goat, 8=fishTilapia, 9=fishCatfish
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

      case 4: // Dairy Cattle
        if (stage.contains('prestarter') ||
            stage.contains('pre-starter') ||
            stage.contains('calf')) {
          return [
            AnimalCategory.dairyCalfPreStarter,
            AnimalCategory.ruminantDairy,
            AnimalCategory.ruminant,
          ];
        } else if (stage.contains('starter')) {
          return [
            AnimalCategory.dairyCalfStarter,
            AnimalCategory.dairyCalfPreStarter,
            AnimalCategory.ruminantDairy,
            AnimalCategory.ruminant,
          ];
        } else if (stage.contains('grower')) {
          return [
            AnimalCategory.dairyHeiferGrowing,
            AnimalCategory.dairyCalfStarter,
            AnimalCategory.ruminantDairy,
            AnimalCategory.ruminant,
          ];
        } else if (stage.contains('finisher')) {
          return [
            AnimalCategory.dairyHeiferFinisher,
            AnimalCategory.dairyHeiferGrowing,
            AnimalCategory.ruminantDairy,
            AnimalCategory.ruminant,
          ];
        } else if (stage.contains('early') || stage.contains('peak')) {
          return [
            AnimalCategory.dairyLactatingEarly,
            AnimalCategory.dairyLactatingMid,
            AnimalCategory.ruminantDairy,
            AnimalCategory.ruminant,
          ];
        } else if (stage.contains('lactating')) {
          return [
            AnimalCategory.dairyLactatingMid,
            AnimalCategory.dairyLactatingEarly,
            AnimalCategory.ruminantDairy,
            AnimalCategory.ruminant,
          ];
        } else if (stage.contains('gestating') || stage.contains('dry')) {
          return [
            AnimalCategory.dairyDry,
            AnimalCategory.ruminantDairy,
            AnimalCategory.ruminant,
          ];
        } else {
          return [
            AnimalCategory.ruminantDairy,
            AnimalCategory.ruminant,
          ];
        }

      case 5: // Beef Cattle
        if (stage.contains('prestarter') ||
            stage.contains('pre-starter') ||
            stage.contains('creep')) {
          return [
            AnimalCategory.beefCalfPreStarter,
            AnimalCategory.ruminantBeef,
            AnimalCategory.ruminant,
          ];
        } else if (stage.contains('starter')) {
          return [
            AnimalCategory.beefCalfStarter,
            AnimalCategory.beefCalfPreStarter,
            AnimalCategory.ruminantBeef,
            AnimalCategory.ruminant,
          ];
        } else if (stage.contains('grower')) {
          return [
            AnimalCategory.beefGrowing,
            AnimalCategory.beefCalfStarter,
            AnimalCategory.ruminantBeef,
            AnimalCategory.ruminant,
          ];
        } else if (stage.contains('finisher')) {
          return [
            AnimalCategory.beefFinishing,
            AnimalCategory.beefGrowing,
            AnimalCategory.ruminantBeef,
            AnimalCategory.ruminant,
          ];
        } else if (stage.contains('early') || stage.contains('bull')) {
          return [
            AnimalCategory.beefBreedingBull,
            AnimalCategory.ruminantBeef,
            AnimalCategory.ruminant,
          ];
        } else if (stage.contains('gestating') || stage.contains('pregnant')) {
          return [
            AnimalCategory.beefPregnantCow,
            AnimalCategory.ruminantBeef,
            AnimalCategory.ruminant,
          ];
        } else {
          return [
            AnimalCategory.ruminantBeef,
            AnimalCategory.ruminant,
          ];
        }

      case 6: // Sheep
        if (stage.contains('prestarter') ||
            stage.contains('pre-starter') ||
            stage.contains('creep')) {
          return [
            AnimalCategory.sheepLambCreep,
            AnimalCategory.sheep,
            AnimalCategory.ruminant,
          ];
        } else if (stage.contains('starter')) {
          return [
            AnimalCategory.sheepLambStarter,
            AnimalCategory.sheepLambCreep,
            AnimalCategory.sheep,
            AnimalCategory.ruminant,
          ];
        } else if (stage.contains('grower')) {
          return [
            AnimalCategory.sheepLambGrowing,
            AnimalCategory.sheepLambStarter,
            AnimalCategory.sheep,
            AnimalCategory.ruminant,
          ];
        } else if (stage.contains('finisher')) {
          return [
            AnimalCategory.sheepLambFinishing,
            AnimalCategory.sheepLambGrowing,
            AnimalCategory.sheep,
            AnimalCategory.ruminant,
          ];
        } else if (stage.contains('early') || stage.contains('growing ewe')) {
          return [
            AnimalCategory.sheepGrowingEwe,
            AnimalCategory.sheep,
            AnimalCategory.ruminantSheep,
            AnimalCategory.ruminant,
          ];
        } else if (stage.contains('lactating')) {
          return [
            AnimalCategory.sheepLactating,
            AnimalCategory.sheep,
            AnimalCategory.ruminantSheep,
            AnimalCategory.ruminant,
          ];
        } else if (stage.contains('gestating') || stage.contains('pregnant')) {
          return [
            AnimalCategory.sheepDry,
            AnimalCategory.sheep,
            AnimalCategory.ruminantSheep,
            AnimalCategory.ruminant,
          ];
        } else {
          return [
            AnimalCategory.ruminantSheep,
            AnimalCategory.sheep,
            AnimalCategory.ruminant,
          ];
        }

      case 7: // Goat
        if (stage.contains('prestarter') ||
            stage.contains('pre-starter') ||
            stage.contains('creep')) {
          return [
            AnimalCategory.goatDoelingCreep,
            AnimalCategory.goat,
            AnimalCategory.ruminant,
          ];
        } else if (stage.contains('starter')) {
          return [
            AnimalCategory.goatDoelingStarter,
            AnimalCategory.goatDoelingCreep,
            AnimalCategory.goat,
            AnimalCategory.ruminant,
          ];
        } else if (stage.contains('grower')) {
          return [
            AnimalCategory.goatGrowing,
            AnimalCategory.goatDoelingStarter,
            AnimalCategory.goat,
            AnimalCategory.ruminant,
          ];
        } else if (stage.contains('finisher') ||
            stage.contains('replacement')) {
          return [
            AnimalCategory.goatFinisher,
            AnimalCategory.goatGrowing,
            AnimalCategory.goat,
            AnimalCategory.ruminant,
          ];
        } else if (stage.contains('early') || stage.contains('buck')) {
          return [
            AnimalCategory.goatBreedingBuck,
            AnimalCategory.goat,
            AnimalCategory.ruminant,
          ];
        } else if (stage.contains('lactating')) {
          return [
            AnimalCategory.goatLactating,
            AnimalCategory.goat,
            AnimalCategory.ruminantGoat,
            AnimalCategory.ruminant,
          ];
        } else if (stage.contains('gestating') || stage.contains('pregnant')) {
          return [
            AnimalCategory.goatDry,
            AnimalCategory.goat,
            AnimalCategory.ruminantGoat,
            AnimalCategory.ruminant,
          ];
        } else {
          return [
            AnimalCategory.ruminantGoat,
            AnimalCategory.goat,
            AnimalCategory.ruminant,
          ];
        }

      case 8: // Tilapia (8 stages)
        if (stage.contains('micro')) {
          return [
            AnimalCategory.tilapiaMicro,
            AnimalCategory.tilapiaFry,
            AnimalCategory.fishTilapia,
            AnimalCategory.fishFreshwater,
            AnimalCategory.fish,
            AnimalCategory.aquaculture,
          ];
        } else if (stage.contains('fry')) {
          return [
            AnimalCategory.tilapiaFry,
            AnimalCategory.tilapiaMicro,
            AnimalCategory.fishTilapia,
            AnimalCategory.fishFreshwater,
            AnimalCategory.fish,
            AnimalCategory.aquaculture,
          ];
        } else if (stage.contains('prestarter') ||
            stage.contains('pre-starter') ||
            stage.contains('nursery')) {
          return [
            AnimalCategory.tilapiaPreStarter,
            AnimalCategory.tilapiaStarter,
            AnimalCategory.tilapiaFry,
            AnimalCategory.fishTilapia,
            AnimalCategory.fishFreshwater,
            AnimalCategory.fish,
            AnimalCategory.aquaculture,
          ];
        } else if (stage.contains('starter')) {
          return [
            AnimalCategory.tilapiaStarter,
            AnimalCategory.tilapiaPreStarter,
            AnimalCategory.tilapiaGrower,
            AnimalCategory.fishTilapia,
            AnimalCategory.fishFreshwater,
            AnimalCategory.fish,
            AnimalCategory.aquaculture,
          ];
        } else if (stage.contains('grower')) {
          return [
            AnimalCategory.tilapiaGrower,
            AnimalCategory.tilapiaStarter,
            AnimalCategory.tilapiaFinisher,
            AnimalCategory.fishTilapia,
            AnimalCategory.fishFreshwater,
            AnimalCategory.fish,
            AnimalCategory.aquaculture,
          ];
        } else if (stage.contains('finisher')) {
          return [
            AnimalCategory.tilapiaFinisher,
            AnimalCategory.tilapiaGrower,
            AnimalCategory.tilapiaMaintenance,
            AnimalCategory.fishTilapia,
            AnimalCategory.fishFreshwater,
            AnimalCategory.fish,
            AnimalCategory.aquaculture,
          ];
        } else if (stage.contains('breeder') ||
            stage.contains('breeding') ||
            stage.contains('broodstock')) {
          return [
            AnimalCategory.tilapiaBreeder,
            AnimalCategory.tilapiaFinisher,
            AnimalCategory.fishTilapia,
            AnimalCategory.fishFreshwater,
            AnimalCategory.fish,
            AnimalCategory.aquaculture,
          ];
        } else if (stage.contains('maintenance')) {
          return [
            AnimalCategory.tilapiaMaintenance,
            AnimalCategory.tilapiaFinisher,
            AnimalCategory.fishTilapia,
            AnimalCategory.fishFreshwater,
            AnimalCategory.fish,
            AnimalCategory.aquaculture,
          ];
        } else {
          // Generic tilapia progression
          return [
            AnimalCategory.tilapiaStarter,
            AnimalCategory.tilapiaGrower,
            AnimalCategory.tilapiaFinisher,
            AnimalCategory.tilapiaBreeder,
            AnimalCategory.fishTilapia,
            AnimalCategory.fishFreshwater,
            AnimalCategory.fish,
            AnimalCategory.aquaculture,
          ];
        }

      case 9: // Catfish (7 stages)
        if (stage.contains('micro')) {
          return [
            AnimalCategory.catfishMicro,
            AnimalCategory.catfishFry,
            AnimalCategory.fishCatfish,
            AnimalCategory.fishFreshwater,
            AnimalCategory.fish,
            AnimalCategory.aquaculture,
          ];
        } else if (stage.contains('fry')) {
          return [
            AnimalCategory.catfishFry,
            AnimalCategory.catfishMicro,
            AnimalCategory.catfishPreStarter,
            AnimalCategory.fishCatfish,
            AnimalCategory.fishFreshwater,
            AnimalCategory.fish,
            AnimalCategory.aquaculture,
          ];
        } else if (stage.contains('prestarter') ||
            stage.contains('pre-starter') ||
            stage.contains('nursery')) {
          return [
            AnimalCategory.catfishPreStarter,
            AnimalCategory.catfishFry,
            AnimalCategory.catfishStarter,
            AnimalCategory.fishCatfish,
            AnimalCategory.fishFreshwater,
            AnimalCategory.fish,
            AnimalCategory.aquaculture,
          ];
        } else if (stage.contains('starter')) {
          return [
            AnimalCategory.catfishStarter,
            AnimalCategory.catfishPreStarter,
            AnimalCategory.catfishGrower,
            AnimalCategory.fishCatfish,
            AnimalCategory.fishFreshwater,
            AnimalCategory.fish,
            AnimalCategory.aquaculture,
          ];
        } else if (stage.contains('grower')) {
          return [
            AnimalCategory.catfishGrower,
            AnimalCategory.catfishStarter,
            AnimalCategory.catfishFinisher,
            AnimalCategory.fishCatfish,
            AnimalCategory.fishFreshwater,
            AnimalCategory.fish,
            AnimalCategory.aquaculture,
          ];
        } else if (stage.contains('finisher')) {
          return [
            AnimalCategory.catfishFinisher,
            AnimalCategory.catfishGrower,
            AnimalCategory.fishCatfish,
            AnimalCategory.fishFreshwater,
            AnimalCategory.fish,
            AnimalCategory.aquaculture,
          ];
        } else if (stage.contains('breeder') ||
            stage.contains('breeding') ||
            stage.contains('broodstock')) {
          return [
            AnimalCategory.catfishBreeder,
            AnimalCategory.catfishFinisher,
            AnimalCategory.fishCatfish,
            AnimalCategory.fishFreshwater,
            AnimalCategory.fish,
            AnimalCategory.aquaculture,
          ];
        } else {
          // Generic catfish progression
          return [
            AnimalCategory.catfishStarter,
            AnimalCategory.catfishGrower,
            AnimalCategory.catfishFinisher,
            AnimalCategory.catfishBreeder,
            AnimalCategory.fishCatfish,
            AnimalCategory.fishFreshwater,
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
        return 'Pig';
      case 2:
        return 'Poultry';
      case 3:
        return 'Rabbit';
      case 4:
        return 'Dairy Cattle';
      case 5:
        return 'Beef Cattle';
      case 6:
        return 'Sheep';
      case 7:
        return 'Goat';
      case 8:
        return 'Fish (Tilapia)';
      case 9:
        return 'Fish (Catfish)';
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
      // Fish - Tilapia
      'tilapia': 'Tilapia',
      // Fish - Catfish
      'catfish': 'Catfish',
      // Fish generic
      'fish_freshwater': 'Freshwater Fish',
      'fish_marine': 'Marine Fish',
      'salmonids': 'Salmonids (Salmon, Trout)',
      'fish': 'Fish (Generic)',
      'aquaculture': 'Aquaculture (Generic)',
      // Fallback
      'default': 'Default Category',
      'all': 'All Categories',
    };

    return categoryNames[categoryKey] ?? 'Unknown ($categoryKey)';
  }
}
