/// Detailed descriptions for production stages
/// Provides UI-friendly labels, stage-specific guidance, and nutritional context
///
/// Use these for dropdown labels, tooltips, and educational content in the feed formulation UI.
library;

import 'feed_type.dart';

/// Maps production stages to detailed descriptions, UI labels, and guidance
class FeedTypeDescriptions {
  /// Get human-readable label for a feed type with context
  /// e.g. "Dairy Calf Pre-Starter (0-6 weeks)" instead of just "Pre-starter"
  static String getDetailedLabel(FeedType feedType, {int? animalTypeId}) {
    if (animalTypeId == null) {
      return feedType.label;
    }

    switch (animalTypeId) {
      case 4: // Dairy Cattle
        return _dairyDetailedLabel(feedType);
      case 5: // Beef Cattle
        return _beefDetailedLabel(feedType);
      case 6: // Sheep
        return _sheepDetailedLabel(feedType);
      case 7: // Goat
        return _goatDetailedLabel(feedType);
      default:
        return feedType.label;
    }
  }

  /// Get brief nutrition-focused description for UI tooltips
  static String getDescription(FeedType feedType, {int? animalTypeId}) {
    if (animalTypeId == null) {
      return '';
    }

    switch (animalTypeId) {
      case 4:
        return _dairyDescription(feedType);
      case 5:
        return _beefDescription(feedType);
      case 6:
        return _sheepDescription(feedType);
      case 7:
        return _goatDescription(feedType);
      default:
        return '';
    }
  }

  /// Get management guidance for farmers
  static String getGuidance(FeedType feedType, {int? animalTypeId}) {
    if (animalTypeId == null) {
      return '';
    }

    switch (animalTypeId) {
      case 4:
        return _dairyGuidance(feedType);
      case 5:
        return _beefGuidance(feedType);
      case 6:
        return _sheepGuidance(feedType);
      case 7:
        return _goatGuidance(feedType);
      default:
        return '';
    }
  }

  // ===== DAIRY CATTLE LABELS & DESCRIPTIONS =====

  static String _dairyDetailedLabel(FeedType feedType) {
    switch (feedType) {
      case FeedType.preStarter:
        return 'Dairy Calf Pre-Starter (0-6 weeks)';
      case FeedType.starter:
        return 'Dairy Calf Starter (6-9 months)';
      case FeedType.grower:
        return 'Dairy Heifer Grower (12-18 months)';
      case FeedType.finisher:
        return 'Dairy Heifer Finisher (18-24 months)';
      case FeedType.early:
        return 'Dairy Lactation - Early/Peak (1-4 weeks)';
      case FeedType.lactating:
        return 'Dairy Lactation - Mid/Late (4-305 days)';
      case FeedType.gestating:
        return 'Dairy Gestation - Dry Period (8-1 weeks)';
      default:
        return feedType.label;
    }
  }

  static String _dairyDescription(FeedType feedType) {
    switch (feedType) {
      case FeedType.preStarter:
        return 'High digestibility milk replacer transition. High CP (18-22%), high vitamins/minerals for immunity.';
      case FeedType.starter:
        return 'Weaned heifer growth (1.5-2.0 lbs/day). Balanced minerals calcium:phosphorus (2:1) for skeleton development.';
      case FeedType.grower:
        return 'Growing heifer (2.0-2.5 lbs/day). Optimize frame before puberty. Prevent overfeeding energy.';
      case FeedType.finisher:
        return 'Pre-breeding heifer conditioning. Moderate energy to achieve target BCS (3.0) at breeding.';
      case FeedType.early:
        return 'CRITICAL: Peak milk production (40-50 lbs/day). High energy (2500-2700 kcal), high CP (16-18%), monitor body condition.';
      case FeedType.lactating:
        return 'Sustained lactation. Balanced energy/protein to maintain milk production and body reserves.';
      case FeedType.gestating:
        return 'Late pregnancy and dry period. Lower energy but ESSENTIAL minerals for milk fever prevention (Ca:P:K ratios).';
      default:
        return '';
    }
  }

