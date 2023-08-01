import 'dart:async';

import 'package:flutter/services.dart';

Future<bool> detectFileAssets(String file) async {
  Completer<bool> _completer = Completer();
  rootBundle.load(file).then((value) {
    _completer.complete(value.lengthInBytes > 0);
  }).catchError((e) {
    _completer.complete(false);
  });
  return _completer.future;
}
