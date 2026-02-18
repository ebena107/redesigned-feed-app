/// Detailed descriptions for aquaculture production stages
/// Provides UI-friendly labels, species-specific guidance, and hatchery/grow-out context
///
/// Use these for dropdown labels, tooltips, and farmer educational content in feed formulation UI.
library;

import 'feed_type.dart';

/// Maps aquaculture production stages to detailed descriptions, UI labels, and guidance
/// Supports tilapia (8 stages) and catfish (7 stages)
class FishFeedTypeDescriptions {
  /// Get human-readable label for a fish feed type with context
  /// e.g. "Tilapia Hatchery Micro (0-2g)" instead of just "Micro"
  static String getDetailedLabel(FeedType feedType, {int? animalTypeId}) {
    if (animalTypeId == null) {
      return feedType.label;
    }

    switch (animalTypeId) {
      case 8: // Tilapia
        return _tilapiaDetailedLabel(feedType);
      case 9: // Catfish
        return _catfishDetailedLabel(feedType);
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
      case 8:
        return _tilapiaDescription(feedType);
      case 9:
        return _catfishDescription(feedType);
      default:
        return '';
    }
  }

  /// Get management guidance for aquaculture farmers
  static String getGuidance(FeedType feedType, {int? animalTypeId}) {
    if (animalTypeId == null) {
      return '';
    }

    switch (animalTypeId) {
      case 8:
        return _tilapiaGuidance(feedType);
      case 9:
        return _catfishGuidance(feedType);
      default:
        return '';
    }
  }

  // ===== TILAPIA LABELS & DESCRIPTIONS =====

  static String _tilapiaDetailedLabel(FeedType feedType) {
    switch (feedType) {
      case FeedType.micro:
        return 'Tilapia Hatchery Micro (0-2g, <0.1g)';
      case FeedType.fry:
        return 'Tilapia Hatchery Fry (2-5g)';
      case FeedType.preStarter:
        return 'Tilapia Nursery Pre-Starter (5-10g)';
      case FeedType.starter:
        return 'Tilapia Early Growth Starter (10-50g)';
      case FeedType.grower:
        return 'Tilapia Grower (50-100g)';
      case FeedType.finisher:
        return 'Tilapia Finisher (100-200g)';
      case FeedType.breeder:
        return 'Tilapia Broodstock/Breeder (200g+)';
      case FeedType.maintenance:
        return 'Tilapia Maintenance (Non-breeding ponds)';
      default:
        return feedType.label;
    }
  }

  static String _tilapiaDescription(FeedType feedType) {
    switch (feedType) {
      case FeedType.micro:
        return 'CRITICAL HATCHERY STAGE: Extremely small pellets (40 µm). High CP (45-50%), high digestibility. Premium vitamin/mineral blend for immune development. Live feed transition critical.';
      case FeedType.fry:
        return 'Transition from live feed (2-5g). Fine particles (100-150 µm). High CP (42-48%) to maintain growth momentum. Probiotics improve survival.';
      case FeedType.preStarter:
        return 'Nursery phase (5-10g). Mid-size particles (150-250 µm). Balanced growth feed - high quality proteins for rapid development.';
      case FeedType.starter:
        return 'Early grow-out (10-50g). Standard pellets (2-3mm). Good digestibility, balanced amino acids. Foundation for later growth.';
      case FeedType.grower:
        return 'Rapid growth phase (50-100g). Standard to larger pellets (3-4mm acceptable). Moderate-high protein (27-32%), energy focus shifts to growth.';
      case FeedType.finisher:
        return 'Market preparation (100-200g). Standard pellets (4-5mm). Optimized feed conversion, acceptable protein lower than grower (23-27%).';
      case FeedType.breeder:
        return 'Broodstock nutrition (200g+). Supports gonad development and fry quality. Higher lipid (8-10%), carotenoids for pigmentation, enhanced minerals for egg quality.';
      case FeedType.maintenance:
        return 'Non-breeding adult ponds or underutilized broodstock. Lower nutrient density for cost control (22-26% CP). Adequate to maintain body weight without growth.';
      default:
        return '';
    }
  }

