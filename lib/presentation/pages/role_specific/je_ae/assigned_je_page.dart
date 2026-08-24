import 'package:flutter/material.dart';

import '../../../../core/widgets/common/loading_indicator.dart';
import '../../../../data/models/pothole_model.dart';

/// Assigned JE Page - For Junior Engineer to view assigned cases
class AssignedJePage extends StatefulWidget {
  const AssignedJePage({super.key});

  @override
  State<AssignedJePage> createState() => _AssignedJePageState();
}

class _AssignedJePageState extends State<AssignedJePage> {
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

  void _onInspect(PotholeModel caseData) {
    // TODO: Navigate to inspection form
  }

  void _onViewDetails(PotholeModel caseData) {
    // TODO: Navigate to case details
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assigned Cases', style: TextStyle(fontFamily: 'inter_medium', fontSize: 16, color: Colors.white)),
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
          Icon(Icons.assignment_turned_in, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text('No assigned cases', style: theme.textTheme.titleMedium),
        ],
      ),
    );
  }

  Widget _buildCaseCard(PotholeModel caseData, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _onViewDetails(caseData),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                caseData.caseId,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              if (caseData.location != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        caseData.location!,
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _onInspect(caseData),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Start Inspection'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
