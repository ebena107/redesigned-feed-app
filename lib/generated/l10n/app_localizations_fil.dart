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
  String get navFeedFormulator => 'Formulator';

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
  String get screenTitleImportWizard => 'Wizard ng Pag-import';

  @override
  String get screenTitleFeedFormulator => 'Feed Formulator';

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
  String get actionOptimize => 'Optimize';

  @override
  String get actionClear => 'I-clear';

  @override
  String get actionClearFilters => 'I-clear ang mga Filter';

  @override
  String get actionSaveChanges => 'I-save ang mga Pagbabago';

  @override
  String get actionReset => 'I-reset';

  @override
  String get actionBack => 'Back';

  @override
  String get actionNext => 'Next';

  @override
  String formulatorStepIndicator(int step, int total) {
    return 'Step $step of $total';
  }

  @override
  String get formulatorStepAnimal => 'Animal profile';

  @override
  String get formulatorStepIngredients => 'Select ingredients';

  @override
  String get formulatorStepConstraints => 'Set nutrient targets';

  @override
  String get formulatorStepResults => 'Optimized formula';

  @override
  String get formulatorSelectIngredientsHint =>
      'Choose ingredients to include in optimization';

  @override
  String get formulatorSearchIngredients => 'Search ingredients';

  @override
  String get formulatorIngredientSearchHint => 'Search by name';

  @override
  String formulatorSelectedCount(int count) {
    return '$count selected';
  }

  @override
  String get formulatorSelectAll => 'Select all';

  @override
  String get formulatorResetSelection => 'Clear selection';

  @override
  String get formulatorConstraintMin => 'Min';

  @override
  String get formulatorConstraintMax => 'Maximum';

  @override
  String get formulatorConstraintHelp => 'Leave blank to ignore a bound';

  @override
  String get formulatorActionSolve => 'Solve Formulation';

  @override
  String get formulatorDiversityTitle => 'Enhanced Diversity Mode';

  @override
  String get formulatorDiversityDesc =>
      'Forces the engine to use a wider spread of your selected ingredients rather than picking only the absolute cheapest ones.';

  @override
  String get formulatorNoResults => 'Run optimization to see results.';

  @override
  String get formulatorStatusSolving => 'Optimizing...';

  @override
  String get formulatorStatusFailed => 'Optimization failed';

  @override
  String get formulatorStatusInfeasible =>
      'No feasible solution with current constraints.';

  @override
  String get formulatorStatusUnbounded =>
      'Optimization is unbounded. Check constraints.';

  @override
  String get formulatorCostPerKg => 'Cost per kg';

  @override
  String get formulatorNutrientsSummary => 'Nutrient summary';

  @override
  String get formulatorIngredientMix => 'Ingredient mix';

  @override
  String get formulatorWarnings => 'Warnings';

  @override
  String get formulatorEmptySelection =>
      'Select at least one ingredient to continue.';

  @override
  String get formulatorLoadingAnimals => 'Loading animal types...';

  @override
  String formulatorLoadAnimalsFailed(String error) {
    return 'Failed to load animal types: $error';
  }

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
  String get noIngredientsSelected => 'Wala pang napiling sangkap';

  @override
  String get selectedIngredients => 'Mga Napiling Sangkap';

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
  String confirmDelete(String item) {
    return 'Tanggalin ang $item?';
  }

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
  String get regionAll => 'Lahat ng Rehiyon';

  @override
  String get regionAfrica => 'Afrika';

  @override
  String get regionAsia => 'Asya';

  @override
  String get regionEurope => 'Europa';

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
  String get unitKcal => 'kcal/kg';

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
  String get formSectionBasicInfo => 'Pangunahing Impormasyon';

  @override
  String get formSectionEnergyValues => 'Mga Halaga ng Enerhiya';

  @override
  String get formSectionMacronutrients => 'Makronutriyente';

  @override
  String get formSectionMicronutrients => 'Mikronutriyente';

  @override
  String get formSectionCostAvailability => 'Gastos at Pagkakaroon';

  @override
  String get formSectionAdditionalInfo => 'Karagdagang Impormasyon';

  @override
  String get fieldHintEnergyMode =>
      'Ilagay ang mga halaga ng enerhiya para sa bawat partikular na grupo ng hayop?';

  @override
  String get fieldLabelAdultPigs => 'Mga baboy na nasa hustong gulang';

  @override
  String get fieldLabelGrowingPigs => 'Mga baboy na lumalaki';

  @override
  String get fieldLabelPoultry => 'Poultry';

  @override
  String get fieldLabelRabbit => 'Kuneho';

  @override
  String get fieldLabelRuminant => 'Ruminant';

  @override
  String get fieldLabelFish => 'Isda';

  @override
  String get fieldLabelCreatedBy => 'Nilikhang ni';

  @override
  String get fieldLabelNotes => 'Mga tala';

  @override
  String get customIngredientHeader => 'Paglikha ng Pasadyang Sangkap';

  @override
  String get customIngredientDescription =>
      'Maaari kang magdagdag ng sarili mong sangkap na may pasadyang mga halagang nutrisyon';

  @override
  String get newIngredientTitle => 'Bagong Sangkap';

  @override
  String get fieldLabelFeedName => 'Pangalan ng Pakain';

  @override
  String get fieldLabelAnimalType => 'Uri ng Hayop';

  @override
  String get fieldLabelProductionStage => 'Yugto ng Produksyon';

  @override
  String ingredientAddedSuccessTitle(String name) {
    return '$name ay naidagdag';
  }

  @override
  String get ingredientAddedSuccessMessage =>
      'Gusto mo bang magdagdag pa ng isa pang sangkap?';

  @override
  String get ingredientAddedNo => 'Hindi, Bumalik';

  @override
  String get ingredientAddedYes => 'Oo, Magpatuloy';

  @override
  String customIngredientsHeader(int count) {
    return 'Iyong Mga Pasadyang Sangkap ($count)';
  }

  @override
  String get customIngredientsSearchHint =>
      'Maghanap sa iyong mga pasadyang sangkap...';

  @override
  String get customIngredientsEmptyTitle => 'Wala pang pasadyang sangkap';

  @override
  String get customIngredientsEmptySubtitle =>
      'Gumawa ng iyong unang pasadyang sangkap!';

  @override
  String get customIngredientsNoMatch =>
      'Walang sangkap na tumugma sa iyong paghahanap';

  @override
  String labelCreatedBy(String creator) {
    return 'ni $creator';
  }

  @override
  String get labelNotes => 'Mga tala:';

  @override
  String get labelPriceHistory => 'Kasaysayan ng Presyo';

  @override
  String get labelCa => 'Ca';

  @override
  String get labelP => 'P';

  @override
  String get priceHistoryEmpty => 'Walang kasaysayan ng presyo';

  @override
  String get priceHistoryError => 'Hindi ma-load ang kasaysayan ng presyo';

  @override
  String get deleteCustomIngredientTitle => 'Tanggalin ang \"null\"?';

  @override
  String deleteCustomIngredientMessage(String name) {
    return 'Sigurado ka bang nais mong tanggalin ang pasadyang sangkap na ito?';
  }

  @override
  String ingredientRemovedSuccess(String name) {
    return 'Inalis ang $name';
  }

  @override
  String get exportFormatTitle => 'Format ng Export';

  @override
  String get exportFormatMessage =>
      'Piliin ang format ng export para sa iyong mga pasadyang sangkap:';

  @override
  String get exportingToJson => 'Ini-export sa JSON...';

  @override
  String get exportingToCsv => 'Ini-export sa CSV...';

  @override
  String get exportFailed => 'Nabigo ang export';

  @override
  String exportFailedWithError(String error) {
    return 'Nabigo ang export: $error';
  }

  @override
  String get importCustomIngredientsTitle =>
      'I-import ang Mga Pasadyang Sangkap';

  @override
  String get importFormatMessage => 'Piliin ang format ng file na i-import:';

  @override
  String get importingData => 'Ini-import ang data...';

  @override
  String get importSuccessTitle => 'Matagumpay ang Import';

  @override
  String get importFailedTitle => 'Nabigo ang Import';

  @override
  String importError(String error) {
    return 'Error: $error';
  }

  @override
  String get actionJson => 'JSON';

  @override
  String get actionCsv => 'CSV';

  @override
  String get labelIngredient => 'Sangkap';

  @override
  String get actionShare => 'Share';

  @override
  String get exportingToPdf => 'Exporting to PDF...';

  @override
  String missingPriceWarning(int count) {
    return 'Nawawalang presyo para sa $count sangkap; gumagamit ng average na presyo.';
  }

  @override
  String get addMoreIngredientsRecommendation =>
      'Magdagdag ng mas maraming sangkap (inirerekomenda ang hindi bababa sa 3-5) para sa mas maraming flexibility sa pagtugunan ang mga layuning pangnutrisyon.';

  @override
  String get tightenedConstraintsRecommendation =>
      'Ang mga pangangailangan sa nutrisyon ay maaaring masyadong mahigpit para sa mga napiling sangkap. Subukan na palawakin ang min/max na mga hanay ng 5-10%.';

  @override
  String get addHigherNutrientIngredientsRecommendation =>
      'Bilang alternatibo, magdagdag ng mga sangkap na may mas mataas na densidad ng nutrisyon sa mga limitadong nutriente.';

  @override
  String conflictingConstraintsError(String min, String max) {
    return 'Minimum ($min) lumampas sa maximum ($max). Mangyaring ayusin ito.';
  }

  @override
  String narrowRangeWarning(String range) {
    return 'Ang hanay ay napakalaki ($range). Subukan na palawakin ng 10-20%.';
  }

  @override
  String nutrientCoverageIssue(String max, String min, String nutrient) {
    return 'Ang pinakamataas na available mula sa mga sangkap ay $max, ngunit ang kinakailangang minimum ay $min. Bawasan ang requirement o pumili ng mga sangkap na may mas mataas na $nutrient.';
  }

  @override
  String get lowInclusionLimitsWarning =>
      'Maraming sangkap ang may napakababang maximum inclusion limits. Magdagdag ng mas maraming iba\'t ibang sangkap upang makapantay sa mga hadlang.';

  @override
  String totalInclusionLimitWarning(String total) {
    return 'Ang kabuuang maximum inclusion sa mga napiling sangkap ay $total%. Magdagdag ng mas maraming sangkap o taasan ang indibidwal na mga limitasyon.';
  }
}
