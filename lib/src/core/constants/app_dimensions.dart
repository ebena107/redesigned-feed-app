/// Centralized application dimensions and spacing
///
/// Maintains consistent spacing, sizing, and layout values throughout the app.
/// This promotes a cohesive visual design and makes theme adjustments easier.
abstract class AppDimensions {
  // Form & Interaction
  static const double fieldHeight = 48.0;
  static const double fieldWidth = 280.0;
  static const double minTapTarget = 44.0;

  // Padding & Margins
  static const double paddingExtraSmall = 4.0;
  static const double paddingSmall = 8.0;
  static const double paddingRegular = 12.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingExtraLarge = 32.0;
  static const double paddingXXL = 48.0;

  // Common spacing alias
  static const double spacingSmall = paddingSmall;
  static const double spacingRegular = paddingRegular;
  static const double spacingMedium = paddingMedium;
  static const double spacingLarge = paddingLarge;

  // Border Radius
  static const double radiusSmall = 4.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 12.0;
  static const double radiusXL = 16.0;
  static const double radiusCircle = 50.0;

  // Icon Sizes
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMediumCompact = 20.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeXL = 48.0;

  // Button Sizes
  static const double buttonHeightSmall = 36.0;
  static const double buttonHeightMedium = 44.0;
  static const double buttonHeightLarge = 56.0;
  static const double buttonMinWidth = 100.0;

  // TextField/Input Heights
  static const double inputHeightSmall = 36.0;
  static const double inputHeightMedium = 44.0;
  static const double inputHeightLarge = 56.0;

  // Card & Container Sizes
  static const double cardElevation = 2.0;
  static const double cardElevationHigh = 8.0;
  static const double cardMinHeight = 100.0;
  static const double cardMaxWidth = 500.0;

  // Divider & Stroke
  static const double dividerThickness = 1.0;
  static const double strokeWidth = 1.5;
  static const double strokeWidthMedium = 2.0;

  // Typography (Line Heights)
  static const double lineHeightSmall = 1.2;
  static const double lineHeightMedium = 1.5;
  static const double lineHeightLarge = 1.8;

  // Screen Margins
  static const double screenMarginSmall = 12.0;
  static const double screenMarginMedium = 16.0;
  static const double screenMarginLarge = 24.0;

  // Grid & List
  static const double gridSpacing = 12.0;
  static const double listItemHeight = 56.0;
  static const double listItemHeightCompact = 44.0;
  static const double listItemHeightExpanded = 100.0;

  // Drawer & Navigation
  static const double drawerWidth = 280.0;
  static const double navigationBarHeight = 56.0;
  static const double appBarHeight = 56.0;
  static const double tabBarHeight = 48.0;

  // Bottom Sheet
  static const double bottomSheetRadius = 16.0;
  static const double bottomSheetMaxHeight = 600.0;

  // Dialog
  static const double dialogMaxWidth = 400.0;
  static const double dialogBorderRadius = 12.0;

  // Snackbar (managed by Flutter, these are custom)
  static const double snackbarMargin = 16.0;

  // Chip & Tag
  static const double chipHeight = 32.0;
  static const double chipPadding = 8.0;

  // Progress Indicators
  static const double progressIndicatorSize = 24.0;
  static const double progressIndicatorStroke = 3.0;

  // Avatar
  static const double avatarSizeSmall = 32.0;
  static const double avatarSizeMedium = 48.0;
  static const double avatarSizeLarge = 64.0;

  // Image Dimensions
  static const double imagePlaceholderHeight = 200.0;
  static const double imageThumbnailSize = 80.0;

  // Aspect Ratios
  static const double aspectRatioSquare = 1.0;
  static const double aspectRatioWide = 16.0 / 9.0;
  static const double aspectRatioPortrait = 9.0 / 16.0;

  // Common Constraints
  static const double maxContentWidth = 600.0;
  static const double minSwipeDistance = 50.0;

  // Animation-related dimensions
  static const double scrollPhysicsDamping = 0.9;
  static const double fastThreshold = 1000.0;
}
