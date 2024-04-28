import 'package:flutter/material.dart';

import 'email_page.dart';
import 'otp_page.dart';

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
      this.textColor = Colors.grey,
      required this.onRequestCodeClick,
      required this.onSkip,
      required this.onSubmit,
      required this.tabDataList});

  @override
  State<LoginPages> createState() => _LoginPagesState();
}

class _LoginPagesState extends State<LoginPages> {
  late PageController _pageController;
  final _pageIndex = ValueNotifier<int>(0);
  final _buttonEnable = ValueNotifier<bool>(false);

  final emailController = TextEditingController();
  final otpController = TextEditingController();

  // final tabDataList = <LoginDataItem>[
  //   LoginDataItem(
  //       image: Stack(
  //         alignment: Alignment.center,
  //         children: [
  //           Image.asset('assets/images/login_1_1.png'),
  //           Image.asset('assets/images/login_1_2.png')
  //         ],
  //       ),
  //       detail:
  //           "Log in now to receive personalized recommendations for practice and sync progress across devices."),
  //   LoginDataItem(
  //       image: Image.asset('assets/images/login_2.png'),
  //       detail:
  //           "Please enter the verification code we sent to your email address within 30 minutes. If you don't see it, check your spam folder.")
  // ];

  @override
  void initState() {
    _pageController = PageController();
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
                  itemCount: 2,
                  itemBuilder: (_, index) => _buildTab(
                      type: index == 0 ? TabType.email : TabType.code)),
            ]),
          ),

          // Lower background
          Expanded(
            flex: 1,
            child: Stack(children: [
              Container(color: widget.upperBackgroundColor),
              Container(
                decoration: BoxDecoration(
                    color: widget.lowerBackgroundColor,
                    borderRadius:
                        const BorderRadius.only(topLeft: Radius.circular(50))),
              ),
              Center(child: _buildButton())
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

  Widget _buildTab({required TabType type}) => type == TabType.email
      ? EmailPage(
          emailController: emailController,
          image: widget.tabDataList[0].image,
          textColor: widget.textColor,
          detail: widget.tabDataList[0].detail,
          mainColor: widget.mainColor,
          onEnterEmail: () =>
              _buttonEnable.value = _isValidEmail(emailController.text),
        )
      : OtpPage(
          otpController: otpController,
          image: widget.tabDataList[1].image,
          textColor: widget.textColor,
          detail: widget.tabDataList[1].detail,
          mainColor: widget.mainColor,
          onReenterEmail: () {
            // Clear all text controllers
            emailController.clear();
            otpController.clear();

            // Reset button
            _buttonEnable.value = false;

            // Go to email page
            _pageController.previousPage(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut);
          },
          onEnterOtp: () =>
              _buttonEnable.value = otpController.text.length == 4,
        );

  Widget _buildButton() => SizedBox(
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
      );

  _handleButtonClick() {
    // If at email tab
    if (_pageController.page == 0) {
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
