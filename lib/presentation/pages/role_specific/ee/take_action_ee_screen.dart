import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/providers/providers.dart';
import '../../../../data/models/user_model.dart';

const _green = Color(0xFF3D9A7E);
const _yellow = Color(0xFFF8C300);

class TakeActionEeScreen extends ConsumerStatefulWidget {
  final String caseId;
  final String reportId;

  const TakeActionEeScreen({
    super.key,
    required this.caseId,
    required this.reportId,
  });

  @override
  ConsumerState<TakeActionEeScreen> createState() => _TakeActionEeScreenState();
}

class _TakeActionEeScreenState extends ConsumerState<TakeActionEeScreen> {
  // Radio selection: null = nothing selected, true = satisfied, false = unsatisfied
  bool? _isSatisfied;

  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _otherRemarksController = TextEditingController();

  bool _isForwardLoading = false;
  bool _isReassignLoading = false;
  
  bool _isLoadingSEs = true;
  List<UserModel> _seUsers = [];
  UserModel? _selectedSe;

  @override
  void initState() {
    super.initState();
    _fetchSEs();
  }

  Future<void> _fetchSEs() async {
    try {
      final repo = await ref.read(reportRepositoryProvider.future);
      final users = await repo.getUsersInDivision('se');
      if (mounted) {
        setState(() {
          _seUsers = users;
          _isLoadingSEs = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingSEs = false);
      }
    }
  }

  @override
  void dispose() {
    _remarksController.dispose();
    _otherRemarksController.dispose();
    super.dispose();
  }

  // ── Derived booleans ──────────────────────────────────────────────────────
  bool get _canForward => _isSatisfied == true && _selectedSe != null;
  bool get _canReassign =>
      _isSatisfied == false && _otherRemarksController.text.trim().isNotEmpty;

  // ── Confirm dialogs ───────────────────────────────────────────────────────
  Future<void> _showForwardConfirm() async {
    final confirmed = await _showConfirmDialog(
      title: 'Forward to SE',
      subtitle: 'Are you sure you want to forward this case to Superintending Engineer (SE)?',
      reportId: widget.reportId,
      actionLabel: 'Forward',
      actionColor: _green,
    );
    if (confirmed == true) _doForwardToSe();
  }

  Future<void> _showReassignConfirm() async {
    final remark = _otherRemarksController.text.trim();
    if (remark.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please specify the reason for return.')),
      );
      return;
    }
    final confirmed = await _showConfirmDialog(
      title: 'Return to AEE',
      subtitle: 'Are you sure you want to return this case to AEE?',
      reportId: widget.reportId,
      actionLabel: 'Return',
      actionColor: _yellow,
    );
    if (confirmed == true) _doReassignToAee();
  }

