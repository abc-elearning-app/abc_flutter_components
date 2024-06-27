import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MistakeData {
  final String title;
  bool isSelected;

  MistakeData(this.title, {this.isSelected = false});
}

class ReportMistakePopup extends StatefulWidget {
  final bool isDarkMode;
  final Color mainColor;
  final Color secondaryColor;
  final void Function(List<MistakeData> mistakeData, String otherReasons)
      onClick;

  const ReportMistakePopup({
    super.key,
    required this.isDarkMode,
    this.mainColor = const Color(0xFFE3A651),
    this.secondaryColor = const Color(0xFF7C6F5B),
    required this.onClick,
  });

  @override
  State<ReportMistakePopup> createState() => _ReportMistakePopupState();
}

class _ReportMistakePopupState extends State<ReportMistakePopup> {
  late ValueNotifier<bool> _enableButton;
  late TextEditingController _textEditingController;

  final mistakeList = <MistakeData>[
    MistakeData('Incorrect Answer'),
    MistakeData('Wrong Explanation'),
    MistakeData('Grammatical Error'),
    MistakeData('Missing Content'),
    MistakeData('Typo'),
    MistakeData('Bad Image Quality'),
  ];

  @override
  void initState() {
    _enableButton = ValueNotifier(false);
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _enableButton.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset('assets/images/popup_dropdown.svg'),
        Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
            color: widget.isDarkMode ? Colors.black : Colors.white,
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Report A Mistake',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color:
                            widget.isDarkMode ? Colors.white : Colors.black)),

                // List of mistakes
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(top: 10),
                    itemCount: mistakeList.length,
                    itemBuilder: (_, index) =>
                        _mistakeRow(mistakeList[index], index)),

                _reasonTextField(),

                _reportButton()
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _mistakeRow(MistakeData mistakeData, int index) => StatefulBuilder(
        builder: (_, setState) => ListTile(
          contentPadding: EdgeInsets.zero,
          onTap: () => setState(() => _updateSelection(index)),
          leading: Text(
            mistakeData.title,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: widget.isDarkMode ? Colors.white : Colors.black),
          ),
          trailing: Transform.scale(
            scale: 1.1,
            child: MyCheckBox(
              activeColor:
                  widget.isDarkMode ? widget.mainColor : widget.secondaryColor,
              fillColor: widget.isDarkMode
                  ? Colors.white.withOpacity(0.08)
                  : Colors.white,
              borderColor: widget.isDarkMode
                  ? Colors.white.withOpacity(0.16)
                  : widget.secondaryColor,
              iconColor: Colors.white,
              value: mistakeData.isSelected,
              onChanged: (_) => setState(() => _updateSelection(index)),
            ),
          ),
        ),
      );

  Widget _reasonTextField() {
    final underlineDecoration = UnderlineInputBorder(
        borderSide: BorderSide(
            width: 1,
            color: widget.isDarkMode
                ? Colors.white.withOpacity(0.24)
                : Colors.black));

    return TextField(
      controller: _textEditingController,
      onChanged: (_) => _checkEnableButton.call(),
      decoration: InputDecoration(
        hintText: 'Other reasons',
        enabledBorder: underlineDecoration,
        focusedBorder: underlineDecoration,
        hintStyle: TextStyle(
            color: (widget.isDarkMode ? Colors.white : Colors.black)
                .withOpacity(0.24)),
      ),
    );
  }

  Widget _reportButton() => Container(
      margin: const EdgeInsets.only(top: 30),
      width: double.infinity,
      child: ValueListenableBuilder(
          valueListenable: _enableButton,
          builder: (_, value, __) => MainButton(
              title: 'Report',
              backgroundColor: widget.mainColor,
              disabledColor: Color.lerp(widget.mainColor, Colors.black, 0.5),
              disabled: !value,
              disabledTextColor: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 12),
              textStyle: const TextStyle(fontSize: 18),
              onPressed: () {
                widget.onClick(mistakeList, _textEditingController.text);
                Navigator.of(context).pop();
              })));

  _updateSelection(int index) {
    mistakeList[index].isSelected = !mistakeList[index].isSelected;
    _checkEnableButton();
  }

  _checkEnableButton() {
    _enableButton.value =
        mistakeList.where((mistake) => mistake.isSelected).isNotEmpty ||
            _textEditingController.text.isNotEmpty;
  }
}
