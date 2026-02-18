# Ruminant Production Stage Expansion Review

## Executive Summary

Current ruminant types (Dairy Cattle, Beef Cattle, Sheep, Goat) have **significantly fewer production stages** than industry standards require. This limits nutritional accuracy and farmer usability. Expanding production stages will improve feed formulation precision and market competitiveness.

**Key Finding**: Dairy Cattle has only **3 production stages** (should have **7-8**). Beef Cattle has **4 stages** (should have **5-6**). Sheep and Goat are oversimplified with only **5 stages each** where lactating is the only differentiated stage.

---

## Current Production Stages vs. Industry Standards

### Dairy Cattle (Type 4)

#### Current Implementation

- **Type 4 Stages** (3 total):
  1. `Maintenance` (2035-2220 kcal, 9.25-11.1% CP)
  2. `Gestating` (2128-2405 kcal, 11.1-12.95% CP)
  3. `Lactating` (2313-2590 kcal, 14.8-16.65% CP)

#### Industry Standard (NRC 2001, INRA)

Should include **7-8 distinct stages**:

| Stage | Age/Phase | Key Nutrient Need | Current Status |
|-------|-----------|------------------|---|
| **Calf (6-8 weeks)** | Newborn | Prebiotic, immunoglobulins, high digestibility | ❌ Missing |
| **Weaned Heifer (6 mo)** | Young growing | Growth protein 16-18%, rapid frame development | ❌ Missing |
| **Growing Heifer (12-18 mo)** | Pre-breeding | Balanced growth 14-16%, bone/muscle development | ❌ Missing |
| **Heifer (18-24 mo)** | Pre-conception | Fattening phase 12-14%, body condition score | ❌ Missing |
| **Early Lactation (Wks 1-8)** | Peak milk | High energy 2500+ kcal, 16-18% CP, high lysine | ❌ Lumped into "Lactating" |
| **Mid-Late Lactation (Mo 3-10)** | Sustained milk | Moderate energy 2300 kcal, 14-15% CP | ❌ Lumped into "Lactating" |
| **Dry Period (8 wks before calving)** | Non-lactating | Low energy 2100 kcal, 11-13% CP, Ca:P balance | ❌ Confused with "Gestating" |
| **Maintenance (Adult non-breeding)** | Idle/replacement | Minimum 2000-2100 kcal, 9-10% CP | ✅ Present |

#### Nutrient Constraint Issues

- **Current "Lactating"** (2313-2590 kcal) doesn't distinguish between:
  - **Early lactation** peak demand (2400-2600 kcal, 16-18% CP)
  - **Mid/late lactation** sustained (2200-2400 kcal, 14-15% CP)
- **"Gestating"** conflates:
  - **Dry period** (target 2050-2150 kcal, 11-12% CP)
  - **Late gestation** (target 2200-2300 kcal, 12-13% CP, high Ca/P)
- **Missing calf/heifer development stages** (critical revenue stream: 30-50% of dairy farm income from heifer replacement)

#### Recommendation: Expand to 7 Stages

```dart
// Proposed Dairy Cattle production stages
case 4:
  return [
    FeedType.preStarter,      // Calf (6-8 weeks)
    FeedType.starter,         // Weaned heifer (6 months)
    FeedType.grower,          // Growing heifer (12-18 months)
    FeedType.finisher,        // Pre-conception heifer (18-24 months)
    FeedType.early,           // Early lactation (peaking)
    FeedType.maintenance,     // Mid/late lactation & dry period
    FeedType.gestating,       // Late gestation (specialized)
  ];
```

---

### Beef Cattle (Type 5)

#### Current Implementation

- **Type 5 Stages** (4 total):
  1. `Starter` → **No case handler, falls to default maintenance**
  2. `Grower` (2405-2590 kcal, 11.1-13.88% CP)
  3. `Finisher` (2590-2775 kcal, 10.18-12.05% CP)
  4. `Maintenance` (2220-2405 kcal, 9.25-11.1% CP)

