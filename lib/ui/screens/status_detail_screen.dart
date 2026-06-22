import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:statuses/data/models/status_file.dart';
import 'package:statuses/providers/download_notifier.dart';
import 'package:statuses/ui/theme/app_theme.dart';
import 'package:statuses/utils/date_formatter.dart';
import 'package:statuses/utils/file_utils.dart';

class StatusDetailScreen extends StatefulWidget {
  final StatusFile status;

  const StatusDetailScreen({super.key, required this.status});

  @override
  State<StatusDetailScreen> createState() => _StatusDetailScreenState();
}

class _StatusDetailScreenState extends State<StatusDetailScreen> {
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.status.mediaType == MediaType.video) {
      _initVideo();
    }
  }

  Future<void> _initVideo() async {
    final file = File(widget.status.filePath);
    if (!await file.exists()) return;

    _videoController = VideoPlayerController.file(file);
    await _videoController!.initialize();
    if (mounted) {
      setState(() => _isVideoInitialized = true);
      _videoController!.play();
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        title: Text(
          widget.status.fileNameWithoutExtension,
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) => _handleMenuAction(value, context),
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'download', child: Text('Download')),
              const PopupMenuItem(value: 'share', child: Text('Share')),
              const PopupMenuItem(value: 'info', child: Text('Info')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _buildMediaViewer(context)),
          _buildBottomBar(context),
        ],
      ),
    );
  }

  Widget _buildMediaViewer(BuildContext context) {
    final file = File(widget.status.filePath);
    if (!file.existsSync()) {
      return const Center(
        child: Text('File not found', style: TextStyle(color: Colors.white)),
      );
    }

    switch (widget.status.mediaType) {
      case MediaType.image:
        return InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: Center(
            child: Image.file(
              file,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Center(
                child: Text('Unable to load image',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        );
      case MediaType.video:
        if (!_isVideoInitialized) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.white54),
                SizedBox(height: 16),
                Text('Loading video...',
                    style: TextStyle(color: Colors.white70)),
              ],
            ),
          );
        }
        return Center(
          child: GestureDetector(
            onTap: () {
              if (_videoController!.value.isPlaying) {
                _videoController!.pause();
              } else {
                _videoController!.play();
              }
              setState(() {});
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                  aspectRatio: _videoController!.value.aspectRatio,
                  child: VideoPlayer(_videoController!),
                ),
                if (!_videoController!.value.isPlaying)
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
              ],
            ),
          ),
        );
      case MediaType.audio:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.primaryDark.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.audiotrack_rounded,
                  size: 50,
                  color: AppColors.primaryDark,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.status.fileNameWithoutExtension,
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        );
      default:
        return const Center(
          child: Text('Unsupported file type',
              style: TextStyle(color: Colors.white)),
        );
    }
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      color: Colors.black87,
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActionButton(
            icon: Icons.download_rounded,
            label: 'Download',
            onTap: () => _handleMenuAction('download', context),
          ),
          _buildActionButton(
            icon: Icons.share_rounded,
            label: 'Share',
            onTap: () => _handleMenuAction('share', context),
          ),
          _buildActionButton(
            icon: Icons.info_outline_rounded,
            label: 'Info',
            onTap: () => _handleMenuAction('info', context),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white70, size: 24),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 11)),
        ],
      ),
    );
  }

  Future<void> _handleMenuAction(String value, BuildContext context) async {
    switch (value) {
      case 'download':
        {
          final notifier = context.read<DownloadNotifier>();
          await notifier.downloadStatus(widget.status);
          if (context.mounted) {
            final success = notifier.error == null;
            final msg = success
                ? '\u2713 Guardado en Pictures/Statuses'
                : notifier.error!;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(msg),
                backgroundColor: success ? Colors.green[700] : Colors.red[700],
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 3),
              ),
            );
          }
          break;
        }
      case 'share':
        {
          final notifier = context.read<DownloadNotifier>();
          await notifier.shareStatus(widget.status);
          break;
        }
      case 'info':
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('File Info'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ${widget.status.fileName}'),
                  const SizedBox(height: 4),
                  Text(
                      'Size: ${FileUtils.formatFileSize(widget.status.fileSize)}'),
                  const SizedBox(height: 4),
                  Text('Type: ${widget.status.mediaType.name}'),
                  const SizedBox(height: 4),
                  Text(
                      'Date: ${DateFormatter.formatDateTime(widget.status.lastModified)}'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ],
            ),
          );
        }
    }
  }
}
