class CodeValidator {
  bool validateCode(String value) {
    String pattern = "^[0-9a-zA-Z]+\$";
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return false;
    } else if (!regExp.hasMatch(value)) {
      return false;
    }
    return true;
  }
}
