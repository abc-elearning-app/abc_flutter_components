import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TopBanner extends StatelessWidget {
  final String background;
  final void Function() onRestore;
  final bool isDarkMode;

  const TopBanner({
    super.key,
    required this.background,
    required this.onRestore,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 50),
        Container(
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
        ),
      ],
    );
  }
}
