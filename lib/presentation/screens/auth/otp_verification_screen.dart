import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/common/custom_button.dart';
import '../../../core/widgets/common/input_fields.dart';
import '../../../core/widgets/common/loading_indicator.dart';
import '../../../data/providers/auth_provider.dart';

class OTPVerificationScreen extends ConsumerStatefulWidget {
  final String username;
  final String role;

  const OTPVerificationScreen({
    super.key,
    required this.username,
    required this.role,
  });

  @override
  ConsumerState<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends ConsumerState<OTPVerificationScreen> {
  final _otpController = TextEditingController();
  bool _isLoading = false;
  bool _canResend = false;
  int _resendSeconds = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    _timer?.cancel();
    _canResend = false;
    _resendSeconds = 30;
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds > 0) {
        setState(() => _resendSeconds--);
      } else {
        setState(() => _canResend = true);
        timer.cancel();
      }
    });
  }

  Future<void> _verifyOTP() async {
    if (_otpController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter 6-digit OTP')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authRepo = await ref.read(authRepositoryProvider.future);
      await authRepo.verifyOtp(
        username: widget.username,
        otp: _otpController.text.trim(),
        role: widget.role,
      );

      if (!mounted) return;

      // Navigate to reset password
      context.pushNamed(
        'resetPassword',
        extra: {
          'username': widget.username,
          'role': widget.role,
        },
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification failed: ${e.toString().replaceAll('Exception: ', '')}')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resendOTP() async {
    if (!_canResend) return;

    setState(() => _isLoading = true);

    try {
      final authRepo = await ref.read(authRepositoryProvider.future);
      await authRepo.resendOtp(
        username: widget.username,
        role: widget.role,
      );
      
      _startResendTimer();
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP resent successfully')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to resend: ${e.toString().replaceAll('Exception: ', '')}')),
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
        title: const Text('Verify OTP'),
      ),
      body: SafeArea(child: LoadingOverlay(
        isLoading: _isLoading,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              // Illustration
              Image.asset(
                'assets/images/verification_01_1.png',
                width: 150,
                height: 150,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.verified_user,
                  size: 100,
                  color: theme.primaryColor,
                ),
              ),
              const SizedBox(height: 32),
              // Header
              Text(
                'Enter OTP',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'We sent a 6-digit code to your registered mobile number',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'for user: ${widget.username}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: theme.primaryColor,
                ),
              ),
              const SizedBox(height: 32),
              // OTP Input
              OtpInputField(
                controller: _otpController,
                onCompleted: (_) => _verifyOTP(),
              ),
              const SizedBox(height: 32),
              // Verify Button
              CustomButton(
                text: 'Verify OTP',
                onPressed: _verifyOTP,
              ),
              const SizedBox(height: 24),
              // Resend
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive code? ",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  TextButton(
                    onPressed: _canResend ? _resendOTP : null,
                    child: Text(
                      _canResend
                          ? 'Resend'
                          : 'Resend in ${_resendSeconds}s',
                      style: TextStyle(
                        color: _canResend ? theme.primaryColor : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }
}
