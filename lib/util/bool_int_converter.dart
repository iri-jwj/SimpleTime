class BoolIntConverter {
  static Map<String, dynamic> mapConvertBool2Int(
      Map<String, dynamic> toConvert) {
    return toConvert.map((key, value) {
      if (value is bool) {
        int actAsBool;
        if (value) {
          actAsBool = 1;
        } else {
          actAsBool = 0;
        }
        return MapEntry<String, dynamic>(key, actAsBool);
      }

      return MapEntry<String, dynamic>(key, value);
    });
  }

  static Map<String, dynamic> mapConvertInt2Bool(
      Map<String, dynamic> toConvert, List<String> targetKeys) {
    return toConvert.map((key, value) {
      if (targetKeys.contains(key) && (value == 0 || value == 1)) {
        bool realBool;
        if (value == 1) {
          realBool = true;
        } else {
          realBool = false;
        }
        return MapEntry<String, dynamic>(key, realBool);
      }
      return MapEntry<String, dynamic>(key, value);
    });
  }

  static List<dynamic> listConvertBool2Int(List<dynamic> toConvert) {
    List<dynamic> convertedList = List();

    for (dynamic value in toConvert) {
      if (value is bool) {
        if (value) {
          convertedList.add(1);
        } else {
          convertedList.add(0);
        }
      } else {
        convertedList.add(value);
      }
    }
    return convertedList;
  }
}
