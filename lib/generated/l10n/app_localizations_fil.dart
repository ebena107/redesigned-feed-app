// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Filipino Pilipino (`fil`).
class AppLocalizationsFil extends AppLocalizations {
  AppLocalizationsFil([String locale = 'fil']) : super(locale);

  @override
  String get appTitle => 'Feed Estimator';

  @override
  String get appDescription => 'Optimizer ng pagmula ng pagkain ng hayop';

  @override
  String get navHome => 'Tahanan';

  @override
  String get navFeeds => 'Aking mga Pagkain';

  @override
  String get navIngredients => 'Sangkap';

  @override
  String get navSettings => 'Mga Setting';

  @override
  String get navAbout => 'Tungkol';

  @override
  String get screenTitleHome => 'Pagbuo ng Pagkain';

  @override
  String get screenTitleIngredientLibrary => 'Libro ng Sangkap';

  @override
  String get screenTitleNewFeed => 'Lumikha ng Pagkain';

  @override
  String get screenTitleReports => 'Pagsusuri';

  @override
  String get screenTitleSettings => 'Mga Setting';

  @override
  String get screenTitleAbout => 'Tungkol sa Feed Estimator';

  @override
  String get actionCreate => 'Lumikha';

  @override
  String get actionSave => 'I-save';

  @override
  String get actionUpdate => 'I-update';

  @override
  String get actionDelete => 'Tanggalin';

  @override
  String get actionCancel => 'Kanselahin';

  @override
  String get actionAdd => 'Magdagdag';

  @override
  String get actionAddNew => 'Magdagdag ng Bago';

  @override
  String get actionRefresh => 'I-refresh';

  @override
  String get actionEdit => 'I-edit';

  @override
  String get actionRemove => 'Alisin';

  @override
  String get actionRetry => 'Subukan Muli';

  @override
  String get actionViewReport => 'Tingnan ang Ulat';

  @override
  String get actionClear => 'I-clear';

  @override
  String get actionClearFilters => 'I-clear ang mga Filter';

  @override
  String get actionSaveChanges => 'Salbahin ang Pagbabago';

  @override
  String get actionReset => 'I-reset';

  @override
  String get homeEmptyTitle => 'Walang Feed Pa';

  @override
  String get homeEmptySubtitle => 'Lumikha ng iyong unang formulasyon ng feed';

  @override
  String get homeCreateFeed => 'Lumikha ng Feed';

  @override
  String get homeAddFeed => 'Magdagdag ng Feed';

  @override
  String homeLoadFailed(String error) {
    return 'Hindi na-load ang mga feed: $error';
  }

  @override
  String get homeLoadingFeeds => 'Nilo-load ang mga feed...';

  @override
  String get feedListEmpty => 'Walang Available na Feed';

  @override
  String get feedsLoadFailed => 'Hindi na-load ang mga feed';

  @override
  String get feedsEmptyStateTitle => 'Walang nahanap na feed';

  @override
  String get feedNameUnknown => 'Hindi Kilalang Feed';

  @override
  String feedSubtitle(String animalType) {
    return 'Feed para sa $animalType';
  }

  @override
  String feedDeleteTitle(String feedName) {
    return 'Tanggalin ang \"$feedName\"?';
  }

  @override
  String get confirmDeletionWarning => 'Hindi na mababawi ang aksyong ito.';

  @override
  String get feedStoreTitle => 'Feed sa Bodega';

  @override
  String get feedStorePlaceholder => 'Nakaimbak na feed dito';

  @override
  String get ingredientSelectedLabel => 'Napiling Sangkap';

  @override
  String get ingredientSelectLabel => 'Pumili ng Sangkap';

  @override
  String get ingredientSelectTitle => 'Pumili ng Sangkap';

  @override
  String get ingredientSearchHint => 'Maghanap gamit ang pangalan...';

  @override
  String get ingredientNameUnknown => 'Hindi Kilala';

  @override
  String ingredientAvailableQty(String qty) {
    return '$qty kg available';
  }

  @override
  String ingredientPricePerKg(String price) {
    return '$price/kg';
  }

