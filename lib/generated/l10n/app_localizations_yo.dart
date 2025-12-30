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
  String get actionCreate => 'Ṣẹda';

  @override
  String get actionSave => 'Fi Pamọ';

  @override
  String get actionUpdate => 'Tun';

  @override
  String get actionDelete => 'Pa';

  @override
  String get actionCancel => 'Fagile';

  @override
  String get actionAdd => 'Ṣafikun';

  @override
  String get actionAddNew => 'Fi Kan Tuntun';

  @override
  String get actionRefresh => 'Inu tun';

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
  String get actionSaveChanges => 'Fi Pamọ Ayipada';

  @override
  String get actionReset => 'Tun';

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
  String get confirmDelete => 'Pa';

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
  String get regionAll => 'Gbogbo';

  @override
  String get regionAfrica => 'Afirika';

  @override
  String get regionAsia => 'Asia';

  @override
  String get regionEurope => 'Europa';

  @override
  String get regionAmericas => 'Amerika';

  @override
  String get regionOceania => 'Oṣean';

  @override
  String get regionGlobal => 'Agbaye';

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
  String get unitKcal => 'Kcal';

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
