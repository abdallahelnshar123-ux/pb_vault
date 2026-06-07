import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class SharedPrefsUtils {
  final SharedPreferences _sharedPreferences;

  SharedPrefsUtils(this._sharedPreferences);

  Future<bool> saveData({required String key, required dynamic value}) async {
    switch (value) {
      case int _:
        return await _sharedPreferences.setInt(key, value);
      case String _:
        return await _sharedPreferences.setString(key, value);
      case double _:
        return await _sharedPreferences.setDouble(key, value);
      case List<String> _:
        return await _sharedPreferences.setStringList(key, value);
      case bool _:
        return await _sharedPreferences.setBool(key, value);
      default:
        throw UnsupportedError('Unsupported type ${value.runtimeType}');
    }
  }

  T? getData<T>({required String key}) {
    final value = _sharedPreferences.get(key);

    if (value is T) return value;

    return null;
  }

  Future<bool> removeData({required String key}) async {
    return await _sharedPreferences.remove(key);
  }
}
