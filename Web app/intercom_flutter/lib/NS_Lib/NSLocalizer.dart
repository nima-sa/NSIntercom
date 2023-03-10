import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'NSStorage.dart';

class NSLocalizer {
//   static Map<String, String> _localizedStringsDelegated;

//   final Locale locale;
//   NSLocalizer(this.locale);

//   static const LocalizationsDelegate<NSLocalizer> delegate =
//       _NSLocalizerDelegate();
//   static NSLocalizer of(BuildContext context) =>
//       Localizations.of<NSLocalizer>(context, NSLocalizer);

//   Future<bool> methodLoad(String scope) async {
//     String jsonString =
//         await rootBundle.loadString('$scope/${locale.languageCode}.json');
//     Map<String, dynamic> jsonMap = json.decode(jsonString);

//     final localizedStrings = jsonMap.map((key, value) {
//       return MapEntry(key, value.toString());
//     });
//     _localizedStringsDelegated = localizedStrings;
//     return true;
//   }

// // --------

  static TextDirection get textDirection {
    return isRtl ? TextDirection.rtl : TextDirection.ltr;
  }

  static TextAlign get textAlign {
    return isRtl ? TextAlign.end : TextAlign.start;
  }

  static bool isRtl = false;

  static Map<String, Map<String, String>> _localizedStrings = {};
  static String lng;

  static void clearCache() {
    _localizedStrings = {};
    isRtl = null;
    lng = null;
  }

  static List<String> ltrLanguages = ['en'];
  static List<String> rtlLanguages = ['fa', 'ar'];

  static List<String> faNumedLanguages = ['fa', 'ar'];

  static Future<Map<String, String>> load(
      {String scope = 'lang', String languageCode}) async {
    if (_localizedStrings[scope] != null) {
      return _localizedStrings[scope];
    }

    lng ??= languageCode ?? await NSStorage.recall(key: 'applng') ?? 'en';
    isRtl ??= rtlLanguages.contains(lng);

    String jsonString = await rootBundle.loadString('$scope/$lng.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    final localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });
    _localizedStrings[scope] = localizedStrings;
    return _localizedStrings[scope];
  }

  static String numsToFa(String inp) {
    return inp
        .replaceAll('0', '??')
        .replaceAll('1', '??')
        .replaceAll('2', '??')
        .replaceAll('3', '??')
        .replaceAll('4', '??')
        .replaceAll('5', '??')
        .replaceAll('6', '??')
        .replaceAll('7', '??')
        .replaceAll('8', '??')
        .replaceAll('9', '??');
  }

  static String numsToEn(String inp) {
    return inp
        .replaceAll('??', '0')
        .replaceAll('??', '1')
        .replaceAll('??', '2')
        .replaceAll('??', '3')
        .replaceAll('??', '4')
        .replaceAll('??', '5')
        .replaceAll('??', '6')
        .replaceAll('??', '7')
        .replaceAll('??', '8')
        .replaceAll('??', '9');
  }

  static String translate(String key, {String scope = 'lang', String sub}) {
    if (sub != null) scope = scope + '/$sub';
    load(scope: scope);
    final localizedScope = _localizedStrings[scope];
    if (localizedScope == null) return '';
    final out = localizedScope[key] ?? '';
    // final localized =
    // faNumedLanguages.contains(lng) ? numsToFa(out) : numsToEn(out);
    return out;
  }

  static String numbersToLng(String inp) {
    final localized =
        faNumedLanguages.contains(lng) ? numsToFa(inp) : numsToEn(inp);
    return localized;
  }

  static List<String> keys({String scope = 'lang', String sub}) {
    if (sub != null) scope = scope + '/$sub';
    load(scope: scope);
    final localizedScope = _localizedStrings[scope];
    if (localizedScope == null) return [];
    return localizedScope.keys.toList();
  }
}

// class _NSLocalizerDelegate extends LocalizationsDelegate<NSLocalizer> {
//   const _NSLocalizerDelegate();

//   @override
//   bool isSupported(Locale locale) => ['en', 'fa'].contains(locale.languageCode);

//   @override
//   Future<NSLocalizer> load(Locale locale) async {
//     NSLocalizer localizations = new NSLocalizer(locale);
//     await localizations.methodLoad('lang');
//     return localizations;
//   }

//   @override
//   bool shouldReload(_NSLocalizerDelegate old) => false;
// }
