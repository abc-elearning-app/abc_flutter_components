import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:flutter_abc_jsc_components/src/widgets/icons/icon_box.dart';

class EndorsementData {
  final int id;
  final String name;
  final String icon;

  EndorsementData({
    required this.id,
    required this.icon,
    required this.name,
  });
}

class SelectEndorsementTab extends StatefulWidget {
  final List<EndorsementData> endorsementList;

  final bool isDarkMode;

  final Color mainColor;
  final Color secondaryColor;
  final Color backgroundColor;

  final void Function(List<int> selectedIds) onNext;

  const SelectEndorsementTab({
    super.key,
    required this.endorsementList,
    required this.isDarkMode,
    required this.mainColor,
    required this.secondaryColor,
    required this.backgroundColor,
    required this.onNext,
  });

  @override
  State<SelectEndorsementTab> createState() => _SelectEndorsementTabState();
}

class _SelectEndorsementTabState extends State<SelectEndorsementTab> {
  late List<int> selectedIds;
  late ValueNotifier<bool> allSelected;

  @override
  void initState() {
    selectedIds = widget.endorsementList.map((topic) => topic.id).toList();
    allSelected = ValueNotifier<bool>(true);
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
        Expanded(child: ListView.builder(itemCount: widget.endorsementList.length, itemBuilder: (_, index) => _buildItem(index))),
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 30, bottom: 15, top: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Select All',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              ValueListenableBuilder(
                valueListenable: allSelected,
                builder: (_, value, __) => MyCheckBox(
                  activeColor: widget.mainColor,
                  borderColor: widget.mainColor,
                  value: value,
                  onChanged: (value) {
                    setState(() {
                      if (value) {
                        selectedIds = widget.endorsementList.map((en) => en.id).toList();
                      } else {
                        selectedIds.clear();
                      }
                    });
                    allSelected.value = value;
                  },
                ),
              )
            ],
          ),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(left: 15, right: 15, bottom: 18),
          child: MainButton(
            title: 'Next',
            padding: const EdgeInsets.symmetric(vertical: 15),
            textStyle: const TextStyle(fontSize: 16),
            backgroundColor: widget.mainColor,
            onPressed: () => widget.onNext(selectedIds),
          ),
        )
      ],
    );
  }

  Widget _buildItem(int index) {
    var currentId = widget.endorsementList[index].id;
    return StatefulBuilder(
      builder: (_, setState) => GestureDetector(
        onTap: () => _onToggle(index, currentId, setState),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: selectedIds.contains(currentId) ? widget.mainColor : Colors.transparent, width: 2),
              boxShadow: !widget.isDarkMode
                  ? [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 5,
                        spreadRadius: 2,
                        offset: const Offset(0, 2),
                      )
                    ]
                  : null),
          child: Row(
            children: [
              IconBox(
                iconColor: Colors.white,
                backgroundColor: widget.secondaryColor,
                icon: widget.endorsementList[index].icon,
                size: 40,
              ),
              const SizedBox(width: 15),
              Expanded(child: Text(widget.endorsementList[index].name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
              MyCheckBox(
                value: selectedIds.contains(widget.endorsementList[index].id),
                activeColor: widget.mainColor,
                borderColor: widget.mainColor,
                onChanged: (_) => _onToggle(index, currentId, setState),
              )
            ],
          ),
        ),
      ),
    );
  }

  _onToggle(int index, int currentId, void Function(void Function() action) setState) {
    setState(() {
      if (selectedIds.contains(currentId)) {
        selectedIds.remove(widget.endorsementList[index].id);
      } else {
        selectedIds.add(currentId);
      }
    });
    allSelected.value = selectedIds.length == widget.endorsementList.length;
  }
}