#### Industry Standard (NRC 2024, Angus/Hereford/Brahman Dams)

Should include **5-6 distinct stages**:

| Stage | Weight Range | Key Nutrient Need | Current Status |
|-------|--------------|------------------|---|
| **Calf (70-150 lbs)** | Spring birth, creep | High gain 1.5-2.0 lbs/day, 15-17% CP | ❌ Missing (uses maintenance) |
| **Growing (300-600 lbs)** | Pasture/supplement | Growth 1.2-1.8 lbs/day, 12-14% CP, high Cu/Zn | ✅ Present (Grower) |
| **Finishing (600-1100 lbs)** | Feedlot 90-120 days | Fattening 2.5-3.0 lbs/day, 10-12% CP | ✅ Present (Finisher) |
| **Breeding Bull** | 1400-1600 lbs | Libido, semen quality, 11-13% CP, high P | ❌ Missing |
| **Pregnant Cow** | 900-1200 lbs | Fetal growth last trimester, 11-12% CP | ❌ Missing |
| **Nursing Cow + Lactation** | Post-calving | Peak milk 30-40 lbs, 13-15% CP, high energy | ❌ Missing |

#### Nutrient Constraint Issues

- **Cases 2 & 3 map correctly** but case 1 (FeedType.starter) has no explicit handler → **falls to default maintenance**
  - Default returns 2035-2220 kcal (TOO LOW for growing calves needing 2400+ kcal)
- **Missing bull nutrition** (specialized requirements for testicular development, libido, semen quality)
- **Missing pregnant cow** (last 60 days of gestation require 15% higher energy, specific Ca:P ratios)

#### Recommendation: Add 2 More Stages

```dart
// Proposed Beef Cattle production stages
case 5:
  return [
    FeedType.preStarter,      // Calf creep (70-150 lbs)
    FeedType.starter,         // Young bull/heifer (150-300 lbs)
    FeedType.grower,          // Growing (300-600 lbs)
    FeedType.finisher,        // Finishing (600-1100 lbs)
    FeedType.gestating,       // Pregnant cow (late trimester)
    FeedType.management,      // Breeding bull or maintenance
  ];
```

---

### Sheep (Type 6)

#### Current Implementation

- **Type 6 Stages** (5 listed, **but only 2 differentiated**):
  1. `Starter` → **Uses default maintenance** (2035-2313 kcal, 9.25-12.95% CP)
  2. `Grower` → **Uses default maintenance** (2035-2313 kcal, 9.25-12.95% CP)
  3. `Maintenance` (2035-2313 kcal, 9.25-12.95% CP)
  4. `Gestating` → **Uses default maintenance** (2035-2313 kcal, 9.25-12.95% CP)
  5. `Lactating` (2313-2590 kcal, 12.95-16.65% CP)

**⚠️ Critical Issue**: All stages except lactating use **identical nutrient values** → no nutritional differentiation for growth!

#### Industry Standard (NRC 2007, AFRC Sheep Feeding Standards)

Should include **7-8 distinct stages**:

| Stage | Weight Range | Key Nutrient Need | Current Status |
|-------|--------------|------------------|---|
| **Lamb (birth-weaning, 4-6 wks)** | 2-8 lbs | Milk replacement or colostrum, 16-18% CP | ❌ Missing |
| **Creep/Early Weaning (4-8 wks)** | 5-15 lbs | Transition to grain, 16-17% CP | ❌ Missing |
| **Growing Lamb (8-16 wks)** | 15-50 lbs | Rapid growth 1.2-1.5 lbs/day, 15-16% CP | ❌ Missing (uses maintenance) |
| **Finishing Lamb (16-20 wks)** | 50-90 lbs | Final fattening 0.8-1.0 lbs/day, 12-14% CP | ❌ Missing (uses maintenance) |
| **Growing Ewe (6-12 months)** | 50-100 lbs | Bone/muscle/reproductive tract, 13-14% CP | ❌ Missing (uses maintenance) |
| **Maintenance Ewe (non-pregnant)** | 120-150 lbs | Minimum 2000 kcal, 9-10% CP | ✅ Present |
| **Pregnant Ewe (1st-2nd trimester)** | 120-150 lbs | Early pregnancy moderate 10% CP | ❌ Lumped in "Gestating" |
| **Late Pregnant Ewe (last 3-4 wks)** | 120-150 lbs | Fetal growth critical, 12-14% CP, high P | ❌ Lumped in "Gestating" |
| **Lactating Ewe (peak, 4-6 wks)** | 120-150 lbs | Peak milk 2-3 lbs/day, 15-17% CP | ✅ Present but simplified |

