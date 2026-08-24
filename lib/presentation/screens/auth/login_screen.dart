import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/routes.dart';
import '../../../core/widgets/common/loading_indicator.dart';
import '../../../data/providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  final String roleName;
  final String roleLabel;
  final String roleDesc;

  const LoginScreen({
    super.key,
    required this.roleName,
    required this.roleLabel,
    required this.roleDesc,
  });

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  final _kGreen = const Color(0xFF3D9A7E);
  final _kBorder = const Color(0xFFEEEEEE);
  final _kBg = const Color(0xFFF5F7FA);

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final authNotifier = ref.read(authProvider.notifier);
      await authNotifier.login(
        username: _usernameController.text,
        password: _passwordController.text,
        role: widget.roleName,
      );

      if (!mounted) return;
      context.go(Routes.main);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red[900], behavior: SnackBarBehavior.floating, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero), content: Text('Authentication failed: $e', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LoadingOverlay(
          isLoading: authState.isLoading,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset('assets/images/_778_1.png', height: 180),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F7F7),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF5C4DC8).withOpacity(0.3), width: 1),
                      ),
                      child: Text(
                        widget.roleLabel,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600, // inter_semibold
                          color: Color(0xFF5C4DC8), // blue2
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Center(
                    child: Text(
                      'Verify pothole reports and assign repair tasks to vendors.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w400, // inter
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  const Text(
                    'Enter User Name',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w500, // inter_medium
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F7F7), // Similar to edit_text_background
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFEBEBEB)),
                    ),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(Icons.person_outline, color: Colors.grey, size: 20),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _usernameController,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w500, // inter_medium
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 15),
                            ),
                            validator: (v) => v?.isEmpty ?? true ? 'Username required' : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  const Text(
                    'Enter Password',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w500, // inter_medium
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F7F7),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFEBEBEB)),
                    ),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(Icons.lock_outline, color: Colors.grey, size: 20),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w500, // inter_medium
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 15),
                            ),
                            validator: (v) => v?.isEmpty ?? true ? 'Password required' : null,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            color: Colors.grey,
                            size: 20,
                          ),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => context.pushNamed('forgotPassword', extra: widget.roleName),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Forgot Password',
                        style: TextStyle(
                          color: Color(0xFF3D9A7E), // green
                          fontWeight: FontWeight.w600, // inter_semibold
                          fontSize: 12,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: authState.isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF8C300), // yellow
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: authState.isLoading
                          ? const SizedBox(height: 25, width: 25, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                          : const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w500, // inter_medium
                              ),
                            ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  Center(
                    child: GestureDetector(
                      onTap: () => context.go(Routes.roleSelection),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Select Role ',
                            style: TextStyle(
                              color: Color(0xFFF8C300), // yellow
                              fontWeight: FontWeight.w500, // inter_medium
                              fontSize: 14,
                            ),
                          ),
                          Icon(Icons.keyboard_arrow_up_rounded, color: Color(0xFFF8C300), size: 18),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey, letterSpacing: 1));
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscure = false,
    VoidCallback? onToggleVisibility,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && obscure,
      validator: validator,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 12, right: 8),
          child: Icon(icon, color: Colors.grey, size: 18),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        suffixIcon: isPassword ? IconButton(
          onPressed: onToggleVisibility,
          icon: Icon(obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded, color: Colors.grey, size: 18),
        ) : null,
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
