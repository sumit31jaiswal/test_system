import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_system/theme/app_color.dart';
import 'package:test_system/utils/extension.dart';
import 'package:test_system/views/widgets/category_details.dart';
import 'package:test_system/views/widgets/paint.dart';

import '../../controllers/spending_controller.dart';
import '../../models/category_model.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel model;
  const CategoryCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<SpendingController>();
    final color = c.colorForStatus(model.spendStatus);

    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
          CategoryDetailSheet(model: model),
          isScrollControlled: true,
          backgroundColor: AppColor.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            model.finleyCategory.capitalize ?? '',
            style: TextStyle(
              fontSize: context.f(13),
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.h(8)),
          SizedBox(
            height: context.h(62),
            width: context.h(62),
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: Size(context.h(62), context.h(62)),
                  painter: RingPainter(
                    progress: model.spendPercentage / 100,
                    color: color,
                    background: Colors.grey.shade200,
                    strokeWidth: context.w(6),
                  ),
                ),
                Icon(
                  c.iconForCategory(model.finleyCategory),
                  size: context.f(28),
                  color: AppColor.darkGrey,
                ),
              ],
            ),
          ),

          SizedBox(height: context.h(8)),
          Text(
            c.spendTextForModel(model),
            maxLines: 1,
            style: TextStyle(
              fontSize: context.f(14),
              color: AppColor.darkGrey,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            c.statusTextForModel(model),
            style: TextStyle(
              fontSize: context.f(12),
              color: AppColor.darkGrey,
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
