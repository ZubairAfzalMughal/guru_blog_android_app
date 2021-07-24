import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';

class CheckConnection with ChangeNotifier {
  late StreamSubscription<ConnectivityResult> _streamSubscription;
  Connectivity _connectivity = Connectivity();
  late ConnectivityResult _connectivityResult=ConnectivityResult.none;

  ConnectivityResult get connectivityResult => _connectivityResult;

  void checkConnection() {
    _streamSubscription =
        _connectivity.onConnectivityChanged.listen(listenConnection);
  }

  void listenConnection(ConnectivityResult result) {
    _connectivityResult = result;
    notifyListeners();
  }

  void closeStream() {
    _streamSubscription.cancel();
  }
}
