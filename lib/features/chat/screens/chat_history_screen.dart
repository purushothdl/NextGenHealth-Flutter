// lib/features/chat/screens/chat_history_screen.dart
import 'package:flutter/material.dart';
import 'package:next_gen_health/features/auth/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import 'chat_screen.dart';
import 'package:intl/intl.dart';

class ChatHistoryScreen extends StatelessWidget {
  const ChatHistoryScreen({super.key});

  Future<void> _loadChats(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.currentUser?['user_id'];
    if (userId != null) {
      await context.read<ChatProvider>().loadUserChats(userId, forceReload: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Initialize chats if not already loaded
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final userId = authProvider.currentUser?['user_id'];
    
    if (!chatProvider.isInitialized && userId != null) {
      chatProvider.loadUserChats(userId);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.read<ChatProvider>().clearActiveSession();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatScreen(),
                ),
              );
            },
          ),
        ],
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
                    physics: const AlwaysScrollableScrollPhysics(), // Ensure it's always scrollable
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight, // Ensure it takes full height
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
                                );
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
                    title: Row(
                      children: [
                        Text(
                          'Chat ${index + 1}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (chat.ticketId != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Ticket #${chat.ticketId}',
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            sessionId: chat.sessionId,
                          ),
                        ),
                      );
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