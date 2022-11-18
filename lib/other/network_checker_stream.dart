import 'dart:async';
import 'dart:io';

Stream<bool> networkCheckerStreamFunction() async* {
  while (true) {
    await Future.delayed(
      const Duration(seconds: 1),
    );
    try {
      final result = await InternetAddress.lookup('example.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        yield true;
      }
    } on SocketException catch (_) {
      yield false;
    }
  }
}