  @override
  String get ingredientsLoadFailed => 'Hindi na-load ang mga sangkap';

  @override
  String get ingredientsEmptyTitle => 'Walang nahanap na sangkap';

  @override
  String get ingredientsEmptySubtitle =>
      'Magdagdag ng mga sangkap para magsimula';

  @override
  String get ingredientsEmptyFilteredTitle =>
      'Walang sangkap na tumutugma sa iyong mga filter';

  @override
  String get ingredientsEmptyFilteredSubtitle =>
      'Subukang i-adjust ang iyong paghahanap o mga filter';

  @override
  String get filterFavorites => 'Mga Paborito';

  @override
  String get filterCustom => 'Custom';

  @override
  String filterRegionLabel(String region) {
    return 'Rehiyon: $region';
  }

  @override
  String get fallbackUnknownSymbol => '?';

  @override
  String get actionClose => 'Isara';

  @override
  String get actionExport => 'I-export';

  @override
  String get actionImport => 'I-import';

  @override
  String get labelName => 'Pangalan';

  @override
  String get labelPrice => 'Presyo';

  @override
  String get labelQuantity => 'Dami';

  @override
  String get labelCategory => 'Kategorya';

  @override
  String get labelRegion => 'Rehiyon';

  @override
  String get labelProtein => 'Protina';

  @override
  String get labelFat => 'Taba';

  @override
  String get labelFiber => 'Bituin';

  @override
  String get labelCalcium => 'Kalyo';

  @override
  String get labelPhosphorus => 'Fosforo';

  @override
  String get labelEnergy => 'Enerhiya';

  @override
  String get labelCost => 'Gastos';

  @override
  String get labelTotal => 'Kabuuan';

  @override
  String get hintEnterName => 'halimbawa, Pagkain ng Broiler Starter';

  @override
  String get hintEnterPrice => '10.50';

  @override
  String get hintEnterQuantity => '100';

  @override
  String get hintSearch => 'Maghanap ng sangkap...';

  @override
  String get hintSelectIngredient => 'Tapikin upang piliin ang sangkap';

  @override
  String errorRequired(String field) {
    return 'Kailangan ang $field';
  }

  @override
  String get errorInvalidPrice =>
      'Magpasok ng wastong presyo (halimbawa, 10.50)';

  @override
  String get errorInvalidQuantity =>
      'Magpasok ng wastong dami (halimbawa, 100)';

  @override
  String get errorPriceNegative =>
      'Ang presyo ay hindi maaaring maging negatibo';

  @override
  String get errorQuantityZero => 'Ang dami ay dapat na higit sa 0';

  @override
  String get errorNameTooShort =>
      'Ang pangalan ay dapat na hindi bababa sa 3 na character';

  @override
  String get errorNameTooLong =>
      'Ang pangalan ay dapat na mas mababa sa 50 na character';

  @override
  String errorUnique(String field) {
    return 'Ang $field ay nag-exist na';
  }

  @override
  String get errorDatabaseOperation =>
      'Nabigo ang database na operasyon. Subukan ulit.';

  @override
  String get errorNetworkError =>
      'Kamalian sa network. Mangyaring suriin ang iyong koneksyon.';

  @override
  String messageCreatedSuccessfully(String item) {
    return 'Matagumpay na nilikha ang $item';
  }

  @override
  String messageUpdatedSuccessfully(String item) {
    return 'Matagumpay na na-update ang $item';
  }

  @override
  String messageDeletedSuccessfully(String item) {
    return 'Matagumpay na natanggal ang $item';
  }

  @override
  String get messageLoading => 'Naglo-load...';

  @override
  String get messageNoData => 'Walang available na data';

  @override
  String messageEmpty(String item) {
    return 'Walang $item na naidagdag pa';
  }

  @override
  String get confirmDelete => 'Tanggalin';

  @override
  String get confirmDeleteDescription =>
      'Ang aksyon na ito ay hindi maaaring bawiin.';

  @override
  String get animalTypePig => 'Baboy';

  @override
  String get animalTypePoultry => 'Manok';

