import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:statuses/data/models/status_file.dart';
import 'package:statuses/providers/download_notifier.dart';
import 'package:statuses/utils/date_formatter.dart';
import 'package:statuses/utils/file_utils.dart';

class StatusDetailScreen extends StatefulWidget {
  final List<StatusFile> statuses;
  final int initialIndex;

  const StatusDetailScreen({
    super.key,
    required this.statuses,
    required this.initialIndex,
  });

  @override
  State<StatusDetailScreen> createState() => _StatusDetailScreenState();
}

class _StatusDetailScreenState extends State<StatusDetailScreen> {
  late final PageController _pageController;
  late int _currentIndex;
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;

  StatusFile get _current => widget.statuses[_currentIndex];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    _tryInitVideo(_currentIndex);
  }

  Future<void> _tryInitVideo(int index) async {
    final status = widget.statuses[index];
    if (status.mediaType != MediaType.video) return;
    final file = File(status.filePath);
    if (!await file.exists()) return;
    final controller = VideoPlayerController.file(file);
    await controller.initialize();
    if (!mounted) {
      controller.dispose();
      return;
    }
    final old = _videoController;
    setState(() {
      _videoController = controller;
      _isVideoInitialized = true;
    });
    controller.play();
    old?.dispose();
  }

  void _onPageChanged(int index) {
    _videoController?.pause();
    final old = _videoController;
    setState(() {
      _currentIndex = index;
      _videoController = null;
      _isVideoInitialized = false;
    });
    old?.dispose();
    _tryInitVideo(index);
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showSubtitle = widget.statuses.length > 1;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _current.fileNameWithoutExtension,
              style: const TextStyle(fontSize: 14),
            ),
            if (showSubtitle)
              Text(
                '${_currentIndex + 1} / ${widget.statuses.length}',
                style: const TextStyle(fontSize: 11, color: Colors.white54),
              ),
          ],
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
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: widget.statuses.length,
              itemBuilder: (context, index) => _buildPage(
                context,
                widget.statuses[index],
                index == _currentIndex,
              ),
            ),
          ),
          _buildBottomBar(context),
        ],
      ),
    );
  }

  Widget _buildPage(BuildContext context, StatusFile status, bool isActive) {
    final file = File(status.filePath);
    if (!file.existsSync()) {
      return const Center(
        child: Text('File not found', style: TextStyle(color: Colors.white)),
      );
    }

    switch (status.mediaType) {
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
        if (!isActive || !_isVideoInitialized || _videoController == null) {
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
          await notifier.downloadStatus(_current);
          if (context.mounted) {
            final success = notifier.error == null;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(
                      success
                          ? Icons.check_circle_rounded
                          : Icons.error_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        success
                            ? 'Archivo guardado correctamente'
                            : notifier.error!,
                      ),
                    ),
                  ],
                ),
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
          await notifier.shareStatus(_current);
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
                  Text('Name: ${_current.fileName}'),
                  const SizedBox(height: 4),
                  Text('Size: ${FileUtils.formatFileSize(_current.fileSize)}'),
                  const SizedBox(height: 4),
                  Text('Type: ${_current.mediaType.name}'),
                  const SizedBox(height: 4),
                  Text(
                      'Date: ${DateFormatter.formatDateTime(_current.lastModified)}'),
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
