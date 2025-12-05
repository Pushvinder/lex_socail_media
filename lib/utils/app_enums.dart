enum LogColor {
  red,
  green,
  yellow,
  blue,
  purple,
  cyan,
  gray,
  animated,
}

enum LanguageCode {
  en,
  es,
  fr,
  it,
  nl,
  zh,
}

// ✅ UPDATED: Added more notification types for social media
enum NotificationType {
  message,
  call,
  friendRequest,
  friendAccepted,
  like,
  comment,
  mention,
  follow,
  post,
  groupInvite,
  general,
}

enum ValidationType {
  none,
  email,
  phone,
  username,
  passwordLength,
  passwordLengthAlphaNumericSpecialCharacters,
  confirmPassword,
  empty,
}

enum ChatMessageType {
  none,
  text,
  image,
  audio,
  video,
  gif,
  textImage,
}

enum ChatBubbleType {
  sendBubble,
  receiveBubble,
}

enum MultilineIconPosition {
  top,
  bottom,
}

enum ComingFromScreen {
  none,
  splash,
  signup,
  signin,
  restricted,
  forgotPassword,
  profile,
  notifications,
}

enum ButtonPosition {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

enum DateFormatType {
  abbreviatedWeekdayMonthYear, // e.g. Tue, Mar 22, 2023
  mediumDate, // e.g. 23/Mar/2023
  longDate, // e.g. Wed 23 March, 2023
  fullDate, // e.g. Wednesday, March 23, 2023
  monthAndYear, // e.g. March 2023
  yearOnly, // e.g. 2023
  shortDate, // e.g. 23 Mar, 2023
  mediumDateWithWeekday, // e.g. Wed, 23 Mar 2023
  shortMonthAndYear, // e.g. Mar 2023
  shortDayMonthAndYear, // e.g. 23 Mar 2023
  dayOfWeekAndShortDate, // e.g. Wed 23 Mar, 2023
  dayOfWeekAndMonthYear, // e.g. Wed, March 2023
  shortMonthDayYear, // e.g. Mar 23, 2023
  shortMonthDay, // e.g. Mar 23
  shortDayMonth, // e.g. 23 Mar
  shortMonth, // e.g. Mar
  longMonth, // e.g. March
  longMonthAndYear, // e.g. March 2023
  longDayMonthAndYear, // e.g. 23 March 2023
  longDayMonth, // e.g. 23 March
  dayMonthYear, // e.g. 23/03/2023
  monthDayYear, // e.g. 03/23/2023
  longMonthDayYear, // e.g. March 23, 2023
  shortMonthDayOfWeekAndYear, // e.g. Mar 23, Wed 2023
  longMonthDayOfWeekAndYear, // e.g. March 23, Wed 2023
  longMonthDayOfWeek, // e.g. March 23, Wed
}

enum MonthFormatType {
  short,
  long,
  numeric,
}

enum DayFormatType {
  short,
  long,
  numeric,
}

enum RecordingState {
  UnSet,
  Set,
  Recording,
  Stopped,
}

enum MenuState {
  riderHome,
  coachHome,
}

// ✅ NEW: Extension for NotificationType
extension NotificationTypeExtension on NotificationType {
  String get value {
    return 'NotificationType.$name';
  }

  static NotificationType fromString(String value) {
    switch (value) {
      case 'NotificationType.message':
        return NotificationType.message;
      case 'NotificationType.call':
        return NotificationType.call;
      case 'NotificationType.friendRequest':
        return NotificationType.friendRequest;
      case 'NotificationType.friendAccepted':
        return NotificationType.friendAccepted;
      case 'NotificationType.like':
        return NotificationType.like;
      case 'NotificationType.comment':
        return NotificationType.comment;
      case 'NotificationType.mention':
        return NotificationType.mention;
      case 'NotificationType.follow':
        return NotificationType.follow;
      case 'NotificationType.post':
        return NotificationType.post;
      case 'NotificationType.groupInvite':
        return NotificationType.groupInvite;
      case 'NotificationType.general':
      default:
        return NotificationType.general;
    }
  }
}