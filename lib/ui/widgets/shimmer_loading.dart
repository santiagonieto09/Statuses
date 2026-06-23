import 'package:flutter/material.dart';
import 'package:statuses/ui/theme/app_theme.dart';

class ShimmerLoading extends StatefulWidget {
  final bool isGrid;

  const ShimmerLoading({super.key, this.isGrid = true});

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (widget.isGrid) {
          return _buildGrid(constraints);
        }
        return _buildList(constraints);
      },
    );
  }

  Widget _buildGrid(BoxConstraints constraints) {
    const double padding = 8;
    const double spacing = 4;
    const int crossAxisCount = 3;
    final double availableWidth = constraints.maxWidth - padding * 2;
    final double cardSize = (availableWidth - spacing * (crossAxisCount - 1)) / crossAxisCount;
    final double rowHeight = cardSize + spacing;
    final double availableHeight = constraints.maxHeight - padding * 2;
    final int rows = (availableHeight / rowHeight).ceil().clamp(4, 12);
    final int itemCount = rows * crossAxisCount;

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(padding),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: 1,
      ),
      itemCount: itemCount,
      itemBuilder: (_, __) => _buildShimmerCard(),
    );
  }

  Widget _buildList(BoxConstraints constraints) {
    const double itemHeight = 72;
    final int itemCount = (constraints.maxHeight / itemHeight).ceil().clamp(6, 20);

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8),
      itemCount: itemCount,
      itemBuilder: (_, __) => _buildShimmerListItem(),
    );
  }

  Widget _buildShimmerCard() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.grey[300]!,
                Colors.grey[100]!,
                Colors.grey[300]!,
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(_animation.value, 0),
              end: Alignment(_animation.value + 1, 0),
            ),
            borderRadius: BorderRadius.circular(AppShapes.smallRadius),
          ),
        );
      },
    );
  }

  Widget _buildShimmerListItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (_, __) {
          return Row(
            children: [
              _shimmerBox(48, 48, AppShapes.smallRadius),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _shimmerBox(14, double.infinity, 4),
                    const SizedBox(height: 6),
                    _shimmerBox(12, 100, 4),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _shimmerBox(double height, double width, double radius) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey[300]!,
            Colors.grey[100]!,
            Colors.grey[300]!,
          ],
          stops: const [0.0, 0.5, 1.0],
          begin: Alignment(_animation.value, 0),
          end: Alignment(_animation.value + 1, 0),
        ),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
