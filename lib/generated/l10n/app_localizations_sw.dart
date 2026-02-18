// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swahili (`sw`).
class AppLocalizationsSw extends AppLocalizations {
  AppLocalizationsSw([String locale = 'sw']) : super(locale);

  @override
  String get appTitle => 'Feed Estimator';

  @override
  String get appDescription => 'Lugha ya uongezaji wa chakula cha mifugo';

  @override
  String get navHome => 'Nyumbani';

  @override
  String get navFeeds => 'Chakula Changu';

  @override
  String get navIngredients => 'Vipengele';

  @override
  String get navSettings => 'Mipango';

  @override
  String get navAbout => 'Kuhusu';

  @override
  String get navFeedFormulator => 'Formulator';

  @override
  String get screenTitleHome => 'Uandaaji wa Chakula';

  @override
  String get screenTitleIngredientLibrary => 'Maktaba ya Vipengele';

  @override
  String get screenTitleNewFeed => 'Tengeneza Chakula';

  @override
  String get screenTitleReports => 'Uchambuzi';

  @override
  String get screenTitleSettings => 'Mipango';

  @override
  String get screenTitleAbout => 'Kuhusu Feed Estimator';

  @override
  String get screenTitleImportWizard => 'Mchawi wa Uingizaji';

  @override
  String get screenTitleFeedFormulator => 'Feed Formulator';

  @override
  String get actionCreate => 'Tengeneza';

  @override
  String get actionSave => 'Hifadhi';

  @override
  String get actionUpdate => 'Sasisha';

  @override
  String get actionDelete => 'Futa';

  @override
  String get actionCancel => 'Ghairi';

  @override
  String get actionAdd => 'Ongeza';

  @override
  String get actionAddNew => 'Ongeza Mpya';

  @override
  String get actionRefresh => 'Pakia Tena';

  @override
  String get actionEdit => 'Hariri';

  @override
  String get actionRemove => 'Ondoa';

  @override
  String get actionRetry => 'Jaribu Tena';

  @override
  String get actionViewReport => 'Tazama Ripoti';

  @override
  String get actionClear => 'Futa';

  @override
  String get actionClearFilters => 'Futa Vichujio';

  @override
  String get actionSaveChanges => 'Hifadhi Mabadiliko';

  @override
  String get actionReset => 'Weka Upya';

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
  String get homeEmptyTitle => 'Hakuna Chakula Bado';

  @override
  String get homeEmptySubtitle => 'Unda muundo wako wa kwanza wa chakula';

  @override
  String get homeCreateFeed => 'Unda Chakula';

  @override
  String get homeAddFeed => 'Ongeza Chakula';

  @override
  String homeLoadFailed(String error) {
    return 'Imeshindwa kupakia chakula: $error';
  }

  @override
  String get homeLoadingFeeds => 'Inapakia chakula...';

  @override
  String get feedListEmpty => 'Hakuna Chakula Kilichopatikana';

  @override
  String get feedsLoadFailed => 'Imeshindwa kupakia chakula';

  @override
  String get feedsEmptyStateTitle => 'Hakuna chakula kilipatikana';

  @override
  String get feedNameUnknown => 'Chakula Kisichojulikana';

  @override
  String feedSubtitle(String animalType) {
    return 'Chakula cha $animalType';
  }

  @override
  String feedDeleteTitle(String feedName) {
    return 'Futa \"$feedName\"?';
  }

  @override
  String get confirmDeletionWarning => 'Hatua hii haiwezi kutenguka.';

  @override
  String get feedStoreTitle => 'Chakula katika Ghala';

  @override
  String get feedStorePlaceholder => 'Chakula kilichohifadhiwa hapa';

  @override
  String get ingredientSelectedLabel => 'Kiambata Kilichochaguliwa';

  @override
  String get ingredientSelectLabel => 'Chagua Kiambata';

