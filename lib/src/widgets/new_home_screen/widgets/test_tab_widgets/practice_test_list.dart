import 'package:flutter/material.dart';

import '../../../icons/icon_box.dart';

class PracticeTestBoxData {
  final int index;
  final String title;
  final String background;
  final String icon;

  PracticeTestBoxData(this.index, this.title, this.icon, this.background);
}

class PracticeTestList extends StatelessWidget {
  final Color textColor;
  final List<PracticeTestBoxData> practiceTests;
  final void Function(int index) onSelect;

  const PracticeTestList({
    super.key,
    required this.practiceTests,
    required this.textColor,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: double.infinity,
      child: ListView.builder(
          padding: const EdgeInsets.only(left: 10, bottom: 10),
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: practiceTests.length,
          itemBuilder: (_, index) =>
              _practiceTestBox(practiceTests[index], index)),
    );
  }

  Widget _practiceTestBox(PracticeTestBoxData data, int index) => GestureDetector(
    onTap: () => onSelect(index),
    child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.all(10),
          width: 200,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                  image: AssetImage(data.background), fit: BoxFit.cover)),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconBox(
                  iconColor: Colors.black,
                  backgroundColor: textColor,
                  icon: data.icon,
                  padding: const EdgeInsets.all(2),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  data.title,
                  maxLines: 2,
                  style: TextStyle(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
  );
}
