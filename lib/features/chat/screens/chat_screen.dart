// lib/features/chat/screens/chat_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../widgets/chat_input_widget.dart';
import '../widgets/chat_message_widget.dart';

class ChatScreen extends StatefulWidget {
  final String? sessionId; // Add sessionId as an optional parameter
  final String? ticketId; // Add ticketId as an optional parameter

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
    // Load the chat session if sessionId is provided
    if (widget.sessionId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          final chatProvider = context.read<ChatProvider>();
          chatProvider.loadChatSession(widget.sessionId!);
        }
      });
    }
    // Start the chat with the ticketId if provided
    else if (widget.ticketId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          final chatProvider = context.read<ChatProvider>();
          chatProvider.startChat(ticketId: widget.ticketId!);
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
        title: const Text('Medical Assistant'),
      ),
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
                  if (!mounted) return; // Ensure the widget is still mounted

                  if (chatProvider.activeSession == null) {
                    await chatProvider.startChat(
                      ticketId: widget.ticketId, // Pass ticketId if available
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