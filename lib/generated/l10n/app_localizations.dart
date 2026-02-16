import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fil.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_sw.dart';
import 'app_localizations_tl.dart';
import 'app_localizations_yo.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fil'),
    Locale('fr'),
    Locale('pt'),
    Locale('sw'),
    Locale('tl'),
    Locale('yo')
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'Feed Estimator'**
  String get appTitle;

  /// Application description
  ///
  /// In en, this message translates to:
  /// **'Livestock feed formulation optimizer'**
  String get appDescription;

  /// Navigation label for home screen
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// Navigation label for feeds screen
  ///
  /// In en, this message translates to:
  /// **'My Feeds'**
  String get navFeeds;

  /// Navigation label for ingredients screen
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get navIngredients;

  /// Navigation label for settings screen
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// Navigation label for about screen
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get navAbout;

  /// Home screen title
  ///
  /// In en, this message translates to:
  /// **'Feed Formulation'**
  String get screenTitleHome;

  /// Ingredient library screen title
  ///
  /// In en, this message translates to:
  /// **'Ingredient Library'**
  String get screenTitleIngredientLibrary;

  /// New feed creation screen title
  ///
  /// In en, this message translates to:
  /// **'Create Feed'**
  String get screenTitleNewFeed;

  /// Reports/analysis screen title
  ///
  /// In en, this message translates to:
  /// **'Analysis'**
  String get screenTitleReports;

  /// Settings screen title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get screenTitleSettings;

  /// About screen title
  ///
  /// In en, this message translates to:
  /// **'About Feed Estimator'**
  String get screenTitleAbout;

  /// Import wizard screen title
  ///
  /// In en, this message translates to:
  /// **'Import Wizard'**
  String get screenTitleImportWizard;

  /// Action button to create new item
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get actionCreate;

  /// Action button to save
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// Action button to update
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get actionUpdate;

  /// Action button to delete
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// Action button to cancel
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// Action button to add
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get actionAdd;

  /// Action button to add new item
  ///
  /// In en, this message translates to:
  /// **'Add New'**
  String get actionAddNew;

  /// Action button to refresh
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get actionRefresh;

  /// Action button to edit
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get actionEdit;

  /// Action button to remove
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get actionRemove;

  /// Action button to retry
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get actionRetry;

  /// Action to view detailed report
  ///
  /// In en, this message translates to:
  /// **'View Report'**
  String get actionViewReport;

  /// Action button to clear filters or selection
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get actionClear;

  /// Action button to clear all active filters
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get actionClearFilters;

  /// Action button to save changes
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get actionSaveChanges;

  /// Action button to reset form
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get actionReset;

  /// Empty state title on home screen
  ///
  /// In en, this message translates to:
  /// **'No Feeds Yet'**
  String get homeEmptyTitle;

  /// Empty state subtitle on home screen
  ///
  /// In en, this message translates to:
  /// **'Create your first feed formulation'**
  String get homeEmptySubtitle;

  /// Button text to create first feed
  ///
  /// In en, this message translates to:
  /// **'Create Feed'**
  String get homeCreateFeed;

  /// FAB text to add a new feed
  ///
  /// In en, this message translates to:
  /// **'Add Feed'**
  String get homeAddFeed;

  /// Error message when feeds fail to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load feeds: {error}'**
  String homeLoadFailed(String error);

  /// Loading message on home screen
  ///
  /// In en, this message translates to:
  /// **'Loading feeds...'**
  String get homeLoadingFeeds;

  /// Empty state message in feed list
  ///
  /// In en, this message translates to:
  /// **'No Feed Available'**
  String get feedListEmpty;

  /// Error message when feed loading fails
  ///
  /// In en, this message translates to:
  /// **'Failed to load feeds'**
  String get feedsLoadFailed;

  /// Empty state title in feed grid
  ///
  /// In en, this message translates to:
  /// **'No feeds found'**
  String get feedsEmptyStateTitle;

  /// Fallback text for feeds with no name
  ///
  /// In en, this message translates to:
  /// **'Unknown Feed'**
  String get feedNameUnknown;

  /// Feed subtitle with animal type
  ///
  /// In en, this message translates to:
  /// **'{animalType} Feed'**
  String feedSubtitle(String animalType);

  /// Confirmation dialog title for feed deletion
  ///
  /// In en, this message translates to:
  /// **'Delete \"{feedName}\"?'**
  String feedDeleteTitle(String feedName);

  /// Warning message in deletion confirmation dialogs
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get confirmDeletionWarning;

  /// Title for stored feeds screen
  ///
  /// In en, this message translates to:
  /// **'Feed in Store'**
  String get feedStoreTitle;

  /// Placeholder text for stored feeds feature
  ///
  /// In en, this message translates to:
  /// **'Stored Feed here'**
  String get feedStorePlaceholder;

  /// Label shown when an ingredient is selected
  ///
  /// In en, this message translates to:
  /// **'Selected Ingredient'**
  String get ingredientSelectedLabel;

  /// Label prompting user to select ingredient
  ///
  /// In en, this message translates to:
  /// **'Select Ingredient'**
  String get ingredientSelectLabel;

  /// Title of ingredient selection sheet
  ///
  /// In en, this message translates to:
  /// **'Select Ingredient'**
  String get ingredientSelectTitle;

  /// Hint text in ingredient search field
  ///
  /// In en, this message translates to:
  /// **'Search by name...'**
  String get ingredientSearchHint;

  /// Fallback text for ingredients with no name
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get ingredientNameUnknown;

  /// Display text for available ingredient quantity
  ///
  /// In en, this message translates to:
  /// **'{qty} kg available'**
  String ingredientAvailableQty(String qty);

  /// Display text for ingredient price per kg
  ///
  /// In en, this message translates to:
  /// **'{price}/kg'**
  String ingredientPricePerKg(String price);

  /// Error message when ingredients fail to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load ingredients'**
  String get ingredientsLoadFailed;

  /// Empty state title when no ingredients exist
  ///
  /// In en, this message translates to:
  /// **'No ingredients found'**
  String get ingredientsEmptyTitle;

  /// Empty state subtitle when no ingredients exist
  ///
  /// In en, this message translates to:
  /// **'Add ingredients to get started'**
  String get ingredientsEmptySubtitle;

  /// Empty state title when filters return no results
  ///
  /// In en, this message translates to:
  /// **'No ingredients match your filters'**
  String get ingredientsEmptyFilteredTitle;

  /// Empty state subtitle when filters return no results
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search or filters'**
  String get ingredientsEmptyFilteredSubtitle;

  /// Message shown when cart is empty
  ///
  /// In en, this message translates to:
  /// **'No ingredients selected yet'**
  String get noIngredientsSelected;

  /// Title for cart/selected ingredients list
  ///
  /// In en, this message translates to:
  /// **'Selected Ingredients'**
  String get selectedIngredients;

  /// Filter chip label for favorites
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get filterFavorites;

  /// Filter chip label for custom ingredients
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get filterCustom;

  /// Filter chip label for regional filtering
  ///
  /// In en, this message translates to:
  /// **'Region: {region}'**
  String filterRegionLabel(String region);

  /// Symbol shown when name/value is unknown
  ///
  /// In en, this message translates to:
  /// **'?'**
  String get fallbackUnknownSymbol;

  /// Action button to close dialog or sheet
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get actionClose;

  /// Action button to export data
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get actionExport;

  /// Action button to import data
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get actionImport;

  /// Label for name field
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get labelName;

  /// Label for price field
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get labelPrice;

  /// Label for quantity field
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get labelQuantity;

  /// Label for category field
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get labelCategory;

  /// Label for region field
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get labelRegion;

  /// Label for protein nutrient
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get labelProtein;

  /// Label for fat nutrient
  ///
  /// In en, this message translates to:
  /// **'Fat'**
  String get labelFat;

  /// Label for fiber nutrient
  ///
  /// In en, this message translates to:
  /// **'Fiber'**
  String get labelFiber;

  /// Label for calcium nutrient
  ///
  /// In en, this message translates to:
  /// **'Calcium'**
  String get labelCalcium;

  /// Label for phosphorus nutrient
  ///
  /// In en, this message translates to:
  /// **'Phosphorus'**
  String get labelPhosphorus;

  /// Label for energy value
  ///
  /// In en, this message translates to:
  /// **'Energy'**
  String get labelEnergy;

  /// Label for cost value
  ///
  /// In en, this message translates to:
  /// **'Cost'**
  String get labelCost;

  /// Label for total value
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get labelTotal;

  /// Hint text for name input field
  ///
  /// In en, this message translates to:
  /// **'e.g., Broiler Starter'**
  String get hintEnterName;

  /// Hint text for price input field
  ///
  /// In en, this message translates to:
  /// **'10.50'**
  String get hintEnterPrice;

  /// Hint text for quantity input field
  ///
  /// In en, this message translates to:
  /// **'100'**
  String get hintEnterQuantity;

  /// Hint text for search field
  ///
  /// In en, this message translates to:
  /// **'Search ingredients...'**
  String get hintSearch;

  /// Hint text for ingredient selection
  ///
  /// In en, this message translates to:
  /// **'Tap to select ingredient'**
  String get hintSelectIngredient;

  /// Error message when a required field is empty
  ///
  /// In en, this message translates to:
  /// **'{field} is required'**
  String errorRequired(String field);

  /// Error message for invalid price format
  ///
  /// In en, this message translates to:
  /// **'Enter valid price (e.g., 10.50)'**
  String get errorInvalidPrice;

  /// Error message for invalid quantity format
  ///
  /// In en, this message translates to:
  /// **'Enter valid quantity (e.g., 100)'**
  String get errorInvalidQuantity;

  /// Error message for negative price
  ///
  /// In en, this message translates to:
  /// **'Price cannot be negative'**
  String get errorPriceNegative;

  /// Error message for zero quantity
  ///
  /// In en, this message translates to:
  /// **'Quantity must be greater than 0'**
  String get errorQuantityZero;

  /// Error message for name too short
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 3 characters'**
  String get errorNameTooShort;

  /// Error message for name too long
  ///
  /// In en, this message translates to:
  /// **'Name must be less than 50 characters'**
  String get errorNameTooLong;

  /// Error when trying to create a duplicate
  ///
  /// In en, this message translates to:
  /// **'{field} already exists'**
  String errorUnique(String field);

  /// Error message for database operation failure
  ///
  /// In en, this message translates to:
  /// **'Database operation failed. Please try again.'**
  String get errorDatabaseOperation;

  /// Error message for network errors
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection.'**
  String get errorNetworkError;

  /// Success message when an item is created
  ///
  /// In en, this message translates to:
  /// **'{item} created successfully'**
  String messageCreatedSuccessfully(String item);

  /// Success message when an item is updated
  ///
  /// In en, this message translates to:
  /// **'{item} updated successfully'**
  String messageUpdatedSuccessfully(String item);

  /// Success message when an item is deleted
  ///
  /// In en, this message translates to:
  /// **'{item} deleted successfully'**
  String messageDeletedSuccessfully(String item);

  /// Loading message
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get messageLoading;

  /// Message when no data is available
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get messageNoData;

  /// Message when a list is empty
  ///
  /// In en, this message translates to:
  /// **'No {item} added yet'**
  String messageEmpty(String item);

  /// Confirmation message before deletion
  ///
  /// In en, this message translates to:
  /// **'Delete {item}?'**
  String confirmDelete(String item);

  /// Description for delete confirmation
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get confirmDeleteDescription;

  /// Animal type: Pig
  ///
  /// In en, this message translates to:
  /// **'Pig'**
  String get animalTypePig;

  /// Animal type: Poultry
  ///
  /// In en, this message translates to:
  /// **'Poultry'**
  String get animalTypePoultry;

  /// Animal type: Rabbit
  ///
  /// In en, this message translates to:
  /// **'Rabbit'**
  String get animalTypeRabbit;

  /// Animal type: Ruminant
  ///
  /// In en, this message translates to:
  /// **'Ruminant'**
  String get animalTypeRuminant;

  /// Animal type: Fish
  ///
  /// In en, this message translates to:
  /// **'Fish'**
  String get animalTypeFish;

  /// Filter option: All regions
  ///
  /// In en, this message translates to:
  /// **'All Regions'**
  String get regionAll;

  /// Region: Africa
  ///
  /// In en, this message translates to:
  /// **'Africa'**
  String get regionAfrica;

  /// Region: Asia
  ///
  /// In en, this message translates to:
  /// **'Asia'**
  String get regionAsia;

  /// Region: Europe
  ///
  /// In en, this message translates to:
  /// **'Europe'**
  String get regionEurope;

  /// Region: Americas
  ///
  /// In en, this message translates to:
  /// **'Americas'**
  String get regionAmericas;

  /// Region: Oceania
  ///
  /// In en, this message translates to:
  /// **'Oceania'**
  String get regionOceania;

  /// Region: Global
  ///
  /// In en, this message translates to:
  /// **'Global'**
  String get regionGlobal;

  /// Filter label
  ///
  /// In en, this message translates to:
  /// **'Filter By'**
  String get filterBy;

  /// Sort label
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get sortBy;

  /// Sort option: By name
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get sortByName;

  /// Sort option: By price
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get sortByPrice;

  /// Sort option: By region
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get sortByRegion;

  /// Unit: Kilogram
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get unitKg;

  /// Unit: Gram
  ///
  /// In en, this message translates to:
  /// **'g'**
  String get unitG;

  /// Unit: Pound
  ///
  /// In en, this message translates to:
  /// **'lb'**
  String get unitLb;

  /// Unit: Ton
  ///
  /// In en, this message translates to:
  /// **'ton'**
  String get unitTon;

  /// Unit: Kilocalories per kilogram
  ///
  /// In en, this message translates to:
  /// **'kcal/kg'**
  String get unitKcal;

  /// Settings: Language option
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingLanguage;

  /// Settings: Theme option
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingTheme;

  /// Settings: Notifications option
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingNotifications;

  /// Settings: About option
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingAbout;

  /// About app version
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String aboutVersion(String version);

  /// About privacy policy link
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get aboutPrivacy;

  /// About terms of service link
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get aboutTerms;

  /// About developer credit
  ///
  /// In en, this message translates to:
  /// **'Developed for livestock farmers'**
  String get aboutDeveloper;

  /// About contribution message
  ///
  /// In en, this message translates to:
  /// **'Your feedback helps us improve'**
  String get aboutContribution;

  /// Settings screen title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Settings section: Language
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsSectionLanguage;

  /// Settings section: Privacy & Data
  ///
  /// In en, this message translates to:
  /// **'Privacy & Data'**
  String get settingsSectionPrivacy;

  /// Settings section: Data Management
  ///
  /// In en, this message translates to:
  /// **'Data Management'**
  String get settingsSectionDataManagement;

  /// Settings section: Legal
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get settingsSectionLegal;

  /// Language selector label
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get settingsSelectLanguage;

  /// Language option with limited framework support
  ///
  /// In en, this message translates to:
  /// **'{language} (Limited system UI)'**
  String settingsLanguageLimitedUI(String language);

  /// Data collection consent toggle
  ///
  /// In en, this message translates to:
  /// **'Data Collection Consent'**
  String get settingsDataConsent;

  /// Consent status: granted
  ///
  /// In en, this message translates to:
  /// **'You have consented to data collection'**
  String get settingsConsentGranted;

  /// Consent status: not granted
  ///
  /// In en, this message translates to:
  /// **'You have not consented'**
  String get settingsConsentNotGranted;

  /// Date when consent was granted
  ///
  /// In en, this message translates to:
  /// **'Consent Date'**
  String get settingsConsentDate;

  /// Privacy policy link
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settingsPrivacyPolicy;

  /// Privacy policy subtitle
  ///
  /// In en, this message translates to:
  /// **'View our privacy policy'**
  String get settingsPrivacyPolicySubtitle;

  /// Feed formulations count label
  ///
  /// In en, this message translates to:
  /// **'Feed Formulations'**
  String get settingsFeedFormulations;

  /// Custom ingredients count label
  ///
  /// In en, this message translates to:
  /// **'Custom Ingredients'**
  String get settingsCustomIngredients;

  /// Database size label
  ///
  /// In en, this message translates to:
  /// **'Database Size'**
  String get settingsDatabaseSize;

  /// Export data option
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get settingsExportData;

  /// Export data subtitle
  ///
  /// In en, this message translates to:
  /// **'Backup all your data'**
  String get settingsExportDataSubtitle;

  /// Import data option
  ///
  /// In en, this message translates to:
  /// **'Import Data'**
  String get settingsImportData;

  /// Import data subtitle
  ///
  /// In en, this message translates to:
  /// **'Restore from backup'**
  String get settingsImportDataSubtitle;

  /// Delete all data option
  ///
  /// In en, this message translates to:
  /// **'Delete All Data'**
  String get settingsDeleteData;

  /// Delete all data subtitle
  ///
  /// In en, this message translates to:
  /// **'Permanently delete everything'**
  String get settingsDeleteDataSubtitle;

  /// App version label
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsVersion;

  /// Rate app option
  ///
  /// In en, this message translates to:
  /// **'Rate the App'**
  String get settingsRateApp;

  /// Rate app subtitle
  ///
  /// In en, this message translates to:
  /// **'Share your feedback'**
  String get settingsRateAppSubtitle;

  /// Open source licenses option
  ///
  /// In en, this message translates to:
  /// **'Open Source Licenses'**
  String get settingsLicenses;

  /// Terms of service option
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get settingsTermsOfService;

  /// Terms of service coming soon
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get settingsTermsComingSoon;

  /// Data safety option
  ///
  /// In en, this message translates to:
  /// **'Data Safety'**
  String get settingsDataSafety;

  /// Data safety subtitle
  ///
  /// In en, this message translates to:
  /// **'Your data is stored locally'**
  String get settingsDataSafetySubtitle;

  /// Settings footer message
  ///
  /// In en, this message translates to:
  /// **'Made with ❤️ for livestock farmers'**
  String get settingsFooter;

  /// Loading message while exporting
  ///
  /// In en, this message translates to:
  /// **'Exporting data...'**
  String get settingsExporting;

  /// Export success dialog title
  ///
  /// In en, this message translates to:
  /// **'Export Successful'**
  String get settingsExportSuccess;

  /// Export success message
  ///
  /// In en, this message translates to:
  /// **'Your backup has been created successfully!'**
  String get settingsExportSuccessMessage;

  /// Revoke consent dialog title
  ///
  /// In en, this message translates to:
  /// **'Revoke Consent'**
  String get settingsRevokeConsentTitle;

  /// Revoke consent dialog message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to revoke your consent? This will not delete your data, but you acknowledge that you no longer consent to data collection.'**
  String get settingsRevokeConsentMessage;

  /// Language change success message
  ///
  /// In en, this message translates to:
  /// **'Language updated to {language}'**
  String settingsLanguageUpdated(String language);

  /// Title for ingredient library screen
  ///
  /// In en, this message translates to:
  /// **'Ingredient Library'**
  String get ingredientLibraryTitle;

  /// Section title for inventory management
  ///
  /// In en, this message translates to:
  /// **'MANAGE INVENTORY'**
  String get manageInventoryTitle;

  /// Section title for custom ingredients
  ///
  /// In en, this message translates to:
  /// **'Custom Ingredients'**
  String get customIngredientsTitle;

  /// Form title for updating ingredient details
  ///
  /// In en, this message translates to:
  /// **'Update Details'**
  String get updateDetailsTitle;

  /// Label when ingredient is marked as favorite
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get labelFavorite;

  /// Label to add ingredient to favorites
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get labelAddToFavorites;

  /// Label for price per kilogram input field
  ///
  /// In en, this message translates to:
  /// **'Price per kg'**
  String get labelPricePerKg;

  /// Label for available quantity input field
  ///
  /// In en, this message translates to:
  /// **'Available Qty (kg)'**
  String get labelAvailableQty;

  /// Button to view price history
  ///
  /// In en, this message translates to:
  /// **'Price History'**
  String get actionPriceHistory;

  /// Confirmation dialog title for deleting an ingredient
  ///
  /// In en, this message translates to:
  /// **'Delete Ingredient?'**
  String get deleteIngredientTitle;

  /// Confirmation dialog message for deleting an ingredient
  ///
  /// In en, this message translates to:
  /// **'This will permanently remove this ingredient from your library. This action cannot be undone.'**
  String get deleteIngredientMessage;

  /// Cancel button in confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get confirmCancel;

  /// Success message when ingredient is updated
  ///
  /// In en, this message translates to:
  /// **'Ingredient updated successfully'**
  String get successIngredientUpdated;

  /// Error message when saving fails
  ///
  /// In en, this message translates to:
  /// **'Failed to save: {error}'**
  String errorSaveFailed(String error);

  /// Success message when ingredient is deleted
  ///
  /// In en, this message translates to:
  /// **'Ingredient deleted'**
  String get successIngredientDeleted;

  /// Error message when deletion fails
  ///
  /// In en, this message translates to:
  /// **'Failed to delete: {error}'**
  String errorDeleteFailed(String error);

  /// Error message for price validation
  ///
  /// In en, this message translates to:
  /// **'Must be > 0'**
  String get errorPriceGreaterThanZero;

  /// Error message for quantity validation
  ///
  /// In en, this message translates to:
  /// **'Must be ≥ 0'**
  String get errorQuantityGreaterOrEqual;

  /// Title for adding a new feed
  ///
  /// In en, this message translates to:
  /// **'Add/Check Feed'**
  String get addFeedTitle;

  /// Title for updating an existing feed
  ///
  /// In en, this message translates to:
  /// **'Update Feed'**
  String get updateFeedTitle;

  /// Button to add ingredients to feed
  ///
  /// In en, this message translates to:
  /// **'Add Ingredients'**
  String get actionAddIngredients;

  /// Tooltip for add ingredients button
  ///
  /// In en, this message translates to:
  /// **'Add more ingredients to feed'**
  String get tooltipAddIngredients;

  /// Tooltip for save feed button
  ///
  /// In en, this message translates to:
  /// **'Save feed'**
  String get tooltipSaveFeed;

  /// Tooltip for update feed button
  ///
  /// In en, this message translates to:
  /// **'Update feed'**
  String get tooltipUpdateFeed;

  /// Analyse button label
  ///
  /// In en, this message translates to:
  /// **'Analyse'**
  String get actionAnalyse;

  /// Tooltip for analyse feed button
  ///
  /// In en, this message translates to:
  /// **'Analyse feed composition'**
  String get tooltipAnalyseFeed;

  /// Error title when feed name is missing
  ///
  /// In en, this message translates to:
  /// **'Feed Name Required'**
  String get errorFeedNameRequired;

  /// Error message prompting user to enter feed name
  ///
  /// In en, this message translates to:
  /// **'Please enter a name for your feed before saving.'**
  String get errorFeedNameMessage;

  /// Error title when feed name is missing for analysis
  ///
  /// In en, this message translates to:
  /// **'Missing Feed Name'**
  String get errorMissingFeedName;

  /// Error message when feed name missing for analysis
  ///
  /// In en, this message translates to:
  /// **'Please enter a feed name before analysing.'**
  String get errorMissingFeedNameMessage;

  /// Error title when no ingredients added to feed
  ///
  /// In en, this message translates to:
  /// **'No Ingredients'**
  String get errorNoIngredients;

  /// Error message when no ingredients in feed
  ///
  /// In en, this message translates to:
  /// **'Please add at least one ingredient to analyse.'**
  String get errorNoIngredientsMessage;

  /// Error title when ingredient quantities are invalid
  ///
  /// In en, this message translates to:
  /// **'Invalid Quantities'**
  String get errorInvalidQuantities;

  /// Error message for invalid ingredient quantities
  ///
  /// In en, this message translates to:
  /// **'All ingredients must have valid quantities greater than 0.'**
  String get errorInvalidQuantitiesMessage;

  /// Generic error title
  ///
  /// In en, this message translates to:
  /// **'An Error Occurred'**
  String get errorGenericTitle;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'Please try again.'**
  String get errorGenericMessage;

  /// OK button label
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get actionOk;

  /// Title for analyse feed confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Analyse Feed Composition'**
  String get analyseDialogTitle;

  /// Dialog message for analysing new (unsaved) feed
  ///
  /// In en, this message translates to:
  /// **'View detailed nutritional analysis for \"{feedName}\" without saving it.'**
  String analyseDialogMessageNew(String feedName);

  /// Dialog message for analysing existing feed
  ///
  /// In en, this message translates to:
  /// **'View detailed nutritional analysis for \"{feedName}\" without updating it.'**
  String analyseDialogMessageUpdate(String feedName);

  /// Note indicating this is a preview for unsaved feed
  ///
  /// In en, this message translates to:
  /// **'This is a preview. You can save later.'**
  String get analyseDialogPreviewNote;

  /// Note indicating changes won't be saved
  ///
  /// In en, this message translates to:
  /// **'Changes will not be saved.'**
  String get analyseDialogNoSaveNote;

  /// Error message when feed analysis fails
  ///
  /// In en, this message translates to:
  /// **'Failed to analyse feed. Please try again.'**
  String get analyseDialogFailedMessage;

  /// Report title for estimated/preview analysis
  ///
  /// In en, this message translates to:
  /// **'Estimated Analysis'**
  String get reportTitleEstimate;

  /// Report title for saved feed analysis
  ///
  /// In en, this message translates to:
  /// **'Analysis Report'**
  String get reportTitleAnalysis;

  /// Label for digestive energy (for fish)
  ///
  /// In en, this message translates to:
  /// **'Digestive Energy'**
  String get nutrientDigestiveEnergy;

  /// Label for metabolic energy
  ///
  /// In en, this message translates to:
  /// **'Metabolic Energy'**
  String get nutrientMetabolicEnergy;

  /// Label for crude protein
  ///
  /// In en, this message translates to:
  /// **'Crude Protein'**
  String get nutrientCrudeProtein;

  /// Label for crude fiber
  ///
  /// In en, this message translates to:
  /// **'Crude Fiber'**
  String get nutrientCrudeFiber;

  /// Label for crude fat
  ///
  /// In en, this message translates to:
  /// **'Crude Fat'**
  String get nutrientCrudeFat;

  /// Label for calcium
  ///
  /// In en, this message translates to:
  /// **'Calcium'**
  String get nutrientCalcium;

  /// Label for phosphorus
  ///
  /// In en, this message translates to:
  /// **'Phosphorus'**
  String get nutrientPhosphorus;

  /// Label for lysine amino acid
  ///
  /// In en, this message translates to:
  /// **'Lysine'**
  String get nutrientLysine;

  /// Label for methionine amino acid
  ///
  /// In en, this message translates to:
  /// **'Methionine'**
  String get nutrientMethionine;

  /// Label for ash content
  ///
  /// In en, this message translates to:
  /// **'Ash'**
  String get nutrientAsh;

  /// Label for moisture content
  ///
  /// In en, this message translates to:
  /// **'Moisture'**
  String get nutrientMoisture;

  /// Label for available phosphorus (abbreviated)
  ///
  /// In en, this message translates to:
  /// **'Avail. P'**
  String get nutrientAvailablePhosphorus;

  /// Label for total phosphorus (abbreviated)
  ///
  /// In en, this message translates to:
  /// **'Total P'**
  String get nutrientTotalPhosphorus;

  /// Label for phytate phosphorus (abbreviated)
  ///
  /// In en, this message translates to:
  /// **'Phytate P'**
  String get nutrientPhytatePhosphorus;

  /// Unit label for percentage
  ///
  /// In en, this message translates to:
  /// **'%'**
  String get unitPercent;

  /// Unit label for grams per kilogram
  ///
  /// In en, this message translates to:
  /// **'g/Kg'**
  String get unitGramPerKg;

  /// Title for amino acid profile card
  ///
  /// In en, this message translates to:
  /// **'Amino Acid Profile'**
  String get aminoAcidProfileTitle;

  /// Label for standardized ileal digestible amino acids
  ///
  /// In en, this message translates to:
  /// **'SID (Digestible)'**
  String get aminoAcidSidLabel;

  /// Label for total amino acids
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get aminoAcidTotalLabel;

  /// Button label for SID amino acids
  ///
  /// In en, this message translates to:
  /// **'SID'**
  String get aminoAcidSidButton;

  /// Button label for total amino acids
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get aminoAcidTotalButton;

  /// Table header for amino acid name
  ///
  /// In en, this message translates to:
  /// **'Amino Acid'**
  String get aminoAcidTableHeaderName;

  /// Table header for amino acid content percentage
  ///
  /// In en, this message translates to:
  /// **'Content (%)'**
  String get aminoAcidTableHeaderContent;

  /// Amino acid name: Lysine
  ///
  /// In en, this message translates to:
  /// **'Lysine'**
  String get aminoAcidLysine;

  /// Amino acid name: Methionine
  ///
  /// In en, this message translates to:
  /// **'Methionine'**
  String get aminoAcidMethionine;

  /// Amino acid name: Cystine
  ///
  /// In en, this message translates to:
  /// **'Cystine'**
  String get aminoAcidCystine;

  /// Amino acid name: Threonine
  ///
  /// In en, this message translates to:
  /// **'Threonine'**
  String get aminoAcidThreonine;

  /// Amino acid name: Tryptophan
  ///
  /// In en, this message translates to:
  /// **'Tryptophan'**
  String get aminoAcidTryptophan;

  /// Amino acid name: Arginine
  ///
  /// In en, this message translates to:
  /// **'Arginine'**
  String get aminoAcidArginine;

  /// Amino acid name: Isoleucine
  ///
  /// In en, this message translates to:
  /// **'Isoleucine'**
  String get aminoAcidIsoleucine;

  /// Amino acid name: Leucine
  ///
  /// In en, this message translates to:
  /// **'Leucine'**
  String get aminoAcidLeucine;

  /// Amino acid name: Valine
  ///
  /// In en, this message translates to:
  /// **'Valine'**
  String get aminoAcidValine;

  /// Amino acid name: Histidine
  ///
  /// In en, this message translates to:
  /// **'Histidine'**
  String get aminoAcidHistidine;

  /// Amino acid name: Phenylalanine
  ///
  /// In en, this message translates to:
  /// **'Phenylalanine'**
  String get aminoAcidPhenylalanine;

  /// Information text explaining SID amino acids
  ///
  /// In en, this message translates to:
  /// **'SID = Standardized Ileal Digestible (industry standard)'**
  String get aminoAcidSidInfo;

  /// Information text explaining total amino acids
  ///
  /// In en, this message translates to:
  /// **'Total amino acids (not all digestible)'**
  String get aminoAcidTotalInfo;

  /// Error message when amino acid data fails to load
  ///
  /// In en, this message translates to:
  /// **'Error loading amino acid data'**
  String get aminoAcidLoadError;

  /// Title for formulation warnings card
  ///
  /// In en, this message translates to:
  /// **'Warnings & Recommendations'**
  String get warningsCardTitle;

  /// Message showing number of issues found
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 issue found} other{{count} issues found}}'**
  String warningsCardIssueCount(int count);

  /// Title for PDF preview screen
  ///
  /// In en, this message translates to:
  /// **'Ebena Feed Estimator | {feedName} Print Preview'**
  String pdfPreviewTitle(String feedName);

  /// Form section header for basic ingredient information
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get formSectionBasicInfo;

  /// Form section header for energy values
  ///
  /// In en, this message translates to:
  /// **'Energy Values'**
  String get formSectionEnergyValues;

  /// Form section header for macronutrients
  ///
  /// In en, this message translates to:
  /// **'Macronutrients'**
  String get formSectionMacronutrients;

  /// Form section header for micronutrients
  ///
  /// In en, this message translates to:
  /// **'Micronutrients'**
  String get formSectionMicronutrients;

  /// Form section header for cost and availability
  ///
  /// In en, this message translates to:
  /// **'Cost & Availability'**
  String get formSectionCostAvailability;

  /// Form section header for additional information
  ///
  /// In en, this message translates to:
  /// **'Additional Information'**
  String get formSectionAdditionalInfo;

  /// Label for energy mode selector checkbox
  ///
  /// In en, this message translates to:
  /// **'Enter Energy Values for each specific group of animals?'**
  String get fieldHintEnergyMode;

  /// Label for adult pigs energy field
  ///
  /// In en, this message translates to:
  /// **'Adult Pigs'**
  String get fieldLabelAdultPigs;

  /// Label for growing pigs energy field
  ///
  /// In en, this message translates to:
  /// **'Growing Pigs'**
  String get fieldLabelGrowingPigs;

  /// Label for poultry energy field
  ///
  /// In en, this message translates to:
  /// **'Poultry'**
  String get fieldLabelPoultry;

  /// Label for rabbit energy field
  ///
  /// In en, this message translates to:
  /// **'Rabbit'**
  String get fieldLabelRabbit;

  /// Label for ruminant energy field
  ///
  /// In en, this message translates to:
  /// **'Ruminant'**
  String get fieldLabelRuminant;

  /// Label for fish/salmonids energy field
  ///
  /// In en, this message translates to:
  /// **'Fish'**
  String get fieldLabelFish;

  /// Label for creator name field
  ///
  /// In en, this message translates to:
  /// **'Created By'**
  String get fieldLabelCreatedBy;

  /// Label for notes field
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get fieldLabelNotes;

  /// Header title for custom ingredient creation
  ///
  /// In en, this message translates to:
  /// **'Creating Custom Ingredient'**
  String get customIngredientHeader;

  /// Description text for custom ingredient creation
  ///
  /// In en, this message translates to:
  /// **'You can add your own ingredient with custom nutritional values'**
  String get customIngredientDescription;

  /// Title for new ingredient form
  ///
  /// In en, this message translates to:
  /// **'New Ingredient'**
  String get newIngredientTitle;

  /// Label for feed name field
  ///
  /// In en, this message translates to:
  /// **'Feed Name'**
  String get fieldLabelFeedName;

  /// Label for animal type selection field
  ///
  /// In en, this message translates to:
  /// **'Animal Type'**
  String get fieldLabelAnimalType;

  /// Label for production stage field
  ///
  /// In en, this message translates to:
  /// **'Production Stage'**
  String get fieldLabelProductionStage;

  /// Success dialog title when ingredient is added
  ///
  /// In en, this message translates to:
  /// **'{name} Added Successfully'**
  String ingredientAddedSuccessTitle(String name);

  /// Success dialog message asking if user wants to continue
  ///
  /// In en, this message translates to:
  /// **'Would you like to add another ingredient?'**
  String get ingredientAddedSuccessMessage;

  /// Button to decline adding another ingredient
  ///
  /// In en, this message translates to:
  /// **'No, Go Back'**
  String get ingredientAddedNo;

  /// Button to continue adding ingredients
  ///
  /// In en, this message translates to:
  /// **'Yes, Continue'**
  String get ingredientAddedYes;

  /// Header showing count of custom ingredients
  ///
  /// In en, this message translates to:
  /// **'Your Custom Ingredients ({count})'**
  String customIngredientsHeader(int count);

  /// Search field hint for custom ingredients
  ///
  /// In en, this message translates to:
  /// **'Search your custom ingredients...'**
  String get customIngredientsSearchHint;

  /// Empty state title when no custom ingredients exist
  ///
  /// In en, this message translates to:
  /// **'No custom ingredients yet'**
  String get customIngredientsEmptyTitle;

  /// Empty state subtitle encouraging creation
  ///
  /// In en, this message translates to:
  /// **'Create your first custom ingredient!'**
  String get customIngredientsEmptySubtitle;

  /// Message when search returns no results
  ///
  /// In en, this message translates to:
  /// **'No ingredients match your search'**
  String get customIngredientsNoMatch;

  /// Label showing ingredient creator
  ///
  /// In en, this message translates to:
  /// **'by {creator}'**
  String labelCreatedBy(String creator);

  /// Label for notes section
  ///
  /// In en, this message translates to:
  /// **'Notes:'**
  String get labelNotes;

  /// Label for price history section
  ///
  /// In en, this message translates to:
  /// **'Price History'**
  String get labelPriceHistory;

  /// Short label for Calcium
  ///
  /// In en, this message translates to:
  /// **'Ca'**
  String get labelCa;

  /// Short label for Phosphorus
  ///
  /// In en, this message translates to:
  /// **'P'**
  String get labelP;

  /// Message when no price history exists
  ///
  /// In en, this message translates to:
  /// **'No price history available'**
  String get priceHistoryEmpty;

  /// Error message for price history loading failure
  ///
  /// In en, this message translates to:
  /// **'Error loading price history'**
  String get priceHistoryError;

  /// Confirmation dialog title for deleting custom ingredient
  ///
  /// In en, this message translates to:
  /// **'Delete Custom Ingredient?'**
  String get deleteCustomIngredientTitle;

  /// Confirmation message for deleting custom ingredient
  ///
  /// In en, this message translates to:
  /// **'Remove \"{name}\" from your custom ingredients?'**
  String deleteCustomIngredientMessage(String name);

  /// Success message after ingredient removal
  ///
  /// In en, this message translates to:
  /// **'{name} removed'**
  String ingredientRemovedSuccess(String name);

  /// Dialog title for export format selection
  ///
  /// In en, this message translates to:
  /// **'Export Format'**
  String get exportFormatTitle;

  /// Dialog message for export format selection
  ///
  /// In en, this message translates to:
  /// **'Choose export format for your custom ingredients:'**
  String get exportFormatMessage;

  /// Loading message while exporting to JSON
  ///
  /// In en, this message translates to:
  /// **'Exporting to JSON...'**
  String get exportingToJson;

  /// Loading message while exporting to CSV
  ///
  /// In en, this message translates to:
  /// **'Exporting to CSV...'**
  String get exportingToCsv;

  /// Error message when export fails
  ///
  /// In en, this message translates to:
  /// **'Export failed'**
  String get exportFailed;

  /// Error message with details when export fails
  ///
  /// In en, this message translates to:
  /// **'Export failed: {error}'**
  String exportFailedWithError(String error);

  /// Dialog title for importing custom ingredients
  ///
  /// In en, this message translates to:
  /// **'Import Custom Ingredients'**
  String get importCustomIngredientsTitle;

  /// Dialog message for import format selection
  ///
  /// In en, this message translates to:
  /// **'Choose the file format to import:'**
  String get importFormatMessage;

  /// Loading message while importing
  ///
  /// In en, this message translates to:
  /// **'Importing data...'**
  String get importingData;

  /// Success dialog title after import
  ///
  /// In en, this message translates to:
  /// **'Import Successful'**
  String get importSuccessTitle;

  /// Error dialog title after failed import
  ///
  /// In en, this message translates to:
  /// **'Import Failed'**
  String get importFailedTitle;

  /// Error message with details
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String importError(String error);

  /// JSON format option
  ///
  /// In en, this message translates to:
  /// **'JSON'**
  String get actionJson;

  /// CSV format option
  ///
  /// In en, this message translates to:
  /// **'CSV'**
  String get actionCsv;

  /// Generic label for ingredient
  ///
  /// In en, this message translates to:
  /// **'Ingredient'**
  String get labelIngredient;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'en',
        'es',
        'fil',
        'fr',
        'pt',
        'sw',
        'tl',
        'yo'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fil':
      return AppLocalizationsFil();
    case 'fr':
      return AppLocalizationsFr();
    case 'pt':
      return AppLocalizationsPt();
    case 'sw':
      return AppLocalizationsSw();
    case 'tl':
      return AppLocalizationsTl();
    case 'yo':
      return AppLocalizationsYo();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
