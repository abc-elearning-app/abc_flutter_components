import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class ProBannerData {
  final double percentSaved;
  final double price;
  final ProOptionTime timeType;

  ProBannerData(
    this.percentSaved,
    this.price,
    this.timeType,
  );
}

class ProBanner extends StatefulWidget {
  final String background;
  final Color textColor;
  final ProBannerData data;
  final String limitedOfferFrame;

  const ProBanner(
      {super.key,
      required this.background,
      required this.textColor,
      required this.data,
      required this.limitedOfferFrame});

  @override
  State<ProBanner> createState() => _ProBannerState();
}

class _ProBannerState extends State<ProBanner> {
  final _time = ValueNotifier<Duration>(
      const Duration(hours: 19, minutes: 56, seconds: 12));
  late Timer timer;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 1),
        (_) => _time.value -= const Duration(seconds: 1));
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(widget.background), fit: BoxFit.cover)),
      child: Row(
        children: [
          Expanded(
              child: RichText(
            text: TextSpan(
                style: TextStyle(
                    fontSize: 14,
                    color: widget.textColor,
                    fontWeight: FontWeight.w500),
                children: [
                  const TextSpan(text: 'Save '),
                  TextSpan(
                      text: '${widget.data.percentSaved.toInt()}%',
                      style: const TextStyle(
                          color: Color(0xFFFFD600),
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  const TextSpan(text: ' - Only '),
                  TextSpan(
                      text: '\$${widget.data.price}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w800)),
                  TextSpan(text: ' For 1 ${widget.data.timeType.name}')
                ]),
          )),

          // Limited offer
          Container(
            width: 100,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(widget.limitedOfferFrame))),
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: ValueListenableBuilder(
              valueListenable: _time,
              builder: (_, value, __) => Center(
                child: Transform.translate(
                  offset: const Offset(0, 3),
                  child: Text(
                    _getDisplayTime(value),
                    style: TextStyle(
                      color: widget.textColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _getDisplayTime(Duration time) {
    int hours = time.inHours;
    String displayHour = hours == 0
        ? '00'
        : hours < 10
            ? '0$hours'
            : hours.toString();
    int minutes = (time - Duration(hours: hours)).inMinutes;
    String displayMinute = minutes == 0
        ? '00'
        : minutes < 10
            ? '0$minutes'
            : minutes.toString();
    int seconds = (time - Duration(hours: hours, minutes: minutes)).inSeconds;
    String displaySecond = seconds == 0
        ? '00'
        : seconds < 10
            ? '0$seconds'
            : seconds.toString();
    return '$displayHour:$displayMinute:$displaySecond';
  }
}
