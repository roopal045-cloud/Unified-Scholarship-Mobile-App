import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/gov_header.dart';
import '../widgets/emblem_watermark.dart';
import 'dashboard_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _idController = TextEditingController();
  bool _otpSent = false;

  void _sendOtp() {
    if (_idController.text.trim().isEmpty) return;
    setState(() => _otpSent = true);
  }

  void _verifyOtp() {
    // No real auth for the demo - just navigate to the dashboard.
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const DashboardShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const GovHeader(),
          Expanded(
            child: Stack(
              children: [
                // Subtle emblem watermark behind the login form, as on the dashboard.
                const Positioned.fill(
                  child: Center(
                    child: EmblemWatermark(size: 260, opacity: 0.04),
                  ),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        'Student login',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Enter your Aadhaar-linked registered mobile number or student ID to continue.',
                        style: TextStyle(color: AppColors.textDark, fontSize: 13),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _idController,
                        enabled: !_otpSent,
                        decoration: InputDecoration(
                          labelText: 'Student ID / Mobile number',
                          filled: true,
                          fillColor: AppColors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
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
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _otpSent ? _verifyOtp : _sendOtp,
                          child: Text(_otpSent ? 'Verify and continue' : 'Send OTP'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}