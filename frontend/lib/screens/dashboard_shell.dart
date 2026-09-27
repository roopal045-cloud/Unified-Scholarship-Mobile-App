import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/gov_header.dart';
import 'dashboard_screen.dart';
import 'document_wallet_screen.dart';
import 'chatbot_screen.dart';
import 'applications_screen.dart';
import 'profile_screen.dart';
class DashboardShell extends StatefulWidget {
  const DashboardShell({
    super.key,
    required this.studentId,
    this.applicantName,
    this.applicantState,
  });

  final String studentId;
  final String? applicantName;
  final String? applicantState;
  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  int _selectedIndex = 0;

  static const List<String> _titles = [
    'Dashboard',
    'Applications',
    'Document wallet',
    'JAGO assistant',
    'Profile',
  ];

  List<Widget> get _screens => [
        DashboardScreen(studentId: widget.studentId, applicantName: widget.applicantName),
        ApplicationsScreen(studentId: widget.studentId, applicantName: widget.applicantName),
               DocumentWalletScreen(studentId: widget.studentId),
        ChatbotScreen(studentId: widget.studentId),
        ProfileScreen(
          studentId: widget.studentId,
          applicantName: widget.applicantName,
          applicantState: widget.applicantState,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.description_outlined), label: 'Applications'),
          BottomNavigationBarItem(icon: Icon(Icons.folder_outlined), label: 'Documents'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'JAGO'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

// Temporary placeholder for tabs not yet built.
class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GovHeader(compact: true),
        Expanded(
          child: Center(
            child: Text(
              '$label screen - coming soon',
              style: const TextStyle(color: AppColors.textDark),
            ),
          ),
        ),
      ],
    );
  }
}