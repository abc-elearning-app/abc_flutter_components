import 'package:flutter/material.dart';

class TopBannerComponent extends StatelessWidget {
  final String background;
  final bool isDarkMode;
  final Color secondaryColor;
  final bool loading;
  final void Function() onRestore;

  const TopBannerComponent({
    super.key,
    required this.background,
    required this.onRestore,
    required this.isDarkMode,
    required this.secondaryColor,
    required this.loading,
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
            loading
                ? Container(
                    margin: const EdgeInsets.only(right: 20),
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(color: isDarkMode ? Colors.white : Colors.black))
                : TextButton(
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
