# Phase 4.6 Ingredient Expansion – Template & Samples

This doc provides:
- A JSON and CSV template aligned to the v5 `Ingredient` model fields
- 10 sample ingredients (fully populated) to serve as patterns
- A curated list of missing candidates by region (India/Asia/Africa/Europe/Americas)

## JSON Template (per ingredient)

```json
{
  "ingredient_id": null,                  // optional when inserting
  "name": "<ingredient name>",
  "crude_protein": null,                  // % DM
  "crude_fiber": null,                    // % DM
  "crude_fat": null,                      // % DM
  "calcium": null,                        // g/kg
  "phosphorus": null,                     // g/kg (legacy fallback)
  "lysine": null,                         // g/kg (legacy fallback)
  "methionine": null,                     // g/kg (legacy fallback)
  "me_growing_pig": null,                 // kcal/kg (legacy)
  "me_adult_pig": null,                   // kcal/kg (legacy)
  "me_poultry": null,                     // kcal/kg (legacy)
  "me_ruminant": null,                    // kcal/kg (legacy)
  "me_rabbit": null,                      // kcal/kg (legacy)
  "de_salmonids": null,                   // kcal/kg (legacy)
  "price_kg": null,
  "available_qty": null,
  "category_id": null,
  "favourite": 0,
  // v5 enhanced fields
  "ash": null,                            // % DM
  "moisture": null,                       // %
  "starch": null,                         // % DM
  "bulk_density": null,                   // kg/m3
  "total_phosphorus": null,               // g/kg
  "available_phosphorus": null,           // g/kg
  "phytate_phosphorus": null,             // g/kg
  "me_finishing_pig": null,               // kcal/kg
  "amino_acids_total": {                  // g/kg
    "lysine": null,
    "methionine": null,
    "cystine": null,
    "threonine": null,
    "tryptophan": null,
    "phenylalanine": null,
    "tyrosine": null,
    "leucine": null,
    "isoleucine": null,
    "valine": null
  },
  "amino_acids_sid": {                    // g/kg, SID values if available
    "lysine": null,
    "methionine": null,
    "cystine": null,
    "threonine": null,
    "tryptophan": null,
    "phenylalanine": null,
    "tyrosine": null,
    "leucine": null,
    "isoleucine": null,
    "valine": null
  },
  "energy": {                             // kcal/kg
    "mePig": null,
    "dePig": null,
    "nePig": null,
    "mePoultry": null,
    "meRuminant": null,
    "meRabbit": null,
    "deSalmonids": null
  },
  "anti_nutritional_factors": {
    "glucosinolatesMicromolG": null,
    "trypsinInhibitorTuG": null,
    "tanninsPpm": null,
    "phyticAcidPpm": null
  },
  "max_inclusion_pct": null,               // 0 = unlimited
  "warning": null,                         // safety note
  "regulatory_note": null,                 // regulatory note
  "is_custom": 0,
  "created_by": null,
  "created_date": null,
  "notes": null
}
```

## CSV Template (header)

```
name,crude_protein,crude_fiber,crude_fat,ash,moisture,starch,calcium,phosphorus,total_phosphorus,available_phosphorus,phytate_phosphorus,lysine,methionine,bulk_density,me_poultry,me_growing_pig,me_finishing_pig,me_ruminant,me_rabbit,de_salmonids,price_kg,amino_total_lys,amino_total_met,amino_total_cys,amino_total_thr,amino_total_trp,amino_total_phe,amino_total_tyr,amino_total_leu,amino_total_ile,amino_total_val,amino_sid_lys,amino_sid_met,amino_sid_cys,amino_sid_thr,amino_sid_trp,amino_sid_phe,amino_sid_tyr,amino_sid_leu,amino_sid_ile,amino_sid_val,anf_glucosinolate,anf_trypsin,anf_tannins,anf_phytic,max_inclusion_pct,warning,regulatory_note
```

## 10 Sample Ingredients (patterns)

Values are plausible references (rounded) for patterning; tune with source data before final load.

