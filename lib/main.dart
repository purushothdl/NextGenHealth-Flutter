// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/admin/providers/admin_provider.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/tickets/providers/ticket_provider.dart';
import 'features/chat/providers/chat_provider.dart';
import 'features/auth/screens/loading_screen.dart';
import 'features/home/screens/home_screen.dart'; // Import HomeApp

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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