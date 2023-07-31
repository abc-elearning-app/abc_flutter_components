import 'package:flutter/material.dart';

class OnReady extends StatefulWidget {
  final Widget child;
  final VoidCallback onReady;

  const OnReady({super.key, required this.child, required this.onReady});

  @override
  State<StatefulWidget> createState() => _OnReadyState();
}

class _OnReadyState extends State<OnReady> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      widget.onReady();
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