1) **Azolla (duckweed fern, sun-dried)**
- CP 22%, CF 13%, EE 3%, Ash 18%, Ca 17 g/kg, Total P 4 g/kg
- Amino total (g/kg): Lys 12, Met 3, Thr 9, Trp 2, Val 13, Ile 11, Leu 16, Phe 12, Tyr 10, Cys 2.5
- Energy (kcal/kg): ME poultry 2300, ME pig 2100, ME ruminant 1900
- ANF: phytic 3500 ppm; max inclusion 15%; warning: “Introduce gradually; watch palatability.”

1) **Moringa leaf meal (shade-dried)**
- CP 26%, CF 12%, EE 5%, Ash 9%, Ca 17 g/kg, Total P 3 g/kg
- Amino total: Lys 19, Met 5, Thr 13, Trp 3, Val 16, Ile 13, Leu 24, Phe 16, Tyr 12, Cys 3.5
- Energy: ME poultry 2400, ME pig 2200, ME ruminant 2000
- ANF: tannins 2500 ppm, phytic 4500 ppm; max inclusion 10%; warning: “High saponin/tannin; limit to 10%.”

1) **Duckweed (Lemna) meal**
- CP 32%, CF 8%, EE 4%, Ash 14%, Ca 12 g/kg, Total P 6 g/kg
- Amino total: Lys 20, Met 5, Thr 14, Trp 3.5, Val 17, Ile 15, Leu 24, Phe 17, Tyr 13, Cys 4
- Energy: ME poultry 2350, ME pig 2150, ME ruminant 1950
- ANF: phytic 3000 ppm; max inclusion 12%; warning: “Rinse if harvested from high-nitrate water.”

1) **Cassava peels (sun-dried)**
- CP 6%, CF 12%, EE 1.5%, Ash 5%, Starch 50%, Ca 3 g/kg, Total P 1.5 g/kg
- Amino total: Lys 2.5, Met 0.6, Thr 1.8, Trp 0.4, Val 2.2, Ile 1.8, Leu 3.5, Phe 2.3, Tyr 1.6, Cys 0.5
- Energy: ME poultry 2600, ME pig 2500, ME ruminant 2100
- ANF: cyanide risk—set warning: “Detoxify via proper drying/soaking”; max inclusion 20% (after detox).

1) **Sweet potato vines (sun-dried)**
- CP 17%, CF 15%, EE 2.5%, Ash 10%, Ca 15 g/kg, Total P 3 g/kg
- Amino total: Lys 11, Met 2.3, Thr 8, Trp 2, Val 10, Ile 8.5, Leu 14, Phe 10, Tyr 8, Cys 2
- Energy: ME poultry 2100, ME pig 2000, ME ruminant 1850
- ANF: phytic 3000 ppm; max inclusion 15%; warning: “Moderate fiber; watch intake in monogastrics.”

1) **Banana peels (sun-dried)**
- CP 6%, CF 12%, EE 3%, Ash 9%, Ca 5 g/kg, Total P 2 g/kg
- Amino total: Lys 3, Met 0.7, Thr 2.5, Trp 0.5, Val 3, Ile 2.5, Leu 4.5, Phe 3, Tyr 2.3, Cys 0.6
- Energy: ME poultry 2400, ME pig 2300, ME ruminant 2000
- ANF: tannins 1500 ppm; max inclusion 15%; warning: “High K; adjust mineral balance.”

1) **Mango seed kernel meal (detoxified)**
- CP 9%, CF 4%, EE 8%, Ash 3.5%, Ca 2 g/kg, Total P 2.5 g/kg
- Amino total: Lys 3, Met 1, Thr 2.5, Trp 0.4, Val 3, Ile 2.4, Leu 4, Phe 3, Tyr 2.2, Cys 0.8
- Energy: ME poultry 2800, ME pig 2700
- ANF: tannins 2500 ppm; warning: “Detoxify (heat/soak) to reduce tannins”; max inclusion 10%.

