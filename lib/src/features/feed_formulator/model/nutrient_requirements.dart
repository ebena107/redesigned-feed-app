import 'feed_type.dart';
import 'formulator_constraint.dart';

/// Industry-standard nutrient requirements for feed formulation
///
/// Sources:
///   Swine:           NRC 2012 (Nutrient Requirements of Swine)
///   Poultry Broiler: NRC 1994 / Ross 308 Broiler Nutrient Specifications
///   Poultry Layer:   NRC 1994 / Hy-Line W-36 / Lohmann LSL-Classic Management Guide
///   Poultry Breeder: NRC 1994 / Cobb Breeder Management Guide
///   Rabbit:          INRA 2004 (Nutrition du Lapin) + EGRAN 2001
///   Dairy Cattle:    NRC 2001 (Nutrient Requirements of Dairy Cattle, 7th Revised Edition)
///   Beef Cattle:     NRC 2016 (Nutrient Requirements of Beef Cattle, 8th Edition)
///   Sheep:           NRC 2007 (Nutrient Requirements of Small Ruminants)
///   Goat:            NRC 2007 (Nutrient Requirements of Small Ruminants)
///   Tilapia:         NRC 2011 (Nutrient Requirements of Fish and Shrimp)
///   Catfish:         NRC 2011 + El-Sayed 2006 (Tilapia Culture)
///
/// Units:
///   Energy:     kcal ME/kg
///   CP:         % (crude protein)
///   Lysine:     % (total)
///   Methionine: % (total)
///   Calcium:    % (total)
///   Phosphorus: % (available/digestible)
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
      case 1:
        return _swine(feedType);
      case 2:
        return _poultryBroiler(feedType);
      case 3:
        return _rabbit(feedType);
      case 4:
        return _dairyCattle(feedType);
      case 5:
        return _beefCattle(feedType);
      case 6:
        return _sheep(feedType);
      case 7:
        return _goat(feedType);
      case 8:
        return _tilapia(feedType);
      case 9:
        return _catfish(feedType);
      default:
        return _maintenanceFallback(animalTypeId, feedType);
    }
  }

  // ============================================================
  // SWINE  —  NRC 2012
  // Body weight ranges: preStarter <7kg, starter 7-25kg,
  // grower 25-60kg, finisher 60-125kg
  // ============================================================
  static NutrientRequirements _swine(FeedType type) {
    switch (type) {
      // Birth to 7 kg — creep/milk replacer phase (NRC 2012, Table 10-5)
      // Energy range widened ±100 kcal (~15%) to avoid infeasibility
      case FeedType.preStarter:
        return _build(
          1,
          type,
          energyMin: 3150,
          energyMax: 3500,
          cpMin: 23.7,
          cpMax: 26.0,
          lysineMin: 1.50,
          lysineMax: 1.75,
          metMin: 0.40,
          metMax: 0.55,
          caMin: 0.85,
          caMax: 1.05,
          pMin: 0.45,
          pMax: 0.60,
        );

      // 7–25 kg — weaner phase (NRC 2012, Table 10-6)
      // Energy range widened ±100 kcal (~15%) to avoid infeasibility
      case FeedType.starter:
        return _build(
          1,
          type,
          energyMin: 2980,
          energyMax: 3380,
          cpMin: 20.0,
          cpMax: 22.5,
          lysineMin: 1.25,
          lysineMax: 1.50,
          metMin: 0.34,
          metMax: 0.46,
          caMin: 0.80,
          caMax: 0.95,
          pMin: 0.40,
          pMax: 0.52,
        );

      // 25–60 kg — grower phase (NRC 2012, Table 10-7)
      // Energy range widened ±100 kcal (~15%) to avoid infeasibility
      case FeedType.grower:
        return _build(
          1,
          type,
          energyMin: 2800,
          energyMax: 3200,
          cpMin: 17.0,
          cpMax: 19.5,
          lysineMin: 1.00,
          lysineMax: 1.20,
          metMin: 0.27,
          metMax: 0.38,
          caMin: 0.65,
          caMax: 0.80,
          pMin: 0.30,
          pMax: 0.42,
        );

      // 60–125 kg — finisher phase (NRC 2012, Table 10-8)
      // Energy range widened ±100 kcal to fix narrow-range warning (was 125 kcal)
      case FeedType.finisher:
        return _build(
          1,
          type,
          energyMin: 2720,
          energyMax: 3080,
          cpMin: 14.5,
          cpMax: 17.0,
          lysineMin: 0.78,
          lysineMax: 1.00,
          metMin: 0.21,
          metMax: 0.31,
          caMin: 0.55,
          caMax: 0.70,
          pMin: 0.23,
          pMax: 0.35,
        );

      // Gestating sows (NRC 2012, Table 10-12)
      case FeedType.gestating:
        return _build(
          1,
          type,
          energyMin: 2400,
          energyMax: 2650,
          cpMin: 12.0,
          cpMax: 14.5,
          lysineMin: 0.58,
          lysineMax: 0.78,
          metMin: 0.16,
          metMax: 0.26,
          caMin: 0.75,
          caMax: 0.90,
          pMin: 0.35,
          pMax: 0.48,
        );

      // Lactating sows (NRC 2012, Table 10-11)
      case FeedType.lactating:
        return _build(
          1,
          type,
          energyMin: 2925,
          energyMax: 3200,
          cpMin: 18.0,
          cpMax: 20.5,
          lysineMin: 0.95,
          lysineMax: 1.20,
          metMin: 0.25,
          metMax: 0.36,
          caMin: 0.78,
          caMax: 0.95,
          pMin: 0.37,
          pMax: 0.50,
        );

      // Breeding boar (NRC 2012, Table 10-13)
      // Energy range widened ±100 kcal to improve feasibility
      case FeedType.breeder:
        return _build(
          1,
          type,
          energyMin: 2620,
          energyMax: 3080,
          cpMin: 13.0,
          cpMax: 15.5,
          lysineMin: 0.60,
          lysineMax: 0.80,
          metMin: 0.16,
          metMax: 0.26,
          caMin: 0.75,
          caMax: 0.90,
          pMin: 0.35,
          pMax: 0.48,
        );

      default:
        return _build(
          1,
          type,
          energyMin: 2720,
          energyMax: 3080,
          cpMin: 14.5,
          cpMax: 17.0,
          lysineMin: 0.78,
          lysineMax: 1.00,
          metMin: 0.21,
          metMax: 0.31,
          caMin: 0.55,
          caMax: 0.70,
          pMin: 0.23,
          pMax: 0.35,
        );
    }
  }

  // ============================================================
  // POULTRY BROILER  —  NRC 1994 / Ross 308 (2022)
  // ============================================================
  static NutrientRequirements _poultryBroiler(FeedType type) {
    switch (type) {
      // 0–7 days (Ross 308 Pre-Starter)
      case FeedType.preStarter:
        return _build(
          2,
          type,
          energyMin: 2860,
          energyMax: 2960,
          cpMin: 22.0,
          cpMax: 24.0,
          lysineMin: 1.30,
          lysineMax: 1.55,
          metMin: 0.50,
          metMax: 0.65,
          caMin: 0.95,
          caMax: 1.05,
          pMin: 0.45,
          pMax: 0.55,
        );

      // 0–14 days starter (NRC 1994, Table 1 / Ross 308)
      case FeedType.starter:
        return _build(
          2,
          type,
          energyMin: 2900,
          energyMax: 3000,
          cpMin: 22.0,
          cpMax: 24.0,
          lysineMin: 1.22,
          lysineMax: 1.44,
          metMin: 0.50,
          metMax: 0.62,
          caMin: 0.95,
          caMax: 1.10,
          pMin: 0.45,
          pMax: 0.55,
        );

      // 15–28 days grower (NRC 1994 / Ross 308)
      case FeedType.grower:
        return _build(
          2,
          type,
          energyMin: 2950,
          energyMax: 3050,
          cpMin: 19.0,
          cpMax: 21.5,
          lysineMin: 1.05,
          lysineMax: 1.25,
          metMin: 0.42,
          metMax: 0.54,
          caMin: 0.86,
          caMax: 1.00,
          pMin: 0.40,
          pMax: 0.50,
        );

      // 29–42+ days finisher (NRC 1994 / Ross 308 Finisher)
      case FeedType.finisher:
        return _build(
          2,
          type,
          energyMin: 3050,
          energyMax: 3150,
          cpMin: 17.0,
          cpMax: 19.0,
          lysineMin: 0.95,
          lysineMax: 1.15,
          metMin: 0.38,
          metMax: 0.48,
          caMin: 0.78,
          caMax: 0.92,
          pMin: 0.36,
          pMax: 0.46,
        );

      // Poultry layer — NRC 1994 / Hy-Line W-36 commercial guide
      case FeedType.layer:
        return _build(
          2, type,
          energyMin: 2750, energyMax: 2900,
          cpMin: 15.5, cpMax: 17.5,
          lysineMin: 0.73, lysineMax: 0.90,
          metMin: 0.34, metMax: 0.45,
          caMin: 3.50, caMax: 4.50, // High Ca for eggshell formation
          pMin: 0.30, pMax: 0.42,
        );

      // Poultry breeder — NRC 1994 / Cobb Breeder Guide
      case FeedType.breeder:
        return _build(
          2,
          type,
          energyMin: 2750,
          energyMax: 2860,
          cpMin: 15.0,
          cpMax: 17.0,
          lysineMin: 0.68,
          lysineMax: 0.85,
          metMin: 0.32,
          metMax: 0.43,
          caMin: 2.50,
          caMax: 3.50,
          pMin: 0.30,
          pMax: 0.42,
        );

      default:
        return _build(
          2,
          type,
          energyMin: 2950,
          energyMax: 3050,
          cpMin: 19.0,
          cpMax: 21.5,
          lysineMin: 1.05,
          lysineMax: 1.25,
          metMin: 0.42,
          metMax: 0.54,
          caMin: 0.86,
          caMax: 1.00,
          pMin: 0.40,
          pMax: 0.50,
        );
    }
  }

  // ============================================================
  // RABBIT  —  INRA 2004 / EGRAN 2001
  // ============================================================
  static NutrientRequirements _rabbit(FeedType type) {
    switch (type) {
      // Weaning to 5 weeks (INRA 2004)
      case FeedType.preStarter:
      case FeedType.starter:
        return _build(
          3,
          type,
          energyMin: 2500,
          energyMax: 2700,
          cpMin: 17.0,
          cpMax: 19.0,
          lysineMin: 0.80,
          lysineMax: 0.98,
          metMin: 0.40,
          metMax: 0.52,
          caMin: 0.80,
          caMax: 1.00,
          pMin: 0.38,
          pMax: 0.50,
        );

      // 5–11 weeks fattening (EGRAN 2001)
      case FeedType.grower:
        return _build(
          3,
          type,
          energyMin: 2350,
          energyMax: 2550,
          cpMin: 15.0,
          cpMax: 17.0,
          lysineMin: 0.70,
          lysineMax: 0.88,
          metMin: 0.35,
          metMax: 0.47,
          caMin: 0.70,
          caMax: 0.90,
          pMin: 0.35,
          pMax: 0.47,
        );

      // Pre-slaughter 11–13 weeks (INRA 2004)
      case FeedType.finisher:
        return _build(
          3,
          type,
          energyMin: 2300,
          energyMax: 2500,
          cpMin: 14.0,
          cpMax: 16.0,
          lysineMin: 0.65,
          lysineMax: 0.82,
          metMin: 0.32,
          metMax: 0.44,
          caMin: 0.65,
          caMax: 0.85,
          pMin: 0.32,
          pMax: 0.44,
        );

      // Gestating does (INRA 2004, Table 4-2)
      case FeedType.gestating:
        return _build(
          3,
          type,
          energyMin: 2300,
          energyMax: 2500,
          cpMin: 14.5,
          cpMax: 16.5,
          lysineMin: 0.70,
          lysineMax: 0.88,
          metMin: 0.33,
          metMax: 0.45,
          caMin: 0.80,
          caMax: 1.00,
          pMin: 0.40,
          pMax: 0.52,
        );

      // Lactating does (INRA 2004, Table 4-2) — peak demand
      case FeedType.lactating:
        return _build(
          3,
          type,
          energyMin: 2550,
          energyMax: 2750,
          cpMin: 18.0,
          cpMax: 20.0,
          lysineMin: 0.88,
          lysineMax: 1.08,
          metMin: 0.42,
          metMax: 0.55,
          caMin: 1.00,
          caMax: 1.25,
          pMin: 0.50,
          pMax: 0.65,
        );

      // Adult maintenance / breeder (INRA 2004)
      default:
        return _build(
          3,
          type,
          energyMin: 2200,
          energyMax: 2400,
          cpMin: 12.0,
          cpMax: 14.5,
          lysineMin: 0.55,
          lysineMax: 0.72,
          metMin: 0.28,
          metMax: 0.40,
          caMin: 0.65,
          caMax: 0.85,
          pMin: 0.32,
          pMax: 0.44,
        );
    }
  }

  // ============================================================
  // DAIRY CATTLE  —  NRC 2001 (7th Revised Edition)
  // ============================================================
  static NutrientRequirements _dairyCattle(FeedType type) {
    switch (type) {
      // Calf 0–8 weeks (NRC 2001, Table 10-1)
      case FeedType.preStarter:
        return _build(
          4,
          type,
          energyMin: 3000,
          energyMax: 3200,
          cpMin: 20.0,
          cpMax: 23.0,
          lysineMin: 0.95,
          lysineMax: 1.15,
          metMin: 0.36,
          metMax: 0.48,
          caMin: 0.90,
          caMax: 1.10,
          pMin: 0.50,
          pMax: 0.65,
        );

      // Heifer 2–6 months (NRC 2001)
      case FeedType.starter:
        return _build(
          4,
          type,
          energyMin: 2700,
          energyMax: 2950,
          cpMin: 16.0,
          cpMax: 18.5,
          lysineMin: 0.78,
          lysineMax: 0.98,
          metMin: 0.27,
          metMax: 0.39,
          caMin: 0.70,
          caMax: 0.90,
          pMin: 0.40,
          pMax: 0.52,
        );

      // Heifer 6–15 months (NRC 2001)
      case FeedType.grower:
        return _build(
          4,
          type,
          energyMin: 2550,
          energyMax: 2800,
          cpMin: 13.5,
          cpMax: 16.0,
          lysineMin: 0.62,
          lysineMax: 0.82,
          metMin: 0.22,
          metMax: 0.32,
          caMin: 0.55,
          caMax: 0.75,
          pMin: 0.30,
          pMax: 0.42,
        );

      // Replacement heifer 15–24 months pre-calving (NRC 2001)
      case FeedType.finisher:
        return _build(
          4,
          type,
          energyMin: 2450,
          energyMax: 2700,
          cpMin: 12.5,
          cpMax: 15.0,
          lysineMin: 0.58,
          lysineMax: 0.78,
          metMin: 0.20,
          metMax: 0.30,
          caMin: 0.52,
          caMax: 0.70,
          pMin: 0.28,
          pMax: 0.40,
        );

      // Early lactation 0–70 DIM (NRC 2001, Table 7-1 — high-producing cow)
      case FeedType.early:
        return _build(
          4,
          type,
          energyMin: 2550,
          energyMax: 2750,
          cpMin: 17.0,
          cpMax: 19.0,
          lysineMin: 0.88,
          lysineMax: 1.05,
          metMin: 0.30,
          metMax: 0.42,
          caMin: 0.75,
          caMax: 0.95,
          pMin: 0.38,
          pMax: 0.52,
        );

      // Mid/late lactation 70-305 DIM (NRC 2001)
      case FeedType.lactating:
        return _build(
          4,
          type,
          energyMin: 2400,
          energyMax: 2600,
          cpMin: 14.5,
          cpMax: 16.5,
          lysineMin: 0.72,
          lysineMax: 0.90,
          metMin: 0.24,
          metMax: 0.36,
          caMin: 0.62,
          caMax: 0.82,
          pMin: 0.30,
          pMax: 0.44,
        );

      // Dry period / far-off dry cow (NRC 2001)
      case FeedType.gestating:
        return _build(
          4,
          type,
          energyMin: 2100,
          energyMax: 2350,
          cpMin: 11.5,
          cpMax: 13.5,
          lysineMin: 0.55,
          lysineMax: 0.72,
          metMin: 0.19,
          metMax: 0.29,
          caMin: 0.48,
          caMax: 0.65,
          pMin: 0.25,
          pMax: 0.38,
        );

      default:
        return _maintenanceFallback(4, type);
    }
  }

  // ============================================================
  // BEEF CATTLE  —  NRC 2016 (8th Revised Edition)
  // ============================================================
  static NutrientRequirements _beefCattle(FeedType type) {
    switch (type) {
      // Creep-fed calves < 150 kg (NRC 2016, Table 15-1)
      case FeedType.preStarter:
        return _build(
          5,
          type,
          energyMin: 2800,
          energyMax: 3000,
          cpMin: 15.0,
          cpMax: 17.5,
          lysineMin: 0.72,
          lysineMax: 0.90,
          metMin: 0.22,
          metMax: 0.32,
          caMin: 0.70,
          caMax: 0.90,
          pMin: 0.35,
          pMax: 0.48,
        );

      // Growing calves 150–300 kg post-weaning (NRC 2016)
      case FeedType.starter:
        return _build(
          5,
          type,
          energyMin: 2650,
          energyMax: 2850,
          cpMin: 13.0,
          cpMax: 15.5,
          lysineMin: 0.60,
          lysineMax: 0.78,
          metMin: 0.19,
          metMax: 0.29,
          caMin: 0.60,
          caMax: 0.78,
          pMin: 0.28,
          pMax: 0.40,
        );

      // Growing stocker 300–500 kg (NRC 2016)
      case FeedType.grower:
        return _build(
          5,
          type,
          energyMin: 2450,
          energyMax: 2650,
          cpMin: 11.0,
          cpMax: 13.5,
          lysineMin: 0.50,
          lysineMax: 0.68,
          metMin: 0.16,
          metMax: 0.25,
          caMin: 0.50,
          caMax: 0.68,
          pMin: 0.23,
          pMax: 0.35,
        );

      // Feedlot finishing 400–650 kg (NRC 2016, Table 21-1)
      case FeedType.finisher:
        return _build(
          5,
          type,
          energyMin: 2600,
          energyMax: 2850,
          cpMin: 10.5,
          cpMax: 13.0,
          lysineMin: 0.48,
          lysineMax: 0.65,
          metMin: 0.15,
          metMax: 0.24,
          caMin: 0.44,
          caMax: 0.62,
          pMin: 0.20,
          pMax: 0.32,
        );

      // Late gestating cows, last trimester (NRC 2016)
      case FeedType.gestating:
        return _build(
          5,
          type,
          energyMin: 2200,
          energyMax: 2450,
          cpMin: 10.0,
          cpMax: 12.5,
          lysineMin: 0.44,
          lysineMax: 0.62,
          metMin: 0.14,
          metMax: 0.22,
          caMin: 0.48,
          caMax: 0.65,
          pMin: 0.22,
          pMax: 0.34,
        );

      // Breeding bull (NRC 2016, Table 23-1)
      case FeedType.breeder:
        return _build(
          5,
          type,
          energyMin: 2400,
          energyMax: 2650,
          cpMin: 10.5,
          cpMax: 13.0,
          lysineMin: 0.46,
          lysineMax: 0.63,
          metMin: 0.14,
          metMax: 0.23,
          caMin: 0.44,
          caMax: 0.62,
          pMin: 0.20,
          pMax: 0.32,
        );

      default:
        return _maintenanceFallback(5, type);
    }
  }

  // ============================================================
  // SHEEP  —  NRC 2007 (Nutrient Requirements of Small Ruminants)
  // ============================================================
  static NutrientRequirements _sheep(FeedType type) {
    switch (type) {
      // Suckling lamb 0–4 weeks (NRC 2007, Table 16-1)
      case FeedType.preStarter:
        return _build(
          6,
          type,
          energyMin: 3000,
          energyMax: 3250,
          cpMin: 22.0,
          cpMax: 26.0,
          lysineMin: 1.00,
          lysineMax: 1.25,
          metMin: 0.32,
          metMax: 0.44,
          caMin: 0.80,
          caMax: 1.00,
          pMin: 0.40,
          pMax: 0.55,
        );

      // Weaned lamb 4–8 weeks (NRC 2007)
      case FeedType.starter:
        return _build(
          6,
          type,
          energyMin: 2850,
          energyMax: 3050,
          cpMin: 18.0,
          cpMax: 20.5,
          lysineMin: 0.85,
          lysineMax: 1.05,
          metMin: 0.27,
          metMax: 0.39,
          caMin: 0.72,
          caMax: 0.90,
          pMin: 0.35,
          pMax: 0.47,
        );

      // Growing lamb 8–16 weeks (NRC 2007, Table 16-3)
      case FeedType.grower:
        return _build(
          6,
          type,
          energyMin: 2750,
          energyMax: 2950,
          cpMin: 15.5,
          cpMax: 17.5,
          lysineMin: 0.73,
          lysineMax: 0.92,
          metMin: 0.23,
          metMax: 0.35,
          caMin: 0.60,
          caMax: 0.80,
          pMin: 0.28,
          pMax: 0.40,
        );

      // Finishing lamb 16–24 weeks (NRC 2007)
      case FeedType.finisher:
        return _build(
          6,
          type,
          energyMin: 2800,
          energyMax: 3000,
          cpMin: 13.5,
          cpMax: 15.5,
          lysineMin: 0.62,
          lysineMax: 0.80,
          metMin: 0.20,
          metMax: 0.30,
          caMin: 0.52,
          caMax: 0.70,
          pMin: 0.24,
          pMax: 0.36,
        );

      // Ewes last 6 weeks of gestation — twin-bearing (NRC 2007)
      case FeedType.gestating:
        return _build(
          6,
          type,
          energyMin: 2500,
          energyMax: 2750,
          cpMin: 12.5,
          cpMax: 15.0,
          lysineMin: 0.60,
          lysineMax: 0.78,
          metMin: 0.19,
          metMax: 0.29,
          caMin: 0.45,
          caMax: 0.65,
          pMin: 0.22,
          pMax: 0.34,
        );

      // Lactating ewes weeks 1–8 peak milk (NRC 2007)
      case FeedType.lactating:
        return _build(
          6,
          type,
          energyMin: 2750,
          energyMax: 3000,
          cpMin: 15.0,
          cpMax: 17.5,
          lysineMin: 0.72,
          lysineMax: 0.90,
          metMin: 0.23,
          metMax: 0.35,
          caMin: 0.48,
          caMax: 0.68,
          pMin: 0.26,
          pMax: 0.38,
        );

      // Adult maintenance — non-productive ewes (NRC 2007)
      case FeedType.maintenance:
        return _build(
          6,
          type,
          energyMin: 2100,
          energyMax: 2350,
          cpMin: 9.5,
          cpMax: 11.5,
          lysineMin: 0.44,
          lysineMax: 0.60,
          metMin: 0.14,
          metMax: 0.22,
          caMin: 0.35,
          caMax: 0.50,
          pMin: 0.17,
          pMax: 0.28,
        );

      default:
        return _maintenanceFallback(6, type);
    }
  }

  // ============================================================
  // GOAT  —  NRC 2007 (same source as sheep, adjusted upward)
  // Goats have ~5-10% higher maintenance requirements vs sheep
  // ============================================================
  static NutrientRequirements _goat(FeedType type) {
    switch (type) {
      case FeedType.preStarter:
        return _build(
          7,
          type,
          energyMin: 3000,
          energyMax: 3300,
          cpMin: 22.0,
          cpMax: 26.0,
          lysineMin: 1.05,
          lysineMax: 1.30,
          metMin: 0.33,
          metMax: 0.45,
          caMin: 0.82,
          caMax: 1.02,
          pMin: 0.42,
          pMax: 0.57,
        );

      case FeedType.starter:
        return _build(
          7,
          type,
          energyMin: 2900,
          energyMax: 3100,
          cpMin: 18.0,
          cpMax: 21.0,
          lysineMin: 0.87,
          lysineMax: 1.07,
          metMin: 0.28,
          metMax: 0.40,
          caMin: 0.73,
          caMax: 0.93,
          pMin: 0.36,
          pMax: 0.49,
        );

      case FeedType.grower:
        return _build(
          7,
          type,
          energyMin: 2800,
          energyMax: 3000,
          cpMin: 15.5,
          cpMax: 18.0,
          lysineMin: 0.74,
          lysineMax: 0.94,
          metMin: 0.24,
          metMax: 0.36,
          caMin: 0.62,
          caMax: 0.82,
          pMin: 0.29,
          pMax: 0.42,
        );

      case FeedType.finisher:
        return _build(
          7,
          type,
          energyMin: 2700,
          energyMax: 2950,
          cpMin: 13.5,
          cpMax: 16.0,
          lysineMin: 0.62,
          lysineMax: 0.82,
          metMin: 0.20,
          metMax: 0.31,
          caMin: 0.53,
          caMax: 0.72,
          pMin: 0.25,
          pMax: 0.37,
        );

      case FeedType.gestating:
        return _build(
          7,
          type,
          energyMin: 2600,
          energyMax: 2850,
          cpMin: 13.0,
          cpMax: 15.5,
          lysineMin: 0.62,
          lysineMax: 0.80,
          metMin: 0.20,
          metMax: 0.30,
          caMin: 0.46,
          caMax: 0.66,
          pMin: 0.23,
          pMax: 0.35,
        );

      case FeedType.lactating:
        return _build(
          7,
          type,
          energyMin: 2900,
          energyMax: 3200,
          cpMin: 16.0,
          cpMax: 18.5,
          lysineMin: 0.76,
          lysineMax: 0.96,
          metMin: 0.24,
          metMax: 0.37,
          caMin: 0.50,
          caMax: 0.70,
          pMin: 0.27,
          pMax: 0.40,
        );

      case FeedType.maintenance:
        return _build(
          7,
          type,
          energyMin: 2200,
          energyMax: 2450,
          cpMin: 10.0,
          cpMax: 12.5,
          lysineMin: 0.46,
          lysineMax: 0.63,
          metMin: 0.15,
          metMax: 0.23,
          caMin: 0.36,
          caMax: 0.52,
          pMin: 0.18,
          pMax: 0.29,
        );

      // Breeding buck (NRC 2007)
      case FeedType.breeder:
        return _build(
          7,
          type,
          energyMin: 2600,
          energyMax: 2850,
          cpMin: 13.5,
          cpMax: 16.0,
          lysineMin: 0.64,
          lysineMax: 0.82,
          metMin: 0.21,
          metMax: 0.31,
          caMin: 0.44,
          caMax: 0.62,
          pMin: 0.22,
          pMax: 0.34,
        );

      default:
        return _maintenanceFallback(7, type);
    }
  }

  // ============================================================
  // TILAPIA  —  NRC 2011 (Nutrient Requirements of Fish and Shrimp)
  // Based on Oreochromis niloticus (Nile Tilapia) research data
  // ============================================================
  static NutrientRequirements _tilapia(FeedType type) {
    switch (type) {
      // Larvae/hatchery fry <0.5 g (NRC 2011, Table 9-1)
      case FeedType.micro:
        return _build(
          8,
          type,
          energyMin: 2900,
          energyMax: 3100,
          cpMin: 45.0,
          cpMax: 50.0,
          lysineMin: 2.00,
          lysineMax: 2.40,
          metMin: 1.00,
          metMax: 1.30,
          caMin: 1.60,
          caMax: 2.00,
          pMin: 0.90,
          pMax: 1.20,
        );

      // Fry 0.5–5 g (NRC 2011)
      case FeedType.fry:
        return _build(
          8,
          type,
          energyMin: 2900,
          energyMax: 3100,
          cpMin: 42.0,
          cpMax: 48.0,
          lysineMin: 1.90,
          lysineMax: 2.30,
          metMin: 0.95,
          metMax: 1.25,
          caMin: 1.50,
          caMax: 1.90,
          pMin: 0.85,
          pMax: 1.10,
        );

      // Fingerling 5–30 g (NRC 2011, Table 9-2)
      case FeedType.preStarter:
        return _build(
          8,
          type,
          energyMin: 2800,
          energyMax: 3000,
          cpMin: 38.0,
          cpMax: 44.0,
          lysineMin: 1.75,
          lysineMax: 2.10,
          metMin: 0.88,
          metMax: 1.15,
          caMin: 1.40,
          caMax: 1.80,
          pMin: 0.80,
          pMax: 1.05,
        );

      // Fingerling/nursery 30–100 g (El-Sayed 2006)
      case FeedType.starter:
        return _build(
          8,
          type,
          energyMin: 2750,
          energyMax: 2950,
          cpMin: 34.0,
          cpMax: 40.0,
          lysineMin: 1.55,
          lysineMax: 1.90,
          metMin: 0.78,
          metMax: 1.05,
          caMin: 1.20,
          caMax: 1.60,
          pMin: 0.70,
          pMax: 0.95,
        );

      // Juvenile grow-out 100–300 g (NRC 2011)
      case FeedType.grower:
        return _build(
          8,
          type,
          energyMin: 2650,
          energyMax: 2850,
          cpMin: 28.0,
          cpMax: 34.0,
          lysineMin: 1.30,
          lysineMax: 1.65,
          metMin: 0.65,
          metMax: 0.90,
          caMin: 1.00,
          caMax: 1.40,
          pMin: 0.60,
          pMax: 0.85,
        );

      // Market grow-out 300 g – market (NRC 2011)
      case FeedType.finisher:
        return _build(
          8,
          type,
          energyMin: 2600,
          energyMax: 2800,
          cpMin: 24.0,
          cpMax: 30.0,
          lysineMin: 1.10,
          lysineMax: 1.45,
          metMin: 0.55,
          metMax: 0.78,
          caMin: 0.90,
          caMax: 1.25,
          pMin: 0.50,
          pMax: 0.75,
        );

      // Broodstock (NRC 2011, Table 9-3)
      case FeedType.breeder:
        return _build(
          8,
          type,
          energyMin: 2700,
          energyMax: 2900,
          cpMin: 30.0,
          cpMax: 36.0,
          lysineMin: 1.35,
          lysineMax: 1.70,
          metMin: 0.68,
          metMax: 0.92,
          caMin: 1.10,
          caMax: 1.50,
          pMin: 0.65,
          pMax: 0.90,
        );

      // Maintenance (non-productive overwintering)
      case FeedType.maintenance:
        return _build(
          8,
          type,
          energyMin: 2400,
          energyMax: 2650,
          cpMin: 20.0,
          cpMax: 26.0,
          lysineMin: 0.92,
          lysineMax: 1.20,
          metMin: 0.46,
          metMax: 0.65,
          caMin: 0.80,
          caMax: 1.10,
          pMin: 0.45,
          pMax: 0.65,
        );

      default:
        return _build(
          8,
          type,
          energyMin: 2650,
          energyMax: 2850,
          cpMin: 28.0,
          cpMax: 34.0,
          lysineMin: 1.30,
          lysineMax: 1.65,
          metMin: 0.65,
          metMax: 0.90,
          caMin: 1.00,
          caMax: 1.40,
          pMin: 0.60,
          pMax: 0.85,
        );
    }
  }

  // ============================================================
  // CATFISH  —  NRC 2011 / Lovell 1989 (Channel Catfish Nutrition)
  // Based on Clarias gariepinus (African Catfish) / Ictalurus punctatus
  // ============================================================
  static NutrientRequirements _catfish(FeedType type) {
    switch (type) {
      // Microparticle / first feeding <0.5 g (NRC 2011)
      case FeedType.micro:
        return _build(
          9,
          type,
          energyMin: 3000,
          energyMax: 3200,
          cpMin: 48.0,
          cpMax: 55.0,
          lysineMin: 2.10,
          lysineMax: 2.55,
          metMin: 1.05,
          metMax: 1.40,
          caMin: 1.80,
          caMax: 2.20,
          pMin: 1.00,
          pMax: 1.35,
        );

      // Hatchery fry 0.5–5 g (NRC 2011)
      case FeedType.fry:
        return _build(
          9,
          type,
          energyMin: 3000,
          energyMax: 3200,
          cpMin: 45.0,
          cpMax: 50.0,
          lysineMin: 1.95,
          lysineMax: 2.35,
          metMin: 0.98,
          metMax: 1.30,
          caMin: 1.65,
          caMax: 2.05,
          pMin: 0.92,
          pMax: 1.20,
        );

      // Fingerling 5–30 g (Lovell 1989)
      case FeedType.preStarter:
        return _build(
          9,
          type,
          energyMin: 2900,
          energyMax: 3100,
          cpMin: 40.0,
          cpMax: 48.0,
          lysineMin: 1.75,
          lysineMax: 2.15,
          metMin: 0.88,
          metMax: 1.18,
          caMin: 1.50,
          caMax: 1.90,
          pMin: 0.85,
          pMax: 1.12,
        );

      // Nursery 30–100 g (NRC 2011, Table 14-2)
      case FeedType.starter:
        return _build(
          9,
          type,
          energyMin: 2800,
          energyMax: 3050,
          cpMin: 36.0,
          cpMax: 44.0,
          lysineMin: 1.55,
          lysineMax: 1.95,
          metMin: 0.78,
          metMax: 1.05,
          caMin: 1.30,
          caMax: 1.70,
          pMin: 0.75,
          pMax: 1.00,
        );

      // Grow-out phase I 100–500 g (NRC 2011)
      case FeedType.grower:
        return _build(
          9,
          type,
          energyMin: 2650,
          energyMax: 2900,
          cpMin: 30.0,
          cpMax: 38.0,
          lysineMin: 1.30,
          lysineMax: 1.68,
          metMin: 0.65,
          metMax: 0.90,
          caMin: 1.10,
          caMax: 1.50,
          pMin: 0.62,
          pMax: 0.88,
        );

      // Grow-out phase II / market >500 g (NRC 2011)
      case FeedType.finisher:
        return _build(
          9,
          type,
          energyMin: 2550,
          energyMax: 2800,
          cpMin: 26.0,
          cpMax: 34.0,
          lysineMin: 1.12,
          lysineMax: 1.50,
          metMin: 0.56,
          metMax: 0.80,
          caMin: 0.95,
          caMax: 1.30,
          pMin: 0.55,
          pMax: 0.78,
        );

      // Broodstock — conditioning and spawning (NRC 2011)
      case FeedType.breeder:
        return _build(
          9,
          type,
          energyMin: 2800,
          energyMax: 3000,
          cpMin: 34.0,
          cpMax: 40.0,
          lysineMin: 1.45,
          lysineMax: 1.82,
          metMin: 0.73,
          metMax: 0.98,
          caMin: 1.20,
          caMax: 1.60,
          pMin: 0.70,
          pMax: 0.95,
        );

      // Off-season / non-productive maintenance (NRC 2011)
      case FeedType.maintenance:
        return _build(
          9,
          type,
          energyMin: 2400,
          energyMax: 2650,
          cpMin: 22.0,
          cpMax: 28.0,
          lysineMin: 0.96,
          lysineMax: 1.25,
          metMin: 0.48,
          metMax: 0.68,
          caMin: 0.85,
          caMax: 1.15,
          pMin: 0.48,
          pMax: 0.68,
        );

      default:
        return _build(
          9,
          type,
          energyMin: 2650,
          energyMax: 2900,
          cpMin: 30.0,
          cpMax: 38.0,
          lysineMin: 1.30,
          lysineMax: 1.68,
          metMin: 0.65,
          metMax: 0.90,
          caMin: 1.10,
          caMax: 1.50,
          pMin: 0.62,
          pMax: 0.88,
        );
    }
  }

  // ============================================================
  // HELPERS
  // ============================================================

  /// Build a full nutrient constraint set for a species + stage.
  ///
  /// Energy in kcal ME/kg; all others in %.
  ///
  /// Auto-widens any constraint range that is too narrow to be feasible:
  ///   - Energy:        minimum 200 kcal spread (engine warns below 150)
  ///   - All others:    minimum 0.40 % spread  (engine warns below 0.35)
  /// Expansion is symmetric (equal left and right) so the biological
  /// midpoint stays centred on the NRC/INRA reference value.
  static NutrientRequirements _build(
    int animalTypeId,
    FeedType type, {
    required double energyMin,
    required double energyMax,
    required double cpMin,
    required double cpMax,
    required double lysineMin,
    required double lysineMax,
    required double metMin,
    required double metMax,
    required double caMin,
    required double caMax,
    required double pMin,
    required double pMax,
  }) {
    // ── Auto-widen helper ──────────────────────────────────────────────────
    (double, double) widen(double lo, double hi, double minWidth) {
      final gap = hi - lo;
      if (gap >= minWidth) return (lo, hi);
      final expand = (minWidth - gap) / 2;
      return (lo - expand, hi + expand);
    }

    // Enforce minimum range widths before passing to constraints
    const minEnergyWidth = 200.0; // kcal
    const minPctWidth = 0.40; // %

    (energyMin, energyMax) = widen(energyMin, energyMax, minEnergyWidth);
    (cpMin, cpMax) = widen(cpMin, cpMax, minPctWidth);
    (lysineMin, lysineMax) = widen(lysineMin, lysineMax, minPctWidth);
    (metMin, metMax) = widen(metMin, metMax, minPctWidth);
    (caMin, caMax) = widen(caMin, caMax, minPctWidth);
    (pMin, pMax) = widen(pMin, pMax, minPctWidth);
    // ──────────────────────────────────────────────────────────────────────

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
          min: cpMin,
          max: cpMax,
        ),
        createNutrientConstraint(
          key: NutrientKey.lysine,
          min: lysineMin,
          max: lysineMax,
        ),
        createNutrientConstraint(
          key: NutrientKey.methionine,
          min: metMin,
          max: metMax,
        ),
        createNutrientConstraint(
          key: NutrientKey.calcium,
          min: caMin,
          max: caMax,
        ),
        createNutrientConstraint(
          key: NutrientKey.phosphorus,
          min: pMin,
          max: pMax,
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
      energyMin: 2100,
      energyMax: 2500,
      cpMin: 10.0,
      cpMax: 14.0,
      lysineMin: 0.45,
      lysineMax: 0.65,
      metMin: 0.14,
      metMax: 0.24,
      caMin: 0.40,
      caMax: 0.60,
      pMin: 0.20,
      pMax: 0.35,
    );
  }
}
