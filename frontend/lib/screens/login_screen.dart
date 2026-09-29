import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/gov_header.dart';
import 'dashboard_shell.dart';
import '../services/api_service.dart';
import 'ministry_login_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _idController = TextEditingController();
  bool _otpSent = false;
  bool _loading = false;
  String? _errorText;

  void _sendOtp() {
    if (_idController.text.trim().isEmpty) return;
    setState(() => _otpSent = true);
  }

  void _verifyOtp() async {
    setState(() {
      _loading = true;
      _errorText = null;
    });

    final studentId = _idController.text.trim();

    try {
      final result = await ApiService.login(studentId);
      final profile = result['profile'];

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => DashboardShell(
            studentId: profile['student_id'],
            applicantName: profile['full_name'],
            applicantState: profile['state'],
          ),
        ),
      );
    } catch (e) {
      setState(() {
        _loading = false;
        _errorText = 'Login failed. Check the Student ID and try again.';
      });
    }
  }

  void _goToMinistryLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const MinistryLoginScreen()),
    );
  }

  Widget _hero() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your scholarship, one secure login away',
          style: TextStyle(
            color: AppColors.navy,
            fontWeight: FontWeight.bold,
            fontSize: 30,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Apply, verify documents and track payments from a single place.',
          style: TextStyle(color: AppColors.textDark, fontSize: 15),
        ),
        const SizedBox(height: 40),
        SizedBox(
          height: 110,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 170,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.navy.withOpacity(0.35), width: 1.5),
                ),
                padding: const EdgeInsets.all(16),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _bar(width: 70),
                        const SizedBox(height: 10),
                        _bar(width: 90),
                        const SizedBox(height: 10),
                        _bar(width: 55),
                      ],
                    ),
                    const Positioned(
                      right: 0,
                      bottom: 0,
                      child: CircleAvatar(radius: 8, backgroundColor: AppColors.saffron),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 130,
                top: 20,
                child: Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.green,
                    border: Border.all(color: AppColors.white, width: 3),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    '\u20B9',
                    style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _bar({required double width}) {
    return Container(
      width: width,
      height: 8,
      decoration: BoxDecoration(color: AppColors.barLight, borderRadius: BorderRadius.circular(4)),
    );
  }

  Widget _loginTab({required String label, required bool selected, required VoidCallback onTap}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: selected ? AppColors.white : const Color(0xFFEDEFF8),
            border: Border(
              bottom: BorderSide(color: selected ? AppColors.navy : Colors.transparent, width: 2.5),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: selected ? AppColors.navy : Colors.grey[600],
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _loginTab(label: 'Student', selected: true, onTap: () {}),
              _loginTab(label: 'Ministry official', selected: false, onTap: _goToMinistryLogin),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Student login',
                  style: TextStyle(color: AppColors.navy, fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Enter your Aadhaar-linked registered mobile number or student ID to continue.',
                  style: TextStyle(color: AppColors.textDark, fontSize: 13),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _idController,
                  enabled: !_otpSent,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person_outline, size: 20),
                    labelText: 'Student ID / Mobile number',
                    filled: true,
                    fillColor: AppColors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                  ),
                ),
                if (_otpSent) ...[
                  const SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Enter OTP',
                      filled: true,
                      fillColor: AppColors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
                const SizedBox(height: 20),
                if (_errorText != null) ...[
                  Text(_errorText!, style: const TextStyle(color: Color(0xFFD32F2F), fontSize: 12)),
                  const SizedBox(height: 12),
                ],
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : (_otpSent ? _verifyOtp : _sendOtp),
                    child: _loading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : Text(_otpSent ? 'Verify and continue' : 'Send OTP'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const GovHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 720;
                  if (isWide) {
                    return IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(flex: 5, child: _hero()),
                          const SizedBox(width: 32),
                          Expanded(flex: 5, child: _loginCard()),
                        ],
                      ),
                    );
                  }
                  return Column(
                    children: [
                      _hero(),
                      const SizedBox(height: 32),
                      _loginCard(),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}