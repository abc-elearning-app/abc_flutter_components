class AppStrings {
  const AppStrings._();

  static const enterEmailSheetStrings = _EnterEmailSheetStrings();
}

class _EnterEmailSheetStrings {
  const _EnterEmailSheetStrings();

  final login = "Login";
  final notYetEnterEmail = "Please enter your email!";
  final emailInvalid = "Please provide a valid email address!";

  get sentEmail => (String email) =>
      "We have sent an email with a verified code to $email. Please check your inbox!";
  final timeoutCode = "Notice: The code will invalid in 5 minutes.";
  final code = "Code";
  final notYetEnterCode = "Please enter enter your code";
  final codeInvalid = "Please provide a valid code!";
  final verifyCode = "Verify";
  final submit = "Submit";
}
