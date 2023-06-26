import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/constants/index.dart';
import 'package:flutter_abc_jsc_components/src/utils/email_validator.dart';
import 'package:flutter_abc_jsc_components/src/utils/firebase_callbacks.dart';

enum Screen { sendEmail, verifyCode }

class EnterEmailSheet extends StatefulWidget {
  final String loginTitle;
  final Widget privacyPolicyWidget;
  final String notYetEnterEmailString;
  final String emailInvalidString;

  const EnterEmailSheet(
      {super.key,
      required this.loginTitle,
      required this.privacyPolicyWidget,
      required this.notYetEnterEmailString,
      required this.emailInvalidString});

  @override
  State<EnterEmailSheet> createState() => _EnterEmailSheetState();
}

class _EnterEmailSheetState extends State<EnterEmailSheet>
    with SingleTickerProviderStateMixin {
  late TextEditingController _textEmailController;
  final _formEmailKey = GlobalKey<FormState>();
  late TextEditingController _textCodeController;
  final _formCodeKey = GlobalKey<FormState>();
  bool _sendEmailLoading = false;
  bool _verifyCodeLoading = false;

  late AnimationController _controller;
  late Animation<Offset> _animation;
  Screen screen = Screen.sendEmail;

  @override
  void initState() {
    super.initState();
    _textEmailController = TextEditingController();
    _textCodeController = TextEditingController();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero)
        .animate(_controller);
    _controller.forward(from: 1);
    _clickLogin();
  }

  void _clickLogin() {
    FirebaseCallbacks.logEvent(AppStrings.firebaseString.eventClickLogin);
  }

  @override
  void dispose() {
    _textEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.loginTitle),
      ),
      body: Stack(
        children: [
          screen == Screen.sendEmail
              ? SlideTransition(
                  position: _animation, child: _makePageSendEmail())
              : SlideTransition(
                  position: _animation, child: _makePageVerifyCode()),
        ],
      ),
    );
  }

  Widget _makePageSendEmail() {
    return Center(
      child: Form(
        key: _formEmailKey,
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
        controller: _textEmailController,
        decoration: const InputDecoration(
          icon: Icon(Icons.email),
          labelText: 'Email *',
        ),
        style:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        validator: (value) {
          value = value?.trim() ?? "";
          if (value.isEmpty) {
            return widget.notYetEnterEmailString;
          }
          if (!EmailValidator.validate(value)) {
            return widget.emailInvalidString;
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
      child: _sendEmailLoading
          ? const Column(
              children: [
                CircularProgressIndicator(),
              ],
            )
          : NewMainButton(
              title: "Submit",
              onPressed: () {
                if (_sendEmailLoading) {
                  return;
                }
                if (_formEmailKey.currentState!.validate()) {
                  setState(() {
                    _sendEmailLoading = true;
                  });
                  _onSendEmail();
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
                            child: Text(LocaleKeys.sended_email.tr(namedArgs: {
                          'title': _textEmailController.value.text.trim() ?? ""
                        })))
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.warning, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            LocaleKeys.timeout_code.tr(
                              namedArgs: {
                                'title': EMAIL_VERIFY_EXPIRED_TIME.toString()
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            : const SizedBox(),
        Form(
          key: _formCodeKey,
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
        controller: _textCodeController,
        decoration: InputDecoration(
          icon: const Icon(Icons.email),
          labelText: "${LocaleKeys.code.tr()} *",
        ),
        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return LocaleKeys.not_yet_enter_code.tr();
          }
          if (value.length < 6 || !validateCode(value)) {
            return LocaleKeys.code_invalid.tr();
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
      child: _verifyCodeLoading
          ? const Column(
              children: [
                CircularProgressIndicator(),
              ],
            )
          : NewMainButton(
              title: LocaleKeys.verifyCode.tr(),
              onPressed: () {
                if (_verifyCodeLoading) {
                  return;
                }
                if (_formCodeKey.currentState!.validate()) {
                  setState(() {
                    _verifyCodeLoading = true;
                  });
                  _onVerifyCode();
                }
              },
            ),
    );
  }

  void _gotoVerifyCodePage() {
    setState(() {
      screen = Screen.verifyCode;
    });
    _controller.reset();
    _controller.forward();
  }

  void _onSendEmail() {
    if (!DataManager.getInstance().isOnline) {
      ABCToaster.showWarningNoInternet(context);
      return;
    }
    String email = _textEmailController.value.text?.trim()?.toLowerCase() ?? "";
    FirebaseManagement.logEvent(Constants.event_login_by_email, parameters: {
      "email": email,
    });
    debugLog(
        "0000000000000000000000000000000000000000000000000000000000000000 isInDebugMode $isInDebugMode");
    if (EMAILS_DEMO.contains(email) ||
        (DataManager.getInstance().isTester || isInDebugMode)) {
      debugLog("1111111111111111111111111111111111111111111111111111");
      Provider.of<AuthModel>(context, listen: false)
          .onLoggedIn(email)
          .then((_) {
        Provider.of<InAppPurchaseModel>(context, listen: false).upgradePro();
        setState(() {
          _verifyCodeLoading = false;
        });
        Future.delayed(Duration(milliseconds: 200), () {
          NavigationService().pop();
        });
        Future.delayed(Duration(milliseconds: 400), () {
          ABCToaster.showToast(
              context: context,
              msg: LocaleKeys.login_successed.tr(),
              type: ABCToasterType.success);
          // showToastSuccess(LocaleKeys.login_successed.tr());
        });
      });
      return;
    }
    NetworkManagement.instance.sendEmailVerifyCode(email).then((int status) {
      setState(() {
        _sendEmailLoading = false;
      });
      if (status == 1) {
        _gotoVerifyCodePage();
      } else {
        ABCToaster.showToast(
            context: context,
            msg: LocaleKeys.cannot_send_email_try_again.tr(),
            type: ABCToasterType.failed);
        // showToastError(LocaleKeys.cannot_send_email_try_again.tr());
      }
    });
  }

  void _loginSuccess(String email) {
    FirebaseManagement.logEvent(Constants.event_login_by_email_success,
        parameters: {
          "email": email,
        });
  }

  void _onVerifyCode() {
    if (!DataManager.getInstance().isOnline) {
      ABCToaster.showWarningNoInternet(context);
      return;
    }
    String email = _textEmailController.value.text?.trim() ?? "";
    String code = _textCodeController.value.text?.trim() ?? "";
    FirebaseManagement.logEvent(Constants.event_verify_code, parameters: {
      "email": email,
      "code": code,
    });
    Provider.of<AuthModel>(context, listen: false)
        .verifyCode(email, code)
        .then((int status) {
      setState(() {
        _verifyCodeLoading = false;
      });
      if (status == STATUS_EMAIL_VERIFY_OK) {
        _loginSuccess(email);
        NavigationService().pop();
        Future.delayed(Duration(milliseconds: 200), () {
          ABCToaster.showToast(
              context: context,
              msg: LocaleKeys.login_successed.tr(),
              type: ABCToasterType.success);
          // showToastSuccess(LocaleKeys.login_successed.tr());
        });
      } else if (status == STATUS_EMAIL_VERIFY_EXPIRED) {
        ABCToaster.showToast(
            context: context,
            msg: LocaleKeys.code_expired.tr(),
            type: ABCToasterType.failed);
        // showToastError(LocaleKeys.code_expired.tr());
      } else if (status == STATUS_EMAIL_VERIFY_NOT_EXISTED) {
        ABCToaster.showToast(
            context: context,
            msg: LocaleKeys.code_not_existed_try_again.tr(),
            type: ABCToasterType.failed);
        // showToastError(LocaleKeys.code_not_existed_try_again.tr());
      } else {
        ABCToaster.showToast(
            context: context,
            msg: LocaleKeys.cannot_login_try_again.tr(),
            type: ABCToasterType.failed);
        // showToastError(LocaleKeys.cannot_login_try_again.tr());
      }
    });
  }
}
