import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statuses/constants/app_constants.dart';
import 'package:statuses/data/models/status_file.dart';
import 'package:statuses/data/services/video_thumbnail_service.dart';
import 'package:statuses/i18n/translations.g.dart';
import 'package:statuses/providers/download_notifier.dart';
import 'package:statuses/ui/theme/app_theme.dart';
import 'package:statuses/utils/date_formatter.dart';
import 'package:statuses/utils/file_utils.dart';

class StatusThumbnailCard extends StatelessWidget {
  final StatusFile status;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isSelected;
  final bool showSavedIndicator;

  const StatusThumbnailCard({
    super.key,
    required this.status,
    this.onTap,
    this.onLongPress,
    this.isSelected = false,
    this.showSavedIndicator = true,
  });

  @override
  Widget build(BuildContext context) {
    final isSaved = showSavedIndicator
        ? context.select<DownloadNotifier, bool>(
            (n) => n.savedFilePaths.contains(status.fileName),
          )
        : false;
    return RepaintBoundary(
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppShapes.smallRadius),
              child: _buildImage(context),
            ),
            if (status.mediaType != MediaType.image)
              Positioned(
                top: 4,
                right: 4,
                child: _buildBadge(context),
              ),
            if (isSaved)
              Positioned(
                bottom: 4,
                right: 4,
                child: Tooltip(
                  message: 'Ya guardado',
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.accentGreen,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: const Icon(Icons.check_rounded,
                        color: Colors.white, size: 12),
                  ),
                ),
              ),
            if (isSelected) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(AppShapes.smallRadius),
                child: Container(color: Colors.green.withValues(alpha: 0.4)),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green.shade600, width: 2.5),
                  borderRadius: BorderRadius.circular(AppShapes.smallRadius),
                ),
              ),
              Positioned(
                top: 6,
                left: 6,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: Colors.green.shade600,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: const Icon(Icons.check_rounded,
                      color: Colors.white, size: 14),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    switch (status.mediaType) {
      case MediaType.video:
        return FutureBuilder<String?>(
          future: VideoThumbnailService.instance.getThumbnail(status.filePath),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                color: Colors.black87,
                child: const Center(
                  child: Opacity(
                    opacity: 0.5,
                    child: Icon(
                      Icons.play_circle_outline,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              );
            }
            if (snapshot.hasData && snapshot.data != null) {
              return RepaintBoundary(
                child: Image.file(
                  File(snapshot.data!),
                  fit: BoxFit.cover,
                  cacheWidth: AppConstants.thumbnailSize.toInt(),
                  cacheHeight: AppConstants.thumbnailSize.toInt(),
                  errorBuilder: (_, __, ___) => _buildPlaceholder(context),
                ),
              );
            }
            return _buildPlaceholder(context);
          },
        );
      case MediaType.unknown:
        return _buildPlaceholder(context);
      case MediaType.image:
        return RepaintBoundary(
          child: Image.file(
            File(status.filePath),
            fit: BoxFit.cover,
            cacheWidth: AppConstants.thumbnailSize.toInt(),
            cacheHeight: AppConstants.thumbnailSize.toInt(),
            errorBuilder: (_, __, ___) => _buildPlaceholder(context),
          ),
        );
    }
  }

  Widget _buildPlaceholder(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark ? AppColors.surfaceDark : Colors.grey[200],
      child: Icon(
        status.mediaType == MediaType.video
            ? Icons.videocam_rounded
            : Icons.image_rounded,
        color: AppColors.secondaryText,
        size: 32,
      ),
    );
  }

  Widget _buildBadge(BuildContext context) {
    final t = Translations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 14),
          const SizedBox(width: 2),
          Text(
            t.detail.video_badge,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class StatusListItem extends StatelessWidget {
  final StatusFile status;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isSelected;
  final bool showSavedIndicator;

  const StatusListItem({
    super.key,
    required this.status,
    this.onTap,
    this.onLongPress,
    this.isSelected = false,
    this.showSavedIndicator = true,
  });

  @override
  Widget build(BuildContext context) {
    final isSaved = showSavedIndicator
        ? context.select<DownloadNotifier, bool>(
            (n) => n.savedFilePaths.contains(status.fileName),
          )
        : false;
    return ListTile(
      tileColor: isSelected ? Colors.green.withValues(alpha: 0.15) : null,
      onTap: onTap,
      onLongPress: onLongPress,
      leading: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppShapes.smallRadius),
            child: SizedBox(
              width: 48,
              height: 48,
              child: _buildLeadingImage(context),
            ),
          ),
          if (isSaved)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.accentGreen,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: const Icon(Icons.check_rounded,
                    color: Colors.white, size: 10),
              ),
            ),
          if (isSelected)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: Colors.green.shade600,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 11,
                ),
              ),
            ),
        ],
      ),
      title: Text(
        status.fileNameWithoutExtension,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Row(
        children: [
          Text(DateFormatter.formatRelative(
              status.lastModified, Translations.of(context))),
          const SizedBox(width: 8),
          Text(
            FileUtils.formatFileSize(status.fileSize),
            style: TextStyle(color: AppColors.secondaryText),
          ),
        ],
      ),
      trailing: _buildTrailingIcon(context),
    );
  }

  Widget _buildLeadingImage(BuildContext context) {
    final errorWidget = Container(
      color: Colors.grey[200],
      child: Icon(
        status.mediaType == MediaType.video
            ? Icons.videocam_rounded
            : Icons.image_rounded,
        color: AppColors.secondaryText,
      ),
    );

    switch (status.mediaType) {
      case MediaType.video:
        return FutureBuilder<String?>(
          future: VideoThumbnailService.instance.getThumbnail(status.filePath),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                color: Colors.black87,
                child: const Center(
                  child: Opacity(
                    opacity: 0.5,
                    child: Icon(
                      Icons.play_circle_outline,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              );
            }
            if (snapshot.hasData && snapshot.data != null) {
              return RepaintBoundary(
                child: Image.file(
                  File(snapshot.data!),
                  fit: BoxFit.cover,
                  cacheWidth: AppConstants.listThumbnailSize.toInt(),
                  cacheHeight: AppConstants.listThumbnailSize.toInt(),
                  errorBuilder: (_, __, ___) => errorWidget,
                ),
              );
            }
            return errorWidget;
          },
        );
      case MediaType.unknown:
        return errorWidget;
      case MediaType.image:
        return RepaintBoundary(
          child: Image.file(
            File(status.filePath),
            fit: BoxFit.cover,
            cacheWidth: AppConstants.listThumbnailSize.toInt(),
            cacheHeight: AppConstants.listThumbnailSize.toInt(),
            errorBuilder: (_, __, ___) => errorWidget,
          ),
        );
    }
  }

  Widget? _buildTrailingIcon(BuildContext context) {
    if (status.mediaType == MediaType.video) {
      return const Icon(Icons.play_circle_outline,
          color: AppColors.primaryDark);
    }
    return null;
  }
}