  static String _dairyGuidance(FeedType feedType) {
    switch (feedType) {
      case FeedType.preStarter:
        return '✓ Limit dietary fibers (max 30% NDF). Ensure palatability for transition from milk. Use high-quality grains.';
      case FeedType.starter:
        return '✓ Provide free-choice quality hay. Monitor rumen development. Avoid excessive concentrates (max 50% diet).';
      case FeedType.grower:
        return '✓ Target growth rate 1.5-2.0 lbs/day. Use balanced protein (amino acid ratios important). Check mineral status.';
      case FeedType.finisher:
        return '✓ Achieve target weight 1300 lbs @ 14-18 months. Moderate energy to avoid obesity (affects fertility). BCS 3.0-3.2.';
      case FeedType.early:
        return '✓ Peak energy demand period. Provide separate early lactation ration if possible. Monitor dry matter intake (>20 lbs/day). Risk of ketosis/LCHF - feed minerals aggressively.';
      case FeedType.lactating:
        return '✓ Adjust ration based on milk production level. Target energy balance neutral or +1 Mcal/day. Monitor body condition score monthly.';
      case FeedType.gestating:
        return '✓ CRITICAL for health: Monitor calcium intake (1st third gestation low, 3rd trimester high). Magnesium critical (0.4-0.5%) for milk fever prevention. Avoid moldy feeds (mycotoxins damage placenta).';
      default:
        return '';
    }
  }

  // ===== BEEF CATTLE LABELS & DESCRIPTIONS =====

  static String _beefDetailedLabel(FeedType feedType) {
    switch (feedType) {
      case FeedType.preStarter:
        return 'Beef Calf Pre-Starter/Creep (70-150 lbs)';
      case FeedType.starter:
        return 'Beef Calf Starter (150-300 lbs)';
      case FeedType.grower:
        return 'Beef Feeder Grower (300-600 lbs)';
      case FeedType.finisher:
        return 'Beef Finisher (600-1200 lbs)';
      case FeedType.early:
        return 'Beef - Breeding Bull';
      case FeedType.gestating:
        return 'Beef - Pregnant Cow';
      default:
        return feedType.label;
    }
  }

  static String _beefDescription(FeedType feedType) {
    switch (feedType) {
      case FeedType.preStarter:
        return 'Creep feed for calves still nursing. High-quality ingredients, high CP (15-17%) for early growth.';
      case FeedType.starter:
        return 'Post-weaning nutrition. Gastrointestinal health critical. Avoid mycotoxins, provide buffer feeds.';
      case FeedType.grower:
        return 'Frame development phase (6-12 months). Moderate energy prevents fat deposition. Optimal ADG 1.5-2.0 lbs/day.';
      case FeedType.finisher:
        return 'Final weight gain and marbling (12-18 months). Higher energy, lower protein. Target ADG 3-4 lbs/day for finishing.';
      case FeedType.early:
        return 'Breeding bull: Moderate to good body condition (BCS 7-8). Ensure adequate protein and minerals for sperm production.';
      case FeedType.gestating:
        return 'Pregnant beef cow. Variable energy (low-mod) depending on stage. Mineral balance important for calf quality.';
      default:
        return '';
    }
  }

  static String _beefGuidance(FeedType feedType) {
    switch (feedType) {
      case FeedType.preStarter:
        return '✓ Use milk replacer or highly digestible grain. Provide quality hay. Transition to standard feed by 3-4 months. Monitor calf health closely.';
      case FeedType.starter:
        return '✓ Gradual diet transition from nursing dam. Provide ionophores (monensin) for coccidiosis prevention. Allow forage. Target ADG 1.5-2.0 lbs/day.';
      case FeedType.grower:
        return '✓ Value-based pricing: pay attention to frame score. Balanced mineral (Ca:P 2:1). Avoid over/under-nutrition.';
      case FeedType.finisher:
        return '✓ High-grain diet dominance (65-85% concentrate). Quality feed, consistent ration. Enzyme efficiency/energy density critical.';
      case FeedType.early:
        return '✓ Body condition 7-8/9 scale. High-quality forage or pasture. Mineral package for reproductive function. Avoid overfeeding energy (reduces libido).';
      case FeedType.gestating:
        return '✓ Early pregnancy: minimize nutrient excess. Late pregnancy (last 3 months): increase energy 15-20% & minerals (especially Mg 0.3-0.4%, Ca 0.5-0.6%) for calf vigor.';
      default:
        return '';
    }
  }

  // ===== SHEEP LABELS & DESCRIPTIONS =====