  @override
  String get animalTypeRabbit => 'Kuneho';

  @override
  String get animalTypeRuminant => 'Umiing Hayop';

  @override
  String get animalTypeFish => 'Isda';

  @override
  String get regionAll => 'Lahat';

  @override
  String get regionAfrica => 'Africa';

  @override
  String get regionAsia => 'Asya';

  @override
  String get regionEurope => 'Europe';

  @override
  String get regionAmericas => 'Amerika';

  @override
  String get regionOceania => 'Oceania';

  @override
  String get regionGlobal => 'Pandaigdig';

  @override
  String get filterBy => 'I-filter Ayon sa';

  @override
  String get sortBy => 'Pagsort-in Ayon sa';

  @override
  String get sortByName => 'Pangalan';

  @override
  String get sortByPrice => 'Presyo';

  @override
  String get sortByRegion => 'Rehiyon';

  @override
  String get unitKg => 'kg';

  @override
  String get unitG => 'g';

  @override
  String get unitLb => 'lb';

  @override
  String get unitTon => 'tonelada';

  @override
  String get unitKcal => 'Kcal';

  @override
  String get settingLanguage => 'Wika';

  @override
  String get settingTheme => 'Tema';

  @override
  String get settingNotifications => 'Mga Notipikasyon';

  @override
  String get settingAbout => 'Tungkol';

  @override
  String aboutVersion(String version) {
    return 'Bersyon $version';
  }

  @override
  String get aboutPrivacy => 'Privacy Policy';

  @override
  String get aboutTerms => 'Mga Kaugnayan sa Serbisyo';

  @override
  String get aboutDeveloper => 'Ginawa para sa mga magsasaka ng hayop';

  @override
  String get aboutContribution =>
      'Ang iyong feedback ay tumutulong sa amin na mapabuti';

  @override
  String get settingsTitle => 'Mga Setting';

  @override
  String get settingsSectionLanguage => 'Wika';

  @override
  String get settingsSectionPrivacy => 'Privacy at Data';

  @override
  String get settingsSectionDataManagement => 'Pamamahala ng Data';

  @override
  String get settingsSectionLegal => 'Legal';

  @override
  String get settingsSelectLanguage => 'Pumili ng Wika';

  @override
  String settingsLanguageLimitedUI(String language) {
    return '$language (Limitadong system UI)';
  }

  @override
  String get settingsDataConsent => 'Pahintulot sa Pagkolekta ng Data';

  @override
  String get settingsConsentGranted => 'Pumayag ka na sa pagkolekta ng data';

  @override
  String get settingsConsentNotGranted => 'Hindi ka pumayag';

  @override
  String get settingsConsentDate => 'Petsa ng Pahintulot';

  @override
  String get settingsPrivacyPolicy => 'Privacy Policy';

  @override
  String get settingsPrivacyPolicySubtitle =>
      'Tingnan ang aming privacy policy';

  @override
  String get settingsFeedFormulations => 'Mga Formulation ng Feed';

  @override
  String get settingsCustomIngredients => 'Mga Custom na Sangkap';

  @override
  String get settingsDatabaseSize => 'Laki ng Database';

  @override
  String get settingsExportData => 'I-export ang Data';

  @override
  String get settingsExportDataSubtitle => 'I-backup ang lahat ng iyong data';

  @override
  String get settingsImportData => 'I-import ang Data';

  @override
  String get settingsImportDataSubtitle => 'Ibalik mula sa backup';

  @override
  String get settingsDeleteData => 'Tanggalin ang Lahat ng Data';

  @override
  String get settingsDeleteDataSubtitle => 'Permanenteng tanggalin ang lahat';

  @override
  String get settingsVersion => 'Bersyon';

  @override
  String get settingsRateApp => 'I-rate ang App';

  @override
  String get settingsRateAppSubtitle => 'Ibahagi ang iyong feedback';

  @override
  String get settingsLicenses => 'Mga Open Source License';

  @override
  String get settingsTermsOfService => 'Mga Kaugnayan sa Serbisyo';

  @override
  String get settingsTermsComingSoon => 'Paparating na';

