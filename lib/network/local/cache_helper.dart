import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper
{
  static SharedPreferences? sharedPreferences;

  static init() async
  {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> putBoolean({
    required String key,
    required bool value,
  }) async
  {
    return sharedPreferences!.setBool(key, value);
  }

  static dynamic getDate({
    required String key,
  })
  {
    return sharedPreferences?.get(key);
  }

   static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async
  {
    if(value is int ) {
      return sharedPreferences!.setInt(key, value);
    }
    if(value is String ) {
      return sharedPreferences!.setString(key, value);
    }
    if(value is bool ) {
      return sharedPreferences!.setBool(key, value);
    }else
      {
          return sharedPreferences!.setDouble(key, value);
      }
  }
 static Future<bool?> clearData({
  required String key,
})async{
    return  sharedPreferences?.remove(key);
  }

}
