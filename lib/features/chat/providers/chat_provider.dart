// lib/features/chat/providers/chat_provider.dart
import 'package:flutter/material.dart';
import '../../../core/services/api/chat_api_service.dart';
import '../models/chat_model.dart';

class ChatProvider extends ChangeNotifier {
  final ChatApiService _chatService = ChatApiService();
  ChatSession? _activeSession;
  List<ChatSession> _userChats = [];
  bool isLoading = false;
  bool _isInitialized = false; // Add this flag
  String? error;

  ChatSession? get activeSession => _activeSession;
  List<ChatSession> get userChats => _userChats;
  bool get isInitialized => _isInitialized; // Add this getter

Future<void> loadUserChats(String userId, {String? ticketId, bool forceReload = false}) async {
  // Skip if already loading or initialized (unless force reload)
  if (isLoading || (_isInitialized && !forceReload)) return;

  isLoading = true;
  error = null;
  _notifyListeners();

  try {
    final chats = await _chatService.getUserChats(userId, ticketId: ticketId);
    _userChats = chats; // Update chats even if empty
    _isInitialized = true;
    _notifyListeners();
  } catch (e) {
    error = e.toString();
    _notifyListeners();
  } finally {
    isLoading = false;
    _notifyListeners();
  }
}

  Future<void> loadChatSession(String sessionId) async {
    if (isLoading) return; // Avoid duplicate loads

    isLoading = true;
    error = null;
    _notifyListeners();

    try {
      final session = await _chatService.getChatById(sessionId);
      if (session != _activeSession) {
        _activeSession = session;
        _notifyListeners();
      }
    } catch (e) {
      error = e.toString();
      _notifyListeners();
    } finally {
      isLoading = false;
      _notifyListeners();
    }
  }

  Future<void> startChat({
    String? ticketId,
    String? initialMessage,
    String? imagePath,
    String? documentPath,
  }) async {
    if (isLoading) return; // Avoid duplicate loads

    isLoading = true;
    error = null;
    _notifyListeners();

    try {
      final session = await _chatService.startChat(
        ticketId: ticketId,
        message: initialMessage,
        imagePath: imagePath,
        documentPath: documentPath,
      );
      if (session != _activeSession) {
        _activeSession = session;
        _notifyListeners();
      }
    } catch (e) {
      error = e.toString();
      _notifyListeners();
    } finally {
      isLoading = false;
      _notifyListeners();
    }
  }

  Future<void> sendMessage(String message, {String? imagePath, String? documentPath}) async {
    if (_activeSession == null || isLoading) return;

    isLoading = true;
    error = null;
    _notifyListeners();

    try {
      final updatedSession = await _chatService.continueChat(
        sessionId: _activeSession!.sessionId,
        message: message,
        imagePath: imagePath,
        documentPath: documentPath,
      );
      if (updatedSession != _activeSession) {
        _activeSession = updatedSession;
        _notifyListeners();
      }
    } catch (e) {
      error = e.toString();
      _notifyListeners();
    } finally {
      isLoading = false;
      _notifyListeners();
    }
  }

  void reset() {
    _activeSession = null;
    _userChats = [];
    isLoading = false;
    error = null;
    _notifyListeners();
  }

  void clearActiveSession() {
    _activeSession = null;
    _notifyListeners();
  }

  // Helper method to defer notifyListeners() until after the current frame
  void _notifyListeners() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}