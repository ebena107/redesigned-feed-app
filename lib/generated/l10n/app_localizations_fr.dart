// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Estimateur d\'Aliment';

  @override
  String get appDescription =>
      'Optimiseur de formulation d\'aliment pour bétail';

  @override
  String get navHome => 'Accueil';

  @override
  String get navFeeds => 'Mes Aliments';

  @override
  String get navIngredients => 'Ingrédients';

  @override
  String get navSettings => 'Paramètres';

  @override
  String get navAbout => 'À Propos';

  @override
  String get screenTitleHome => 'Formulation d\'Aliment';

  @override
  String get screenTitleIngredientLibrary => 'Bibliothèque d\'Ingrédients';

  @override
  String get screenTitleNewFeed => 'Créer Aliment';

  @override
  String get screenTitleReports => 'Analyse';

  @override
  String get screenTitleSettings => 'Paramètres';

  @override
  String get screenTitleAbout => 'À Propos d\'Estimateur d\'Aliment';

  @override
  String get actionCreate => 'Créer';

  @override
  String get actionSave => 'Enregistrer';

  @override
  String get actionUpdate => 'Mettre à Jour';

  @override
  String get actionDelete => 'Supprimer';

  @override
  String get actionCancel => 'Annuler';

  @override
  String get actionAdd => 'Ajouter';

  @override
  String get actionAddNew => 'Ajouter Nouveau';

  @override
  String get actionRefresh => 'Actualiser';

  @override
  String get actionEdit => 'Modifier';

  @override
  String get actionRemove => 'Retirer';

  @override
  String get actionRetry => 'Réessayer';

  @override
  String get actionViewReport => 'Voir le Rapport';

  @override
  String get actionClear => 'Effacer';

  @override
  String get actionClearFilters => 'Effacer les Filtres';

  @override
  String get actionSaveChanges => 'Enregistrer les Modifications';

  @override
  String get actionReset => 'Réinitialiser';

  @override
  String get homeEmptyTitle => 'Aucun Aliment Pour l\'Instant';

  @override
  String get homeEmptySubtitle => 'Créez votre première formulation d\'aliment';

  @override
  String get homeCreateFeed => 'Créer un Aliment';

  @override
  String get homeAddFeed => 'Ajouter un Aliment';

  @override
  String homeLoadFailed(String error) {
    return 'Échec du chargement des aliments: $error';
  }

  @override
  String get homeLoadingFeeds => 'Chargement des aliments...';

  @override
  String get feedListEmpty => 'Aucun Aliment Disponible';

  @override
  String get feedsLoadFailed => 'Échec du chargement des aliments';

  @override
  String get feedsEmptyStateTitle => 'Aucun aliment trouvé';

  @override
  String get feedNameUnknown => 'Aliment Inconnu';

  @override
  String feedSubtitle(String animalType) {
    return 'Aliment pour $animalType';
  }

  @override
  String feedDeleteTitle(String feedName) {
    return 'Supprimer \"$feedName\"?';
  }

  @override
  String get confirmDeletionWarning => 'Cette action ne peut pas être annulée.';

  @override
  String get feedStoreTitle => 'Aliments en Stock';

  @override
  String get feedStorePlaceholder => 'Aliments stockés ici';

  @override
  String get ingredientSelectedLabel => 'Ingrédient Sélectionné';

  @override
  String get ingredientSelectLabel => 'Sélectionner un Ingrédient';

  @override
  String get ingredientSelectTitle => 'Sélectionner un Ingrédient';

  @override
  String get ingredientSearchHint => 'Rechercher par nom...';

  @override
  String get ingredientNameUnknown => 'Inconnu';

  @override
  String ingredientAvailableQty(String qty) {
    return '$qty kg disponibles';
  }

  @override
  String ingredientPricePerKg(String price) {
    return '$price/kg';
  }

  @override
  String get ingredientsLoadFailed => 'Échec du chargement des ingrédients';

  @override
  String get ingredientsEmptyTitle => 'Aucun ingrédient trouvé';

  @override
  String get ingredientsEmptySubtitle =>
      'Ajoutez des ingrédients pour commencer';

  @override
  String get ingredientsEmptyFilteredTitle =>
      'Aucun ingrédient ne correspond à vos filtres';

  @override
  String get ingredientsEmptyFilteredSubtitle =>
      'Essayez d\'ajuster votre recherche ou vos filtres';

  @override
  String get filterFavorites => 'Favoris';

  @override
  String get filterCustom => 'Personnalisés';

  @override
  String filterRegionLabel(String region) {
    return 'Région: $region';
  }

  @override
  String get fallbackUnknownSymbol => '?';

  @override
  String get actionClose => 'Fermer';

  @override
  String get actionExport => 'Exporter';

  @override
  String get actionImport => 'Importer';

  @override
  String get labelName => 'Nom';

  @override
  String get labelPrice => 'Prix';

  @override
  String get labelQuantity => 'Quantité';

  @override
  String get labelCategory => 'Catégorie';

  @override
  String get labelRegion => 'Région';

  @override
  String get labelProtein => 'Protéine';

  @override
  String get labelFat => 'Graisse';

  @override
  String get labelFiber => 'Fibre';

  @override
  String get labelCalcium => 'Calcium';

  @override
  String get labelPhosphorus => 'Phosphore';

  @override
  String get labelEnergy => 'Énergie';

  @override
  String get labelCost => 'Coût';

  @override
  String get labelTotal => 'Total';

  @override
  String get hintEnterName => 'ex: Aliment Démarrage pour Poulet';

  @override
  String get hintEnterPrice => '10.50';

  @override
  String get hintEnterQuantity => '100';

  @override
  String get hintSearch => 'Rechercher des ingrédients...';

  @override
  String get hintSelectIngredient => 'Appuyez pour sélectionner un ingrédient';

  @override
  String errorRequired(String field) {
    return '$field est obligatoire';
  }

  @override
  String get errorInvalidPrice => 'Entrez un prix valide (ex: 10.50)';

  @override
  String get errorInvalidQuantity => 'Entrez une quantité valide (ex: 100)';

  @override
  String get errorPriceNegative => 'Le prix ne peut pas être négatif';

  @override
  String get errorQuantityZero => 'La quantité doit être supérieure à 0';

  @override
  String get errorNameTooShort => 'Le nom doit avoir au moins 3 caractères';

  @override
  String get errorNameTooLong => 'Le nom doit avoir moins de 50 caractères';

  @override
  String errorUnique(String field) {
    return '$field existe déjà';
  }

  @override
  String get errorDatabaseOperation =>
      'L\'opération de base de données a échoué. Réessayez.';

  @override
  String get errorNetworkError => 'Erreur réseau. Vérifiez votre connexion.';

  @override
  String messageCreatedSuccessfully(String item) {
    return '$item créé avec succès';
  }

  @override
  String messageUpdatedSuccessfully(String item) {
    return '$item mis à jour avec succès';
  }

  @override
  String messageDeletedSuccessfully(String item) {
    return '$item supprimé avec succès';
  }

  @override
  String get messageLoading => 'Chargement...';

  @override
  String get messageNoData => 'Aucune donnée disponible';

  @override
  String messageEmpty(String item) {
    return 'Aucun $item ajouté encore';
  }

  @override
  String get confirmDelete => 'Supprimer';

  @override
  String get confirmDeleteDescription =>
      'Cette action ne peut pas être annulée.';

  @override
  String get animalTypePig => 'Porc';

  @override
  String get animalTypePoultry => 'Volaille';

  @override
  String get animalTypeRabbit => 'Lapin';

  @override
  String get animalTypeRuminant => 'Ruminant';

  @override
  String get animalTypeFish => 'Poisson';

  @override
  String get regionAll => 'Tous';

  @override
  String get regionAfrica => 'Afrique';

  @override
  String get regionAsia => 'Asie';

  @override
  String get regionEurope => 'Europe';

  @override
  String get regionAmericas => 'Amériques';

  @override
  String get regionOceania => 'Océanie';

  @override
  String get regionGlobal => 'Mondial';

  @override
  String get filterBy => 'Filtrer Par';

  @override
  String get sortBy => 'Trier Par';

  @override
  String get sortByName => 'Nom';

  @override
  String get sortByPrice => 'Prix';

  @override
  String get sortByRegion => 'Région';

  @override
  String get unitKg => 'kg';

  @override
  String get unitG => 'g';

  @override
  String get unitLb => 'lb';

  @override
  String get unitTon => 'tonne';

  @override
  String get unitKcal => 'Kcal';

  @override
  String get settingLanguage => 'Langue';

  @override
  String get settingTheme => 'Thème';

  @override
  String get settingNotifications => 'Notifications';

  @override
  String get settingAbout => 'À Propos';

  @override
  String aboutVersion(String version) {
    return 'Version $version';
  }

  @override
  String get aboutPrivacy => 'Politique de Confidentialité';

  @override
  String get aboutTerms => 'Conditions d\'Utilisation';

  @override
  String get aboutDeveloper => 'Développé pour les éleveurs de bétail';

  @override
  String get aboutContribution =>
      'Vos commentaires nous aident à nous améliorer';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsSectionLanguage => 'Langue';

  @override
  String get settingsSectionPrivacy => 'Confidentialité et Données';

  @override
  String get settingsSectionDataManagement => 'Gestion des Données';

  @override
  String get settingsSectionLegal => 'Légal';

  @override
  String get settingsSelectLanguage => 'Sélectionner la Langue';

  @override
  String settingsLanguageLimitedUI(String language) {
    return '$language (Interface système limitée)';
  }

  @override
  String get settingsDataConsent => 'Consentement à la Collecte de Données';

  @override
  String get settingsConsentGranted =>
      'Vous avez consenti à la collecte de données';

  @override
  String get settingsConsentNotGranted => 'Vous n\'avez pas consenti';

  @override
  String get settingsConsentDate => 'Date de Consentement';

  @override
  String get settingsPrivacyPolicy => 'Politique de Confidentialité';

  @override
  String get settingsPrivacyPolicySubtitle =>
      'Voir notre politique de confidentialité';

  @override
  String get settingsFeedFormulations => 'Formulations d\'Aliment';

  @override
  String get settingsCustomIngredients => 'Ingrédients Personnalisés';

  @override
  String get settingsDatabaseSize => 'Taille de la Base de Données';

  @override
  String get settingsExportData => 'Exporter les Données';

  @override
  String get settingsExportDataSubtitle => 'Sauvegarder toutes vos données';

  @override
  String get settingsImportData => 'Importer les Données';

  @override
  String get settingsImportDataSubtitle => 'Restaurer depuis une sauvegarde';

  @override
  String get settingsDeleteData => 'Supprimer Toutes les Données';

  @override
  String get settingsDeleteDataSubtitle => 'Supprimer définitivement tout';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsRateApp => 'Évaluer l\'Application';

  @override
  String get settingsRateAppSubtitle => 'Partager vos commentaires';

  @override
  String get settingsLicenses => 'Licences Open Source';

  @override
  String get settingsTermsOfService => 'Conditions d\'Utilisation';

  @override
  String get settingsTermsComingSoon => 'Bientôt disponible';

  @override
  String get settingsDataSafety => 'Sécurité des Données';

  @override
  String get settingsDataSafetySubtitle =>
      'Vos données sont stockées localement';

  @override
  String get settingsFooter => 'Fait avec ❤️ pour les éleveurs de bétail';

  @override
  String get settingsExporting => 'Export des données...';

  @override
  String get settingsExportSuccess => 'Export Réussi';

  @override
  String get settingsExportSuccessMessage =>
      'Votre sauvegarde a été créée avec succès!';

  @override
  String get settingsRevokeConsentTitle => 'Révoquer le Consentement';

  @override
  String get settingsRevokeConsentMessage =>
      'Êtes-vous sûr de vouloir révoquer votre consentement? Cela ne supprimera pas vos données, mais vous reconnaissez que vous ne consentez plus à la collecte de données.';

  @override
  String settingsLanguageUpdated(String language) {
    return 'Langue mise à jour vers $language';
  }

  @override
  String get ingredientLibraryTitle => 'Bibliothèque d\'Ingrédients';

  @override
  String get manageInventoryTitle => 'GÉRER L\'INVENTAIRE';

  @override
  String get customIngredientsTitle => 'Ingrédients Personnalisés';

  @override
  String get updateDetailsTitle => 'Mettre à Jour les Détails';

  @override
  String get labelFavorite => 'Favori';

  @override
  String get labelAddToFavorites => 'Ajouter aux favoris';

  @override
  String get labelPricePerKg => 'Prix par kg';

  @override
  String get labelAvailableQty => 'Quantité Disponible (kg)';

  @override
  String get actionPriceHistory => 'Historique des Prix';

  @override
  String get deleteIngredientTitle => 'Supprimer l\'Ingrédient?';

  @override
  String get deleteIngredientMessage =>
      'Cela supprimera définitivement cet ingrédient de votre bibliothèque. Cette action ne peut pas être annulée.';

  @override
  String get confirmCancel => 'Annuler';

  @override
  String get successIngredientUpdated => 'Ingrédient mis à jour avec succès';

  @override
  String errorSaveFailed(String error) {
    return 'Échec de l\'enregistrement: $error';
  }

  @override
  String get successIngredientDeleted => 'Ingrédient supprimé';

  @override
  String errorDeleteFailed(String error) {
    return 'Échec de la suppression: $error';
  }

  @override
  String get errorPriceGreaterThanZero => 'Doit être > 0';

  @override
  String get errorQuantityGreaterOrEqual => 'Doit être ≥ 0';

  @override
  String get addFeedTitle => 'Ajouter/Vérifier Aliment';

  @override
  String get updateFeedTitle => 'Mettre à Jour l\'Aliment';

  @override
  String get actionAddIngredients => 'Ajouter des Ingrédients';

  @override
  String get tooltipAddIngredients =>
      'Ajouter plus d\'ingrédients à l\'aliment';

  @override
  String get tooltipSaveFeed => 'Enregistrer l\'aliment';

  @override
  String get tooltipUpdateFeed => 'Mettre à jour l\'aliment';

  @override
  String get actionAnalyse => 'Analyser';

  @override
  String get tooltipAnalyseFeed => 'Analyser la composition de l\'aliment';

  @override
  String get errorFeedNameRequired => 'Nom de l\'Aliment Requis';

  @override
  String get errorFeedNameMessage =>
      'Veuillez saisir un nom pour votre aliment avant de l\'enregistrer.';

  @override
  String get errorMissingFeedName => 'Nom de l\'Aliment Manquant';

  @override
  String get errorMissingFeedNameMessage =>
      'Veuillez saisir un nom d\'aliment avant d\'analyser.';

  @override
  String get errorNoIngredients => 'Aucun Ingrédient';

  @override
  String get errorNoIngredientsMessage =>
      'Veuillez ajouter au moins un ingrédient pour analyser.';

  @override
  String get errorInvalidQuantities => 'Quantités Invalides';

  @override
  String get errorInvalidQuantitiesMessage =>
      'Tous les ingrédients doivent avoir des quantités valides supérieures à 0.';

  @override
  String get errorGenericTitle => 'Une Erreur s\'est Produite';

  @override
  String get errorGenericMessage => 'Veuillez réessayer.';

  @override
  String get actionOk => 'OK';

  @override
  String get analyseDialogTitle => 'Analyser la Composition de l\'Aliment';

  @override
  String analyseDialogMessageNew(String feedName) {
    return 'Voir l\'analyse nutritionnelle détaillée de \"$feedName\" sans l\'enregistrer.';
  }

  @override
  String analyseDialogMessageUpdate(String feedName) {
    return 'Voir l\'analyse nutritionnelle détaillée de \"$feedName\" sans la mettre à jour.';
  }

  @override
  String get analyseDialogPreviewNote =>
      'Ceci est un aperçu. Vous pouvez enregistrer plus tard.';

  @override
  String get analyseDialogNoSaveNote =>
      'Les modifications ne seront pas enregistrées.';

  @override
  String get analyseDialogFailedMessage =>
      'Échec de l\'analyse de l\'aliment. Veuillez réessayer.';

  @override
  String get reportTitleEstimate => 'Analyse Estimée';

  @override
  String get reportTitleAnalysis => 'Rapport d\'Analyse';

  @override
  String get nutrientDigestiveEnergy => 'Énergie Digestible';

  @override
  String get nutrientMetabolicEnergy => 'Énergie Métabolisable';

  @override
  String get nutrientCrudeProtein => 'Protéine Brute';

  @override
  String get nutrientCrudeFiber => 'Fibre Brute';

  @override
  String get nutrientCrudeFat => 'Graisse Brute';

  @override
  String get nutrientCalcium => 'Calcium';

  @override
  String get nutrientPhosphorus => 'Phosphore';

  @override
  String get nutrientLysine => 'Lysine';

  @override
  String get nutrientMethionine => 'Méthionine';

  @override
  String get nutrientAsh => 'Cendres';

  @override
  String get nutrientMoisture => 'Humidité';

  @override
  String get nutrientAvailablePhosphorus => 'Phosp. Dispon.';

  @override
  String get nutrientTotalPhosphorus => 'Phosp. Total';

  @override
  String get nutrientPhytatePhosphorus => 'Phosp. Phytate';

  @override
  String get unitPercent => '%';

  @override
  String get unitGramPerKg => 'g/Kg';

  @override
  String get aminoAcidProfileTitle => 'Profil des Acides Aminés';

  @override
  String get aminoAcidSidLabel => 'SID (Digestible)';

  @override
  String get aminoAcidTotalLabel => 'Total';

  @override
  String get aminoAcidSidButton => 'SID';

  @override
  String get aminoAcidTotalButton => 'Total';

  @override
  String get aminoAcidTableHeaderName => 'Acide Aminé';

  @override
  String get aminoAcidTableHeaderContent => 'Contenu (%)';

  @override
  String get aminoAcidLysine => 'Lysine';

  @override
  String get aminoAcidMethionine => 'Méthionine';

  @override
  String get aminoAcidCystine => 'Cystine';

  @override
  String get aminoAcidThreonine => 'Thréonine';

  @override
  String get aminoAcidTryptophan => 'Tryptophane';

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
  String get aminoAcidPhenylalanine => 'Phénylalanine';

  @override
  String get aminoAcidSidInfo =>
      'SID = Digestibilité Iléale Standardisée (norme de l\'industrie)';

  @override
  String get aminoAcidTotalInfo =>
      'Acides aminés totaux (pas tous digestibles)';

  @override
  String get aminoAcidLoadError =>
      'Erreur lors du chargement des données des acides aminés';

  @override
  String get warningsCardTitle => 'Avertissements et Recommandations';

  @override
  String warningsCardIssueCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count problèmes trouvés',
      one: '1 problème trouvé',
    );
    return '$_temp0';
  }

  @override
  String pdfPreviewTitle(String feedName) {
    return 'Ebena Feed Estimator | Aperçu de $feedName';
  }
}
