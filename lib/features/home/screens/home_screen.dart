// lib/features/home/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../dashboard/screens/dashboard_screen.dart';
import '../../tickets/screens/ticket_screen.dart';
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

  // Persistent instances of each screen
  final List<Widget> _screens = [
    const DashboardScreen(),
    const TicketScreen(),
    const ChatHistoryScreen(),
    const ProfileScreen(),
  ];

  final List<BottomNavigationBarItem> _bottomNavItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.dashboard),
      label: 'Dashboard',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.assignment),
      label: 'Tickets',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.bubble_chart),
      label: 'Chatbot',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Display the selected screen
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: _bottomNavItems,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}