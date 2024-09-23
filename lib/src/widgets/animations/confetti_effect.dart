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
    _confettiController.stop();
    _confettiController.play();
    super.initState();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ConfettiEffect oldWidget) {
    _confettiController.stop();
    _confettiController.play();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    _confettiController.stop();
    _confettiController.play();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ConfettiWidget(
      shouldLoop: true,
      blastDirectionality: BlastDirectionality.explosive,
      confettiController: _confettiController,
    );
  }
}
