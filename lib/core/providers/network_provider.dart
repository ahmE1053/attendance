import 'package:flutter/material.dart';

import '../../other/network_checker_stream.dart';

class NetworkProvider extends ChangeNotifier {
  bool isConnectionWorking = true;
  int hello = 1;

  void changeIsConnectionWorking() {
    networkCheckerStreamFunction().listen(
      (connectionState) {
        if (connectionState != isConnectionWorking) {
          isConnectionWorking = connectionState;

          notifyListeners();
        }
      },
    );
  }
}
