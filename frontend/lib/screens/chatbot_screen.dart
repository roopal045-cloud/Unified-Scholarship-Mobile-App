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

  // PLACEHOLDER - pending final intent copy from Person D.
  'eligibility': () =>
      '[Placeholder response - eligibility copy pending from design lead]. In the meantime, you can check '
      'eligibility criteria for each scheme on its details page.',

  // PLACEHOLDER - pending final intent copy from Person D.
  'documents_required': () =>
      '[Placeholder response - documents-required copy pending from design lead]. Generally you\'ll need an '
      'Aadhaar Card, Income Certificate, Caste Certificate, Bonafide Certificate and Bank Passbook.',

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

  void _handleIntentTap(ChatIntent intent) {
    setState(() {
      _messages.add(ChatMessage(text: intent.chipLabel, isUser: true));
    });
    Future.delayed(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      final reply = chatIntentReplies[intent.id]?.call() ??
          '[No response configured for this intent yet]';
      setState(() {
        _messages.add(ChatMessage(text: reply, isUser: false));
      });
      _scrollToBottom();
    });
    _scrollToBottom();
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
          color: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: const BoxDecoration(
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
          color: AppColors.white,
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          decoration: const BoxDecoration(
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