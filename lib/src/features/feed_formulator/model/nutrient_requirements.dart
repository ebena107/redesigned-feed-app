import 'feed_type.dart';
import 'formulator_constraint.dart';

/// Industrial nutrient standards
/// Sources:
/// NRC (Swine, Poultry, Dairy, Beef, Rabbit, Fish)
/// FAO Aquaculture Feed Standards
/// INRA Ruminant Feeding Tables
///
/// Units:
/// Energy: kcal/kg
/// Protein: %
/// Lysine: %
/// Methionine: %
/// Calcium: %
/// Phosphorus: %
class NutrientRequirements {
  const NutrientRequirements({
    required this.animalTypeId,
    required this.feedType,
    required this.constraints,
  });

  final int animalTypeId;
  final FeedType feedType;
  final List<NutrientConstraint> constraints;

  static NutrientRequirements getDefaults(
    int animalTypeId,
    FeedType feedType,
  ) {
    switch (animalTypeId) {
      /// PIG
      case 1:
        return _pig(feedType);

      /// POULTRY BROILER
      case 2:
        return _poultry(feedType);

      /// RABBIT
      case 3:
        return _rabbit(feedType);

      /// DAIRY CATTLE
      case 4:
        return _dairy(feedType);

      /// BEEF CATTLE
      case 5:
        return _beef(feedType);

      /// SHEEP
      case 6:
        return _sheep(feedType);

      /// GOAT
      case 7:
        return _goat(feedType);

      /// TILAPIA
      case 8:
        return _tilapia(feedType);

      /// CATFISH
      case 9:
        return _catfish(feedType);

      default:
        return _maintenanceFallback(animalTypeId, feedType);
    }
  }

  // =========================
  // PIG
  // =========================

  static NutrientRequirements _pig(FeedType type) {
    switch (type) {
      case FeedType.preStarter:
        return _build(1, type, 3145, 3330, 18.5, 20.35, 1.28, 1.50);

      case FeedType.starter:
        return _build(1, type, 3053, 3238, 16.65, 18.5, 1.09, 1.31);

      case FeedType.grower:
        return _build(1, type, 2960, 3145, 14.8, 16.65, 0.91, 1.13);

      case FeedType.finisher:
        return _build(1, type, 2868, 3053, 12.95, 14.8, 0.72, 0.94);

      case FeedType.lactating:
        return _build(1, type, 3053, 3330, 14.8, 16.65, 0.91, 1.13);

      default:
        return _build(1, type, 2590, 2775, 11.1, 12.95, 0.54, 0.76);
    }
  }

  // =========================
  // POULTRY
  // =========================

  static NutrientRequirements _poultry(FeedType type) {
    switch (type) {
      case FeedType.preStarter:
        return _build(2, type, 2728, 2821, 21.28, 23.13, 1.28, 1.50);

      case FeedType.starter:
        return _build(2, type, 2775, 2868, 19.43, 21.28, 1.09, 1.31);

      case FeedType.grower:
        return _build(2, type, 2868, 2960, 17.55, 19.43, 0.91, 1.13);

      case FeedType.finisher:
        return _build(2, type, 2960, 3053, 15.7, 17.55, 0.72, 0.94);

      default:
        return _build(2, type, 2590, 2775, 13.88, 15.7, 0.63, 0.85);
    }
  }

  // =========================
  // RABBIT
  // =========================

  static NutrientRequirements _rabbit(FeedType type) {
    switch (type) {
      case FeedType.starter:
      case FeedType.grower:
        return _build(3, type, 2313, 2498, 14.8, 16.65, 0.63, 0.76);

      case FeedType.lactating:
        return _build(3, type, 2405, 2590, 15.73, 17.55, 0.72, 0.85);

      default:
        return _build(3, type, 2220, 2405, 11.1, 12.95, 0.44, 0.57);
    }
  }

  // =========================
  // DAIRY
  // =========================

