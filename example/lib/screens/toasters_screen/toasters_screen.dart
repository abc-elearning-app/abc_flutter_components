import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class ToastersScreen extends StatefulWidget {
  const ToastersScreen({super.key});

  @override
  State<ToastersScreen> createState() => _ToastersScreenState();
}

class _ToastersScreenState extends State<ToastersScreen> {
  final showToast = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            ElevatedButton(
                onPressed: () => ABCToaster.showToast(
                    context: context,
                    msg: "Enter information for your report!",
                    type: ABCToasterType.failed),
                child: const Text("Show Toast")),
            ElevatedButton(
                onPressed: () => showToast.value = !showToast.value,
                child: const Text("Show Inline Toast")),
            ValueListenableBuilder(
              valueListenable: showToast,
              builder: (_, value, __) => value
                  ? InlineToaster(
                      msg: "Inline Toaster",
                      type: ABCToasterType.info,
                      onShowToastEnd: () {},
                    )
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
