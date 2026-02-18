// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Yoruba (`yo`).
class AppLocalizationsYo extends AppLocalizations {
  AppLocalizationsYo([String locale = 'yo']) : super(locale);

  @override
  String get appTitle => 'Iṣiro Eko Aran';

  @override
  String get appDescription => 'Olupilese ọ⊙rọ eko aran fun aran';

  @override
  String get navHome => 'Oju-Opo';

  @override
  String get navFeeds => 'Eko Mi';

  @override
  String get navIngredients => 'Awọn Ero';

  @override
  String get navSettings => 'Awọn Iṣeto';

  @override
  String get navAbout => 'Nipa';

  @override
  String get navFeedFormulator => 'Formulator';

  @override
  String get screenTitleHome => 'Sakekọ Eko Aran';

  @override
  String get screenTitleIngredientLibrary => 'Ibi-eko Awọn Ero';

  @override
  String get screenTitleNewFeed => 'Ṣe Eko';

  @override
  String get screenTitleReports => 'Itupalẹ';

  @override
  String get screenTitleSettings => 'Awọn Iṣeto';

  @override
  String get screenTitleAbout => 'Nipa Iṣiro Eko Aran';

  @override
  String get screenTitleImportWizard => 'Oluranlowo Gbigbe Wọle';

  @override
  String get screenTitleFeedFormulator => 'Feed Formulator';

  @override
  String get actionCreate => 'Ṣẹda';

  @override
  String get actionSave => 'Fi Pamọ';

  @override
  String get actionUpdate => 'Ṣe Atuala';

  @override
  String get actionDelete => 'Paare';

  @override
  String get actionCancel => 'Fagile';

  @override
  String get actionAdd => 'Ṣafikun';

  @override
  String get actionAddNew => 'Ṣafikun Tuntun';

  @override
  String get actionRefresh => 'Ṣatun';

  @override
  String get actionEdit => 'Ṣatunraye';

  @override
  String get actionRemove => 'Yọ Kuro';

  @override
  String get actionRetry => 'Gbiyanju Lẹẹkansi';

  @override
  String get actionViewReport => 'Wo Ijabọ';

  @override
  String get actionClear => 'Nu';

  @override
  String get actionClearFilters => 'Nu Awọn Asẹ';

  @override
  String get actionSaveChanges => 'Fi Awọn Ayipada Pamọ';

  @override
  String get actionReset => 'Tun Ṣeto';

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
  String get formulatorConstraintMin => 'Minimum';

  @override
  String get formulatorConstraintMax => 'Maximum';

  @override
  String get formulatorConstraintHelp => 'Leave blank to ignore a bound';

  @override
  String get formulatorActionSolve => 'Solve';

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
  String get homeEmptyTitle => 'Ko Si Ounjẹ Sibẹ';

  @override
  String get homeEmptySubtitle => 'Ṣẹda ounjẹ akọkọ rẹ';

  @override
  String get homeCreateFeed => 'Ṣẹda Ounjẹ';

  @override
  String get homeAddFeed => 'Fi Ounjẹ Kun';

  @override
  String homeLoadFailed(String error) {
    return 'Ikuna lati ṣe akojọpọ ounjẹ: $error';
  }

  @override
  String get homeLoadingFeeds => 'N ṣe akojọpọ ounjẹ...';

  @override
  String get feedListEmpty => 'Ko Si Ounjẹ Ti O Wa';

  @override
  String get feedsLoadFailed => 'Ikuna lati ṣe akojọpọ ounjẹ';

  @override
  String get feedsEmptyStateTitle => 'Ko ri ounjẹ eyikeyi';

  @override
  String get feedNameUnknown => 'Ounjẹ Aimọ';

  @override
  String feedSubtitle(String animalType) {
    return 'Ounjẹ fun $animalType';
  }

  @override
  String feedDeleteTitle(String feedName) {
    return 'Pa \"$feedName\" rẹ?';
  }

  @override
  String get confirmDeletionWarning => 'A ko le ṣe atunṣe iṣẹ yii.';

