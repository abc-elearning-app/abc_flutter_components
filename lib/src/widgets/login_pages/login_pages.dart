import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

enum TabType { email, code }

class LoginPages extends StatefulWidget {
  final Color upperBackgroundColor;
  final Color lowerBackgroundColor;
  final Color buttonColor;
  final Color buttonTextColor;
  final void Function(String email) onRequestCodeClick;
  final void Function() onSkip;
  final void Function(String code) onSubmit;

  const LoginPages({
    super.key,
    required this.upperBackgroundColor,
    required this.lowerBackgroundColor,
    required this.buttonColor,
    required this.buttonTextColor,
    required this.onRequestCodeClick,
    required this.onSkip,
    required this.onSubmit,
  });

  @override
  State<LoginPages> createState() => _LoginPagesState();
}

class _LoginPagesState extends State<LoginPages> {
  late PageController _pageController;
  final _pageIndex = ValueNotifier<int>(0);
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _scrollController = ScrollController();

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
    _emailController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  PinTheme customPinTheme = PinTheme();

  @override
  Widget build(BuildContext context) {
    customPinTheme = PinTheme(
        textStyle: const TextStyle(fontSize: 12),
        width: 30,
        height: 30,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
            border: Border.all(width: 0.5, color: const Color(0xFF307561))));

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: widget.upperBackgroundColor,
        leading: ValueListenableBuilder(
          valueListenable: _pageIndex,
          builder: (_, value, __) => value != 0
              ? IconButton(
                  icon: const Icon(
                    Icons.chevron_left,
                    size: 40,
                  ),
                  onPressed: () => _pageController.previousPage(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut),
                )
              : const SizedBox(),
        ),
        title: ValueListenableBuilder(
            valueListenable: _pageIndex,
            builder: (_, value, __) => Text(
                  value == 0 ? 'Log in' : 'Check your email',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 25),
                )),
        actions: [
          ValueListenableBuilder(
              valueListenable: _pageIndex,
              builder: (_, value, __) => value == 0
                  ? GestureDetector(
                      onTap: () => widget.onSkip(),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Text(
                          'Skip',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    )
                  : const SizedBox())
        ],
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
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ElevatedButton(
                    onPressed: () {
                      // If at email tab
                      if (_pageController.hasClients &&
                          _pageController.page == 0) {
                        if (_emailController.text.isNotEmpty) {
                          _pageController.nextPage(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut);
                        }

                        widget.onRequestCodeClick(_emailController.text);
                      } else if (_pageController.hasClients) {}
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: widget.buttonColor,
                        foregroundColor: widget.buttonTextColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15)),
                    child: ValueListenableBuilder(
                      valueListenable: _pageIndex,
                      builder: (_, value, __) => Text(
                        value == 0 ? 'Request Code' : 'Submit',
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                  ),
                ),
              )
            ]),
          )
        ],
      ),
    );
  }

  Widget _buildTab({required TabType type}) => SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            if (type == TabType.code) const SizedBox(height: 30),
            type == TabType.email
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset('assets/images/login_1_1.png', scale: 0.9),
                      Image.asset('assets/images/login_1_2.png', scale: 0.9)
                    ],
                  )
                : Image.asset('assets/images/login_2.png', scale: 1.8,),
            Padding(
              padding: EdgeInsets.only(
                  left: 30,
                  right: 30,
                  bottom: 30,
                  top: type == TabType.code ? 50 : 0),
              child: Text(
                type == TabType.email
                    ? "Log in now to receive personalized recommendations for practice and sync progress across devices."
                    : "Please enter the verification code we sent to your email address within 30 minutes. If you don't see it, check your spam folder.",
                style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
            ),
            type == TabType.email
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Email',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),

                        // Add padding when keyboard appear
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: TextField(
                            onTap: () => _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 100),
                                curve: Curves.linear),
                            controller: _emailController,
                            cursorColor: const Color(0xFF307561),
                            decoration: InputDecoration(
                                filled: true,
                                hintText: 'Type your email',
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade300),
                                fillColor: Colors.white,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                        color: Color(0xFF307561))),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        ),
                      ],
                    ),
                  )
                : Transform.scale(
                    scale: 2,
                    child: Pinput(
                      onTap: () => _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.linear),
                      controller: _otpController,
                      defaultPinTheme: customPinTheme,
                      focusedPinTheme: customPinTheme,
                      onCompleted: (pin) => print(pin),
                    ),
                  ),
            if (type == TabType.code)
              GestureDetector(
                onTap: () {
                  _emailController.clear();
                  _pageController.previousPage(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut);
                },
                child: const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    'Enter Another Email',
                    style: TextStyle(fontSize: 1, color: Color(0xFF307561)),
                  ),
                ),
              ),
            const SizedBox(height: 10),
          ],
        ),
      );
}
