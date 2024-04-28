import 'package:flutter/material.dart';

class DateOptionPage extends StatefulWidget {
  final String title;
  final Widget image;
  final PageController pageController;

  const DateOptionPage(
      {super.key,
      required this.title,
      required this.image,
      required this.pageController});

  @override
  State<DateOptionPage> createState() => _DateOptionPageState();
}

class _DateOptionPageState extends State<DateOptionPage> {
  final _selectedIndex = ValueNotifier<int?>(null);

  @override
  void dispose() {
    _selectedIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                widget.title,
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: widget.image,
            ),
            ValueListenableBuilder(
                valueListenable: _selectedIndex,
                builder: (_, value, __) => Column(
                      children: [
                        _buildSelectedOptionFrame(
                            index: 0,
                            isSelected: value == 0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Choose A Date',
                                  style: TextStyle(
                                      color: value == 0
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ),
                                Text('Pick A Date From Calendar',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: value == 0
                                            ? Colors.grey.shade300
                                            : Colors.grey)),
                              ],
                            )),
                        const SizedBox(height: 20),
                        _buildSelectedOptionFrame(
                            index: 1,
                            isSelected: value == 1,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                "I Don't Know My Exam Date Yet",
                                style: TextStyle(
                                    color: value == 1
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18),
                              ),
                            )),
                      ],
                    ))
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedOptionFrame(
          {required int index,
          required bool isSelected,
          required Widget child}) =>
      GestureDetector(
        onTap: () {
          _selectedIndex.value = index;

          // Delay for smooth animation
          Future.delayed(const Duration(milliseconds: 200), () {
            if (_selectedIndex.value == 0) {
              widget.pageController.nextPage(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut);
            } else {
              widget.pageController.animateToPage(3,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut);
            }
          });
        },
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: isSelected
                ? null
                : Border.all(width: 1, color: const Color(0xFF579E89)),
            color: isSelected ? const Color(0xFF579E89) : Colors.white,
          ),
          child: Row(
            children: [
              Expanded(child: child),
              CircleAvatar(
                radius: 12,
                backgroundColor: isSelected ? Colors.white : Colors.grey,
                child: CircleAvatar(
                  radius: isSelected ? 5 : 11,
                  backgroundColor:
                      isSelected ? const Color(0xFF579E89) : Colors.white,
                ),
              )
            ],
          ),
        ),
      );
}