  @override
  String get feedStoreTitle => 'Ounjẹ Ninu Ile Itọju';

  @override
  String get feedStorePlaceholder => 'Ounjẹ ti a tọju nibi';

  @override
  String get ingredientSelectedLabel => 'Eroja Ti A Yan';

  @override
  String get ingredientSelectLabel => 'Yan Eroja';

  @override
  String get ingredientSelectTitle => 'Yan Eroja';

  @override
  String get ingredientSearchHint => 'Wa pẹlu orukọ...';

  @override
  String get ingredientNameUnknown => 'Aimọ';

  @override
  String ingredientAvailableQty(String qty) {
    return '$qty kg wa';
  }

  @override
  String ingredientPricePerKg(String price) {
    return '$price/kg';
  }

  @override
  String get ingredientsLoadFailed => 'Ikuna lati ṣe akojọpọ eroja';

  @override
  String get ingredientsEmptyTitle => 'Ko ri eroja kankan';

  @override
  String get ingredientsEmptySubtitle => 'Fi awọn eroja kun lati bẹrẹ';

  @override
  String get ingredientsEmptyFilteredTitle =>
      'Ko si eroja ti o baamu awọn asẹ rẹ';

  @override
  String get ingredientsEmptyFilteredSubtitle =>
      'Gbiyanju ṣatunṣe wiwa rẹ tabi awọn asẹ';

  @override
  String get noIngredientsSelected => 'Ko si eroja ti a ti yan';

  @override
  String get selectedIngredients => 'Awọn eroja ti a yan';

  @override
  String get filterFavorites => 'Awọn Ayanfẹ';

  @override
  String get filterCustom => 'Adani';

  @override
  String filterRegionLabel(String region) {
    return 'Agbegbe: $region';
  }

  @override
  String get fallbackUnknownSymbol => '?';

  @override
  String get actionClose => 'Didi';

  @override
  String get actionExport => 'Gbe Sita';

  @override
  String get actionImport => 'Gbe Sinu';

  @override
  String get labelName => 'Oruko';

  @override
  String get labelPrice => 'Idiyele';

  @override
  String get labelQuantity => 'Isura';

  @override
  String get labelCategory => 'Isọrọ';

  @override
  String get labelRegion => 'Agbegbe';

  @override
  String get labelProtein => 'Aadun';

  @override
  String get labelFat => 'Afara';

  @override
  String get labelFiber => 'Egbin';

  @override
  String get labelCalcium => 'Kalisiamu';

  @override
  String get labelPhosphorus => 'Fosfora';

  @override
  String get labelEnergy => 'Agbara';

  @override
  String get labelCost => 'Idiyele';

  @override
  String get labelTotal => 'Lapapọ';

  @override
  String get hintEnterName => 'Apẹẹrẹ: Eko Kini Adie';

  @override
  String get hintEnterPrice => '10.50';

  @override
  String get hintEnterQuantity => '100';

  @override
  String get hintSearch => 'Wa awọn ero...';

  @override
  String get hintSelectIngredient => 'Kan lati yan ero';

  @override
  String errorRequired(String field) {
    return '$field jẹ dandan';
  }

  @override
  String get errorInvalidPrice => 'Tẹ idiyele ti o tọ (apẹẹrẹ: 10.50)';

  @override
  String get errorInvalidQuantity => 'Tẹ isura ti o tọ (apẹẹrẹ: 100)';

  @override
  String get errorPriceNegative => 'Idiyele ko le jẹ ailopin';

  @override
  String get errorQuantityZero => 'Isura gbọdọ wa pelu idiyele';

  @override
  String get errorNameTooShort => 'Oruko gbọdọ ni orilẹ mẹta ni isunma';

  @override
  String get errorNameTooLong => 'Oruko gbọdọ ni iwe 50 ni isunma';

  @override
  String errorUnique(String field) {
    return '$field ti wa tẹlẹ';
  }

  @override
  String get errorDatabaseOperation =>
      'Iṣẹ àkójọ àwè padanu. Jọwọ gbiyanju lẹẹkansi.';

