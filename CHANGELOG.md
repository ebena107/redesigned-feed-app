# Changelog

All notable changes to Feed Estimator will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Comprehensive deployment documentation suite
  - `DEPLOYMENT_READINESS_REPORT.md` - Complete production readiness audit
  - `PRE_DEPLOYMENT_CHECKLIST.md` - Quick reference for submission
  - `GOOGLE_PLAY_SUBMISSION_GUIDE.md` - Step-by-step Play Store guide

### Fixed
- Replaced placeholder privacy URLs with GitHub-hosted PRIVACY_POLICY.md link
- Added missing `url_launcher` import to settings screen
- Privacy policy now accessible from all screens (Settings, Consent, Privacy Settings)

---

## [1.0.0+12] - 2025-01-XX (Release Candidate)

### Added

#### Price Management System (Phase 4.5e)
- **Price History Tracking**: Record historical ingredient prices with dates, sources, and notes
- **Price Trend Visualization**: Interactive line chart showing price trends over time
- **Multi-Currency Support**: NGN, USD, EUR, GBP with proper currency symbols
- **Price Editing**: Add, edit, delete price records with validation
- **Bidirectional Sync**: Ingredient prices automatically sync with price history
- **New Database Table**: `price_history` with 8 columns and performance indexing

#### Ingredient Database Expansion (Phase 4.6)
- **57 New Ingredients** (27% increase): 152 → 209 total ingredients
- **Tropical Forages** (15): Azolla, Cassava hay, Cowpea hay, Desmodium, Gliricidia, Lablab hay, Leucaena, Moringa leaves, Mucuna hay, Napier grass, Pennisetum hay, Pigeon pea hay, Sesbania, Stylosanthes, Tithonia
- **Aquatic Plants** (3): Duckweed (Lemna), Water hyacinth, Water lettuce
- **Alternative Proteins** (12): Black soldier fly larvae, Cricket meal, Earthworm meal, Grasshopper meal, Locust meal, Maggot meal, Mealworm meal, Palm weevil larvae, Silk worm pupae, Snail meal, Termite meal, Tilapia by-product
- **Energy Sources** (8): Barley, Cassava root meal, Corn gluten feed (wet), Rice (broken), Rye, Sorghum distillers grains, Sweet potato vine, Triticale
- **Novel Ingredients** (19): Algae meal, Banana stem, Brewer's yeast, Carob meal, Citrus pulp, Cocoa husks, Coffee pulp, Date palm waste, Faba bean hulls, Guava leaves, Jackfruit waste, Mango seed kernel, Neem cake, Papaya leaves, Pumpkin seed meal, Sesame cake, Sugarcane bagasse, Sunflower heads, Yeast culture

#### Localization (Phase 4.7a)
- **Complete 8-Language Support**: English, Spanish, Portuguese, Filipino, French, Yoruba, Swahili, Tagalog
- **120+ Localized Strings**: All UI elements, dialogs, error messages, field labels
- **Locale Switcher**: User can change language in Settings screen
- **RTL Support Preparation**: Framework ready for right-to-left languages

#### CSV Import System (Phase 5.1)
- **Bulk Ingredient Import**: CSV file parsing and validation
- **Conflict Resolution**: Smart detection and handling of duplicate ingredients
- **Import Wizard**: Step-by-step guided import process with preview
- **Validation**: Comprehensive field validation before import
- **Export Integration**: Share custom ingredients as CSV files

#### Performance Optimizations (Phase 4.2-4.4)
- **List Virtualization**: Ingredient lists now use `ListView.builder` with `itemExtent` for 60fps scroll
- **Pagination Helper**: Lazy loading for long lists (pageSize=50, preloadThreshold=10)
- **Memory Optimization**: O(visible) widget creation vs O(n) full list
- **Database Timeouts**: 30-second timeout protection on all async operations
- **Provider Caching**: Optimized price history provider with better state management

