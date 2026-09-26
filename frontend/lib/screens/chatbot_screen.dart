import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/gov_header.dart';
import '../services/api_service.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  const ChatMessage({required this.text, required this.isUser});
}

class ChatIntent {
  final String id;
  final String chipLabel;
  const ChatIntent({required this.id, required this.chipLabel});
}

const String chatbotGreeting =
    "Namaste! I'm JAGO, your scholarship assistant. I can help you check your "
    "application status, check eligibility, tell you what documents are needed, "
    "or explain a deficiency notice. What would you like to know?";

const List<ChatIntent> chatIntents = [
  ChatIntent(id: 'status_check', chipLabel: 'Check application status'),
  ChatIntent(id: 'eligibility', chipLabel: 'Am I eligible?'),
  ChatIntent(id: 'documents_required', chipLabel: 'Documents required'),
  ChatIntent(id: 'deficiency_explanation', chipLabel: 'Explain my deficiency notice'),
];

const Map<String, String> _schemeLabels = {
  'PRE_MATRIC_ST': 'Pre-Matric Scholarship for ST Students',
  'POST_MATRIC_ST': 'Post-Matric Scholarship for ST Students',
  'TOP_CLASS': 'Top Class Education Scheme',
  'NFST': 'National Fellowship for ST Students',
  'NOS': 'National Overseas Scholarship',
};

const Map<String, String> _statusLabels = {
  'under_verification': 'under verification',
  'sanctioned': 'sanctioned',
  'disbursed': 'disbursed',
  'action_required': 'flagged for action',
};

// Phase 4 (D): "multilingual toggle, even if just 2 languages via prompt".
// This is a hardcoded EN/HI string swap rather than a translation API call -
// enough to demo the toggle without needing a live LLM connection mid-pitch.
enum ChatLanguage { en, hi }

const Map<String, String> _chipLabelsHi = {
  'status_check': 'आवेदन की स्थिति देखें',
  'eligibility': 'क्या मैं पात्र हूं?',
  'documents_required': 'आवश्यक दस्तावेज़',
  'deficiency_explanation': 'कमी सूचना समझाएं',
};

