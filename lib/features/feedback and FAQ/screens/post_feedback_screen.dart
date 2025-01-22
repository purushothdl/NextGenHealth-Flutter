import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/feedback_provider.dart';
import '../widgets/feedback/rating_widget.dart';

class PostFeedbackScreen extends StatefulWidget {
  const PostFeedbackScreen({super.key});

  @override
  State<PostFeedbackScreen> createState() => _PostFeedbackScreenState();
}

class _PostFeedbackScreenState extends State<PostFeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _commentController = TextEditingController();
  double _rating = 0;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    
    final feedbackProvider = Provider.of<FeedbackProvider>(context, listen: false);
    await feedbackProvider.postFeedback(
      title: _titleController.text,
      rating: _rating,
      comment: _commentController.text,
    );

    if (!mounted) return;
    
    setState(() => _isSubmitting = false);

    if (feedbackProvider.error == null) {
      _showSuccessDialog(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(feedbackProvider.error!),
          backgroundColor: Colors.red[600],
        ),
      );
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.blue, size: 48),
              const SizedBox(height: 16),
              Text('Feedback Submitted',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600
                ),
              ),
              const SizedBox(height: 8),
              const Text('Thank you for your input! 🎉',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close', style: TextStyle(color: Colors.red),),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Feedback',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(
                icon: Icons.title,
                title: 'Feedback Title',
                child: _buildTitleField(),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle(
                icon: Icons.feedback,
                title: 'Your Feedback',
                child: _buildCommentField(),
              ),
              const SizedBox(height: 24),
              RatingCard(
                rating: _rating,
                onRatingChanged: (rating) => setState(() => _rating = rating),
              ),
              const SizedBox(height: 32),
              _buildSubmitButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.blue, size: 20),
            ),
            const SizedBox(width: 12),
            Text(title,
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w600,
                fontSize: 15
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white, // Background color
            borderRadius: BorderRadius.circular(12), 
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), 
                blurRadius: 0.5, 
                spreadRadius: 0.5, 
                offset: const Offset(0, 0.5), 
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: child, 
          ),
        )
      ],
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      style: const TextStyle(fontSize: 16),
      decoration: const InputDecoration(
        hintText: 'Enter feedback title',
        hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
        border: InputBorder.none,
      ),
      validator: (value) => value?.isEmpty ?? true 
        ? 'Please enter a title' 
        : null,
    );
  }

  Widget _buildCommentField() {
    return TextFormField(
      controller: _commentController,
      maxLines: 5,
      style: const TextStyle(fontSize: 16),
      decoration: const InputDecoration(
        hintText: 'Write your feedback here...',
        hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
        border: InputBorder.none,
      ),
      validator: (value) => value?.isEmpty ?? true 
        ? 'Please enter your feedback' 
        : null,
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: _isSubmitting
            ? const SizedBox.shrink()
            : const Icon(Icons.send, size: 20),
        label: _isSubmitting
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text('Submit Feedback'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        onPressed: _isSubmitting ? null : () => _submitFeedback(context),
      ),
    );
  }
}