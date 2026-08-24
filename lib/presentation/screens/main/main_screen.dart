import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/auth_provider.dart';
import '../../pages/home/home_page.dart';
import '../../pages/notification/notification_page.dart';
import '../../pages/profile/profile_page.dart';
import '../../pages/report/report_page.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(currentUserProvider)?.userType.toLowerCase();
    final isSe = role == 'se';
    final pages = <Widget>[
      const HomePage(),
      if (!isSe) const ReportPage(),
      const NotificationPage(),
      const ProfilePage(),
    ];
    final navItems = <_MainNavItem>[
      const _MainNavItem(Icons.home_outlined, Icons.home, 'Home'),
      if (!isSe) const _MainNavItem(Icons.assignment_outlined, Icons.assignment, 'My Reports'),
      const _MainNavItem(Icons.notifications_outlined, Icons.notifications, 'Notifications'),
      const _MainNavItem(Icons.person_outline, Icons.person, 'Profile'),
    ];

    if (_currentIndex >= pages.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _currentIndex = 0);
      });
    }

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey[200]!, width: 1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 18,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            height: 66,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                navItems.length,
                (index) => _buildNavItem(index, navItems[index]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, _MainNavItem item) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? const Color(0xFF3D9A7E) : Colors.grey[500];

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: InkWell(
          onTap: () => setState(() => _currentIndex = index),
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF3D9A7E).withValues(alpha: 0.10) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedScale(
                  scale: isSelected ? 1.05 : 1,
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutCubic,
                  child: Icon(
                    isSelected ? item.selectedIcon : item.icon,
                    color: color,
                    size: 22,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MainNavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const _MainNavItem(this.icon, this.selectedIcon, this.label);
}
