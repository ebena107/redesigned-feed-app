# Pre-Release Checklist - Version 1.1.5+14

**Date**: February 14, 2026  
**Release Version**: 1.1.5+14  
**Release Type**: Critical Bug Fix + Feature Release

---

## ✅ Code Quality

- [x] **Flutter analyze passes** - No issues found
- [x] **No critical TODOs** - All blockers resolved
- [x] **Code reviewed** - Database changes verified
- [x] **Git history clean** - All changes committed
- [ ] **Release APK built** - In progress
- [ ] **Release APK tested** - Pending build completion

---

## ✅ Database Migration

### Migration V12→V13 Verification

- [x] **Migration code written** - V12→V13 in app_db.dart
- [x] **Database version incremented** - Set to 13
- [x] **Data preservation verified** - All data copied
- [x] **Foreign keys corrected** - Proper table references
- [x] **Error handling added** - Try-catch with logging
- [ ] **Migration tested on real device** - Needs device testing
- [ ] **Rollback plan documented** - See recovery section below

### Critical Foreign Key Fixes

- [x] feed_id → References `feeds` table (was self-referencing)
- [x] ingredient_id → References `ingredients` table (was wrong table)
- [x] ON DELETE CASCADE implemented
- [x] Table imports updated

---

## ✅ Features

### Copy Ingredient Feature

- [x] **Backend logic** - copyFromIngredient() method added
- [x] **UI components** - Copy button added to ingredient list
- [x] **Navigation** - Routes to new ingredient form
- [x] **Data pre-fill** - All fields populated correctly
- [x] **User feedback** - Notes field shows source
- [ ] **Feature tested on device** - Needs testing
- [ ] **User documentation** - Added to release notes

---

## ✅ Testing

### Unit Tests

- [ ] Database migration tests
- [ ] Foreign key validation tests
- [ ] Copy ingredient logic tests

### Integration Tests

- [ ] Create feed → Add ingredients → Verify save
- [ ] Update existing feed → Verify load
- [ ] Delete feed → Verify cascade delete
- [ ] Copy ingredient → Modify → Save
- [ ] Migration V12→V13 on real database

### Device Testing

- [ ] Fresh install (no prior data)
- [ ] Upgrade from v1.0.4+14 (with existing data)
- [ ] Verify feeds present after migration
- [ ] Create new feed
- [ ] Edit existing feed
- [ ] Delete feed
- [ ] Copy ingredient
- [ ] Create custom ingredient

### Performance Tests

- [ ] Database query performance
- [ ] App launch time after migration
- [ ] Memory usage check
- [ ] No ANR (Application Not Responding)

---

## ✅ Documentation

- [x] **Release notes** - RELEASE_NOTES_v1.1.5+14.md created
- [x] **Technical analysis** - FEED_DATA_LOSS_ANALYSIS.md
- [x] **Pre-release checklist** - This document
- [ ] **User guide updated** - Needs copy feature docs
- [ ] **API documentation** - If applicable
- [ ] **Migration guide** - For developers

---

## ✅ Build & Deployment

### Build Artifacts

- [ ] **Debug APK** - build/app/outputs/flutter-apk/app-debug.apk
- [ ] **Release APK** - build/app/outputs/flutter-apk/app-release.apk (Building...)
- [ ] **App Bundle** - For Play Store (if needed)
- [ ] **Symbols file** - For crash reporting

### Build Verification

- [ ] APK size reasonable (<50MB recommended)
- [ ] ProGuard/R8 enabled
- [ ] Code obfuscation working
- [ ] No dev dependencies in release
- [ ] Proper signing configuration

### Version Numbers

- [x] pubspec.yaml: 1.1.5+14
- [x] Database version: 13
- [ ] Verify AndroidManifest version codes match
- [ ] Verify iOS version if applicable

---

## ✅ Security

- [x] **No hardcoded secrets** - Verified
- [x] **Foreign key enforcement** - PRAGMA ON
- [x] **Input validation** - In place
- [x] **SQL injection safe** - Parameterized queries used
- [ ] **Security audit** - Quick review needed