const Map<String, String> _statusLabelsHi = {
  'under_verification': 'सत्यापन में',
  'sanctioned': 'स्वीकृत',
  'disbursed': 'वितरित',
  'action_required': 'कार्रवाई हेतु चिह्नित',
};

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key, required this.studentId});

  final String studentId;

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<ChatMessage> _messages = [
    const ChatMessage(text: chatbotGreeting, isUser: false),
  ];
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();

  List<Map<String, dynamic>> _applications = [];
  bool _loadingData = true;
  ChatLanguage _language = ChatLanguage.en;

  String _t(String en, String hi) => _language == ChatLanguage.en ? en : hi;

  void _toggleLanguage() {
    setState(() {
      _language = _language == ChatLanguage.en ? ChatLanguage.hi : ChatLanguage.en;
      _messages.add(ChatMessage(
        text: _t(
          'Switched to English. New replies will be in English.',
          'हिंदी में बदल दिया गया। अब से जवाब हिंदी में मिलेंगे।',
        ),
        isUser: false,
      ));
    });
    _scrollToBottom();
  }

  @override
  void initState() {
    super.initState();
    _loadApplications();
  }
  // NOTE for D: this already calls the real /api/applications endpoint and
  // builds live replies from it (see _buildReply below) — Phase 3's
  // "connect chatbot to student status API" is done. Please review the 4
  // intent replies below match what you intended, then take ownership of
  // this file going forward so we're not duplicating work.
  Future<void> _loadApplications() async {
    try {
      final data = await ApiService.getDashboard(widget.studentId);
      setState(() {
        _applications = List<Map<String, dynamic>>.from(data['applications']);
        _loadingData = false;
      });
    } catch (e) {
      setState(() => _loadingData = false);
    }
  }

  Map<String, dynamic>? get _demoApp {
    if (_applications.isEmpty) return null;
    return _applications.firstWhere(
      (a) => a['status'] == 'action_required',
      orElse: () => _applications.first,
    );
  }

  String _schemeLabelFor(Map<String, dynamic> app) =>
      _schemeLabels[app['scheme']] ?? app['scheme'].toString();

  String _buildReply(String intentId) {
    if (_loadingData) {
      return _t(
        "One moment, I'm still fetching your application details.",
        'कृपया प्रतीक्षा करें, मैं आपकी आवेदन जानकारी प्राप्त कर रहा हूं।',
      );
    }
    final app = _demoApp;
    if (app == null) {
      return _t(
        "I couldn't find any applications linked to your account yet.",
        'आपके खाते से जुड़ा कोई आवेदन अभी तक नहीं मिला।',
      );
    }

    switch (intentId) {
      case 'status_check':
        final statusPhrase = _t(
          _statusLabels[app['status']] ?? app['status'].toString(),
          _statusLabelsHi[app['status']] ?? app['status'].toString(),
        );
        final followUp = app['status'] == 'action_required'
            ? _t(
                'Please check the Application Detail screen for what needs to be corrected.',
                'कृपया देखें कि आवेदन विवरण स्क्रीन पर क्या सुधारना है।',
              )
            : _t(
                "We'll notify you as soon as it moves to the next stage.",
                'अगले चरण में पहुंचते ही हम आपको सूचित करेंगे।',
              );
        return _t(
          'Your application ${app['application_id']} for "${_schemeLabelFor(app)}" is '
              'currently $statusPhrase. $followUp',
          'आपका आवेदन ${app['application_id']} ("${_schemeLabelFor(app)}") वर्तमान में '
              '$statusPhrase है। $followUp',
        );

      case 'eligibility':
        return _t(
          'For "${_schemeLabelFor(app)}", you are generally eligible if you belong to a '
              'notified Scheduled Tribe, meet the income ceiling for the scheme, and are enrolled '
              'in a recognised institution. Since you already have an active application '
              '(${app['application_id']}), a new application under a different scheme will show '
              'as blocked until this one is closed.',
          '"${_schemeLabelFor(app)}" के लिए, आप आमतौर पर पात्र हैं यदि आप अधिसूचित अनुसूचित '
              'जनजाति से हैं, आय सीमा पूरी करते हैं, और किसी मान्यता प्राप्त संस्थान में नामांकित हैं। '
              'चूंकि आपका पहले से एक सक्रिय आवेदन (${app['application_id']}) है, इसलिए किसी अन्य '
              'योजना के तहत नया आवेदन तब तक अवरुद्ध दिखेगा जब तक यह बंद नहीं हो जाता।',
        );

      case 'documents_required':
        final pendingDocs = (app['pending_documents'] as List<dynamic>? ?? []);
        if (app['status'] == 'action_required' && pendingDocs.isNotEmpty) {
          return _t(
            'For ${app['application_id']}, the following need attention: '
                '${pendingDocs.join(', ')}. You can upload corrected copies from the Document '
                'Wallet tab.',
            '${app['application_id']} के लिए इन पर ध्यान देना होगा: '
                '${pendingDocs.join(', ')}। आप डॉक्यूमेंट वॉलेट टैब से सही प्रति अपलोड कर सकते हैं।',
          );
        }
        return _t(
          'For most schemes you will need: Aadhaar Card, Income Certificate, Scheduled '
              'Tribe (ST) Certificate, Bonafide Certificate from your institution, and Bank '
              'Passbook (for DBT). Additional documents may apply depending on your scheme.',
          'अधिकांश योजनाओं के लिए आपको चाहिए: आधार कार्ड, आय प्रमाण पत्र, अनुसूचित जनजाति '
              '(ST) प्रमाण पत्र, संस्थान से बोनाफाइड प्रमाण पत्र, और बैंक पासबुक (DBT हेतु)। '
              'योजना के अनुसार अतिरिक्त दस्तावेज़ भी लग सकते हैं।',
        );

      case 'deficiency_explanation':
        final pendingDocs = (app['pending_documents'] as List<dynamic>? ?? []);
        if (app['status'] == 'action_required' && pendingDocs.isNotEmpty) {
          return _t(
            'For ${app['application_id']}: flagged for review - ${pendingDocs.join(', ')}.',
            '${app['application_id']} के लिए: समीक्षा हेतु चिह्नित - ${pendingDocs.join(', ')}।',
          );
        }
        return _t(
          "You don't currently have any applications flagged for correction.",
          'फिलहाल आपका कोई भी आवेदन सुधार हेतु चिह्नित नहीं है।',
        );

      default:
        return _t('[No response configured for this intent yet]', '[इस विषय पर अभी उत्तर उपलब्ध नहीं है]');
    }
  }

  void _handleIntentTap(ChatIntent intent) {
    final label = _language == ChatLanguage.en ? intent.chipLabel : _chipLabelsHi[intent.id]!;
    _addUserMessage(label);
    _sendReply(() => _buildReply(intent.id));
  }

  void _handleTextSubmit(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    _textController.clear();
    _addUserMessage(trimmed);

    final matchedId = _matchIntent(trimmed);
    _sendReply(() => matchedId != null
        ? _buildReply(matchedId)
        : _t(
            "I'm not sure I understood that. Try one of the suggestions below, "
                'or rephrase your question - for example, ask about your application status, '
                'eligibility, required documents, or a deficiency notice.',
            'मुझे यह समझ नहीं आया। नीचे दिए सुझावों में से कोई एक आज़माएं, या अपना प्रश्न फिर '
                'से लिखें - जैसे आवेदन की स्थिति, पात्रता, आवश्यक दस्तावेज़, या कमी सूचना के बारे में पूछें।',
          ));
  }

  String? _matchIntent(String text) {
    final lower = text.toLowerCase();
    if (lower.contains('status') || lower.contains('track') || lower.contains('where is')) {
      return 'status_check';
    }
    if (lower.contains('eligib') || lower.contains('qualify') || lower.contains('can i apply')) {
      return 'eligibility';
    }
    if (lower.contains('document') || lower.contains('docs') || lower.contains('upload')) {
      return 'documents_required';
    }
    if (lower.contains('deficien') || lower.contains('reject') || lower.contains('wrong') ||
        lower.contains('mismatch') || lower.contains('correct')) {
      return 'deficiency_explanation';
    }
    return null;
  }

  void _addUserMessage(String text) {
    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
    });
    _scrollToBottom();
  }

  void _sendReply(String Function() replyBuilder) {
    Future.delayed(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      setState(() {
        _messages.add(ChatMessage(text: replyBuilder(), isUser: false));
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 50), () {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const GovHeader(compact: true),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: const BoxDecoration(
            color: AppColors.white,
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: Row(
            children: [
              const Icon(Icons.smart_toy_outlined, color: AppColors.navy, size: 20),
              const SizedBox(width: 8),
              Text('JAGO Assistant', style: Theme.of(context).textTheme.titleMedium),
              const Spacer(),
              // Phase 4 (D) multilingual toggle.
              OutlinedButton(
                onPressed: _toggleLanguage,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.navy),
                  minimumSize: const Size(0, 30),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                ),
                child: Text(
                  _language == ChatLanguage.en ? 'हिंदी' : 'English',
                  style: const TextStyle(fontSize: 11, color: AppColors.navy, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(12),
            itemCount: _messages.length,
            itemBuilder: (context, index) => _MessageBubble(message: _messages[index]),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          decoration: const BoxDecoration(
            color: AppColors.white,
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: chatIntents
                .map((intent) => OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.navy),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      onPressed: () => _handleIntentTap(intent),
                      child: Text(
                        _language == ChatLanguage.en ? intent.chipLabel : _chipLabelsHi[intent.id]!,
                        style: const TextStyle(fontSize: 11, color: AppColors.navy),
                      ),
                    ))
                .toList(),
          ),
        ),
        Container(
          width: double.infinity,
          color: AppColors.white,
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  onSubmitted: _handleTextSubmit,
                  decoration: InputDecoration(
                    hintText: _t('Type your question...', 'अपना प्रश्न लिखें...'),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => _handleTextSubmit(_textController.text),
                icon: const Icon(Icons.send, color: AppColors.navy),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isUser ? AppColors.navy : AppColors.white,
          border: Border.all(color: isUser ? AppColors.navy : AppColors.border),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            fontSize: 13,
            color: isUser ? AppColors.white : AppColors.textDark,
            height: 1.35,
          ),
        ),
      ),
    );
  }
}