  static String _tilapiaGuidance(FeedType feedType) {
    switch (feedType) {
      case FeedType.micro:
        return '✓ CRITICAL STAGE - 40-50% hatchery mortality risk if improper feed: Ensure 40 µm particles (sieve test). Feed 5-8 times daily in micro amounts. Combine with live feed (rotifer/nauplii). Monitor water quality hourly (0.1-0.2g/L feeding). No uneaten feed should settle.';
      case FeedType.fry:
        return '✓ Transition to formulated feeds: 100-150 µm particles. Feed 4-6 times daily. Mix live feed 50:50 with pellets first 5 days, then increase pellet percentage. Gradual transition reduces mortality (target <10%). Excellent water quality essential (daily siphoning).';
      case FeedType.preStarter:
        return '✓ Nursery management: Use fine mesh (1-2mm) to separate similar sizes. Feed 3-4 times daily. Monitor for disease (fungal infections common in nurseries). Good aeration critical. Cannibalism begins - size grading at 7-10g helps.';
      case FeedType.starter:
        return '✓ Early grow-out (10-50g): Feed 2-3 times daily at satiation (stomach ~10-15% of body weight). Stock density: 100-200 fish/m³ max. Monitor water quality (ammonia, nitrite). Each fish consumes ~2-3% body weight/day.';
      case FeedType.grower:
        return '✓ Rapid growth phase: Feed 1-2 times daily (larger fish consolidate meals). Stock density: 150-300 fish/m³. Monitor oxygen (>4 mg/L). If water quality poor, reduce stocking or increase aeration. FCR target: 1.5-2.0 (highly efficient).';
      case FeedType.finisher:
        return '✓ Market finish (100-200g): Feed 1 time daily at satiation. Higher feed conversion efficiency now. Monitor for harvest readiness (target market 200-300g typical). If extended, switch to breeder feed to improve lip quality.';
      case FeedType.breeder:
        return '✓ BROODSTOCK MANAGEMENT: Feed premium feed daily (separate from grow-out ponds). Condition score 6-7/9 optimal. Sex ratio 1 male: 3-4 females typical. Spawning triggered by temperature 26-28°C. Tank-induced all-male populations: supplement 17α-methyltestosterone (1.5-2.0 mg/kg feed, feed for 30-60 days post-hatching).';
      case FeedType.maintenance:
        return '✓ Cost-effective feeding: Feed 1 time, 3-4 times/week (if not breeding). Target FCR 2.5-3.0 acceptable. Integrate with forage/vegetation (water hyacinth, duckweed reduce feed needs 15-30%). Maintain minimum oxygen > 3 mg/L. Regular harvesting reduces crowding.';
      default:
        return '';
    }
  }

  // ===== CATFISH LABELS & DESCRIPTIONS =====

  static String _catfishDetailedLabel(FeedType feedType) {
    switch (feedType) {
      case FeedType.micro:
        return 'Catfish Hatchery Micro Fry (5-7 days post-hatch)';
      case FeedType.fry:
        return 'Catfish Hatchery Fry (0.5-2g)';
      case FeedType.preStarter:
        return 'Catfish Nursery Pre-Starter (2-10g)';
      case FeedType.starter:
        return 'Catfish Early Growth Starter (10-50g)';
      case FeedType.grower:
        return 'Catfish Grower (50-100g)';
      case FeedType.finisher:
        return 'Catfish Finisher (100-300g)';
      case FeedType.breeder:
        return 'Catfish Broodstock/Breeder (300g+)';
      default:
        return feedType.label;
    }
  }

  static String _catfishDescription(FeedType feedType) {
    switch (feedType) {
      case FeedType.micro:
        return 'CRITICAL HATCHERY - HIGHEST PROTEIN TIER: Micro fry (5-7 days old, 50-100 mg). Ultra-fine 20-40 µm particles. EXTREME protein demand: 50-55% CP (highest of all aquaculture). Must use specialized micro feeds or live food (nauplii) + infusoria blend.';
      case FeedType.fry:
        return 'ULTRA-HIGH PROTEIN transition (0.5-2g). Fine particles (100-200 µm), still highest protein phase: 48-52% CP. Catfish fry grow 2-3x faster than tilapia with proper high-protein feed. Bottom-feeders - pellets must sink.';
      case FeedType.preStarter:
        return 'Nursery phase (2-10g). Transition to standard hatchery pellets (200-400 µm). High protein (42-48%) maintained. Bottom-feeder behavior developing - sinking pellets essential.';
      case FeedType.starter:
        return 'Early grow-out (10-50g). Standard pellets (3-5mm). High protein (37-46%) supports rapid body growth. Strong appetite - feed to satiation 2-3 times daily.';
      case FeedType.grower:
        return 'Rapid growth phase (50-100g). Standard pellets (5-8mm). Moderate protein (29-39%) as catfish convert to larger pellets. Strong bottom-feeders - ensure pellet reaches bottom.';
      case FeedType.finisher:
        return 'Market preparation (100-300g). Large pellets (8-12mm). Optimize feed efficiency - lower protein (25-34%) acceptable as energy needs increase. Aggressive feeders consume rapidly.';
      case FeedType.breeder:
        return 'Broodstock nutrition (300g+). Supports gonad development. Enhanced lipid (10-12%), vitamins A & E boost fertility. Minerals: calcium, phosphorus, zinc critical for egg/sperm quality.';
      default:
        return '';
    }
  }

