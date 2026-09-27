import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/gov_header.dart';
import 'coverage_gap_screen.dart';

// Separate login flow for Ministry officials - not connected to student
// accounts or student data. Mock credentials only, no real government
// auth backend exists for this hackathon build.
class MinistryLoginScreen extends StatefulWidget {
  const MinistryLoginScreen({super.key});

  @override
  State<MinistryLoginScreen> createState() => _MinistryLoginScreenState();
}

class _MinistryLoginScreenState extends State<MinistryLoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorText;

  static const String _mockUsername = 'admin';
  static const String _mockPassword = 'mota2026';

  void _login() {
    if (_usernameController.text.trim() == _mockUsername &&
        _passwordController.text.trim() == _mockPassword) {
      setState(() => _errorText = null);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const CoverageGapScreen()),
      );
    } else {
      setState(() => _errorText = 'Incorrect username or password.');
    }
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Icon(Icons.admin_panel_settings_outlined, color: AppColors.navy, size: 36),
                  const SizedBox(height: 12),
                  Text('Ministry official login', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  const Text(
                    'Access the scholarship outreach dashboard. For demonstration purposes only.',
                    style: TextStyle(color: AppColors.textDark, fontSize: 13),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                    ),
                  ),
                  if (_errorText != null) ...[
                    const SizedBox(height: 12),
                    Text(_errorText!, style: const TextStyle(color: Color(0xFFD32F2F), fontSize: 12)),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(onPressed: _login, child: const Text('Login')),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Back to student login',
                        style: TextStyle(fontSize: 12, color: AppColors.navy),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}