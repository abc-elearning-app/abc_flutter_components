import 'package:flutter/material.dart';

import '../../../flutter_abc_jsc_components.dart';

class ParagraphWidget extends StatelessWidget {
  final String? paragraph;
  final double? fontSize;

  const ParagraphWidget({super.key, this.paragraph, this.fontSize});

  @override
  Widget build(BuildContext context) {
    if (paragraph == null || paragraph!.isEmpty) {
      return const SizedBox();
    }
    return InkWell(
      onTap: () {
        _showParagraphDialog(context);
      },
      child: Container(
        padding: const EdgeInsets.only(top: 8),
        alignment: Alignment.centerRight,
        child: Text(
          AppStrings.gameStrings.gameSeeMore,
          style: TextStyle(color: const Color(0xFF3478F5), fontSize: fontSize),
        ),
      ),
    );
  }

  void _showParagraphDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              child: MyCustomDialog(
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF383838)
                    : Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0)),
                elevation: 0.1,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  width: MediaQuery.of(context).size.width,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF383838)
                      : null,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                          alignment: const Alignment(1, 0),
                          child: IconButton(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(0.0),
                            icon: Icon(Icons.close,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                                size: 30),
                            onPressed: () => Navigator.of(context).pop(),
                          )),
                      Expanded(
                        flex: 2,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 20),
                            child: TextContent(
                              paragraph!,
                              TextAlign.justify,
                              TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: fontSize,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