  @override
  String get errorNetworkError => 'Asoye network. Jọwọ ṣayẹwo iyipada rẹ.';

  @override
  String messageCreatedSuccessfully(String item) {
    return '$item ṣeda daradun';
  }

  @override
  String messageUpdatedSuccessfully(String item) {
    return '$item ṣe atuala daradun';
  }

  @override
  String messageDeletedSuccessfully(String item) {
    return '$item paare daradun';
  }

  @override
  String get messageLoading => 'N ila...';

  @override
  String get messageNoData => 'Enikan àkọsílẹ ko si';

  @override
  String messageEmpty(String item) {
    return 'Enikan $item ko ṣafikun tii';
  }

  @override
  String confirmDelete(String item) {
    return 'Paare $item?';
  }

  @override
  String get confirmDeleteDescription => 'Iṣẹ yii ko le tun rọ pada.';

  @override
  String get animalTypePig => 'Ewa';

  @override
  String get animalTypePoultry => 'Adie';

  @override
  String get animalTypeRabbit => 'Ehoro';

  @override
  String get animalTypeRuminant => 'Aran mimu';

  @override
  String get animalTypeFish => 'Eja';

  @override
  String get regionAll => 'Gbogbo Agbegbe';

  @override
  String get regionAfrica => 'Afrika';

  @override
  String get regionAsia => 'Esia';

  @override
  String get regionEurope => 'Europa';

  @override
  String get regionAmericas => 'Awọn Amerika';

  @override
  String get regionOceania => 'Oseania';

  @override
  String get regionGlobal => 'Ayaba';

  @override
  String get filterBy => 'Ya Nipase';

  @override
  String get sortBy => 'Pa Ni Iṣiro';

  @override
  String get sortByName => 'Oruko';

  @override
  String get sortByPrice => 'Idiyele';

  @override
  String get sortByRegion => 'Agbegbe';

  @override
  String get unitKg => 'kg';

  @override
  String get unitG => 'g';

  @override
  String get unitLb => 'lb';

  @override
  String get unitTon => 'ton';

  @override
  String get unitKcal => 'kcal/kg';

  @override
  String get settingLanguage => 'Ede';

  @override
  String get settingTheme => 'Ṣokan';

  @override
  String get settingNotifications => 'Awọn Akiyesi';

  @override
  String get settingAbout => 'Nipa';

  @override
  String aboutVersion(String version) {
    return 'Ẹtọ $version';
  }

  @override
  String get aboutPrivacy => 'Ohun Ẹkọ Isiṣẹ';

  @override
  String get aboutTerms => 'Awọn Ofin Lilo';

  @override
  String get aboutDeveloper => 'Ṣẹda fun awọn ti n itan aran';

  @override
  String get aboutContribution => 'Ero rẹ nran wa lọwọ lati mu dara si';

  @override
  String get settingsTitle => 'Awọn Iṣeto';

  @override
  String get settingsSectionLanguage => 'Ede';

  @override
  String get settingsSectionPrivacy => 'Aṣiri ati Data';

  @override
  String get settingsSectionDataManagement => 'Iṣakoso Data';

  @override
  String get settingsSectionLegal => 'Ofin';

  @override
  String get settingsSelectLanguage => 'Yan Ede';

  @override
  String settingsLanguageLimitedUI(String language) {
    return '$language (Eto lopin)';
  }

  @override
  String get settingsDataConsent => 'Ifọwọsi Gbigba Data';

  @override
  String get settingsConsentGranted => 'O ti fun ni ifọwọsi fun gbigba data';

  @override
  String get settingsConsentNotGranted => 'O ko fun ni ifọwọsi';

  @override
  String get settingsConsentDate => 'Ojo Ifọwọsi';

  @override
  String get settingsPrivacyPolicy => 'Ohun Ẹkọ Isiṣẹ';

  @override
  String get settingsPrivacyPolicySubtitle => 'Wo ohun ẹkọ isiṣẹ wa';

  @override
  String get settingsFeedFormulations => 'Awọn Sakekọ Eko';

