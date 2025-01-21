// lib/features/home/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../dashboard/screens/dashboard_screen.dart';
import '../../tickets/screens/tickets_screen.dart';
import '../../chat/screens/chat_screen.dart';
import '../../chat/screens/chat_history_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../chat/providers/chat_provider.dart';

class HomeApp extends StatefulWidget {
  const HomeApp({super.key});

  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  int _selectedIndex = 0;
  final double _navBarHeight = 72;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const TicketScreen(),
    const ChatHistoryScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        height: _navBarHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey.withOpacity(0.1),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            _navItems.length,
            (index) => _NavItem(
              icon: _navItems[index].icon,
              label: _navItems[index].label,
              isActive: _selectedIndex == index,
              onTap: () => setState(() => _selectedIndex = index),
            ),
          ),
        ),
      ),
    );
  }

  final List<({IconData icon, String label})> _navItems = [
    (icon: Icons.dashboard_rounded, label: 'Dashboard'),
    (icon: Icons.assignment_outlined, label: 'Tickets'),
    (icon: Icons.medical_services_outlined, label: 'Health AI'),
    (icon: Icons.person_outline_rounded, label: 'Profile'),
  ];
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isActive ? Colors.blue[50] : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: isActive
                    ? [const Color(0xFF3BAEE9), const Color(0xFF6AC8F5)]
                    : [Colors.grey, Colors.grey],
              ).createShader(bounds),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, anim) => ScaleTransition(
                  scale: anim,
                  child: child,
                ),
                child: Icon(
                  icon,
                  key: ValueKey(isActive),
                  size: isActive ? 28 : 24,
                  color: isActive ? Colors.white : Colors.grey[400],
                ),
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                fontSize: isActive ? 12 : 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive ? const Color(0xFF3BAEE9) : Colors.grey[600],
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}