  @override
  String get settingsDataSafety => 'Kaligtasan ng Data';

  @override
  String get settingsDataSafetySubtitle =>
      'Ang iyong data ay naka-imbak sa lokal';

  @override
  String get settingsFooter =>
      'Ginawa nang may ❤️ para sa mga magsasaka ng hayop';

  @override
  String get settingsExporting => 'Nag-e-export ng data...';

  @override
  String get settingsExportSuccess => 'Matagumpay ang Export';

  @override
  String get settingsExportSuccessMessage =>
      'Matagumpay na nalikha ang iyong backup!';

  @override
  String get settingsRevokeConsentTitle => 'Bawiin ang Pahintulot';

  @override
  String get settingsRevokeConsentMessage =>
      'Sigurado ka bang gusto mong bawiin ang iyong pahintulot? Hindi nito tatanggalin ang iyong data, ngunit kinikilala mo na hindi ka na pumapayag sa pagkolekta ng data.';

  @override
  String settingsLanguageUpdated(String language) {
    return 'Na-update ang wika sa $language';
  }

  @override
  String get ingredientLibraryTitle => 'Aklatan ng Sangkap';

  @override
  String get manageInventoryTitle => 'PAMAHALAAN ANG INVENTORY';

  @override
  String get customIngredientsTitle => 'Customized na Sangkap';

  @override
  String get updateDetailsTitle => 'I-update ang Detalye';

  @override
  String get labelFavorite => 'Paboritong';

  @override
  String get labelAddToFavorites => 'Idagdag sa mga paboritong';

  @override
  String get labelPricePerKg => 'Presyo bawat kg';

  @override
  String get labelAvailableQty => 'Available na Dami (kg)';

  @override
  String get actionPriceHistory => 'Kasaysayan ng Presyo';

  @override
  String get deleteIngredientTitle => 'Tanggalin ang Sangkap?';

  @override
  String get deleteIngredientMessage =>
      'Ito ay permanenteng aalis ang sangkapong ito mula sa iyong aklatan. Ang aksyon na ito ay hindi maaaring i-undo.';

  @override
  String get confirmCancel => 'Kanselahin';

  @override
  String get successIngredientUpdated =>
      'Ang sangkap ay na-update nang matagumpay';

  @override
  String errorSaveFailed(String error) {
    return 'Hindi nakapagsave: $error';
  }

  @override
  String get successIngredientDeleted => 'Tanggal na ang sangkap';

  @override
  String errorDeleteFailed(String error) {
    return 'Hindi matanggal: $error';
  }

  @override
  String get errorPriceGreaterThanZero => 'Dapat > 0';

  @override
  String get errorQuantityGreaterOrEqual => 'Dapat ≥ 0';

  @override
  String get addFeedTitle => 'Magdagdag/Suriin ang Feed';

  @override
  String get updateFeedTitle => 'I-update ang Feed';

  @override
  String get actionAddIngredients => 'Magdagdag ng Mga Sangkap';

  @override
  String get tooltipAddIngredients => 'Magdagdag ng higit pang sangkap sa feed';

  @override
  String get tooltipSaveFeed => 'I-save ang feed';

  @override
  String get tooltipUpdateFeed => 'I-update ang feed';

  @override
  String get actionAnalyse => 'Suriin';

  @override
  String get tooltipAnalyseFeed => 'Suriin ang komposisyon ng feed';

  @override
  String get errorFeedNameRequired => 'Kinakailangan ang Pangalan ng Feed';

  @override
  String get errorFeedNameMessage =>
      'Pakilagay ang pangalan ng feed bago mag-save.';

  @override
  String get errorMissingFeedName => 'Walang Pangalan ng Feed';

  @override
  String get errorMissingFeedNameMessage =>
      'Pakilagay ang pangalan ng feed bago ang pagsusuri.';

  @override
  String get errorNoIngredients => 'Walang Sangkap';

  @override
  String get errorNoIngredientsMessage =>
      'Magdagdag ng kahit isang sangkap para sa pagsusuri.';

  @override
  String get errorInvalidQuantities => 'Maling Dami';

