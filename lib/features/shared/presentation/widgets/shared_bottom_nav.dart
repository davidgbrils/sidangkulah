import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sidangkufix/core/constants/app_colors.dart';

class SharedBottomNav extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final List<BottomNavigationBarItem> items;

  const SharedBottomNav({
    super.key,
    required this.navigationShell,
    required this.items,
  });

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        height: 80,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Color(0xFFE0E7EF),
              width: 1.0,
            ),
          ),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            currentIndex: navigationShell.currentIndex,
            onTap: _onTap,
            items: items,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: const Color(0xFF9AA0A6),
            selectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
