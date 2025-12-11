# Play Store Data Safety Questionnaire Responses

**App Name:** Feed Estimator  
**Package Name:** ng.com.ebena.feed.app  
**Date Completed:** December 11, 2025

---

## Section 1: Data Collection and Security

### Does your app collect or share any of the required user data types?

**Answer:** YES

**Explanation:** The app collects user-generated content (feed formulations and custom ingredients) but stores it locally on the device only.

---

## Section 2: Data Types

### Data types collected:

#### ✅ User Content
- **Feed Formulations**
  - Collection: YES
  - Sharing: NO
  - Purpose: App functionality
  - Optional/Required: Required for core functionality

- **Custom Ingredients**
  - Collection: YES
  - Sharing: NO
  - Purpose: App functionality
  - Optional/Required: Optional

#### ❌ Personal Information
- Name: NO
- Email: NO
- Phone: NO
- Address: NO

#### ❌ Financial Info
- Payment info: NO
- Purchase history: NO
- Credit score: NO

#### ❌ Health and Fitness
- Health info: NO
- Fitness info: NO

#### ❌ Location
- Approximate location: NO
- Precise location: NO

#### ❌ Contacts
- Contacts: NO

#### ❌ Photos and Videos
- Photos: NO (future feature may request permission)
- Videos: NO

#### ❌ Audio Files
- Voice/sound recordings: NO
- Music files: NO

#### ❌ Files and Docs
- Files and docs: NO

#### ❌ Calendar
- Calendar events: NO

#### ❌ App Activity
- App interactions: NO
- In-app search history: NO
- Installed apps: NO
- Other user-generated content: NO
- Other actions: NO

#### ❌ Web Browsing
- Web browsing history: NO

#### ❌ App Info and Performance
- Crash logs: NO
- Diagnostics: NO
- Other app performance data: NO

#### ❌ Device or Other IDs
- Device or other IDs: NO

---

## Section 3: Data Usage and Handling

### For each data type collected, specify:

#### User Content (Feed Formulations)

**Is this data collected?** YES

**Is this data shared with third parties?** NO

**Is this data processed ephemerally?** NO

**Is this data required or optional?** Required for app functionality

**Data usage purposes:**
- [x] App functionality
- [ ] Analytics
- [ ] Developer communications
- [ ] Advertising or marketing
- [ ] Fraud prevention, security, and compliance
- [ ] Personalization
- [ ] Account management

**Data handling:**
- [x] Data is encrypted in transit: NO (offline app, no transmission)
- [x] Users can request data deletion: YES
- [x] Data is encrypted at rest: NO (stored in plain SQLite)

---

#### User Content (Custom Ingredients)

**Is this data collected?** YES

**Is this data shared with third parties?** NO

**Is this data processed ephemerally?** NO

**Is this data required or optional?** Optional

**Data usage purposes:**
- [x] App functionality
- [ ] Analytics
- [ ] Developer communications
- [ ] Advertising or marketing
- [ ] Fraud prevention, security, and compliance
- [ ] Personalization
- [ ] Account management

**Data handling:**
- [x] Data is encrypted in transit: NO (offline app, no transmission)
- [x] Users can request data deletion: YES
- [x] Data is encrypted at rest: NO (stored in plain SQLite)

---

## Section 4: Security Practices

### Does your app follow security best practices?

**Data encryption in transit:**
- Status: NOT APPLICABLE
- Reason: App is offline-only, no data transmission

**Data encryption at rest:**
- Status: NO
- Reason: Data stored in unencrypted SQLite database
- Note: Data is protected by device-level security (screen lock, device encryption)

**Users can request data deletion:**
- Status: YES
- Method: In-app deletion via Settings → Privacy → Delete All Data
- Also: Uninstalling app removes all data

**Committed to follow Google Play Families Policy:**
- Status: NOT APPLICABLE
- Reason: App not designed for children

**Independent security review:**
- Status: NO
- Plan: May conduct security audit in future

---

## Section 5: Privacy Policy

**Privacy Policy URL:** https://yourdomain.com/privacy-policy

**Note:** Update this URL before submission with your actual hosted privacy policy.

---

## Section 6: Data Safety Section Preview

### How it will appear in Play Store:

**Data safety**

**No data shared with third parties**
Learn more about how developers declare sharing

**Data collected**
- User-generated content
  - Feed formulations and custom ingredients
  
**Security practices**
- Data isn't encrypted
- You can request that data be deleted

---

## Recommendations Before Submission

### Critical Actions:

1. **✅ Host Privacy Policy**
   - Upload PRIVACY_POLICY.md to your website
   - Ensure URL is accessible
   - Update URL in this form

2. **⚠️ Consider Encryption**
   - Implement SQLCipher for database encryption
   - Update data safety form to reflect encryption
   - Improves user trust

3. **✅ Test Data Deletion**
   - Verify "Delete All Data" functionality works
   - Test that data is actually removed
   - Confirm app works after deletion

4. **✅ Verify Offline Functionality**
   - Ensure app works without internet
   - Remove INTERNET permission if not needed
   - Or document why it's needed

---

## Submission Checklist

- [ ] Privacy policy hosted and accessible
- [ ] Privacy policy URL updated in form
- [ ] Data safety responses reviewed and accurate
- [ ] Data deletion functionality tested
- [ ] Screenshots prepared
- [ ] App description written
- [ ] Content rating completed
- [ ] Target audience declared
- [ ] Store listing graphics created

---

## Notes for Future Updates

If you add any of these features, update the Data Safety form:

- **Cloud Sync:** Would require declaring data sharing
- **Analytics:** Would require declaring app activity data
- **Crash Reporting:** Would require declaring diagnostics data
- **User Accounts:** Would require declaring personal info
- **In-App Purchases:** Would require declaring financial info
- **Photo Uploads:** Would require declaring photos/videos

---

## Contact for Questions

**Google Play Console Help:** https://support.google.com/googleplay/android-developer/answer/10787469

**Data Safety Form:** Play Console → App Content → Data Safety

---

**Form Completion Status:** ✅ READY FOR SUBMISSION

**Last Reviewed:** December 11, 2025
