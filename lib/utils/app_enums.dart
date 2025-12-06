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

// ✅ UPDATED: Added call notification type
enum NotificationType {
  message,
  call,
  incomingCall, // ✅ Added for incoming calls
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

// ✅ NEW: Call State Enum
enum CallState {
  idle,
  calling,
  ringing,
  connected,
  ended,
  missed,
  rejected,
  busy,
  failed,
}

// ✅ NEW: Call Type Enum
enum CallType {
  audio,
  video,
}

// ✅ NEW: Call Direction Enum
enum CallDirection {
  incoming,
  outgoing,
}

// ✅ UPDATED: Extension for NotificationType
extension NotificationTypeExtension on NotificationType {
  String get value {
    return 'NotificationType.$name';
  }

  static NotificationType fromString(String value) {
    // Remove 'NotificationType.' prefix if present
    final cleanValue = value.replaceFirst('NotificationType.', '');

    switch (cleanValue.toLowerCase()) {
      case 'message':
        return NotificationType.message;
      case 'call':
      case 'incoming_call':
      case 'incomingcall':
        return NotificationType.incomingCall;
      case 'friendrequest':
      case 'friend_request':
        return NotificationType.friendRequest;
      case 'friendaccepted':
      case 'friend_accepted':
        return NotificationType.friendAccepted;
      case 'like':
        return NotificationType.like;
      case 'comment':
        return NotificationType.comment;
      case 'mention':
        return NotificationType.mention;
      case 'follow':
        return NotificationType.follow;
      case 'post':
        return NotificationType.post;
      case 'groupinvite':
      case 'group_invite':
        return NotificationType.groupInvite;
      case 'general':
      default:
        return NotificationType.general;
    }
  }

  // ✅ Helper to convert to backend format
  String toBackendString() {
    switch (this) {
      case NotificationType.message:
        return 'message';
      case NotificationType.call:
      case NotificationType.incomingCall:
        return 'incoming_call';
      case NotificationType.friendRequest:
        return 'friend_request';
      case NotificationType.friendAccepted:
        return 'friend_accepted';
      case NotificationType.like:
        return 'like';
      case NotificationType.comment:
        return 'comment';
      case NotificationType.mention:
        return 'mention';
      case NotificationType.follow:
        return 'follow';
      case NotificationType.post:
        return 'post';
      case NotificationType.groupInvite:
        return 'group_invite';
      case NotificationType.general:
        return 'general';
    }
  }
}

// ✅ NEW: Extension for CallState
extension CallStateExtension on CallState {
  String get value {
    return 'CallState.$name';
  }

  static CallState fromString(String value) {
    final cleanValue = value.replaceFirst('CallState.', '');

    switch (cleanValue.toLowerCase()) {
      case 'idle':
        return CallState.idle;
      case 'calling':
        return CallState.calling;
      case 'ringing':
        return CallState.ringing;
      case 'connected':
        return CallState.connected;
      case 'ended':
        return CallState.ended;
      case 'missed':
        return CallState.missed;
      case 'rejected':
        return CallState.rejected;
      case 'busy':
        return CallState.busy;
      case 'failed':
        return CallState.failed;
      default:
        return CallState.idle;
    }
  }

  // ✅ Check if call is active
  bool get isActive {
    return this == CallState.calling ||
        this == CallState.ringing ||
        this == CallState.connected;
  }

  // ✅ Check if call ended
  bool get isEnded {
    return this == CallState.ended ||
        this == CallState.missed ||
        this == CallState.rejected ||
        this == CallState.failed;
  }

  // ✅ Get display text
  String get displayText {
    switch (this) {
      case CallState.idle:
        return 'Idle';
      case CallState.calling:
        return 'Calling...';
      case CallState.ringing:
        return 'Incoming Call';
      case CallState.connected:
        return 'Connected';
      case CallState.ended:
        return 'Call Ended';
      case CallState.missed:
        return 'Missed Call';
      case CallState.rejected:
        return 'Call Rejected';
      case CallState.busy:
        return 'User Busy';
      case CallState.failed:
        return 'Call Failed';
    }
  }
}

// ✅ NEW: Extension for CallType
extension CallTypeExtension on CallType {
  String get value {
    return 'CallType.$name';
  }

  static CallType fromString(String value) {
    final cleanValue = value.replaceFirst('CallType.', '');

    switch (cleanValue.toLowerCase()) {
      case 'audio':
        return CallType.audio;
      case 'video':
        return CallType.video;
      default:
        return CallType.audio;
    }
  }

  // ✅ Convert to backend format
  String toBackendString() {
    switch (this) {
      case CallType.audio:
        return 'audio';
      case CallType.video:
        return 'video';
    }
  }

  // ✅ Get display text
  String get displayText {
    switch (this) {
      case CallType.audio:
        return 'Audio Call';
      case CallType.video:
        return 'Video Call';
    }
  }

  // ✅ Get icon name
  String get iconName {
    switch (this) {
      case CallType.audio:
        return 'call_icon';
      case CallType.video:
        return 'video_icon';
    }
  }
}

// ✅ NEW: Extension for CallDirection
extension CallDirectionExtension on CallDirection {
  String get value {
    return 'CallDirection.$name';
  }

  static CallDirection fromString(String value) {
    final cleanValue = value.replaceFirst('CallDirection.', '');

    switch (cleanValue.toLowerCase()) {
      case 'incoming':
        return CallDirection.incoming;
      case 'outgoing':
        return CallDirection.outgoing;
      default:
        return CallDirection.outgoing;
    }
  }

  // ✅ Convert to backend format
  String toBackendString() {
    switch (this) {
      case CallDirection.incoming:
        return 'incoming';
      case CallDirection.outgoing:
        return 'outgoing';
    }
  }

  // ✅ Get display text
  String get displayText {
    switch (this) {
      case CallDirection.incoming:
        return 'Incoming';
      case CallDirection.outgoing:
        return 'Outgoing';
    }
  }

  // ✅ Get icon rotation (for call history UI)
  double get iconRotation {
    switch (this) {
      case CallDirection.incoming:
        return 0.0; // Arrow pointing down
      case CallDirection.outgoing:
        return 180.0; // Arrow pointing up
    }
  }
}