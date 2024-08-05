import 'package:flutter/material.dart';

class SelectDataDialogComponent extends StatelessWidget {
  final String title;
  final String content;
  final bool isDarkMode;

  final DateTime currentLastSaved;
  final DateTime previousLastSaved;

  final Color secondaryColor;
  final Color backgroundColor;

  final void Function() currentSelected;
  final void Function() previousSelected;

  const SelectDataDialogComponent({
    super.key,
    required this.title,
    required this.content,
    required this.currentLastSaved,
    required this.previousLastSaved,
    required this.backgroundColor,
    required this.isDarkMode,
    required this.secondaryColor,
    required this.currentSelected,
    required this.previousSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: isDarkMode ? Colors.grey.shade900 : backgroundColor, borderRadius: BorderRadius.circular(36)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
              ),
              Text(content, style: const TextStyle(fontSize: 14), textAlign: TextAlign.center),
              const SizedBox(height: 20),
              _buildButton('Current Device', currentLastSaved, currentSelected),
              _buildButton('Previous Device', previousLastSaved, previousSelected),
            ],
          ),
        ),
      ]),
    );
  }

  _buildButton(String title, DateTime savedTime, void Function() onClick) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
          onPressed: onClick,
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              backgroundColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
              elevation: 0,
              foregroundColor: secondaryColor),
          child: Row(
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Last Saved: ${_getTimeFormat(savedTime)}',
                    style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                ],
              )),
              Icon(Icons.chevron_right_rounded, size: 35, color: isDarkMode ? Colors.white : Colors.grey.shade500)
            ],
          )),
    );
  }

  String _getTimeFormat(DateTime time) {
    String day = time.day.toString().padLeft(2, '0');
    String month = time.month.toString().padLeft(2, '0');
    String year = time.year.toString();
    String hour = time.hour.toString().padLeft(2, '0');
    String minute = time.minute.toString().padLeft(2, '0');
    String second = time.second.toString().padLeft(2, '0');

    return '$day/$month/$year $hour:$minute:$second';
  }
}
