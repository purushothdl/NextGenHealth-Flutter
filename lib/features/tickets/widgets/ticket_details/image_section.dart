import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageSection extends StatelessWidget {
  final String title;
  final String fileUrl;

  const ImageSection({
    super.key,
    required this.title,
    required this.fileUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            if (fileUrl.endsWith('.jpg') || fileUrl.endsWith('.jpeg') || fileUrl.endsWith('.png'))
              CachedNetworkImage(
                imageUrl: fileUrl,
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) {
                  print('Error loading image: $error');
                  return const Icon(Icons.error);
                },
              ),
          ],
        ),
      ),
    );
  }
}