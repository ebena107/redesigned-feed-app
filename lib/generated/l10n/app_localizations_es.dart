// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Estimador de Alimento';

  @override
  String get appDescription =>
      'Optimizador de formulación de alimento para ganado';

  @override
  String get navHome => 'Inicio';

  @override
  String get navFeeds => 'Mis Alimentos';

  @override
  String get navIngredients => 'Ingredientes';

  @override
  String get navSettings => 'Configuración';

  @override
  String get navAbout => 'Acerca de';

  @override
  String get screenTitleHome => 'Formulación de Alimento';

  @override
  String get screenTitleIngredientLibrary => 'Biblioteca de Ingredientes';

  @override
  String get screenTitleNewFeed => 'Crear Alimento';

  @override
  String get screenTitleReports => 'Análisis';

  @override
  String get screenTitleSettings => 'Configuración';

  @override
  String get screenTitleAbout => 'Acerca de Estimador de Alimento';

  @override
  String get actionCreate => 'Crear';

  @override
  String get actionSave => 'Guardar';

  @override
  String get actionUpdate => 'Actualizar';

  @override
  String get actionDelete => 'Eliminar';

  @override
  String get actionCancel => 'Cancelar';

  @override
  String get actionAdd => 'Añadir';

  @override
  String get actionAddNew => 'Añadir Nuevo';

  @override
  String get actionRefresh => 'Actualizar';

  @override
  String get actionEdit => 'Editar';

  @override
  String get actionRemove => 'Quitar';

  @override
  String get actionRetry => 'Reintentar';

  @override
  String get actionViewReport => 'Ver Reporte';

  @override
  String get actionClear => 'Limpiar';

  @override
  String get actionClearFilters => 'Limpiar Filtros';

  @override
  String get actionSaveChanges => 'Guardar Cambios';

  @override
  String get actionReset => 'Restablecer';

  @override
  String get homeEmptyTitle => 'Sin Alimentos Aún';

  @override
  String get homeEmptySubtitle => 'Cree su primera formulación de alimento';

  @override
  String get homeCreateFeed => 'Crear Alimento';

  @override
  String get homeAddFeed => 'Agregar Alimento';

  @override
  String homeLoadFailed(String error) {
    return 'Error al cargar alimentos: $error';
  }

  @override
  String get homeLoadingFeeds => 'Cargando alimentos...';

  @override
  String get feedListEmpty => 'Sin Alimentos Disponibles';

  @override
  String get feedsLoadFailed => 'Error al cargar alimentos';

  @override
  String get feedsEmptyStateTitle => 'No se encontraron alimentos';

  @override
  String get feedNameUnknown => 'Alimento Desconocido';

  @override
  String feedSubtitle(String animalType) {
    return 'Alimento para $animalType';
  }

  @override
  String feedDeleteTitle(String feedName) {
    return '¿Eliminar \"$feedName\"?';
  }

  @override
  String get confirmDeletionWarning => 'Esta acción no se puede deshacer.';

  @override
  String get feedStoreTitle => 'Alimentos en Almacén';

  @override
  String get feedStorePlaceholder => 'Alimentos almacenados aquí';

  @override
  String get ingredientSelectedLabel => 'Ingrediente Seleccionado';

  @override
  String get ingredientSelectLabel => 'Seleccionar Ingrediente';

  @override
  String get ingredientSelectTitle => 'Seleccionar Ingrediente';

  @override
  String get ingredientSearchHint => 'Buscar por nombre...';

  @override
  String get ingredientNameUnknown => 'Desconocido';

  @override
  String ingredientAvailableQty(String qty) {
    return '$qty kg disponibles';
  }

  @override
  String ingredientPricePerKg(String price) {
    return '$price/kg';
  }

  @override
  String get ingredientsLoadFailed => 'Error al cargar ingredientes';

  @override
  String get ingredientsEmptyTitle => 'No se encontraron ingredientes';

  @override
  String get ingredientsEmptySubtitle => 'Agregue ingredientes para comenzar';

  @override
  String get ingredientsEmptyFilteredTitle =>
      'Ningún ingrediente coincide con sus filtros';

  @override
  String get ingredientsEmptyFilteredSubtitle =>
      'Intente ajustar su búsqueda o filtros';

  @override
  String get filterFavorites => 'Favoritos';

  @override
  String get filterCustom => 'Personalizados';

  @override
  String filterRegionLabel(String region) {
    return 'Región: $region';
  }

  @override
  String get fallbackUnknownSymbol => '?';

  @override
  String get actionClose => 'Cerrar';

  @override
  String get actionExport => 'Exportar';

  @override
  String get actionImport => 'Importar';

  @override
  String get labelName => 'Nombre';

  @override
  String get labelPrice => 'Precio';

  @override
  String get labelQuantity => 'Cantidad';

  @override
  String get labelCategory => 'Categoría';

  @override
  String get labelRegion => 'Región';

  @override
  String get labelProtein => 'Proteína';

  @override
  String get labelFat => 'Grasa';

  @override
  String get labelFiber => 'Fibra';

  @override
  String get labelCalcium => 'Calcio';

  @override
  String get labelPhosphorus => 'Fósforo';

  @override
  String get labelEnergy => 'Energía';

  @override
  String get labelCost => 'Costo';

  @override
  String get labelTotal => 'Total';

  @override
  String get hintEnterName => 'ej: Alimento de Inicio para Broilers';

  @override
  String get hintEnterPrice => '10.50';

  @override
  String get hintEnterQuantity => '100';

  @override
  String get hintSearch => 'Buscar ingredientes...';

  @override
  String get hintSelectIngredient => 'Toque para seleccionar ingrediente';

  @override
  String errorRequired(String field) {
    return '$field es requerido';
  }

  @override
  String get errorInvalidPrice => 'Ingrese precio válido (ej: 10.50)';

  @override
  String get errorInvalidQuantity => 'Ingrese cantidad válida (ej: 100)';

  @override
  String get errorPriceNegative => 'El precio no puede ser negativo';

  @override
  String get errorQuantityZero => 'La cantidad debe ser mayor que 0';

  @override
  String get errorNameTooShort => 'El nombre debe tener al menos 3 caracteres';

  @override
  String get errorNameTooLong => 'El nombre debe tener menos de 50 caracteres';

  @override
  String errorUnique(String field) {
    return '$field ya existe';
  }

  @override
  String get errorDatabaseOperation =>
      'Operación de base de datos fallida. Intente nuevamente.';

  @override
  String get errorNetworkError => 'Error de red. Verifique su conexión.';

  @override
  String messageCreatedSuccessfully(String item) {
    return '$item creado exitosamente';
  }

  @override
  String messageUpdatedSuccessfully(String item) {
    return '$item actualizado exitosamente';
  }

  @override
  String messageDeletedSuccessfully(String item) {
    return '$item eliminado exitosamente';
  }

  @override
  String get messageLoading => 'Cargando...';

  @override
  String get messageNoData => 'No hay datos disponibles';

  @override
  String messageEmpty(String item) {
    return 'No hay $item añadidos aún';
  }

  @override
  String get confirmDelete => 'Eliminar';

  @override
  String get confirmDeleteDescription => 'Esta acción no se puede deshacer.';

  @override
  String get animalTypePig => 'Cerdo';

  @override
  String get animalTypePoultry => 'Pollo';

  @override
  String get animalTypeRabbit => 'Conejo';

  @override
  String get animalTypeRuminant => 'Rumiante';

  @override
  String get animalTypeFish => 'Pez';

  @override
  String get regionAll => 'Todos';

  @override
  String get regionAfrica => 'África';

  @override
  String get regionAsia => 'Asia';

  @override
  String get regionEurope => 'Europa';

  @override
  String get regionAmericas => 'América';

  @override
  String get regionOceania => 'Oceanía';

  @override
  String get regionGlobal => 'Global';

  @override
  String get filterBy => 'Filtrar Por';

  @override
  String get sortBy => 'Ordenar Por';

  @override
  String get sortByName => 'Nombre';

  @override
  String get sortByPrice => 'Precio';

  @override
  String get sortByRegion => 'Región';

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
  String get settingLanguage => 'Idioma';

  @override
  String get settingTheme => 'Tema';

  @override
  String get settingNotifications => 'Notificaciones';

  @override
  String get settingAbout => 'Acerca de';

  @override
  String aboutVersion(String version) {
    return 'Versión $version';
  }

  @override
  String get aboutPrivacy => 'Política de Privacidad';

  @override
  String get aboutTerms => 'Términos de Servicio';

  @override
  String get aboutDeveloper => 'Desarrollado para ganaderos';

  @override
  String get aboutContribution => 'Sus comentarios nos ayudan a mejorar';

  @override
  String get settingsTitle => 'Configuración';

  @override
  String get settingsSectionLanguage => 'Idioma';

  @override
  String get settingsSectionPrivacy => 'Privacidad y Datos';

  @override
  String get settingsSectionDataManagement => 'Gestión de Datos';

  @override
  String get settingsSectionLegal => 'Legal';

  @override
  String get settingsSelectLanguage => 'Seleccionar Idioma';

  @override
  String settingsLanguageLimitedUI(String language) {
    return '$language (Interfaz del sistema limitada)';
  }

  @override
  String get settingsDataConsent => 'Consentimiento de Recopilación de Datos';

  @override
  String get settingsConsentGranted => 'Ha consentido la recopilación de datos';

  @override
  String get settingsConsentNotGranted => 'No ha consentido';

  @override
  String get settingsConsentDate => 'Fecha de Consentimiento';

  @override
  String get settingsPrivacyPolicy => 'Política de Privacidad';

  @override
  String get settingsPrivacyPolicySubtitle =>
      'Ver nuestra política de privacidad';

  @override
  String get settingsFeedFormulations => 'Formulaciones de Alimento';

  @override
  String get settingsCustomIngredients => 'Ingredientes Personalizados';

  @override
  String get settingsDatabaseSize => 'Tamaño de la Base de Datos';

  @override
  String get settingsExportData => 'Exportar Datos';

  @override
  String get settingsExportDataSubtitle => 'Respaldar todos sus datos';

  @override
  String get settingsImportData => 'Importar Datos';

  @override
  String get settingsImportDataSubtitle => 'Restaurar desde respaldo';

  @override
  String get settingsDeleteData => 'Eliminar Todos los Datos';

  @override
  String get settingsDeleteDataSubtitle => 'Eliminar permanentemente todo';

  @override
  String get settingsVersion => 'Versión';

  @override
  String get settingsRateApp => 'Calificar la Aplicación';

  @override
  String get settingsRateAppSubtitle => 'Compartir sus comentarios';

  @override
  String get settingsLicenses => 'Licencias de Código Abierto';

  @override
  String get settingsTermsOfService => 'Términos de Servicio';

  @override
  String get settingsTermsComingSoon => 'Próximamente';

  @override
  String get settingsDataSafety => 'Seguridad de Datos';

  @override
  String get settingsDataSafetySubtitle => 'Sus datos se almacenan localmente';

  @override
  String get settingsFooter => 'Hecho con ❤️ para ganaderos';

  @override
  String get settingsExporting => 'Exportando datos...';

  @override
  String get settingsExportSuccess => 'Exportación Exitosa';

  @override
  String get settingsExportSuccessMessage =>
      '¡Su respaldo se ha creado exitosamente!';

  @override
  String get settingsRevokeConsentTitle => 'Revocar Consentimiento';

  @override
  String get settingsRevokeConsentMessage =>
      '¿Está seguro de que desea revocar su consentimiento? Esto no eliminará sus datos, pero reconoce que ya no consiente la recopilación de datos.';

  @override
  String settingsLanguageUpdated(String language) {
    return 'Idioma actualizado a $language';
  }

  @override
  String get ingredientLibraryTitle => 'Biblioteca de Ingredientes';

  @override
  String get manageInventoryTitle => 'GESTIONAR INVENTARIO';

  @override
  String get customIngredientsTitle => 'Ingredientes Personalizados';

  @override
  String get updateDetailsTitle => 'Actualizar Detalles';

  @override
  String get labelFavorite => 'Favorito';

  @override
  String get labelAddToFavorites => 'Añadir a favoritos';

  @override
  String get labelPricePerKg => 'Precio por kg';

  @override
  String get labelAvailableQty => 'Cantidad Disponible (kg)';

  @override
  String get actionPriceHistory => 'Historial de Precios';

  @override
  String get deleteIngredientTitle => '¿Eliminar Ingrediente?';

  @override
  String get deleteIngredientMessage =>
      'Esto eliminará permanentemente este ingrediente de su biblioteca. Esta acción no se puede deshacer.';

  @override
  String get confirmCancel => 'Cancelar';

  @override
  String get successIngredientUpdated => 'Ingrediente actualizado exitosamente';

  @override
  String errorSaveFailed(String error) {
    return 'Falló al guardar: $error';
  }

  @override
  String get successIngredientDeleted => 'Ingrediente eliminado';

  @override
  String errorDeleteFailed(String error) {
    return 'Falló al eliminar: $error';
  }

  @override
  String get errorPriceGreaterThanZero => 'Debe ser > 0';

  @override
  String get errorQuantityGreaterOrEqual => 'Debe ser ≥ 0';

  @override
  String get addFeedTitle => 'Añadir/Verificar Alimento';

  @override
  String get updateFeedTitle => 'Actualizar Alimento';

  @override
  String get actionAddIngredients => 'Añadir Ingredientes';

  @override
  String get tooltipAddIngredients => 'Añadir más ingredientes al alimento';

  @override
  String get tooltipSaveFeed => 'Guardar alimento';

  @override
  String get tooltipUpdateFeed => 'Actualizar alimento';

  @override
  String get actionAnalyse => 'Analizar';

  @override
  String get tooltipAnalyseFeed => 'Analizar composición del alimento';

  @override
  String get errorFeedNameRequired => 'Nombre de Alimento Requerido';

  @override
  String get errorFeedNameMessage =>
      'Ingrese un nombre para su alimento antes de guardar.';

  @override
  String get errorMissingFeedName => 'Falta Nombre de Alimento';

  @override
  String get errorMissingFeedNameMessage =>
      'Ingrese un nombre de alimento antes de analizar.';

  @override
  String get errorNoIngredients => 'Sin Ingredientes';

  @override
  String get errorNoIngredientsMessage =>
      'Añada al menos un ingrediente para analizar.';

  @override
  String get errorInvalidQuantities => 'Cantidades Inválidas';

  @override
  String get errorInvalidQuantitiesMessage =>
      'Todos los ingredientes deben tener cantidades válidas mayores que 0.';

  @override
  String get errorGenericTitle => 'Ocurrió un Error';

  @override
  String get errorGenericMessage => 'Inténtelo nuevamente.';

  @override
  String get actionOk => 'ACEPTAR';

  @override
  String get analyseDialogTitle => 'Analizar Composición del Alimento';

  @override
  String analyseDialogMessageNew(String feedName) {
    return 'Ver análisis nutricional detallado de \"$feedName\" sin guardarlo.';
  }

  @override
  String analyseDialogMessageUpdate(String feedName) {
    return 'Ver análisis nutricional detallado de \"$feedName\" sin actualizarlo.';
  }

  @override
  String get analyseDialogPreviewNote =>
      'Esta es una vista previa. Puede guardar después.';

  @override
  String get analyseDialogNoSaveNote => 'Los cambios no se guardarán.';

  @override
  String get analyseDialogFailedMessage =>
      'Falló el análisis del alimento. Inténtelo nuevamente.';

  @override
  String get reportTitleEstimate => 'Análisis Estimado';

  @override
  String get reportTitleAnalysis => 'Informe de Análisis';

  @override
  String get nutrientDigestiveEnergy => 'Energía Digestible';

  @override
  String get nutrientMetabolicEnergy => 'Energía Metabolizable';

  @override
  String get nutrientCrudeProtein => 'Proteína Cruda';

  @override
  String get nutrientCrudeFiber => 'Fibra Cruda';

  @override
  String get nutrientCrudeFat => 'Grasa Cruda';

  @override
  String get nutrientCalcium => 'Calcio';

  @override
  String get nutrientPhosphorus => 'Fósforo';

  @override
  String get nutrientLysine => 'Lisina';

  @override
  String get nutrientMethionine => 'Metionina';

  @override
  String get nutrientAsh => 'Ceniza';

  @override
  String get nutrientMoisture => 'Humedad';

  @override
  String get nutrientAvailablePhosphorus => 'Fósf. Dispon.';

  @override
  String get nutrientTotalPhosphorus => 'Fósf. Total';

  @override
  String get nutrientPhytatePhosphorus => 'Fósf. Fitato';

  @override
  String get unitPercent => '%';

  @override
  String get unitGramPerKg => 'g/Kg';

  @override
  String get aminoAcidProfileTitle => 'Perfil de Aminoácidos';

  @override
  String get aminoAcidSidLabel => 'SID (Digestible)';

  @override
  String get aminoAcidTotalLabel => 'Total';

  @override
  String get aminoAcidSidButton => 'SID';

  @override
  String get aminoAcidTotalButton => 'Total';

  @override
  String get aminoAcidTableHeaderName => 'Aminoácido';

  @override
  String get aminoAcidTableHeaderContent => 'Contenido (%)';

  @override
  String get aminoAcidLysine => 'Lisina';

  @override
  String get aminoAcidMethionine => 'Metionina';

  @override
  String get aminoAcidCystine => 'Cistina';

  @override
  String get aminoAcidThreonine => 'Treonina';

  @override
  String get aminoAcidTryptophan => 'Triptófano';

  @override
  String get aminoAcidArginine => 'Arginina';

  @override
  String get aminoAcidIsoleucine => 'Isoleucina';

  @override
  String get aminoAcidLeucine => 'Leucina';

  @override
  String get aminoAcidValine => 'Valina';

  @override
  String get aminoAcidHistidine => 'Histidina';

  @override
  String get aminoAcidPhenylalanine => 'Fenilalanina';

  @override
  String get aminoAcidSidInfo =>
      'SID = Digestibilidad Ileal Estandarizada (estándar de la industria)';

  @override
  String get aminoAcidTotalInfo => 'Aminoácidos totales (no todos digestibles)';

  @override
  String get aminoAcidLoadError => 'Error al cargar datos de aminoácidos';

  @override
  String get warningsCardTitle => 'Advertencias y Recomendaciones';

  @override
  String warningsCardIssueCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count problemas encontrados',
      one: '1 problema encontrado',
    );
    return '$_temp0';
  }

  @override
  String pdfPreviewTitle(String feedName) {
    return 'Ebena Feed Estimator | Vista Previa de $feedName';
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
    return '$name Añadido Exitosamente';
  }

  @override
  String get ingredientAddedSuccessMessage => '¿Desea añadir otro ingrediente?';

  @override
  String get ingredientAddedNo => 'No, Volver';

  @override
  String get ingredientAddedYes => 'Sí, Continuar';

  @override
  String customIngredientsHeader(int count) {
    return 'Sus Ingredientes Personalizados ($count)';
  }

  @override
  String get customIngredientsSearchHint =>
      'Buscar sus ingredientes personalizados...';

  @override
  String get customIngredientsEmptyTitle =>
      'Aún no hay ingredientes personalizados';

  @override
  String get customIngredientsEmptySubtitle =>
      '¡Cree su primer ingrediente personalizado!';

  @override
  String get customIngredientsNoMatch =>
      'Ningún ingrediente coincide con su búsqueda';

  @override
  String labelCreatedBy(String creator) {
    return 'por $creator';
  }

  @override
  String get labelNotes => 'Notas:';

  @override
  String get labelPriceHistory => 'Historial de Precios';

  @override
  String get labelCa => 'Ca';

  @override
  String get labelP => 'P';

  @override
  String get priceHistoryEmpty => 'No hay historial de precios disponible';

  @override
  String get priceHistoryError => 'Error al cargar historial de precios';

  @override
  String get deleteCustomIngredientTitle =>
      '¿Eliminar Ingrediente Personalizado?';

  @override
  String deleteCustomIngredientMessage(String name) {
    return '¿Eliminar \"$name\" de sus ingredientes personalizados?';
  }

  @override
  String ingredientRemovedSuccess(String name) {
    return '$name eliminado';
  }

  @override
  String get exportFormatTitle => 'Formato de Exportación';

  @override
  String get exportFormatMessage =>
      'Elija el formato de exportación para sus ingredientes personalizados:';

  @override
  String get exportingToJson => 'Exportando a JSON...';

  @override
  String get exportingToCsv => 'Exportando a CSV...';

  @override
  String get exportFailed => 'Exportación fallida';

  @override
  String exportFailedWithError(String error) {
    return 'Exportación fallida: $error';
  }

  @override
  String get importCustomIngredientsTitle =>
      'Importar Ingredientes Personalizados';

  @override
  String get importFormatMessage =>
      'Elija el formato de archivo para importar:';

  @override
  String get importingData => 'Importando datos...';

  @override
  String get importSuccessTitle => 'Importación Exitosa';

  @override
  String get importFailedTitle => 'Importación Fallida';

  @override
  String importError(String error) {
    return 'Error: $error';
  }

  @override
  String get actionJson => 'JSON';

  @override
  String get actionCsv => 'CSV';

  @override
  String get labelIngredient => 'Ingrediente';
}