---

## ✅ Localization

### Translation Status

- ⚠️ 7 languages have untranslated messages (non-blocking):
  - es: 21 messages
  - fil: 57 messages  
  - fr: 21 messages
  - pt: 57 messages
  - sw: 55 messages
  - tl: 57 messages
  - yo: 57 messages

**Status**: Non-critical, app functional in all languages with English fallbacks

---

## ✅ Compatibility

### Platform Compatibility

- [x] Android API 21+ (Lollipop 5.0+)
- [ ] iOS (if applicable)
- [x] Windows Desktop
- [ ] Linux Desktop (if supported)

### Dependency Compatibility

- [x] Flutter SDK: >=3.5.0 <4.0.0
- [x] Dart SDK: >=3.5.0 <4.0.0
- [x] All packages compatible
- ⚠️ 58 packages have newer versions (non-blocking)

---

## ✅ User Communication

### Release Announcement

- [ ] **Blog post** - Draft prepared
- [ ] **Social media** - Posts scheduled
- [ ] **Email notification** - Template ready
- [ ] **In-app notification** - Update prompt configured

### User Support

- [ ] **FAQ updated** - Migration questions addressed
- [ ] **Support channels ready** - Team briefed
- [ ] **Known issues documented** - In release notes
- [ ] **Rollback procedure** - Documented below

---

## ✅ Rollback Plan

### If Critical Issues Found

**Immediate Actions:**

1. Remove APK from distribution channels
2. Notify users via in-app message
3. Revert to v1.0.4+14 in stores

**User Recovery:**

```
If users already updated and lost data:
1. Uninstall app
2. Install v1.0.4+14
3. Data should be intact (migration is one-way but preserves)
```

**Database Recovery:**

```dart
// Users can export data before updating
// Or we can provide recovery tool
```

---

## ✅ Monitoring

### Post-Release Monitoring

- [ ] **Crash reports** - Firebase/Sentry configured
- [ ] **Analytics** - Track migration success rate
- [ ] **User feedback** - Monitor app store reviews
- [ ] **GitHub issues** - Watch for bug reports
- [ ] **Performance metrics** - App load time, query times

### Success Metrics

- Migration success rate > 95%
- Zero critical bugs in first 48 hours
- No increase in crash rate
- Feeds accessible for all users
- Positive user feedback

---

## ✅ Final Checks

### Before Release

- [ ] All checkboxes above completed
- [ ] Team approval received
- [ ] Legal/compliance cleared (if required)
- [ ] App store listing updated
- [ ] Screenshots current
- [ ] Privacy policy up to date

### Release Day

- [ ] APK uploaded to distribution
- [ ] Release notes published
- [ ] Users notified
- [ ] Monitoring dashboard active
- [ ] Support team on standby

---

## 🚦 Release Status

**Current Status**: 🟡 **IN PROGRESS**

**Blockers**:

- Release APK build in progress
- Device testing pending

**Ready When**:

- [x] Code complete
- [x] Analyze passing
- [ ] Release APK built ⏳
- [ ] Device testing complete
- [ ] All checkboxes marked

**Estimated Ready**: After APK build completes (~10 minutes) + device testing (~30 minutes)

---

## 📞 Contacts

**Release Manager**: [Name]  
**QA Lead**: [Name]  
**Support Lead**: [Name]  
**Emergency Contact**: [Phone]

---

## 📝 Notes

### Open Issues

1. Java 8 obsolete warnings (non-critical, defer to next release)
2. Localization gaps (non-critical, schedule for v1.2.0)
3. Some package updates available (evaluate for next release)

### Lessons Learned

- Always verify foreign key references in database schema
- Migration testing critical for data integrity
- User communication about data safety important

---

**Last Updated**: February 14, 2026  
**Next Review**: After release APK build completion  
**Sign-off Required**: Technical Lead, QA Lead
