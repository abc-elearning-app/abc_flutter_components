import 'package:flutter/material.dart';

import '../../../flutter_abc_jsc_components.dart';

class ReportData {
  final String title;
  bool isSelected;

  ReportData({required this.title, this.isSelected = false});
}

class ReportTab extends StatefulWidget {
  final void Function(List<ReportData> reportDataList, String otherReason)
      onReport;

  const ReportTab({super.key, required this.onReport});

  @override
  State<ReportTab> createState() => _ReportTabState();
}

class _ReportTabState extends State<ReportTab> {
  final _reportDataList = <ReportData>[
    ReportData(title: 'Incorrect Answer'),
    ReportData(title: 'Wrong Explanation'),
    ReportData(title: 'Wrong Category'),
    ReportData(title: 'Grammatical Error'),
    ReportData(title: 'Missing Content'),
    ReportData(title: 'Typo'),
    ReportData(title: 'Bad Image Quality'),
  ];

  final _feedbackTextController = TextEditingController();

  final _buttonDisable = ValueNotifier<bool>(true);

  @override
  void initState() {
    _feedbackTextController.addListener(() {
      _buttonDisable.value =
          _reportDataList.where((element) => element.isSelected).isEmpty &&
              _feedbackTextController.text.isEmpty;
    });
    super.initState();
  }

  @override
  void dispose() {
    _feedbackTextController.dispose();
    _buttonDisable.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 30, bottom: 50),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              'Report A Mistake',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ),
          _buildReportList(),
          _buildTextField(),
          _buildReportButton(context)
        ],
      ),
    );
  }

  Widget _buildReportList() => ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: _reportDataList.length,
      itemBuilder: (_, index) {
        return ListTile(
          title: Text(
            _reportDataList[index].title,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
          ),
          trailing: StatefulBuilder(
            builder: (_, setState) => Transform.scale(
              scale: 1.1,
              child: MyCheckBox(
                onChanged: (value) {
                  setState(() => _reportDataList[index].isSelected = value);
                  _buttonDisable.value = _reportDataList
                          .where((element) => element.isSelected)
                          .isEmpty &&
                      _feedbackTextController.text.isEmpty;
                },
                value: _reportDataList[index].isSelected,
              ),
            ),
          ),
        );
      });

  Widget _buildTextField() => Padding(
        padding: const EdgeInsets.all(20),
        child: TextField(
          controller: _feedbackTextController,
          decoration: InputDecoration(
              hintText: 'Other reasons',
              hintStyle: TextStyle(fontSize: 18, color: Colors.grey.shade400),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade800)),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade800))),
        ),
      );

  Widget _buildReportButton(BuildContext context) => Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: ValueListenableBuilder(
          valueListenable: _buttonDisable,
          builder: (_, value, __) => MainButton(
              disabled: value,
              title: 'Report',
              textStyle: const TextStyle(fontSize: 20),
              borderRadius: 15,
              onPressed: () => _handleReport(context)),
        ),
      );

  _handleReport(BuildContext context) {
    widget.onReport(_reportDataList, _feedbackTextController.text);
    Navigator.of(context).pop();
  }
}
