import 'package:flutter/material.dart';

class ButtonProVersion extends StatefulWidget {
  final String gifImage;
  final String image;

  const ButtonProVersion({
    Key? key,
    required this.gifImage,
    required this.image,
  }) : super(key: key);

  @override
  ButtonProVersionState createState() => ButtonProVersionState();
}

class ButtonProVersionState extends State<ButtonProVersion> {
  bool status = false;
  bool disposed = false;

  @override
  void initState() {
    super.initState();
    disposed = false;
    onRefresh();
  }

  void onRefresh() {
    if (!disposed) {
      setState(() {
        status = false;
      });
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (!disposed) {
          setState(() {
            status = true;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        children: [
          Opacity(
              opacity: 0,
              child: Image.asset(widget.image, fit: BoxFit.fitWidth)),
          Image.asset(
            status ? widget.image : widget.gifImage,
            fit: BoxFit.fitWidth,
          )
        ],
      ),
    );
  }
}
