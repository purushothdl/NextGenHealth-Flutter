// lib/features/dashboard/role based/shared/service_item.dart

import 'package:flutter/material.dart';

class ServiceItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const ServiceItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            icon,
            size: 36,
            color: Colors.blue,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}