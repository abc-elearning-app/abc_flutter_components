import 'package:flutter/material.dart';

import 'pages/email_page.dart';
import 'pages/otp_page.dart';

enum TabType { email, code }

class LoginItem {
  final String image;
  final String detail;

  LoginItem({
    required this.image,
    required this.detail,
  });
}

class MainLoginPage extends StatefulWidget {
  final Color upperBackgroundColor;
  final Color lowerBackgroundColor;
  final Color mainColor;
  final Color secondaryColor;
  final Color buttonTextColor;
  final bool isDarkMode;
  final List<LoginItem> tabDataList;

  final void Function(String email) onRequestCodeClick;
  final void Function() onSkip;
  final void Function(String otp) onSubmit;

  const MainLoginPage(
      {super.key,
      this.mainColor = const Color(0xFFE3A651),
      this.secondaryColor = const Color(0xFF7C6F5B),
      this.upperBackgroundColor = const Color(0xFFF5F4EE),
      this.lowerBackgroundColor = Colors.white,
      this.buttonTextColor = Colors.white,
      required this.isDarkMode,
      required this.onRequestCodeClick,
      required this.onSkip,
      required this.onSubmit,
      required this.tabDataList});

  @override
  State<MainLoginPage> createState() => _MainLoginPageState();
}

class _MainLoginPageState extends State<MainLoginPage> {
  final _pageController = PageController();
  final _pageIndex = ValueNotifier<int>(0);
  final _buttonEnable = ValueNotifier<bool>(false);

  final emailController = TextEditingController();
  final otpController = TextEditingController();

  late List<Widget> tabs;

  @override
  void initState() {
    tabs = [
      EmailPage(
        isDarkMode: widget.isDarkMode,
        emailController: emailController,
        image: widget.tabDataList[0].image,
        secondaryColor: widget.secondaryColor,
        detail: widget.tabDataList[0].detail,
        mainColor: widget.mainColor,
        onEnterEmail: () =>
            _buttonEnable.value = _isValidEmail(emailController.text),
      ),
      OtpPage(
        isDarkMode: widget.isDarkMode,
        otpController: otpController,
        image: widget.tabDataList[1].image,
        detail: widget.tabDataList[1].detail,
        mainColor: widget.mainColor,
        secondaryColor: widget.secondaryColor,
        onReenterEmail: () => _handleReenterEmail(),
        onEnterOtp: () => _buttonEnable.value = otpController.text.length == 4,
      )
    ];

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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor:
          widget.isDarkMode ? Colors.black : widget.upperBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor:
            widget.isDarkMode ? Colors.black : widget.upperBackgroundColor,
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
              Container(
                  color: widget.isDarkMode
                      ? Colors.grey.shade800
                      : widget.lowerBackgroundColor),
              Container(
                decoration: BoxDecoration(
                    color: widget.isDarkMode
                        ? Colors.black
                        : widget.upperBackgroundColor,
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
              Container(
                  color: widget.isDarkMode
                      ? Colors.black
                      : widget.upperBackgroundColor),
              Container(
                decoration: BoxDecoration(
                    color: widget.isDarkMode
                        ? Colors.grey.shade800
                        : widget.lowerBackgroundColor,
                    borderRadius:
                        const BorderRadius.only(topLeft: Radius.circular(50))),
              ),

              _buildButton()
            ]),
          )
        ],
      ),
    );
  }

  Widget _buildLeadingButton() => ValueListenableBuilder(
      valueListenable: _pageIndex,
      builder: (_, value, __) => Visibility(
            visible: value != 0,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: widget.isDarkMode ? Colors.white : Colors.black,
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
                fontWeight: FontWeight.w600,
                fontSize: 24,
                color: widget.isDarkMode ? Colors.white : Colors.black),
          ));

  Widget _buildSkipButton() => ValueListenableBuilder(
      valueListenable: _pageIndex,
      builder: (_, value, __) => Visibility(
            visible: value == 0,
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                icon: Text('Skip',
                    style: TextStyle(
                        fontSize: 16,
                        color:
                            widget.isDarkMode ? Colors.white : Colors.black)),
                onPressed: widget.onSkip,
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
                  disabledBackgroundColor: Colors.grey,
                  backgroundColor: widget.mainColor,
                  foregroundColor: widget.buttonTextColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  )),
              child: ValueListenableBuilder(
                valueListenable: _pageIndex,
                builder: (_, value, __) => Text(
                  value == 0 ? 'Request Code' : 'Submit',
                  style: const TextStyle(fontSize: 20),
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
