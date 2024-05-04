import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'pages/email_page.dart';
import 'pages/otp_page.dart';

enum TabType { email, code }

class LoginDataItem {
  final Widget image;
  final String detail;

  LoginDataItem({required this.image, required this.detail});
}

class LoginPages extends StatefulWidget {
  final Color appBarTextColor;
  final Color textColor;
  final Color upperBackgroundColor;
  final Color lowerBackgroundColor;
  final Color mainColor;
  final Color buttonTextColor;

  final String fontFamily;

  final List<LoginDataItem> tabDataList;

  final void Function(String email) onRequestCodeClick;
  final void Function() onSkip;
  final void Function(String otp) onSubmit;

  const LoginPages(
      {super.key,
      this.appBarTextColor = Colors.black,
      this.mainColor = const Color(0xFF579E89),
      this.upperBackgroundColor = const Color(0xFFEEFFFA),
      this.lowerBackgroundColor = Colors.white,
      this.buttonTextColor = Colors.white,
      this.textColor = Colors.black54,
      this.fontFamily = 'Poppins',
      required this.onRequestCodeClick,
      required this.onSkip,
      required this.onSubmit,
      required this.tabDataList});

  @override
  State<LoginPages> createState() => _LoginPagesState();
}

class _LoginPagesState extends State<LoginPages> {
  final _pageController = PageController();
  final _pageIndex = ValueNotifier<int>(0);
  final _buttonEnable = ValueNotifier<bool>(false);

  final emailController = TextEditingController();
  final otpController = TextEditingController();

  final tabs = <Widget>[];

  @override
  void initState() {
    tabs.addAll([
      EmailPage(
        fontFamily: widget.fontFamily,
        emailController: emailController,
        image: widget.tabDataList[0].image,
        textColor: widget.textColor,
        detail: widget.tabDataList[0].detail,
        mainColor: widget.mainColor,
        onEnterEmail: () =>
            _buttonEnable.value = _isValidEmail(emailController.text),
      ),
      OtpPage(
        otpController: otpController,
        image: widget.tabDataList[1].image,
        textColor: widget.textColor,
        detail: widget.tabDataList[1].detail,
        mainColor: widget.mainColor,
        onReenterEmail: () => _handleReenterEmail(),
        onEnterOtp: () => _buttonEnable.value = otpController.text.length == 4,
      )
    ]);

    _pageController.addListener(() {
      _pageIndex.value = _pageController.page!.toInt();
    });

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _pageIndex.dispose();
    _buttonEnable.dispose();

    emailController.dispose();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: widget.upperBackgroundColor,
          leading: _buildLeadingButton(),
          title: _buildPageTitle(),
          actions: [_buildSkipButton()],
        ),
        body: Column(
          children: [
            Expanded(
              flex: 5,
              child: Stack(alignment: Alignment.center, children: [
                // Upper background
                Container(color: widget.lowerBackgroundColor),
                Container(
                  decoration: BoxDecoration(
                      color: widget.upperBackgroundColor,
                      borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(50))),
                ),

                // Main page content
                PageView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    itemCount: tabs.length,
                    itemBuilder: (_, index) => tabs[index]),
              ]),
            ),
            Expanded(
              flex: 1,
              child: Stack(children: [
                // Lower background
                Container(color: widget.upperBackgroundColor),
                Container(
                  decoration: BoxDecoration(
                      color: widget.lowerBackgroundColor,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(50))),
                ),

                _buildButton()
              ]),
            )
          ],
        ),
      ),

      // Debug back button
      if (kDebugMode && Platform.isIOS)
        Column(
          children: [
            const SizedBox(height: 100),
            IconButton(
                onPressed: () => Navigator.of(context).pop(context),
                icon: const Icon(
                  Icons.chevron_left,
                  color: Colors.red,
                )),
          ],
        )
    ]);
  }

  Widget _buildLeadingButton() => ValueListenableBuilder(
      valueListenable: _pageIndex,
      builder: (_, value, __) => Visibility(
            visible: value != 0,
            child: IconButton(
              icon: Icon(
                Icons.chevron_left,
                size: 40,
                color: widget.appBarTextColor,
              ),
              onPressed: () {
                // Check button enable when go back to email page
                _buttonEnable.value = _isValidEmail(emailController.text);

                // Go back to email page
                _pageController.previousPage(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut);
              },
            ),
          ));

  Widget _buildPageTitle() => ValueListenableBuilder(
      valueListenable: _pageIndex,
      builder: (_, value, __) => Text(
            value == 0 ? 'Log in' : 'Check your email',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: widget.appBarTextColor,
            ),
          ));

  Widget _buildSkipButton() => ValueListenableBuilder(
      valueListenable: _pageIndex,
      builder: (_, value, __) => Visibility(
            visible: value == 0,
            child: GestureDetector(
              onTap: () => widget.onSkip(),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text('Skip',
                    style: TextStyle(
                      fontSize: 18,
                      color: widget.appBarTextColor,
                    )),
              ),
            ),
          ));

  Widget _buildButton() => Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: ValueListenableBuilder(
            valueListenable: _buttonEnable,
            builder: (_, value, __) => ElevatedButton(
              onPressed: value ? _handleButtonClick : null,
              style: ElevatedButton.styleFrom(
                  backgroundColor: widget.mainColor,
                  foregroundColor: widget.buttonTextColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15)),
              child: ValueListenableBuilder(
                valueListenable: _pageIndex,
                builder: (_, value, __) => Text(
                  value == 0 ? 'Request Code' : 'Submit',
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ),
          ),
        ),
      );

  _handleReenterEmail() {
    // Clear all text controllers
    emailController.clear();
    otpController.clear();

    // Reset button
    _buttonEnable.value = false;

    // Go to email page
    _pageController.previousPage(
        duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  _handleButtonClick() {
    // If at email tab
    if (_pageController.page == 0) {
      FocusScope.of(context).unfocus();

      _pageController.nextPage(
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);

      // Handle when request code
      widget.onRequestCodeClick(emailController.text);

      // Check enable button when move to otp page
      _buttonEnable.value = otpController.text.length == 4;
    } else {
      widget.onSubmit(otpController.text);
    }
  }

  _isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      caseSensitive: false,
      multiLine: false,
    );

    return emailRegex.hasMatch(email);
  }
}
