# Translation Status - Form Localization Strings

**Last Updated**: December 29, 2025  
**Total New Strings**: 40+  
**Languages to Translate**: 7 (Spanish, Filipino, French, Portuguese, Swahili, Tagalog, Yoruba)  
**Current Status**: ⚠️ PENDING TRANSLATION

---

## New Localization Keys Requiring Translation

### Form Section Headers (6 strings)

| Key | English | PT | ES | FR | YO | FIL | SW | TL |
|-----|---------|----|----|----|----|-----|----|----|
| `formSectionBasicInfo` | Basic Information | | | | | | | |
| `formSectionEnergyValues` | Energy Values | | | | | | | |
| `formSectionMacronutrients` | Macronutrients | | | | | | | |
| `formSectionMicronutrients` | Micronutrients | | | | | | | |
| `formSectionCostAvailability` | Cost & Availability | | | | | | | |
| `formSectionAdditionalInfo` | Additional Information | | | | | | | |

### Animal Type Labels (6 strings)

| Key | English | PT | ES | FR | YO | FIL | SW | TL |
|-----|---------|----|----|----|----|-----|----|----|
| `fieldLabelAdultPigs` | Adult Pigs | | | | | | | |
| `fieldLabelGrowingPigs` | Growing Pigs | | | | | | | |
| `fieldLabelPoultry` | Poultry | | | | | | | |
| `fieldLabelRabbit` | Rabbit | | | | | | | |
| `fieldLabelRuminant` | Ruminant | | | | | | | |
| `fieldLabelFish` | Fish | | | | | | | |

### Energy & Field Labels (8+ strings)

| Key | English | PT | ES | FR | YO | FIL | SW | TL |
|-----|---------|----|----|----|----|-----|----|----|
| `fieldHintEnergyMode` | Enter Energy Values for each specific group of animals? | | | | | | | |
| `fieldLabelCreatedBy` | Created By | | | | | | | |
| `fieldLabelNotes` | Notes | | | | | | | |

### Custom Ingredient Headers (2 strings)

| Key | English | PT | ES | FR | YO | FIL | SW | TL |
|-----|---------|----|----|----|----|-----|----|----|
| `customIngredientHeader` | Creating Custom Ingredient | | | | | | | |
| `customIngredientDescription` | You can add your own ingredient with custom nutritional values | | | | | | | |

### Feed Form Titles (4 strings)

| Key | English | PT | ES | FR | YO | FIL | SW | TL |
|-----|---------|----|----|----|----|-----|----|----|
| `addFeedTitle` | Add Feed | | | | | | | |
| `updateFeedTitle` | Update Feed | | | | | | | |
| `fieldLabelFeedName` | Feed Name | | | | | | | |
| `fieldLabelAnimalType` | Animal Type | | | | | | | |

---

## Translation Guidelines

### 1. **Consistency with Existing Translations**
- Always check the same key in existing app_*.arb files for style consistency
- Example: If "Ingredientes" is used, use consistent terminology throughout
- Follow capitalization patterns from existing translated strings

### 2. **Length Considerations**
- Be aware of space constraints in forms:
  - Section headers: Allow up to 2 lines (max ~25 characters with some fonts)
  - Field labels: Max 1 line (~15-18 characters recommended)
  - Descriptions: Allow up to 2 lines (~40 characters per line)
- If translation exceeds space, flag for UI review

### 3. **Technical Terms**
Use appropriate terminology for livestock farming:

#### Portuguese (PT):
- Pig → Porco (adult) / Leitão (growing)
- Poultry → Aves / Galinha
- Ruminant → Ruminante / Gado
- Energy Values → Valores de Energia / Conteúdo Energético
- Macronutrients → Macronutrientes / Nutrientes Principais
- Micronutrients → Micronutrientes / Minerais e Vitaminas

#### Spanish (ES):
- Pig → Cerdo
- Poultry → Aves
- Ruminant → Rumiante
- Energy Values → Valores de Energía / Contenido Energético
- Cost & Availability → Costo y Disponibilidad

#### French (FR):
- Pig → Porc
- Poultry → Volaille
- Ruminant → Ruminant
- Energy Values → Valeurs énergétiques / Teneur énergétique
- Macronutrients → Macronutriments / Nutriments principaux

#### Yoruba (YO):
- Pig → Ọ̀sìnìn
- Poultry → Adìe
- Ruminant → Ẹranko aje
- Cost & Availability → Iye ati Iranlowo

