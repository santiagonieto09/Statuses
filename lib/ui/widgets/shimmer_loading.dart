import 'package:flutter/material.dart';

class ShimmerLoading extends StatefulWidget {
  final int itemCount;
  final double? separator;
  final bool showAppBar;
  final bool isGrid;
  final int shimmerColumns;

  const ShimmerLoading({
    super.key,
    this.itemCount = 6,
    this.separator,
    this.showAppBar = false,
    this.isGrid = true,
    this.shimmerColumns = 3,
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  int _buildCount = 0;

  @override
  void initState() {
    super.initState();
    final sw = Stopwatch()..start();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
    sw.stop();
    if (sw.elapsedMicroseconds > 200) {
      debugPrint('[PERF] ShimmerLoading initState: ${sw.elapsedMicroseconds}us');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _buildCount++;
    final buildSw = Stopwatch()..start();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final shimmerColor = isDark ? Colors.grey[700]! : Colors.grey[200]!;
    final separator = widget.separator ?? 4.0;

    final shimmerHeight = (MediaQuery.of(context).size.width - 32 - (widget.shimmerColumns - 1) * separator) /
        widget.shimmerColumns;

    final shimmerWidget = AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return _ShimmerMask(
          animation: _animation,
          baseColor: baseColor,
          shimmerColor: shimmerColor,
          child: child!,
        );
      },
      child: widget.showAppBar
          ? Column(
              children: [
                _buildAppBarShimmer(baseColor, shimmerColor),
                const SizedBox(height: 8),
                Expanded(
                  child: _buildGrid(shimmerHeight, separator),
                ),
              ],
            )
          : _buildGrid(shimmerHeight, separator),
    );

    buildSw.stop();
    if (buildSw.elapsedMilliseconds > 3) {
      debugPrint('[PERF] ShimmerLoading.build #$_buildCount: ${buildSw.elapsedMilliseconds}ms (${widget.itemCount} items)');
    }
    return shimmerWidget;
  }

  Widget _buildAppBarShimmer(Color baseColor, Color shimmerColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildShimmerBlock(width: 120, height: 16, baseColor: baseColor, shimmerColor: shimmerColor),
          const SizedBox(height: 8),
          _buildShimmerBlock(width: double.infinity, height: 14, baseColor: baseColor, shimmerColor: shimmerColor),
        ],
      ),
    );
  }

  Widget _buildGrid(double shimmerHeight, double separator) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.shimmerColumns,
        crossAxisSpacing: separator,
        mainAxisSpacing: separator,
        childAspectRatio: 9.0 / 16.0,
      ),
      itemCount: widget.itemCount,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[300],
          ),
        );
      },
    );
  }

  Widget _buildShimmerBlock({
    required double width,
    required double height,
    required Color baseColor,
    required Color shimmerColor,
  }) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return _ShimmerMask(
          animation: _animation,
          baseColor: baseColor,
          shimmerColor: shimmerColor,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: baseColor,
            ),
          ),
        );
      },
    );
  }
}

class _ShimmerMask extends StatelessWidget {
  final Animation<double> animation;
  final Color baseColor;
  final Color shimmerColor;
  final Widget child;

  const _ShimmerMask({
    required this.animation,
    required this.baseColor,
    required this.shimmerColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            baseColor,
            baseColor,
            shimmerColor,
            baseColor,
            baseColor,
          ],
          stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
          transform: _SlideTransform(animation.value),
        ).createShader(bounds);
      },
      blendMode: BlendMode.srcATop,
      child: child,
    );
  }
}

class _SlideTransform extends GradientTransform {
  final double value;

  const _SlideTransform(this.value);

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * value, 0, 0);
  }
}