  static String _sheepDetailedLabel(FeedType feedType) {
    switch (feedType) {
      case FeedType.preStarter:
        return 'Lamb Creep Feed (Birth-4 weeks)';
      case FeedType.starter:
        return 'Lamb Starter (Weaned, 4-8 weeks)';
      case FeedType.grower:
        return 'Growing Lamb (8-16 weeks)';
      case FeedType.finisher:
        return 'Finishing Lamb (16-24 weeks, 80-120 lbs)';
      case FeedType.early:
        return 'Growing Ewe (6-12 months)';
      case FeedType.maintenance:
        return 'Maintenance Ewe/Wether (Adult non-breeding)';
      case FeedType.gestating:
        return 'Pregnant Ewe (Late gestation, 4-6 weeks)';
      case FeedType.lactating:
        return 'Lactating Ewe (Peak, 1-8 weeks)';
      default:
        return feedType.label;
    }
  }

  static String _sheepDescription(FeedType feedType) {
    switch (feedType) {
      case FeedType.preStarter:
        return 'Creep feed offered alongside dam milk. Transition to solids. High CP (18-22%), high digestibility, palatable ingredients.';
      case FeedType.starter:
        return 'Post-weaning (7-14 lbs live weight). Critical health period. Balance CP/fiber for rumen development.';
      case FeedType.grower:
        return 'Rapid growth phase (14-55 lbs). Optimal frame development. High CP (15-16%) critical for wool & muscle growth.';
      case FeedType.finisher:
        return 'Market preparation (55-120 lbs). Optimize dressing percentage and meat quality. Higher energy than grower.';
      case FeedType.early:
        return 'Young ewe development (6-12 months). Moderate growth to target breeding weight (120-140 lbs). Prevent bloat/acidosis.';
      case FeedType.maintenance:
        return 'Adult ewe not pregnant/lactating, or wethers. Lower nutrient density. Adequate roughage essential for health.';
      case FeedType.gestating:
        return 'Last 4-6 weeks of pregnancy. CRITICAL: Prevent pregnancy toxemia (ketosis). Increase energy 15-20%. Molybdenum toxicity risk if high Mo forage.';
      case FeedType.lactating:
        return 'Nursing ewes, peak milk production. High energy & protein (15-17%). Often exceeds 1 lamb: provide separate ration if possible.';
      default:
        return '';
    }
  }

  static String _sheepGuidance(FeedType feedType) {
    switch (feedType) {
      case FeedType.preStarter:
        return '✓ Offer high-quality palatable grains (oats, barley). Limit pelleted feed (<40% diet). Prevent bloat (ionophores optional). Monitor intake.';
      case FeedType.starter:
        return '✓ Provide quality hay (alfalfa or clover mix). Introduce concentrates gradually. Watch for parasites (most critical lamb mortality risk). Vaccinate for CDT.';
      case FeedType.grower:
        return '✓ CRITICAL STAGE: Protein deficiency causes 30-40% growth slowdown. Never use maintenance-level protein. Target ADG 0.4-0.6 lbs/day. Good forage + grain essential.';
      case FeedType.finisher:
        return '✓ Market finish: grain-heavy ration acceptable. Monitor for bloat. Slaughter age typically 5-7 months. Early finishing reduces parasite risk.';
      case FeedType.early:
        return '✓ Target breeding weight 120-140 lbs by 7-8 months. High-quality forage. Expose to breeding ram 3-4 months before lambing. Monitor body condition.';
      case FeedType.maintenance:
        return '✓ Pasture-based if available (most economical). Hay-based in off-season. Supplement salt & trace minerals. Protein 9-12% adequate if no growth/production occurring.';
      case FeedType.gestating:
        return '✓ CRITICAL: Prevent pregnancy toxemia (ewes carrying multiple lambs at high risk). Last trimester: increase metabolizable energy 20%, also increase Mg (0.3-0.4%) & Zn (40 mg/kg). Use propylene glycol drench if signs appear.';
      case FeedType.lactating:
        return '✓ Provide best quality forage + grain. If nursing 2+ lambs: may need 3.5-4.0 Mcal ME/kg diet. Monitor body condition (target 3.0-3.5). Calcium 0.6-0.8% if grain-heavy ration.';
      default:
        return '';
    }
  }

  // ===== GOAT LABELS & DESCRIPTIONS =====