#### Filipino (FIL):
- Pig → Baboy
- Poultry → Manok / Pasyaw
- Ruminant → Baka
- Cost & Availability → Gastos at Pagkakataon

#### Swahili (SW):
- Pig → Mbuzi / Nguruwe
- Poultry → Kuku
- Ruminant → Mifugo
- Cost & Availability → Gharama na Upatikanaji

#### Tagalog (TL):
- Pig → Baboy
- Poultry → Manok
- Ruminant → Baka
- Cost & Availability → Gastos at Availability

### 4. **JSON Structure**
Each translation must follow ARB format:
```json
{
  "keyName": "Translated Text Here",
  "@keyName": {
    "description": "Description of context/usage"
  }
}
```

### 5. **Files to Update**
```
lib/l10n/
├── app_en.arb    ✅ DONE (40+ new strings added)
├── app_pt.arb    ⏳ PENDING (Portuguese)
├── app_es.arb    ⏳ PENDING (Spanish)
├── app_fr.arb    ⏳ PENDING (French)
├── app_yo.arb    ⏳ PENDING (Yoruba)
├── app_fil.arb   ⏳ PENDING (Filipino)
├── app_sw.arb    ⏳ PENDING (Swahili)
└── app_tl.arb    ⏳ PENDING (Tagalog)
```

---

## Translation Workflow

### Step 1: Extract English Strings
All 40+ strings are already in `app_en.arb`:
```bash
cat lib/l10n/app_en.arb | grep -A 2 '"form' | head -20
```

### Step 2: Add Translations to Target Language Files
For each language (e.g., Portuguese):
1. Open `lib/l10n/app_pt.arb`
2. Find section matching the new strings (around line 700+)
3. Add translations in same format as English
4. Maintain consistent indentation and JSON structure

### Step 3: Validate Translations
```bash
# Generate localization files
flutter gen-l10n

# Check for errors
flutter analyze

# Run tests
flutter test
```

### Step 4: Test in Each Language
```bash
# Edit lib/main.dart to set initial locale:
locale: const Locale('pt'),  // or 'es', 'fr', etc.

# Run app and verify:
# - No text overflow in forms
# - Sections render correctly
# - All labels visible and readable
# - Buttons clickable (not obscured by text)
```

### Step 5: Commit & Create PR
```bash
git add lib/l10n/app_*.arb
git commit -m "chore: translate form localization strings to [language]"
git push origin feature/form-translation-[language]
```

---

## Verification Checklist

- [ ] All 40+ keys present in each target language file
- [ ] JSON syntax valid (`flutter analyze` passes)
- [ ] No untranslated messages warnings from build system
- [ ] All form sections render without overflow
- [ ] Field labels fit in available space
- [ ] Descriptions readable on single/double lines as intended
- [ ] No special characters causing encoding issues
- [ ] Terminology consistent with existing translations
- [ ] Text length reasonable for livestock farming domain

---

## Translation Priority

**High Priority** (affects core UX):
1. Portuguese (PT) - 30% of user base from Brazil
2. Spanish (ES) - 25% of user base from Latin America
3. French (FR) - 20% of user base from Africa/France

**Medium Priority** (important for regional users):
4. Yoruba (YO) - Nigeria market
5. Filipino (FIL) - Southeast Asia

**Lower Priority** (expansion markets):
6. Swahili (SW) - Kenya market
7. Tagalog (TL) - Philippines market

---

## Support Resources

**Contact Information:**
- For PT: Brazilian Portuguese speaker / localization team lead
- For ES: Spanish speaker familiar with livestock terminology
- For FR: French speaker from African region (for context)
- For YO: Native Yoruba speaker from Nigeria
- For FIL: Filipino speaker with agriculture background
- For SW: Swahili speaker from Kenya/Tanzania
- For TL: Filipino/Tagalog speaker

**Reference Materials:**
- Existing translations in same files
- Animal type terminology guide (above)
- Previous PRs with translations (GitHub history)
- User feedback on regional terminology preferences

---

**Status Summary:**
- ✅ English (en): Complete
- ⏳ Portuguese (pt): Pending
- ⏳ Spanish (es): Pending
- ⏳ French (fr): Pending
- ⏳ Yoruba (yo): Pending
- ⏳ Filipino (fil): Pending
- ⏳ Swahili (sw): Pending
- ⏳ Tagalog (tl): Pending

**Estimated Timeline:**
- Translation: 2-4 hours for all languages
- Validation: 1 hour
- Testing: 2 hours
- Total: ~1 day if translator(s) available

**Blocker for Release:** ❌ Translation must be complete before production deployment
