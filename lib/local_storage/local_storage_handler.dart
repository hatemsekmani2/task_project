import 'package:shared_preferences/shared_preferences.dart';


class LocalStorageHandler {
  static  SharedPreferences? _sharedPreferences;
  static  LocalStorageHandler? _localStorageHandler;
  LocalStorageHandler._();

  static LocalStorageHandler getInstance() {

    _localStorageHandler ??= LocalStorageHandler._();

    return _localStorageHandler!;

  }

  Future<void> initSharedPreferences() async{
    _sharedPreferences ??= await  SharedPreferences.getInstance();


  }

  Future<bool> setString(String key , String value){
   return _sharedPreferences!.setString(key, value);
  }

  Future<bool>  setInt(String key , int value) {
    return _sharedPreferences!.setInt(key, value);
  }

  Future<bool>  setDouble(String key , double value) {
    return _sharedPreferences!.setDouble(key, value);
  }

  Future<bool>  setBool(String key , bool value){
    return _sharedPreferences!.setBool(key, value);
  }

  String? getString(String key) {
    return _sharedPreferences!.getString(key);
  }

  bool? getBool(String key) {
    return _sharedPreferences!.getBool(key);
  }

  double? getDouble(String key) {
    return _sharedPreferences!.getDouble(key);
  }

  int? getInt(String key) {
    return _sharedPreferences!.getInt(key);
  }

  bool containsKey(String key) {
    return _sharedPreferences!.containsKey(key);
  }
  Future<bool> clear() {
    return  _sharedPreferences!.clear();
  }


}