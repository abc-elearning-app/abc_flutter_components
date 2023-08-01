import 'package:flutter/material.dart';
import 'dart:typed_data';

import 'package:flutter_abc_jsc_components/src/constants/app_strings.dart';
import 'package:flutter_abc_jsc_components/src/widgets/buttons/raised_button.dart';

class ReportMistakeOverlay extends ModalRoute<void> {
  String questionId;
  Uint8List screenshotBytes;
  Function report;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  ReportMistakeOverlay(this.questionId, this.screenshotBytes, this.report);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    // This makes sure that text and other content follows the material style
    return Material(
      // type: MaterialType.transparency,
      color: Colors.blueGrey,
      child: SafeArea(
        child: DialogContent(
            onReport: report,
            questionId: questionId,
            screenshotBytes: screenshotBytes),
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}

class DialogContent extends StatefulWidget {
  final String questionId;
  final Uint8List screenshotBytes;
  final Function onReport;

  const DialogContent({
    super.key,
    required this.onReport,
    required this.questionId,
    required this.screenshotBytes,
  });

  @override
  State<DialogContent> createState() => _DialogContentState();
}

class _DialogContentState extends State<DialogContent> {
  bool isMistake = false;
  bool isDifficult = false;
  bool isOther = false;
  bool isSelected = false;
  int reason = -1;
  final TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Widget getBody = isSelected == false
        ? Card(
            elevation: 1,
            child: Column(
              children: <Widget>[
                CheckboxListTile(
                  value: isMistake,
                  onChanged: (_) {
                    onCheckBoxChange(1);
                  },
                  title: Text(
                    AppStrings.reportMistakeStrings.thereIsAMistake,
                    style: const TextStyle(color: Colors.black87),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const Divider(),
                CheckboxListTile(
                  value: isDifficult,
                  onChanged: (_) {
                    onCheckBoxChange(2);
                  },
                  title: Text(AppStrings.reportMistakeStrings.itTooDifficult,
                      style: const TextStyle(color: Colors.black87)),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const Divider(),
                CheckboxListTile(
                  value: isOther,
                  onChanged: (_) {
                    onCheckBoxChange(3);
                  },
                  title: Text(AppStrings.reportMistakeStrings.other,
                      style: const TextStyle(color: Colors.black87)),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ],
            ),
          )
        : Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: TextField(
              controller: _textFieldController,
              maxLines: 8,
              textInputAction: TextInputAction.done,
              style: const TextStyle(fontSize: 15.0, color: Colors.black87),
              decoration: InputDecoration(
                hintText: AppStrings.reportMistakeStrings.explainIssue,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: const BorderSide(
                    color: Colors.white,
                  ),
                ),
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          );

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            margin:
                const EdgeInsets.only(top: 5, bottom: 5, left: 16, right: 16),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(16),
                  alignment: const Alignment(1, 0),
                  child: SizedBox(
                    height: 24.0,
                    width: 24.0,
                    child: IconButton(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.all(0.0),
                      icon: const Icon(Icons.close,
                          size: 32, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: Container(
                      alignment: const Alignment(0, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Text(
                                  AppStrings.reportMistakeStrings.reportMistake,
                                  style: const TextStyle(
                                      fontSize: 25, color: Colors.white),
                                ),
                              ),
                              getBody
                            ],
                          ),
                          ButtonTheme(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            minWidth: double.infinity,
                            height: 50,
                            child: RaisedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                if (reason > 0) {
                                  widget.onReport(
                                      reason, _textFieldController.text);
                                }
                              },
                              textColor: Colors.white,
                              color:
                                  isSelected ? Colors.green : Colors.grey[400],
                              child: Text(
                                AppStrings.reportMistakeStrings.report,
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
              ],
            ),
          )),
    );
  }

  void onCheckBoxChange(int option) {
    reason = option;
    if (option == 1) {
      setState(() {
        isMistake = true;
        isSelected = true;
      });
    } else if (option == 2) {
      setState(() {
        isDifficult = true;
        isSelected = true;
      });
    } else if (option == 3) {
      setState(() {
        isOther = true;
        isSelected = true;
      });
    }
  }
}
