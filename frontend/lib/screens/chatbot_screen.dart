import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/gov_header.dart';
import '../models/scholarship_application.dart';

// §1.4 - JAGO chatbot screen.
//
// IMPORTANT: Person D is still finalizing the real intent list + copy.
// Everything intent-related lives in ONE swappable data source below
// (chatIntentReplies) - a Map<String, String Function()>. Drop in the
// final phrasing/intents there and nothing in the UI code needs to change.
// The two entries with real spec copy are 'greeting' and 'status_check';
// the rest are clearly-marked placeholders.

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

// The flagged demo persona, used to make status-check / deficiency
// responses feel real rather than generic lorem-ipsum placeholders.
final ScholarshipApplication _demoApplication =
    dummyApplications.firstWhere((a) => a.actionRequired, orElse: () => dummyApplications.first);

// ---------------------------------------------------------------------
// SWAPPABLE DATA SOURCE - this is the only thing Person D needs to edit.
// ---------------------------------------------------------------------
const String chatbotGreeting =
    "Namaste! I'm JAGO, your scholarship assistant. I can help you check your "
    "application status, check eligibility, tell you what documents are needed, "
    "or explain a deficiency notice. What would you like to know?";

final List<ChatIntent> chatIntents = const [
  ChatIntent(id: 'status_check', chipLabel: 'Check application status'),
  ChatIntent(id: 'eligibility', chipLabel: 'Am I eligible?'),
  ChatIntent(id: 'documents_required', chipLabel: 'Documents required'),
  ChatIntent(id: 'deficiency_explanation', chipLabel: 'Explain my deficiency notice'),
];

final Map<String, String Function()> chatIntentReplies = {
  // Real spec copy (status check).
  'status_check': () {
    final app = _demoApplication;
    final statusPhrase = app.actionRequired
        ? 'flagged as Action Required'
        : 'at the ${_stageLabel(app.currentStage)} stage';
    final followUp = app.actionRequired
        ? 'Please check the Application Detail screen for what needs to be corrected.'
        : "We'll notify you as soon as it moves to the next stage.";
    return 'Your application ${app.applicationId} for "${app.schemeName}" is currently '
        '$statusPhrase. $followUp';
  },

    'eligibility': () {
    final app = _demoApplication;
    return 'For "${app.schemeName}", you are generally eligible if you belong to a notified '
        'Scheduled Tribe, meet the income ceiling for the scheme, and are enrolled in a recognised '
        'institution. Since you already have an active application (${app.applicationId}), your '
        'eligibility for this scheme has been accepted. You cannot hold two scholarships at the same '
        'time, so a new application under a different scheme will show as blocked until this one is closed.';
  },

  'documents_required': () {
    final app = _demoApplication;
    if (app.actionRequired && app.flaggedDocuments.isNotEmpty) {
      final docs = app.flaggedDocuments.join(', ');
      return 'For ${app.applicationId}, the following documents need to be re-submitted: $docs. '
          'You can upload corrected copies from the Document Wallet tab.';
    }
    return 'For most schemes you will need: Aadhaar Card, Income Certificate, Scheduled Tribe (ST) '
        'Certificate, Bonafide Certificate from your institution, and Bank Passbook (for DBT). '
        'Additional documents may apply depending on your scheme.';
  },
  // Uses the flagged persona's real deficiency note where available.
  'deficiency_explanation': () => _demoApplication.actionRequired
      ? 'For ${_demoApplication.applicationId}: ${_demoApplication.deficiencyNote}'
      : '[Placeholder response - deficiency-explanation copy pending from design lead]. You don\'t currently '
          'have any applications flagged for correction.',
};

String _stageLabel(ApplicationStage s) {
  switch (s) {
    case ApplicationStage.submitted:
      return 'Submitted';
    case ApplicationStage.verified:
      return 'Verified';
    case ApplicationStage.sanctioned:
      return 'Sanctioned';
    case ApplicationStage.disbursed:
      return 'Disbursed';
  }
}
// ---------------------------------------------------------------------

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<ChatMessage> _messages = [
    const ChatMessage(text: chatbotGreeting, isUser: false),
  ];
   final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();

  void _handleIntentTap(ChatIntent intent) {
    _addUserMessage(intent.chipLabel);
    _sendReply(() => chatIntentReplies[intent.id]?.call() ??
        '[No response configured for this intent yet]');
  }

  void _handleTextSubmit(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    _textController.clear();
    _addUserMessage(trimmed);

    final matchedId = _matchIntent(trimmed);
    _sendReply(() => matchedId != null
        ? (chatIntentReplies[matchedId]?.call() ?? '[No response configured for this intent yet]')
        : "I'm not sure I understood that. Try one of the suggestions below, "
            'or rephrase your question - for example, ask about your application status, '
            'eligibility, required documents, or a deficiency notice.');
  }

  // Simple keyword-based intent matching for typed questions.
  // Not real NLU - good enough for a hackathon demo; swap for a proper
  // intent classifier or LLM call later if time allows.
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
          // Suggested-intent chips - swappable via chatIntents/chatIntentReplies above.
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
        // Free-text input row.
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

// Bordered message bubble - no rounded fintech-style shape, no shadow.
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