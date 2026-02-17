# Feed Estimator - Feature Guides

**Last Updated**: February 17, 2026  
**Status**: Complete ✅

---

## Table of Contents

- [Animal Categories System](#animal-categories-system)
- [Price Management](#price-management)
- [Import/Export Functionality](#importexport-functionality)
- [User Feedback Integration](#user-feedback-integration)
- [Best Practices](#best-practices)

---

## Animal Categories System

### Overview

The Animal Categories system enables precise feed formulation for different animal species and production stages, with industry-standard nutrient requirements.

### Supported Species

**1. Poultry** (Chickens, Turkeys, Ducks)
- Starter (0-3 weeks)
- Grower (3-6 weeks)
- Finisher (6+ weeks)
- Layer (egg production)
- Breeder (reproduction)

**2. Swine** (Pigs)
- Starter (weaning-25kg)
- Grower (25-60kg)
- Finisher (60-100kg)
- Gestation (pregnant sows)
- Lactation (nursing sows)

**3. Ruminants** (Cattle, Sheep, Goats)
- Calf/Lamb/Kid (pre-weaning)
- Growing (post-weaning)
- Finishing (market weight)
- Lactation (dairy)
- Maintenance (dry period)

**4. Rabbits**
- Growing (weaning-market)
- Breeding does
- Breeding bucks
- Lactation

**5. Fish** (Aquaculture)
- Fry (early stage)
- Fingerling (juvenile)
- Grower (market size)

### Industry Standards

**NRC 2012** (Swine):
- Nutrient requirements by weight and stage
- Energy calculation methodologies
- Amino acid digestibility values

**NRC 2016** (Poultry):
- Poultry nutrient requirements
- ME calculation for poultry
- Amino acid profiles

**CVB 2021** (European):
- European livestock feed value tables
- Standardized digestibility coefficients

**INRA-AFZ 2018** (French/International):
- International feed composition
- Ruminant energy systems

### Usage

1. **Select Animal Type**: Choose from 5 species
2. **Select Production Stage**: Choose appropriate stage
3. **Automatic Requirements**: System loads industry-standard requirements
4. **Customize**: Adjust requirements as needed
5. **Formulate**: Create feed meeting requirements

---

## Price Management

### Overview

The Price Management system enables users to track ingredient prices over time, visualize trends, and manage costs effectively.

### Features

**1. User-Editable Prices**:
- Override default ingredient prices
- Set custom prices per ingredient
- Date-stamped price changes
- Source attribution

**2. Price History Tracking**:
- Record all price changes
- View historical prices
- Track price trends
- Compare prices over time

**3. Multi-Currency Support**:
- NGN (Nigerian Naira)
- USD (US Dollar)
- EUR (Euro)
- GBP (British Pound)
- Automatic currency conversion

**4. Price Trend Visualization**:
- Line charts showing price changes
- Date range selection
- Interactive charts (zoom, pan)
- Export chart data

**5. Bidirectional Sync**:
- Ingredient prices sync with price history
- Price history updates ingredient prices
- Consistent data across app

### Database Schema

**`price_history` Table**:
- `id` (primary key)
- `ingredient_id` (foreign key)
- `price` (decimal)
- `currency` (string)
- `date` (timestamp)
- `source` (string)
- `notes` (text)
- `created_at` (timestamp)

### Usage

**Edit Ingredient Price**:
1. Navigate to Ingredients screen
2. Select ingredient
3. Tap "Edit Price" button
4. Enter new price and currency
5. Add optional notes
6. Save

**View Price History**:
1. Open ingredient details
2. Expand "Price History" section
3. View chart and table
4. Filter by date range
5. Export data if needed

**Bulk Price Import**:
1. Prepare CSV file with prices
2. Navigate to Settings > Import Prices
3. Select CSV file
4. Review and confirm
5. Import prices

---

## Import/Export Functionality

### Overview

The Import/Export system enables bulk ingredient management through CSV files, making it easy to add many ingredients at once or backup custom ingredients.

### CSV Import

**Features**:
- Parse CSV files with ingredient data
- Validate all fields before import
- Detect and resolve duplicate ingredients
- Preview import before confirming
- Error handling with clear messages

**CSV Format**:
```csv
name,category,crude_protein,crude_fiber,crude_fat,calcium,phosphorus,lysine,methionine,me_poultry,me_swine
Corn,Grains,8.5,2.2,3.8,0.02,0.28,0.26,0.18,3350,3400
Soybean Meal,Protein,47.5,3.5,1.0,0.29,0.65,2.96,0.67,2230,2440
```

**Supported Fields** (20+):
- Basic: name, category
- Macronutrients: crude_protein, crude_fiber, crude_fat, ash, moisture, starch
- Minerals: calcium, total_phosphorus, available_phosphorus
- Amino acids: lysine, methionine, threonine, tryptophan, etc.
- Energy: me_poultry, me_swine, me_ruminant, etc.

**Import Process**:
1. **Select File**: Choose CSV file from device
2. **Parse**: System reads and validates CSV
3. **Detect Conflicts**: Identify duplicate ingredients
4. **Resolve**: Choose to skip, replace, or rename duplicates
5. **Preview**: Review ingredients to be imported
6. **Import**: Confirm and import to database
7. **Verify**: Check imported ingredients

**Conflict Resolution**:
- **Skip**: Don't import duplicate
- **Replace**: Overwrite existing ingredient
- **Rename**: Import with modified name
- **Merge**: Combine data from both

### CSV Export

**Features**:
- Export all ingredients to CSV
- Export custom ingredients only
- Export selected ingredients
- Export formulations
- Standardized format compatible with Excel/Google Sheets

**Export Process**:
1. Navigate to Ingredients screen
2. Tap "Export" button
3. Choose export type (all/custom/selected)
4. Select file location
5. Confirm export
6. Share or save file

**Use Cases**:
- Backup custom ingredients
- Share ingredients with team
- Import to spreadsheet for analysis
- Transfer data between devices

---

## User Feedback Integration

### Overview

Based on 148 verified Google Play Store reviews (4.5★ average), we've integrated user feedback into the app's development roadmap.

### User Demographics

**Primary Users**:
- Livestock farmers in Nigeria/Africa
- Aquaculture operators
- Agropreneurs
- Feed mill operators

**Key Concerns**:
- Cost optimization
- Ingredient availability
- Ease of use
- Accurate calculations

### Top User Requests

**1. More Ingredients** (66% of feedback):
- ✅ **COMPLETED**: Added 57 tropical ingredients
- ✅ Azolla, Cassava hay, Moringa, Napier grass
- ✅ Duckweed, Water hyacinth, Water lettuce
- ✅ Black soldier fly larvae, Cricket meal, Earthworm meal
- ✅ Total: 209 ingredients (was 152)

**2. Price Editing** (20% of feedback):
- ✅ **COMPLETED**: User-editable ingredient prices
- ✅ Price history tracking
- ✅ Multi-currency support
- ✅ Price trend visualization

**3. Inventory Tracking** (14% of feedback):
- 📋 **PLANNED**: Stock level tracking
- 📋 Low-stock alerts
- 📋 Consumption trends
- 📋 Integration with formulation

**4. Better Reporting** (11% of feedback):
- 📋 **PLANNED**: Cost breakdown charts
- 📋 Nutritional composition visualization
- 📋 What-if analysis
- 📋 Batch calculation reports

### Success Metrics

**Target Improvements**:
- Rating: 4.5★ → 4.6+★ (within 2 months)
- Reviews: 148 → 250+ (within 2 months)
- Feature adoption: >60% of users
- Negative reviews: 7 → <3

---

## Best Practices

### Feed Formulation

**1. Start with Requirements**:
- Select animal type and production stage
- Review industry-standard requirements
- Adjust for specific needs

**2. Choose Ingredients**:
- Use regional filters for local availability
- Consider cost and nutritional value
- Check max inclusion limits
- Review safety warnings

**3. Balance Nutrients**:
- Aim to meet all requirements
- Don't exceed max inclusion limits
- Consider anti-nutritional factors
- Balance cost vs nutrition

**4. Verify Calculations**:
- Review nutritional analysis
- Check cost breakdown
- Ensure all requirements met
- Look for warnings

**5. Save and Export**:
- Save formulation with descriptive name
- Export as PDF for reference
- Share with team or veterinarian

### Price Management

**1. Update Prices Regularly**:
- Check market prices weekly/monthly
- Update ingredient prices as needed
- Add notes about price sources
- Track price trends

**2. Use Price History**:
- Review historical prices before buying
- Identify seasonal trends
- Plan purchases during low prices
- Budget for price fluctuations

**3. Multi-Currency**:
- Use local currency for accuracy
- Convert to USD for comparison
- Track exchange rate changes
- Update currency rates regularly

### Data Management

**1. Backup Regularly**:
- Export all data monthly
- Save CSV files securely
- Keep multiple backups
- Test restore process

**2. Organize Ingredients**:
- Use descriptive names
- Add regional tags
- Set max inclusion limits
- Add safety warnings

**3. Validate Data**:
- Check nutritional values against standards
- Verify energy calculations
- Confirm amino acid profiles
- Review phosphorus breakdown

---

**Status**: Complete ✅  
**User Feedback**: Integrated ✅  
**Best Practices**: Documented ✅
