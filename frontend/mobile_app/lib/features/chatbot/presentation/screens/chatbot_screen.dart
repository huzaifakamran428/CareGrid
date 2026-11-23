// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import '../state/chat_demo_store.dart';
import 'chat_history_screen.dart';

class CaregridChatbotScreen extends StatefulWidget {
  final String? sessionId;
  const CaregridChatbotScreen({super.key, this.sessionId});

  @override
  State<CaregridChatbotScreen> createState() => _CaregridChatbotScreenState();
}

class _CaregridChatbotScreenState extends State<CaregridChatbotScreen> {
  // ---------------------------------------------------------------------------
  // CAREGRID DESIGN SYSTEM COLORS
  // ---------------------------------------------------------------------------
  static const Color _primaryGreen = Color(0xFF14634B);
  static const Color _headerBadgeBg = Color(0xFF1E755B);
  static const Color _headerBadgeBorder = Color(0xFF3E8E75);
  static const Color _amberBadge = Color(0xFFF4A623);

  static const Color _mintCardBg = Color(0xFFDDF2EA);
  static const Color _mintCardBorder = Color(0xFF2B7A62);
  static const Color _darkForestText = Color(0xFF1B4332);
  static const Color _mutedText = Color(0xFF4A635A);

  static const Color _canvasBg = Color(0xFFF8FAFC);
  static const Color _neutralBtnBg = Color(0xFFF1F5F4);
  static const Color _neutralBtnBorder = Color(0xFFD5DFDC);

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isUrduMode = false;
  bool _isTyping = false;

  final List _quickPromptsEn = [
    'Check my remaining medical subsidy',
    'How do I book an 80% subsidized lab test?',
    'Nearest CareGrid partner pharmacy',
    'Documents needed for ration renewal',
  ];

  final List _quickPromptsUr = [
    'Meri baaqi medical subsidy kitni hai?',
    'Subsidized lab test kaise book karein?',
    'Qareebi partner pharmacy kahan hai?',
    'Ration renewal ke liye kaunse documents chahiye?',
  ];

  late final List<Map<String, dynamic>> _messages;
  String? _sessionId;

  @override
  void initState() {
    super.initState();
    final session = widget.sessionId == null
        ? null : chatDemoStore.find(widget.sessionId!);
    if (session == null) {
      _messages = [
        {
          'sender': 'ai',
          'text': 'Assalam-o-Alaikum! This CareGrid help preview can explain how to browse labs, use your Digital ID and send complaints. I cannot access a real beneficiary account.',
          'source': 'Demo guidance • Not live data',
          'time': 'Now',
        },
      ];
    } else {
      _sessionId = session.id;
      _messages = session.messages.map((message) => <String, dynamic>{
        'sender': message.sender,
        'text': message.text,
        'source': message.sender == 'ai' ? 'Demo answer • Not live data' : '',
        'time': 'Saved in session',
      }).toList();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage([String? presetText]) {
    final String query = (presetText ?? _messageController.text).trim();
    if (query.isEmpty) return;
    _sessionId ??= chatDemoStore.startSession();
    chatDemoStore.addMessage(_sessionId!, sender: 'user', text: query);

    setState(() {
      _messages.add({
        'sender': 'user',
        'text': query,
        'source': '',
        'time': 'Just now',
      });
      _messageController.clear();
      _isTyping = true;
    });

    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 650), () {
      if (!mounted) return;
      final Map reply = _generateDemoReply(query);
      chatDemoStore.addMessage(_sessionId!, sender: 'ai', text: reply['text'].toString());
      setState(() {
        _isTyping = false;
        _messages.add({
          'sender': 'ai',
          'text': reply['text'],
          'source': reply['source'],
          'time': 'Just now',
        });
      });
      _scrollToBottom();
    });
  }

