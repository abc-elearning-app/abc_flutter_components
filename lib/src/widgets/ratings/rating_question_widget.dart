import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/constants/configs.dart';

import '../index.dart';

class RatingQuestionWidget extends StatefulWidget {
  final Function(int value) onChange;
  final bool isDarkMode;

  const RatingQuestionWidget(
      {super.key, required this.onChange, required this.isDarkMode});

  @override
  State<RatingQuestionWidget> createState() => _RatingQuestionWidgetState();

  List<RatingQuestionItem> getRatingQuestionItems() {
    return [
      RatingQuestionItem(
          color: const Color(0xFFDF2A19),
          id: 1,
          title: "1",
          icon: "assets/icons/rating_icon_1.png"),
      RatingQuestionItem(
          color: const Color(0xFFDF2A19),
          id: 2,
          title: "2",
          icon: "assets/icons/rating_icon_2.png"),
      RatingQuestionItem(
          color: const Color(0xFFF07C01),
          id: 3,
          title: "3",
          icon: "assets/icons/rating_icon_3.png"),
      RatingQuestionItem(
          color: const Color(0xFFF07C01),
          id: 4,
          title: "4",
          icon: "assets/icons/rating_icon_4.png"),
      RatingQuestionItem(
          color: const Color(0xFFE2C802),
          id: 5,
          title: "5",
          icon: "assets/icons/rating_icon_5.png"),
      RatingQuestionItem(
          color: const Color(0xFFE2C802),
          id: 6,
          title: "6",
          icon: "assets/icons/rating_icon_6.png"),
      RatingQuestionItem(
          color: const Color(0xFFD5BC48),
          id: 7,
          title: "7",
          icon: "assets/icons/rating_icon_7.png"),
      RatingQuestionItem(
          color: const Color(0xFFD5BC48),
          id: 8,
          title: "8",
          icon: "assets/icons/rating_icon_8.png"),
      RatingQuestionItem(
          color: const Color(0xFF8FAF1E),
          id: 9,
          title: "9",
          icon: "assets/icons/rating_icon_9.png"),
      RatingQuestionItem(
          color: const Color(0xFF54AE28),
          id: 10,
          title: "10",
          icon: "assets/icons/rating_icon_10.png")
    ];
  }
}

class RatingQuestionItem {
  String? icon;
  String? title;
  int? id;
  Color? color;

  RatingQuestionItem({this.color, this.icon, this.id, this.title});
}

class _RatingQuestionWidgetState extends State<RatingQuestionWidget> {
  int activeId = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 1,
                      color: widget.isDarkMode
                          ? Colors.white54
                          : const Color(0xFFE3E3E3)))),
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: widget.getRatingQuestionItems().map<Widget>((item) {
              return Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  child: Text(item.id.toString(),
                      style: TextStyle(
                          color: widget.isDarkMode
                              ? Colors.white
                              : const Color(0xFF8B8B8B))));
            }).toList(),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: widget.getRatingQuestionItems().map<Widget>((item) {
            return ItemWidget(
              activeId: activeId,
              item: item,
              onChange: () {
                setState(() {
                  activeId = item.id!;
                });
                widget.onChange.call(activeId);
              },
            );
          }).toList(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Bad",
                  style: TextStyle(
                      color: widget.getRatingQuestionItems().first.color)),
              Text("Excellent",
                  style: TextStyle(
                      color: widget.getRatingQuestionItems().last.color)),
            ],
          ),
        )
      ],
    );
  }
}

class ItemWidget extends StatefulWidget {
  final RatingQuestionItem item;
  final VoidCallback onChange;
  final int activeId;

  const ItemWidget(
      {super.key,
      required this.item,
      required this.onChange,
      required this.activeId});

  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  GlobalKey<FadeScaleAnimationState> key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    if (widget.activeId > -1 && widget.item.id! < widget.activeId) {
      Future.delayed(
          Duration(
              milliseconds: (widget.activeId - widget.item.id!.toInt()) * 50),
          () {
        key.currentState?.onAnimated();
      });
    }
    return FadeScaleAnimation(
        key: key, delay: widget.item.id!.toInt() * 100, child: _makeContent());
  }

  Widget _makeContent() {
    if (widget.activeId == widget.item.id) {
      return SizedBox(
          width: 24,
          height: 24,
          child: Image.asset(
            widget.item.icon.toString(),
            width: 24,
            package: appPackage,
          ));
    }
    return InkWell(
      onTap: widget.onChange,
      child: Container(
        width: 24,
        height: 24,
        alignment: Alignment.center,
        child: Container(
          width: 14,
          height: 14,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: widget.activeId > widget.item.id!
                    ? widget.item.color!
                    : const Color(0xFFE3E3E3),
                width: 2),
          ),
          child: Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFFF1F1F1),
            ),
          ),
        ),
      ),
    );
  }
}
