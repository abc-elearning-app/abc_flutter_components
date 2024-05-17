import 'package:flutter/material.dart';

class TopBanner extends StatelessWidget {
  final String background;
  final Color textColor;
  final void Function() onRestore;

  const TopBanner({
    super.key,
    required this.background,
    required this.onRestore,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage(background),
        fit: BoxFit.fill,
      )),
      child: Align(
        alignment: Alignment.topCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                icon: Icon(Icons.close, color: textColor),
                onPressed: () => Navigator.of(context).pop()),
            TextButton(
                onPressed: onRestore,
                child: Text('Restore',
                    style: TextStyle(fontSize: 18, color: textColor)))
          ],
        ),
      ),
    );
  }
}
