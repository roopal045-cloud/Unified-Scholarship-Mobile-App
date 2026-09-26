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

  @override
  void initState() {
    super.initState();
    _loadApplications();
  }

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
      return "One moment, I'm still fetching your application details.";
    }
    final app = _demoApp;
    if (app == null) {
      return "I couldn't find any applications linked to your account yet.";
    }

    switch (intentId) {
      case 'status_check':
        final statusPhrase = _statusLabels[app['status']] ?? app['status'].toString();
        final followUp = app['status'] == 'action_required'
            ? 'Please check the Application Detail screen for what needs to be corrected.'
            : "We'll notify you as soon as it moves to the next stage.";
        return 'Your application ${app['application_id']} for "${_schemeLabelFor(app)}" is '
            'currently $statusPhrase. $followUp';

      case 'eligibility':
        return 'For "${_schemeLabelFor(app)}", you are generally eligible if you belong to a '
            'notified Scheduled Tribe, meet the income ceiling for the scheme, and are enrolled '
            'in a recognised institution. Since you already have an active application '
            '(${app['application_id']}), a new application under a different scheme will show '
            'as blocked until this one is closed.';

      case 'documents_required':
        final pendingDocs = (app['pending_documents'] as List<dynamic>? ?? []);
        if (app['status'] == 'action_required' && pendingDocs.isNotEmpty) {
          return 'For ${app['application_id']}, the following need attention: '
              '${pendingDocs.join(', ')}. You can upload corrected copies from the Document '
              'Wallet tab.';
        }
        return 'For most schemes you will need: Aadhaar Card, Income Certificate, Scheduled '
            'Tribe (ST) Certificate, Bonafide Certificate from your institution, and Bank '
            'Passbook (for DBT). Additional documents may apply depending on your scheme.';

      case 'deficiency_explanation':
        final pendingDocs = (app['pending_documents'] as List<dynamic>? ?? []);
        if (app['status'] == 'action_required' && pendingDocs.isNotEmpty) {
          return 'For ${app['application_id']}: flagged for review - ${pendingDocs.join(', ')}.';
        }
        return "You don't currently have any applications flagged for correction.";

      default:
        return '[No response configured for this intent yet]';
    }
  }

  void _handleIntentTap(ChatIntent intent) {
    _addUserMessage(intent.chipLabel);
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
        : "I'm not sure I understood that. Try one of the suggestions below, "
            'or rephrase your question - for example, ask about your application status, '
            'eligibility, required documents, or a deficiency notice.');
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
                        intent.chipLabel,
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
                    hintText: 'Type your question...',
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