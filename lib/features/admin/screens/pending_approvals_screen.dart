// lib/features/admin/screens/pending_approvals_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../admin/providers/admin_provider.dart';
import '../widgets/approval/user_approval_card.dart';

class PendingApprovalsScreen extends StatefulWidget {
  const PendingApprovalsScreen({super.key});

  @override
  State<PendingApprovalsScreen> createState() => _PendingApprovalsScreenState();
}

class _PendingApprovalsScreenState extends State<PendingApprovalsScreen> {
  bool _isInitialLoad = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInitialLoad) {
      _isInitialLoad = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<AdminProvider>(context, listen: false)
            .loadPendingApprovals(forceReload: true);
      });
    }
  }

  Future<void> _refreshData() async {
    await Provider.of<AdminProvider>(context, listen: false)
        .loadPendingApprovals(forceReload: true);
  }

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Approvals', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: _buildContent(adminProvider),
      ),
    );
  }

  Widget _buildContent(AdminProvider adminProvider) {
    if (adminProvider.isLoading && adminProvider.pendingApprovals.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (adminProvider.pendingApprovals.isEmpty) {
      return Center(
        child: Text(
          'No pending approvals found',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: adminProvider.pendingApprovals.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) => UserApprovalCard(
        user: adminProvider.pendingApprovals[index],
        onApprove: (userId) => _handleApproval(context, userId),
        onReject: (userId) => _handleRejection(context, userId),
      ),
    );
  }

  void _handleApproval(BuildContext context, String userId) async {
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    await adminProvider.approveUser(userId);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User approved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _handleRejection(BuildContext context, String userId) async {
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    await adminProvider.rejectUser(userId);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User rejected successfully!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}