  Map _generateDemoReply(String query) {
    final q = query.toLowerCase();
    String answer;
    if (q.contains('lab') || q.contains('test') || q.contains('book')) {
      answer = 'Open the Labs tab to browse sample partner tests, compare the example prices, choose a lab and save a demo appointment. Real availability needs a laboratory API.';
    } else if (q.contains('pharmacy') || q.contains('medicine')) {
      answer = 'The Profile tab displays example subsidy information. Actual medicine limits and partner pharmacy access require beneficiary verification and an active backend.';
    } else if (q.contains('ration') || q.contains('document') || q.contains('renewal')) {
      answer = 'For welfare support, keep your identity and eligibility documents ready. Your NGO can confirm the specific application and renewal requirements. This preview cannot verify your case.';
    } else if (q.contains('complaint') || q.contains('help')) {
      answer = 'Use the Support tab to submit a complaint and track its demo reference number, or rate a welfare service.';
    } else {
      answer = 'I can explain CareGrid screens and workflows, but I cannot check live eligibility, account balances or records. For assistance, open Support.';
    }
    return {'text': answer, 'source': 'Demo guidance • No live data'};
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List activePrompts = _isUrduMode ? _quickPromptsUr : _quickPromptsEn;

    return Scaffold(
      backgroundColor: _primaryGreen,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // 1. TOP FOREST GREEN HEADER
            _buildTopHeader(),

            // 2. MAIN ROUNDED CHAT SHEET
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: _canvasBg,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                  child: Column(
                    children: [
                      // Chat Messages Stream
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
                          itemCount: _messages.length + (_isTyping ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (_isTyping && index == _messages.length) {
                              return _buildTypingIndicator();
                            }
                            final Map msg = _messages[index] as Map;
                            return _buildMessageBubble(msg);
                          },
                        ),
                      ),

                      // Quick Prompt Suggestion Chips
                      _buildQuickPromptStrip(activePrompts),

                      // Bottom Message Composer
                      _buildInputBar(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.maybePop(context),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _headerBadgeBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _headerBadgeBorder),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 16),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'CareGrid Help',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: _amberBadge,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'DEMO',
                        style: TextStyle(
                          color: _darkForestText,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Sample responses · offline preview',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.88),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Chat history',
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(
                builder: (_) => const ChatHistoryScreen(),
              ),
            ),
            icon: const Icon(Icons.history, color: Colors.white),
          ),
          InkWell(
            onTap: () {
              setState(() {
                _isUrduMode = !_isUrduMode;
              });
            },
            borderRadius: BorderRadius.circular(9),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _headerBadgeBg,
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: _headerBadgeBorder),
              ),
              child: Text(
                _isUrduMode ? 'EN / اردو' : 'اردو / EN',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map msg) {
    final bool isAi = msg['sender'] == 'ai';
    final String source = msg['source'].toString();

    return Align(
      alignment: isAi ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.82,
        ),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isAi ? Colors.white : _primaryGreen,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isAi ? 4 : 18),
            bottomRight: Radius.circular(isAi ? 18 : 4),
          ),
          border: isAi
              ? Border.all(color: _mintCardBorder.withValues(alpha: 0.45), width: 1.2)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isAi)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: _mintCardBg,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(Icons.auto_awesome_rounded,
                          color: _primaryGreen, size: 12),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'CAREGRID GUIDE',
                      style: TextStyle(
                        color: _primaryGreen,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
              ),
            Text(
              msg['text'].toString(),
              style: TextStyle(
                color: isAi ? _darkForestText : Colors.white,
                fontSize: 13.5,
                height: 1.42,
                fontWeight: isAi ? FontWeight.w500 : FontWeight.w600,
              ),
            ),
            if (isAi && source.isNotEmpty) ...[
              const SizedBox(height: 9),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: _mintCardBg,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(
                  source,
                  style: const TextStyle(
                    color: _primaryGreen,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 5),
            Text(
              msg['time'].toString(),
              style: TextStyle(
                color: isAi
                    ? _mutedText
                    : Colors.white.withValues(alpha: 0.78),
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: _mintCardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _mintCardBorder, width: 1),
        ),
        child: const Text(
          'Searching CareGrid welfare policies...',
          style: TextStyle(
            color: _primaryGreen,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildQuickPromptStrip(List prompts) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: prompts.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final String text = prompts[index].toString();
          return InkWell(
            onTap: () => _sendMessage(text),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
              decoration: BoxDecoration(
                color: _mintCardBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _mintCardBorder, width: 1),
              ),
              child: Center(
                child: Text(
                  text,
                  style: const TextStyle(
                    color: _darkForestText,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _neutralBtnBorder, width: 1.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              onSubmitted: (_) => _sendMessage(),
              style: const TextStyle(
                color: _darkForestText,
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: _isUrduMode
                    ? 'Roman Urdu ya English mein sawal likhein...'
                    : 'Ask about subsidies, lab tests, or clinics...',
                hintStyle: const TextStyle(color: _mutedText, fontSize: 13),
                filled: true,
                fillColor: _neutralBtnBg,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: _neutralBtnBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: _neutralBtnBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide:
                      const BorderSide(color: _primaryGreen, width: 1.5),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: () => _sendMessage(),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: _primaryGreen,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.send_rounded,
                  color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}