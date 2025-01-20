// lib/features/chat/providers/chat_provider.dart
import 'package:flutter/material.dart';
import '../../../core/services/api/chat_api_service.dart';
import '../models/chat_model.dart';

class ChatProvider extends ChangeNotifier {
  final ChatApiService _chatService = ChatApiService();
  ChatSession? _activeSession;
  List<ChatSession> _userChats = [];
  bool isLoading = false;
  bool _isInitialized = false;
  String? error;

  ChatSession? get activeSession => _activeSession;
  List<ChatSession> get userChats => _userChats;
  bool get isInitialized => _isInitialized;

  Future<void> loadUserChats(String userId, {String? ticketId, bool forceReload = false}) async {
    if (isLoading || (_isInitialized && !forceReload)) return;

    isLoading = true;
    error = null;
    _safeNotifyListeners();

    try {
      final chats = await _chatService.getUserChats(userId, ticketId: ticketId);
      _userChats = chats;
      _isInitialized = true;
      _safeNotifyListeners();
    } catch (e) {
      error = e.toString();
      _safeNotifyListeners();
    } finally {
      isLoading = false;
      _safeNotifyListeners();
    }
  }

  Future<void> loadChatSession(String sessionId) async {
    if (isLoading) return;

    isLoading = true;
    error = null;
    _safeNotifyListeners();

    try {
      final session = await _chatService.getChatById(sessionId);
      if (session != _activeSession) {
        _activeSession = session;
        _safeNotifyListeners();
      }
    } catch (e) {
      error = e.toString();
      _safeNotifyListeners();
    } finally {
      isLoading = false;
      _safeNotifyListeners();
    }
  }

  Future<void> startChat({
    String? ticketId,
    String? initialMessage,
    String? imagePath,
    String? documentPath,
  }) async {
    if (isLoading) return;

    isLoading = true;
    error = null;
    _safeNotifyListeners();

    try {
      final session = await _chatService.startChat(
        ticketId: ticketId,
        message: initialMessage,
        imagePath: imagePath,
        documentPath: documentPath,
      );
      if (session != _activeSession) {
        _activeSession = session;
        _safeNotifyListeners();
      }
    } catch (e) {
      error = e.toString();
      _safeNotifyListeners();
    } finally {
      isLoading = false;
      _safeNotifyListeners();
    }
  }

  Future<void> sendMessage(String message, {String? imagePath, String? documentPath}) async {
    if (_activeSession == null || isLoading) return;

    isLoading = true;
    error = null;
    _safeNotifyListeners();

    try {
      final updatedSession = await _chatService.continueChat(
        sessionId: _activeSession!.sessionId,
        message: message,
        imagePath: imagePath,
        documentPath: documentPath,
      );
      if (updatedSession != _activeSession) {
        _activeSession = updatedSession;
        _safeNotifyListeners();
      }
    } catch (e) {
      error = e.toString();
      _safeNotifyListeners();
    } finally {
      isLoading = false;
      _safeNotifyListeners();
    }
  }

  void reset() {
    _activeSession = null;
    _userChats = [];
    isLoading = false;
    error = null;
    _safeNotifyListeners();
  }

  void clearActiveSession() {
    _activeSession = null;
    _safeNotifyListeners();
  }

  Future<void> deleteChat(String sessionId) async {
    isLoading = true;
    error = null;
    _safeNotifyListeners();

    try {
      await _chatService.deleteChatSession(sessionId);
      _userChats.removeWhere((chat) => chat.sessionId == sessionId);
      _safeNotifyListeners();
    } catch (e) {
      error = e.toString();
      _safeNotifyListeners();
    } finally {
      isLoading = false;
      _safeNotifyListeners();
    }
  }

  // Helper method to safely notify listeners
  void _safeNotifyListeners() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isDisposed) {
        notifyListeners();
      }
    });
  }

  // Track if the provider is disposed
  bool isDisposed = false;

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }
}