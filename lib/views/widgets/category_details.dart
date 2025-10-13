import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_system/models/category_model.dart';
import 'package:test_system/theme/app_color.dart';
import 'package:test_system/utils/extension.dart';
import 'package:test_system/views/widgets/paint.dart';

import '../../controllers/spending_controller.dart';

class CategoryDetailSheet extends StatelessWidget {
  final CategoryModel model;
  const CategoryDetailSheet({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<SpendingController>();

    final statusMsg = c.statusTextForModel(model);

    return DraggableScrollableSheet(
      initialChildSize: 0.42,
      minChildSize: 0.25,
      maxChildSize: 0.42,
      expand: false,
      builder: (_, controllerScroll) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: context.w(36),
                  height: context.h(4),
                  margin: EdgeInsets.only(bottom: context.h(12)),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    width: context.h(70),
                    height: context.h(70),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomPaint(
                          size: Size(context.h(70), context.h(70)),
                          painter: RingPainter(
                            progress: model.spendPercentage,
                            color: c.colorForStatus(model.spendStatus),
                            background: AppColor.grey,
                            strokeWidth: 8,
                          ),
                        ),
                        Icon(
                          c.iconForCategory(model.finleyCategory),
                          size: context.f(34),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: context.w(16)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          model.categoryName,
                          style: TextStyle(
                            fontSize: context.f(20),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: context.h(6)),
                        Text(
                          c.currencyFormat.format(model.categorySpend),
                          style: TextStyle(
                            fontSize: context.f(18),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: context.h(4)),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.h(20)),
              Text(
                'Budget limit: ${model.categorySpend + model.spendRemaining}',
                style: TextStyle(
                  fontSize: context.f(14),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: context.h(8)),
              LinearProgressIndicator(
                value: model.spendPercentage / 100,
                backgroundColor: AppColor.grey,
                valueColor: AlwaysStoppedAnimation<Color>(
                  c.colorForStatus(model.spendStatus),
                ),
                minHeight: context.h(10),
              ),
              SizedBox(height: context.h(12)),
              Text(
                'Percentage spent: ${model.spendPercentage.toStringAsFixed(2)}%',
                style: TextStyle(fontSize: context.f(14)),
              ),
              SizedBox(height: context.f(8)),
              Text(
                "Status: $statusMsg",
                style: TextStyle(fontSize: context.f(12)),
              ),
              SizedBox(height: context.h(20)),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.green,
                  ),
                  child: const Text('Close'),
                ),
              ),
              SizedBox(height: context.h(40)),
            ],
          ),
        );
      },
    );
  }
}
