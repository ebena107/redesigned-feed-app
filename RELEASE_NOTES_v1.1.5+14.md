# Release Notes - Version 1.1.5+14

**Release Date**: February 14, 2026  
**Build Number**: 14  
**Version**: 1.1.5

---

## 🚨 CRITICAL FIX - Feed Data Preservation

### Major Changes

#### Database Schema Fix (CRITICAL)

- **Fixed critical database bug** that caused user feed formulations to become inaccessible
- Corrected foreign key references in `feed_ingredients` table
- Added automatic data recovery migration (V12→V13)
- **All existing feed data will be automatically restored upon update**

#### What Was Wrong?

The `feed_ingredients` table had incorrect foreign key references:

- `feed_id` was referencing itself instead of the `feeds` table
- `ingredient_id` was referencing wrong table (`ingredient_categories` instead of `ingredients`)

This caused referential integrity violations that made feed data appear "lost" when it was actually just orphaned in the database.

#### What We Fixed

- ✅ Corrected all foreign key references to point to proper tables
- ✅ Added migration V12→V13 that automatically repairs existing databases
- ✅ Preserves ALL existing user data (zero data loss)
- ✅ Improved cascade delete behavior for cleaner data management

---

## ✨ New Features

### Copy Ingredient Feature

- **Create custom ingredients from existing ones**
- New copy button (📋) on each ingredient in the ingredient selector
- Tap to pre-fill all nutritional values from an existing ingredient
- Modify values as needed and save as new custom ingredient
- Notes field automatically populated with "Copied from [ingredient name]"

**Use Case**: Perfect for creating ingredient variations with adjusted values while preserving the original data.

---

## 🔧 Improvements

### Code Quality

- ✅ Flutter analyze passes with zero issues
- ✅ All dependencies up to date
- ✅ Optimized database migrations for better performance
- ✅ Improved error handling in database operations

### Performance

- Database operations use proper foreign key constraints
- Cascade deletes prevent orphaned data
- Cleaner data relationships improve query performance

---

## 🗄️ Database Changes

### Migration V12→V13 (Automatic)

This migration runs automatically when you update the app:

1. **Backs up** existing `feed_ingredients` table
2. **Creates** new table with correct foreign keys
3. **Copies** all existing data (100% preservation)
4. **Removes** old table
5. **Validates** data integrity

**User Impact**: None - migration is automatic and transparent

---

## ⚠️ Breaking Changes

**None** - This is a bug fix release that maintains full backward compatibility.

---

## 📦 Installation

### For Users

1. Update app from Play Store or install APK
2. **First launch may take slightly longer** (migration running)
3. All your feeds will be automatically restored
4. No manual action required

### For Developers

```bash
git pull origin master
flutter pub get
flutter build apk --release
```

---

## 🧪 Testing Performed

### Pre-Release Testing

- ✅ Fresh install test - All features working
- ✅ Migration test (V12→V13) - Data preserved
- ✅ Feed creation/editing - Working correctly
- ✅ Foreign key validation - Passing
- ✅ Data integrity check - No violations
- ✅ Performance test - No degradation

### Devices Tested

- Android (Vivo V2318)
- Windows Desktop
- Various API levels

---

## 🐛 Known Issues

### Minor Issues (Non-Blocking)

- Localization: 7 languages have untranslated messages (does not affect functionality)
  - Spanish (es): 21 messages
  - Filipino (fil): 57 messages
  - French (fr): 21 messages
  - Portuguese (pt): 57 messages
  - Swahili (sw): 55 messages
  - Tagalog (tl): 57 messages
  - Yoruba (yo): 57 messages

### Java Warnings (Non-Critical)

- Build shows Java 8 obsolete warnings
- Does not affect app functionality
- Will be addressed in future release

---

## 📝 Technical Details

### Files Modified

- `lib/src/core/database/app_db.dart` - Added migration V12→V13
- `lib/src/features/main/repository/feed_ingredient_repository.dart` - Fixed foreign keys
- `lib/src/features/add_ingredients/provider/ingredients_provider.dart` - Added copy feature
- `lib/src/features/store_ingredients/widget/ingredient_select_widget.dart` - Added copy UI
- `pubspec.yaml` - Version bump to 1.1.5+14

### Database Schema

```sql
-- Corrected foreign keys
CREATE TABLE feed_ingredients (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  feed_id INTEGER NOT NULL,
  ingredient_id INTEGER NOT NULL,
  quantity REAL NOT NULL,
  price_unit_kg REAL NOT NULL,
  FOREIGN KEY(feed_id) REFERENCES feeds(feed_id) 
    ON DELETE CASCADE,
  FOREIGN KEY(ingredient_id) REFERENCES ingredients(id) 
    ON DELETE CASCADE
);
```

---

## 🚀 What's Next

### Planned for Next Release

- Address localization for additional languages
- Update Java build configuration
- Additional custom ingredient features
- Performance optimizations

---

## 💬 Support

### If You Experience Issues

**Missing Feeds After Update?**

1. Restart the app completely
2. Wait 30 seconds for migration to complete
3. Check if feeds reappear
4. If still missing, contact support

**Other Issues?**

- Report bugs on GitHub: <https://github.com/ebena107/redesigned-feed-app/issues>
- Email: [support email]

---

## 🙏 Acknowledgments

Special thanks to all users who reported the feed data loss issue. Your feedback helped us identify and fix this critical problem quickly.

---

## 📊 Version History

- **v1.1.5+14** (Current) - Critical database fix + copy ingredient feature
- **v1.0.5+15** - Copy ingredient feature
- **v1.0.4+14** - Custom ingredient form fixes
- **v1.0.3+13** - Previous stable release

---

**For developers**: See [FEED_DATA_LOSS_ANALYSIS.md](doc/FEED_DATA_LOSS_ANALYSIS.md) for detailed technical analysis.

**Status**: ✅ **READY FOR RELEASE**
