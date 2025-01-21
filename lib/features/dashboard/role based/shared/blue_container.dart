// lib/features/dashboard/role based/shared/blue_container.dart

import 'package:flutter/material.dart';
import 'package:next_gen_health/features/shared/utils/string_utils.dart';

class BlueContainer extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final String? imagePath; // Add imagePath parameter

  const BlueContainer({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onButtonPressed,
    this.imagePath, // Make it optional
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue, // Fallback color if no image is provided
        borderRadius: BorderRadius.circular(12.0),
        image: imagePath != null
            ? DecorationImage(
                image: AssetImage(imagePath!), 
                fit: BoxFit.cover, 
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3), // Add a dark overlay for better text visibility
                  BlendMode.darken,
                ),
              )
            : null, // No image if imagePath is null
      ),
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            StringUtils.getCapitalisedUsername(title),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.bottomLeft,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: onButtonPressed,
              child: Text(buttonText),
            ),
          ),
        ],
      ),
    );
  }
}