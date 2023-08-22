import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

import '../../navigation/navigation_service.dart';

class BottomSheetsScreen extends StatelessWidget {
  const BottomSheetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            MainButton(
              title: "My Modal Bottom Sheet",
              onPressed: () async => await showMyModalBottomSheet(
                context: context,
                isScrollControlled: true,
                widget: Container(
                  height: 300,
                ),
                isUseBackground: true,
              ),
            ),
            MainButton(
              title: "Report Mistake Bottom Sheet",
              onPressed: () async => await showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                isScrollControlled: true,
                enableDrag: true,
                builder: (context) {
                  return ReportMistakeBottomSheet(
                    onReport: (_, __, ___) => showToastSuccess("Report sent"),
                    onClose: () => NavigationService().pop(),
                    questionId: 0,
                    notShowAdFunc: () {},
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
