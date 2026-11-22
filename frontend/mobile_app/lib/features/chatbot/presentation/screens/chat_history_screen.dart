// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({super.key});

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
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

  static const Color _softRedBg = Color(0xFFFBE9EC);
  static const Color _softRedBorder = Color(0xFFD6455D);
  static const Color _crimsonBadge = Color(0xFFD92D4B);

  static const Color _canvasBg = Color(0xFFF8FAFC);
  static const Color _neutralBtnBg = Color(0xFFF1F5F4);
  static const Color _neutralBtnBorder = Color(0xFFD5DFDC);

  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';

  final List _categories = [
    'All',
    'Lab & Diagnostics',
    'Subsidy & Ration',
    'Prescriptions & OCR',
  ];

  final List _sessions = [
    {
      'id': 'CHAT-2026-904',
      'title': 'Monthly Diagnostic Lab Subsidy Balance',
      'category': 'Lab & Diagnostics',
      'date': '22 Nov 2026 • 09:46 AM',
      'language': 'English',
      'preview':
          'Checked remaining Rs. 8,500 diagnostic pool and 80% subsidy eligibility at Chughtai Lab.',
      'messages': [
        {
          'sender': 'user',
          'text': 'How much diagnostic lab subsidy do I have left this month?',
          'source': '',
        },
        {
          'sender': 'ai',
          'text':
              'Under your active Al-Khidmat Foundation sponsorship (ID: CG-BEN-2026-009481), you have Rs. 8,500 remaining in your monthly diagnostic pool. Partner labs cover 80% of approved tests upon uploading a doctor prescription.',
          'source': 'Beneficiary Policy Ledger • Live Sync',
        },
        {
          'sender': 'user',
          'text': 'Which branch near Johar Town accepts my Digital ID pass?',
          'source': '',
        },
        {
          'sender': 'ai',
          'text':
              'Chughtai Lab - Johar Town Branch (Reg ID: CG-LAB-0042) is active and verified. Present your Digital ID QR pass at reception to pay only the 20% patient co-share.',
          'source': 'Partner Directory • Lahore Zone',
        },
      ],
    },
    {
      'id': 'CHAT-2026-891',
      'title': 'Ration & Pharmacy Cap Inquiry (Roman Urdu)',
      'category': 'Subsidy & Ration',
      'date': '19 Nov 2026 • 04:15 PM',
      'language': 'Roman Urdu',
      'preview':
          'Meri monthly medicine subsidy limit aur ration renewal documents ki maloomat.',
      'messages': [
        {
          'sender': 'user',
          'text':
              'Meri baaqi medicine subsidy kitni hai aur ration renewal ke liye kaunse documents chahiye?',
          'source': '',
        },
        {
          'sender': 'ai',
          'text':
              'Aap ke CareGrid account mein Rs. 4,200 ki monthly pharmacy medicine subsidy (70% coverage) baaqi hai. Ration renewal ke liye apna valid CNIC aur taza bijli ka bill upload karein. Aapka current tier 31 Dec 2026 tak active hai.',
          'source': 'Welfare Eligibility Manual • Bilingual RAG',
        },
      ],
    },
    {
      'id': 'CHAT-2026-874',
      'title': 'Prescription OCR Verification Guidelines',
      'category': 'Prescriptions & OCR',
      'date': '14 Nov 2026 • 11:20 AM',
      'language': 'English',
      'preview':
          'Verified rules for uploading doctor prescriptions for CBC and HbA1c test approval.',
      'messages': [
        {
          'sender': 'user',
          'text':
              'Why do I need to upload a prescription before booking an HbA1c lab test?',
          'source': '',
        },
        {
          'sender': 'ai',
          'text':
              'CareGrid requires a signed physician prescription dated within the last 30 days so our AI OCR verifier can validate the clinical indication and unlock your 80% NGO diagnostic subsidy.',
          'source': 'Diagnostic SOP • Section 3.2',
        },
      ],
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List _getFilteredSessions() {
    final String query = _searchController.text.trim().toLowerCase();
    return _sessions.where((item) {
      final Map session = item as Map;
      final bool matchesCategory =
          _selectedCategory == 'All' || session['category'] == _selectedCategory;
      final bool matchesQuery =
          session['title'].toString().toLowerCase().contains(query) ||
              session['preview'].toString().toLowerCase().contains(query) ||
              session['category'].toString().toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  void _showSnack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? _crimsonBadge : _primaryGreen,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _deleteSession(String id) {
    setState(() {
      _sessions.removeWhere((item) => (item as Map)['id'] == id);
    });
    _showSnack('Chat session removed from archive', isError: true);
  }

  void _openTranscriptSheet(Map session) {
    final List thread = session['messages'] as List;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return DraggableScrollableSheet(
          initialChildSize: 0.78,
          minChildSize: 0.5,
          maxChildSize: 0.94,
          builder: (_, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: _canvasBg,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(26),
                  topRight: Radius.circular(26),
                ),
              ),
              child: Column(
                children: [
                  // Drag Handle & Header
                  Container(
                    padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(26),
                        topRight: Radius.circular(26),
                      ),
                      border: Border(
                        bottom: BorderSide(color: _neutralBtnBorder, width: 1.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: _neutralBtnBorder,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 9, vertical: 4),
                              decoration: BoxDecoration(
                                color: _primaryGreen,
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Text(
                                session['category'].toString().toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Text(
                              session['language'].toString(),
                              style: const TextStyle(
                                color: _primaryGreen,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          session['title'].toString(),
                          style: const TextStyle(
                            color: _darkForestText,
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${session['id']} • ${session['date']}',
                          style: const TextStyle(
                            color: _mutedText,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Thread Messages
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: thread.length,
                      itemBuilder: (context, idx) {
                        final Map msg = thread[idx] as Map;
                        final bool isAi = msg['sender'] == 'ai';
                        final String source = msg['source'].toString();

                        return Align(
                          alignment: isAi
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(13),
                            constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.82,
                            ),
                            decoration: BoxDecoration(
                              color: isAi ? Colors.white : _primaryGreen,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(16),
                                topRight: const Radius.circular(16),
                                bottomLeft: Radius.circular(isAi ? 4 : 16),
                                bottomRight: Radius.circular(isAi ? 16 : 4),
                              ),
                              border: isAi
                                  ? Border.all(
                                      color: _mintCardBorder.withValues(
                                          alpha: 0.45),
                                      width: 1.2)
                                  : null,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (isAi)
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 5),
                                    child: Text(
                                      'CAREGRID RAG ASSISTANT',
                                      style: TextStyle(
                                        color: _primaryGreen,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                Text(
                                  msg['text'].toString(),
                                  style: TextStyle(
                                    color:
                                        isAi ? _darkForestText : Colors.white,
                                    fontSize: 13.5,
                                    height: 1.42,
                                    fontWeight:
                                        isAi ? FontWeight.w500 : FontWeight.w600,
                                  ),
                                ),
                                if (isAi && source.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _mintCardBg,
                                      borderRadius: BorderRadius.circular(6),
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
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Bottom Action Bar
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 22),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(color: _neutralBtnBorder, width: 1.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              final String transcript = thread
                                  .map((m) =>
                                      '${(m as Map)['sender'].toString().toUpperCase()}: ${m['text']}')
                                  .join('\n\n');
                              Clipboard.setData(
                                  ClipboardData(text: transcript));
                              Navigator.pop(sheetContext);
                              _showSnack('Conversation copied to clipboard');
                            },
                            icon: const Icon(Icons.copy_rounded, size: 16),
                            label: const Text(
                              'Copy Transcript',
                              style: TextStyle(
                                  fontSize: 12.5, fontWeight: FontWeight.w700),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: _darkForestText,
                              backgroundColor: _neutralBtnBg,
                              side:
                                  const BorderSide(color: _neutralBtnBorder),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(sheetContext);
                              Navigator.maybePop(context);
                            },
                            icon: const Icon(Icons.chat_bubble_outline_rounded,
                                size: 16),
                            label: const Text(
                              'Resume Chat',
                              style: TextStyle(
                                  fontSize: 12.5, fontWeight: FontWeight.w700),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primaryGreen,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List filteredSessions = _getFilteredSessions();

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
                      // Search & Filter Section
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
                        child: Column(
                          children: [
                            _buildSearchBar(),
                            const SizedBox(height: 12),
                            _buildCategoryFilterRow(),
                          ],
                        ),
                      ),

                      // Saved Sessions List
                      Expanded(
                        child: filteredSessions.isEmpty
                            ? _buildEmptyState()
                            : ListView.builder(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 8, 16, 28),
                                itemCount: filteredSessions.length,
                                itemBuilder: (context, index) {
                                  final Map session =
                                      filteredSessions[index] as Map;
                                  return _buildSessionCard(session);
                                },
                              ),
                      ),
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
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => Navigator.maybePop(context),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
                  decoration: BoxDecoration(
                    color: _headerBadgeBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _headerBadgeBorder),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white, size: 13),
                      SizedBox(width: 5),
                      Text(
                        'AI Assistant',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _amberBadge,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${_sessions.length} SAVED CHATS',
                  style: const TextStyle(
                    color: _darkForestText,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'AI Assistant Chat History',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Review past welfare policy answers, lab subsidy checks, and bilingual guidance.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SEARCH BAR
  // ---------------------------------------------------------------------------
  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onChanged: (_) => setState(() {}),
      style: const TextStyle(
        color: _darkForestText,
        fontSize: 13.5,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: 'Search saved questions or policy topics...',
        hintStyle: const TextStyle(color: _mutedText, fontSize: 13),
        prefixIcon: const Icon(Icons.search_rounded, color: _primaryGreen),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close_rounded,
                    color: _mutedText, size: 18),
                onPressed: () {
                  _searchController.clear();
                  setState(() {});
                },
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 11),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _neutralBtnBorder, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _neutralBtnBorder, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _primaryGreen, width: 1.5),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // CATEGORY FILTER CHIPS
  // ---------------------------------------------------------------------------
  Widget _buildCategoryFilterRow() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final String cat = _categories[index].toString();
          final bool isSelected = _selectedCategory == cat;

          return InkWell(
            onTap: () {
              setState(() {
                _selectedCategory = cat;
              });
            },
            borderRadius: BorderRadius.circular(18),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: isSelected ? _primaryGreen : _mintCardBg,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected ? _primaryGreen : _mintCardBorder,
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  cat,
                  style: TextStyle(
                    color: isSelected ? Colors.white : _darkForestText,
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

  // ---------------------------------------------------------------------------
  // SESSION CARD
  // ---------------------------------------------------------------------------
  Widget _buildSessionCard(Map session) {
    final List msgs = session['messages'] as List;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _neutralBtnBorder, width: 1.2),
      ),
      child: InkWell(
        onTap: () => _openTranscriptSheet(session),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: _mintCardBg,
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(color: _mintCardBorder, width: 0.8),
                    ),
                    child: Text(
                      session['category'].toString().toUpperCase(),
                      style: const TextStyle(
                        color: _primaryGreen,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Text(
                    session['date'].toString(),
                    style: const TextStyle(
                      color: _mutedText,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 9),
              Text(
                session['title'].toString(),
                style: const TextStyle(
                  color: _darkForestText,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                session['preview'].toString(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _mutedText,
                  fontSize: 12.5,
                  height: 1.38,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.forum_outlined,
                          color: _primaryGreen, size: 15),
                      const SizedBox(width: 5),
                      Text(
                        '${msgs.length} Messages • ${session['language']}',
                        style: const TextStyle(
                          color: _primaryGreen,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () => _deleteSession(session['id'].toString()),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 9, vertical: 5),
                          decoration: BoxDecoration(
                            color: _softRedBg,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: _softRedBorder),
                          ),
                          child: const Text(
                            'Delete',
                            style: TextStyle(
                              color: _crimsonBadge,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 11, vertical: 5),
                        decoration: BoxDecoration(
                          color: _primaryGreen,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'View Thread',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // EMPTY STATE
  // ---------------------------------------------------------------------------
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _mintCardBg,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.history_toggle_off_rounded,
                  color: _primaryGreen, size: 32),
            ),
            const SizedBox(height: 12),
            const Text(
              'No Matching Conversations',
              style: TextStyle(
                color: _darkForestText,
                fontSize: 15.5,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Try clearing your search filter or start a new conversation with the CareGrid AI Assistant.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _mutedText,
                fontSize: 12.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}