import 'package:flutter/material.dart';

import 'confetti/confetti.dart';
import 'confetti/enum/blast_directionality.dart';

class ConfettiEffect extends StatefulWidget {
  const ConfettiEffect({super.key});

  @override
  State<ConfettiEffect> createState() => _ConfettiEffectState();
}

class _ConfettiEffectState extends State<ConfettiEffect> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    _confettiController = ConfettiController();
    _confettiController.play();
    super.initState();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        shouldLoop: true,
        blastDirectionality: BlastDirectionality.explosive,
        confettiController: _confettiController,
      ),
    );
  }
}