  @override
  String get ingredientSelectTitle => 'Chagua Kiambata';

  @override
  String get ingredientSearchHint => 'Tafuta kwa jina...';

  @override
  String get ingredientNameUnknown => 'Haijulikani';

  @override
  String ingredientAvailableQty(String qty) {
    return '$qty kg zinapatikana';
  }

  @override
  String ingredientPricePerKg(String price) {
    return '$price/kg';
  }

  @override
  String get ingredientsLoadFailed => 'Imeshindwa kupakia viambata';

  @override
  String get ingredientsEmptyTitle => 'Hakuna viambata vilivyopatikana';

  @override
  String get ingredientsEmptySubtitle => 'Ongeza viambata ili kuanza';

  @override
  String get ingredientsEmptyFilteredTitle =>
      'Hakuna viambata vinavyolingana na vichujio vyako';

  @override
  String get ingredientsEmptyFilteredSubtitle =>
      'Jaribu kurekebisha utafutaji au vichujio vyako';

  @override
  String get noIngredientsSelected => 'Hakuna viungo vilivyochaguliwa bado';

  @override
  String get selectedIngredients => 'Viungo Vilivyochaguliwa';

  @override
  String get filterFavorites => 'Vipendwa';

  @override
  String get filterCustom => 'Maalum';

  @override
  String filterRegionLabel(String region) {
    return 'Mkoa: $region';
  }

  @override
  String get fallbackUnknownSymbol => '?';

  @override
  String get actionClose => 'Funga';

  @override
  String get actionExport => 'Hamisha';

  @override
  String get actionImport => 'Ingiza';

  @override
  String get labelName => 'Jina';

  @override
  String get labelPrice => 'Bei';

  @override
  String get labelQuantity => 'Kiasi';

  @override
  String get labelCategory => 'Aina';

  @override
  String get labelRegion => 'Eneo';

  @override
  String get labelProtein => 'Protini';

  @override
  String get labelFat => 'Mafuta';

  @override
  String get labelFiber => 'Nyuzi';

  @override
  String get labelCalcium => 'Kalisiamu';

  @override
  String get labelPhosphorus => 'Fosfoni';

  @override
  String get labelEnergy => 'Nishati';

  @override
  String get labelCost => 'Gharama';

  @override
  String get labelTotal => 'Jumla';

  @override
  String get hintEnterName => 'k.m., Chakula cha Kuku';

  @override
  String get hintEnterPrice => '10.50';

  @override
  String get hintEnterQuantity => '100';

  @override
  String get hintSearch => 'Tafuta vipengele...';

  @override
  String get hintSelectIngredient => 'Gusa kuchagua kipengele';

  @override
  String errorRequired(String field) {
    return '$field inahitajika';
  }

  @override
  String get errorInvalidPrice => 'Ingiza bei sahihi (k.m., 10.50)';

  @override
  String get errorInvalidQuantity => 'Ingiza kiasi sahihi (k.m., 100)';

  @override
  String get errorPriceNegative => 'Bei haiwezi kuwa hasi';

  @override
  String get errorQuantityZero => 'Kiasi lazima kiwe zaidi ya 0';

  @override
  String get errorNameTooShort => 'Jina lazima liwe na angalau herufi 3';

  @override
  String get errorNameTooLong => 'Jina lazima liwe chini ya herufi 50';

  @override
  String errorUnique(String field) {
    return '$field tayari ipo';
  }

  @override
  String get errorDatabaseOperation =>
      'Operesheni ya hifadhidata imeshindwa. Jaribu tena.';

  @override
  String get errorNetworkError =>
      'Hitilafu ya mtandao. Tafadhali angalia muunganisho wako.';

  @override
  String messageCreatedSuccessfully(String item) {
    return '$item ilikuwa imetengenezwa kwa mafanikio';
  }

  @override
  String messageUpdatedSuccessfully(String item) {
    return '$item imesasishwa kwa mafanikio';
  }

