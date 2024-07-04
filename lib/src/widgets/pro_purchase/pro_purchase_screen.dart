import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:flutter_abc_jsc_components/src/widgets/pro_purchase/widgets/pro_banner.dart';
import 'package:flutter_abc_jsc_components/src/widgets/pro_purchase/widgets/top_banner.dart';

class ProPurchase extends StatefulWidget {
  final List<ProOptionData> proOptions;
  final List<String> perks;
  final String proName;
  final bool isDarkMode;

  final Color mainColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final String mainImage;
  final String proBannerBackground;
  final String proOptionIcon;
  final String limitedOfferFrame;

  final VoidCallback onRestore;
  final void Function(String value) onUpgrade;

  const ProPurchase({
    super.key,
    required this.proOptions,
    required this.perks,
    required this.onRestore,
    required this.proName,
    this.mainColor = const Color(0xFFEEAF56),
    this.secondaryColor = const Color(0xFF9D8A6B),
    this.backgroundColor = const Color(0xFFF5F4EE),
    required this.mainImage,
    required this.proBannerBackground,
    required this.isDarkMode,
    required this.proOptionIcon,
    required this.limitedOfferFrame,
    required this.onUpgrade
  });

  @override
  State<ProPurchase> createState() => _ProPurchaseState();
}

class _ProPurchaseState extends State<ProPurchase> {
  late ValueNotifier<ProBannerData> _proBannerData;

  @override
  void initState() {
    _proBannerData = ValueNotifier(ProBannerData(
      widget.proOptions[1].id,
        widget.proOptions[1].percentSaved,
        widget.proOptions[1].price,
        widget.proOptions[1].optionTime));

    super.initState();
  }

  @override
  void dispose() {
    _proBannerData.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Stack(children: [
                Positioned.fill(
                    child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: widget.isDarkMode
                              ? [Colors.black, Colors.grey.shade900]
                              : [widget.backgroundColor, Colors.white],
                          stops: const [0.1, 0.9])),
                )),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TopBanner(
                      isDarkMode: widget.isDarkMode,
                      background: widget.mainImage,
                      onRestore: widget.onRestore,
                    ),
                    _buildTitle(),
                    _buildPerks(),
                    ProOptions(
                      isDarkMode: widget.isDarkMode,
                      mainColor: widget.mainColor,
                      secondaryColor: widget.secondaryColor,
                      proOptions: widget.proOptions,
                      proOptionIcon: widget.proOptionIcon,
                      onSelect: (index) {
                        final selectedOption = widget.proOptions[index];
                        _proBannerData.value = ProBannerData(
                          selectedOption.id,
                          selectedOption.percentSaved,
                          selectedOption.price,
                          selectedOption.optionTime
                        );
                      },
                    ),
                    _buildDetailText()
                  ],
                ),
              ]),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: _proBannerData,
            builder: (_, value, __) => value.percentSaved != 0
                ? ProBanner(
                    background: widget.proBannerBackground,
                    limitedOfferFrame: widget.limitedOfferFrame,
                    textColor: Colors.white,
                    data: value,
                  )
                : const SizedBox.shrink(),
          ),
          _buildButton(),
        ],
      ),
    );
  }

  Widget _buildTitle() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pass For The First Time With',
              style: TextStyle(
                  fontSize: 25,
                  color: widget.isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600,
                  shadows: !widget.isDarkMode
                      ? [
                          Shadow(
                              color: Colors.grey.shade400,
                              blurRadius: 3,
                              offset: const Offset(1, 3))
                        ]
                      : null),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: RichText(
                text: TextSpan(
                    style: TextStyle(
                        color: widget.isDarkMode ? Colors.white : Colors.black,
                        shadows: !widget.isDarkMode
                            ? [
                                Shadow(
                                    color: Colors.grey.shade300,
                                    blurRadius: 3,
                                    offset: const Offset(1, 3))
                              ]
                            : null),
                    children: [
                      TextSpan(
                          text: widget.proName,
                          style: TextStyle(
                              fontSize: 26,
                              color: widget.mainColor,
                              fontWeight: FontWeight.w800)),
                      const TextSpan(
                          text: ' Plan',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ))
                    ]),
              ),
            ),
          ],
        ),
      );

  Widget _buildPerks() => ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shrinkWrap: true,
      itemCount: widget.perks.length,
      itemBuilder: (_, index) => Row(
            children: [
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Icon(Icons.check, size: 20)),
              Text(
                widget.perks[index],
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                  color: widget.isDarkMode ? Colors.white : Colors.black,
                ),
              )
            ],
          ));

  Widget _buildDetailText() => const Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          'Subscriptions auto-renew at the cost of the chosen package, unless cancelled 24-hours in advance prior to the end of the current period. The subscription fee is charged to your iTunes account at confirmation of purchase. You may manage your subscription and turn off auto-renewal by going to your Account Settings after purchase. Per Apple policy, no cancellation of the current subscription is allowed during the active subscription period. Once purchased, refunds will not be provided for any unused portion of the term.',
          style: TextStyle(fontSize: 12, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      );

  Widget _buildButton() => Container(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 30),
      width: double.infinity,
      child: MainButton(
        title: 'Upgrade Now',
        textStyle: const TextStyle(fontSize: 20),
        borderRadius: 16,
        backgroundColor: widget.mainColor,
        onPressed: () {
          widget.onUpgrade(_proBannerData.value.id);
        },
        padding: const EdgeInsets.symmetric(vertical: 12),
      ));
}
