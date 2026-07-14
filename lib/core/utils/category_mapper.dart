class CategoryMapper {
  CategoryMapper._();

  /// Ticketmaster classificationName values (Postman uses lowercase, e.g. `music`).
  static String? toApi(String? label) {
    if (label == null || label == 'All') return null;
    return switch (label) {
      'Sports' => 'sports',
      'Music' => 'music',
      'Art' => 'arts',
      'Food' => 'food',
      _ => label.toLowerCase(),
    };
  }

  /// Food segment is sparse in Discovery API — keyword search is more reliable.
  static String? keywordFor(String? label) {
    if (label == 'Food') return 'food';
    return null;
  }

  static bool useKeywordInsteadOfClassification(String? label) => label == 'Food';
}
