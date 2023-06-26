class FirebaseCallbacks {
  static Future<void> Function(String name, {Map<String, Object>? parameters})?
      callback;

  static Future<void> logEvent(String name,
      {Map<String, Object>? parameters}) async {
    callback?.call(name, parameters: parameters);
  }
}
