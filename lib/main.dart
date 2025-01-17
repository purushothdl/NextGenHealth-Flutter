// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/tickets/providers/ticket_provider.dart';
import 'features/chat/providers/chat_provider.dart'; // Import ChatProvider
import 'features/auth/screens/loading_screen.dart';
import 'features/tickets/screens/ticket_screen.dart'; // Import the TicketScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TicketProvider()), // Add TicketProvider here
        ChangeNotifierProvider(create: (_) => ChatProvider()), // Add ChatProvider here
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Healthcare App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const LoadingScreen(),
      ),
    );
  }
}