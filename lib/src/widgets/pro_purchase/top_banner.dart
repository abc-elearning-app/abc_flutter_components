import 'package:flutter/material.dart';

class TopBannerComponent extends StatelessWidget {
  final String background;
  final bool isDarkMode;
  final Color secondaryColor;
  final void Function() onRestore;

  const TopBannerComponent({
    super.key,
    required this.background,
    required this.onRestore,
    required this.isDarkMode,
    required this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
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
                icon: Icon(
                  Icons.close,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                onPressed: () => Navigator.of(context).pop()),
            TextButton(
                onPressed: onRestore,
                style: TextButton.styleFrom(foregroundColor: secondaryColor),
                child: Text('Restore',
                    style: TextStyle(
                      fontSize: 18,
                      color: isDarkMode ? Colors.white : Colors.black,
                    )))
          ],
        ),
      ),
    );
  }
}
