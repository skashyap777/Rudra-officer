import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/common/custom_button.dart';
import '../../../core/widgets/common/input_fields.dart';
import '../../../core/widgets/common/loading_indicator.dart';
import '../../../data/providers/auth_provider.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  final String role;

  const ForgotPasswordScreen({super.key, required this.role});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  bool _isLoading = false;

  String get _roleDisplayName {
    return AppConstants.roleDisplayNames[widget.role] ?? 'Officer';
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authRepo = await ref.read(authRepositoryProvider.future);
      await authRepo.forgotPassword(
        username: _usernameController.text.trim(),
        role: widget.role,
      );

      if (!mounted) return;

      // Navigate to OTP verification
      context.pushNamed(
        'otpVerification',
        extra: {
          'username': _usernameController.text.trim(),
          'role': widget.role,
        },
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: ${e.toString().replaceAll('Exception: ', '')}')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Forgot Password'),
      ),
      body: SafeArea(child: LoadingOverlay(
        isLoading: _isLoading,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                // Illustration
                Center(
                  child: Image.asset(
                    'assets/images/_4901538_2022_09_29_password03_1.png',
                    width: 150,
                    height: 150,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.lock_reset,
                      size: 100,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Header
                Text(
                  'Reset Password',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter your username and we\'ll send an OTP to your registered mobile number.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 32),
                // Role Display
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.badge, color: theme.primaryColor),
                      const SizedBox(width: 12),
                      Text(
                        _roleDisplayName,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: theme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Username Field
                CustomTextField(
                  label: 'Username',
                  hint: 'Enter your username',
                  controller: _usernameController,
                  prefixIcon: const Icon(Icons.person_outline),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                // Submit Button
                CustomButton(
                  text: 'Send OTP',
                  onPressed: _submit,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }
}
