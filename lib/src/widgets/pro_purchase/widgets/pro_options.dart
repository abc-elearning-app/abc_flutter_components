import 'package:flutter/material.dart';

enum ProOptionTime { week, month, year }

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

class ProOptionData {
  final String title;
  final double price;
  final double originalPrice;
  final double percentSaved;
  final ProOptionTime optionTime;
  final int freeTrialDays;

  ProOptionData(
    this.title,
    this.price,
    this.originalPrice,
    this.optionTime,
    this.percentSaved,
    this.freeTrialDays,
  );
}

class ProOptions extends StatefulWidget {
  final List<ProOptionData> proOptions;
  final Color optionBackgroundColor;
  final Color mainColor;
  final Color secondaryColor;

  final void Function(int index) onSelect;

  const ProOptions(
      {super.key,
      required this.proOptions,
      required this.optionBackgroundColor,
      required this.mainColor,
      required this.secondaryColor,
      required this.onSelect});

  @override
  State<ProOptions> createState() => _ProOptionsState();
}

class _ProOptionsState extends State<ProOptions> {
  int selectedOption = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Row(
        children: List.generate(
            widget.proOptions.length,
            (index) => Expanded(
                  child: Transform.scale(
                    scale: selectedOption == index ? 1.05 : 1,
                    child: GestureDetector(
                        onTap: () {
                          setState(() => selectedOption = index);
                          widget.onSelect(index);
                        },
                        child: _buildOption(widget.proOptions[index], index)),
                  ),
                )),
      ),
    );
  }

  Widget _buildOption(ProOptionData data, int index) => Container(
        height: 180,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
            color: widget.optionBackgroundColor,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
                width: selectedOption == index ? 2 : 1,
                color: selectedOption == index
                    ? widget.mainColor
                    : widget.secondaryColor)),
        child: Stack(children: [
          // Main content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPrice(data.price, data.originalPrice),

              // Option's time
              Text(
                '1 ${data.optionTime.name.capitalize()}',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Divider(),
              ),

              // Price per day
              _buildPricePerDay(data.price, data.optionTime),
            ],
          ),

          if (data.title.isNotEmpty) _buildTitleBox(data.title, index),

          if (data.freeTrialDays > 0) _buildFreeDayTrials(data.freeTrialDays),

          _buildSavedPercentBox(data.percentSaved, index)
        ]),
      );

  Widget _buildPrice(double price, double originalPrice) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Price
          Text('\$$price',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              )),

          // Original price
          if (originalPrice > 0)
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text('\$$originalPrice',
                  style: const TextStyle(
                    fontSize: 12,
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                  )),
            )
        ],
      );

  Widget _buildPricePerDay(double price, ProOptionTime timeType) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
              text: TextSpan(
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins',
                  ),
                  children: [
                const TextSpan(text: 'Just '),
                TextSpan(
                    text: '\$${_getPricePerDay(price, timeType).floor()}.',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )),
                TextSpan(
                    text: _getPricePerDay(price, timeType)
                        .toStringAsFixed(2)
                        .replaceAll('0.', ''))
              ])),
          const Text(
            'Per Day',
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      );

  Widget _buildTitleBox(String title, int index) =>
      Stack(alignment: Alignment.centerRight, children: [
        Container(
          height: 24,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: selectedOption == index
                  ? widget.mainColor
                  : widget.secondaryColor),
          child: Center(
              child: Text(
            title,
            style: const TextStyle(
                fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500),
          )),
        ),
        selectedOption == index
            ? Image.asset('assets/images/select_pro_option.png')
            : const SizedBox.shrink()
      ]);

  Widget _buildFreeDayTrials(int freeTrialDays) => Align(
        alignment: Alignment.bottomCenter,
        child: Transform.translate(
          offset: const Offset(0, -15),
          child: RichText(
              text: TextSpan(
                  style: TextStyle(
                      color: widget.mainColor,
                      fontSize: 12,
                      fontFamily: 'Poppins'),
                  children: [
                TextSpan(text: '$freeTrialDays-Day '),
                const TextSpan(
                    text: 'FREE',
                    style: TextStyle(fontWeight: FontWeight.w800)),
                const TextSpan(text: ' Trial')
              ])),
        ),
      );

  Widget _buildSavedPercentBox(double percent, int index) => Align(
        alignment: Alignment.bottomCenter,
        child: Transform.translate(
          offset: const Offset(0, 15),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 4,
            ),
            decoration: BoxDecoration(
                color: selectedOption == index
                    ? widget.mainColor
                    : widget.secondaryColor,
                borderRadius: BorderRadius.circular(5)),
            child: Text(
              'save ${percent.toInt()}%',
              style: const TextStyle(
                fontSize: 11,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );

  double _getPricePerDay(double price, ProOptionTime timeType) {
    switch (timeType) {
      case ProOptionTime.week:
        return price / 7;
      case ProOptionTime.month:
        return price / 30;
      case ProOptionTime.year:
        return price / 365;
    }
  }
}