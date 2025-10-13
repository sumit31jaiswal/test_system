import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/category_model.dart';

class MockApiService {
  static Future<List<CategoryModel>> fetchSpendingData() async {
    await Future.delayed(const Duration(milliseconds: 800));

    final jsonString = await rootBundle.loadString('assets/sample_api.json');
    final List<dynamic> data = jsonDecode(jsonString);

    final categories = data
        .map((item) => CategoryModel.fromJson(item as Map<String, dynamic>))
        .toList();

    return categories;
  }
}