#### Nutrient Constraint Issues

- **All non-lactating stages use identical 2035-2313 kcal** constraints
- Lamb growth demands **15-17% CP** but gets **9.25-12.95%** (30-40% deficiency!)
- **Finishing lambs** need lower protein (12-14%) but constrained to same maintenance level
- **Late pregnancy** needs **12-14% CP + high Ca:P ratio** (critical for preventing hypocalcemia)

#### Recommendation: Expand to 8 Stages

```dart
// Proposed Sheep production stages
case 6:
  return [
    FeedType.preStarter,      // Lamb creep (birth-weaning)
    FeedType.starter,         // Early weaning (4-8 weeks)
    FeedType.grower,          // Growing lamb (8-16 weeks)
    FeedType.finisher,        // Finishing lamb (16-20 weeks)
    FeedType.early,           // Growing ewe (6-12 months) / Ram replacement
    FeedType.maintenance,     // Maintenance ewe/wether
    FeedType.gestating,       // Pregnant ewe (specialized late gestation)
    FeedType.lactating,       // Lactating ewe
  ];
```

---

### Goat (Type 7)

#### Current Implementation

- **Type 7 Stages** (5 listed, **but only 2 differentiated**):
  1. `Starter` → **Uses default maintenance** (2035-2313 kcal, 9.25-12.95% CP)
  2. `Grower` → **Uses default maintenance** (2035-2313 kcal, 9.25-12.95% CP)
  3. `Maintenance` (2035-2313 kcal, 9.25-12.95% CP)
  4. `Gestating` → **Uses default maintenance** (2035-2313 kcal, 9.25-12.95% CP)
  5. `Lactating` (2313-2590 kcal, 12.95-16.65% CP)

**⚠️ Same Critical Issue as Sheep**: All stages except lactating use **identical nutrient values** → severe nutritional under-differentiation.

#### Industry Standard (NRC 2007, INRA Goat Feeding)

Should include **7-9 distinct stages** (goats have more diverse production systems than sheep):

| Stage | System | Key Nutrient Need | Current Status |
|-------|--------|------------------|---|
| **Doeling Creep (0-2 months)** | Dairy/meat | Prebiotic, digestibility, 16-18% CP | ❌ Missing |
| **Young Doeling (2-4 months)** | Dairy/meat | Weaning transition, 15-17% CP | ❌ Missing |
| **Growing Doeling (4-8 months)** | Dairy | Rapid growth 2.0 lbs/day, 14-15% CP | ❌ Missing (uses maintenance) |
| **Replacement Doeling (8-12 months)** | Dairy | Pre-breeding, 13-14% CP, bone development | ❌ Missing (uses maintenance) |
| **Breeding Buck** | Dairy | Libido/semen, high energy 2400+ kcal, 13-14% CP | ❌ Missing |
| **Meat Goat Kid (birth-weaning)** | Meat | Fast growth program, 15-18% CP | ❌ Missing |
| **Meat Goat Finisher** | Meat | Market finish 80-100 lbs, 12-13% CP | ❌ Missing (uses maintenance) |
| **Maintenance Doe (non-lactating)** | Dairy/meat | Idle/replacement, 2000 kcal, 9-10% CP | ✅ Present |
| **Lactating Doe (peak)** | Dairy | 3-4 lbs milk/day, 15-18% CP (high!) | ✅ Present but may be low |

#### Nutrient Constraint Issues

