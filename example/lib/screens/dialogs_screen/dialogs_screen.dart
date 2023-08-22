import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class DialogsScreen extends StatelessWidget {
  const DialogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            MainButton(
              title: "Custom Dialog",
              onPressed: () async => await showDialogContent(
                context: context,
                title: "Custom Dialog",
                content: const SizedBox(
                  height: 300,
                  width: 150,
                ),
              ),
            ),
            MainButton(
              title: "My Custom Dialog",
              onPressed: () async => _showParagraphDialog(context),
            ),
            MainButton(
              title: "Unlocked Part Dialog",
              onPressed: () async =>
                  showUnlockedPartDialog(context: context, onNext: () {}),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showParagraphDialog(BuildContext context) async {
    await showDialog(
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
                              "Paragraph Content",
                              TextAlign.justify,
                              TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 13,
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