  static String _goatDetailedLabel(FeedType feedType) {
    switch (feedType) {
      case FeedType.preStarter:
        return 'Goat Doeling/Kid Creep (Birth-2 months)';
      case FeedType.starter:
        return 'Young Doeling/Kid Starter (2-4 months)';
      case FeedType.grower:
        return 'Growing Doeling (4-8 months)';
      case FeedType.finisher:
        return 'Replacement Doeling (8-12 months)';
      case FeedType.early:
        return 'Goat - Breeding Buck';
      case FeedType.maintenance:
        return 'Maintenance Doe/Wether (Adult non-breeding)';
      case FeedType.gestating:
        return 'Pregnant Doe (Late gestation, 4-6 weeks)';
      case FeedType.lactating:
        return 'Lactating Doe (Peak, 1-8 weeks)';
      default:
        return feedType.label;
    }
  }

  static String _goatDescription(FeedType feedType) {
    switch (feedType) {
      case FeedType.preStarter:
        return 'Creep feed for kids. Selective feeders - use small pellets or crumbles. High CP (18-22%), add probiotics for rumen establishment.';
      case FeedType.starter:
        return 'Post-weaning (6-12 lbs). Goats need higher protein than sheep (due to selective feeding behavior & higher metabolism).';
      case FeedType.grower:
        return 'Rapid growth phase (12-40 lbs). HIGH PROTEIN (14-16%) critical for goat development (goats naturally require higher CP than sheep).';
      case FeedType.finisher:
        return 'Near-adult weight (40-80 lbs). Frame development continues to 12-18 months. Optimize feed efficiency.';
      case FeedType.early:
        return 'Breeding buck: Higher plane of nutrition than beef bulls (more active metabolism). Good BCS (7-8), high mineral status for semen quality.';
      case FeedType.maintenance:
        return 'Non-breeding adult doe or wether. Goats browse-feeders - provide long fiber. Moderate energy, adequate protein.';
      case FeedType.gestating:
        return 'Pregnant doe. CRITICAL: Prevent ketosis (more susceptible than sheep, especially if twins+). High protein (13-15%) in late gestation.';
      case FeedType.lactating:
        return 'HIGHEST NUTRIENT DEMAND: Alpine/Saanen milk production ~1.5-2.0 gallons/day. High CP (16-18%), high energy, excellent minerals. Often need separate milking ration.';
      default:
        return '';
    }
  }

  static String _goatGuidance(FeedType feedType) {
    switch (feedType) {
      case FeedType.preStarter:
        return '✓ Use small pellets/crumbles (goats refuse large pellets). Provide high-quality forage. Extra minerals critical (goats = copper/molybdenum issues common). Vaccinate CDT.';
      case FeedType.starter:
        return '✓ Introduce concentrates gradually (goats = acidosis risk). Provide roughage. Limit pelleted feed to prevent digestive upset. Monitor parasite burden closely.';
      case FeedType.grower:
        return '✓ HIGHER PROTEIN than sheep equivalent: goats need 14-16% CP (vs sheep 15-16%). Target ADG 0.5-0.7 lbs/day. Ensure copper adequate (NOT excess). Molybdenum: watch forages from Mo-rich areas.';
      case FeedType.finisher:
        return '✓ Meat goat finish @ 60-90 lbs (dairy @ 100-120 lbs). Target slaughter age 90-120 days. Grain finish improves dressing percentage. Beware of over-fattening.';
      case FeedType.early:
        return '✓ Breeding buck: body condition 7-8/9. High-quality diet. Copper adequate (10-40 mg/kg depending on antagonists). Separate from does except breeding season. Avoid stress.';
      case FeedType.maintenance:
        return '✓ Pasture + hay system optimal. Goats = excellent browsers (can clear brush). Low-cost maintenance on marginal land. Protein 8-10% acceptable if quality forage. Check water quality (some areas high salinity).';
      case FeedType.gestating:
        return '✓ CRITICAL: High ketosis risk (especially twins/triplets). Late gestation: increase energy 15-25%, boost CP to 13-15%. Propylene glycol drench starting 1-2 weeks before kidding if at-risk herd.';
      case FeedType.lactating:
        return '✓ HIGHEST DEMANDS: Separate milking ration essential for high-producers (Alpine/Saanen). CP 16-18%, Energy 3.0+ Mcal ME/kg. Minerals critical: Ca:P 1.5-2:1, Mg 1.8 mg/kg, Cu 10-40. Monitor BCS (should not drop below 2.5).';
      default:
        return '';
    }
  }
}