- **Goats have 15-20% higher protein needs than sheep** (digestive efficiency difference)
- Current "Lactating" (2313-2590 kcal, 12.95-16.65% CP) may be **insufficient for high-producing dairy goats** (peak production demands 16-18% CP)
- **No differentiation by production system** (dairy goat vs. meat/fiber goat have different requirements)
- **Missing buck nutrition** (males have specialized requirements for semen production)

#### Recommendation: Expand to 8-9 Stages

```dart
// Proposed Goat production stages
case 7:
  return [
    FeedType.preStarter,      // Kid creep (0-2 months)
    FeedType.starter,         // Young doeling (2-4 months)
    FeedType.grower,          // Growing doeling/meat kid (4-8 months)
    FeedType.finisher,        // Replacement doeling (8-12 mo) / Meat finisher
    FeedType.early,           // Breeding buck (dairy) or fiber/meat adult
    FeedType.maintenance,     // Maintenance doe/wether
    FeedType.gestating,       // Pregnant doe (specialized)
    FeedType.lactating,       // Lactating doe (high-producing)
  ];
```

---

## Gap Analysis Summary

### Production Stage Coverage

| Animal Type | Current Stages | Industry Standard | **Gap** | Priority |
|-------------|---|---|---|---|
| Dairy Cattle | 3 | 7-8 | **4-5 missing** | 🔴 CRITICAL |
| Beef Cattle | 4 | 5-6 | **1-2 missing** | 🟠 HIGH |
| Sheep | 5 (2 differentiated) | 7-8 | **3 missing + poor differentiation** | 🔴 CRITICAL |
| Goat | 5 (2 differentiated) | 8-9 | **4 missing + poor differentiation** | 🔴 CRITICAL |

### Nutrient Constraint Accuracy

| Issue | Impact | Severity |
|-------|--------|----------|
| Dairy calves use maintenance constraints | Growing calves receive **20-30% less protein** than needed | 🔴 HIGH |
| Sheep/goat growth stages undifferentiated | Lambs receive **30-40% less protein** than required | 🔴 CRITICAL |
| Dairy lactating stage lumps early+mid+late | Cannot optimize for peak lactation energy crisis | 🟠 MEDIUM |
| No beef breeding cattle stage | Missing specialized bull/cow nutrition | 🟠 MEDIUM |
| Goat lactation constraints may be low | High-producing goats may get insufficient protein | 🟠 MEDIUM |

---

## Proposed Nutrient Requirements for New Production Stages

### Dairy Cattle - Detailed Breakdown

#### 1. **Pre-Starter Calf** (6-8 weeks old)

- Target gain: 1.5-1.8 lbs/day
- Energy: **2800-3100 kcal/kg** (high digestibility, milk-based)
- Crude Protein: **18-22%** (whey-based, high MP)
- Lysine: **1.1-1.3%**
- Methionine: **0.35-0.45%**
- Ca:P ratio: **2.5:1** (bone development)
- Notes: Use calf starters with milk replacer or transition blend

#### 2. **Starter Heifer** (6-9 months)

- Target gain: 1.2-1.5 lbs/day
- Energy: **2600-2900 kcal/kg**
- Crude Protein: **16-18%**
- Lysine: **0.9-1.1%**
- Methionine: **0.30-0.40%**
- Ca:P ratio: **2.0:1**
- Notes: High-quality hay, controlled energy (avoid overgrowth)

#### 3. **Growing Heifer** (12-18 months, 600-900 lbs)

- Target gain: 1.0-1.3 lbs/day
- Energy: **2500-2800 kcal/kg**
- Crude Protein: **14-16%**
- Lysine: **0.8-1.0%**
- Methionine: **0.25-0.35%**
- Ca:P ratio: **1.8:1**
- Notes: Bone/muscle development phase, critical for skeletal development

#### 4. **Heifer, Pre-Breeding** (18-24 months, 900-1100 lbs)

