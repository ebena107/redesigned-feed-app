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
      case FeedType.lactating:
        return _build(4, type, 2313, 2590, 14.8, 16.65, 0.81, 1.04);

      case FeedType.gestating:
        return _build(4, type, 2128, 2405, 11.1, 12.95, 0.54, 0.76);

      default:
        return _build(4, type, 2035, 2220, 9.25, 11.1, 0.44, 0.67);
    }
  }

  // =========================
  // BEEF
  // =========================

  static NutrientRequirements _beef(FeedType type) {
    switch (type) {
      case FeedType.finisher:
        return _build(5, type, 2590, 2775, 10.18, 12.05, 0.44, 0.67);

      case FeedType.grower:
        return _build(5, type, 2405, 2590, 11.1, 13.88, 0.54, 0.76);

      default:
        return _build(5, type, 2220, 2405, 9.25, 11.1, 0.44, 0.67);
    }
  }

  // =========================
  // SHEEP
  // =========================

  static NutrientRequirements _sheep(FeedType type) {
    if (type == FeedType.lactating) {
      return _build(6, type, 2313, 2590, 12.95, 16.65, 0.54, 0.76);
    }

    return _build(6, type, 2035, 2313, 9.25, 12.95, 0.44, 0.67);
  }

  // =========================
  // GOAT
  // =========================

  static NutrientRequirements _goat(FeedType type) {
    if (type == FeedType.lactating) {
      return _build(7, type, 2313, 2590, 12.95, 16.65, 0.54, 0.76);
    }

    return _build(7, type, 2035, 2313, 9.25, 12.95, 0.44, 0.67);
  }

  // =========================
  // TILAPIA
  // =========================

  static NutrientRequirements _tilapia(FeedType type) {
    switch (type) {
      case FeedType.starter:
        return _build(8, type, 2683, 2960, 37, 41.63, 1.83, 2.33);

      case FeedType.grower:
        return _build(8, type, 2590, 2868, 27.75, 32.35, 1.37, 1.87);

      default:
        return _build(8, type, 2498, 2775, 23.13, 27.75, 1.09, 1.50);
    }
  }

  // =========================
  // CATFISH
  // =========================

  static NutrientRequirements _catfish(FeedType type) {
    switch (type) {
      case FeedType.starter:
        return _build(9, type, 2775, 3185, 37, 46.13, 1.83, 2.50);

      case FeedType.grower:
        return _build(9, type, 2590, 3053, 29.6, 39.78, 1.37, 1.99);

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
