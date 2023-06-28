import 'package:flutter/material.dart';

import '../index.dart';

class FlashCardItem extends MainItem {
  final String name;
  final IconData icon;
  final int mastered;
  final int total;
  final int index;

  const FlashCardItem({
    super.key,
    required this.icon,
    required this.name,
    required super.onTap,
    this.mastered = 0,
    this.total = 0,
    required this.index,
    required super.title,
    required super.leading,
    required super.subtitle,
    required super.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.52),
                spreadRadius: -20,
                blurRadius: 20,
                offset: const Offset(0, 12), // changes position of shadow
              ),
            ]),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Text(name,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 24,
                            fontWeight: FontWeight.w600))),
                Container(
                    width: 24,
                    height: 24,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: Icon(icon, color: Colors.white, size: 16))
              ],
            ),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                height: 1,
                width: double.infinity,
                color: Theme.of(context).colorScheme.shadow),
            Text("Card: ${mastered == 0 ? total : ('$mastered/$total')}",
                textAlign: TextAlign.left,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
