enum SpendStatus { UNDER_SPENT, OVER_THRESHOLD_SPENT, OVER_SPENT }

class CategoryModel {
  final String finleyCategory;
  final String categoryName;
  final double categorySpend;
  final double spendRemaining;
  final SpendStatus spendStatus;
  final double spendPercentage;

  CategoryModel({
    required this.finleyCategory,
    required this.categoryName,
    required this.categorySpend,
    required this.spendRemaining,
    required this.spendStatus,
    required this.spendPercentage,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> j) {
    String status = j['spendStatus'] ?? 'UNDER_SPENT';
    SpendStatus parsed;
    switch (status) {
      case 'OVER_THRESHOLD_SPENT':
        parsed = SpendStatus.OVER_THRESHOLD_SPENT;
        break;
      case 'OVER_SPENT':
        parsed = SpendStatus.OVER_SPENT;
        break;
      default:
        parsed = SpendStatus.UNDER_SPENT;
    }

    return CategoryModel(
      finleyCategory: j['finleyCategory'],

      categoryName: j['finleyCategoryName'],
      categorySpend: (j['categorySpend']),
      spendRemaining: (j['spendRemaining']),
      spendStatus: parsed,
      spendPercentage: (j['spendPercentage']),
    );
  }
}
