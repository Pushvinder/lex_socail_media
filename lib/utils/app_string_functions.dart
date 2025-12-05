class AppStringFunctions {
  //! Convert string to bool
  static bool stringToBool(String str) {
    return str.toLowerCase() == 'true';
  }

  //! Convert enum to string
  static String enumToString(Object o) => o.toString().split('.').last;

  //! Convert string to enum
  // for example: AppStringFunctions.stringToEnum(chatMessagesListData.messageType, ChatMessageType.values,)
  static T stringToEnum<T>({required String key, required List<T> values}) =>
      values.firstWhere((v) => key == enumToString(v!));

  //! Replace all occurrences of strings in the list from the input string
  static String replaceStrings(
      {required String input,
        required List<String> stringsToReplace,
        required String replaceText}) {
    String result = input;
    for (String s in stringsToReplace) {
      result = result.replaceAll(s, replaceText);
    }
    return result;
  }

  //! Removes all occurrences of strings in the list from the input string
  static String removeStrings(String input, List<String> stringsToRemove) {
    String result = input;
    for (String s in stringsToRemove) {
      result = result.replaceAll(s, "");
    }
    return result;
  }

  //! Removes the last two characters of the input string if any string in the list is found
  static String removeStringOnceMatched(
      String input, List<String> stringsToRemove) {
    String result = "";
    for (String s in stringsToRemove) {
      if (input.contains(s)) {
        result = input.substring(0, input.length - 2);
        break;
      }
    }
    return result;
  }

  static String keepStrings(String input, List<String> stringsToKeep) {
    String result = "";
    for (String s in stringsToKeep) {
      if (input.contains(s)) {
        result += s;
      }
    }
    return result;
  }

  //! Keeps the first matched string from the list in the input and discards the rest
  static String keepStringOnceMatched(
      String input, List<String> stringsToKeep) {
    String result = "";
    for (String s in stringsToKeep) {
      if (input.contains(s)) {
        result += s;
        break;
      }
    }
    return result;
  }

  static List<String> splitString(
      {required String str, required String param}) {
    List<String> substrings = str.split(param);
    return substrings;
  }

  static bool isEmoji(String input) {
    RegExp emojiPattern = RegExp(
        "[\u{1F600}-\u{1F64F}" // Emoticons
            "\u{1F300}-\u{1F5FF}" // Symbols & Pictographs
            "\u{1F680}-\u{1F6FF}" // Transport & Map Symbols
            "\u{2600}-\u{26FF}" // Miscellaneous Symbols
            "\u{2700}-\u{27BF}" // Dingbats
            "\u{1F900}-\u{1F9FF}" // Supplemental Symbols and Pictographs
            "\u{1F1E0}-\u{1F1FF}" // Flags (iOS)
            "]+",
        unicode: true);
    return emojiPattern.hasMatch(input);
  }

  static String getFlagEmoji(String countryCode) {
    final codePoints = countryCode
        .toUpperCase()
        .runes
        .map((charCode) => charCode >= 0x41 && charCode <= 0x5A
        ? charCode + 0x1F1E6 - 0x41
        : null)
        .where((code) => code != null)
        .toList();

    if (codePoints.isEmpty) {
      return '';
    }

    return String.fromCharCodes(codePoints.cast<int>());
  }

  static String extractEmail(String text) {
    RegExp regex =
    RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b');
    Iterable<Match> matches = regex.allMatches(text);
    if (matches.isNotEmpty) {
      return matches.first.group(0)!;
    } else {
      return '';
    }
  }

  static String maybeEmptyString(dynamic value) {
    return value != null ? value.toString() : '';
  }

  //! Get names e.g. "You, Elina and Jenny"
  static String getNamesAtIndex({
    required List<dynamic> data,
    String? keyToSearch,
    String? name,
    String? replaceName,
  }) {
    Set<String> names = {};
    int counter = 0;

    void findNames(List<dynamic> data) {
      for (var item in data) {
        if (item is Map) {
          if (keyToSearch != null && item.containsKey(keyToSearch)) {
            String elementName = item[keyToSearch];
            if (elementName.isNotEmpty) {
              if (elementName == name && replaceName != null) {
                if (replaceName.isNotEmpty) {
                  names.add(replaceName);
                }
              } else {
                names.add(elementName);
              }
            }
          } else {
            findNames(item.values.toList());
          }
        } else if (item is List) {
          findNames(item);
        }
      }
    }

    findNames(data);

    // Format names
    if (names.length == 1) {
      return names.first;
    } else if (names.length == 2) {
      return "${names.elementAt(0)} and ${names.elementAt(1)}";
    } else if (names.length == 3) {
      return "${names.elementAt(0)}, ${names.elementAt(1)} and ${names.elementAt(2)}";
    } else if (names.length > 3) {
      counter = names.length - 3;
      return "${names.elementAt(0)}, ${names.elementAt(1)}, ${names.elementAt(2)} (+$counter)";
    } else {
      return "";
    }
  }

  //! Rider - Get names e.g. "You, Elina and Jenny"
  static String getNamesAtIndexRiderOnly({
    required List<dynamic> data,
    String? keyToSearch,
    String? name,
    String? replaceName,
  }) {
    Set<String> names = {};
    int counter = 0;

    void findNames(List<dynamic> data) {
      for (var item in data) {
        if (item is Map) {
          if (keyToSearch != null && item.containsKey(keyToSearch)) {
            String elementName = item[keyToSearch];
            if (elementName.isNotEmpty) {
              if (elementName == name && replaceName != null) {
                if (replaceName.isNotEmpty) {
                  names.add(replaceName);
                }
              } else {
                names.add(elementName);
              }
            }
          } else {
            findNames(item.values.toList());
          }
        } else if (item is List) {
          findNames(item);
        }
      }
    }

    findNames(data);

    // Format names
    if (names.length == 1) {
      return "You and ${names.first}"; // You and Elina
    } else if (names.length == 2) {
      return "You, ${names.elementAt(0)} and ${names.elementAt(1)}"; // You, Elina and James
    } else if (names.length > 2) {
      counter = names.length - 2;
      return "You, ${names.elementAt(0)}, ${names.elementAt(1)} (+$counter)"; // You, Elina, James (+1)
    } else {
      return "";
    }
  }
}