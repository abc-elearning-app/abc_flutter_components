import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      type: index == 0 ? TabType.email : TabType.code))
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
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    onPressed: () {
                      // If at email tab
                      if (_pageController.hasClients &&
                          _pageController.page == 0) {
                        _pageController.nextPage(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut);
                        //TODO: Add textfield
                        widget.onRequestCodeClick('abc');
                      } else if (_pageController.hasClients) {}
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: widget.buttonColor,
                        foregroundColor: widget.buttonTextColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 80, vertical: 15)),
                    child: ValueListenableBuilder(
                      valueListenable: _pageIndex,
                      builder: (_, value, __) => Text(
                        value == 0 ? 'Request Code' : 'Submit',
                        style: const TextStyle(fontSize: 25),
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

  Widget _buildTab({required TabType type}) => Column(
        children: [
          Icon(
            Icons.abc,
            size: 100,
          ),
          type == TabType.email ? Stack(
            alignment: Alignment.center,
            children: [
              Image.asset('assets/images/login_1_1.png'),
              Image.asset('assets/images/login_1_2.png')
            ],
          ) : Image.asset('assets/images/login_2.png'),
          const SizedBox(
            height: 100,
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
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextField(
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: Color(0xFF307561))),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ],
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < 4; i++)
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(width: 1, color: Color(0xFF307561))),
                      )
                  ],
                ),
          if (type == TabType.code)
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                'Enter Another Email',
                style: TextStyle(fontSize: 18, color: Color(0xFF307561)),
              ),
            )
        ],
      );
}
