import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/routes.dart';
import '../../../core/widgets/common/loading_indicator.dart';
import '../../../data/providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Check auth status
    final authNotifier = ref.read(authProvider.notifier);
    await authNotifier.checkAuthStatus();

    if (!mounted) return;

    final authState = ref.read(authProvider);
    
    authState.when(
      data: (state) {
        if (state == AuthState.authenticated) {
          context.go(Routes.main);
        } else {
          context.go(Routes.roleSelection);
        }
      },
      loading: () {},
      error: (_, __) => context.go(Routes.roleSelection),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Container(
        color: Colors.grey[100], // Matches RUDRA splash background
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo
              Image.asset(
                'assets/images/assam_pwd_logo_1.png',
                width: 96,
                height: 96,
                fit: BoxFit.fill,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.account_balance,
                  size: 80,
                  color: Color(0xFF3D9A7E),
                ),
              ),
              const SizedBox(height: 30),
              // App Name
              const Text(
                'PWD Officer App',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500, // inter_medium
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Smart Monitoring for Better Roads',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500, // inter_medium
                  color: Colors.grey, // grey2
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
