import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gif/gif.dart';

class GifIcon extends StatefulWidget {
  const GifIcon({super.key});

  @override
  State<GifIcon> createState() => _GifIconState();
}

class _GifIconState extends State<GifIcon> with SingleTickerProviderStateMixin {
  late Timer _timer;
  late ValueNotifier<double> _rotation;
  late GifController _gifController;

  @override
  void initState() {
    _gifController = GifController(vsync: this);
    _rotation = ValueNotifier<double>(0);

    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      _rotation.value += 0.02;
      if (_rotation.value >= 2 * pi) _rotation.value = 0;
    });

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    _rotation.dispose();
    _gifController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      ValueListenableBuilder(
        valueListenable: _rotation,
        builder: (_, value, __) => Transform.rotate(
            angle: value,
            child:
                Image.asset('assets/images/premium_background.png', width: 80)),
      ),
      Gif(
        image: const AssetImage("assets/images/premium.gif"),
        controller: _gifController,
        duration: const Duration(milliseconds: 2500),
        autostart: Autostart.no,
        placeholder: (_) => const Text(''),
        onFetchCompleted: () {
          _gifController.reset();
          Future.delayed(const Duration(milliseconds: 200),
              () => _gifController.forward());
        },
      ),
    ]);
  }
}
