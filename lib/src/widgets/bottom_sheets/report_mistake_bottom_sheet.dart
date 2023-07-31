import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:flutter_svg/svg.dart';

class ReportMistakeBottomSheet extends StatefulWidget {
  final int questionId;
  final VoidCallback notShowAdFunc;
  final void Function() onClose;
  final void Function(List<int> reason, String details, int ratingScore)
      onReport;

  const ReportMistakeBottomSheet({
    super.key,
    required this.onReport,
    required this.onClose,
    required this.questionId,
    required this.notShowAdFunc,
  });

  @override
  State<ReportMistakeBottomSheet> createState() =>
      _ReportMistakeBottomSheetState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        ObjectFlagProperty<VoidCallback>.has('notShowAdFunc', notShowAdFunc));
  }
}

class ReportQuestionItem {
  int id;
  String name;

  ReportQuestionItem(this.id, this.name);
}

List<ReportQuestionItem> get reportMistakeDataItems => [
      ReportQuestionItem(1, "There's a mistake"),
      ReportQuestionItem(2, "It's too difficult"),
      ReportQuestionItem(3, "Misunderstood explanation"),
      // ReportQuestionItem(3, "Other"),
    ];

class _ReportMistakeBottomSheetState extends State<ReportMistakeBottomSheet> {
  List<int> selectedIds = [];
  bool showSuccess = false;
  int ratingScore = -1;
  final TextEditingController _textFieldController = TextEditingController();

  void _onSelected(int value) {
    setState(() {
      if (selectedIds.contains(value)) {
        selectedIds.remove(value);
      } else {
        selectedIds.add(value);
      }
    });
  }

  bool get _isDarkMode =>
      Theme.of(context).colorScheme.brightness == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    EdgeInsets padding = MediaQuery.of(context).viewInsets;
    return Padding(
      padding: padding,
      child: Column(
        children: [
          Expanded(
              child: InkWell(
            onTap: widget.onClose,
            child: Container(),
          )),
          InkWell(
            onTap: widget.onClose,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                  "assets/static/icons/arrow_down_bottom_sheet.svg",
                  width: 55,
                  color: Colors.white),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: _isDarkMode ? const Color(0xFF383838) : Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return SlideTransition(
                    position: Tween<Offset>(
                            begin: const Offset(2, 0.0),
                            end: const Offset(0.0, 0.0))
                        .animate(animation),
                    child: child,
                  );
                },
                child: showSuccess ? _makeSuccess() : _makeContent(padding)),
          ),
        ],
      ),
    );
  }

  Widget _makeSuccess() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text("Report sent!",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 24,
                  fontWeight: FontWeight.w600)),
        ),
        const SizedBox(height: 40),
        const ReportMistakeIcon(
          width: 220,
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text("Thank you for helping us improve the question quality",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: _isDarkMode ? Colors.white : const Color(0xFF4D4D4D),
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
        ),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _makeContent(EdgeInsets padding) {
    return Container(
      constraints: BoxConstraints(maxHeight: padding.bottom > 200 ? 350 : 1000),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text("How do you rate this quiz?",
                style: TextStyle(
                    color: _isDarkMode ? Colors.white : const Color(0xFF383838),
                    fontSize: 18,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 16),
            RatingQuestionWidget(
              onChange: (value) {
                setState(() {
                  ratingScore = value;
                });
                FirebaseCallbacks.logEvent("rating_question", parameters: {
                  "questionId": widget.questionId,
                  "ratingScore": value
                });
              },
              isDarkMode: _isDarkMode,
            ),
            Container(
              width: double.infinity,
              height: 1,
              color: const Color(0xFFE3E3E3),
              margin: const EdgeInsets.only(bottom: 16),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text("Why this score?",
                  style: TextStyle(
                      color:
                          _isDarkMode ? Colors.white : const Color(0xFF383838),
                      fontSize: 18,
                      fontWeight: FontWeight.w500)),
            ),
            if (ratingScore < 8) const SizedBox(height: 8),
            if (ratingScore < 8)
              Column(
                children: reportMistakeDataItems.map((item) {
                  bool sel = selectedIds.contains(item.id);
                  return InkWell(
                    onTap: () => _onSelected(item.id),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item.name,
                              style: TextStyle(
                                  color: _isDarkMode
                                      ? Colors.white
                                      : const Color(0xFF383838),
                                  fontSize: 16)),
                          MyCheckBox(
                            onChanged: (value) => _onSelected(item.id),
                            value: sel,
                            activeColor: _isDarkMode
                                ? Colors.white
                                : const Color(0xFF383838),
                            checkColor: _isDarkMode
                                ? Colors.white
                                : const Color(0xFF383838),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            const SizedBox(height: 12),
            TextField(
              controller: _textFieldController,
              textInputAction: TextInputAction.done,
              style: TextStyle(
                  fontSize: 15.0,
                  color: _isDarkMode ? Colors.white : Colors.black87),
              decoration: InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: _isDarkMode ? Colors.white : Colors.grey.shade400,
                    ),
                  ),
                  hintText: "Additional information",
                  hintStyle: TextStyle(
                      color:
                          _isDarkMode ? Colors.white : const Color(0xFFB8B8B8),
                      fontWeight: FontWeight.w500),
                  fillColor: _isDarkMode ? Colors.transparent : Colors.white,
                  filled: true,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: _isDarkMode ? Colors.white : Colors.grey.shade400,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: _isDarkMode ? Colors.white : Colors.black))),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: MainButton(
                padding: const EdgeInsets.all(10),
                title: "Send",
                textColor: _isDarkMode ? Colors.white : const Color(0xFF3E3E40),
                backgroundColor:
                    _isDarkMode ? Colors.transparent : Colors.white,
                borderSize: BorderSide(
                    color: _isDarkMode ? Colors.white : Colors.grey.shade300,
                    width: 1),
                onPressed: () {
                  String? value = _textFieldController.value.text;
                  if (selectedIds.isEmpty &&
                      ratingScore == -1 &&
                      (value.isEmpty)) {
                    ABCToaster.showToast(
                      context: context,
                      msg: "Enter information for your report!",
                      type: ABCToasterType.failed,
                    );
                    // showToastError("Select a mistake!");
                    return;
                  }
                  widget.notShowAdFunc.call();
                  widget.onReport(selectedIds, _textFieldController.value.text,
                      ratingScore);
                  FocusManager.instance.primaryFocus?.unfocus();
                  Future.delayed(const Duration(milliseconds: 200))
                      .whenComplete(() => setState(() => showSuccess = true));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