  @override
  String get settingsCustomIngredients => 'Awọn Ero Akanṣe';

  @override
  String get settingsDatabaseSize => 'Iwọn Ibi-ipamọ';

  @override
  String get settingsExportData => 'Ṣe Export Data';

  @override
  String get settingsExportDataSubtitle => 'Fi gbogbo data rẹ pamọ';

  @override
  String get settingsImportData => 'Gbe Data Wọle';

  @override
  String get settingsImportDataSubtitle => 'Mu pada lati backup';

  @override
  String get settingsDeleteData => 'Paare Gbogbo Data';

  @override
  String get settingsDeleteDataSubtitle => 'Paare gbogbo ohun ni ayeraye';

  @override
  String get settingsVersion => 'Ẹya';

  @override
  String get settingsRateApp => 'Ṣe Idiyele Ohun Elo';

  @override
  String get settingsRateAppSubtitle => 'Pin ero rẹ';

  @override
  String get settingsLicenses => 'Awọn License Orisun Ṣiṣi';

  @override
  String get settingsTermsOfService => 'Awọn Ofin Lilo';

  @override
  String get settingsTermsComingSoon => 'N bọ laipẹ';

  @override
  String get settingsDataSafety => 'Ailewu Data';

  @override
  String get settingsDataSafetySubtitle => 'Data rẹ wa ni ibi agbegbe';

  @override
  String get settingsFooter => 'Ṣe pẹlu ❤️ fun awọn ti n itan aran';

  @override
  String get settingsExporting => 'N ṣe export data...';

  @override
  String get settingsExportSuccess => 'Export Ṣaṣeyọri';

  @override
  String get settingsExportSuccessMessage => 'Backup rẹ ti ṣẹda ni aṣeyọri!';

  @override
  String get settingsRevokeConsentTitle => 'Fagile Ifọwọsi';

  @override
  String get settingsRevokeConsentMessage =>
      'Ṣe o dajudaju pe o fẹ fagile ifọwọsi rẹ? Eyi ko ni paare data rẹ, ṣugbọn o jẹwọ pe o ko fun ni ifọwọsi mọ fun gbigba data.';

  @override
  String settingsLanguageUpdated(String language) {
    return 'Ede ti ṣe atuala si $language';
  }

  @override
  String get ingredientLibraryTitle => 'Apoti Elo-ikunrin';

  @override
  String get manageInventoryTitle => 'ṢIṢẸ IGBOOWU';

  @override
  String get customIngredientsTitle => 'Elo-ikunrin Ti a Ṣelọ';

  @override
  String get updateDetailsTitle => 'Tun Alaye';

  @override
  String get labelFavorite => 'Anfani';

  @override
  String get labelAddToFavorites => 'Fi kun anfani';

  @override
  String get labelPricePerKg => 'Iyipada fun kg';

  @override
  String get labelAvailableQty => 'Iye Igboowu (kg)';

  @override
  String get actionPriceHistory => 'Itan Iyipada';

  @override
  String get deleteIngredientTitle => 'Pa Elo-ikunrin?';

  @override
  String get deleteIngredientMessage =>
      'Eyi a pa elo-ikunrin yi lagilagi kuro ninu apoti rẹ. Aṣiṣe yii ko le tun ṣe.';

  @override
  String get confirmCancel => 'Fa';

  @override
  String get successIngredientUpdated => 'Elo-ikunrin ti tun daradara';

  @override
  String errorSaveFailed(String error) {
    return 'Iṣoro ati ifipamọ: $error';
  }

  @override
  String get successIngredientDeleted => 'Elo-ikunrin ti pa';

  @override
  String errorDeleteFailed(String error) {
    return 'Iṣoro ati papa: $error';
  }

  @override
  String get errorPriceGreaterThanZero => 'Gbodo jẹ > 0';

  @override
  String get errorQuantityGreaterOrEqual => 'Gbodo jẹ ≥ 0';

  @override
  String get addFeedTitle => 'Fi Kun/Ṣayẹwo Eko';

