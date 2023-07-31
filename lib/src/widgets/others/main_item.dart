import 'package:flutter/material.dart';

class MainItem extends StatelessWidget {
  final String title;
  final Function onTap;
  final Widget leading;
  final Widget trailing;
  final Widget subtitle;

  const MainItem({
    super.key,
    required this.title,
    required this.onTap,
    required this.leading,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return makeContent(context,
        title: title,
        leading: leading,
        onTap: onTap,
        subtitle: subtitle,
        trailing: trailing);
  }

  Widget makeContent(BuildContext context,
      {required final String title,
      required final Function onTap,
      required final Widget leading,
      required final Widget trailing,
      required final Widget subtitle}) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: () => onTap(),
        contentPadding: const EdgeInsets.all(18),
        leading: leading,
        title: Text(title,
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontSize: 16, fontWeight: FontWeight.w600)),
        subtitle: subtitle,
        trailing: trailing,
      ),
    );
  }
}
