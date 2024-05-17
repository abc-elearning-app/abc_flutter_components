import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProPurchaseScreen extends StatelessWidget {
  const ProPurchaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF5F4EE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop()),
        actions: [
          TextButton(
              onPressed: () {},
              child: const Text('Restore',
                  style: TextStyle(fontSize: 18, color: Colors.black)))
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Image.asset('assets/images/pro_background_1.png',
                width: double.infinity),
            Container(
              height: 100,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/pro_background_1.png'),
                      fit: BoxFit.cover)),
            )
          ],
        ),
      ),
    );
  }
}
