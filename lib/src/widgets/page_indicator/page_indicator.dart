import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  final int pageCount;
  final int currentPage;
  final Color color;

  const PageIndicator({
    super.key,
    required this.pageCount,
    required this.currentPage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < currentPage; i++) _buildUnselectedDot(),

        _buildSelectedDot(),

        for (int i = 0; i < pageCount - currentPage - 1; i++)
          _buildUnselectedDot()
      ],
    );
  }

  _buildUnselectedDot() => Container(
    height: 10,
    width: 10,
    margin: const EdgeInsets.symmetric(horizontal: 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(width: 1, color: color),
    ),
  );

  _buildSelectedDot() => Container(
    height: 12,
    width: 32,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), color: color),
  );
}
