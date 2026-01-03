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
  String get actionRefresh => 'Onesha Upya';

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
  String get actionReset => 'Rejezesha';

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
  String get confirmDelete => 'Futa';

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
  String get regionAll => 'Zote';

  @override
  String get regionAfrica => 'Afrika';

  @override
  String get regionAsia => 'Azia';

  @override
  String get regionEurope => 'Uropa';

  @override
  String get regionAmericas => 'Amerika';

  @override
  String get regionOceania => 'Okinoya';

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
  String get unitKcal => 'Kcal';

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
  String get addFeedTitle => 'Ongeza/Angalia Chakula';

  @override
  String get updateFeedTitle => 'Sasisha Chakula';

  @override
  String get actionAddIngredients => 'Ongeza Vijenzi';

  @override
  String get tooltipAddIngredients => 'Ongeza vijenzi zaidi kwa chakula';

  @override
  String get tooltipSaveFeed => 'Hifadhi chakula';

  @override
  String get tooltipUpdateFeed => 'Sasisha chakula';

  @override
  String get actionAnalyse => 'Chunguza';

  @override
  String get tooltipAnalyseFeed => 'Chunguza muundo wa chakula';

  @override
  String get errorFeedNameRequired => 'Jina la Chakula Linahitajika';

  @override
  String get errorFeedNameMessage =>
      'Tafadhali weka jina la chakula chako kabla ya kuhifadhi.';

  @override
  String get errorMissingFeedName => 'Jina la Chakula Halijawekwa';

  @override
  String get errorMissingFeedNameMessage =>
      'Tafadhali weka jina la chakula kabla ya kuchunguza.';

  @override
  String get errorNoIngredients => 'Hakuna Vijenzi';

  @override
  String get errorNoIngredientsMessage =>
      'Tafadhali ongeza angalau kijenzi kimoja ili kuchunguza.';

  @override
  String get errorInvalidQuantities => 'Kiasi Kisicho Sahihi';

  @override
  String get errorInvalidQuantitiesMessage =>
      'Vijenzi vyote lazima viwe na kiasi sahihi kikubwa kuliko 0.';

  @override
  String get errorGenericTitle => 'Kosa Limetokea';

  @override
  String get errorGenericMessage => 'Tafadhali jaribu tena.';

  @override
  String get actionOk => 'SAWA';

  @override
  String get analyseDialogTitle => 'Chunguza Muundo wa Chakula';

  @override
  String analyseDialogMessageNew(String feedName) {
    return 'Angalia uchambuzi wa lishe la \"$feedName\" bila kuhifadhi.';
  }

  @override
  String analyseDialogMessageUpdate(String feedName) {
    return 'Angalia uchambuzi wa lishe la \"$feedName\" bila kusasisha.';
  }

  @override
  String get analyseDialogPreviewNote =>
      'Hii ni hakiki ya awali. Unaweza kuhifadhi baadaye.';

  @override
  String get analyseDialogNoSaveNote => 'Mabadiliko hayatahifadhiwa.';

  @override
  String get analyseDialogFailedMessage =>
      'Uchambuzi wa chakula umeshindwa. Tafadhali jaribu tena.';

  @override
  String get reportTitleEstimate => 'Uchambuzi wa Kadiria';

  @override
  String get reportTitleAnalysis => 'Ripoti ya Uchambuzi';

  @override
  String get nutrientDigestiveEnergy => 'Nishati ya Kuchovya';

  @override
  String get nutrientMetabolicEnergy => 'Nishati ya Kimetaboliki';

  @override
  String get nutrientCrudeProtein => 'Protini Ghafi';

  @override
  String get nutrientCrudeFiber => 'Nyuzi Ghafi';

  @override
  String get nutrientCrudeFat => 'Mafuta Ghafi';

  @override
  String get nutrientCalcium => 'Kalisiamu';

  @override
  String get nutrientPhosphorus => 'Phosphorasi';

  @override
  String get nutrientLysine => 'Lysine';

  @override
  String get nutrientMethionine => 'Methionine';

  @override
  String get nutrientAsh => 'Majivu';

  @override
  String get nutrientMoisture => 'Unyevunyevu';

  @override
  String get nutrientAvailablePhosphorus => 'Phosph. Inapatikana';

  @override
  String get nutrientTotalPhosphorus => 'Phosph. Jumla';

  @override
  String get nutrientPhytatePhosphorus => 'Phosph. Phytate';

  @override
  String get unitPercent => '%';

  @override
  String get unitGramPerKg => 'g/Kg';

  @override
  String get aminoAcidProfileTitle => 'Profaili ya Asidi ya Amino';

  @override
  String get aminoAcidSidLabel => 'SID (Inayoweza Kuchovya)';

  @override
  String get aminoAcidTotalLabel => 'Jumla';

  @override
  String get aminoAcidSidButton => 'SID';

  @override
  String get aminoAcidTotalButton => 'Jumla';

  @override
  String get aminoAcidTableHeaderName => 'Asidi ya Amino';

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
      'SID = Uchovyo wa Ileal Uliowekwa Viwango (kiwango cha sekta)';

  @override
  String get aminoAcidTotalInfo => 'Asidi za amino jumla (si zote zinachovywa)';

  @override
  String get aminoAcidLoadError => 'Kosa la kupakia data ya asidi ya amino';

  @override
  String get warningsCardTitle => 'Maonyo na Mapendekezo';

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
    return 'Ebena Feed Estimator | $feedName Hakiki ya Kuchapisha';
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
