import 'package:flutter/material.dart';

class RecipeImage extends StatelessWidget {
  static const String stockImageUrl =
      'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?auto=format&fit=crop&w=1200&q=80';

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;

  const RecipeImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  Widget _stockImage() {
    return Image.network(
      stockImageUrl,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => _imagePlaceholder(),
    );
  }

  Widget _imagePlaceholder() {
    return SizedBox(
      width: width,
      height: height,
      child: const ColoredBox(
        color: Color(0xFFF3EEE4),
        child: Center(
          child: Icon(Icons.dinner_dining, size: 64, color: Colors.grey),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final url = imageUrl.trim();
    if (url.isEmpty) return _stockImage();

    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => _stockImage(),
    );
  }
}
