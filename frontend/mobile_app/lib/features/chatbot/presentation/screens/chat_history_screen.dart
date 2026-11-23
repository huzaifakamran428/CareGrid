import 'package:flutter/material.dart';
import '../../../../app/theme/brand_tokens.dart';
import '../../../../core/widgets/caregrid_brand.dart';
import '../state/chat_demo_store.dart';
import 'chatbot_screen.dart';

/// Search and reopen conversations from this app session; no server sync.
class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({super.key});

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  final _search = TextEditingController();
  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _openChat([String? sessionId]) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => CaregridChatbotScreen(sessionId: sessionId),
      ),
    );
  }

  Future<void> _removeChat(DemoChatSession session) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete this conversation?'),
        content: const Text('This removes the conversation from the current demo session.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Keep'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    chatDemoStore.deleteSession(session.id);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Chat history'),
      actions: [
        TextButton.icon(
          onPressed: () => _openChat(),
          icon: const Icon(Icons.add_comment_outlined),
          label: const Text('New'),
        ),
      ],
    ),
    body: SafeArea(child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: const CareGridPalette.paleMint,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
          child: const Row(children: [
            Icon(Icons.info_outline, color: CareGridPalette.primary, size: 19),
            SizedBox(width: 9),
            Expanded(child: Text(
              'Demo history only. Chats are not saved to the cloud.',
              style: TextStyle(color: CareGridPalette.ink, fontSize: 12),
            )),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: TextField(
            controller: _search,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Search conversations',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                tooltip: 'Clear search',
                icon: const Icon(Icons.close),
                onPressed: () => setState(() => _search.clear()),
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
        Expanded(child: AnimatedBuilder(
          animation: chatDemoStore,
          builder: (context, _) {
            final query = _search.text.toLowerCase().trim();
            final sessions = chatDemoStore.sessions.where(
              (session) => query.isEmpty ||
                  session.title.toLowerCase().contains(query) ||
                  session.messages.any((msg) =>
                      msg.text.toLowerCase().contains(query)),
            ).toList();
            if (sessions.isEmpty) {
              return Center(child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.forum_outlined,
                        size: 48, color: CareGridPalette.primary),
                    const SizedBox(height: 12),
                    Text(query.isEmpty
                        ? 'No conversations yet'
                        : 'No conversations match your search',
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
                    const SizedBox(height: 9),
                    const Text('Ask the demo assistant a question to create a transcript.',
                        textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () => _openChat(),
                      icon: const Icon(Icons.chat_outlined),
                      label: const Text('Start a chat'),
                    ),
                  ],
                ),
              ));
            }
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 2, 16, 24),
              itemCount: sessions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final session = sessions[index];
                final d = session.updatedAt;
                final date = '${d.day}/${d.month}/${d.year}';
                return Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: const BorderSide(color: CareGridPalette.line),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(14, 10, 3, 10),
                    leading: const CircleAvatar(
                      backgroundColor: CareGridPalette.paleMint,
                      child: Icon(Icons.chat_bubble_outline,
                          color: CareGridPalette.primary),
                    ),
                    title: Text(session.title,
                        maxLines: 2, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text('$date • ${session.messages.length} messages'),
                    ),
                    onTap: () => _openChat(session.id),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      tooltip: 'Delete conversation',
                      onPressed: () => _removeChat(session),
                    ),
                  ),
                );
              },
            );
          },
        )),
      ],
    )),
  );
}
