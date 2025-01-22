import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/feedback_provider.dart';
import '../widgets/feedback/feedback_item.dart';
import '../widgets/feedback/feedback_state.dart';


class ViewFeedbackScreen extends StatefulWidget {
  const ViewFeedbackScreen({super.key});

  @override
  State<ViewFeedbackScreen> createState() => _ViewFeedbackScreenState();
}

class _ViewFeedbackScreenState extends State<ViewFeedbackScreen> {
  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final feedbackProvider = Provider.of<FeedbackProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      // Fetch feedback based on the user's role
      if (authProvider.currentUser?['role'] == 'admin') {
        feedbackProvider.loadAdminFeedback();
      } else {
        feedbackProvider.loadFeedback();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final feedbackProvider = Provider.of<FeedbackProvider>(context);

    return Scaffold(
      appBar: _buildAppBar(authProvider.currentUser?['role'] == 'admin'),
      body: _buildBody(feedbackProvider, authProvider),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isAdmin) {
    return AppBar(
      title: Text(
        isAdmin ? 'User Feedback' : 'Your Feedback',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ), 
      centerTitle: true,
      foregroundColor: Colors.white,
      backgroundColor: Colors.blue,
      elevation: 2,
      shadowColor: Colors.black12,
    );
  }

  Widget _buildBody(FeedbackProvider feedbackProvider, AuthProvider authProvider) {
    if (feedbackProvider.isLoading) return const FeedbackLoadingState();
    if (feedbackProvider.error != null) return FeedbackErrorState(error: feedbackProvider.error!);
    if (feedbackProvider.feedbacks.isEmpty) return const FeedbackEmptyState();

    return RefreshIndicator(
      color: Colors.blue.shade600,
      onRefresh: () async {
        if (authProvider.currentUser?['role'] == 'admin') {
          await feedbackProvider.loadAdminFeedback();
        } else {
          await feedbackProvider.loadFeedback();
        }
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: feedbackProvider.feedbacks.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) => FeedbackItem(
          feedback: feedbackProvider.feedbacks[index],
          showUser: authProvider.currentUser?['role'] == 'admin', // Pass whether to show user info
        ),
      ),
    );
  }
}