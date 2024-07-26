import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

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

  final void Function(List<int> selectedIds) onSelect;

  const SubjectsBox({
    super.key,
    required this.subjects,
    required this.mainColor,
    required this.secondaryColor,
    required this.isDarkMode,
    required this.onSelect,
  });

  @override
  State<SubjectsBox> createState() => _SubjectsBoxState();
}

class _SubjectsBoxState extends State<SubjectsBox> {
  late List<bool> selectedOptions;
  late List<int> selectedIds;
  late ValueNotifier<bool> allSelected;

  @override
  void initState() {
    selectedOptions = List.generate(widget.subjects.length, (_) => true);
    selectedIds = widget.subjects.map((subject) => subject.id).toList();
    allSelected = ValueNotifier(true);
    super.initState();
  }

  @override
  void dispose() {
    allSelected.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Subjects', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: widget.isDarkMode ? Colors.white : Colors.black)),
              _selectAllButton(context)
            ],
          ),
        ),
        Container(
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
                itemBuilder: (_, index) => _subjectTile(index, widget.subjects[index]))),
      ],
    );
  }

  Widget _subjectTile(int index, CustomizeSubjectData subjectData) {
    return StatefulBuilder(
      builder: (_, setState) => GestureDetector(
        onTap: () => _onToggle(setState, index, subjectData.id),
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
                  onChanged: (_) => _onToggle(setState, index, subjectData.id)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectAllButton(BuildContext context) => Row(
        children: [
          Text('Select All', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: _textColor())),
          Padding(
            padding: const EdgeInsets.only(right: 3, left: 10),
            child: ValueListenableBuilder(
              valueListenable: allSelected,
              builder: (_, value, __) => MyCheckBox(
                activeColor: widget.mainColor,
                borderColor: widget.mainColor,
                value: value,
                onChanged: (value) {
                  setState(() => selectedOptions = List.generate(widget.subjects.length, (_) => value));
                  allSelected.value = value;
                },
              ),
            ),
          ),
        ],
      );

  _onToggle(void Function(void Function() action) setState, int index, subjectId) {
    // setState only the current row
    setState(() {
      selectedOptions[index] = !selectedOptions[index];
      if (selectedOptions[index]) {
        selectedIds.add(subjectId);
      } else {
        selectedIds.remove(subjectId);
      }
    });

    // Update select all checkbox
    allSelected.value = !selectedOptions.contains(false);

    // Callback
    widget.onSelect(selectedIds);
  }

  _textColor() => widget.isDarkMode ? Colors.white : Colors.black;
}
