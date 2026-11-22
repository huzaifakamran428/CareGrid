// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';

class CareGridChatbotScreen extends StatefulWidget {
  const CareGridChatbotScreen({super.key});

  @override
  State<CareGridChatbotScreen> createState() => _CareGridChatbotScreenState();
}

class _CareGridChatbotScreenState extends State<CareGridChatbotScreen> {
  // ---------------------------------------------------------------------------
  // DESIGN SYSTEM COLORS (100% Consistent across CareGrid Screens)
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

  // ---------------------------------------------------------------------------
  // CHAT STATE & DUMMY CONVERSATION DATA
  // ---------------------------------------------------------------------------
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List _quickPrompts = [
    'How do I use my Digital ID?',
    'What is my pharmacy subsidy?',
    'How to book a subsidized lab?',
    'Can you prescribe medicine?',
  ];

  final List _messages = [
    {
      'sender': 'bot',
      'text':
          'Assalam-o-Alaikum Ayesha! I am the CareGrid Welfare Assistant. Ask me anything about your Digital ID, medicine & lab subsidies, prescription uploads, or submitting a complaint.',
      'time': '09:20 PM',
      'source': 'CareGrid Platform Guide',
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String rawText) {
    final String text = rawText.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({
        'sender': 'user',
        'text': text,
        'time': 'Now',
      });
      _messages.add(_generateGroundedReply(text));
    });

    _messageController.clear();
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

  Map _generateGroundedReply(String query) {
    final String q = query.toLowerCase();

    if (q.contains('prescribe') ||
        q.contains('diagnos') ||
        q.contains('fever') ||
        q.contains('medicine for')) {
      return {
        'sender': 'bot',
        'text':
            'I cannot provide medical diagnoses or recommend specific medicines. Please consult a licensed doctor and upload your signed prescription on the Upload Prescription screen to claim your 70% pharmacy subsidy.',
        'time': 'Now',
        'source': 'Platform Safety Policy',
      };
    }

    if (q.contains('digital id') || q.contains('pass')) {
      return {
        'sender': 'bot',
        'text':
            'Show your CareGrid Digital ID (CG-BEN-2026-009481) from your Home or Profile screen at any partner pharmacy or diagnostic lab. Staff will verify your active status before applying your welfare discount.',
        'time': 'Now',
        'source': 'Beneficiary Verification Rules',
      };
    }

    if (q.contains('pharmacy') || q.contains('subsidy') || q.contains('med')) {
      return {
        'sender': 'bot',
        'text':
            'Your active welfare profile covers 70% of eligible prescription medicines and 80% of partner laboratory tests, up to your monthly cap of Rs. 12,000 (Rs. 8,500 remaining).',
        'time': 'Now',
        'source': 'Subsidy Entitlement Policy',
      };
    }

    if (q.contains('lab') || q.contains('book') || q.contains('test')) {
      return {
        'sender': 'bot',
        'text':
            'Open Subsidized Labs from your Home screen, search for your required test (e.g., CBC or HbA1c), compare partner lab prices, and select an available appointment slot. Your digital report will appear in My Bookings once ready.',
        'time': 'Now',
        'source': 'Diagnostic Booking Guide',
      };
    }

    return {
      'sender': 'bot',
      'text':
          'You can manage your profile documents, upload prescriptions for AI scanning, book subsidized lab tests, or submit a support complaint directly from your Home dashboard.',
      'time': 'Now',
      'source': 'CareGrid Help Center',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _primaryGreen,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // 1. TOP FOREST GREEN HEADER
            _buildTopHeader(),

            // 2. MAIN ROUNDED SHEET CONTAINER
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
                      // Chat Messages List
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            final Map msg = _messages[index] as Map;
                            return _buildMessageBubble(msg);
                          },
                        ),
                      ),

                      // Quick Prompt Suggestion Chips
                      _buildQuickPromptsBar(),

                      // Bottom Message Input Bar
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

  // ---------------------------------------------------------------------------
  // TOP HEADER
  // ---------------------------------------------------------------------------
  Widget _buildTopHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: _amberBadge,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'CAREGRID AI ASSISTANT',
                  style: TextStyle(
                    color: _darkForestText,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _headerBadgeBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _headerBadgeBorder, width: 1),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.circle, color: _amberBadge, size: 8),
                    SizedBox(width: 5),
                    Text(
                      'PLATFORM GUIDE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Welfare Help & Support Chat',
            style: TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Instant answers on subsidies, Digital ID verification, prescriptions & lab bookings.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.88),
              fontSize: 12.5,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // CHAT BUBBLE WIDGET
  // ---------------------------------------------------------------------------
  Widget _buildMessageBubble(Map msg) {
    final bool isBot = msg['sender'] == 'bot';

    return Align(
      alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.82,
        ),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isBot ? _mintCardBg : _primaryGreen,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isBot ? 4 : 16),
            bottomRight: Radius.circular(isBot ? 16 : 4),
          ),
          border: isBot
              ? Border.all(color: _mintCardBorder, width: 1.1)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isBot) ...[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.smart_toy_outlined,
                      color: _primaryGreen, size: 14),
                  const SizedBox(width: 5),
                  Text(
                    msg['source']?.toString() ?? 'CareGrid AI',
                    style: const TextStyle(
                      color: _primaryGreen,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
            ],
            Text(
              msg['text'].toString(),
              style: TextStyle(
                color: isBot ? _darkForestText : Colors.white,
                fontSize: 13,
                fontWeight: isBot ? FontWeight.w600 : FontWeight.w500,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 5),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                msg['time'].toString(),
                style: TextStyle(
                  color: isBot
                      ? _mutedText
                      : Colors.white.withValues(alpha: 0.78),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // QUICK PROMPTS ROW
  // ---------------------------------------------------------------------------
  Widget _buildQuickPromptsBar() {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _quickPrompts.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final String prompt = _quickPrompts[index].toString();
          return GestureDetector(
            onTap: () => _sendMessage(prompt),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _mintCardBorder, width: 1.1),
              ),
              child: Center(
                child: Text(
                  prompt,
                  style: const TextStyle(
                    color: _primaryGreen,
                    fontSize: 11.5,
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

  // ---------------------------------------------------------------------------
  // BOTTOM MESSAGE INPUT BAR
  // ---------------------------------------------------------------------------
  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: _neutralBtnBorder, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: _neutralBtnBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _neutralBtnBorder),
              ),
              child: TextField(
                controller: _messageController,
                onSubmitted: _sendMessage,
                style: const TextStyle(
                  color: _darkForestText,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                ),
                decoration: const InputDecoration(
                  hintText: 'Ask about subsidies, Digital ID, labs...',
                  hintStyle: TextStyle(
                    color: _mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: () => _sendMessage(_messageController.text),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _primaryGreen,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}