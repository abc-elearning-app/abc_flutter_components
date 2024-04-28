import 'package:flutter/material.dart';

class LoginDataItem {
  final Widget image;
  final String detail;

  LoginDataItem({required this.image, required this.detail});
}

class EmailPage extends StatefulWidget {
  final Color upperBackgroundColor;
  final Color lowerBackgroundColor;
  final LoginDataItem tabData;

  const EmailPage(
      {super.key,
      required this.upperBackgroundColor,
      required this.lowerBackgroundColor,
      required this.tabData});

  @override
  State<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 8,
            child: Stack(alignment: Alignment.center, children: [
              Container(color: widget.lowerBackgroundColor),
              Container(
                decoration: BoxDecoration(
                    color: widget.upperBackgroundColor,
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(50))),
              ),
              widget.tabData.image
            ]),
          ),

          // Lower background
          Expanded(
            flex: 3,
            child: Stack(children: [
              Container(color: widget.upperBackgroundColor),
              Container(
                decoration: BoxDecoration(
                    color: widget.lowerBackgroundColor,
                    borderRadius:
                        const BorderRadius.only(topLeft: Radius.circular(50))),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  widget.tabData.detail,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
            ]),
          )
        ],
      ),
    );
  }
}
