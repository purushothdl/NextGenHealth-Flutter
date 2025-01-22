// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:next_gen_health/features/feedback%20and%20FAQ/providers/feedback_provider.dart';
import 'package:provider/provider.dart';
import 'core/services/firebase/firebase_service.dart';
import 'features/admin/providers/admin_provider.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/chat/providers/app_state_providers.dart';
import 'features/feedback and FAQ/providers/faq_provider.dart';
import 'features/notifications/provider/notifications_provider.dart';
import 'features/tickets/providers/ticket_provider.dart';
import 'features/chat/providers/chat_provider.dart';
import 'features/auth/screens/loading_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(); // Initialize Firebase before anything else

  // Initialize FirebaseService
  final firebaseService = FirebaseService();
  await firebaseService.initialize();
  firebaseService.setupNotificationHandlers();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final routeObserver = RouteObserver<ModalRoute<void>>();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TicketProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider()),
        ChangeNotifierProvider(create: (_) => AppStateProvider()),
        ChangeNotifierProvider(create: (_) => FeedbackProvider()),
        ChangeNotifierProvider(create: (_) => FAQProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        Provider<RouteObserver<ModalRoute<void>>>(create: (_) => routeObserver),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Healthcare App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const LoadingScreen(), // Start with LoadingScreen
        navigatorObservers: [routeObserver],
      ),
    );
  }
}