import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/routes.dart';
import '../../../core/widgets/common/custom_button.dart';
import '../../../core/widgets/common/input_fields.dart';
import '../../../core/widgets/common/loading_indicator.dart';
import '../../../data/providers/auth_provider.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String username;
  final String role;

  const ResetPasswordScreen({
    super.key,
    required this.username,
    required this.role,
  });

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authRepo = await ref.read(authRepositoryProvider.future);
      await authRepo.resetPassword(
        username: widget.username,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        role: widget.role,
      );

      if (!mounted) return;

      // Show success and navigate to login
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Your password has been reset successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.go(Routes.login, extra: widget.role);
              },
              child: const Text('Login'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reset failed: ${e.toString().replaceAll('Exception: ', '')}')),
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
        title: const Text('Reset Password'),
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
                    'assets/images/_778_1.png',
                    width: 150,
                    height: 150,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.lock_person,
                      size: 100,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Header
                Text(
                  'Create New Password',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your new password must be different from previous passwords.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 32),
                // New Password
                PasswordField(
                  label: 'New Password',
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter new password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Confirm Password
                PasswordField(
                  label: 'Confirm Password',
                  controller: _confirmPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                // Reset Button
                CustomButton(
                  text: 'Reset Password',
                  onPressed: _resetPassword,
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
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