  @override
  String messageDeletedSuccessfully(String item) {
    return '$item imefutwa kwa mafanikio';
  }

  @override
  String get messageLoading => 'Inapakia...';

  @override
  String get messageNoData => 'Hakuna data inayopatikana';

  @override
  String messageEmpty(String item) {
    return 'Hakuna $item imeongezwa bado';
  }

  @override
  String confirmDelete(String item) {
    return 'Futa $item?';
  }

  @override
  String get confirmDeleteDescription => 'Hatua hii haiwezi kufanywa upya.';

  @override
  String get animalTypePig => 'Nguruwe';

  @override
  String get animalTypePoultry => 'Kuku';

  @override
  String get animalTypeRabbit => 'Sungura';

  @override
  String get animalTypeRuminant => 'Mifugaji';

  @override
  String get animalTypeFish => 'Samaki';

  @override
  String get regionAll => 'Maeneo Yote';

  @override
  String get regionAfrica => 'Afrika';

  @override
  String get regionAsia => 'Asia';

  @override
  String get regionEurope => 'Ulaya';

  @override
  String get regionAmericas => 'Amerika';

  @override
  String get regionOceania => 'Oceania';

  @override
  String get regionGlobal => 'Ulimwengu';

  @override
  String get filterBy => 'Chuja Kwa';

  @override
  String get sortBy => 'Panga Kwa';

  @override
  String get sortByName => 'Jina';

  @override
  String get sortByPrice => 'Bei';

  @override
  String get sortByRegion => 'Eneo';

  @override
  String get unitKg => 'kg';

  @override
  String get unitG => 'g';

  @override
  String get unitLb => 'lb';

  @override
  String get unitTon => 'tani';

  @override
  String get unitKcal => 'kcal/kg';

  @override
  String get settingLanguage => 'Lugha';

  @override
  String get settingTheme => 'Mandhari';

  @override
  String get settingNotifications => 'Arifa';

  @override
  String get settingAbout => 'Kuhusu';

  @override
  String aboutVersion(String version) {
    return 'Toleo $version';
  }

  @override
  String get aboutPrivacy => 'Sera ya Faragha';

  @override
  String get aboutTerms => 'Masharti ya Huduma';

  @override
  String get aboutDeveloper => 'Iliyoendekezwa kwa wakulima wa mifugo';

  @override
  String get aboutContribution => 'Maoni yako husaidia sisi kuboresha';

  @override
  String get settingsTitle => 'Mipango';

  @override
  String get settingsSectionLanguage => 'Lugha';

  @override
  String get settingsSectionPrivacy => 'Faragha na Data';

  @override
  String get settingsSectionDataManagement => 'Usimamizi wa Data';

  @override
  String get settingsSectionLegal => 'Kisheria';

  @override
  String get settingsSelectLanguage => 'Chagua Lugha';

  @override
  String settingsLanguageLimitedUI(String language) {
    return '$language (Kiolesura cha mfumo kilichowezeshwa)';
  }

  @override
  String get settingsDataConsent => 'Idhini ya Ukusanyaji wa Data';

  @override
  String get settingsConsentGranted => 'Umeidhinisha ukusanyaji wa data';

  @override
  String get settingsConsentNotGranted => 'Hujaidhinisha';

  @override
  String get settingsConsentDate => 'Tarehe ya Idhini';

  @override
  String get settingsPrivacyPolicy => 'Sera ya Faragha';

  @override
  String get settingsPrivacyPolicySubtitle => 'Tazama sera yetu ya faragha';

  @override
  String get settingsFeedFormulations => 'Miundo ya Chakula';

  @override
  String get settingsCustomIngredients => 'Vipengele Maalum';

  @override
  String get settingsDatabaseSize => 'Ukubwa wa Hifadhidata';

  @override
  String get settingsExportData => 'Hamisha Data';

