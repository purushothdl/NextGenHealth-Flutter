import 'package:flutter/material.dart';

class FeedbackLoadingState extends StatelessWidget {
  const FeedbackLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: Colors.blue.shade600),
          const SizedBox(height: 20),
          const Text(
            'Loading Feedback...',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class FeedbackErrorState extends StatelessWidget {
  final String error;

  const FeedbackErrorState({required this.error, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade600, size: 40),
          const SizedBox(height: 16),
          const Text(
            'Couldn\'t load feedback:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

class FeedbackEmptyState extends StatelessWidget {
  const FeedbackEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_outlined, color: Colors.blue.shade300, size: 60),
          const SizedBox(height: 20),
          const Text(
            'No Feedback Found',
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
          const SizedBox(height: 8),
          Text(
            'Your feedback will appear here',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}