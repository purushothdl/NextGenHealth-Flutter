// lib/features/admin/screens/pending_approvals_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../admin/providers/admin_provider.dart';

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
      // Load pending approvals when the screen is first displayed
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
        title: const Text('Pending Approvals'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: _buildPendingApprovalsList(adminProvider),
      ),
    );
  }

  Widget _buildPendingApprovalsList(AdminProvider adminProvider) {
    if (adminProvider.isLoading && adminProvider.pendingApprovals.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    } else if (adminProvider.error != null) {
      return Center(child: Text('Error: ${adminProvider.error}'));
    } else if (adminProvider.pendingApprovals.isEmpty) {
      return const Center(child: Text('No pending approvals found.'));
    }

    return ListView.builder(
      itemCount: adminProvider.pendingApprovals.length,
      itemBuilder: (context, index) {
        final user = adminProvider.pendingApprovals[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          elevation: 2.0,
          child: ListTile(
            leading: const Icon(Icons.person, color: Colors.orange),
            title: Text(
              user['username'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(user['email']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.check, color: Colors.green),
                  onPressed: () => _approveUser(context, user['_id']),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () => _rejectUser(context, user['_id']),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _approveUser(BuildContext context, String userId) async {
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    await adminProvider.approveUser(userId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User approved successfully!')),
    );
  }

  void _rejectUser(BuildContext context, String userId) async {
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    await adminProvider.rejectUser(userId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User rejected successfully!')),
    );
  }
}