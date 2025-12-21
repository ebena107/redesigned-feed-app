/// Pagination helper for efficient list loading
///
/// Provides utilities for paginated data loading to improve performance
/// when displaying large lists (ingredients, feeds, etc.)
class PaginationHelper<T> {
  static const int defaultPageSize = 50;
  static const int defaultPreloadThreshold =
      10; // Items before end to trigger load

  final int pageSize;
  final int preloadThreshold;

  const PaginationHelper({
    this.pageSize = defaultPageSize,
    this.preloadThreshold = defaultPreloadThreshold,
  });

  /// Get a page of items from a list
  ///
  /// Returns items from [startIndex] to [startIndex + pageSize]
  List<T> getPage(List<T> items, int pageNumber) {
    final startIndex = pageNumber * pageSize;
    final endIndex = (startIndex + pageSize).clamp(0, items.length);

    if (startIndex >= items.length) {
      return [];
    }

    return items.sublist(startIndex, endIndex);
  }

  /// Check if we should load the next page based on scroll position
  ///
  /// Returns true when user is [preloadThreshold] items away from the end
  bool shouldLoadNextPage({
    required int currentIndex,
    required int loadedItemsCount,
    required int totalItemsCount,
  }) {
    // If all items are loaded, no need to load more
    if (loadedItemsCount >= totalItemsCount) {
      return false;
    }

    // Load next page when user approaches the end
    return currentIndex >= loadedItemsCount - preloadThreshold;
  }

  /// Calculate the number of pages needed for a list
  int getTotalPages(int totalItems) {
    return (totalItems / pageSize).ceil();
  }

  /// Get the range of items for a specific page
  ///
  /// Returns (startIndex, endIndex) tuple
  (int, int) getPageRange(int pageNumber, int totalItems) {
    final startIndex = pageNumber * pageSize;
    final endIndex = (startIndex + pageSize).clamp(0, totalItems);
    return (startIndex, endIndex);
  }
}

/// Extension on List for easier pagination
extension PaginationExtension<T> on List<T> {
  /// Get a paginated subset of this list
  List<T> paginate(int pageNumber, {int pageSize = 50}) {
    final helper = PaginationHelper<T>(pageSize: pageSize);
    return helper.getPage(this, pageNumber);
  }

  /// Get items up to a specific page (inclusive)
  List<T> upToPage(int pageNumber, {int pageSize = 50}) {
    final maxItems = (pageNumber + 1) * pageSize;
    return take(maxItems.clamp(0, length)).toList();
  }
}
