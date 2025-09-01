// import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

// abstract interface class ConnectionChecker {
//   Future<bool> get isConnected;
// }

// class ConnectionCheckerImpl implements ConnectionChecker{
//   final InternetConnection internetConnection;
//   ConnectionCheckerImpl(this.internetConnection);

//   @override
//   Future<bool> get isConnected async  => await internetConnection.hasInternetAccess ;

// }
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract interface class ConnectionChecker {
  Future<bool> get isConnected;
}

class ConnectionCheckerImpl implements ConnectionChecker {
  final InternetConnection internetConnection;
  ConnectionCheckerImpl(this.internetConnection);

  @override
  Future<bool> get isConnected async {
    try {
      // Only check actual internet access
      return await internetConnection.hasInternetAccess;
    } catch (e) {
      return false;
    }
  }
}
