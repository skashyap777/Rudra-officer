import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/routes.dart';
import '../../../data/models/user_model.dart';
import '../../../data/providers/auth_provider.dart';

const _green = Color(0xFF3D9A7E);

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});
  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: const Text('Confirm Logout', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
        content: const Text('Are you sure you want to logout?', style: TextStyle(fontSize: 13)),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey, fontSize: 13)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text('Logout', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await ref.read(authProvider.notifier).logout();
      if (!mounted) return;
      context.go(Routes.roleSelection);
    }
  }

  Future<void> _launch(String urlString) async {
    final url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _onAction(String action) {
    switch (action) {
      case 'Logout':          _logout(); break;
      case 'Edit Profile':    context.push(Routes.completeProfile); break;
      case 'Terms':           _launch('https://rudra.assam.gov.in/terms-and-conditions'); break;
      case 'Privacy':         _launch('https://pwdroads.assam.gov.in/portlets/privacy-policy-1'); break;
      case 'Support':         _launch('https://pwdroads.assam.gov.in/portlets/contact-us-22'); break;
      case 'About':           _launch('https://pwdroads.assam.gov.in/portlets/about-us-3'); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white)),
        backgroundColor: const Color(0xFF3D9A7E),
        elevation: 0,
        toolbarHeight: 56,
        centerTitle: false,
        titleSpacing: 14,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 28),
        child: Column(
          children: [
            _ProfileCard(user: user),
            Container(
              margin: const EdgeInsets.only(top: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE4E9E6)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  children: [
                    _MenuItem(
                      iconStr: 'ri_edit_fill.png',
                      fallbackIcon: Icons.edit_outlined,
                      title: 'Edit Profile',
                      onTap: () => _onAction('Edit Profile'),
                      showDivider: true,
                    ),
                    _MenuItem(
                      iconStr: 'group.png',
                      fallbackIcon: Icons.description_outlined,
                      title: 'Terms & Conditions',
                      onTap: () => _onAction('Terms'),
                      showDivider: true,
                    ),
                    _MenuItem(
                      iconStr: 'privacy_policy_7888843_2.png',
                      fallbackIcon: Icons.privacy_tip_outlined,
                      title: 'Privacy Policy',
                      onTap: () => _onAction('Privacy'),
                      showDivider: true,
                    ),
                    _MenuItem(
                      iconStr: 'ic_sharp_phone.png',
                      fallbackIcon: Icons.headset_mic_outlined,
                      title: 'Contact Support',
                      onTap: () => _onAction('Support'),
                      showDivider: true,
                    ),
                    _MenuItem(
                      iconStr: 'assam_pwd_logo_1.png',
                      fallbackIcon: Icons.info_outline,
                      title: 'About PWD Assam Initiative',
                      onTap: () => _onAction('About'),
                      showDivider: true,
                    ),
                    _MenuItem(
                      iconStr: 'material_symbols_logout.png',
                      fallbackIcon: Icons.logout_rounded,
                      title: 'Logout',
                      isDestructive: true,
                      onTap: _logout,
                      showDivider: false,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final UserModel? user;
  const _ProfileCard({this.user});

  @override
  Widget build(BuildContext context) {
    final name = user?.name ?? 'Officer';
    final role = user?.userType.toUpperCase() ?? '';
    final division = user?.divisionName ?? '---';
    final photoUrl = user?.profilePhotoLink ?? '';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE4E9E6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 64,
              height: 64,
              color: const Color(0xFF3D9A7E).withValues(alpha: 0.08),
              child: photoUrl.isNotEmpty
                  ? Image.network(photoUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.person, color: Color(0xFF3D9A7E), size: 32))
                  : const Icon(Icons.person, color: Color(0xFF3D9A7E), size: 32),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black87),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.badge_outlined, size: 14, color: Color(0xFF3D9A7E)),
                    const SizedBox(width: 6),
                    Text(
                      role,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF3D9A7E)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        division,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final String iconStr;
  final IconData fallbackIcon;
  final String title;
  final VoidCallback onTap;
  final bool showDivider;
  final bool isDestructive;

  const _MenuItem({
    required this.iconStr,
    required this.fallbackIcon,
    required this.title,
    required this.onTap,
    this.showDivider = true,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = isDestructive ? const Color(0xFFD32F2F) : Colors.black87;
    final iconColor = isDestructive ? const Color(0xFFD32F2F) : const Color(0xFF3D9A7E);

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/$iconStr',
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Icon(fallbackIcon, size: 20, color: iconColor),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isDestructive ? FontWeight.w600 : FontWeight.w500,
                      color: titleColor,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right_rounded, size: 18, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
        if (showDivider)
          const Divider(height: 1, thickness: 1, indent: 50, endIndent: 16, color: Color(0xFFF2F4F3)),
      ],
    );
  }
}
