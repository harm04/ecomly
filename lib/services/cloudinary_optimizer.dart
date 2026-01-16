import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';

class CloudinaryOptimizer {
  static const String cloudName = 'dzrbiw4bc';
  static const String uploadPreset = 'omqk9y1q';

  // Create optimized Cloudinary instance
  static CloudinaryPublic getCloudinaryInstance() {
    return CloudinaryPublic(cloudName, uploadPreset);
  }

  // Upload file with optimizations
  static Future<CloudinaryResponse> uploadOptimizedFile({
    required CloudinaryFile file,
    String? folder,
  }) async {
    final cloudinary = getCloudinaryInstance();

    return await cloudinary.uploadFile(file);
  }

  // Generate optimized image URL for display
  static String getOptimizedImageUrl({
    required String originalUrl,
    int? width,
    int? height,
    String quality = 'auto:best',
    String format = 'auto',
    BoxFit? fit,
  }) {
    if (originalUrl.isEmpty) return originalUrl;

    // Extract the public_id from the Cloudinary URL
    final uri = Uri.parse(originalUrl);
    final pathSegments = uri.pathSegments;

    if (pathSegments.length < 3) return originalUrl;

    // Find the version and public_id parts
    int versionIndex = -1;
    for (int i = 0; i < pathSegments.length; i++) {
      if (pathSegments[i].startsWith('v')) {
        versionIndex = i;
        break;
      }
    }

    if (versionIndex == -1) return originalUrl;

    // Extract public_id (everything after version)
    final publicId = pathSegments.sublist(versionIndex + 1).join('/');
    final publicIdWithoutExtension = publicId.split('.').first;

    // Build transformation string
    List<String> transformations = [];

    // Add dimensions if provided
    if (width != null && height != null) {
      String cropMode = _getCropMode(fit);
      transformations.add('w_$width,h_$height,c_$cropMode');
    } else if (width != null) {
      transformations.add('w_$width');
    } else if (height != null) {
      transformations.add('h_$height');
    }

    // Add quality and format optimizations
    transformations.addAll(['f_$format', 'q_$quality', 'fl_progressive']);

    final transformationString = transformations.join(',');

    // Construct optimized URL
    return 'https://res.cloudinary.com/$cloudName/image/upload/$transformationString/$publicIdWithoutExtension';
  }

  // Helper method to convert Flutter BoxFit to Cloudinary crop mode
  static String _getCropMode(BoxFit? fit) {
    switch (fit) {
      case BoxFit.cover:
        return 'fill'; // Fills the given dimensions, may crop
      case BoxFit.contain:
        return 'fit'; // Fits within dimensions, may have padding
      case BoxFit.fill:
        return 'scale'; // Stretches to fill, may distort
      case BoxFit.fitWidth:
        return 'scale'; // Scales to fit width
      case BoxFit.fitHeight:
        return 'scale'; // Scales to fit height
      case BoxFit.scaleDown:
        return 'limit'; // Only scales down if larger
      default:
        return 'fill';
    }
  }

  // Preset configurations for common use cases
  static String getThumbnailUrl(String originalUrl, {int size = 150}) {
    return getOptimizedImageUrl(
      originalUrl: originalUrl,
      width: size,
      height: size,
      quality: 'auto:good',
      fit: BoxFit.cover,
    );
  }

  static String getProductImageUrl(
    String originalUrl, {
    int width = 400,
    int height = 400,
  }) {
    return getOptimizedImageUrl(
      originalUrl: originalUrl,
      width: width,
      height: height,
      quality: 'auto:best',
      fit: BoxFit.cover,
    );
  }

  static String getBannerImageUrl(
    String originalUrl, {
    int width = 800,
    int height = 200,
  }) {
    return getOptimizedImageUrl(
      originalUrl: originalUrl,
      width: width,
      height: height,
      quality: 'auto:best',
      fit: BoxFit.cover,
    );
  }

  static String getCategoryImageUrl(String originalUrl, {int size = 200}) {
    return getOptimizedImageUrl(
      originalUrl: originalUrl,
      width: size,
      height: size,
      quality: 'auto:good',
      fit: BoxFit.cover,
    );
  }
}
