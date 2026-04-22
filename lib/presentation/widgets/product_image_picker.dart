import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductImagePicker extends StatelessWidget {
  final List<XFile> images;
  final VoidCallback onPickImages;
  final VoidCallback onTakePhoto;
  final Function(int) onRemoveImage;
  final int maxImages;

  const ProductImagePicker({
    super.key,
    required this.images,
    required this.onPickImages,
    required this.onTakePhoto,
    required this.onRemoveImage,
    this.maxImages = 5,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // Gallery button (only if < max images)
          if (images.length < maxImages)
            Container(
              width: 100,
              height: 100,
              margin: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: onPickImages,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate,
                        size: 32,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Galería',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Camera button (only if images exist)
          if (images.isNotEmpty)
            Container(
              width: 100,
              height: 100,
              margin: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: onTakePhoto,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt, size: 32, color: Colors.grey[600]),
                      const SizedBox(height: 4),
                      Text(
                        'Cámara',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Image thumbnails
          ...List.generate(images.length, (index) {
            return Stack(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.only(right: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(images[index].path),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 12,
                  child: GestureDetector(
                    onTap: () => onRemoveImage(index),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
