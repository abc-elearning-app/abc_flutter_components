import 'package:flutter/material.dart';

class QuestionActionsWidget extends StatelessWidget {
  final bool bookmark;
  final VoidCallback onFavorite;
  final VoidCallback onReport;

  const QuestionActionsWidget({
    super.key,
    required this.bookmark,
    required this.onFavorite,
    required this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onFavorite,
          child: Icon(
              bookmark ? Icons.favorite : Icons.favorite_border_outlined,
              size: 24,
              color:
                  bookmark ? const Color(0xFFFF4B4B) : const Color(0xFFDADADA)),
        ),
        const SizedBox(
          width: 10,
        ),
        InkWell(
          onTap: onReport,
          child: Icon(Icons.flag_outlined,
              size: 24,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black),
        ),
      ],
    );
  }
}