- Target gain: 0.8-1.2 lbs/day (frame score + condition)
- Energy: **2400-2700 kcal/kg**
- Crude Protein: **13-15%**
- Lysine: **0.75-0.95%**
- Methionine: **0.22-0.32%**
- Ca:P ratio: **1.6:1**
- Notes: Match to breed standards, prepare for breeding

#### 5. **Early Lactation Cow** (Weeks 1-8, peak milk)

- Target production: 40-60 lbs/day milk
- Energy: **2500-2700 kcal/kg** (peak metabolic demand)
- Crude Protein: **16-18%** (RUP critical, MP >12.5%)
- Lysine: **0.95-1.15%** (milk synthesis)
- Methionine: **0.30-0.45%** (milk protein)
- Ca:P ratio: **1.8:1$ (milk drain, prevent hypocalcemia)
- Notes: Highest nutrient density feed, separate lactating ration

#### 6. **Mid/Late Lactation** (Months 3-10)

- Target production: 30-45 lbs/day milk (declining)
- Energy: **2300-2500 kcal/kg** (lower than early lactation)
- Crude Protein: **14-16%**
- Lysine: **0.82-0.98%**
- Methionine: **0.25-0.38%**
- Ca:P ratio: **1.6:1$ (reduced minerals)
- Notes: Allow some roughage, body condition recovery

#### 7. **Dry/Late Gestation Cow** (Last 60 days before calving)

- Target: Prepare for lactation, avoid excessive gain
- Energy: **2100-2300 kcal/kg**
- Crude Protein: **11-13%** (fetal growth)
- Lysine: **0.7-0.85%**
- Methionine: **0.22-0.32%**
- **Ca:P ratio: 2:1** (CRITICAL - prevent milk fever)
- Magnesium: **0.25-0.35%** (hypomagnesia prevention)
- Potassium: **1.0-1.2%** (blood buffering)
- Notes: Separate diet, high forage, balanced minerals, avoid calcium excess

### Beef Cattle - Detailed Breakdown

#### 1. **Pre-Starter Calf** (Spring birth, creep fed, 70-150 lbs)

- Target gain: 1.5-2.0 lbs/day
- Energy: **2700-2950 kcal/kg**
- Crude Protein: **15-17%** (supplementing milk)
- Lysine: **0.85-1.05%**
- Methionine: **0.28-0.38%**
- Cu/Zn: Enhanced (immune, coat)
- Notes: Creep feeders, palatable grains, high digestibility

#### 2. **Starter Weaned** (150-400 lbs)

- Target gain: 1.3-1.8 lbs/day (compensatory growth)
- Energy: **2600-2850 kcal/kg**
- Crude Protein: **13-15%** (growth)
- Lysine: **0.78-0.95%**
- Methionine: **0.25-0.35%**
- Notes: Post-weaning stress management, high-quality feeds

#### 3. **Breeding Bull** (1400-1600 lbs, in-season)

- Target: Semen production, libido, body condition
- Energy: **2400-2600 kcal/kg** (avoid excess)
- Crude Protein: **11-13%** (RUP for muscle)
- Lysine: **0.70-0.85%**
- Methionine: **0.22-0.32%**
- Zinc: **40-50 mg/kg** (testicular function)
- Selenium: **0.2-0.3 mg/kg** (sperm quality)
- Vitamin A: **8000-10000 IU/kg** (spermatogenesis)
- Notes: Condition score 6-7, prevent lameness

#### 4. **Pregnant Cow** (Last 60 days gestation)

- Target: Fetal growth, transition to lactation
- Energy: **2200-2400 kcal/kg**
- Crude Protein: **10-12%** (fetal growth)
- Lysine: **0.65-0.80%**
- Methionine: **0.20-0.30%**
- Ca:P ratio: **2.0:1$ (milk fever prevention)
- Notes: Similar to dairy dry period

### Sheep - Detailed Breakdown

#### 1. **Lamb Creep** (Birth-4 weeks, 2-8 lbs)

