// lib/features/chat/screens/chat_screen.dart
import 'package:flutter/material.dart';
import 'package:next_gen_health/features/chat/screens/chat_history_screen.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../widgets/chatbot/chat_input_widget.dart';
import '../widgets/chatbot/chat_message_widget.dart';

class ChatScreen extends StatefulWidget {
  final String? sessionId;
  final String? ticketId;

  const ChatScreen({
    super.key,
    this.sessionId,
    this.ticketId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  void _initializeChat() {
    if (widget.sessionId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          final chatProvider = context.read<ChatProvider>();
          chatProvider.loadChatSession(widget.sessionId!);
        }
      });
    } else if (widget.ticketId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          final chatProvider = context.read<ChatProvider>();
          chatProvider.startChat(ticketId: widget.ticketId!);
        }
      });
    } else {
      // Clear active session if no sessionId or ticketId is provided
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          final chatProvider = context.read<ChatProvider>();
          chatProvider.clearActiveSession();
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'NextGenHealth Chatbot',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ChatHistoryScreen()),
            );
          },
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue,
      ),
      backgroundColor: const Color.fromARGB(255, 246, 246, 246),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, _) {
          return Column(
            children: [
              Expanded(
                child: chatProvider.activeSession != null
                    ? ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(8.0),
                        itemCount: chatProvider.activeSession!.messages.length,
                        itemBuilder: (context, index) {
                          final message = chatProvider.activeSession!.messages[index];
                          return ChatMessageWidget(message: message);
                        },
                      )
                    : const Center(
                        child: Text('Start a conversation'),
                      ),
              ),
              if (chatProvider.isLoading) const LinearProgressIndicator(),
              ChatInputWidget(
                enabled: !chatProvider.isLoading,
                onSendMessage: (message, {imagePath, documentPath}) async {
                  if (!mounted) return;

                  if (chatProvider.activeSession == null) {
                    await chatProvider.startChat(
                      ticketId: widget.ticketId,
                      initialMessage: message,
                      imagePath: imagePath,
                      documentPath: documentPath,
                    );
                  } else {
                    await chatProvider.sendMessage(
                      message,
                      imagePath: imagePath,
                      documentPath: documentPath,
                    );
                  }

                  if (mounted) {
                    _scrollToBottom();
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
}