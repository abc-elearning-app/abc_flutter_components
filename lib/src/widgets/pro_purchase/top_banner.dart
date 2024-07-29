import 'package:flutter/material.dart';

class TopBannerComponent extends StatelessWidget {
  final String background;
  final void Function() onRestore;
  final bool isDarkMode;

  const TopBannerComponent({
    super.key,
    required this.background,
    required this.onRestore,
    required this.isDarkMode,
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
