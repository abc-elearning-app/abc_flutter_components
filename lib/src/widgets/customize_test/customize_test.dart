import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/widgets/customize_test/widgets/select_answer_mode_block.dart';
import 'package:flutter_abc_jsc_components/src/widgets/customize_test/widgets/select_subjects_box.dart';
import 'package:flutter_abc_jsc_components/src/widgets/customize_test/widgets/slider_tile.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../flutter_abc_jsc_components.dart';

enum ValueType { question, minute, passRate }

class CustomizeTest extends StatelessWidget {
  const CustomizeTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F4EE),
      child: Scaffold(
        appBar: _buildAppBar(),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Answer mode
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text('Feedback Modes',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  color: Colors.black)),
                        ),
                        const AnswerModesBlock(),

                        // Select amount of questions
                        const Padding(
                          padding:
                              EdgeInsets.only(left: 10, right: 10, top: 20),
                          child: Text('Question Count',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 20)),
                        ),
                        const SliderTile(
                            minValue: 10,
                            maxValue: 50,
                            type: ValueType.question),

                        // Select amount of minutes
                        const Padding(
                          padding:
                              EdgeInsets.only(left: 10, right: 10, top: 20),
                          child: Text('Duration (minutes)',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 20)),
                        ),
                        const SliderTile(
                            minValue: 10,
                            maxValue: 100,
                            type: ValueType.minute),

                        // Select subjects
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 20, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Subjects',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20)),
                              Row(
                                children: [
                                  Checkbox(
                                    value: true,
                                    onChanged: (value) {},
                                  ),
                                  const Text('Select All',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SelectSubjectBox(),

                        // Select amount of mistakes
                        const Padding(
                          padding:
                              EdgeInsets.only(left: 10, right: 10, top: 20),
                          child: Text('Passing score (%)',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 20)),
                        ),
                        const SliderTile(
                            minValue: 10,
                            maxValue: 100,
                            type: ValueType.passRate),
                      ],
                    ),
                  ),
                ),
                _buildButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildAppBar() => AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Customize Test',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 10),
            SvgPicture.asset('assets/images/pro.svg')
          ],
        ),
      );

  _buildButton() => Container(
        margin: const EdgeInsets.all(10),
        width: double.infinity,
        child: MainButton(
          textStyle: const TextStyle(fontSize: 18),
          title: 'Start',
          backgroundColor: const Color(0xFFE3A651),
          onPressed: () {},
        ),
      );
}
