import 'package:flutter/material.dart';

import '../../../../core/widgets/common/loading_indicator.dart';
import '../../../../data/models/pothole_model.dart';

/// Pending EE Page - For Executive Engineer to view pending cases
class PendingEePage extends StatefulWidget {
  const PendingEePage({super.key});

  @override
  State<PendingEePage> createState() => _PendingEePageState();
}

class _PendingEePageState extends State<PendingEePage> {
  bool _isLoading = false;
  final List<PotholeModel> _cases = [];

  @override
  void initState() {
    super.initState();
    _loadCases();
  }

  Future<void> _loadCases() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
  }

  void _onAccept(PotholeModel caseData) {
    // TODO: Implement accept case
  }

  void _onReject(PotholeModel caseData) {
    // TODO: Show reject dialog
  }

  void _onAssign(PotholeModel caseData) {
    // TODO: Navigate to assign to AEE
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Cases', style: TextStyle(fontFamily: 'inter_medium', fontSize: 16, color: Colors.white)),
        backgroundColor: const Color(0xFF3D9A7E),
        elevation: 0,
        titleSpacing: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(child: _isLoading
          ? const Center(child: LoadingIndicator())
          : _cases.isEmpty
              ? _buildEmptyState(theme)
              : RefreshIndicator(
                  onRefresh: _loadCases,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _cases.length,
                    itemBuilder: (context, index) => _buildCaseCard(_cases[index], theme),
                  ),
                )),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text('No pending cases', style: theme.textTheme.titleMedium),
        ],
      ),
    );
  }

  Widget _buildCaseCard(PotholeModel caseData, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(caseData.caseId, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _onAccept(caseData),
                    child: const Text('Accept'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _onReject(caseData),
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text('Reject'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _onAssign(caseData),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF8C300)),
                child: const Text('Assign to AEE'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
