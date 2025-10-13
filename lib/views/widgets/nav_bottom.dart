import 'package:flutter/material.dart';
import 'package:test_system/theme/app_color.dart';
import 'package:test_system/views/spending_view.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 2;

  final List<Widget> screens = const [
    Center(child: Text('Home')),
    Center(child: Text('Finley AI Screen')),
    SpendingScreen(),
    Center(child: Text('Meet Coach')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,

      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) {
          setState(() {
            currentIndex = i;
          });
        },
        selectedItemColor: AppColor.green,
        unselectedItemColor: AppColor.lightGrey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy_outlined),
            label: 'Finley AI',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_outline),
            label: 'Spending',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Meet Coach',
          ),
        ],
      ),
    );
  }
}
