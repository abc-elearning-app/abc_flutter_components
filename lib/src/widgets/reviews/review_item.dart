import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/widgets/index.dart';
import 'package:flutter_svg/svg.dart';

class ReviewItem extends MainItem {
  final String iconName;

  const ReviewItem({
    super.key,
    required this.iconName,
    required super.onTap,
    required super.title,
    required super.leading,
    required super.subtitle,
    required super.trailing,
  });

  Widget _getImage(String icon) {
    return SvgPicture.asset(
      "assets/$icon.svg",
      width: 16,
      height: 16,
      color: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap.call(),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                    width: 24,
                    height: 24,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: _getImage(iconName))
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              height: 1,
              width: double.infinity,
              color: Theme.of(context).colorScheme.outline,
            ),
            Text(title,
                textAlign: TextAlign.left,
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    ?.copyWith(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
