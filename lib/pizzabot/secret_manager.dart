import 'package:shared_preferences/shared_preferences.dart';

class SecretManager {
  final SECRET_KEY = "secret";
  final LAST_UPDATED_KEY = "last_updated";

  Future<void> set(String secret) async {
    final sp = await SharedPreferences.getInstance();
    final now = DateTime.now();
    sp.setString(SECRET_KEY, secret);
    sp.setString(LAST_UPDATED_KEY, now.toString());
  }

  Future<String> get() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(SECRET_KEY) ?? "";
  }

  Future<int> hoursFromLastUpdate() async {
    try {
      final sp = await SharedPreferences.getInstance();
      final lastUpdated = DateTime.parse(sp.getString(LAST_UPDATED_KEY) ?? "");
      final now = DateTime.now();
      return now.difference(lastUpdated).inHours;
    } on FormatException catch (e) {
      return 365;
    }
  }
}
