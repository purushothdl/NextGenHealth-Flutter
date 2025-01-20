// lib/features/chat/screens/chat_history_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:next_gen_health/features/auth/providers/auth_provider.dart';
import '../../home/screens/home_screen.dart';
import '../providers/chat_provider.dart';
import 'chat_screen.dart';
import 'package:intl/intl.dart';
import 'package:flutter/scheduler.dart';

class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({super.key});

  @override
  _ChatHistoryScreenState createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> with RouteAware {
  RouteObserver<ModalRoute<void>>? _routeObserver; // Save a reference to the RouteObserver

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Subscribe to the RouteObserver and save the reference
    _routeObserver = Provider.of<RouteObserver<ModalRoute<void>>>(context, listen: false);
    _routeObserver?.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    // Unsubscribe from the RouteObserver using the saved reference
    _routeObserver?.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Called when the user returns to this route
    _loadChats(context);
  }

  Future<void> _loadChats(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.currentUser?['user_id'];
    if (userId != null) {
      await context.read<ChatProvider>().loadUserChats(userId, forceReload: true);
      if (mounted) {
        // Only update the UI if the widget is still mounted
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Initialize chats if not already loaded
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
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), // White text for visibility
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white), // White add icon
            onPressed: () {
              context.read<ChatProvider>().clearActiveSession();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatScreen(),
                ),
              ).then((_) {
                _loadChats(context);
              });
            },
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // White back icon
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeApp()),
            );
          },
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue, // Blue background
        automaticallyImplyLeading: false, // Disable default back button
      ),
      
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
              return LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
                            const SizedBox(height: 16),
                            const Text(
                              'No chat history yet',
                              style: TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.add),
                              label: const Text('Start New Chat'),
                              onPressed: () {
                                context.read<ChatProvider>().clearActiveSession();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ChatScreen(),
                                  ),
                                ).then((_) {
                                  // Reload chats when returning from ChatScreen
                                  _loadChats(context);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return ListView.builder(
              itemCount: chatProvider.userChats.length,
              itemBuilder: (context, index) {
                final chat = chatProvider.userChats[index];
                final lastMessage = chat.messages.isNotEmpty ? chat.messages.last : null;

return Card(
  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  child: ListTile(
    leading: CircleAvatar(
      backgroundColor: Theme.of(context).primaryColor,
      child: const Icon(Icons.chat, color: Colors.white),
    ),
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Chat ${index + 1}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        if (chat.ticketId != null) ...[
          const SizedBox(height: 4), // Add spacing between chat number and ticket ID
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _truncateTicketId(chat.ticketId!), // Truncate the ticket ID
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ],
    ),
    subtitle: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (lastMessage != null) ...[
          const SizedBox(height: 4),
          Text(
            lastMessage.text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        const SizedBox(height: 4),
        Text(
          'Last updated: ${DateFormat('MMM d, y HH:mm').format(chat.updatedAt)}',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    ),
    trailing: IconButton(
      icon: const Icon(Icons.delete, color: Colors.red),
      onPressed: () async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Chat'),
            content: const Text('Are you sure you want to delete this chat?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );

        if (confirmed == true) {
          await context.read<ChatProvider>().deleteChat(chat.sessionId);
          // Reload chats after deletion
          _loadChats(context);
        }
      },
    ),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            sessionId: chat.sessionId,
          ),
        ),
      ).then((_) {
        // Reload chats when returning from ChatScreen
        _loadChats(context);
      });
    },
  ),
);
              },
            );
          },
        ),
      ),
    );
  }
}

String _truncateTicketId(String ticketId) {
  const maxLength = 25; // Maximum length of the displayed ticket ID
  if (ticketId.length <= maxLength) {
    return ticketId; // No need to truncate
  }
  // Truncate the ticket ID with '...' in the middle
  final prefix = ticketId.substring(0, maxLength ~/ 2);
  final suffix = ticketId.substring(ticketId.length - maxLength ~/ 2);
  return '$prefix...$suffix';
}