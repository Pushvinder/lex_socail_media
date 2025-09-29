extension DateFormatExtension on DateTime {
  String toLongDateFormat() {
    return "$day ${_monthName(month)}, $year";
  }

  String _monthName(int month) {
    const months = [
      "",
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return months[month];
  }
}