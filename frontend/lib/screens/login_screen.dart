import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/gov_header.dart';
import '../widgets/emblem_watermark.dart';
import 'dashboard_shell.dart';
import '../services/api_service.dart';
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

   bool _loading = false;
  String? _errorText;

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
          ),
        ],
      ),
    );
  }
}