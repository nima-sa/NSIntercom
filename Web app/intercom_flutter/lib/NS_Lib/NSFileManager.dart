import 'dart:convert';

import 'package:flutter/services.dart';

class NSFileManager {
  static Map<String, dynamic> cache = {};
  static Future<dynamic> loadFromRootBundle(String path,
      {bool cache = true}) async {
    try {
      if (cache && NSFileManager.cache[path] != null)
        return NSFileManager.cache[path];
      String jsonString = await rootBundle.loadString(path);
      dynamic jsonMap;
      jsonMap = json.decode(jsonString);
      if (cache) NSFileManager.cache[path] = jsonMap;
      return jsonMap;
    } catch (e) {
      return null;
    }
  }

  static dynamic loadCached(String path) => NSFileManager.cache[path];
}
