import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_system/theme/app_color.dart';
import 'package:test_system/utils/extension.dart';
import 'package:test_system/views/widgets/category_card.dart';
import 'package:test_system/views/widgets/nav_bottom.dart';

import '../controllers/spending_controller.dart';

class SpendingScreen extends StatelessWidget {
  const SpendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SpendingController());

    return SafeArea(
      child: Obx(
        () => Column(
          children: [
            Container(
              color: Colors.transparent,
              padding: EdgeInsets.symmetric(
                horizontal: context.w(8),
                vertical: context.h(8),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: null,
                    icon: const Icon(Icons.lock_outline),
                  ),
                  IconButton(
                    onPressed: null,
                    icon: const Icon(Icons.copy_outlined),
                  ),
                  IconButton(
                    onPressed: null,
                    icon: const Icon(Icons.share_outlined),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.place_outlined, size: context.f(18)),
                        SizedBox(width: context.w(6)),
                        Expanded(
                          child: Text(
                            controller.locationText.value,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(width: context.w(8)),
                        controller.locationLoading.value
                            ? Container(
                                margin: EdgeInsets.only(
                                  right: context.w(5),
                                  left: context.w(5),
                                ),
                                width: context.h(20),
                                height: context.h(20),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : IconButton(
                                onPressed: () {
                                  controller.checkAndFetchLocation();
                                },
                                icon: Icon(Icons.refresh, size: context.f(20)),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.w(16),
                vertical: context.h(6),
              ),
              child: Row(
                children: [
                  Text(
                    'Hi, Super',
                    style: TextStyle(
                      fontSize: context.f(20),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: null,
                    icon: const Icon(Icons.notifications_none),
                  ),
                  IconButton(
                    onPressed: null,
                    icon: const Icon(Icons.person_outline),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.w(16)),
              child: Container(
                height: context.h(140),
                decoration: BoxDecoration(
                  color: const Color(0xFFA5D6A7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Keep this empty',
                    style: TextStyle(
                      fontSize: context.f(22),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: context.w(8),
                  right: context.w(8),
                  top: context.h(8),
                ),
                child: Card(
                  color: AppColor.cardBackground,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.w(16),
                          vertical: context.h(16),
                        ),
                        child: Text(
                          'Spending by category',
                          style: TextStyle(
                            fontSize: context.f(16),
                            fontWeight: FontWeight.w600,
                            color: AppColor.darkGrey,
                          ),
                        ),
                      ),
                      Expanded(
                        child: controller.loading.value
                            ? const Center(child: CircularProgressIndicator())
                            : GridView.builder(
                                padding: EdgeInsets.symmetric(
                                  horizontal: context.w(16),
                                ),
                                itemCount: controller.categories.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      childAspectRatio: 0.55,
                                    ),
                                itemBuilder: (context, index) {
                                  final m = controller.categories[index];
                                  return CategoryCard(model: m);
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
