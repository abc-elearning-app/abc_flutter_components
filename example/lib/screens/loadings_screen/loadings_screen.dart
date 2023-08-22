import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class LoadingsScreen extends StatefulWidget {
  const LoadingsScreen({super.key});

  @override
  State<LoadingsScreen> createState() => _LoadingsScreenState();
}

class _LoadingsScreenState extends State<LoadingsScreen> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            ElevatedButton(
                onPressed: () => setState(() => _isLoading = true),
                child: const Text("Make loading")),
            if (_isLoading)
              GestureDetector(
                onTap: () => setState(() => _isLoading = false),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration:
                      BoxDecoration(color: Colors.grey.withOpacity(0.3)),
                  child: makeLoading(context),
                ),
              )
          ],
        ),
      ),
    );
  }
}
