import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static Future<bool> isConnected() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      return false;
    }
  }

  static Stream<List<ConnectivityResult>> get connectionStream {
    return Connectivity().onConnectivityChanged;
  }

  static Future<void> ensureConnection() async {
    final isConnected = await ConnectivityService.isConnected();
    if (!isConnected) {
      throw Exception('لا يوجد اتصال بالإنترنت');
    }
  }

  static String getConnectionStatusText(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return 'متصل بشبكة Wi-Fi';
      case ConnectivityResult.mobile:
        return 'متصل بشبكة المحمول';
      case ConnectivityResult.ethernet:
        return 'متصل بشبكة Ethernet';
      case ConnectivityResult.vpn:
        return 'متصل عبر VPN';
      case ConnectivityResult.bluetooth:
        return 'متصل عبر Bluetooth';
      case ConnectivityResult.other:
        return 'متصل';
      default:
        return 'غير متصل بالإنترنت';
    }
  }
}
