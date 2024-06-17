import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class QuestionCountDialog extends StatefulWidget {
  final bool isDarkMode;
  final Color mainColor;
  final Color secondaryColor;
  final Color backgroundColor;

  final void Function(int questions) onPracticeClick;

  const QuestionCountDialog(
      {super.key,
      required this.isDarkMode,
      this.mainColor = const Color(0xFFE3A651),
      this.secondaryColor = const Color(0xFF7C6F5B),
      this.backgroundColor = const Color(0xFFF5F4EE),
      required this.onPracticeClick});

  @override
  State<QuestionCountDialog> createState() => _QuestionCountDialogState();
}

class _QuestionCountDialogState extends State<QuestionCountDialog> {
  int selectedOption = -1;
  late ValueNotifier<bool> _enablePracticeButton;

  @override
  void initState() {
    _enablePracticeButton = ValueNotifier(false);
    super.initState();
  }

  @override
  void dispose() {
    _enablePracticeButton.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: widget.isDarkMode ? Colors.black : widget.backgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          )),
      padding: const EdgeInsets.only(top: 15),
      width: double.infinity,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: 60,
              height: 5,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFF212121).withOpacity(0.3)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: SizedBox(
                width: 250,
                child: Text(
                  'How Many Questions Do You Want?',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: widget.isDarkMode ? Colors.white : Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            _buildOptions(),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
              child: Row(
                children: [
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: MainButton(
                            borderRadius: 18,
                            title: 'Cancel',
                            textColor: widget.mainColor,
                            textStyle: const TextStyle(fontSize: 18),
                            onPressed: () => Navigator.of(context).pop(),
                            borderSize: BorderSide(
                              width: 1,
                              color: widget.mainColor,
                            ),
                            backgroundColor: Colors.white
                                .withOpacity(widget.isDarkMode ? 0.16 : 1),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ))),
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: ValueListenableBuilder(
                            valueListenable: _enablePracticeButton,
                            builder: (_, value, __) => MainButton(
                              borderRadius: 18,
                              title: 'Practice',
                              disabled: !value,
                              textStyle: const TextStyle(fontSize: 18),
                              onPressed: () => _handlePracticeClick(),
                              backgroundColor: widget.mainColor,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                          ))),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildOptions() => Padding(
        padding: const EdgeInsets.all(10),
        child: StatefulBuilder(
          builder: (_, setState) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
                6,
                (index) => GestureDetector(
                      onTap: () => _updateSelection(index),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: selectedOption == index
                            ? widget.isDarkMode
                                ? widget.mainColor
                                : widget.secondaryColor
                            : widget.isDarkMode
                                ? Colors.white.withOpacity(0.16)
                                : const Color(0xFF212121).withOpacity(0.08),
                        child: Text(
                          '${(index + 1) * 10}',
                          style: TextStyle(
                              color: selectedOption == index
                                  ? Colors.white
                                  : widget.isDarkMode
                                      ? Colors.white
                                      : Colors.black),
                        ),
                      ),
                    )),
          ),
        ),
      );

  _handlePracticeClick() {
    int questionValue = (selectedOption + 1) * 10;
    widget.onPracticeClick(questionValue);
    Navigator.of(context).pop();
  }

  _updateSelection(int index) {
    setState(() => selectedOption = index);
    if (!_enablePracticeButton.value) _enablePracticeButton.value = true;
  }
}