  @override
  String get errorInvalidQuantitiesMessage =>
      'Lahat ng sangkap ay dapat may wastong dami na mas malaki sa 0.';

  @override
  String get errorGenericTitle => 'May Nagkaproblema';

  @override
  String get errorGenericMessage => 'Pakisubukang muli.';

  @override
  String get actionOk => 'OK';

  @override
  String get analyseDialogTitle => 'Suriin ang Komposisyon ng Feed';

  @override
  String analyseDialogMessageNew(String feedName) {
    return 'Tingnan ang detalyadong pagsusuri para sa \"$feedName\" nang hindi sine-save.';
  }

  @override
  String analyseDialogMessageUpdate(String feedName) {
    return 'Tingnan ang detalyadong pagsusuri para sa \"$feedName\" nang hindi nag-a-update.';
  }

  @override
  String get analyseDialogPreviewNote =>
      'Ito ay preview. Maaari mong i-save mamaya.';

  @override
  String get analyseDialogNoSaveNote => 'Hindi mase-save ang mga pagbabago.';

  @override
  String get analyseDialogFailedMessage =>
      'Nabigo ang pagsusuri ng feed. Pakisubukang muli.';

  @override
  String get reportTitleEstimate => 'Tantiyang Pagsusuri';

  @override
  String get reportTitleAnalysis => 'Ulat ng Pagsusuri';

  @override
  String get nutrientDigestiveEnergy => 'Natutunaw na Enerhiya';

  @override
  String get nutrientMetabolicEnergy => 'Metabolic na Enerhiya';

  @override
  String get nutrientCrudeProtein => 'Krudong Protina';

  @override
  String get nutrientCrudeFiber => 'Krudong Hibla';

  @override
  String get nutrientCrudeFat => 'Krudong Taba';

  @override
  String get nutrientCalcium => 'Calcium';

  @override
  String get nutrientPhosphorus => 'Posporus';

  @override
  String get nutrientLysine => 'Lisina';

  @override
  String get nutrientMethionine => 'Metiyonina';

  @override
  String get nutrientAsh => 'Abo';

  @override
  String get nutrientMoisture => 'Halumigmig';

  @override
  String get nutrientAvailablePhosphorus => 'Magagamit na Posporus';

  @override
  String get nutrientTotalPhosphorus => 'Kabuuang Posporus';

  @override
  String get nutrientPhytatePhosphorus => 'Posporus ng Pitate';

  @override
  String get unitPercent => '%';

  @override
  String get unitGramPerKg => 'g/Kg';

  @override
  String get aminoAcidProfileTitle => 'Profayl ng Amino Asido';

  @override
  String get aminoAcidSidLabel => 'SID (Natutunaw)';

  @override
  String get aminoAcidTotalLabel => 'Kabuuan';

  @override
  String get aminoAcidSidButton => 'SID';

  @override
  String get aminoAcidTotalButton => 'Kabuuan';

  @override
  String get aminoAcidTableHeaderName => 'Amino Asido';

  @override
  String get aminoAcidTableHeaderContent => 'Nilalaman (%)';

  @override
  String get aminoAcidLysine => 'Lisina';

  @override
  String get aminoAcidMethionine => 'Metiyonina';

  @override
  String get aminoAcidCystine => 'Sistina';

  @override
  String get aminoAcidThreonine => 'Treonina';

  @override
  String get aminoAcidTryptophan => 'Triptofan';

  @override
  String get aminoAcidArginine => 'Arjinin';

  @override
  String get aminoAcidIsoleucine => 'Isolusin';

  @override
  String get aminoAcidLeucine => 'Leusin';

  @override
  String get aminoAcidValine => 'Valin';

  @override
  String get aminoAcidHistidine => 'Histidina';

  @override
  String get aminoAcidPhenylalanine => 'Fenilalanina';

  @override
  String get aminoAcidSidInfo =>
      'SID = Pamantayang ileal na natutunaw (pamantayan ng industriya)';

  @override
  String get aminoAcidTotalInfo =>
      'Kabuuang amino acid (hindi lahat ay natutunaw)';