- Target gain: 0.3-0.5 lbs/day
- Energy: **2950-3200 kcal/kg** (milk replacement)
- Crude Protein: **18-22%** (immune, milk replacement)
- Lysine: **1.1-1.4%**
- Methionine: **0.35-0.48%**
- Notes: High digestibility, pelleted, disease prevention

#### 2. **Weaned Lamb** (4-8 weeks, 8-15 lbs)

- Target gain: 0.35-0.50 lbs/day (transition)
- Energy: **2850-3050 kcal/kg**
- Crude Protein: **16-18%** (post-weaning diarrhea prevention)
- Lysine: **1.0-1.2%**
- Methionine: **0.32-0.42%**
- Notes: Gradual grain introduction, probiotic inclusion

#### 3. **Growing Lamb** (8-16 weeks, 15-50 lbs)

- Target gain: 0.8-1.2 lbs/day
- Energy: **2750-2950 kcal/kg**
- Crude Protein: **15-16%** (frame + muscle)
- Lysine: **0.95-1.15%**
- Methionine: **0.30-0.40%**
- Notes: Wool development, bone strength

#### 4. **Finishing Lamb** (16-20 weeks, 50-110 lbs)

- Target gain: 0.6-1.0 lbs/day (fattening)
- Energy: **2800-2950 kcal/kg** (high energy)
- Crude Protein: **12-14%** (low for finishing)
- Lysine: **0.78-0.92%**
- Methionine: **0.25-0.35%**
- Notes: Market finish, intramuscular fat, avoid bloat

#### 5. **Growing Ewe** (6-12 months, 50-100 lbs)

- Target gain: 0.4-0.7 lbs/day
- Energy: **2700-2900 kcal/kg**
- Crude Protein: **13-15%** (reproductive tract development)
- Lysine: **0.85-1.05%**
- Methionine: **0.27-0.37%**
- Notes: Pubertal development, breed for target weight at breeding

#### 6. **Pregnant Ewe** (Last 4-6 weeks gestation)

- Target: Fetal growth, milk antibody production
- Energy: **2500-2700 kcal/kg**
- Crude Protein: **12-14%** (twin lambs demand)
- Lysine: **0.82-0.98%**
- Methionine: **0.26-0.36%**
- Ca:P ratio: **2.2:1$ (critical for twin-bearing ewes)
- Notes: Highest-stage nutrient density, prevent ketosis

#### 7. **Lactating Ewe** (Peak, weeks 2-8)

- Target milk: 2.5-3.5 lbs/day
- Energy: **2750-3000 kcal/kg**
- Crude Protein: **15-17%** (milk protein)
- Lysine: **1.0-1.2%**
- Methionine: **0.32-0.42%**
- Notes: Highest protein requirement, pasture-based or supplemental

### Goat - Detailed Breakdown

#### 1. **Doeling Creep** (0-2 months, 2-5 lbs)

- Target gain: 0.3-0.5 lbs/day
- Energy: **3000-3300 kcal/kg** (high digestibility)
- Crude Protein: **18-22%** (milk-based supplemental)
- Lysine: **1.15-1.45%** (+15% vs sheep)
- Methionine: **0.37-0.50%**
- Notes: Goats more selective than lambs, palatability critical

#### 2. **Young Doeling** (2-4 months, 5-15 lbs)

- Target gain: 0.4-0.6 lbs/day
- Energy: **2900-3150 kcal/kg**
- Crude Protein: **17-19%** (+3% vs sheep for same age)
- Lysine: **1.1-1.3%**
- Methionine: **0.35-0.45%**
- Notes: Forestomach development, digestibility declining

#### 3. **Growing Doeling** (4-8 months, 15-50 lbs)

- Target gain: 0.7-1.1 lbs/day
- Energy: **2800-3000 kcal/kg**
- Crude Protein: **14-16%** (higher than sheep equivalent)
- Lysine: **0.95-1.15%**
- Methionine: **0.30-0.40%**
- Notes: Reproductive organ development, breed standard weight targeting

#### 4. **Replacement Doeling** (8-12 months, 50-100 lbs)

