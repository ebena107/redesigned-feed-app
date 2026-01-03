// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Feed Estimator';

  @override
  String get appDescription => 'Livestock feed formulation optimizer';

  @override
  String get navHome => 'Home';

  @override
  String get navFeeds => 'My Feeds';

  @override
  String get navIngredients => 'Ingredients';

  @override
  String get navSettings => 'Settings';

  @override
  String get navAbout => 'About';

  @override
  String get screenTitleHome => 'Feed Formulation';

  @override
  String get screenTitleIngredientLibrary => 'Ingredient Library';

  @override
  String get screenTitleNewFeed => 'Create Feed';

  @override
  String get screenTitleReports => 'Analysis';

  @override
  String get screenTitleSettings => 'Settings';

  @override
  String get screenTitleAbout => 'About Feed Estimator';

  @override
  String get actionCreate => 'Create';

  @override
  String get actionSave => 'Save';

  @override
  String get actionUpdate => 'Update';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionAdd => 'Add';

  @override
  String get actionAddNew => 'Add New';

  @override
  String get actionRefresh => 'Refresh';

  @override
  String get actionEdit => 'Edit';

  @override
  String get actionRemove => 'Remove';

  @override
  String get actionRetry => 'Retry';

  @override
  String get actionViewReport => 'View Report';

  @override
  String get actionClear => 'Clear';

  @override
  String get actionClearFilters => 'Clear Filters';

  @override
  String get actionSaveChanges => 'Save Changes';

  @override
  String get actionReset => 'Reset';

  @override
  String get homeEmptyTitle => 'No Feeds Yet';

  @override
  String get homeEmptySubtitle => 'Create your first feed formulation';

  @override
  String get homeCreateFeed => 'Create Feed';

  @override
  String get homeAddFeed => 'Add Feed';

  @override
  String homeLoadFailed(String error) {
    return 'Failed to load feeds: $error';
  }

  @override
  String get homeLoadingFeeds => 'Loading feeds...';

  @override
  String get feedListEmpty => 'No Feed Available';

  @override
  String get feedsLoadFailed => 'Failed to load feeds';

  @override
  String get feedsEmptyStateTitle => 'No feeds found';

  @override
  String get feedNameUnknown => 'Unknown Feed';

  @override
  String feedSubtitle(String animalType) {
    return '$animalType Feed';
  }

  @override
  String feedDeleteTitle(String feedName) {
    return 'Delete \"$feedName\"?';
  }

  @override
  String get confirmDeletionWarning => 'This action cannot be undone.';

  @override
  String get feedStoreTitle => 'Feed in Store';

  @override
  String get feedStorePlaceholder => 'Stored Feed here';

  @override
  String get ingredientSelectedLabel => 'Selected Ingredient';

  @override
  String get ingredientSelectLabel => 'Select Ingredient';

  @override
  String get ingredientSelectTitle => 'Select Ingredient';

  @override
  String get ingredientSearchHint => 'Search by name...';

  @override
  String get ingredientNameUnknown => 'Unknown';

  @override
  String ingredientAvailableQty(String qty) {
    return '$qty kg available';
  }

  @override
  String ingredientPricePerKg(String price) {
    return '$price/kg';
  }

  @override
  String get ingredientsLoadFailed => 'Failed to load ingredients';

  @override
  String get ingredientsEmptyTitle => 'No ingredients found';

  @override
  String get ingredientsEmptySubtitle => 'Add ingredients to get started';

  @override
  String get ingredientsEmptyFilteredTitle =>
      'No ingredients match your filters';

  @override
  String get ingredientsEmptyFilteredSubtitle =>
      'Try adjusting your search or filters';

  @override
  String get noIngredientsSelected => 'No ingredients selected yet';

  @override
  String get selectedIngredients => 'Selected Ingredients';

  @override
  String get filterFavorites => 'Favorites';

  @override
  String get filterCustom => 'Custom';

  @override
  String filterRegionLabel(String region) {
    return 'Region: $region';
  }

  @override
  String get fallbackUnknownSymbol => '?';

  @override
  String get actionClose => 'Close';

  @override
  String get actionExport => 'Export';

  @override
  String get actionImport => 'Import';

  @override
  String get labelName => 'Name';

  @override
  String get labelPrice => 'Price';

  @override
  String get labelQuantity => 'Quantity';

  @override
  String get labelCategory => 'Category';

  @override
  String get labelRegion => 'Region';

  @override
  String get labelProtein => 'Protein';

  @override
  String get labelFat => 'Fat';

  @override
  String get labelFiber => 'Fiber';

  @override
  String get labelCalcium => 'Calcium';

  @override
  String get labelPhosphorus => 'Phosphorus';

  @override
  String get labelEnergy => 'Energy';

  @override
  String get labelCost => 'Cost';

  @override
  String get labelTotal => 'Total';

  @override
  String get hintEnterName => 'e.g., Broiler Starter';

  @override
  String get hintEnterPrice => '10.50';

  @override
  String get hintEnterQuantity => '100';

  @override
  String get hintSearch => 'Search ingredients...';

  @override
  String get hintSelectIngredient => 'Tap to select ingredient';

  @override
  String errorRequired(String field) {
    return '$field is required';
  }

  @override
  String get errorInvalidPrice => 'Enter valid price (e.g., 10.50)';

  @override
  String get errorInvalidQuantity => 'Enter valid quantity (e.g., 100)';

  @override
  String get errorPriceNegative => 'Price cannot be negative';

  @override
  String get errorQuantityZero => 'Quantity must be greater than 0';

  @override
  String get errorNameTooShort => 'Name must be at least 3 characters';

  @override
  String get errorNameTooLong => 'Name must be less than 50 characters';

  @override
  String errorUnique(String field) {
    return '$field already exists';
  }

  @override
  String get errorDatabaseOperation =>
      'Database operation failed. Please try again.';

  @override
  String get errorNetworkError =>
      'Network error. Please check your connection.';

  @override
  String messageCreatedSuccessfully(String item) {
    return '$item created successfully';
  }

  @override
  String messageUpdatedSuccessfully(String item) {
    return '$item updated successfully';
  }

  @override
  String messageDeletedSuccessfully(String item) {
    return '$item deleted successfully';
  }

  @override
  String get messageLoading => 'Loading...';

  @override
  String get messageNoData => 'No data available';

  @override
  String messageEmpty(String item) {
    return 'No $item added yet';
  }

  @override
  String get confirmDelete => 'Delete';

  @override
  String get confirmDeleteDescription => 'This action cannot be undone.';

  @override
  String get animalTypePig => 'Pig';

  @override
  String get animalTypePoultry => 'Poultry';

  @override
  String get animalTypeRabbit => 'Rabbit';

  @override
  String get animalTypeRuminant => 'Ruminant';

  @override
  String get animalTypeFish => 'Fish';

  @override
  String get regionAll => 'All';

  @override
  String get regionAfrica => 'Africa';

  @override
  String get regionAsia => 'Asia';

  @override
  String get regionEurope => 'Europe';

  @override
  String get regionAmericas => 'Americas';

  @override
  String get regionOceania => 'Oceania';

  @override
  String get regionGlobal => 'Global';

  @override
  String get filterBy => 'Filter By';

  @override
  String get sortBy => 'Sort By';

  @override
  String get sortByName => 'Name';

  @override
  String get sortByPrice => 'Price';

  @override
  String get sortByRegion => 'Region';

  @override
  String get unitKg => 'kg';

  @override
  String get unitG => 'g';

  @override
  String get unitLb => 'lb';

  @override
  String get unitTon => 'ton';

  @override
  String get unitKcal => 'Kcal';

  @override
  String get settingLanguage => 'Language';

  @override
  String get settingTheme => 'Theme';

  @override
  String get settingNotifications => 'Notifications';

  @override
  String get settingAbout => 'About';

  @override
  String aboutVersion(String version) {
    return 'Version $version';
  }

  @override
  String get aboutPrivacy => 'Privacy Policy';

  @override
  String get aboutTerms => 'Terms of Service';

  @override
  String get aboutDeveloper => 'Developed for livestock farmers';

  @override
  String get aboutContribution => 'Your feedback helps us improve';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSectionLanguage => 'Language';

  @override
  String get settingsSectionPrivacy => 'Privacy & Data';

  @override
  String get settingsSectionDataManagement => 'Data Management';

  @override
  String get settingsSectionLegal => 'Legal';

  @override
  String get settingsSelectLanguage => 'Select Language';

  @override
  String settingsLanguageLimitedUI(String language) {
    return '$language (Limited system UI)';
  }

  @override
  String get settingsDataConsent => 'Data Collection Consent';

  @override
  String get settingsConsentGranted => 'You have consented to data collection';

  @override
  String get settingsConsentNotGranted => 'You have not consented';

  @override
  String get settingsConsentDate => 'Consent Date';

  @override
  String get settingsPrivacyPolicy => 'Privacy Policy';

  @override
  String get settingsPrivacyPolicySubtitle => 'View our privacy policy';

  @override
  String get settingsFeedFormulations => 'Feed Formulations';

  @override
  String get settingsCustomIngredients => 'Custom Ingredients';

  @override
  String get settingsDatabaseSize => 'Database Size';

  @override
  String get settingsExportData => 'Export Data';

  @override
  String get settingsExportDataSubtitle => 'Backup all your data';

  @override
  String get settingsImportData => 'Import Data';

  @override
  String get settingsImportDataSubtitle => 'Restore from backup';

  @override
  String get settingsDeleteData => 'Delete All Data';

  @override
  String get settingsDeleteDataSubtitle => 'Permanently delete everything';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsRateApp => 'Rate the App';

  @override
  String get settingsRateAppSubtitle => 'Share your feedback';

  @override
  String get settingsLicenses => 'Open Source Licenses';

  @override
  String get settingsTermsOfService => 'Terms of Service';

  @override
  String get settingsTermsComingSoon => 'Coming soon';

  @override
  String get settingsDataSafety => 'Data Safety';

  @override
  String get settingsDataSafetySubtitle => 'Your data is stored locally';

  @override
  String get settingsFooter => 'Made with ❤️ for livestock farmers';

  @override
  String get settingsExporting => 'Exporting data...';

  @override
  String get settingsExportSuccess => 'Export Successful';

  @override
  String get settingsExportSuccessMessage =>
      'Your backup has been created successfully!';

  @override
  String get settingsRevokeConsentTitle => 'Revoke Consent';

  @override
  String get settingsRevokeConsentMessage =>
      'Are you sure you want to revoke your consent? This will not delete your data, but you acknowledge that you no longer consent to data collection.';

  @override
  String settingsLanguageUpdated(String language) {
    return 'Language updated to $language';
  }

  @override
  String get ingredientLibraryTitle => 'Ingredient Library';

  @override
  String get manageInventoryTitle => 'MANAGE INVENTORY';

  @override
  String get customIngredientsTitle => 'Custom Ingredients';

  @override
  String get updateDetailsTitle => 'Update Details';

  @override
  String get labelFavorite => 'Favorite';

  @override
  String get labelAddToFavorites => 'Add to favorites';

  @override
  String get labelPricePerKg => 'Price per kg';

  @override
  String get labelAvailableQty => 'Available Qty (kg)';

  @override
  String get actionPriceHistory => 'Price History';

  @override
  String get deleteIngredientTitle => 'Delete Ingredient?';

  @override
  String get deleteIngredientMessage =>
      'This will permanently remove this ingredient from your library. This action cannot be undone.';

  @override
  String get confirmCancel => 'Cancel';

  @override
  String get successIngredientUpdated => 'Ingredient updated successfully';

  @override
  String errorSaveFailed(String error) {
    return 'Failed to save: $error';
  }

  @override
  String get successIngredientDeleted => 'Ingredient deleted';

  @override
  String errorDeleteFailed(String error) {
    return 'Failed to delete: $error';
  }

  @override
  String get errorPriceGreaterThanZero => 'Must be > 0';

  @override
  String get errorQuantityGreaterOrEqual => 'Must be ≥ 0';

  @override
  String get addFeedTitle => 'Add Feed';

  @override
  String get updateFeedTitle => 'Update Feed';

  @override
  String get actionAddIngredients => 'Add Ingredients';

  @override
  String get tooltipAddIngredients =>
      'Add ingredients to your feed formulation';

  @override
  String get tooltipSaveFeed => 'Save your feed formulation';

  @override
  String get tooltipUpdateFeed => 'Update your feed formulation';

  @override
  String get actionAnalyse => 'Analyse';

  @override
  String get tooltipAnalyseFeed =>
      'Analyze the nutritional composition of your feed';

  @override
  String get errorFeedNameRequired => 'Feed Name Required';

  @override
  String get errorFeedNameMessage =>
      'Please enter a name for your feed before saving.';

  @override
  String get errorMissingFeedName => 'Missing Feed Name';

  @override
  String get errorMissingFeedNameMessage =>
      'Please enter a feed name before analysing.';

  @override
  String get errorNoIngredients => 'No Ingredients';

  @override
  String get errorNoIngredientsMessage =>
      'Please add at least one ingredient to analyse.';

  @override
  String get errorInvalidQuantities => 'Invalid Quantities';

  @override
  String get errorInvalidQuantitiesMessage =>
      'All ingredients must have valid quantities greater than 0.';

  @override
  String get errorGenericTitle => 'An Error Occurred';

  @override
  String get errorGenericMessage => 'Please try again.';

  @override
  String get actionOk => 'OK';

  @override
  String get analyseDialogTitle => 'Analyse Feed Composition';

  @override
  String analyseDialogMessageNew(String feedName) {
    return 'View detailed nutritional analysis for \"$feedName\" without saving it.';
  }

  @override
  String analyseDialogMessageUpdate(String feedName) {
    return 'View detailed nutritional analysis for \"$feedName\" without updating it.';
  }

  @override
  String get analyseDialogPreviewNote =>
      'This is a preview. You can save later.';

  @override
  String get analyseDialogNoSaveNote => 'Changes will not be saved.';

  @override
  String get analyseDialogFailedMessage =>
      'Failed to analyse feed. Please try again.';

  @override
  String get reportTitleEstimate => 'Estimated Analysis';

  @override
  String get reportTitleAnalysis => 'Analysis Report';

  @override
  String get nutrientDigestiveEnergy => 'Digestive Energy';

  @override
  String get nutrientMetabolicEnergy => 'Metabolic Energy';

  @override
  String get nutrientCrudeProtein => 'Crude Protein';

  @override
  String get nutrientCrudeFiber => 'Crude Fiber';

  @override
  String get nutrientCrudeFat => 'Crude Fat';

  @override
  String get nutrientCalcium => 'Calcium';

  @override
  String get nutrientPhosphorus => 'Phosphorus';

  @override
  String get nutrientLysine => 'Lysine';

  @override
  String get nutrientMethionine => 'Methionine';

  @override
  String get nutrientAsh => 'Ash';

  @override
  String get nutrientMoisture => 'Moisture';

  @override
  String get nutrientAvailablePhosphorus => 'Avail. P';

  @override
  String get nutrientTotalPhosphorus => 'Total P';

  @override
  String get nutrientPhytatePhosphorus => 'Phytate P';

  @override
  String get unitPercent => '%';

  @override
  String get unitGramPerKg => 'g/Kg';

  @override
  String get aminoAcidProfileTitle => 'Amino Acid Profile';

  @override
  String get aminoAcidSidLabel => 'SID (Digestible)';

  @override
  String get aminoAcidTotalLabel => 'Total';

  @override
  String get aminoAcidSidButton => 'SID';

  @override
  String get aminoAcidTotalButton => 'Total';

  @override
  String get aminoAcidTableHeaderName => 'Amino Acid';

  @override
  String get aminoAcidTableHeaderContent => 'Content (%)';

  @override
  String get aminoAcidLysine => 'Lysine';

  @override
  String get aminoAcidMethionine => 'Methionine';

  @override
  String get aminoAcidCystine => 'Cystine';

  @override
  String get aminoAcidThreonine => 'Threonine';

  @override
  String get aminoAcidTryptophan => 'Tryptophan';

  @override
  String get aminoAcidArginine => 'Arginine';

  @override
  String get aminoAcidIsoleucine => 'Isoleucine';

  @override
  String get aminoAcidLeucine => 'Leucine';

  @override
  String get aminoAcidValine => 'Valine';

  @override
  String get aminoAcidHistidine => 'Histidine';

  @override
  String get aminoAcidPhenylalanine => 'Phenylalanine';

  @override
  String get aminoAcidSidInfo =>
      'SID = Standardized Ileal Digestible (industry standard)';

  @override
  String get aminoAcidTotalInfo => 'Total amino acids (not all digestible)';

  @override
  String get aminoAcidLoadError => 'Error loading amino acid data';

  @override
  String get warningsCardTitle => 'Warnings & Recommendations';

  @override
  String warningsCardIssueCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count issues found',
      one: '1 issue found',
    );
    return '$_temp0';
  }

  @override
  String pdfPreviewTitle(String feedName) {
    return 'Ebena Feed Estimator | $feedName Print Preview';
  }

  @override
  String get formSectionBasicInfo => 'Basic Information';

  @override
  String get formSectionEnergyValues => 'Energy Values';

  @override
  String get formSectionMacronutrients => 'Macronutrients';

  @override
  String get formSectionMicronutrients => 'Micronutrients';

  @override
  String get formSectionCostAvailability => 'Cost & Availability';

  @override
  String get formSectionAdditionalInfo => 'Additional Information';

  @override
  String get fieldHintEnergyMode =>
      'Enter Energy Values for each specific group of animals?';

  @override
  String get fieldLabelAdultPigs => 'Adult Pigs';

  @override
  String get fieldLabelGrowingPigs => 'Growing Pigs';

  @override
  String get fieldLabelPoultry => 'Poultry';

  @override
  String get fieldLabelRabbit => 'Rabbit';

  @override
  String get fieldLabelRuminant => 'Ruminant';

  @override
  String get fieldLabelFish => 'Fish';

  @override
  String get fieldLabelCreatedBy => 'Created By';

  @override
  String get fieldLabelNotes => 'Notes';

  @override
  String get customIngredientHeader => 'Creating Custom Ingredient';

  @override
  String get customIngredientDescription =>
      'You can add your own ingredient with custom nutritional values';

  @override
  String get newIngredientTitle => 'New Ingredient';

  @override
  String get fieldLabelFeedName => 'Feed Name';

  @override
  String get fieldLabelAnimalType => 'Animal Type';

  @override
  String get fieldLabelProductionStage => 'Production Stage';

  @override
  String ingredientAddedSuccessTitle(String name) {
    return '$name Added Successfully';
  }

  @override
  String get ingredientAddedSuccessMessage =>
      'Would you like to add another ingredient?';

  @override
  String get ingredientAddedNo => 'No, Go Back';

  @override
  String get ingredientAddedYes => 'Yes, Continue';

  @override
  String customIngredientsHeader(int count) {
    return 'Your Custom Ingredients ($count)';
  }

  @override
  String get customIngredientsSearchHint => 'Search your custom ingredients...';

  @override
  String get customIngredientsEmptyTitle => 'No custom ingredients yet';

  @override
  String get customIngredientsEmptySubtitle =>
      'Create your first custom ingredient!';

  @override
  String get customIngredientsNoMatch => 'No ingredients match your search';

  @override
  String labelCreatedBy(String creator) {
    return 'by $creator';
  }

  @override
  String get labelNotes => 'Notes:';

  @override
  String get labelPriceHistory => 'Price History';

  @override
  String get labelCa => 'Ca';

  @override
  String get labelP => 'P';

  @override
  String get priceHistoryEmpty => 'No price history available';

  @override
  String get priceHistoryError => 'Error loading price history';

  @override
  String get deleteCustomIngredientTitle => 'Delete Custom Ingredient?';

  @override
  String deleteCustomIngredientMessage(String name) {
    return 'Remove \"$name\" from your custom ingredients?';
  }

  @override
  String ingredientRemovedSuccess(String name) {
    return '$name removed';
  }

  @override
  String get exportFormatTitle => 'Export Format';

  @override
  String get exportFormatMessage =>
      'Choose export format for your custom ingredients:';

  @override
  String get exportingToJson => 'Exporting to JSON...';

  @override
  String get exportingToCsv => 'Exporting to CSV...';

  @override
  String get exportFailed => 'Export failed';

  @override
  String exportFailedWithError(String error) {
    return 'Export failed: $error';
  }

  @override
  String get importCustomIngredientsTitle => 'Import Custom Ingredients';

  @override
  String get importFormatMessage => 'Choose the file format to import:';

  @override
  String get importingData => 'Importing data...';

  @override
  String get importSuccessTitle => 'Import Successful';

  @override
  String get importFailedTitle => 'Import Failed';

  @override
  String importError(String error) {
    return 'Error: $error';
  }

  @override
  String get actionJson => 'JSON';

  @override
  String get actionCsv => 'CSV';

  @override
  String get labelIngredient => 'Ingredient';
}
