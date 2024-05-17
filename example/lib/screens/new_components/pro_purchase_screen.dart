import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class TestProPurchaseScreen extends StatelessWidget {
  const TestProPurchaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final proOptions = <ProOptionData>[
      ProOptionData('', 4.99, 7, ProOptionTime.week, 0, 0),
      ProOptionData('Popular', 12.99, 24, ProOptionTime.month, 40, 3),
      ProOptionData('Economical', 19.99, 0, ProOptionTime.year, 90, 3),
    ];

    final perks = <String>[
      'Unlock Explanations for 1000+ Questions',
      'Customize your own tests',
      'Remove ads',
      'Use Dark mode',
      'Sync Across Devices'
    ];

    return ProPurchaseScreen(
      proOptions: proOptions,
      proName: 'ASVAB Pro',
      perks: perks,
      onRestore: () => print('Restore'),
    );
  }
}