  Future<bool?> _showConfirmDialog({
    required String title,
    required String subtitle,
    required String reportId,
    required String actionLabel,
    required Color actionColor,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.info_outline, size: 64, color: _green),
              const SizedBox(height: 12),
              Text(title,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black)),
              const SizedBox(height: 8),
              Text(subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, color: Color(0xFF666666))),
              const SizedBox(height: 6),
              Text('Report ID: $reportId',
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _green)),
              const SizedBox(height: 24),
              Row(
                children: [
                   Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(ctx, false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: _green),
                        ),
                        alignment: Alignment.center,
                        child: const Text('Cancel',
                            style: TextStyle(
                                color: _green, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(ctx, true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        decoration: BoxDecoration(
                          color: actionColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        alignment: Alignment.center,
                        child: Text(actionLabel,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── API calls ──────────────────────────────────────────────────────────────
  Future<void> _doForwardToSe() async {
    if (_selectedSe == null) return;
    setState(() => _isForwardLoading = true);
    try {
      final repo = await ref.read(reportRepositoryProvider.future);
      await repo.forwardToSe(
        int.parse(widget.caseId),
        _selectedSe!.id,
        _remarksController.text.trim(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Report forwarded to SE successfully')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        final msg = _extractError(e);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(msg)));
      }
    } finally {
      if (mounted) setState(() => _isForwardLoading = false);
    }
  }

  Future<void> _doReassignToAee() async {
    setState(() => _isReassignLoading = true);
    try {
      final repo = await ref.read(reportRepositoryProvider.future);
      // EE has a reassignToAee method in ApiEndpoints but might need implementation in repo
      // checking repo again...
      await repo.reassignToAee(
        caseId: widget.caseId,
        otherReason: _otherRemarksController.text.trim(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Report returned to AEE successfully')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        final msg = _extractError(e);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(msg)));
      }
    } finally {
      if (mounted) setState(() => _isReassignLoading = false);
    }
  }

  String _extractError(Object e) {
    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map && data.containsKey('message')) return data['message'].toString();
      if (data is Map && data.containsKey('errors')) return data['errors'].toString();
    }
    return e.toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Action Panel (EE)', style: TextStyle(fontFamily: 'inter_medium', fontSize: 16, color: Colors.white)),
        backgroundColor: const Color(0xFF3D9A7E),
        elevation: 0,
        titleSpacing: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Inspection Review',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black, letterSpacing: -0.5),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Are you satisfied with the report? You can forward it to Superintending Engineer or return it to AEE for correction.',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.4, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 24),
                        _RadioOption(
                          label: 'Satisfied (Forward to SE)',
                          selected: _isSatisfied == true,
                          onTap: () => setState(() {
                            _isSatisfied = true;
                            _otherRemarksController.clear();
                          }),
                        ),
                        const SizedBox(height: 12),
                        _RadioOption(
                          label: 'Unsatisfied (Return to AEE)',
                          selected: _isSatisfied == false,
                          onTap: () => setState(() {
                            _isSatisfied = false;
                            _remarksController.clear();
                          }),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  if (_isSatisfied == true) ...[
                    const Padding(
                      padding: EdgeInsets.only(left: 4, bottom: 10),
                      child: Text('SELECT SUPERINTENDING ENGINEER *', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.grey, letterSpacing: 1)),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: _isLoadingSEs 
                        ? const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : DropdownButtonHideUnderline(
                            child: DropdownButton<UserModel>(
                              isExpanded: true,
                              hint: Text('Select SE', style: TextStyle(color: Colors.grey[400], fontSize: 14, fontWeight: FontWeight.w600)),
                              value: _selectedSe,
                              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: _green),
                              items: _seUsers.map((user) {
                                return DropdownMenuItem<UserModel>(
                                  value: user,
                                  child: Text('${user.name} (${user.userType.toUpperCase()})', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                                );
                              }).toList(),
                              onChanged: (val) => setState(() => _selectedSe = val),
                            ),
                          ),
                    ),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.only(left: 4, bottom: 10),
                      child: Text('REMARKS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.grey, letterSpacing: 1)),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: TextField(
                        controller: _remarksController,
                        maxLines: 5,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          hintText: 'Enter your approval remarks...',
                          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                  ],

                  if (_isSatisfied == false) ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 10),
                      child: Row(
                        children: const [
                          Text('REASON FOR RETURN', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.grey, letterSpacing: 1)),
                          Text(' *', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: TextField(
                        controller: _otherRemarksController,
                        maxLines: 5,
                        onChanged: (_) => setState(() {}),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          hintText: 'Describe why you are returning this case...',
                          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5)),
              ],
            ),
            child: Column(
              children: [
                if (_isSatisfied == false)
                  ElevatedButton(
                    onPressed: (_canReassign && !_isReassignLoading) ? _showReassignConfirm : null,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(60),
                      backgroundColor: Colors.orange[400],
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey[200],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 0,
                    ),
                    child: _isReassignLoading
                        ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                        : const Text('RETURN TO AEE', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                  ),
                if (_isSatisfied == true)
                  ElevatedButton(
                    onPressed: (_canForward && !_isForwardLoading) ? _showForwardConfirm : null,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(60),
                      backgroundColor: theme.primaryColor,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey[200],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 0,
                    ),
                    child: _isForwardLoading
                        ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                        : const Text('FORWARD TO SE', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                  ),
                if (_isSatisfied == null)
                  Text(
                    'Select an option above to proceed',
                    style: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.w700, fontSize: 13),
                  ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}

class _RadioOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _RadioOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? theme.primaryColor.withOpacity(0.05) : Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? theme.primaryColor : Colors.grey.shade200,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? theme.primaryColor : Colors.grey.shade400,
                  width: 2,
                ),
                color: selected ? theme.primaryColor : Colors.transparent,
              ),
              child: selected ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                color: selected ? theme.primaryColor : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
