import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:flutter_abc_jsc_components/src/widgets/pro_purchase/widgets/pro_banner.dart';
import 'package:flutter_abc_jsc_components/src/widgets/pro_purchase/widgets/top_banner.dart';

class ProPurchaseScreen extends StatefulWidget {
  final List<ProOptionData> proOptions;
  final List<String> perks;
  final String proName;

  final Color mainColor;
  final Color secondaryColor;
  final Color textColor;
  final Color backgroundColor;
  final Color optionBackgroundColor;
  final String backgroundImage;
  final String proBannerBackground;

  final void Function() onRestore;

  const ProPurchaseScreen(
      {super.key,
      required this.proOptions,
      required this.perks,
      required this.onRestore,
      required this.proName,
      this.mainColor = const Color(0xFFEEAF56),
      this.secondaryColor = const Color(0xFF9D8A6B),
      this.textColor = Colors.black,
      this.backgroundColor = const Color(0xFFF5F4EE),
      this.optionBackgroundColor = Colors.white,
      this.backgroundImage = 'assets/images/pro_background_1.png',
      this.proBannerBackground = 'assets/images/pro_banner_background.png'});

  @override
  State<ProPurchaseScreen> createState() => _ProPurchaseScreenState();
}

class _ProPurchaseScreenState extends State<ProPurchaseScreen> {
  late ValueNotifier<ProBannerData> _proBannerData;

  @override
  void initState() {
    _proBannerData = ValueNotifier(ProBannerData(
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
      backgroundColor: widget.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TopBanner(
                      background: widget.backgroundImage,
                      onRestore: widget.onRestore,
                      textColor: widget.textColor,
                    ),
                    _buildTitle(),
                    _buildPerks(),
                    ProOptions(
                      mainColor: widget.mainColor,
                      secondaryColor: widget.secondaryColor,
                      proOptions: widget.proOptions,
                      optionBackgroundColor: widget.optionBackgroundColor,
                      onSelect: (index) {
                        final selectedOption = widget.proOptions[index];
                        _proBannerData.value = ProBannerData(
                            selectedOption.percentSaved,
                            selectedOption.price,
                            selectedOption.optionTime);
                      },
                    ),
                    _buildDetailText()
                  ],
                ),
              ),
            ),
            ValueListenableBuilder(
              valueListenable: _proBannerData,
              builder: (_, value, __) => value.percentSaved != 0
                  ? ProBanner(
                      background: widget.proBannerBackground,
                      textColor: Colors.white,
                      data: value,
                    )
                  : const SizedBox.shrink(),
            ),
            _buildButton(),
          ],
        ),
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
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: widget.textColor,
                  shadows: [
                    Shadow(
                        color: Colors.grey.shade400,
                        blurRadius: 3,
                        offset: const Offset(1, 3))
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: RichText(
                text: TextSpan(
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        color: widget.textColor,
                        shadows: [
                          Shadow(
                              color: Colors.grey.shade300,
                              blurRadius: 3,
                              offset: const Offset(1, 3))
                        ]),
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
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                ),
              )
            ],
          ));

  Widget _buildDetailText() => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Text(
          'Subscriptions auto-renew at the cost of the chosen package, unless cancelled 24-hours in advance prior to the end of the current period. The subscription fee is charged to your iTunes account at confirmation of purchase. You may manage your subscription and turn off auto-renewal by going to your Account Settings after purchase. Per Apple policy, no cancellation of the current subscription is allowed during the active subscription period. Once purchased, refunds will not be provided for any unused portion of the term.',
          style: TextStyle(fontSize: 12, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      );

  Widget _buildButton() => Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: double.infinity,
      child: MainButton(
        title: 'Upgrade Now',
        textStyle: const TextStyle(fontSize: 20),
        borderRadius: 16,
        backgroundColor: widget.mainColor,
        onPressed: () {},
        padding: const EdgeInsets.symmetric(vertical: 12),
      ));
}
