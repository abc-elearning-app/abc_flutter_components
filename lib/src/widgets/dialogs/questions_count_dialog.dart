import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class QuestionCountDialog extends StatelessWidget {
  QuestionCountDialog({super.key});

  int selectedOption = -1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
            color: Color(0xFFF5F4EE),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            )),
        padding: const EdgeInsets.only(top: 15),
        width: double.infinity,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: 60,
              height: 5,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFF212121).withOpacity(0.3)),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: SizedBox(
                width: 250,
                child: Text(
                  'How many questions do you want?',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            _buildOptions(),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
              child: Row(
                children: [
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: MainButton(
                            borderRadius: 18,
                            title: 'Cancel',
                            textColor: const Color(0xFFE3A651),
                            textStyle: const TextStyle(fontSize: 18),
                            onPressed: () {},
                            borderSize: const BorderSide(
                                width: 1, color: Color(0xFFE3A651)),
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ))),
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: MainButton(
                            borderRadius: 18,
                            title: 'Practice',
                            textStyle: const TextStyle(fontSize: 18),
                            onPressed: () {},
                            backgroundColor: const Color(0xFFE3A651),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ))),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildOptions() => Padding(
        padding: const EdgeInsets.all(10),
        child: StatefulBuilder(
          builder: (_, setState) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
                6,
                (index) => GestureDetector(
                  onTap: () => setState(() => selectedOption = index),
                  child: CircleAvatar(
                        radius: 25,
                        backgroundColor: selectedOption == index
                            ? const Color(0xFF7C6F5B)
                            : const Color(0xFF212121).withOpacity(0.08),
                        child: Text(
                          '${(index + 1) * 10}',
                          style: TextStyle(
                              color: selectedOption == index
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ),
                )),
          ),
        ),
      );
}
