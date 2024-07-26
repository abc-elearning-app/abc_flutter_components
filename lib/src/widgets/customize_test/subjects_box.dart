import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class SubjectsValue {
  final int testSettingId;
  final int totalQuestion;
  final int duration;
  final int passingScore;
  final List<int> topicIds;

  SubjectsValue({
    required this.duration,
    required this.passingScore,
    required this.testSettingId,
    required this.topicIds,
    required this.totalQuestion,
  });
}

class CustomizeSubjectData {
  final int id;
  final String title;
  bool isSelected;
  String icon;

  CustomizeSubjectData({
    required this.id,
    required this.icon,
    required this.title,
    this.isSelected = false,
  });
}

class SubjectsBox extends StatefulWidget {
  final List<CustomizeSubjectData> subjects;
  final Color mainColor;
  final Color secondaryColor;
  final bool isDarkMode;

  const SubjectsBox({
    super.key,
    required this.subjects,
    required this.mainColor,
    required this.secondaryColor,
    required this.isDarkMode,
  });

  @override
  State<SubjectsBox> createState() => _SubjectsBoxState();
}

class _SubjectsBoxState extends State<SubjectsBox> {
  late List<bool> selectedOptions;

  @override
  void initState() {
    super.initState();
    selectedOptions = List.generate(widget.subjects.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: widget.mainColor),
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withOpacity(widget.isDarkMode ? 0.16 : 1),
        ),
        child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 5),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.subjects.length,
            itemBuilder: (_, index) => _subjectTile(index, widget.subjects[index])));
  }

  Widget _subjectTile(int index, CustomizeSubjectData subjectData) {
    return StatefulBuilder(
      builder: (_, setState) => GestureDetector(
        onTap: () {
          _toggle(subjectData.id);
          setState(() {
            selectedOptions[index] = !selectedOptions[index];
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          child: Row(
            children: [
              // Icon
              Container(
                width: 30,
                height: 30,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(color: widget.secondaryColor, borderRadius: BorderRadius.circular(8)),
                child: IconWidget(
                  icon: subjectData.icon,
                  color: Colors.white,
                  width: 24,
                ),
              ),
              const SizedBox(width: 15),
              // Title
              Expanded(
                child: Text(subjectData.title,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 16, color: widget.isDarkMode ? Colors.white : Colors.black, overflow: TextOverflow.ellipsis)),
              ),

              // Checkbox
              MyCheckBox(
                  activeColor: widget.mainColor,
                  fillColor: Colors.white.withOpacity(0.08),
                  borderColor: widget.isDarkMode ? Colors.white.withOpacity(0.16) : widget.mainColor,
                  iconColor: Colors.white,
                  value: selectedOptions[index],
                  onChanged: (_) => _toggle(subjectData.id))
            ],
          ),
        ),
      ),
    );
  }

  _toggle(int value) {}
}