  @override
  String get settingsExportDataSubtitle => 'Hifadhi nakala ya data yako yote';

  @override
  String get settingsImportData => 'Leta Data';

  @override
  String get settingsImportDataSubtitle => 'Rejesha kutoka kwa nakala';

  @override
  String get settingsDeleteData => 'Futa Data Yote';

  @override
  String get settingsDeleteDataSubtitle => 'Futa kila kitu kabisa';

  @override
  String get settingsVersion => 'Toleo';

  @override
  String get settingsRateApp => 'Kadiria Programu';

  @override
  String get settingsRateAppSubtitle => 'Shiriki maoni yako';

  @override
  String get settingsLicenses => 'Leseni za Chanzo Wazi';

  @override
  String get settingsTermsOfService => 'Masharti ya Huduma';

  @override
  String get settingsTermsComingSoon => 'Inakuja hivi karibuni';

  @override
  String get settingsDataSafety => 'Usalama wa Data';

  @override
  String get settingsDataSafetySubtitle => 'Data yako imehifadhiwa ndani';

  @override
  String get settingsFooter => 'Imetengenezwa kwa ❤️ kwa wakulima wa mifugo';

  @override
  String get settingsExporting => 'Inahamisha data...';

  @override
  String get settingsExportSuccess => 'Uhamishaji Umefanikiwa';

  @override
  String get settingsExportSuccessMessage =>
      'Nakala yako imeundwa kwa mafanikio!';

  @override
  String get settingsRevokeConsentTitle => 'Futa Idhini';

  @override
  String get settingsRevokeConsentMessage =>
      'Una uhakika unataka kufuta idhini yako? Hii haitafuta data yako, lakini unakubali kwamba hukubali tena ukusanyaji wa data.';

  @override
  String settingsLanguageUpdated(String language) {
    return 'Lugha imesasishwa hadi $language';
  }

  @override
  String get ingredientLibraryTitle => 'Maktaba ya Vijenzi';

  @override
  String get manageInventoryTitle => 'SIMAMIA HIFADHI';

  @override
  String get customIngredientsTitle => 'Vijenzi vya Kawaida';

  @override
  String get updateDetailsTitle => 'Sasisha Maelezo';

  @override
  String get labelFavorite => 'Pendwa';

  @override
  String get labelAddToFavorites => 'Ongeza kwa mapendwa';

  @override
  String get labelPricePerKg => 'Bei kwa kg';

  @override
  String get labelAvailableQty => 'Kiasi Kinachopo (kg)';

  @override
  String get actionPriceHistory => 'Historia ya Bei';

  @override
  String get deleteIngredientTitle => 'Futa Kijinzi?';

  @override
  String get deleteIngredientMessage =>
      'Hii itafuta kijinzi hiki kabisa mula kwenye maktaba yako. Hatua hii haiwezi kurudishwa.';

  @override
  String get confirmCancel => 'Ghairi';

  @override
  String get successIngredientUpdated => 'Kijinzi kimesasishwa kwa mafanikio';

  @override
  String errorSaveFailed(String error) {
    return 'Kushindwa kuhifadhi: $error';
  }

  @override
  String get successIngredientDeleted => 'Kijinzi kimefutwa';

  @override
  String errorDeleteFailed(String error) {
    return 'Kushindwa kufuta: $error';
  }

  @override
  String get errorPriceGreaterThanZero => 'Lazima kuwa > 0';

  @override
  String get errorQuantityGreaterOrEqual => 'Lazima kuwa ≥ 0';

  @override
  String get addFeedTitle => 'Ongeza/Kagua Lishe';

  @override
  String get updateFeedTitle => 'Sasisha Lishe';

  @override
  String get actionAddIngredients => 'Ongeza Vijenzi';

  @override
  String get tooltipAddIngredients => 'Ongeza vijenzi zaidi kwenye lishe';

  @override
  String get tooltipSaveFeed => 'Hifadhi lishe';

