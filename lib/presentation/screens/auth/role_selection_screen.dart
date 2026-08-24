import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  final List<Map<String, dynamic>> _roles = [
    {
      'role_name': 'je',
      'role': 'Junior Engineer',
      'role_desc': 'Verify pothole reports and assign repair tasks to vendors.'
    },
    {
      'role_name': 'ae',
      'role': 'Assistant Engineer',
      'role_desc': 'Review and approve vendor assignments and oversee progress.'
    },
    {
      'role_name': 'aee',
      'role': 'Asst. Executive Engineer',
      'role_desc': 'Assign tasks, track progress, and inspect potholes when needed.'
    },
    {
      'role_name': 'ee',
      'role': 'Executive Engineer',
      'role_desc': 'Monitor overall work status and perform inspections.'
    },
    {
      'role_name': 'se',
      'role': 'Superintendent Engineer',
      'role_desc': 'Perform final QC checks and close completed repair reports.'
    },
    {
      'role_name': 'vendor',
      'role': 'Maintenance Vendor',
      'role_desc': 'Visit the site, fix potholes, and update task status with completion details.'
    },
  ];

  String? _selectedRoleName;
  String? _selectedRoleLabel;

  final _kGreen = const Color(0xFF3D9A7E);
  final _kBg = const Color(0xFFF5F7FA);
  final _kBorder = const Color(0xFFEEEEEE);

  void _onContinue() {
    if (_selectedRoleName != null) {
      context.pushNamed(
        'login',
        extra: {
          'role_name': _selectedRoleName,
          'role_label': _selectedRoleLabel,
          'role_desc': _roles.firstWhere((r) => r['role_name'] == _selectedRoleName)['role_desc'],
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    const Text(
                      'Select Your Role',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600, // inter_semibold
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Choose your official role to continue.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666768), // grey2
                        fontWeight: FontWeight.w500, // inter_medium
                      ),
                    ),
                    const SizedBox(height: 20),
                    ..._roles.map((role) {
                      final isSelected = _selectedRoleName == role['role_name'];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedRoleName = role['role_name'];
                              _selectedRoleLabel = role['role'];
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFFF7F7F7) : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected ? const Color(0xFF5C4DC8) : const Color(0xFFEBEBEB),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        role['role']!,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600, // inter_semibold
                                          fontSize: 14,
                                          color: Color(0xFF5C4DC8), // blue2
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        role['role_desc']!,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF666768), // grey2
                                          fontWeight: FontWeight.w400, // inter
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              color: Colors.white,
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _selectedRoleName != null ? _onContinue : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF8C300), // yellow
                    disabledBackgroundColor: const Color(0xFFF8C300).withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500, // inter_medium
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getRoleIcon(String roleName) {
    switch (roleName) {
      case 'je': return Icons.engineering_rounded;
      case 'ae': return Icons.architecture_rounded;
      case 'aee': return Icons.manage_accounts_rounded;
      case 'ee': return Icons.supervisor_account_rounded;
      case 'se': return Icons.verified_user_rounded;
      case 'vendor': return Icons.construction_rounded;
      default: return Icons.person_rounded;
    }
  }
}