  static NutrientRequirements _dairy(FeedType type) {
    switch (type) {
      // Pre-Starter: Calf (6-8 weeks) - high digestibility, disease prevention
      case FeedType.preStarter:
        return _build(4, type, 2800, 3100, 18.0, 22.0, 1.1, 1.3);

      // Starter: Weaned heifer (6-9 months) - transition phase
      case FeedType.starter:
        return _build(4, type, 2600, 2900, 16.0, 18.0, 0.9, 1.1);

      // Grower: Growing heifer (12-18 months) - bone/muscle development
      case FeedType.grower:
        return _build(4, type, 2500, 2800, 14.0, 16.0, 0.8, 1.0);

      // Finisher: Pre-breeding heifer (18-24 months) - body condition
      case FeedType.finisher:
        return _build(4, type, 2400, 2700, 13.0, 15.0, 0.75, 0.95);

      // Early: Early lactation (Weeks 1-8, peak milk) - energy critical
      case FeedType.early:
        return _build(4, type, 2500, 2700, 16.0, 18.0, 0.95, 1.15);

      // Lactating: Mid/late lactation (Months 3-10) - sustained production
      case FeedType.lactating:
        return _build(4, type, 2300, 2500, 14.0, 16.0, 0.82, 0.98);

      // Gestating: Late gestation (Dry period, last 60 days) - fetal growth, mineral balance
      case FeedType.gestating:
        return _build(4, type, 2100, 2300, 11.0, 13.0, 0.7, 0.85);

      default:
        return _maintenanceFallback(4, type);
    }
  }

  // =========================
  // BEEF
  // =========================

  static NutrientRequirements _beef(FeedType type) {
    switch (type) {
      // Pre-Starter: Calf creep (70-150 lbs) - spring calves, compensatory growth
      case FeedType.preStarter:
        return _build(5, type, 2700, 2950, 15.0, 17.0, 0.85, 1.05);

      // Starter: Young animal (150-300 lbs) - post-weaning growth
      case FeedType.starter:
        return _build(5, type, 2600, 2850, 13.0, 15.0, 0.78, 0.95);

      // Grower: Growing (300-600 lbs) - frame development
      case FeedType.grower:
        return _build(5, type, 2405, 2590, 11.1, 13.88, 0.54, 0.76);

      // Finisher: Finishing (600-1100 lbs) - marbling, fattening
      case FeedType.finisher:
        return _build(5, type, 2590, 2775, 10.18, 12.05, 0.44, 0.67);

      // Early: Breeding bull - semen quality, libido, body condition
      case FeedType.early:
        return _build(5, type, 2400, 2600, 11.0, 13.0, 0.70, 0.85);

      // Gestating: Pregnant cow - late trimester growth + dry period
      case FeedType.gestating:
        return _build(5, type, 2200, 2400, 10.0, 12.0, 0.65, 0.80);

      default:
        return _maintenanceFallback(5, type);
    }
  }

  // =========================
  // SHEEP
  // =========================

  static NutrientRequirements _sheep(FeedType type) {
    switch (type) {
      // Pre-Starter: Lamb creep (birth-4 weeks, 2-8 lbs) - milk replacement
      case FeedType.preStarter:
        return _build(6, type, 2950, 3200, 18.0, 22.0, 1.1, 1.4);

      // Starter: Weaned lamb (4-8 weeks, 8-15 lbs) - transition, disease prevention
      case FeedType.starter:
        return _build(6, type, 2850, 3050, 16.0, 18.0, 1.0, 1.2);

      // Grower: Growing lamb (8-16 weeks, 15-50 lbs) - rapid growth phase
      case FeedType.grower:
        return _build(6, type, 2750, 2950, 15.0, 16.0, 0.95, 1.15);

      // Finisher: Finishing lamb (16-20 weeks, 50-110 lbs) - fattening, market finish
      case FeedType.finisher:
        return _build(6, type, 2800, 2950, 12.0, 14.0, 0.78, 0.92);

      // Early: Growing ewe (6-12 months) - reproductive tract development
      case FeedType.early:
        return _build(6, type, 2700, 2900, 13.0, 15.0, 0.85, 1.05);

      // Maintenance: Non-breeding ewe/wether - idle stock
      case FeedType.maintenance:
        return _build(6, type, 2035, 2313, 9.25, 12.95, 0.44, 0.67);

      // Gestating: Late pregnant ewe (last 4-6 weeks) - fetal growth critical
      case FeedType.gestating:
        return _build(6, type, 2500, 2700, 12.0, 14.0, 0.82, 0.98);

      // Lactating: Lactating ewe (peak, weeks 2-8) - milk production, high protein
      case FeedType.lactating:
        return _build(6, type, 2750, 3000, 15.0, 17.0, 1.0, 1.2);

      default:
        return _maintenanceFallback(6, type);
    }
  }

  // =========================
  // GOAT
  // =========================