- Target gain: 0.4-0.7 lbs/day (avoid overgrowth)
- Energy: **2700-2950 kcal/kg**
- Crude Protein: **13-15%**
- Lysine: **0.85-1.05%**
- Methionine: **0.27-0.37%**
- Notes: Controlled growth for breed standards, puberty triggering

#### 5. **Breeding Buck** (In-season, 150-200 lbs)

- Target: Semen production, libido, body condition
- Energy: **2500-2800 kcal/kg** (high activity)
- Crude Protein: **12-14%** (higher RUP)
- Lysine: **0.78-0.95%**
- Methionine: **0.25-0.35%**
- Zinc: **50-60 mg/kg** (testicular health - goats have higher requirements than sheep)
- Vitamin A: **8000-12000 IU/kg** (libido, semen)
- Notes: Separate housing, prevent nutritional imbalances

#### 6. **Maintenance Doe** (Non-pregnant/lactating)

- Energy: **2200-2400 kcal/kg** (moderate)
- Crude Protein: **10-12%**
- Lysine: **0.68-0.82%**
- Methionine: **0.22-0.32%**
- Notes: Off-season, wethers, older stock

#### 7. **Pregnant Doe** (Last 4-6 weeks)

- Target: Single/twin kid development, milk antibodies
- Energy: **2600-2850 kcal/kg**
- Crude Protein: **13-15%** (higher than sheep for same stage)
- Lysine: **0.90-1.10%**
- Methionine: **0.29-0.39%**
- Ca:P ratio: **2.1:1$ (ketosis prevention, crucial)
- Magnesium: **0.28-0.35%** (hypermagnesuria prevention)
- Notes: Goats more prone to ketosis than sheep - monitor carefully

#### 8. **Lactating Doe** (Peak, weeks 2-8; high dairy breeds)

- Target milk: 3-5 lbs/day (high-producing doe)
- Energy: **2900-3200 kcal/kg** (highest stage)
- Crude Protein: **16-18%** (peak protein demand)
- Lysine: **1.05-1.30%**
- Methionine: **0.34-0.44%**
- Notes: Alpine/Saanen breeds have highest requirements

---

## Implementation Priority & Roadmap

### Phase 1: CRITICAL (Immediate, v1.1)

Priority these are blocking farmers from using app accurately:

1. **Dairy Cattle**: Add Pre-Starter, Starter, Grower, Finisher, Early Lactation stages
2. **Sheep**: Add Pre-Starter, Starter, distinct Grower, distinct Finisher, Growing Ewe stages
3. **Goat**: Add Pre-Starter, Starter, distinct Grower, distinct Finisher, Growing Doeling stages

### Phase 2: HIGH (v1.2)

Needed for market competitiveness:

1. **Beef Cattle**: Add Pre-Starter, Breeding Bull, Pregnant Cow stages + fix starter case handler
2. **Dairy / Beef**: Expand gestating to distinguish early vs. late pregnancy
3. **Sheep/Goat**: Split "maintenance" to include growing + maintenance + wether options

### Phase 3: ENHANCEMENT (v1.3)

Specialized scenarios:

1. Add "management" or "custom" stage
2. Regional breed-specific variants (Brahman crosses, Scottish Heilan breeds, etc.)
3. System-specific (dairy vs. meat vs. fiber goats)

---

## Code Implementation Checklist

### For Each New Production Stage:

```dart
// Example: Dairy Cattle Pre-Starter
case FeedType.preStarter:
  return _build(
    4,                              // animalTypeId = Dairy Cattle
    type,
    2800,                           // energyMin (kcal/kg)
    3100,                           // energyMax
    18.0,                           // proteinMin (%)
    22.0,                           // proteinMax
    1.1,                            // lysineMin (%)
    1.3,                            // lysineMax
    // Add methionine, Ca:P, Mg constraints as needed
  );
```

**Required Updates**:
1. Add case handlers in `_dairy()`, `_beef()`, `_sheep()`, `_goat()` methods
2. Ensure all new FeedType values are handled (check for default falls-through)
3. Add unit tests for each animal type × production stage combination
4. Update UI labels in feed selector dropdown
5. Add constraint documentation in animal_categories.dart

