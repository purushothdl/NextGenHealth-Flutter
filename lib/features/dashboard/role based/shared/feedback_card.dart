// lib/features/dashboard/role_based/shared/feedback_card.dart
import 'package:flutter/material.dart';

class FeedbackCard extends StatelessWidget {
  final VoidCallback onGiveFeedback;
  final VoidCallback onViewFeedback;

  const FeedbackCard({
    super.key,
    required this.onGiveFeedback,
    required this.onViewFeedback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: AssetImage('assets/images/feedback_bg.jpg'), // Add your image
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title with blue background
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.blue.shade700,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Feedback',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 1.1,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Message
            const Text(
              'Your thoughts shape our service!\nShare your experience with us.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),

            // Buttons Row
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    text: 'Give Feedback',
                    backgroundColor: Colors.blue.shade700,
                    textColor: Colors.white,
                    onPressed: onGiveFeedback,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white.withOpacity(0.3),
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                ),
                Expanded(
                  child: _buildActionButton(
                    text: 'See Your Feedback',
                    backgroundColor: Colors.white,
                    textColor: Colors.blue.shade700,
                    onPressed: onViewFeedback,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 0),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}