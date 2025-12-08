/// Centralized application strings
///
/// All user-facing strings are defined here for:
/// - Easy maintenance and updates
/// - Future localization support
/// - Consistent terminology across the app
abstract class AppStrings {
  // App-level strings
  static const appName = 'Feed Estimator';
  static const appVersion = '0.1.1';

  // Navigation & General
  static const home = 'Home';
  static const back = 'Back';
  static const cancel = 'Cancel';
  static const save = 'Save';
  static const delete = 'Delete';
  static const edit = 'Edit';
  static const create = 'Create';
  static const update = 'Update';
  static const confirm = 'Confirm';
  static const close = 'Close';
  static const next = 'Next';
  static const previous = 'Previous';
  static const finish = 'Finish';
  static const loading = 'Loading...';
  static const search = 'Search';
  static const filter = 'Filter';
  static const sort = 'Sort';
  static const noResults = 'No results found';
  static const tryAgain = 'Try Again';

  // Feed Management
  static const feeds = 'Feeds';
  static const newFeed = 'New Feed';
  static const feedName = 'Feed Name';
  static const feedNameRequired = 'Feed name is required';
  static const selectAnimalType = 'Select Animal Type';
  static const animalTypeRequired = 'Animal type is required';
  static const feedNameHint = 'Enter feed name (e.g., Broiler Starter)';
  static const totalQuantity = 'Total Quantity (kg)';
  static const quantityRequired = 'Quantity is required';
  static const createFeedSuccess = 'Feed created successfully';
  static const updateFeedSuccess = 'Feed updated successfully';
  static const deleteFeedSuccess = 'Feed deleted successfully';
  static const confirmDeleteFeed = 'Are you sure you want to delete this feed?';

  // Ingredients
  static const ingredients = 'Ingredients';
  static const ingredient = 'Ingredient';
  static const newIngredient = 'New Ingredient';
  static const addIngredient = 'Add Ingredient';
  static const selectIngredient = 'Select Ingredient';
  static const ingredientName = 'Ingredient Name';
  static const ingredientNameRequired = 'Ingredient name is required';
  static const category = 'Category';
  static const categoryRequired = 'Category is required';
  static const price = 'Price (per kg)';
  static const priceRequired = 'Price is required';
  static const availableQuantity = 'Available Quantity';
  static const quantityAvailable = 'Quantity Available';

  // Nutritional Values
  static const nutritionalContent = 'Nutritional Content';
  static const crudeProtein = 'Crude Protein (%)';
  static const crudeFat = 'Crude Fat (%)';
  static const crudeFiber = 'Crude Fiber (%)';
  static const calcium = 'Calcium (%)';
  static const phosphorus = 'Phosphorus (%)';
  static const lysine = 'Lysine (%)';
  static const methionine = 'Methionine (%)';
  static const energyValue = 'Energy Value (ME kcal/kg)';
  static const meGrowingPig = 'Growing Pig';
  static const meAdultPig = 'Adult Pig';
  static const mePoultry = 'Poultry';
  static const meRuminant = 'Ruminant';
  static const meRabbit = 'Rabbit';
  static const deSalmonids = 'Salmonids/Fish';
  static const energyValueRequired = 'Energy value is required';

  // Reports & Analysis
  static const reports = 'Reports';
  static const report = 'Report';
  static const analysis = 'Analysis';
  static const estimate = 'Estimate';
  static const totalCost = 'Total Cost';
  static const costPerUnit = 'Cost per Unit (kg)';
  static const nutritionalAnalysis = 'Nutritional Analysis';
  static const exportPdf = 'Export as PDF';
  static const shareReport = 'Share Report';

  // Animal Types
  static const animalTypes = 'Animal Types';
  static const pig = 'Pig';
  static const poultry = 'Poultry';
  static const ruminant = 'Ruminant';
  static const rabbit = 'Rabbit';
  static const fish = 'Fish';

  // Categories
  static const categories = 'Categories';
  static const grains = 'Grains';
  static const legumes = 'Legumes';
  static const oils = 'Oils & Fats';
  static const minerals = 'Minerals & Vitamins';
  static const supplements = 'Supplements';

  // Validation Messages
  static const errorValidation = 'Validation Error';
  static const errorRequired = 'This field is required';
  static const errorMinLength = 'Minimum length is ';
  static const errorMaxLength = 'Maximum length is ';
  static const errorInvalidNumber = 'Please enter a valid number';
  static const errorInvalidEmail = 'Please enter a valid email';
  static const errorInvalidDate = 'Please enter a valid date';
  static const errorNumericOnly = 'Only numeric values are allowed';
  static const errorPositiveNumber = 'Value must be greater than 0';

  // Error Messages
  static const errorGeneric = 'An error occurred. Please try again.';
  static const errorNetwork = 'Network error. Please check your connection.';
  static const errorDatabase = 'Database error. Please try again.';
  static const errorNotFound = 'Resource not found.';
  static const errorTimeout = 'Request timed out. Please try again.';
  static const errorUnknown = 'Unknown error occurred.';

  // Success Messages
  static const successGeneric = 'Operation successful';
  static const successSave = 'Saved successfully';
  static const successDelete = 'Deleted successfully';
  static const successUpdate = 'Updated successfully';

  // Confirmation Dialogs
  static const confirmAction = 'Are you sure?';
  static const confirmDelete = 'Are you sure you want to delete this item?';
  static const confirmQuit = 'Are you sure you want to quit?';

  // Empty States
  static const emptyFeeds = 'No feeds yet. Create one to get started.';
  static const emptyIngredients = 'No ingredients available.';
  static const emptyReports = 'No reports generated yet.';

  // Settings
  static const settings = 'Settings';
  static const language = 'Language';
  static const theme = 'Theme';
  static const about = 'About';
  static const version = 'Version';
  static const feedback = 'Send Feedback';
  static const rateApp = 'Rate App';

  // Tooltips & Help
  static const helpIngredient = 'Select the ingredient to add to this feed';
  static const helpQuantity = 'Enter the quantity in kilograms';
  static const helpPrice = 'Current market price per kilogram';
}
