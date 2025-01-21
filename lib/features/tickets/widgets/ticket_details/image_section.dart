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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFF3BAEE9), Color(0xFF6AC8F5)],
                  ).createShader(bounds),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(Icons.photo_library_rounded, 
                    color: Colors.blueGrey[300]),
              ],
            ),
            const SizedBox(height: 16),
if (fileUrl.endsWith('.jpg') || fileUrl.endsWith('.jpeg') || fileUrl.endsWith('.png'))
  SizedBox(
    height: 200, // Set a fixed height or use MediaQuery to make it dynamic
    width: double.infinity, // Ensure it takes the full width
    child: Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: fileUrl,
              placeholder: (context, url) => Center(
                child: Icon(
                  Icons.medical_services_rounded,
                  color: Colors.blueGrey[200],
                  size: 40,
                ),
              ),
              errorWidget: (context, url, error) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      color: Colors.red,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Failed to load image',
                      style: TextStyle(
                        color: Colors.blueGrey[400],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              fit: BoxFit.fill, // Stretch the image to fill the container
              width: double.infinity, // Ensure it takes the full width
              height: double.infinity, // Ensure it takes the full height
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => _showFullScreenImage(context),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                icon: Icon(
                  Icons.open_in_full_rounded,
                  color: Colors.blueGrey[600],
                  size: 16,
                ),
                label: Text(
                  'View Fullscreen',
                  style: TextStyle(
                    color: Colors.blueGrey[600],
                  ),
                ),
                onPressed: () => _showFullScreenImage(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFullScreenImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: InteractiveViewer(
          child: CachedNetworkImage(
            imageUrl: fileUrl,
            fit: BoxFit.contain, // Use BoxFit.contain for fullscreen to maintain aspect ratio
          ),
        ),
      ),
    );
  }
}