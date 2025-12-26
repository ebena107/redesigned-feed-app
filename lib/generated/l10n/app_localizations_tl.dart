// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tagalog (`tl`).
class AppLocalizationsTl extends AppLocalizations {
  AppLocalizationsTl([String locale = 'tl']) : super(locale);

  @override
  String get appTitle => 'Feed Estimator';

  @override
  String get appDescription => 'Optimizer ng pagbuo ng pagkain ng hayop';

  @override
  String get navHome => 'Tahanan';

  @override
  String get navFeeds => 'Aking mga Pagkain';

  @override
  String get navIngredients => 'Sangkap';

  @override
  String get navSettings => 'Mga Ayos';

  @override
  String get navAbout => 'Tungkol sa amin';

  @override
  String get screenTitleHome => 'Pagbuo ng Pagkain';

  @override
  String get screenTitleIngredientLibrary => 'Aklat ng Sangkap';

  @override
  String get screenTitleNewFeed => 'Lumikha ng Pagkain';

  @override
  String get screenTitleReports => 'Analisis';

  @override
  String get screenTitleSettings => 'Mga Ayos';

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
  String get actionEdit => 'Baguhin';

  @override
  String get actionRemove => 'Alisin';

  @override
  String get actionRetry => 'Subukang Muli';

  @override
  String get actionViewReport => 'Tingnan ang Ulat';

  @override
  String get actionClear => 'Linisin';

  @override
  String get actionClearFilters => 'Linisin ang mga Salaan';

  @override
  String get actionSaveChanges => 'Salbahin ang Pagbabago';

  @override
  String get actionReset => 'I-reset';

  @override
  String get homeEmptyTitle => 'Walang Feed Pa';

  @override
  String get homeEmptySubtitle => 'Gumawa ng iyong unang pormulasyon ng feed';

  @override
  String get homeCreateFeed => 'Gumawa ng Feed';

  @override
  String get homeAddFeed => 'Magdagdag ng Feed';

  @override
  String homeLoadFailed(String error) {
    return 'Hindi makarga ang mga feed: $error';
  }

  @override
  String get homeLoadingFeeds => 'Kinakarga ang mga feed...';

  @override
  String get feedListEmpty => 'Walang Available na Feed';

  @override
  String get feedsLoadFailed => 'Hindi makarga ang mga feed';

  @override
  String get feedsEmptyStateTitle => 'Walang nakitang feed';

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
  String get ingredientsLoadFailed => 'Hindi makarga ang mga sangkap';

  @override
  String get ingredientsEmptyTitle => 'Walang nakitang sangkap';

  @override
  String get ingredientsEmptySubtitle =>
      'Magdagdag ng mga sangkap para magsimula';

  @override
  String get ingredientsEmptyFilteredTitle =>
      'Walang sangkap na tumutugma sa iyong mga salaan';

  @override
  String get ingredientsEmptyFilteredSubtitle =>
      'Subukang baguhin ang iyong paghahanap o mga salaan';

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
  String get labelEnergy => 'Lakas';

  @override
  String get labelCost => 'Halaga';

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
  String get hintSelectIngredient => 'Tapikin upang pumili ng sangkap';

  @override
  String errorRequired(String field) {
    return 'Kailangan ang $field';
  }

  @override
  String get errorInvalidPrice =>
      'Magpasok ng tamang presyo (halimbawa, 10.50)';

  @override
  String get errorInvalidQuantity => 'Magpasok ng tamang dami (halimbawa, 100)';

  @override
  String get errorPriceNegative => 'Ang presyo ay hindi maaaring negatibo';

  @override
  String get errorQuantityZero => 'Ang dami ay dapat na higit sa 0';

  @override
  String get errorNameTooShort =>
      'Ang pangalan ay dapat na hindi bababa sa 3 na karakter';

  @override
  String get errorNameTooLong =>
      'Ang pangalan ay dapat na mas mababa sa 50 na karakter';

  @override
  String errorUnique(String field) {
    return 'Ang $field ay umiiral na';
  }

  @override
  String get errorDatabaseOperation =>
      'Nabigo ang database na operasyon. Subukan muli.';

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
  String get messageNoData => 'Walang available na datos';

  @override
  String messageEmpty(String item) {
    return 'Walang $item na naidagdag pa';
  }

  @override
  String get confirmDelete => 'Tanggalin';

  @override
  String get confirmDeleteDescription =>
      'Ang aksyon na ito ay hindi maaaring ibalik.';

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
  String get regionEurope => 'Europa';

  @override
  String get regionAmericas => 'Amerika';

  @override
  String get regionOceania => 'Oceania';

  @override
  String get regionGlobal => 'Pandaigdigan';

  @override
  String get filterBy => 'I-filter ayon sa';

  @override
  String get sortBy => 'Pagsort ayon sa';

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
  String get settingAbout => 'Tungkol sa amin';

  @override
  String aboutVersion(String version) {
    return 'Bersyon $version';
  }

  @override
  String get aboutPrivacy => 'Patakaran sa Privacy';

  @override
  String get aboutTerms => 'Mga Tuntunin ng Serbisyo';

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
  String get settingsPrivacyPolicy => 'Patakaran sa Privacy';

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
  String get settingsTermsOfService => 'Mga Tuntunin ng Serbisyo';

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
  String get manageInventoryTitle => 'PAMAHALAAN ANG IMBENTARYO';

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
}