#### UI/UX Enhancements
- **Production Stage Selection**: Feed formulations now track production stage (Starter, Grower, Finisher, etc.)
- **Expandable Price History**: Collapsible price chart on ingredient cards
- **Segmented Buttons**: Replaced deprecated radio selectors with modern segmented button UI
- **Improved Navigation**: Fixed "Add New" button navigation in ingredient filters
- **Horizontal Scrolling**: Long ingredient names scroll horizontally instead of overflow
- **Regional Badges**: Ingredient cards show regional tags (Africa, Asia, Europe, Americas, Oceania, Global)

### Changed
- **Database Schema**: Migration v7 → v12 (v8 for ingredients, v12 for regions)
- **Ingredient Model**: Enhanced with max inclusion limits and safety warnings
- **Build Configuration**: ProGuard/R8 enabled for release builds (code shrinking + obfuscation)
- **Privacy Policy**: Updated to v1.0.0+12 standards with comprehensive data handling details

### Fixed
- **Layout Overflow**: Resolved RenderFlex overflow errors in feed ingredients list
- **Regional Filter**: Fixed ingredient filtering by geographic region
- **Price Synchronization**: Bidirectional sync between ingredient prices and price history
- **QueryResultSet**: Resolved read-only error in price history repository
- **Context Validation**: Proper context checking for import dialogs and ScaffoldMessenger
- **Lint Issues**: All lint warnings resolved (0 errors, 0 warnings)
- **Conflict Detector**: Cleaned up test conflicts and TODOs
- **Max Inclusion**: Added limits and warnings to canola and cassava ingredients

### Security
- **ProGuard Enabled**: Code obfuscation and shrinking for release builds
- **Input Validation**: Comprehensive validation for price, date, quantity, and name fields
- **SQL Injection Protection**: Parameterized queries throughout database layer
- **Privacy Compliance**: GDPR, CCPA, Nigerian Data Protection Act compliant

### Testing
- **355 Tests Passing**: 278 unit + 4 widget + 1 integration test suites
- **100% Pass Rate**: Zero test failures
- **New Tests**: 26 unit tests for PriceHistory model, 4 widget tests for price UI
- **Coverage**: 80%+ for core business logic

---

## [1.0.0+11] - 2024-12-XX (Previous Release)

### Added
- Initial production release
- 152 livestock feed ingredients
- NRC 2012 standard calculations
- Multi-animal support (Pig, Poultry, Rabbit, Ruminant, Fish)
- PDF export functionality
- Database migration system (v1-v7)
- Privacy consent flow
- Offline-first architecture

### Features
- Feed formulation management
- Nutritional analysis with amino acid profiles
- Custom ingredient creation
- Cost tracking and analysis
- Export/Import functionality

---

## Version History Summary

| Version | Date | Key Features | Ingredients | Tests | Status |
|---------|------|--------------|-------------|-------|--------|
| 1.0.0+12 | Jan 2025 | Price tracking, 57 new ingredients, 8 languages | 209 | 355 | RC |
| 1.0.0+11 | Dec 2024 | Initial release | 152 | 282 | Released |

---

## Upgrade Notes

### From v1.0.0+11 to v1.0.0+12

**Database**:
- Automatic migration from v7 → v12 (no data loss)
- New `price_history` table created automatically
- Regional tags added to ingredients table

**Breaking Changes**: None - fully backward compatible

**Recommended Actions**:
1. Backup existing data before upgrade (Settings > Export Data)
2. Test ingredient price functionality
3. Verify all feeds still calculate correctly
4. Check localization in your preferred language

**New Permissions**: None required

---

## Support & Resources

- **GitHub Repository**: https://github.com/ebena107/redesigned-feed-app
- **Privacy Policy**: [PRIVACY_POLICY.md](PRIVACY_POLICY.md)
- **Release Notes**: [RELEASE_NOTES_v1.0.0+12.md](RELEASE_NOTES_v1.0.0+12.md)
- **Deployment Guide**: [doc/DEPLOYMENT_READINESS_REPORT.md](doc/DEPLOYMENT_READINESS_REPORT.md)

---

## Contributing

See [MODERNIZATION_PLAN.md](doc/MODERNIZATION_PLAN.md) for development roadmap and contribution guidelines.

---

**Maintained by**: Ebena NG  
**License**: [Add license information]  
**Contact**: [Add support email]

---

_This changelog follows [Keep a Changelog](https://keepachangelog.com/) format for clarity and consistency._
