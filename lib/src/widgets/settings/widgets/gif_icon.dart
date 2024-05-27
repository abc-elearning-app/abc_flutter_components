import 'dart:async';

import 'package:flutter/material.dart';

class GifIcon extends StatefulWidget {
  const GifIcon({super.key});

  @override
  State<GifIcon> createState() => _GifIconState();
}

class _GifIconState extends State<GifIcon> {
  late Timer _timer;
  double rotation = 0;

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      rotation += 0.02;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Image.asset('assets/images/premium_background.png', width: 80),
      Image.asset('assets/images/premium.gif', width: 80)
    ]);
  }
}
