import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  final int pageCount;
  final int currentPage;
  final Color color;

  final double unselectedSize;
  final double selectedWidth;
  final double selectHeight;

  const PageIndicator({
    super.key,
    required this.pageCount,
    required this.currentPage,
    required this.color,
    this.unselectedSize = 10,
    this.selectedWidth = 32,
    this.selectHeight = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < currentPage; i++) _buildUnselectedDot(),
        _buildSelectedDot(),
        for (int i = 0; i < pageCount - currentPage - 1; i++)
          _buildUnselectedDot()
      ],
    );
  }

  _buildUnselectedDot() => Container(
        height: unselectedSize,
        width: unselectedSize,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1, color: color),
        ),
      );

  _buildSelectedDot() => Container(
        height: selectHeight,
        width: selectedWidth,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: color),
      );
}
