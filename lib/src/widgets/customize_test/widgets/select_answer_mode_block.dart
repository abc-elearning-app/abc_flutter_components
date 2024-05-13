import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ModeData {
  final String title;
  final String detail;

  ModeData(this.title, this.detail);
}

class AnswerModesBlock extends StatefulWidget {
  const AnswerModesBlock({super.key});

  @override
  State<AnswerModesBlock> createState() => _AnswerModesBlockState();
}

class _AnswerModesBlockState extends State<AnswerModesBlock> {
  final modes = <ModeData>[
    ModeData('Newbie Mode',
        'Immediately after answering each question, the correct answers and explanations are displayed.'),
    ModeData('Expert Mode',
        'Only for expert, not normal people like you. Think very carefully when you select this mode !'),
    ModeData('Exam Mode', 'Exam-like questions to simulate a real life exam')
  ];

  int selectedModeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: List.generate(
            modes.length, (index) => _radioTile(modes[index], index)));
  }

  Widget _radioTile(ModeData modeData, int value) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => setState(() => selectedModeIndex = value),
            child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    border:
                        Border.all(width: 1, color: const Color(0xFFE3A651)),
                    color: selectedModeIndex == value
                        ? const Color(0xFFE3A651)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: ListTile(
                  leading: IconButton(
                      icon: Icon(Icons.info_outline,
                          color: selectedModeIndex == value
                              ? Colors.white
                              : Colors.grey.shade300),
                      onPressed: () {}),
                  title: Text(modeData.title,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: selectedModeIndex == value
                              ? Colors.white
                              : Colors.black)),
                  trailing: CircleAvatar(
                    radius: 12,
                    backgroundColor: selectedModeIndex == value
                        ? Colors.white
                        : Colors.grey.shade300,
                    child: CircleAvatar(
                      radius: selectedModeIndex == value ? 5 : 10,
                      backgroundColor: selectedModeIndex == value
                          ? const Color(0xFFE3A651)
                          : Colors.white,
                    ),
                  ),
                )),
          ),

          // Mode detail
          AnimatedCrossFade(
              firstChild: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  modeData.detail,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              secondChild: const SizedBox(),
              crossFadeState: selectedModeIndex == value
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 300))
        ],
      );
}
