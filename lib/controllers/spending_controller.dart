import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:test_system/services/location_service.dart';
import 'package:test_system/theme/app_color.dart';

import '../models/category_model.dart';
import '../services/mock_api_service.dart';

class SpendingController extends GetxController {
  var categories = <CategoryModel>[].obs;
  var loading = false.obs;
  var locationText = 'Unknown'.obs;
  var locationLoading = false.obs;

  final currencyFormat = NumberFormat.simpleCurrency(decimalDigits: 2);

  @override
  void onInit() {
    super.onInit();
    loadCategories();
    checkAndFetchLocation();
  }

  Future<void> loadCategories() async {
    try {
      loading.value = true;
      final List<CategoryModel> data = await MockApiService.fetchSpendingData();
      categories.assignAll(data);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load categories: $e');
    } finally {
      loading.value = false;
    }
  }

  Future<void> refreshCategories() async {
    await loadCategories();
  }

  Future<void> checkAndFetchLocation() async {
    try {
      locationLoading.value = true;
      locationText.value = 'loading....';

      bool serviceEnabled = await LocationService.isLocationServiceEnabled();
      if (!serviceEnabled) {
        final result = await Get.defaultDialog<bool>(
          title: 'Location services disabled',
          middleText:
              'Please enable location services to show your current city/region.',
          textConfirm: 'Open settings',
          textCancel: 'Cancel',
          onConfirm: () {
            Get.back(result: true);
          },
        );
        if (result == true) {
          await Geolocator.openLocationSettings();
        }
      }

      LocationPermission permission = await LocationService.checkPermission();
      if (permission == LocationPermission.denied) {
        final allow = await Get.defaultDialog<bool>(
          title: 'Location permission',
          middleText:
              'This app needs location access to show your current city. Please allow.',
          textConfirm: 'Allow',
          textCancel: 'Not Now',
          onConfirm: () {
            Get.back(result: true);
          },
        );
        if (allow == true) {
          permission = await LocationService.requestPermission();
        }
      } else if (permission == LocationPermission.deniedForever) {
        Get.defaultDialog(
          title: 'Permission permanently denied',
          middleText:
              'Location permission is permanently denied. Please enable it from app settings.',
          textConfirm: 'Open Settings',
          onConfirm: () {
            Geolocator.openAppSettings();
            Get.back();
          },
        );
      }

      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        final pos = await LocationService.getCurrentPosition();
        print("Line96$pos");
        final city = await LocationService.getCityFromPosition(pos);
        print("Line96$city");

        locationText.value = city;
      } else {
        locationText.value = 'Permission denied';
      }
    } catch (e) {
      log(e.toString());
      locationText.value = 'Location error';
    } finally {
      locationLoading.value = false;
    }
  }

  Color colorForStatus(SpendStatus s) {
    switch (s) {
      case SpendStatus.OVER_SPENT:
        return AppColor.red;
      case SpendStatus.OVER_THRESHOLD_SPENT:
        return AppColor.yellow;
      case SpendStatus.UNDER_SPENT:
        return AppColor.green;
    }
  }

  String spendTextForModel(CategoryModel m) {
    if (m.spendRemaining > 0) {
      return currencyFormat.format(m.categorySpend.abs());
    } else if (m.spendRemaining < 0) {
      return currencyFormat.format(m.categorySpend.abs());
    } else {
      if (m.categorySpend == 0 && m.categorySpend == 0) return '\$0.00';
      return '\$0.00';
    }
  }

  String statusTextForModel(CategoryModel m) {
    if (m.spendRemaining > 0) {
      return 'left';
    } else if (m.spendRemaining < 0) {
      return 'over limit';
    } else {
      if (m.categorySpend == 0 && m.categorySpend == 0) {
        return 'left';
      }
      return 'left';
    }
  }

  IconData iconForCategory(String finleyCategory) {
    switch (finleyCategory.toUpperCase()) {
      case 'HOUSING':
        return Icons.house;
      case 'EDUCATION':
        return Icons.school;
      case 'TRANSPORT':
        return Icons.directions_car;
      case 'HEALTHCARE':
        return Icons.local_hospital;
      case 'INSURANCE':
        return Icons.shield;
      case 'LOANS':
        return Icons.credit_card;
      case 'GROCERIES':
        return Icons.shopping_cart;
      case 'ENTERTAIN':
        return Icons.celebration;
      case 'DINING OUT':
        return Icons.restaurant;
      case 'SHOPPING':
        return Icons.shopping_bag;
      case 'MISC':
        return Icons.settings;
      case 'TRAVEL':
        return Icons.airplanemode_active;
      default:
        return Icons.category;
    }
  }
}