  @override
  String get updateFeedTitle => 'Tun Eko';

  @override
  String get actionAddIngredients => 'Fi Awọn Elo-ikunrin Kun';

  @override
  String get tooltipAddIngredients => 'Fi awọn elo-ikunrin diẹ sii kun eko';

  @override
  String get tooltipSaveFeed => 'Fi eko pamọ';

  @override
  String get tooltipUpdateFeed => 'Tun eko';

  @override
  String get actionAnalyse => 'Ṣayẹwo';

  @override
  String get tooltipAnalyseFeed => 'Ṣayẹwo ipin eko';

  @override
  String get errorFeedNameRequired => 'Orukọ Eko Nilo';

  @override
  String get errorFeedNameMessage =>
      'Jọwọ fi orukọ fun eko rẹ ṣaaju ki o to fi pamọ.';

  @override
  String get errorMissingFeedName => 'Orukọ Eko Ko si';

  @override
  String get errorMissingFeedNameMessage => 'Jọwọ fi orukọ eko ṣaaju ayẹwo.';

  @override
  String get errorNoIngredients => 'Ko si Elo-ikunrin';

  @override
  String get errorNoIngredientsMessage =>
      'Jọwọ fi elo-ikunrin kan kun fun ayẹwo.';

  @override
  String get errorInvalidQuantities => 'Awọn Iye Ti Ko Tọ';

  @override
  String get errorInvalidQuantitiesMessage =>
      'Gbogbo elo-ikunrin gbọdọ ni awọn iye to tọ ti o tobi ju 0 lọ.';

  @override
  String get errorGenericTitle => 'Aṣiṣe Kan Waye';

  @override
  String get errorGenericMessage => 'Jọwọ gbiyanju lẹẹkansi.';

  @override
  String get actionOk => 'O DARA';

  @override
  String get analyseDialogTitle => 'Ṣayẹwo Ipin Eko';

  @override
  String analyseDialogMessageNew(String feedName) {
    return 'Wo ayẹwo ijẹun alaye fun \"$feedName\" laisi fifi pamọ.';
  }

  @override
  String analyseDialogMessageUpdate(String feedName) {
    return 'Wo ayẹwo ijẹun alaye fun \"$feedName\" laisi tunṣe.';
  }

  @override
  String get analyseDialogPreviewNote =>
      'Eyi jẹ ifihan ṣaaju. O le fi pamọ nigbamii.';

  @override
  String get analyseDialogNoSaveNote => 'Awọn ayipada ko ni fi pamọ.';

  @override
  String get analyseDialogFailedMessage =>
      'Ayẹwo eko kuna. Jọwọ gbiyanju lẹẹkansi.';

  @override
  String get reportTitleEstimate => 'Ayẹwo Ti a Fojusi';

  @override
  String get reportTitleAnalysis => 'Ijabọ Ayẹwo';

  @override
  String get nutrientDigestiveEnergy => 'Agbara Itọju';

  @override
  String get nutrientMetabolicEnergy => 'Agbara Metabolic';

  @override
  String get nutrientCrudeProtein => 'Protein Aise';

  @override
  String get nutrientCrudeFiber => 'Okun Aise';

  @override
  String get nutrientCrudeFat => 'Ọra Aise';

  @override
  String get nutrientCalcium => 'Calcium';

  @override
  String get nutrientPhosphorus => 'Phosphorus';

  @override
  String get nutrientLysine => 'Lysine';

  @override
  String get nutrientMethionine => 'Methionine';

  @override
  String get nutrientAsh => 'Eeru';

  @override
  String get nutrientMoisture => 'Omi';

  @override
  String get nutrientAvailablePhosphorus => 'Phosph. Wa';

  @override
  String get nutrientTotalPhosphorus => 'Phosph. Lapapọ';

  @override
  String get nutrientPhytatePhosphorus => 'Phosph. Phytate';

  @override
  String get unitPercent => '%';

  @override
  String get unitGramPerKg => 'g/Kg';

  @override
  String get aminoAcidProfileTitle => 'Profaili Amino Acid';

