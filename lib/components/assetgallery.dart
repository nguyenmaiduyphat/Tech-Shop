// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:tech_fun/components/fullscreengallery.dart';

class AssetGallery extends StatelessWidget {
  final List<String> assetImagePaths;

  const AssetGallery({super.key, required this.assetImagePaths});

  @override
  Widget build(BuildContext context) {
    final displayImages = assetImagePaths.take(4).toList();
    final remainingCount = assetImagePaths.length - 4;

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: List.generate(displayImages.length, (index) {
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FullScreenGallery(
                images: assetImagePaths,
                initialIndex: index,
              ),
            ),
          ),
          child: Stack(
            children: [
              Image.asset(
                displayImages[index],
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              if (index == 3 && remainingCount > 0)
                Container(
                  width: 100,
                  height: 100,
                  color: Colors.black.withOpacity(0.5),
                  alignment: Alignment.center,
                  child: Text(
                    '+$remainingCount',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