1) **Black soldier fly larvae meal (defatted)**
- CP 45%, CF 7%, EE 12%, Ash 8%, Ca 30 g/kg, Total P 8 g/kg
- Amino total: Lys 26, Met 7, Thr 18, Trp 4, Val 24, Ile 20, Leu 36, Phe 23, Tyr 18, Cys 6
- Energy: ME poultry 3200, ME pig 3000, ME finishing pig 3050, ME ruminant 2600, DE salmonids 3400
- ANF: None significant; max inclusion 20% (poultry/swine), 10% (fish); warning: “Monitor Ca:P balance.”

1) **Palm kernel cake (solvent-extracted)**
- CP 16%, CF 17%, EE 8%, Ash 5.5%, Ca 2.5 g/kg, Total P 6 g/kg
- Amino total: Lys 7, Met 3, Thr 6, Trp 1.5, Val 8, Ile 7, Leu 12, Phe 8, Tyr 6, Cys 2.5
- Energy: ME poultry 1900, ME pig 2000, ME ruminant 2100
- ANF: phytic 5500 ppm; max inclusion 10% (monogastric), 25% (ruminant); warning: “High fiber; limit in poultry.”

1) **Coconut meal (expeller)**
- CP 22%, CF 12%, EE 9%, Ash 5%, Ca 2 g/kg, Total P 5 g/kg
- Amino total: Lys 7, Met 3, Thr 6, Trp 1.5, Val 8, Ile 7, Leu 12, Phe 8, Tyr 6, Cys 2.5
- Energy: ME poultry 2200, ME pig 2150, ME ruminant 2050
- ANF: None significant; max inclusion 15% (monogastric), 25% (ruminant); warning: “Watch fiber for young birds.”

## Curated Missing Candidates by Region (to source next)

**India / South Asia**
- Mustard cake (low-glucosinolate), Groundnut haulms, Red gram (pigeon pea) husk, Cottonseed hulls (low gossypol), Neem seed cake (detox), Tamarind seed meal (detox), Karanja cake (detox), De-oiled rice bran (stabilized), Sorghum DDGS

**Southeast / East Asia (Philippines, Vietnam, Indonesia)**
- Copra expeller (high/low fat variants), Rice bran (stabilized), Cassava chip meal, Sago palm meal, Duckweed fresh/meal, Seaweed meals (Ulva, Sargassum) for fish/poultry, Sweet potato peels, Taro leaves (detox), Water spinach (Ipomoea aquatica)

**Africa (West/East/South)**
- Shea nut cake, Baobab seed meal, Jatropha kernel cake (detox, research-only), Bambara groundnut meal, Cowpea haulms, Sorghum malt sprout, Millet bran, Groundnut shells (fiber), Sunflower cake (high/low fiber), Brewer’s spent grain (fresh/dried)

**Europe**
- Rapeseed meal (low-GSL), Sunflower expeller (hi-pro/lo-pro), Beet pulp (dried), Distillers wheat grains, Pea hulls, Faba bean meal (tannin-managed), Lupin meal (sweet varieties), Brewer’s spent grain

**Americas**
- Corn DDGS (hi-pro), Bakery meal, Citrus pulp (dried), Cottonseed meal (de-gossypol), Peanut skins (tannin-managed), Feather meal (hydrolyzed), Meat & bone meal (regulatory-dependent), Poultry by-product meal (regulatory-dependent), Alfalfa pellets (sun-cured/dehy)

## Next Steps

1) Confirm target list (80+ from regions above) and lock nutritional sources (NRC/CVB/INRA/FAO + peer-reviewed local data).
2) Populate CSV/JSON using the template; ensure all v5 fields set or safely null; include ANFs and max inclusion.
3) Validate against `Ingredient` model; keep legacy fields present for back-compat (lysine/methionine/phosphorus, ME fields).
4) Run/extend `ingredient_model_test.dart` with new samples; keep test suite green.
5) Ingest into DB via seed/import; no schema change required (v9 already supports fields).