  @override
  String get aminoAcidSidLabel => 'SID (Itọju)';

  @override
  String get aminoAcidTotalLabel => 'Lapapọ';

  @override
  String get aminoAcidSidButton => 'SID';

  @override
  String get aminoAcidTotalButton => 'Lapapọ';

  @override
  String get aminoAcidTableHeaderName => 'Amino Acid';

  @override
  String get aminoAcidTableHeaderContent => 'Akoonu (%)';

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
      'SID = Itọju Ileal Ti a Ṣe Deede (boṣewa ile-iṣẹ)';

  @override
  String get aminoAcidTotalInfo =>
      'Amino acids lapapọ (kii ṣe gbogbo wọn ni itọju)';

  @override
  String get aminoAcidLoadError => 'Aṣiṣe lakoko gbigbe data amino acid';

  @override
  String get warningsCardTitle => 'Awọn Ikilo ati Awọn Imọran';

  @override
  String warningsCardIssueCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count awọn iṣoro ri',
      one: 'Iṣoro 1 ri',
    );
    return '$_temp0';
  }

  @override
  String pdfPreviewTitle(String feedName) {
    return 'Ebena Feed Estimator | $feedName Print Preview';
  }

  @override
  String get formSectionBasicInfo => 'Alaye ipilẹ';

  @override
  String get formSectionEnergyValues => 'Iye agbara';

  @override
  String get formSectionMacronutrients => 'Awọn makironutrienti';

  @override
  String get formSectionMicronutrients => 'Awọn mikironutrienti';

  @override
  String get formSectionCostAvailability => 'Iye owo ati wiwa';

  @override
  String get formSectionAdditionalInfo => 'Alaye afikun';

  @override
  String get fieldHintEnergyMode =>
      'Fi iye agbara sii fun ẹgbẹ kọọkan ti ẹranko?';

  @override
  String get fieldLabelAdultPigs => 'Ẹlẹdẹ agbalagba';

  @override
  String get fieldLabelGrowingPigs => 'Ẹlẹdẹ to ndagba';

  @override
  String get fieldLabelPoultry => 'Adie';

  @override
  String get fieldLabelRabbit => 'Ehoro';

  @override
  String get fieldLabelRuminant => 'Ruminant';

  @override
  String get fieldLabelFish => 'Eja';

  @override
  String get fieldLabelCreatedBy => 'Ti a ṣẹda nipasẹ';

  @override
  String get fieldLabelNotes => 'Awọn akọsilẹ';

  @override
  String get customIngredientHeader => 'Ṣiṣẹda Eroja Aṣa';

  @override
  String get customIngredientDescription =>
      'O le fi eroja tirẹ kun pẹlu awọn iye to jẹ aládàáṣiṣẹ';

  @override
  String get newIngredientTitle => 'Eroja Tuntun';

  @override
  String get fieldLabelFeedName => 'Orukọ Ounjẹ';

  @override
  String get fieldLabelAnimalType => 'Iru Ẹranko';

  @override
  String get fieldLabelProductionStage => 'Ipele iṣelọpọ';

  @override
  String ingredientAddedSuccessTitle(String name) {
    return '$name ti fi kun';
  }

  @override
  String get ingredientAddedSuccessMessage => 'Ṣe o fẹ fi eroja miiran kun?';

  @override
  String get ingredientAddedNo => 'Rara, Pada';

  @override
  String get ingredientAddedYes => 'Bẹẹni, Tẹsiwaju';

  @override
  String customIngredientsHeader(int count) {
    return 'Awọn Eroja Aṣa Rẹ ($count)';
  }

  @override
  String get customIngredientsSearchHint => 'Wa awọn eroja aṣa rẹ...';

  @override
  String get customIngredientsEmptyTitle => 'Ko si eroja aṣa sibẹ';

  @override
  String get customIngredientsEmptySubtitle => 'Ṣẹda eroja aṣa akọkọ rẹ!';

  @override
  String get customIngredientsNoMatch => 'Ko si eroja ti o baamu wiwa rẹ';

  @override
  String labelCreatedBy(String creator) {
    return 'nipasẹ $creator';
  }

  @override
  String get labelNotes => 'Awọn akọsilẹ:';

  @override
  String get labelPriceHistory => 'Itan idiyele';

  @override
  String get labelCa => 'Ca';

  @override
  String get labelP => 'P';

  @override
  String get priceHistoryEmpty => 'Ko si itan idiyele';

  @override
  String get priceHistoryError => 'Ko le gbe itan idiyele';

  @override
  String get deleteCustomIngredientTitle => 'Pa \"null\" rẹ?';

  @override
  String deleteCustomIngredientMessage(String name) {
    return 'Ṣe o da ọ loju pe o fẹ pa eroja aṣa yii?';
  }

  @override
  String ingredientRemovedSuccess(String name) {
    return '$name ti yọ';
  }

  @override
  String get exportFormatTitle => 'Ọna kika Ikọja';

  @override
  String get exportFormatMessage => 'Yan ọna kika ikọja fun awọn eroja aṣa rẹ:';

  @override
  String get exportingToJson => 'N kọja si JSON...';

  @override
  String get exportingToCsv => 'N kọja si CSV...';

  @override
  String get exportFailed => 'Ikọja kuna';

  @override
  String exportFailedWithError(String error) {
    return 'Ikọja kuna: $error';
  }

  @override
  String get importCustomIngredientsTitle => 'Gbe Awọn Eroja Aṣa Wọle';

  @override
  String get importFormatMessage => 'Yan ọna kika faili lati gbe wọle:';

  @override
  String get importingData => 'N gbe data wọle...';

  @override
  String get importSuccessTitle => 'Gbigbe wọle ṣaṣeyọri';

  @override
  String get importFailedTitle => 'Gbigbe wọle kuna';

  @override
  String importError(String error) {
    return 'Aṣiṣe: $error';
  }

  @override
  String get actionJson => 'JSON';

  @override
  String get actionCsv => 'CSV';

  @override
  String get labelIngredient => 'Eroja';

  @override
  String get actionShare => 'Share';

  @override
  String get exportingToPdf => 'Exporting to PDF...';

  @override
  String missingPriceWarning(int count) {
    return 'Iye kò sì fun $count nukan; lo iye aarin.';
  }

  @override
  String get addMoreIngredientsRecommendation =>
      'Safikan nukan pupo (a gbà 3-5 lẹwa) láti ni iranlowoọ diẹ nin pese awon eka iso nutiriennti.';

  @override
  String get tightenedConstraintsRecommendation =>
      'Awon eka iso nutiriennti maa se gidigidi julo fun awon nukan tó ya. Gbiyanju láti tun awon igunguni min/max kà tó 5-10% dii.';

  @override
  String get addHigherNutrientIngredientsRecommendation =>
      'Tabini ni ó, safikan awon nukan tó ni iye nutiriennti giga julo ninu awon nutiriennti tó nipesun.';

  @override
  String conflictingConstraintsError(String min, String max) {
    return 'Ikekiji ($min) je ti ó ju maximum ($max) lo. Jowo tun gbẹ yii.';
  }

  @override
  String narrowRangeWarning(String range) {
    return 'Are kekere gidigidi ($range). Gbiyanju láti tun un kà tó 10-20% dii.';
  }

  @override
  String nutrientCoverageIssue(String max, String min, String nutrient) {
    return 'Maximum tó wa ninu nukan ni $max, sugbun ikekiji pelu ni $min. Dinuku ape tabi yan awon nukan tó ni $nutrient giga julo.';
  }

  @override
  String get lowInclusionLimitsWarning =>
      'Awon nukan tówopu ni awon igunguni tó kekere gidigidi. Safikan awon nukan ayida láti dapad à awon àpo.';

  @override
  String totalInclusionLimitWarning(String total) {
    return 'Toto maximum tó lè wa fun nukan tó ya ni $total%. Safikan gidigidi nukan tabi tin awon igunguni.';
  }
}