  @override
  String get tooltipUpdateFeed => 'Sasisha lishe';

  @override
  String get actionAnalyse => 'Changanua';

  @override
  String get tooltipAnalyseFeed => 'Changanua muundo wa lishe';

  @override
  String get errorFeedNameRequired => 'Jina la Lishe Linahitajika';

  @override
  String get errorFeedNameMessage =>
      'Tafadhali weka jina la lishe kabla ya kuhifadhi.';

  @override
  String get errorMissingFeedName => 'Jina la Lishe Halipo';

  @override
  String get errorMissingFeedNameMessage =>
      'Tafadhali weka jina la lishe kabla ya uchanganuzi.';

  @override
  String get errorNoIngredients => 'Hakuna Vijenzi';

  @override
  String get errorNoIngredientsMessage =>
      'Tafadhali ongeza kiunzi kimoja kwa uchanganuzi.';

  @override
  String get errorInvalidQuantities => 'Viwango Batili';

  @override
  String get errorInvalidQuantitiesMessage =>
      'Kila kiunzi kinapaswa kuwa na kiasi halali zaidi ya 0.';

  @override
  String get errorGenericTitle => 'Tatizo Limetokea';

  @override
  String get errorGenericMessage => 'Tafadhali jaribu tena.';

  @override
  String get actionOk => 'Sawa';

  @override
  String get analyseDialogTitle => 'Changanua Muundo wa Lishe';

  @override
  String analyseDialogMessageNew(String feedName) {
    return 'Tazama uchanganuzi wa kina kwa \"$feedName\" bila kuhifadhi.';
  }

  @override
  String analyseDialogMessageUpdate(String feedName) {
    return 'Tazama uchanganuzi wa kina kwa \"$feedName\" bila kusasisha.';
  }

  @override
  String get analyseDialogPreviewNote =>
      'Hii ni onyesho la mapema. Unaweza kuhifadhi baadaye.';

  @override
  String get analyseDialogNoSaveNote => 'Mabadiliko hayatahifadhiwa.';

  @override
  String get analyseDialogFailedMessage =>
      'Uchanganuzi wa lishe umeshindwa. Tafadhali jaribu tena.';

  @override
  String get reportTitleEstimate => 'Uchanganuzi Uliokadiriwa';

  @override
  String get reportTitleAnalysis => 'Ripoti ya Uchanganuzi';

  @override
  String get nutrientDigestiveEnergy => 'Nishati Inayomeng’enywa';

  @override
  String get nutrientMetabolicEnergy => 'Nishati Kimetaboliki';

  @override
  String get nutrientCrudeProtein => 'Protini Ghafi';

  @override
  String get nutrientCrudeFiber => 'Nyuzi Ghafi';

  @override
  String get nutrientCrudeFat => 'Mafuta Ghafi';

  @override
  String get nutrientCalcium => 'Kalsiamu';

  @override
  String get nutrientPhosphorus => 'Fosforasi';

  @override
  String get nutrientLysine => 'Lysine';

  @override
  String get nutrientMethionine => 'Methionine';

  @override
  String get nutrientAsh => 'Majivu';

  @override
  String get nutrientMoisture => 'Unyevu';

  @override
  String get nutrientAvailablePhosphorus => 'Fosforasi Inayopatikana';

  @override
  String get nutrientTotalPhosphorus => 'Fosforasi Jumla';

  @override
  String get nutrientPhytatePhosphorus => 'Fosforasi ya Faiti';

  @override
  String get unitPercent => '%';

  @override
  String get unitGramPerKg => 'g/Kg';

  @override
  String get aminoAcidProfileTitle => 'Profaili ya Amino Asidi';

  @override
  String get aminoAcidSidLabel => 'SID (Inayomeng’enywa)';

  @override
  String get aminoAcidTotalLabel => 'Jumla';

  @override
  String get aminoAcidSidButton => 'SID';

