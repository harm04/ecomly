import 'package:flutter/material.dart';
import 'package:ecomly/services/cloudinary_optimizer.dart';

class OptimizedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final String? placeholder;
  final Widget? errorWidget;
  final String quality;

  const OptimizedNetworkImage({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.quality = 'auto:best',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return errorWidget ??
          Container(
            width: width,
            height: height,
            color: Colors.grey[300],
            child: Icon(Icons.image_not_supported, color: Colors.grey[600]),
          );
    }

    final optimizedUrl = CloudinaryOptimizer.getOptimizedImageUrl(
      originalUrl: imageUrl,
      width: (width != null && width!.isFinite) ? width!.toInt() : null,
      height: (height != null && height!.isFinite) ? height!.toInt() : null,
      quality: quality,
      fit: fit,
    );

    return Image.network(
      optimizedUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;

        return Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ??
            Container(
              width: width,
              height: height,
              color: Colors.grey[300],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.broken_image, color: Colors.grey[600]),
                  if (width == null || width! > 100)
                    Text(
                      'Image failed to load',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                ],
              ),
            );
      },
    );
  }
}

// Specialized widgets for different use cases
class ProductImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;

  const ProductImage({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OptimizedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      quality: 'auto:best',
    );
  }
}

class ThumbnailImage extends StatelessWidget {
  final String imageUrl;
  final double size;

  const ThumbnailImage({Key? key, required this.imageUrl, this.size = 150})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final optimizedUrl = CloudinaryOptimizer.getThumbnailUrl(
      imageUrl,
      size: size.isFinite ? size.toInt() : 150,
    );

    return Image.network(
      optimizedUrl,
      width: size,
      height: size,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;

        return Container(
          width: size,
          height: size,
          color: Colors.grey[200],
          child: Center(child: CircularProgressIndicator()),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: size,
          height: size,
          color: Colors.grey[300],
          child: Icon(Icons.broken_image, color: Colors.grey[600]),
        );
      },
    );
  }
}

class BannerImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;

  const BannerImage({Key? key, required this.imageUrl, this.width, this.height})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final optimizedUrl = CloudinaryOptimizer.getBannerImageUrl(
      imageUrl,
      width: (width != null && width!.isFinite) ? width!.toInt() : 800,
      height: (height != null && height!.isFinite) ? height!.toInt() : 200,
    );

    return Image.network(
      optimizedUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;

        return Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: Center(child: CircularProgressIndicator()),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          color: Colors.grey[300],
          child: Icon(Icons.broken_image, color: Colors.grey[600]),
        );
      },
    );
  }
}

class CategoryImage extends StatelessWidget {
  final String imageUrl;
  final double size;

  const CategoryImage({Key? key, required this.imageUrl, this.size = 200})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final optimizedUrl = CloudinaryOptimizer.getCategoryImageUrl(
      imageUrl,
      size: size.isFinite ? size.toInt() : 200,
    );

    return Image.network(
      optimizedUrl,
      width: size,
      height: size,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;

        return Container(
          width: size,
          height: size,
          color: Colors.grey[200],
          child: Center(child: CircularProgressIndicator()),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: size,
          height: size,
          color: Colors.grey[300],
          child: Icon(Icons.broken_image, color: Colors.grey[600]),
        );
      },
    );
  }
}
