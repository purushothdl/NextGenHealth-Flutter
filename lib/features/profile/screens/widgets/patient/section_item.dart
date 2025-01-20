// lib/features/profile/widgets/patient/section_item.dart
import 'package:flutter/material.dart';

class SectionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<dynamic> items;

  const SectionItem({
    super.key,
    required this.icon,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 24, color: Colors.blue),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...items.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Card(
              elevation: 2,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.circle,
                  size: 8,
                  color: Colors.blue,
                ),
                title: Text(
                  item.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.blue,
                ),
              ),
            ),
          );
        }).toList(),
        const SizedBox(height: 16),
      ],
    );
  }
}