// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Estimador de Ração';

  @override
  String get appDescription => 'Otimizador de formulação de ração para rebanho';

  @override
  String get navHome => 'Início';

  @override
  String get navFeeds => 'Minhas Rações';

  @override
  String get navIngredients => 'Ingredientes';

  @override
  String get navSettings => 'Configurações';

  @override
  String get navAbout => 'Sobre';

  @override
  String get screenTitleHome => 'Formulação de Ração';

  @override
  String get screenTitleIngredientLibrary => 'Biblioteca de Ingredientes';

  @override
  String get screenTitleNewFeed => 'Criar Ração';

  @override
  String get screenTitleReports => 'Análise';

  @override
  String get screenTitleSettings => 'Configurações';

  @override
  String get screenTitleAbout => 'Sobre Estimador de Ração';

  @override
  String get actionCreate => 'Criar';

  @override
  String get actionSave => 'Guardar';

  @override
  String get actionUpdate => 'Atualizar';

  @override
  String get actionDelete => 'Excluir';

  @override
  String get actionCancel => 'Cancelar';

  @override
  String get actionAdd => 'Adicionar';

  @override
  String get actionAddNew => 'Adicionar Novo';

  @override
  String get actionRefresh => 'Atualizar';

  @override
  String get actionEdit => 'Editar';

  @override
  String get actionRemove => 'Remover';

  @override
  String get actionRetry => 'Tentar Novamente';

  @override
  String get actionViewReport => 'Ver Relatório';

  @override
  String get actionClear => 'Limpar';

  @override
  String get actionClearFilters => 'Limpar Filtros';

  @override
  String get actionSaveChanges => 'Salvar Alterações';

  @override
  String get actionReset => 'Redefinir';

  @override
  String get homeEmptyTitle => 'Sem Rações Ainda';

  @override
  String get homeEmptySubtitle => 'Crie sua primeira formulação de ração';

  @override
  String get homeCreateFeed => 'Criar Ração';

  @override
  String get homeAddFeed => 'Adicionar Ração';

  @override
  String homeLoadFailed(String error) {
    return 'Falha ao carregar rações: $error';
  }

  @override
  String get homeLoadingFeeds => 'Carregando rações...';

  @override
  String get feedListEmpty => 'Sem Rações Disponíveis';

  @override
  String get feedsLoadFailed => 'Falha ao carregar rações';

  @override
  String get feedsEmptyStateTitle => 'Nenhuma ração encontrada';

  @override
  String get feedNameUnknown => 'Ração Desconhecida';

  @override
  String feedSubtitle(String animalType) {
    return 'Ração para $animalType';
  }

  @override
  String feedDeleteTitle(String feedName) {
    return 'Excluir \"$feedName\"?';
  }

  @override
  String get confirmDeletionWarning => 'Esta ação não pode ser desfeita.';

  @override
  String get feedStoreTitle => 'Rações em Estoque';

  @override
  String get feedStorePlaceholder => 'Rações armazenadas aqui';

  @override
  String get ingredientSelectedLabel => 'Ingrediente Selecionado';

  @override
  String get ingredientSelectLabel => 'Selecionar Ingrediente';

  @override
  String get ingredientSelectTitle => 'Selecionar Ingrediente';

  @override
  String get ingredientSearchHint => 'Buscar por nome...';

  @override
  String get ingredientNameUnknown => 'Desconhecido';

  @override
  String ingredientAvailableQty(String qty) {
    return '$qty kg disponíveis';
  }

  @override
  String ingredientPricePerKg(String price) {
    return '$price/kg';
  }

  @override
  String get ingredientsLoadFailed => 'Falha ao carregar ingredientes';

  @override
  String get ingredientsEmptyTitle => 'Nenhum ingrediente encontrado';

  @override
  String get ingredientsEmptySubtitle => 'Adicione ingredientes para começar';

  @override
  String get ingredientsEmptyFilteredTitle =>
      'Nenhum ingrediente corresponde aos seus filtros';

  @override
  String get ingredientsEmptyFilteredSubtitle =>
      'Tente ajustar sua busca ou filtros';

  @override
  String get filterFavorites => 'Favoritos';

  @override
  String get filterCustom => 'Personalizados';

  @override
  String filterRegionLabel(String region) {
    return 'Região: $region';
  }

  @override
  String get fallbackUnknownSymbol => '?';

  @override
  String get actionClose => 'Fechar';

  @override
  String get actionExport => 'Exportar';

  @override
  String get actionImport => 'Importar';

  @override
  String get labelName => 'Nome';

  @override
  String get labelPrice => 'Preço';

  @override
  String get labelQuantity => 'Quantidade';

  @override
  String get labelCategory => 'Categoria';

  @override
  String get labelRegion => 'Região';

  @override
  String get labelProtein => 'Proteína';

  @override
  String get labelFat => 'Gordura';

  @override
  String get labelFiber => 'Fibra';

  @override
  String get labelCalcium => 'Cálcio';

  @override
  String get labelPhosphorus => 'Fósforo';

  @override
  String get labelEnergy => 'Energia';

  @override
  String get labelCost => 'Custo';

  @override
  String get labelTotal => 'Total';

  @override
  String get hintEnterName => 'ex: Ração de Inicial para Frango';

  @override
  String get hintEnterPrice => '10.50';

  @override
  String get hintEnterQuantity => '100';

  @override
  String get hintSearch => 'Pesquisar ingredientes...';

  @override
  String get hintSelectIngredient => 'Toque para selecionar ingrediente';

  @override
  String errorRequired(String field) {
    return '$field é obrigatório';
  }

  @override
  String get errorInvalidPrice => 'Insira preço válido (ex: 10.50)';

  @override
  String get errorInvalidQuantity => 'Insira quantidade válida (ex: 100)';

  @override
  String get errorPriceNegative => 'O preço não pode ser negativo';

  @override
  String get errorQuantityZero => 'A quantidade deve ser maior que 0';

  @override
  String get errorNameTooShort => 'O nome deve ter pelo menos 3 caracteres';

  @override
  String get errorNameTooLong => 'O nome deve ter menos de 50 caracteres';

  @override
  String errorUnique(String field) {
    return '$field já existe';
  }

  @override
  String get errorDatabaseOperation =>
      'Operação de banco de dados falhou. Tente novamente.';

  @override
  String get errorNetworkError => 'Erro de rede. Verifique sua conexão.';

  @override
  String messageCreatedSuccessfully(String item) {
    return '$item criado com sucesso';
  }

  @override
  String messageUpdatedSuccessfully(String item) {
    return '$item atualizado com sucesso';
  }

  @override
  String messageDeletedSuccessfully(String item) {
    return '$item deletado com sucesso';
  }

  @override
  String get messageLoading => 'Carregando...';

  @override
  String get messageNoData => 'Nenhum dado disponível';

  @override
  String messageEmpty(String item) {
    return 'Nenhum $item adicionado ainda';
  }

  @override
  String get confirmDelete => 'Excluir';

  @override
  String get confirmDeleteDescription => 'Esta ação não pode ser desfeita.';

  @override
  String get animalTypePig => 'Porco';

  @override
  String get animalTypePoultry => 'Frango';

  @override
  String get animalTypeRabbit => 'Coelho';

  @override
  String get animalTypeRuminant => 'Ruminante';

  @override
  String get animalTypeFish => 'Peixe';

  @override
  String get regionAll => 'Todos';

  @override
  String get regionAfrica => 'África';

  @override
  String get regionAsia => 'Ásia';

  @override
  String get regionEurope => 'Europa';

  @override
  String get regionAmericas => 'Américas';

  @override
  String get regionOceania => 'Oceania';

  @override
  String get regionGlobal => 'Global';

  @override
  String get filterBy => 'Filtrar Por';

  @override
  String get sortBy => 'Ordenar Por';

  @override
  String get sortByName => 'Nome';

  @override
  String get sortByPrice => 'Preço';

  @override
  String get sortByRegion => 'Região';

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
  String get settingNotifications => 'Notificações';

  @override
  String get settingAbout => 'Sobre';

  @override
  String aboutVersion(String version) {
    return 'Versão $version';
  }

  @override
  String get aboutPrivacy => 'Política de Privacidade';

  @override
  String get aboutTerms => 'Termos de Serviço';

  @override
  String get aboutDeveloper => 'Desenvolvido para criadores de gado';

  @override
  String get aboutContribution => 'Seus comentários nos ajudam a melhorar';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get settingsSectionLanguage => 'Idioma';

  @override
  String get settingsSectionPrivacy => 'Privacidade e Dados';

  @override
  String get settingsSectionDataManagement => 'Gestão de Dados';

  @override
  String get settingsSectionLegal => 'Legal';

  @override
  String get settingsSelectLanguage => 'Selecionar Idioma';

  @override
  String settingsLanguageLimitedUI(String language) {
    return '$language (Interface do sistema limitada)';
  }

  @override
  String get settingsDataConsent => 'Consentimento de Coleta de Dados';

  @override
  String get settingsConsentGranted => 'Você consentiu com a coleta de dados';

  @override
  String get settingsConsentNotGranted => 'Você não consentiu';

  @override
  String get settingsConsentDate => 'Data do Consentimento';

  @override
  String get settingsPrivacyPolicy => 'Política de Privacidade';

  @override
  String get settingsPrivacyPolicySubtitle =>
      'Ver nossa política de privacidade';

  @override
  String get settingsFeedFormulations => 'Formulações de Ração';

  @override
  String get settingsCustomIngredients => 'Ingredientes Personalizados';

  @override
  String get settingsDatabaseSize => 'Tamanho do Banco de Dados';

  @override
  String get settingsExportData => 'Exportar Dados';

  @override
  String get settingsExportDataSubtitle =>
      'Fazer backup de todos os seus dados';

  @override
  String get settingsImportData => 'Importar Dados';

  @override
  String get settingsImportDataSubtitle => 'Restaurar do backup';

  @override
  String get settingsDeleteData => 'Excluir Todos os Dados';

  @override
  String get settingsDeleteDataSubtitle => 'Excluir permanentemente tudo';

  @override
  String get settingsVersion => 'Versão';

  @override
  String get settingsRateApp => 'Avaliar o Aplicativo';

  @override
  String get settingsRateAppSubtitle => 'Compartilhar seus comentários';

  @override
  String get settingsLicenses => 'Licenças de Código Aberto';

  @override
  String get settingsTermsOfService => 'Termos de Serviço';

  @override
  String get settingsTermsComingSoon => 'Em breve';

  @override
  String get settingsDataSafety => 'Segurança de Dados';

  @override
  String get settingsDataSafetySubtitle =>
      'Seus dados são armazenados localmente';

  @override
  String get settingsFooter => 'Feito com ❤️ para criadores de gado';

  @override
  String get settingsExporting => 'Exportando dados...';

  @override
  String get settingsExportSuccess => 'Exportação Bem-Sucedida';

  @override
  String get settingsExportSuccessMessage =>
      'Seu backup foi criado com sucesso!';

  @override
  String get settingsRevokeConsentTitle => 'Revogar Consentimento';

  @override
  String get settingsRevokeConsentMessage =>
      'Tem certeza de que deseja revogar seu consentimento? Isso não excluirá seus dados, mas você reconhece que não consente mais com a coleta de dados.';

  @override
  String settingsLanguageUpdated(String language) {
    return 'Idioma atualizado para $language';
  }

  @override
  String get ingredientLibraryTitle => 'Biblioteca de Ingredientes';

  @override
  String get manageInventoryTitle => 'GERENCIAR INVENTÁRIO';

  @override
  String get customIngredientsTitle => 'Ingredientes Personalizados';

  @override
  String get updateDetailsTitle => 'Atualizar Detalhes';

  @override
  String get labelFavorite => 'Favorito';

  @override
  String get labelAddToFavorites => 'Adicionar aos favoritos';

  @override
  String get labelPricePerKg => 'Preço por kg';

  @override
  String get labelAvailableQty => 'Quantidade Disponível (kg)';

  @override
  String get actionPriceHistory => 'Histórico de Preços';

  @override
  String get deleteIngredientTitle => 'Excluir Ingrediente?';

  @override
  String get deleteIngredientMessage =>
      'Isso removerá permanentemente este ingrediente de sua biblioteca. Esta ação não pode ser desfeita.';

  @override
  String get confirmCancel => 'Cancelar';

  @override
  String get successIngredientUpdated => 'Ingrediente atualizado com sucesso';

  @override
  String errorSaveFailed(String error) {
    return 'Falha ao salvar: $error';
  }

  @override
  String get successIngredientDeleted => 'Ingrediente excluído';

  @override
  String errorDeleteFailed(String error) {
    return 'Falha ao excluir: $error';
  }

  @override
  String get errorPriceGreaterThanZero => 'Deve ser > 0';

  @override
  String get errorQuantityGreaterOrEqual => 'Deve ser ≥ 0';

  @override
  String get addFeedTitle => 'Adicionar/Verificar Ração';

  @override
  String get updateFeedTitle => 'Atualizar Ração';

  @override
  String get actionAddIngredients => 'Adicionar Ingredientes';

  @override
  String get tooltipAddIngredients => 'Adicionar mais ingredientes à ração';

  @override
  String get tooltipSaveFeed => 'Guardar ração';

  @override
  String get tooltipUpdateFeed => 'Atualizar ração';

  @override
  String get actionAnalyse => 'Analisar';

  @override
  String get tooltipAnalyseFeed => 'Analisar composição da ração';

  @override
  String get errorFeedNameRequired => 'Nome da Ração Obrigatório';

  @override
  String get errorFeedNameMessage =>
      'Introduza um nome para a sua ração antes de guardar.';

  @override
  String get errorMissingFeedName => 'Falta Nome da Ração';

  @override
  String get errorMissingFeedNameMessage =>
      'Introduza um nome de ração antes de analisar.';

  @override
  String get errorNoIngredients => 'Sem Ingredientes';

  @override
  String get errorNoIngredientsMessage =>
      'Adicione pelo menos um ingrediente para analisar.';

  @override
  String get errorInvalidQuantities => 'Quantidades Inválidas';

  @override
  String get errorInvalidQuantitiesMessage =>
      'Todos os ingredientes devem ter quantidades válidas superiores a 0.';

  @override
  String get errorGenericTitle => 'Ocorreu um Erro';

  @override
  String get errorGenericMessage => 'Tente novamente.';

  @override
  String get actionOk => 'OK';

  @override
  String get analyseDialogTitle => 'Analisar Composição da Ração';

  @override
  String analyseDialogMessageNew(String feedName) {
    return 'Ver análise nutricional detalhada de \"$feedName\" sem guardá-la.';
  }

  @override
  String analyseDialogMessageUpdate(String feedName) {
    return 'Ver análise nutricional detalhada de \"$feedName\" sem atualizá-la.';
  }

  @override
  String get analyseDialogPreviewNote =>
      'Esta é uma pré-visualização. Pode guardar mais tarde.';

  @override
  String get analyseDialogNoSaveNote => 'As alterações não serão guardadas.';

  @override
  String get analyseDialogFailedMessage =>
      'Falha na análise da ração. Tente novamente.';

  @override
  String get reportTitleEstimate => 'Análise Estimada';

  @override
  String get reportTitleAnalysis => 'Relatório de Análise';

  @override
  String get nutrientDigestiveEnergy => 'Energia Digestível';

  @override
  String get nutrientMetabolicEnergy => 'Energia Metabolizável';

  @override
  String get nutrientCrudeProtein => 'Proteína Bruta';

  @override
  String get nutrientCrudeFiber => 'Fibra Bruta';

  @override
  String get nutrientCrudeFat => 'Gordura Bruta';

  @override
  String get nutrientCalcium => 'Cálcio';

  @override
  String get nutrientPhosphorus => 'Fósforo';

  @override
  String get nutrientLysine => 'Lisina';

  @override
  String get nutrientMethionine => 'Metionina';

  @override
  String get nutrientAsh => 'Cinzas';

  @override
  String get nutrientMoisture => 'Humidade';

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
  String get aminoAcidSidLabel => 'SID (Digestível)';

  @override
  String get aminoAcidTotalLabel => 'Total';

  @override
  String get aminoAcidSidButton => 'SID';

  @override
  String get aminoAcidTotalButton => 'Total';

  @override
  String get aminoAcidTableHeaderName => 'Aminoácido';

  @override
  String get aminoAcidTableHeaderContent => 'Conteúdo (%)';

  @override
  String get aminoAcidLysine => 'Lisina';

  @override
  String get aminoAcidMethionine => 'Metionina';

  @override
  String get aminoAcidCystine => 'Cistina';

  @override
  String get aminoAcidThreonine => 'Treonina';

  @override
  String get aminoAcidTryptophan => 'Triptofano';

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
      'SID = Digestibilidade Ileal Padronizada (padrão da indústria)';

  @override
  String get aminoAcidTotalInfo => 'Aminoácidos totais (nem todos digestíveis)';

  @override
  String get aminoAcidLoadError => 'Erro ao carregar dados de aminoácidos';

  @override
  String get warningsCardTitle => 'Avisos e Recomendações';

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
    return 'Ebena Feed Estimator | Pré-visualização de $feedName';
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
  String get optimizerTitle => 'Otimizador de Ração';

  @override
  String get optimizerDescription =>
      'Crie formulações de ração ideais automaticamente';

  @override
  String get optimizerMenuTitle => 'Otimizar Ração';

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
  String get quickOptimizeTitle => 'Otimização Rápida (Recomendado)';

  @override
  String get quickOptimizeDescription =>
      'Formulação pré-configurada para Frango Caipira. Minimize custo com ingredientes de alta qualidade.';

  @override
  String get quickOptimizeButton => 'Iniciar Otimização Rápida';

  @override
  String get quickOptimizeTooltip =>
      'Por que esses padrões? Eles são recomendados por nutricionistas para pequenos agricultores. Você pode personalizar as restrições depois.';

  @override
  String get customOptimizeTitle => 'Otimização Personalizada';

  @override
  String get optimizerActionReset => 'Redefinir';

  @override
  String get optimizerActionAdd => 'Adicionar';

  @override
  String get optimizerOptimizing => 'Otimizando...';

  @override
  String get optimizerRunOptimization => 'Executar Otimização';

  @override
  String get optimizerNoConstraints =>
      'Nenhuma restrição adicionada ainda. Toque em + para adicionar.';

  @override
  String get optimizerNoResults =>
      'Nenhum resultado ainda. Execute uma otimização para ver os resultados.';

  @override
  String optimizerLoadedFeed(String feedName) {
    return 'Ração carregada: $feedName';
  }

  @override
  String get optimizerErrorLoadingFeed => 'Erro ao carregar ração';

  @override
  String get optimizerConstraintsTitle => 'Restrições Nutricionais';

  @override
  String get optimizerAddConstraintTooltip => 'Adicionar restrição nutricional';

  @override
  String get optimizerEditConstraint => 'Editar Restrição';

  @override
  String get optimizerLabelNutrient => 'Nutriente';

  @override
  String get optimizerLabelType => 'Tipo';

  @override
  String get optimizerLabelValue => 'Valor';

  @override
  String get optimizerLabelUnit => 'Unidade';

  @override
  String get optimizerConstraintMinimum => 'Mínimo';

  @override
  String get optimizerConstraintMaximum => 'Máximo';

  @override
  String get nutrientEnergy => 'Energia (kcal/kg)';

  @override
  String get optimizerAnimalCategory => 'Tipo de Animal';

  @override
  String get optimizerSelectAnimalSpecies => 'Selecione a espécie animal';

  @override
  String get optimizerSelectProductionStage =>
      'Selecione o estágio de produção';

  @override
  String get optimizerLoadRequirements => 'Carregar Requisitos';

  @override
  String get optimizerConstraints => 'Restrições Nutricionais';

  @override
  String get optimizerAddConstraint => 'Adicionar Restrição';

  @override
  String get optimizerConstraintType => 'Tipo de Restrição';

  @override
  String get optimizerConstraintMin => 'Mínimo';

  @override
  String get optimizerConstraintMax => 'Máximo';

  @override
  String get optimizerConstraintExact => 'Exato';

  @override
  String get optimizerSelectIngredients => 'Selecionar Ingredientes';

  @override
  String get optimizerIngredientsSelected => 'ingredientes selecionados';

  @override
  String get optimizerUseAllIngredients => 'Usar Todos Disponíveis';

  @override
  String get optimizerObjectiveFunction => 'O que é mais importante?';

  @override
  String get optimizerObjectiveMinimizeCost => 'Menor Custo';

  @override
  String get optimizerObjectiveMaximizeProtein => 'Maior Proteína';

  @override
  String get optimizerObjectiveMaximizeEnergy => 'Mais Energia';

  @override
  String get optimizerButtonOptimize => 'Otimizar';

  @override
  String get optimizerButtonQuickOptimize => 'Otimização Rápida (Recomendado)';

  @override
  String get optimizerCalculating => 'Calculando melhor formulação...';

  @override
  String get optimizerResultsTitle => 'Resultados da Otimização';

  @override
  String get optimizerResultsSuccess => 'Sucesso!';

  @override
  String get optimizerResultsFailed => 'Otimização Falhou';

  @override
  String get optimizerResultsQualityScore => 'Pontuação de Qualidade';

  @override
  String get optimizerResultsTotalCost => 'Custo Total';

  @override
  String get optimizerResultsCostPerKg => 'Custo por kg';

  @override
  String get optimizerResultsIngredientProportions =>
      'Distribuição de Ingredientes';

  @override
  String get optimizerResultsNutritionalProfile => 'Perfil Nutricional';

  @override
  String get optimizerResultsWarnings => 'Avisos';

  @override
  String get optimizerResultsWhyExplain => 'Por Que Essas Proporções?';

  @override
  String get optimizerErrorNoIngredients =>
      'Selecione pelo menos 2 ingredientes';

  @override
  String get optimizerErrorNoAnimal => 'Selecione um tipo de animal';

  @override
  String get optimizerErrorInfeasible =>
      'Nenhuma solução encontrada. Tente ajustar as restrições ou adicionar mais ingredientes.';

  @override
  String get optimizerErrorGeneral => 'Otimização falhou. Tente novamente.';

  @override
  String get optimizerHelpTitle => 'Como Funciona';

  @override
  String get optimizerHelpConstraints =>
      'Restrições são requisitos nutricionais como proteína mínima ou fibra máxima. O otimizador encontra a melhor mistura de ingredientes que atende todos os requisitos.';

  @override
  String get optimizerHelpObjective =>
      'O objetivo informa ao otimizador o que priorizar: ração mais barata, maior proteína ou mais energia.';

  @override
  String get optimizerActionSave => 'Salvar nas Minhas Rações';

  @override
  String get optimizerActionShare => 'Compartilhar com Veterinário';

  @override
  String get optimizerActionTryAgain => 'Tentar Novamente';

  @override
  String get optimizerFormulationHistory => 'Formulações Anteriores';

  @override
  String get optimizerExportTitle => 'Formato de Exportação';

  @override
  String get optimizerExportFormatJson => 'JSON';

  @override
  String get optimizerExportFormatCsv => 'CSV';

  @override
  String get optimizerExportFormatText => 'Relatório de Texto';

  @override
  String optimizerExportedAs(String format, String filename) {
    return 'Exportado como $format: $filename';
  }
}