  static String _catfishGuidance(FeedType feedType) {
    switch (feedType) {
      case FeedType.micro:
        return '✓ CRITICAL SURVIVAL STAGE - Hatchery mortality 30-50% if improper feed: Ultra-small 20-40 µm particles MANDATORY (standard hatchery sieves fail). Feed 6-10 times daily in micro amounts (0.05-0.1g per 1000 fry). MUST combine with live feeds (copepod nauplii, infusoria culture) - formulated feed alone insufficient. Monitor: pH 6.5-7.5, dissolved O₂ >5 mg/L, daily complete water changes. No waste tolerance - siphon uneaten immediately.';
      case FeedType.fry:
        return '✓ EXTREME PROTEIN DEMANDS (48-52% CP): Catfish fry grow 0.6→1.5-2.0 g/day with proper high-protein diet (vs tilapia 0.3→0.8 g/day). Feed 4-6 times daily at satiation. Sinking pellets essential (bottom-feeders). Transition from live feed: Start 50% live: 50% pellets, increase pellets weekly. Good water quality critical - daily partial changes (30%) in early phase.';
      case FeedType.preStarter:
        return '✓ Nursery management (2-10g): Feed 3-4 times daily. Sinking hatchery pellets 200-400 µm. Begin grading by size at 5g (reduces cannibalism). Stock density 300-500 fish/m³ acceptable in nurseries. Disease prevention: good aeration, maintain water temp 26-28°C, UV sterilization if available (catfish susceptible to ichthyophthirius & fungus).';
      case FeedType.starter:
        return '✓ Early grow-out (10-50g): Feed 2-3 times daily at satiation. Catfish appetite increases rapidly - monitor consumption (2.5-3.5% body weight/day typical). Stock density: 100-200 fish/m³ max. Pond pH 6.8-8.0 optimal. Catfish tolerate lower oxygen than tilapia (>2 mg/L minimum) but growth suffers - target >3 mg/L.';
      case FeedType.grower:
        return '✓ Rapid growth phase (50-100g): Feed 1-2 times daily at satiation (larger pellets mean fewer meals needed). FCR target: 1.8-2.2 (catfish efficient). Monitor for disease (parasites common in grow-out). Harvest body samples monthly (check lipid content, deformities). Stock density: 150-300 fish/m³.';
      case FeedType.finisher:
        return '✓ Market finish (100-300g): Feed once daily or grower cycle (grow slowly if extended beyond 300g). Aggressive feeders consume quickly - monitor leftovers. Water quality becomes easier - catfish hardy (handles lower oxygen/higher ammonia than tilapia). FCR increases to 2.2-2.5 (normal for larger fish). Harvest window: 300g prime market size (higher prices), can extend to 500g+ if market allows.';
      case FeedType.breeder:
        return '✓ BROODSTOCK MANAGEMENT: Feed premium pelleted feed daily (separate nutrition critical for egg/sperm quality). Target body condition 6-7/9. Spawning triggered by: (1) Temperature drop 2-3°C, (2) Seasonal photoperiod changes, (3) Hunger stimulus (fast 1-2 weeks pre-breeding). Typical spawn: 2000-3000 eggs per female. Hormonal induction (HCG/chorionic gonadotropin) if natural spawning fails. Cannibalism high in hatcheries - use separate hatchery containers within spawning tank.';
      default:
        return '';
    }
  }
}
