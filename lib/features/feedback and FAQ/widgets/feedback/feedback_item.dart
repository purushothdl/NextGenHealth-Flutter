import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:next_gen_health/features/shared/utils/string_utils.dart';

class FeedbackItem extends StatelessWidget {
  final Map<String, dynamic> feedback;
  final bool showUser;

  const FeedbackItem({
    required this.feedback,
    required this.showUser,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showUser) _buildUserHeader(),
            _buildTitle(),
            const SizedBox(height: 12),
            _buildComment(),
            const SizedBox(height: 16),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserHeader() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_outline, size: 18, color: Colors.blue),
          ),
          const SizedBox(width: 8),
          Text(
            StringUtils.getCapitalisedUsername(feedback['username'] ?? 'Unknown User'),
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.feedback_outlined, size: 20, color: Colors.blue),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            feedback['title'] ?? 'No Title',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildComment() {
    return Text(
      feedback['comment'] ?? 'No comment provided',
      style: TextStyle(
        color: Colors.grey.shade700,
        height: 1.4,
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildRating(),
        _buildTimestamp(),
      ],
    );
  }

  Widget _buildRating() {
    final rating = feedback['rating'] ?? 0.0;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: _getRatingColor(rating).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Text(
            _getEmoji(rating),
            style: const TextStyle(fontSize: 24),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${rating.toStringAsFixed(1)}/5.0',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: _getRatingColor(rating),
          ),
        ),
      ],
    );
  }

  Widget _buildTimestamp() {
    return Text(
      _formatDate(feedback['timestamp']),
      style: TextStyle(
        fontSize: 12,
        color: Colors.grey.shade600,
        fontFamily: 'monospace',
        fontWeight: FontWeight.bold,
      ),
    );
  }

  String _formatDate(String? timestamp) {
    if (timestamp == null) return 'No date';
    final date = DateTime.parse(timestamp);
    return DateFormat('dd MMM y • HH:mm').format(date);
  }

  String _getEmoji(double rating) {
    if (rating <= 1) return '😭';
    if (rating <= 2) return '😞';
    if (rating <= 3) return '😐';
    if (rating <= 4) return '😊';
    return '😎';
  }

  Color _getRatingColor(double rating) {
    if (rating <= 2) return Colors.red;
    if (rating <= 3) return Colors.orange;
    if (rating <= 4) return Colors.green;
    return Colors.green;
  }
}