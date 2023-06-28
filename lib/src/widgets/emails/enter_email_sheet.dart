import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/constants/index.dart';
import 'package:flutter_abc_jsc_components/src/utils/index.dart';

import '../index.dart';

enum Screen { sendEmail, verifyCode }

class EnterEmailSheet extends StatefulWidget {
  final Widget privacyPolicyWidget;
  final VoidCallback clickLogin;
  final VoidCallback buttonSubmitClick;
  final VoidCallback buttonVerifyCodeClick;
  final VoidCallback onSendEmail;
  final VoidCallback onVerifyCode;

  const EnterEmailSheet({
    super.key,
    required this.privacyPolicyWidget,
    required this.clickLogin,
    required this.buttonSubmitClick,
    required this.buttonVerifyCodeClick,
    required this.onSendEmail,
    required this.onVerifyCode,
  });

  @override
  State<EnterEmailSheet> createState() => EnterEmailSheetState();
}

class EnterEmailSheetState extends State<EnterEmailSheet>
    with SingleTickerProviderStateMixin {
  late TextEditingController textEmailController;
  final formEmailKey = GlobalKey<FormState>();
  late TextEditingController textCodeController;
  final formCodeKey = GlobalKey<FormState>();
  bool sendEmailLoading = false;
  bool verifyCodeLoading = false;

  late AnimationController controller;
  late Animation<Offset> animation;
  Screen screen = Screen.sendEmail;

  @override
  void initState() {
    super.initState();
    textEmailController = TextEditingController();
    textCodeController = TextEditingController();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    animation = Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero)
        .animate(controller);
    controller.forward(from: 1);
    widget.clickLogin.call();
  }

  @override
  void dispose() {
    textEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(AppStrings.enterEmailSheetStrings.login),
      ),
      body: Stack(
        children: [
          screen == Screen.sendEmail
              ? SlideTransition(
                  position: animation, child: _makePageSendEmail())
              : SlideTransition(
                  position: animation, child: _makePageVerifyCode()),
        ],
      ),
    );
  }

  Widget _makePageSendEmail() {
    return Center(
      child: Form(
        key: formEmailKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _makeEmailField(),
            _makeButton(),
            widget.privacyPolicyWidget
          ],
        ),
      ),
    );
  }

  Widget _makeEmailField() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TextFormField(
        autofocus: true,
        controller: textEmailController,
        decoration: const InputDecoration(
          icon: Icon(Icons.email),
          labelText: 'Email *',
        ),
        style:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        validator: (value) {
          value = value?.trim() ?? "";
          if (value.isEmpty) {
            return AppStrings.enterEmailSheetStrings.notYetEnterEmail;
          }
          if (!EmailValidator.validate(value)) {
            return AppStrings.enterEmailSheetStrings.emailInvalid;
          }
          return null;
        },
      ),
    );
  }

  Widget _makeButton() {
    return Container(
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      child: sendEmailLoading
          ? const Column(
              children: [
                CircularProgressIndicator(),
              ],
            )
          : MainButton(
              title: AppStrings.enterEmailSheetStrings.submit,
              onPressed: () {
                if (sendEmailLoading) {
                  return;
                }
                if (formEmailKey.currentState!.validate()) {
                  setState(() {
                    sendEmailLoading = true;
                  });
                  widget.onSendEmail();
                }
              },
            ),
    );
  }

  Widget _makePageVerifyCode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        screen == Screen.verifyCode
            ? Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Center(
                            child: Icon(Icons.check_circle_outline_outlined,
                                size: 40, color: Colors.green)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            AppStrings.enterEmailSheetStrings.sentEmail(
                                textEmailController.value.text.trim()),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.warning, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            AppStrings.enterEmailSheetStrings.timeoutCode,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            : const SizedBox(),
        Form(
          key: formCodeKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const SizedBox(), _makeCodeField(), _makeVerifyButton()],
          ),
        ),
      ],
    );
  }

  Widget _makeCodeField() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TextFormField(
        autofocus: true,
        controller: textCodeController,
        decoration: InputDecoration(
          icon: const Icon(Icons.email),
          labelText: AppStrings.enterEmailSheetStrings.code,
        ),
        style:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return AppStrings.enterEmailSheetStrings.notYetEnterCode;
          }
          if (value.length < 6 || !CodeValidator().validateCode(value)) {
            return AppStrings.enterEmailSheetStrings.codeInvalid;
          }
          return null;
        },
      ),
    );
  }

  Widget _makeVerifyButton() {
    return Container(
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      child: verifyCodeLoading
          ? const Column(
              children: [
                CircularProgressIndicator(),
              ],
            )
          : MainButton(
              title: AppStrings.enterEmailSheetStrings.verifyCode,
              onPressed: () {
                if (verifyCodeLoading) {
                  return;
                }
                if (formCodeKey.currentState!.validate()) {
                  setState(() {
                    verifyCodeLoading = true;
                  });
                  widget.onVerifyCode();
                }
              },
            ),
    );
  }
}
