import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NSStorage {
  static Map<String, dynamic> _cachedObjs = {};
  static Future<Map<String, dynamic>> getMapFromMemory(String key) async {
    try {
      var mem = await SharedPreferences.getInstance();
      final value = mem.getString(key);
      final Map<String, dynamic> result = json.decode(value);
      return result;
    } catch (error) {
      return null;
    }
  }

  static Future forget(String key) async {
    var mem = await SharedPreferences.getInstance();
    mem.remove(key);
    _cachedObjs.remove(key);
  }

  static Future memorise(
      {@required String key,
      @required dynamic value,
      bool cache = true}) async {
    try {
      var mem = await SharedPreferences.getInstance();
      if (value == null) {
        mem.remove(key);
      } else if (value.runtimeType == bool) {
        mem.setBool(key, value as bool);
      } else if (value.runtimeType == int) {
        mem.setInt(key, value as int);
      } else if (value.runtimeType == double) {
        mem.setDouble(key, value as double);
      } else if (value.runtimeType == String) {
        mem.setString(key, value as String);
      } else if (value.runtimeType == List) {
        mem.setStringList(key, value as List<String>);
      }
      if (cache) _cachedObjs[key] = value;
    } catch (error) {
      return;
    }
  }

  static Future<T> recall<T>({@required String key, bool cached = true}) async {
    try {
      if (cached) {
        final value = _cachedObjs[key];
        if (value != null) return value as T;
      }
      var mem = await SharedPreferences.getInstance();
      final res = mem.get(key);
      if (cached) _cachedObjs[key] = res;
      return res as T;
    } catch (error) {
      return null;
    }
  }

  static T recallCached<T>({@required String key}) {
    try {
      final value = _cachedObjs[key];
      if (value != null)
        return value as T;
      else
        return null;
    } catch (error) {
      return null;
    }
  }
}
