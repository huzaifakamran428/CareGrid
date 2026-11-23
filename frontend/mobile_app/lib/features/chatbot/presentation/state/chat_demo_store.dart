import 'package:flutter/foundation.dart';

/// In-memory chatbot transcript store for UI demonstrations only.
class DemoChatMessage {
  final String sender;
  final String text;
  final DateTime createdAt;
  const DemoChatMessage({required this.sender, required this.text,
      required this.createdAt});
}

class DemoChatSession {
  final String id;
  final DateTime createdAt;
  final List<DemoChatMessage> messages = [];
  DemoChatSession(this.id, this.createdAt);

  String get title {
    for (final message in messages) {
      if (message.sender == 'user') return message.text;
    }
    return 'New conversation';
  }
  DateTime get updatedAt => messages.isEmpty ? createdAt : messages.last.createdAt;
}

class ChatDemoStore extends ChangeNotifier {
  final List<DemoChatSession> _sessions = [];
  List<DemoChatSession> get sessions => List.unmodifiable(_sessions);

  DemoChatSession? find(String id) {
    for (final session in _sessions) {
      if (session.id == id) return session;
    }
    return null;
  }

  String startSession() {
    final now = DateTime.now();
    final id = 'CHAT-DEMO-${now.microsecondsSinceEpoch}';
    _sessions.insert(0, DemoChatSession(id, now));
    notifyListeners();
    return id;
  }

  void addMessage(String id, {required String sender, required String text}) {
    final session = find(id);
    if (session == null) return;
    session.messages.add(DemoChatMessage(
      sender: sender, text: text, createdAt: DateTime.now(),
    ));
    notifyListeners();
  }

  bool deleteSession(String id) {
    final originalLength = _sessions.length;
    _sessions.removeWhere((session) => session.id == id);
    if (_sessions.length == originalLength) return false;
    notifyListeners();
    return true;
  }
}

final chatDemoStore = ChatDemoStore();
