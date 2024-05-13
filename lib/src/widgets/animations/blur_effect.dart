import 'dart:ui';

import 'package:flutter/material.dart';

class BlurEffect extends StatelessWidget {
  const BlurEffect({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(color: Colors.transparent),
        ),
      ),
    );
  }
}
