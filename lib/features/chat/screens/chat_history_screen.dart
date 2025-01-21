// lib/features/chat/screens/chat_history_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:next_gen_health/features/auth/providers/auth_provider.dart';
import '../../home/screens/home_screen.dart';
import '../providers/app_state_providers.dart';
import '../providers/chat_provider.dart';
import '../widgets/chat history/chat_history_list.dart';
import '../widgets/chat history/empty_chat_history.dart';
import 'chat_screen.dart';
import 'package:intl/intl.dart';
import 'package:flutter/scheduler.dart';


class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({super.key});

  @override
  _ChatHistoryScreenState createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> with RouteAware {
  RouteObserver<ModalRoute<void>>? _routeObserver;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _routeObserver = Provider.of<RouteObserver<ModalRoute<void>>>(context, listen: false);
    _routeObserver?.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    _routeObserver?.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _loadChats(context);
  }

  @override
  void initState() {
    super.initState();
    final appStateProvider = Provider.of<AppStateProvider>(context, listen: false);
    if (appStateProvider.isAppStart) {
      _loadChats(context);
      appStateProvider.setAppStart(false);
    }
  }

  Future<void> _loadChats(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.currentUser?['user_id'];
    if (userId != null) {
      await context.read<ChatProvider>().loadUserChats(userId, forceReload: true);
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final userId = authProvider.currentUser?['user_id'];

    if (!chatProvider.isInitialized && userId != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        chatProvider.loadUserChats(userId);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chat History',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              context.read<ChatProvider>().clearActiveSession();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatScreen(),
                ),
              ).then((_) => _loadChats(context));
            },
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeApp()),
            );
          },
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () => _loadChats(context),
        child: Consumer<ChatProvider>(
          builder: (context, chatProvider, _) {
            if (!chatProvider.isInitialized && chatProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (chatProvider.error != null) {
              return Center(
                child: Text(
                  'Error: ${chatProvider.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (chatProvider.userChats.isEmpty) {
              return const EmptyChatHistory();
            }

            return ChatHistoryList(chatProvider: chatProvider);
          },
        ),
      ),
    );
  }
}