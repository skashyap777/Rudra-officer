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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(fontFamily: 'inter_medium', fontSize: 16, color: Colors.white)),
        backgroundColor: const Color(0xFF3D9A7E),
        elevation: 10,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                _ProfileCard(user: user),
                _MenuItem(
                  marginTop: 60,
                  iconStr: 'ri_edit_fill.png',
                  title: 'Edit Profile',
                  onTap: () => _onAction('Edit Profile'),
                ),
                _MenuItem(
                  iconStr: 'group.png',
                  title: 'Terms & Conditions',
                  onTap: () => _onAction('Terms'),
                ),
                _MenuItem(
                  iconStr: 'privacy_policy_7888843_2.png',
                  title: 'Privacy Policy',
                  onTap: () => _onAction('Privacy'),
                ),
                _MenuItem(
                  iconStr: 'ic_sharp_phone.png',
                  title: 'Contact Support',
                  onTap: () => _onAction('Support'),
                ),
                _MenuItem(
                  iconStr: 'assam_pwd_logo_1.png',
                  title: 'About PWD Assam Initiative',
                  onTap: () => _onAction('About'),
                ),
                _MenuItem(
                  iconStr: 'material_symbols_logout.png',
                  title: 'Logout',
                  onTap: _logout,
                ),
              ],
            ),
          ),
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
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9),
              image: photoUrl.isNotEmpty
                  ? DecorationImage(image: NetworkImage(photoUrl), fit: BoxFit.fill)
                  : const DecorationImage(image: AssetImage('assets/images/frame_16.png'), fit: BoxFit.fill),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const Text('Hello, ', style: TextStyle(fontFamily: 'inter_semibold', fontSize: 14, color: Colors.black)),
                    Text(name, style: const TextStyle(fontFamily: 'inter_semibold', fontSize: 14, color: Colors.black)),
                  ],
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    Image.asset('assets/images/id_card_10426413_1.png', width: 13, height: 13, fit: BoxFit.fill, errorBuilder: (_, __, ___) => const Icon(Icons.badge, size: 13)),
                    const SizedBox(width: 5),
                    Text(role, style: const TextStyle(fontFamily: 'inter_medium', fontSize: 12, color: Color(0xFF666768))),
                  ],
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    Image.asset('assets/images/maps_flags_386283_1.png', width: 13, height: 13, fit: BoxFit.fill, errorBuilder: (_, __, ___) => const Icon(Icons.flag, size: 13)),
                    const SizedBox(width: 5),
                    const Text('Division Name: ', style: TextStyle(fontFamily: 'inter_medium', fontSize: 12, color: Color(0xFF666768))),
                    Expanded(
                      child: Text(division, style: const TextStyle(fontFamily: 'inter_medium', fontSize: 12, color: Color(0xFF666768)), overflow: TextOverflow.ellipsis),
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
  final String title;
  final VoidCallback onTap;
  final double marginTop;

  const _MenuItem({
    required this.iconStr,
    required this.title,
    required this.onTap,
    this.marginTop = 13,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: marginTop),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            child: Row(
              children: [
                Image.asset('assets/images/$iconStr', width: 20, height: 20, fit: BoxFit.fill, errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 20)),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontFamily: 'inter_medium', fontSize: 14, color: Colors.black),
                  ),
                ),
                Image.asset('assets/images/weui_arrow_filled.png', width: 12, height: 24, fit: BoxFit.fill, errorBuilder: (_, __, ___) => const Icon(Icons.chevron_right, size: 16)),
                const SizedBox(width: 10),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 10, left: 40, right: 10),
            height: 1,
            color: const Color(0xFFD6D6D6), // grey4
          ),
        ],
      ),
    );
  }
}