  @override
  String get aminoAcidTotalButton => 'Jumla';

  @override
  String get aminoAcidTableHeaderName => 'Amino Asidi';

  @override
  String get aminoAcidTableHeaderContent => 'Yaliyomo (%)';

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
      'SID = Usagaji wa utumbo mdogo uliosanifiwa (kiwango cha tasnia)';

  @override
  String get aminoAcidTotalInfo => 'Amino asidi jumla (si zote zinayeyuka)';

  @override
  String get aminoAcidLoadError => 'Hitilafu kupakia data ya amino asidi';

  @override
  String get warningsCardTitle => 'Onyo na Mapendekezo';

  @override
  String warningsCardIssueCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count shida zimepatikana',
      one: 'Shida 1 imepatikana',
    );
    return '$_temp0';
  }

  @override
  String pdfPreviewTitle(String feedName) {
    return 'Ebena Feed Estimator | $feedName Print Preview';
  }

  @override
  String get formSectionBasicInfo => 'Taarifa za Msingi';

  @override
  String get formSectionEnergyValues => 'Thamani za Nishati';

  @override
  String get formSectionMacronutrients => 'Virutubishi Vikuu';

  @override
  String get formSectionMicronutrients => 'Virutubishi Vidogo';

  @override
  String get formSectionCostAvailability => 'Gharama na Upatikanaji';

  @override
  String get formSectionAdditionalInfo => 'Taarifa za Ziada';

  @override
  String get fieldHintEnergyMode =>
      'Ingiza thamani za nishati kwa kila kundi maalum la wanyama?';

  @override
  String get fieldLabelAdultPigs => 'Nguruwe wakubwa';

  @override
  String get fieldLabelGrowingPigs => 'Nguruwe wanaokua';

  @override
  String get fieldLabelPoultry => 'Kuku';

  @override
  String get fieldLabelRabbit => 'Sungura';

  @override
  String get fieldLabelRuminant => 'Wanyama wanaocheua';

  @override
  String get fieldLabelFish => 'Samaki';

  @override
  String get fieldLabelCreatedBy => 'Imeundwa na';

  @override
  String get fieldLabelNotes => 'Maelezo';

  @override
  String get customIngredientHeader => 'Kutengeneza Kiungo Maalum';

  @override
  String get customIngredientDescription =>
      'Unaweza kuongeza kiungo chako mwenyewe chenye thamani maalum za lishe';

  @override
  String get newIngredientTitle => 'Kiungo Kipya';

  @override
  String get fieldLabelFeedName => 'Jina la Chakula';

  @override
  String get fieldLabelAnimalType => 'Aina ya Mnyama';

  @override
  String get fieldLabelProductionStage => 'Hatua ya Uzalishaji';

  @override
  String ingredientAddedSuccessTitle(String name) {
    return '$name imeongezwa';
  }

  @override
  String get ingredientAddedSuccessMessage =>
      'Ungependa kuongeza kiungo kingine?';

  @override
  String get ingredientAddedNo => 'Hapana, Rudi';

  @override
  String get ingredientAddedYes => 'Ndiyo, Endelea';

  @override
  String customIngredientsHeader(int count) {
    return 'Viungo Vyako Maalum ($count)';
  }

  @override
  String get customIngredientsSearchHint => 'Tafuta viungo vyako maalum...';

  @override
  String get customIngredientsEmptyTitle => 'Bado hakuna viungo maalum';

  @override
  String get customIngredientsEmptySubtitle =>
      'Tengeneza kiungo chako cha kwanza!';

  @override
  String get customIngredientsNoMatch =>
      'Hakuna kiungo kinacholingana na utafutaji wako';

  @override
  String labelCreatedBy(String creator) {
    return 'na $creator';
  }

  @override
  String get labelNotes => 'Maelezo:';

  @override
  String get labelPriceHistory => 'Historia ya Bei';

  @override
  String get labelCa => 'Ca';

  @override
  String get labelP => 'P';

  @override
  String get priceHistoryEmpty => 'Hakuna historia ya bei';

  @override
  String get priceHistoryError => 'Imeshindikana kupakia historia ya bei';

  @override
  String get deleteCustomIngredientTitle => 'Futa \"null\"?';

  @override
  String deleteCustomIngredientMessage(String name) {
    return 'Una uhakika unataka kufuta kiungo hiki maalum?';
  }

  @override
  String ingredientRemovedSuccess(String name) {
    return '$name kimeondolewa';
  }

  @override
  String get exportFormatTitle => 'Muundo wa Kuhamisha';

  @override
  String get exportFormatMessage =>
      'Chagua muundo wa kuhamisha kwa viungo vyako maalum:';

  @override
  String get exportingToJson => 'Inahamishwa kwenda JSON...';

  @override
  String get exportingToCsv => 'Inahamishwa kwenda CSV...';

  @override
  String get exportFailed => 'Uhamisho umeshindikana';

  @override
  String exportFailedWithError(String error) {
    return 'Uhamisho umeshindikana: $error';
  }

  @override
  String get importCustomIngredientsTitle => 'Ingiza Viungo Maalum';

  @override
  String get importFormatMessage => 'Chagua muundo wa faili wa kuingiza:';

  @override
  String get importingData => 'Inaingiza data...';

  @override
  String get importSuccessTitle => 'Uingizaji Umefaulu';

  @override
  String get importFailedTitle => 'Uingizaji Umeshindikana';

  @override
  String importError(String error) {
    return 'Hitilafu: $error';
  }

  @override
  String get actionJson => 'JSON';

  @override
  String get actionCsv => 'CSV';

  @override
  String get labelIngredient => 'Kiungo';

  @override
  String get actionShare => 'Share';

  @override
  String get exportingToPdf => 'Exporting to PDF...';

  @override
  String missingPriceWarning(int count) {
    return 'Fare inayokosea kwa $count vijenzi; kutumia bei wastani.';
  }

  @override
  String get addMoreIngredientsRecommendation =>
      'Ongeza vijenzi zaidi (angalau 3-5 inayopendekezwa) kwa njia nyingi zaidi ya kukidhi lengo la dafu.';

  @override
  String get tightenedConstraintsRecommendation =>
      'Mahitaji ya virutubishi yanaweza kuwa madhambaa sana kwa vijenzi vilivyochaguliwa. Jaribu kupanua kiwango cha min/max kwa 5-10%.';

  @override
  String get addHigherNutrientIngredientsRecommendation =>
      'Badala yake, ongeza vijenzi vya uzani wa virutubishi zaidi katika virutubishi vya vikwazo.';

  @override
  String conflictingConstraintsError(String min, String max) {
    return 'Minimal ($min) inazidi zaidi ya upeo ($max). Tafadhali sahihisha hii.';
  }

  @override
  String narrowRangeWarning(String range) {
    return 'Kiwango ni nyembamba sana ($range). Jaribu kupanua kwa 10-20%.';
  }

  @override
  String nutrientCoverageIssue(String max, String min, String nutrient) {
    return 'Kupitia vijenzi ni $max, lakini kiwango kidogo kinachohitajika ni $min. Punguza mahitaji au chagua vijenzi vya $nutrient zaidi.';
  }

  @override
  String get lowInclusionLimitsWarning =>
      'Vijenzi kadhaa vina kiwango cha chini sana cha upeo wa pamoja. Ongeza vijenzi vya aina tofauti ili kusarili vikwazo.';

  @override
  String totalInclusionLimitWarning(String total) {
    return 'Jumla ya upeo wa pamoja wa vijenzi vilivyochaguliwa ni $total%. Ongeza vijenzi zaidi au kuongeza kiwango cha mtu binafsi.';
  }
}
