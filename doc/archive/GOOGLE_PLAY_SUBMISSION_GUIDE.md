# Google Play Store Submission Guide - Feed Estimator v1.0.0+12

**Quick Start**: Follow this guide to submit the app to Google Play Store.

---

## Step 1: Generate Signed Release APK

```bash
cd c:\dev\feed_estimator\redesigned-feed-app
flutter build apk --release
```

**Output**: `build/app/outputs/flutter-apk/app-release.apk` (~40-50 MB)

**Verification**:

```bash
# Check APK file exists and is properly signed
dir build\app\outputs\flutter-apk\app-release.apk
```

---

## Step 2: Create Google Play Developer Account

### Prerequisites

- Google Account
- $25 one-time developer fee
- Payment method (credit card)

### Steps

1. Go to [Google Play Console](https://play.google.com/console)
2. Click "Create app"
3. Fill in:
   - **App name**: Feed Estimator
   - **Default language**: English
   - **App type**: Application
   - **Category**: Productivity
   - **Audience**: Professional users, farmers

---

## Step 3: Prepare Store Listing Assets

### App Icons Required

**1. Icon (192×192 PNG)**

- Square, no rounded corners (system applies)
- Safe area: 66×66 centered (33 pixels from edge)
- File: `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png`

**2. Icon (512×512 PNG)**

- Same design as 192×192 (scaled up)
- Clear at small sizes
- Used for Google Play Store display

**Creation Instructions**:

```
If icons don't exist, create using:
- Flutter Icon Generator: https://pub.dev/packages/flutter_launcher_icons
- Or use: https://icon.kitchen/

Place in:
- android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png (192×192)
- android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png
- android/app/src/main/res/mipmap-xhdpi/ic_launcher.png
- etc.
```

### Feature Graphic (1024×500 PNG)

**Purpose**: Displayed on your store listing page

**Design**:

- Title: "Feed Estimator"
- Subtitle: "Professional Livestock Feed Formulation"
- Highlight: Main features (ingredients, calculations, data export)

**Create**:

```
Use design tool (Canva, Figma, Photoshop):
- Size: 1024×500 pixels
- Safe zone: 20 pixels from edges
- Format: PNG or JPG
- No transparency needed
```

### Screenshots (5-8 images, 1080×1920 PNG)

**Recommended Sequence**:

1. **Main Screen** (Feed list)
   - Show: 3-4 feeds with details
   - Caption: "Create and manage feed formulations"

2. **Add Feed Screen**
   - Show: Ingredient selection, nutrient summary
   - Caption: "Add ingredients and track nutrients"

3. **Nutritional Analysis**
   - Show: Complete nutrient breakdown
   - Caption: "Real-time nutritional analysis"

4. **Price Management**
   - Show: Price history chart
   - Caption: "Track ingredient costs over time"

5. **Ingredient Database**
   - Show: 209 ingredients with filters
   - Caption: "Access to 209 livestock feed ingredients"

6. **PDF Export**
   - Show: Generated report
   - Caption: "Export detailed analysis reports"

7. **Settings**
   - Show: Language options, privacy policy
   - Caption: "8-language support, privacy-first design"

8. **Features** (Optional)
   - Custom graphic listing key features
   - No screenshot needed

**How to Capture**:

```bash
# Use Android emulator or real device
flutter run -d emulator-5554

# Take screenshots using:
adb shell screencap -p /sdcard/screenshot.png
adb pull /sdcard/screenshot.png ./

# Or use device developer options > "Take Screenshot"

# Resize to 1080×1920 using ImageMagick:
convert screenshot.png -resize 1080x1920 1080x1920.png
```

---

## Step 4: Write Store Listing Text

### Short Description (80 characters max)

**Current**:

```
Professional livestock feed formulation and nutritional analysis
```

### Full Description (4000 characters max)

```
🌾 Feed Estimator - Professional Livestock Feed Formulation

Create optimal feed formulations for your livestock with accurate nutritional analysis. Whether you're raising poultry, pigs, cattle, rabbits, or fish, Feed Estimator helps you design cost-effective feed recipes.

✨ KEY FEATURES

📊 Comprehensive Nutritional Analysis
- Energy values (DE, ME, NE for all animal species)
- 10 essential amino acids (including SID digestibility)
- Complete mineral content (Ca, P with bioavailability)
- Proximate analysis (protein, fiber, fat, ash, moisture)
- Anti-nutritional factor warnings

🧪 Ingredient Database
- 209 livestock feed ingredients
- Industry standards (NRC 2012, CVB, INRA)
- Regional ingredient availability
- Custom ingredient creation
- Price history tracking

💡 Smart Formulation
- Real-time calculation updates
- Inclusion limit validation
- Safety warnings for high-risk ingredients
- Cost optimization suggestions
- Alternative ingredient recommendations

📁 Data Management
- Export formulations as PDF reports
- Bulk import ingredients (CSV)
- Database backup and restore
- Complete data portability

🌍 Multi-Language Support
- English, Spanish, Portuguese
- Filipino, French, Yoruba
- Swahili, Tagalog

🔒 Privacy First
- All data stored locally on your device
- No cloud sync or online accounts
- No ads, tracking, or analytics
- Full GDPR & CCPA compliant
- Works offline, anywhere

⚡ Perfect For
- Livestock farmers and ranchers
- Feed mill operators
- Veterinary professionals
- Agricultural students
- Animal nutritionists

🎯 Why Choose Feed Estimator?

Unlike other feed formulation apps, Feed Estimator prioritizes:

1. **Accuracy** - Based on NRC 2012 standards
2. **Affordability** - Free app, no subscriptions
3. **Privacy** - Your data stays on your device
4. **Accessibility** - Works offline, 8 languages
5. **Practicality** - Optimized for farmers in developing regions

Get started today and create your first feed formulation in minutes!

⚙️ TECHNICAL DETAILS

- Android 5.0+
- 50 MB download size
- Offline functionality
- No internet required
- Automatic backups

📧 SUPPORT

Questions? Email: [support email]
Privacy Policy: https://github.com/ebena-ng/feed-estimator/blob/main/PRIVACY_POLICY.md

Version 1.0.0+12 - December 2025
```

### Promotional Text (80 characters max)

```
Design cost-effective livestock feed with professional analysis
```

---

## Step 5: Content Rating & Classification

### Content Rating Questionnaire

In Google Play Console:

1. Go to **Policies > App content**
2. Answer content rating questionnaire:

**Typical Answers for Feed Estimator**:

- Violence: None
- Sexual content: None
- Profanity: None
- Alcohol/tobacco: None
- Gambling: None
- Medical info: No (informational only, not medical advice)
- Malware: No
- Cheating tools: No
- High APK: No

**Result**: General Audience / Everyone

---

## Step 6: Upload to Google Play Console

### Setup in Console

1. **Store Listing Tab**:
   - [ ] Add app icon (192×192 PNG)
   - [ ] Upload feature graphic (1024×500 PNG)
   - [ ] Add 5-8 screenshots (1080×1920 PNG)
   - [ ] Enter short description (80 chars)
   - [ ] Enter full description (4000 chars)
   - [ ] Select category: **Productivity**

2. **Content Rating Tab**:
   - [ ] Complete questionnaire
   - [ ] Submit for rating (auto-assigned)

3. **Pricing & Distribution**:
   - [ ] Free app (selected by default)
   - [ ] Countries: All or select [Nigeria, USA, UK, India, etc.]

4. **App Signing**:
   - Google Play manages signing (recommended)
   - Upload signed APK for review

### Upload APK

1. Go to **Releases > Production**
2. Click **Create new release**
3. Upload: `build/app/outputs/flutter-apk/app-release.apk`
4. Add Release Notes:

   ```
   v1.0.0+12 - December 2025

   Initial Release Features:
   • 209 livestock feed ingredients
   • NRC 2012 standard calculations
   • Price tracking system
   • 8-language support
   • PDF export and CSV import
   • Offline-first, privacy-focused

   Release notes: https://github.com/ebena-ng/feed-estimator/blob/main/RELEASE_NOTES_v1.0.0+12.md
   ```

5. Click **Save**

---

## Step 7: Review & Submit

### Final Checklist

- [ ] Store listing complete (title, description, images)
- [ ] Content rating submitted
- [ ] Privacy policy URL entered
- [ ] Support email entered
- [ ] APK uploaded and verified
- [ ] Release notes written
- [ ] Pricing set to Free
- [ ] Countries selected

### Submit for Review

1. Click **Review release**
2. Verify all details correct
3. Click **Start rollout to Production**
4. Select: **Full rollout** or **Gradual rollout** (5-10% initially)
5. Confirm submission

**Status**: App now in review queue

---

## Step 8: Monitor Review Progress

### Timeline

- **2-48 hours**: Initial automated checks
- **24-48 hours**: Manual review by Google
- **Next step**: Either approval or policy violation notice

### If Approved

1. App appears on Google Play Store
2. Links:
   - <https://play.google.com/store/apps/details?id=ng.com.ebena.feed.app>
3. Monitor:
   - Downloads
   - User reviews
   - Crash reports
   - Install statistics

### If Rejected

1. Check notification email
2. Common issues:
   - Misleading description
   - Missing privacy policy
   - Policy violation
3. Fix issues and resubmit

---

## Step 9: Post-Launch

### Day 1-7: Monitor

- [ ] Check crash reports daily
- [ ] Respond to user reviews
- [ ] Monitor app ratings
- [ ] Fix any reported bugs immediately

### Week 2: Update Marketing

- [ ] Share announcement (social media, email)
- [ ] Request early reviews from beta users
- [ ] Monitor competitor apps
- [ ] Plan v1.0.1 bug fixes

### Month 1: Analyze

- [ ] 100+ downloads target
- [ ] 4.5+ star rating
- [ ] Zero crash reports
- [ ] User feedback collection

---

## Important Reminders

⚠️ **Before Submitting**:

1. ✅ Test on real Android 11+ device
2. ✅ Verify all features work offline
3. ✅ Check all localization strings
4. ✅ Ensure privacy policy is accessible
5. ✅ Test PDF export functionality
6. ✅ Verify database backup/restore

⚠️ **After Approval**:

1. 📱 Release on both Google Play and GitHub Releases
2. 📢 Announce to target users
3. 📊 Monitor crash logs in Google Play Console
4. 🐛 Fix critical bugs within 24 hours
5. ⭐ Encourage user reviews

---

## Troubleshooting

### APK Won't Upload

```
Error: "Signature/version issue"
Solution: 
1. Delete key.properties
2. Create new signing key: keytool -genkey -v ...
3. Rebuild APK: flutter build apk --release
```

### App Rejected

```
Common reasons:
- Privacy policy not accessible
- Misleading description
- Crashes on first launch
- Missing permissions explanation

Solution: Review rejection reason, fix, resubmit
```

### Low Downloads

```
Suggestions:
- Improve app description (use keywords: feed, nutrition, animals)
- Add better screenshots (show actual app, not mockups)
- Respond to all reviews
- Monitor competitor ratings
```

---

## Quick Command Reference

```bash
# Generate signed APK
flutter build apk --release

# Verify APK signature
jarsigner -verify -certs -verbose build/app/outputs/flutter-apk/app-release.apk

# Check APK size
dir build\app\outputs\flutter-apk\app-release.apk

# Upload to Play Console (manual via web interface)
# Or use Google Play API (advanced)
```

---

## Support & Resources

- **Google Play Developer Help**: <https://support.google.com/googleplay/android-developer>
- **Submission Checklist**: <https://play.google.com/console/developers>
- **Flutter Deployment**: <https://docs.flutter.dev/deployment/android>
- **App Store Policies**: <https://play.google.com/about/developer-content-policy/>

---

**Status**: Ready to Submit ✅

*Follow this guide step-by-step for successful Google Play Store submission.*
