import 'package:flutter/material.dart';

class NavigationService {
  static final NavigationService _this = NavigationService._getInstance();

  factory NavigationService() {
    return _this;
  }

  NavigationService._getInstance();

  final GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  void pop() {
    if (_navigationKey.currentState!.canPop()) {
      _navigationKey.currentState!.pop();
    }
  }

  bool canPop() {
    return _navigationKey.currentState!.canPop();
  }

  void popUntil(String routeName) {
    return _navigationKey.currentState!
        .popUntil(ModalRoute.withName(routeName));
  }

  Future<dynamic> pushNamed(String routeName, {dynamic arguments}) {
    return _navigationKey.currentState!
        .pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushReplacementNamed(String routeName, {dynamic arguments}) {
    return _navigationKey.currentState!
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  Future<dynamic> popAndPushNamed(String routeName, {dynamic arguments}) {
    return _navigationKey.currentState!
        .popAndPushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushNamedAndRemoveUntil(
      String routeName, String removeRouteName,
      {dynamic arguments}) {
    return _navigationKey.currentState!.pushNamedAndRemoveUntil(
        routeName, ModalRoute.withName(removeRouteName));
  }
}