  @override
  String get aminoAcidLoadError =>
      'Nagka-error sa paglo-load ng data ng amino acid';

  @override
  String get warningsCardTitle => 'Mga Babala at Rekomendasyon';

  @override
  String warningsCardIssueCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mga isyu ang nahanap',
      one: '1 isyu ang nahanap',
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

  @override
  String get optimizerTitle => 'Feed Optimizer';

  @override
  String get optimizerDescription =>
      'Awtomatikong lumikha ng pinakamainam na feed formulations';

  @override
  String get optimizerMenuTitle => 'I-optimize ang Feed';

  @override
  String get optimizerQuickOptimize => 'Quick Optimize';

  @override
  String get optimizerQuickOptimizeDescription =>
      'Broiler Chicken Starter with 10 common ingredients (2 minutes)';

  @override
  String get optimizerWhyTheseDefaults => 'Why these defaults?';

  @override
  String get optimizerWhyTheseDefaultsExplanation =>
      'These settings are optimized for broiler chicken starters based on NRC 1994 poultry standards. The 10 ingredients are widely available, cost-effective, and provide excellent nutrition. Results in 2 minutes.';

  @override
  String get optimizerCustomOptimize => 'Custom Optimize';

  @override
  String get quickOptimizeTitle => 'Mabilis na Pag-optimize (Inirekomenda)';

  @override
  String get quickOptimizeDescription =>
      'Pre-configured na pormulasyon para sa Broiler Chicken. Bawasan ang gastos gamit ang mataas na kalidad na sangkap.';

  @override
  String get quickOptimizeButton => 'Simulan ang Mabilis na Pag-optimize';

  @override
  String get quickOptimizeTooltip =>
      'Bakit ang mga default na ito? Inirekomenda sila ng mga nutritionist para sa maliliit na magsasaka. Maaari mong i-customize ang mga hadlang pagkatapos.';

  @override
  String get customOptimizeTitle => 'Customized na Pag-optimize';

  @override
  String get optimizerActionReset => 'I-reset';

  @override
  String get optimizerActionAdd => 'Idagdag';

  @override
  String get optimizerOptimizing => 'Nag-ooptimize...';

  @override
  String get optimizerRunOptimization => 'Patakbuhin ang Optimization';

  @override
  String get optimizerNoConstraints =>
      'Walang idinagdag na hadlang pa. I-tap ang + upang magdagdag.';

  @override
  String get optimizerNoResults =>
      'Walang resulta pa. Magpatakbo ng optimization upang makita ang mga resulta.';

  @override
  String optimizerLoadedFeed(String feedName) {
    return 'Na-load ang feed: $feedName';
  }

  @override
  String get optimizerErrorLoadingFeed => 'Error sa pag-load ng feed';

  @override
  String get optimizerConstraintsTitle => 'Mga Hadlang sa Nutrisyon';

  @override
  String get optimizerAddConstraintTooltip =>
      'Magdagdag ng hadlang sa nutrisyon';

  @override
  String get optimizerEditConstraint => 'I-edit ang Hadlang';

  @override
  String get optimizerLabelNutrient => 'Nutrisyon';

  @override
  String get optimizerLabelType => 'Uri';

  @override
  String get optimizerLabelValue => 'Halaga';

  @override
  String get optimizerLabelUnit => 'Yunit';

  @override
  String get optimizerConstraintMinimum => 'Pinakamababa';

  @override
  String get optimizerConstraintMaximum => 'Pinakamataas';

  @override
  String get nutrientEnergy => 'Enerhiya (kcal/kg)';

  @override
  String get optimizerAnimalCategory => 'Uri ng Hayop';

  @override
  String get optimizerSelectAnimalSpecies => 'Pumili ng uri ng hayop';

  @override
  String get optimizerSelectProductionStage => 'Pumili ng yugto ng produksyon';

  @override
  String get optimizerLoadRequirements => 'I-load ang Mga Kinakailangan';

  @override
  String get optimizerConstraints => 'Mga Hadlang sa Nutrisyon';

  @override
  String get optimizerAddConstraint => 'Magdagdag ng Hadlang';