  static NutrientRequirements _goat(FeedType type) {
    switch (type) {
      // Pre-Starter: Doeling creep (birth-2 months, 2-5 lbs) - milk replacement, high digestibility
      case FeedType.preStarter:
        return _build(7, type, 3000, 3300, 18.0, 22.0, 1.15, 1.45);

      // Starter: Young doeling (2-4 months, 5-15 lbs) - weaning transition
      case FeedType.starter:
        return _build(7, type, 2900, 3150, 17.0, 19.0, 1.1, 1.3);

      // Grower: Growing doeling (4-8 months, 15-50 lbs) - frame development (+3% protein vs sheep)
      case FeedType.grower:
        return _build(7, type, 2800, 3000, 14.0, 16.0, 0.95, 1.15);

      // Finisher: Replacement doeling (8-12 months, 50-100 lbs) - body condition, pre-breeding
      case FeedType.finisher:
        return _build(7, type, 2700, 2950, 13.0, 15.0, 0.85, 1.05);

      // Early: Breeding buck - semen quality, libido, high protein demand
      case FeedType.early:
        return _build(7, type, 2500, 2800, 12.0, 14.0, 0.78, 0.95);

      // Maintenance: Non-lactating doe/wether - idle stock
      case FeedType.maintenance:
        return _build(7, type, 2200, 2400, 10.0, 12.0, 0.68, 0.82);

      // Gestating: Late pregnant doe (last 4-6 weeks) - ketosis prevention (high for goats)
      case FeedType.gestating:
        return _build(7, type, 2600, 2850, 13.0, 15.0, 0.90, 1.10);

      // Lactating: Lactating doe (peak, weeks 2-8) - highest protein demand, high milk breeds
      case FeedType.lactating:
        return _build(7, type, 2900, 3200, 16.0, 18.0, 1.05, 1.30);

      default:
        return _maintenanceFallback(7, type);
    }
  }

  // =========================
  // TILAPIA
  // =========================

  static NutrientRequirements _tilapia(FeedType type) {
    switch (type) {
      case FeedType.micro:
        return _build(8, type, 2800, 3000, 45, 50, 1.8, 2.0);

      case FeedType.fry:
        return _build(8, type, 2900, 3100, 42, 48, 1.9, 2.2);

      case FeedType.preStarter:
        return _build(8, type, 2750, 2950, 40, 45, 1.85, 2.1);

      case FeedType.starter:
        return _build(8, type, 2683, 2960, 37, 41.63, 1.83, 2.33);

      case FeedType.grower:
        return _build(8, type, 2590, 2868, 27.75, 32.35, 1.37, 1.87);

      case FeedType.finisher:
        return _build(8, type, 2498, 2775, 23.13, 27.75, 1.09, 1.50);

      case FeedType.breeder:
        return _build(8, type, 2600, 2800, 30, 34, 1.8, 2.0);

      case FeedType.maintenance:
        return _build(8, type, 2400, 2600, 22, 26, 1.2, 1.6);

      default:
        return _build(8, type, 2498, 2775, 23.13, 27.75, 1.09, 1.50);
    }
  }

  // =========================
  // CATFISH
  // =========================

  static NutrientRequirements _catfish(FeedType type) {
    switch (type) {
      case FeedType.micro:
        return _build(9, type, 2900, 3100, 50, 55, 1.9, 2.2);

      case FeedType.fry:
        return _build(9, type, 2950, 3150, 48, 52, 2.0, 2.3);

      case FeedType.preStarter:
        return _build(9, type, 2800, 3000, 42, 48, 1.85, 2.1);

      case FeedType.starter:
        return _build(9, type, 2775, 3185, 37, 46.13, 1.83, 2.50);

      case FeedType.grower:
        return _build(9, type, 2590, 3053, 29.6, 39.78, 1.37, 1.99);

      case FeedType.finisher:
        return _build(9, type, 2498, 2960, 25.9, 34.8, 1.09, 1.60);

      case FeedType.breeder:
        return _build(9, type, 2700, 2900, 35, 40, 1.8, 2.1);

      default:
        return _build(9, type, 2498, 2960, 25.9, 34.8, 1.09, 1.60);
    }
  }

  // =========================
  // HELPERS
  // =========================

  static NutrientRequirements _build(
    int animalTypeId,
    FeedType type,
    double energyMin,
    double energyMax,
    double proteinMin,
    double proteinMax,
    double lysineMin,
    double lysineMax,
  ) {
    return NutrientRequirements(
      animalTypeId: animalTypeId,
      feedType: type,
      constraints: [
        createNutrientConstraint(
          key: NutrientKey.energy,
          min: energyMin,
          max: energyMax,
        ),
        createNutrientConstraint(
          key: NutrientKey.protein,
          min: proteinMin,
          max: proteinMax,
        ),
        createNutrientConstraint(
          key: NutrientKey.lysine,
          min: lysineMin,
          max: lysineMax,
        ),
      ],
    );
  }

  static NutrientRequirements _maintenanceFallback(
    int animalTypeId,
    FeedType type,
  ) {
    return _build(
      animalTypeId,
      type,
      2200,
      2800,
      10,
      16,
      0.5,
      1.0,
    );
  }
}
