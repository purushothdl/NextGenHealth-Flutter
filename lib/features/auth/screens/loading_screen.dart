// lib/features/auth/screens/loading_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../dashboard/screens/dashboard_screen.dart';
import '../../screening/screens/screening_form_screen.dart';
import '../providers/auth_provider.dart';
import 'register_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final hasUser = await authProvider.checkAndLoadUser();
    
    if (!mounted) return;

    if (!hasUser) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => RegisterScreen()),
      );
      return;
    }

    final user = authProvider.currentUser;
    if (user == null) return;

    if (user['role'] == 'admin') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
      return;
    }

    final needsScreening = user['role'] == 'patient' 
        ? user['patient_data'] == null
        : user['doctor_data'] == null;

    if (needsScreening) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ScreeningFormScreen()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}