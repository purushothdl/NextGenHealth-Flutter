import 'package:flutter/material.dart';

class RatingCard extends StatefulWidget {
  final double rating;
  final ValueChanged<double> onRatingChanged;

  const RatingCard({
    required this.rating,
    required this.onRatingChanged,
    super.key,
  });

  @override
  State<RatingCard> createState() => _RatingCardState();
}

class _RatingCardState extends State<RatingCard> {
  late double _currentRating;
  final List<String> _ratingTexts = [
    'Terrible',
    'Poor',
    'Average',
    'Good',
    'Excellent'
  ];

  @override
  void initState() {
    super.initState();
    _currentRating = widget.rating;
  }

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
            _buildTitle(),
            const SizedBox(height: 16),
            _buildEmojiRating(),
            const SizedBox(height: 16),
            _buildRatingText(),
          ],
        ),
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
          child: const Icon(Icons.star, color: Colors.blue, size: 20),
        ),
        const SizedBox(width: 12),
        const Text('Your Rating',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.w600,
            fontSize: 15
          ),
        ),
      ],
    );
  }

  Widget _buildEmojiRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(5, (index) {
        final isSelected = (index + 1) == _currentRating;
        final bgColor = _getBackgroundColor(index);
        
        return GestureDetector(
          onTap: () {
            setState(() {
              _currentRating = index + 1.0;
              widget.onRatingChanged(_currentRating);
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutBack,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected 
                  ? bgColor.withOpacity(0.2) // 20% opacity
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: AnimatedScale(
              scale: isSelected ? 1.3 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Text(
                _getEmoji(index),
                style: TextStyle(
                  fontSize: 32,
                  color: isSelected ? _getEmojiColor(index) : Colors.grey,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildRatingText() {
    return Center(
      child: Text(
        _currentRating > 0 
            ? _ratingTexts[_currentRating.toInt() - 1]
            : 'Select Rating',
        style: TextStyle(
          color: _getTextColor(),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getBackgroundColor(int index) {
    if (index <= 1) return Colors.red; // Terrible, Poor
    if (index == 2) return Colors.orange; // Average
    return Colors.green; // Good, Excellent
  }

  Color _getEmojiColor(int index) {
    switch(index) {
      case 0: return Colors.red;
      case 1: return Colors.orange;
      case 2: return Colors.amber;
      case 3: return Colors.lightGreen;
      case 4: return Colors.green;
      default: return Colors.black;
    }
  }

  Color _getTextColor() {
    if (_currentRating <= 2) return Colors.red;
    if (_currentRating == 3) return Colors.orange;
    return Colors.green;
  }

  String _getEmoji(int index) {
    switch (index) {
      case 0: return '😭';
      case 1: return '😞';
      case 2: return '😐';
      case 3: return '😊';
      case 4: return '😎';
      default: return '😐';
    }
  }
}