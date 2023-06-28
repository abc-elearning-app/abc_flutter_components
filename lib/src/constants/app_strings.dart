class AppStrings {
  const AppStrings._();

  static const enterEmailSheetStrings = _EnterEmailSheetStrings();
  static const ratingStrings = _RatingStrings();
}

class _EnterEmailSheetStrings {
  const _EnterEmailSheetStrings();

  final login = "Login";
  final notYetEnterEmail = "Please enter your email!";
  final emailInvalid = "Please provide a valid email address!";

  get sentEmail =>
          (String email) =>
      "We have sent an email with a verified code to $email. Please check your inbox!";
  final timeoutCode = "Notice: The code will invalid in 5 minutes.";
  final code = "Code";
  final notYetEnterCode = "Please enter enter your code";
  final codeInvalid = "Please provide a valid code!";
  final verifyCode = "Verify";
  final submit = "Submit";
}

class _RatingStrings {
  const _RatingStrings();

  final ratingQuestion1 = "Are you satisfied with our app?";
  final ratingQuestion2 =
      "Please rate a 5-star to motivate us on making better service";
  final ratingQuestion3 = "Would you mind telling us what made you unpleasant?";

  final feedbackItem1 = "Content is incorrect";
  final feedbackItem2 = "The way of learning is not really helpful";
  final feedbackItem3 = "Unfriendly UI / UX";
  final feedbackItem4 = "Too many ads";
  final feedbackItem5 = "An error occurred";
  final feedbackItem6 = "Other";
  final feedbackItem7 = "An error occurred while processing your request";
  final feedbackItem8 = "What obstacles hinder you from using this app?";
  final feedbackItem9 = "Repetitive questions";
  final feedbackItem10 = "The app does not track my answers";

  final submit = "Submit";

  final ratingTitle = "WE NEED YOU";
  final ratingDescription1 =
      "5-Star ratings help us keep the app going and make us work hard on updates.";
  final ratingDescription2 =
      "Please rate us 5 stars on the App Store, or send us feedback for improvement.";
  final ratingButton = "Rate 5-Star";
  final ratingTakeFewSecond = "Take only a few second";
  final ratingFeedback = "Feedback";

  final ratingHint = "Enter a feedback";

  final okSure = "Ok, sure!";
  final noThanks = "No, thanks!";
}
