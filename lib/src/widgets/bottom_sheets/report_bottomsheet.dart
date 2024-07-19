import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class FeedbackData {
  // TODO: Need id ?
  final String title;
  bool isSelected;

  FeedbackData(this.title, {this.isSelected = false});
}

class ReportPopupComponent extends StatefulWidget {
  final String? title;
  final List<String> options;
  final String buttonTitle;

  final bool isDarkMode;
  final Color mainColor;
  final Color secondaryColor;
  final Color backgroundColor;

  final bool showHandle;

  final void Function(List<FeedbackData> mistakeData, String reason) onClick;

  const ReportPopupComponent({
    super.key,
    this.mainColor = const Color(0xFFE3A651),
    this.secondaryColor = const Color(0xFF7C6F5B),
    this.backgroundColor = const Color(0xFFF5F4EE),
    this.title,
    this.showHandle = true,
    this.buttonTitle = 'Submit',
    required this.isDarkMode,
    required this.onClick,
    required this.options,
  });

  @override
  State<ReportPopupComponent> createState() => _ReportPopupComponentState();
}

class _ReportPopupComponentState extends State<ReportPopupComponent> {
  late ValueNotifier<bool> _enableButton;
  late ValueNotifier<bool> _otherReasonSelected;
  late TextEditingController _textEditingController;

  late List<FeedbackData> options;

  @override
  void initState() {
    _enableButton = ValueNotifier(false);
    _textEditingController = TextEditingController();
    _otherReasonSelected = ValueNotifier(false);

    options = widget.options.map((option) => FeedbackData(option)).toList();
    options.add(FeedbackData('Other'));

    super.initState();
  }

  @override
  void dispose() {
    _enableButton.dispose();
    _otherReasonSelected.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
            color: widget.isDarkMode ? Colors.black : widget.backgroundColor,
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.showHandle)
                  Container(
                    width: 60,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                        color: widget.isDarkMode ? Colors.white : Colors.black,
                        borderRadius: BorderRadius.circular(100)),
                  ),

                if (widget.title != null)
                  Text(widget.title!,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color:
                              widget.isDarkMode ? Colors.white : Colors.black)),

                // List of options
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: options.length,
                    itemBuilder: (_, index) =>
                        _optionRow(options[index], index)),

                _reasonTextField(),

                _submitButton()
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _optionRow(FeedbackData mistakeData, int index) => StatefulBuilder(
        builder: (_, setState) => GestureDetector(
          onTap: () => setState(() => _updateSelection(index)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                MyCheckBox(
                  activeColor: widget.mainColor,
                  fillColor: widget.isDarkMode
                      ? Colors.white.withOpacity(0.08)
                      : Colors.white,
                  borderColor: widget.isDarkMode
                      ? Colors.white.withOpacity(0.16)
                      : widget.mainColor,
                  iconColor: Colors.white,
                  value: mistakeData.isSelected,
                  onChanged: (_) => setState(() => _updateSelection(index)),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    mistakeData.title,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: widget.isDarkMode ? Colors.white : Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _reasonTextField() {
    return ValueListenableBuilder(
      valueListenable: _otherReasonSelected,
      builder: (_, value, __) {
        final underlineDecoration = UnderlineInputBorder(
            borderSide: BorderSide(
                width: 1,
                color: widget.isDarkMode
                    ? Colors.white.withOpacity(0.24)
                    : Colors.black));
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: value ? 50 : 0,
          child: value
              ? TextField(
                  controller: _textEditingController,
                  onChanged: (_) => _checkEnableButton.call(),
                  decoration: InputDecoration(
                    hintText: 'Other reasons',
                    enabledBorder: value ? underlineDecoration : null,
                    focusedBorder: value ? underlineDecoration : null,
                    hintStyle: TextStyle(
                        fontSize: 16,
                        color: (widget.isDarkMode ? Colors.white : Colors.black)
                            .withOpacity(0.24)),
                  ),
                )
              : const SizedBox.shrink(),
        );
      },
    );
  }

  Widget _submitButton() => Container(
      margin: const EdgeInsets.only(top: 20),
      width: double.infinity,
      child: ValueListenableBuilder(
          valueListenable: _enableButton,
          builder: (_, value, __) => MainButton(
              borderRadius: 12,
              title: widget.buttonTitle,
              backgroundColor: widget.mainColor,
              disabledColor: Color.lerp(widget.mainColor, Colors.black, 0.5),
              disabled: !value,
              textColor: !value ? Colors.grey : Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              onPressed: _onSubmit)));

  _onSubmit() {
    widget.onClick(options.where((option) => option.isSelected).toList(),
        _textEditingController.text);
    Navigator.of(context).pop();
  }

  _updateSelection(int index) {
    // Update option status
    options[index].isSelected = !options[index].isSelected;

    // Check the other reason text field
    _otherReasonSelected.value = options.last.isSelected;
    if (!_otherReasonSelected.value) _textEditingController.clear();

    _checkEnableButton();
  }

  _checkEnableButton() => _enableButton.value =
      !((options.last.isSelected && _textEditingController.text.isEmpty) ||
          options.where((option) => option.isSelected).isEmpty);
}