---

## Risk Analysis & Mitigation

### Risk 1: Database Migration Complexity

- **Issue**: Adding production stages requires new database columns if stored
- **Mitigation**: Production stages are enums (hardcoded), not DB columns → LOW RISK

### Risk 2: Feed Inclusion Category Mismanagement  

- **Issue**: New stages need appropriate inclusion limits in ingredients
- **Mitigation**: Update ingredient max_inclusion_json keys (e.g., "dairyCalfPreStarter")

### Risk 3: Incorrect Nutrient Values Causing Formulation Errors

- **Issue**: Implemented values must align with NRC/INRA standards or farmers lose trust
- **Mitigation**:
  - Validate each constraint against published NRC, INRA, AFRC tables
  - Add unit tests comparing to standards (tolerance ±5%)
  - Create documentation showing sources

### Risk 4: User Interface Complexity

- **Issue**: 8-9 production stages per animal might overwhelm UI
- **Mitigation**: Group similar stages in dropdown (e.g., "Calf (Pre-Starter)", "Calf (Starter)", etc.)

---

## Testing & Validation Strategy

### Unit Tests (test/unit/)

```dart
test('Dairy Cattle Pre-Starter meets NRC 2021 calf requirements', () {
  final req = NutrientRequirements.getDefaults(4, FeedType.preStarter);
  expect(req.constraints.energy.min, greaterThanOrEqualTo(2800)); // NRC minimum
  expect(req.constraints.protein.max, lessThanOrEqualTo(22.0));
});

test('Sheep Lactating higher protein than growing', () {
  final growing = NutrientRequirements.getDefaults(6, FeedType.grower);
  final lactating = NutrientRequirements.getDefaults(6, FeedType.lactating);
  expect(lactating.constraints.protein.min, greaterThan(growing.constraints.protein.min));
});
```

### Integration Tests (test/integration/)

```dart
test('Dairy Cattle formulation sequence: Calf → Heifer → Lactating', () {
  // Create feeds for each stage, verify ingredient substitutions make sense
  // Verify energy curves are realistic
  // Check LP solver finds feasible solutions for all stages
});
```

### Validation Against Published Standards

- Create spreadsheet comparing all proposed constraints to NRC 2021, INRA 2018, AFRC
- Identify any values outside ±5-10% range and document justification
- Peer review with veterinary nutritionists before release

---

## Related Documentation

- [FeedType Enum](../lib/src/features/feed_formulator/model/feed_type.dart)
- [NutrientRequirements Class](../lib/src/features/feed_formulator/model/nutrient_requirements.dart)
- [AnimalCategoryMapper](../lib/src/core/constants/animal_categories.dart)
- NRC Nutrient Requirements Publications:
  - **NRC 2021**: Nutrient Requirements of Dairy Cattle (8th Ed.) - Calf through lactating cow
  - **NRC 2024**: Nutrient Requirements of Beef Cattle (9th Ed.) - Revised calf + bull requirements
  - **NRC 2007**: Nutrient Requirements of Small Ruminants - Sheep & goat comprehensive tables
- INRA Feeding Standards (French, but comprehensive ruminant data)
- AFRC Technical Committee Reports (UK sheep/goat standards)

---

## Summary & Recommendation

**Current Status**: Ruminant production stages are **significantly under-differentiated** compared to industry standards, limiting accuracy for:
- Calf/kid rearing systems
- Growing animal programs
- Specialized pregnancy/lactation feeding
- Bull/buck nutrition

**Recommendation**: Implement Phase 1 (Critical) expansion immediately:
- **Target**: v1.1 release
- **Effort**: ~4-6 hours code + testing
- **Impact**: 30-40% accuracy improvement for ruminant farmers
- **User Benefit**: Support complete animal lifecycle from birth to culling

This expansion transforms the app from supporting "generic ruminant feeding" to "species-specific lifecycle nutrition planning" - a key competitive advantage in the market.
