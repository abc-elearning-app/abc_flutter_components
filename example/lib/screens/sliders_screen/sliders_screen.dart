import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class SlidersScreen extends StatelessWidget {
  const SlidersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            FlutterSlider(
              values: const [100],
              max: 200,
              min: 0,
              maximumDistance: 300,
              rtl: false,
              selectByTap: true,
              trackBar: FlutterSliderTrackBar(
                  activeTrackBarHeight: 6,
                  activeTrackBar: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  inactiveTrackBar: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.5))),
              handlerAnimation: const FlutterSliderHandlerAnimation(
                curve: Curves.elasticOut,
                reverseCurve: null,
                duration: Duration(milliseconds: 300),
                scale: 1.1,
              ),
              onDragCompleted: (int handlerIndex, lowerValue, upperValue) {},
            ),
          ],
        ),
      ),
    );
  }
}
