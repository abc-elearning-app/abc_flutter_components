import 'package:flutter/material.dart';

class StarDisplayWidget extends StatelessWidget {
  final int value;
  final Widget filledStar;
  final Widget unfilledStar;

  const StarDisplayWidget({
    super.key,
    this.value = 0,
    required this.filledStar,
    required this.unfilledStar,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return index < value ? filledStar : unfilledStar;
      }),
    );
  }
}

class StarDisplay extends StarDisplayWidget {
  const StarDisplay({
    super.key,
    super.value = 0,
    super.filledStar = const Icon(Icons.star),
    super.unfilledStar = const Icon(Icons.star_border),
  });
}

class StarRating extends StatelessWidget {
  final void Function(int index) onChanged;
  final int value;
  final int max;
  final IconData? filledStar;
  final Widget? filledStarIcon;
  final IconData? unfilledStar;
  final Widget? unfilledStarIcon;

  const StarRating({
    super.key,
    required this.onChanged,
    this.value = 0,
    this.filledStar,
    this.unfilledStar,
    this.max = 5,
    this.filledStarIcon,
    this.unfilledStarIcon,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.secondary;
    const size = 36.0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(max, (index) {
        return IconButton(
          onPressed: () {
            onChanged(value == index + 1 ? index : index + 1);
          },
          color: index < value ? color : null,
          iconSize: size,
          icon: _makeIcon(index),
          padding: EdgeInsets.zero,
          tooltip: "${index + 1} of 5",
        );
      }),
    );
  }

  Widget _makeIcon(int index) {
    if (filledStarIcon != null && index < value) {
      return filledStarIcon!;
    }
    if (unfilledStarIcon != null && index >= value) {
      return unfilledStarIcon!;
    }
    return Icon(
      index < value
          ? (filledStar ?? Icons.star)
          : (unfilledStar ?? Icons.star_border),
    );
  }
}
