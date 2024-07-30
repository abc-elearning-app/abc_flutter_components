import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:flutter_abc_jsc_components/src/widgets/icons/icon_box.dart';

class FilterData {
  final int id;
  final String icon;
  final String title;
  final bool isSelected;

  FilterData({
    required this.id,
    required this.icon,
    required this.title,
    required this.isSelected,
  });
}

class FilterBottomsheetComponent extends StatefulWidget {
  final List<FilterData> list;

  final String dropDownImage;
  final Color mainColor;
  final Color secondaryColor;
  final Color backgroundColor;

  final void Function(List<int> ids) onApply;

  const FilterBottomsheetComponent({
    super.key,
    required this.dropDownImage,
    required this.mainColor,
    required this.backgroundColor,
    required this.list,
    required this.secondaryColor,
    required this.onApply,
  });

  @override
  State<FilterBottomsheetComponent> createState() => _FilterBottomsheetComponentState();
}

class _FilterBottomsheetComponentState extends State<FilterBottomsheetComponent> {
  late List<bool> selectedOptions;
  late ValueNotifier<bool> allSelected;

  @override
  void initState() {
    selectedOptions = widget.list.map((option) => option.isSelected).toList();
    allSelected = ValueNotifier(widget.list.where((option) => !option.isSelected).isEmpty);
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
      mainAxisSize: MainAxisSize.min,
      children: [
        IconWidget(icon: widget.dropDownImage),
        Container(
          margin: const EdgeInsets.only(top: 5),
          decoration:
              BoxDecoration(color: widget.backgroundColor, borderRadius: const BorderRadius.only(topRight: Radius.circular(36), topLeft: Radius.circular(36))),
          child: SafeArea(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text('Subjects', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      const Expanded(child: Text('Select All', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                      ValueListenableBuilder(
                        valueListenable: allSelected,
                        builder: (_, value, __) => MyCheckBox(
                            value: value,
                            borderColor: widget.mainColor,
                            fillColor: Colors.white,
                            activeColor: widget.mainColor,
                            borderWidth: 1.5,
                            onChanged: (value) {
                              allSelected.value = value;
                              setState(() => selectedOptions = List.generate(widget.list.length, (_) => value));
                            }),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.list.length,
                  itemBuilder: (_, index) => _tile(index),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  width: double.infinity,
                  child: MainButton(
                    title: 'Apply Filters',
                    backgroundColor: widget.mainColor,
                    borderRadius: 16,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    textColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    onPressed: _onApply,
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _tile(int index) => GestureDetector(
        onTap: () => _onToggle(index, setState),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            children: [
              IconBox(iconColor: Colors.white, backgroundColor: widget.secondaryColor, icon: widget.list[index].icon),
              const SizedBox(width: 10),
              Expanded(
                  child: Text(
                widget.list[index].title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              )),
              StatefulBuilder(
                builder: (_, setState) => MyCheckBox(
                  value: selectedOptions[index],
                  borderColor: widget.mainColor,
                  fillColor: Colors.white,
                  borderWidth: 1.5,
                  activeColor: widget.mainColor,
                  onChanged: (_) => _onToggle(index, setState),
                ),
              ),
            ],
          ),
        ),
      );

  _onToggle(int index, void Function(void Function() action) setState) {
    setState(() => selectedOptions[index] = !selectedOptions[index]);
    allSelected.value = !selectedOptions.contains(false);
  }

  _onApply() {
    final selectedIds = <int>[];
    for (int i = 0; i < selectedOptions.length; i++) {
      if (selectedOptions[i]) selectedIds.add(widget.list[i].id);
    }
    widget.onApply(selectedIds);
    Navigator.of(context).pop();
  }
}
