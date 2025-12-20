import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ImageCacheHelper {
  static final CacheManager cacheManager = CacheManager(
    Config(
      'vision_app_cache',
      maxNrOfCacheObjects: 150,
      stalePeriod: const Duration(days: 7),
      repo: JsonCacheInfoRepository(databaseName: 'vision_cache'),
    ),
  );

  static Widget cachedNetworkImage(
    String url, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget Function(BuildContext, String)? placeholder,
    Widget Function(BuildContext, String, dynamic)? errorWidget,
  }) {
    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      placeholder: placeholder ?? (context, url) => _buildPlaceholder(),
      errorWidget: errorWidget ?? (context, url, error) => _buildErrorWidget(),
      cacheManager: cacheManager,
    );
  }

  static Widget cachedAssetImage(
    String assetPath, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Color? placeholderColor,
  }) {
    return Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
    );
  }

  static Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey[200]!,
            Colors.grey[300]!,
          ],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.image,
          color: Colors.grey,
          size: 40,
        ),
      ),
    );
  }

  static Widget _buildErrorWidget() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Icon(
          Icons.broken_image,
          color: Colors.grey,
          size: 40,
        ),
      ),
    );
  }

  static Future<void> clearCache() async {
    await cacheManager.emptyCache();
  }

  static Future<void> removeFromCache(String url) async {
    await cacheManager.removeFile(url);
  }
}