  @override
  String get optimizerConstraintType => 'Uri ng Hadlang';

  @override
  String get optimizerConstraintMin => 'Pinakamababa';

  @override
  String get optimizerConstraintMax => 'Pinakamataas';

  @override
  String get optimizerConstraintExact => 'Eksakto';

  @override
  String get optimizerSelectIngredients => 'Pumili ng Mga Sangkap';

  @override
  String get optimizerIngredientsSelected => 'mga sangkap na napili';

  @override
  String get optimizerUseAllIngredients => 'Gamitin Lahat ng Available';

  @override
  String get optimizerObjectiveFunction => 'Ano ang pinaka-mahalaga?';

  @override
  String get optimizerObjectiveMinimizeCost => 'Pinakamababang Halaga';

  @override
  String get optimizerObjectiveMaximizeProtein => 'Pinakamataas na Protina';

  @override
  String get optimizerObjectiveMaximizeEnergy => 'Pinakamaraming Enerhiya';

  @override
  String get optimizerButtonOptimize => 'I-optimize';

  @override
  String get optimizerButtonQuickOptimize =>
      'Mabilis na Pag-optimize (Inirerekomenda)';

  @override
  String get optimizerCalculating =>
      'Kinakalkula ang pinakamainam na formula...';

  @override
  String get optimizerResultsTitle => 'Mga Resulta ng Pag-optimize';

  @override
  String get optimizerResultsSuccess => 'Tagumpay!';

  @override
  String get optimizerResultsFailed => 'Nabigo ang Pag-optimize';

  @override
  String get optimizerResultsQualityScore => 'Puntos ng Kalidad';

  @override
  String get optimizerResultsTotalCost => 'Kabuuang Halaga';

  @override
  String get optimizerResultsCostPerKg => 'Halaga bawat kilo';

  @override
  String get optimizerResultsIngredientProportions => 'Hatiin ng Sangkap';

  @override
  String get optimizerResultsNutritionalProfile => 'Profile ng Nutrisyon';

  @override
  String get optimizerResultsWarnings => 'Mga Babala';

  @override
  String get optimizerResultsWhyExplain => 'Bakit ang Mga Proporsyong Ito?';

  @override
  String get optimizerErrorNoIngredients =>
      'Pumili ng hindi bababa sa 2 sangkap';

  @override
  String get optimizerErrorNoAnimal => 'Pumili ng uri ng hayop';

  @override
  String get optimizerErrorInfeasible =>
      'Walang solusyon na natagpuan. Subukang ayusin ang mga hadlang o magdagdag ng mas maraming sangkap.';

  @override
  String get optimizerErrorGeneral => 'Nabigo ang pag-optimize. Subukan muli.';

  @override
  String get optimizerHelpTitle => 'Paano Ito Gumagana';

  @override
  String get optimizerHelpConstraints =>
      'Ang mga hadlang ay mga kinakailangan sa nutrisyon tulad ng minimum na protina o maximum na hibla. Ang optimizer ay nakakahanap ng pinakamahusay na timpla ng sangkap na nakakatugon sa lahat ng kinakailangan.';

  @override
  String get optimizerHelpObjective =>
      'Ang layunin ay nagsasabi sa optimizer kung ano ang uunahin: pinakamurang feed, pinakamataas na protina, o pinakamaraming enerhiya.';

  @override
  String get optimizerActionSave => 'I-save sa Aking Mga Feed';

  @override
  String get optimizerActionShare => 'Ibahagi sa Veterinarian';

  @override
  String get optimizerActionTryAgain => 'Subukan Muli';

  @override
  String get optimizerFormulationHistory => 'Mga Nakaraang Formula';

  @override
  String get optimizerExportTitle => 'Format ng Pag-export';

  @override
  String get optimizerExportFormatJson => 'JSON';

  @override
  String get optimizerExportFormatCsv => 'CSV';

  @override
  String get optimizerExportFormatText => 'Ulat ng Teksto';

  @override
  String optimizerExportedAs(String format, String filename) {
    return 'I-export bilang $format: $filename';
  }
}
