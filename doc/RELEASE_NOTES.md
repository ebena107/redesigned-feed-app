# Feed Estimator - Release Notes

**Last Updated**: February 17, 2026  
**Current Version**: 1.0.2+12

---

## Table of Contents

- [Version History](#version-history)
- [Latest Release (v1.0.2+12)](#latest-release-v1.0.2+12)
- [Previous Releases](#previous-releases)
- [Upgrade Guides](#upgrade-guides)
- [Breaking Changes](#breaking-changes)

---

## Version History

| Version | Date | Key Features | Status |
|---------|------|--------------|--------|
| 1.0.2+12 | Jan 2026 | Bug fixes, dialog improvements | Current |
| 1.1.5+14 | Jan 2026 | CSV import, localization | Released |
| 1.0.0+12 | Jan 2025 | Price management, ingredients | Released |
| 1.0.0+11 | Dec 2024 | Initial production release | Legacy |

---

## Latest Release (v1.0.2+12)

**Release Date**: January 3, 2026  
**Build Number**: 12  
**Status**: Production

### Bug Fixes

**Dialog Improvements**:
- Fixed delete confirmation dialog cancel button not working in grid menu
- Fixed ingredient removal dialog crash in update feed mode (TypeError on context.l10n access)
- Added confirmation dialog when removing ingredients from cart to prevent accidental deletion
- Fixed cart ingredient removal dialog not localized - Now supports all 8 languages

**Code Quality**:
- Standardized all dialog dismiss patterns using `Navigator.of(context).pop()`
- Improved dialog localization by passing strings as constructor parameters
- Enhanced error handling in delete operations with proper mounted checks
- Cart delete dialog now properly localized in Swahili, Spanish, French, and all other supported languages

### Technical

- Comprehensive dialog implementation audit (35+ dialogs verified)
- Context.pop() usage audit (10 instances reviewed and corrected)
- Hardcoded strings audit (13+ instances identified, cart fixed)
- Clean flutter analyze output with zero issues

---

## Previous Releases

### v1.1.5+14 (January 2026)

**Major Features**:

**CSV Import/Export System**:
- Bulk ingredient import from CSV files
- Conflict resolution for duplicate ingredients
- Import wizard with preview and validation
- Export custom ingredients as CSV
- Share formulations via CSV

**Complete 8-Language Localization**:
- English, Spanish, Portuguese, Filipino, French, Yoruba, Swahili, Tagalog
- 120+ localized strings
- Locale switcher in Settings
- RTL support preparation

**Bug Fixes**:
- Fixed GoRouter stack underflow (About page)
- Fixed feed grid render overflow
- Fixed dialog stack management issues
- Performance improvements

**Metrics**:
- 445/445 tests passing
- Zero lint warnings
- 100% localization coverage

---

### v1.0.0+12 (January 2025)

**Major Features**:

**Price Management System**:
- User-editable ingredient prices
- Price history tracking with dates
- Multi-currency support (NGN, USD, EUR, GBP)
- Price trend visualization (line charts)
- Bidirectional sync between ingredients and price history

**Ingredient Database Expansion**:
- **57 new ingredients** (152 → 209 total)
- Tropical forages (15): Azolla, Cassava hay, Moringa, Napier grass
- Aquatic plants (3): Duckweed, Water hyacinth, Water lettuce
- Alternative proteins (12): Black soldier fly larvae, Cricket meal, Earthworm meal
- Energy sources (8): Barley, Cassava root meal, Sweet potato vine
- Novel ingredients (19): Algae meal, Brewer's yeast, Neem cake

**Enhanced Calculations**:
- 10 amino acids (lysine, methionine, threonine, tryptophan, etc.)
- SID (Standardized Ileal Digestibility) calculations
- Phosphorus breakdown (total, available, phytate)
- Energy values for 7 species

**Performance Optimizations**:
- List virtualization with `ListView.builder`
- Pagination helper for lazy loading
- 60fps scroll performance
- Memory optimization: O(visible) vs O(n)
- Database timeout protection (30 seconds)

**UI/UX Enhancements**:
- Production stage selection
- Expandable price history charts
- Segmented buttons (replaced deprecated radio selectors)
- Horizontal scrolling for long ingredient names
- Regional badges on ingredient cards

**Database**:
- Migration v7 → v12
- New `price_history` table
- Regional tagging support
- Backward compatible migrations

**Testing**:
- 355 tests passing (278 unit + 4 widget + 1 integration)
- 100% pass rate
- 80%+ coverage for core business logic

---

### v1.0.0+11 (December 2024)

**Initial Production Release**:

**Core Features**:
- Feed formulation management
- 152 livestock feed ingredients
- NRC 2012 standard calculations
- Multi-animal support (Pig, Poultry, Rabbit, Ruminant, Fish)
- PDF export functionality
- Database migration system (v1-v7)
- Privacy consent flow
- Offline-first architecture

**Features**:
- Feed formulation creation, editing, deletion
- Nutritional analysis with amino acid profiles
- Custom ingredient creation
- Cost tracking and analysis
- Export/Import functionality

---

## Upgrade Guides

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

### From v1.0.0+12 to v1.1.5+14

**Database**:
- No schema changes
- All data preserved

**Breaking Changes**: None

**New Features**:
- CSV import/export available in Ingredients screen
- Language selector in Settings
- All UI elements now localized

**Recommended Actions**:
1. Explore CSV import for bulk ingredient additions
2. Try different languages in Settings
3. Export your custom ingredients as backup

---

### From v1.1.5+14 to v1.0.2+12

**Bug Fixes Only**:
- No new features
- No database changes
- No breaking changes

**What's Fixed**:
- Dialog localization issues
- Cart ingredient removal crashes
- Delete confirmation dialogs

**Recommended Actions**:
- Update immediately for bug fixes
- No special migration steps needed

---

## Breaking Changes

### None in Current Versions

All releases from v1.0.0+11 to v1.0.2+12 are fully backward compatible with no breaking changes.

**Future Breaking Changes** (if any):
- Will be clearly documented here
- Migration guides will be provided
- Deprecation warnings will be given in advance

---

## Feature Additions by Version

### v1.0.0+11 (Initial Release)
- ✅ Feed formulation management
- ✅ 152 ingredients
- ✅ NRC 2012 calculations
- ✅ PDF export
- ✅ Multi-animal support

### v1.0.0+12
- ✅ Price management (+)
- ✅ 57 new ingredients (+)
- ✅ Enhanced calculations (+)
- ✅ Performance optimizations (+)
- ✅ Regional tagging (+)

### v1.1.5+14
- ✅ CSV import/export (+)
- ✅ 8-language localization (+)
- ✅ Bug fixes (+)

### v1.0.2+12
- ✅ Dialog improvements (+)
- ✅ Localization fixes (+)

---

## Support & Resources

**Documentation**:
- [PROJECT_OVERVIEW.md](PROJECT_OVERVIEW.md) - Project information
- [DEVELOPMENT_HISTORY.md](DEVELOPMENT_HISTORY.md) - Development timeline
- [DATA_MANAGEMENT.md](DATA_MANAGEMENT.md) - Database documentation
- [DEPLOYMENT_AND_COMPLIANCE.md](DEPLOYMENT_AND_COMPLIANCE.md) - Deployment guide

**GitHub Repository**: https://github.com/ebena107/redesigned-feed-app  
**Privacy Policy**: [PRIVACY_POLICY.md](PRIVACY_POLICY.md)  
**Issues**: GitHub Issues  
**Email**: [Add support email]

---

**Current Version**: 1.0.2+12  
**Release Date**: January 3, 2026  
**Status**: Production ✅
