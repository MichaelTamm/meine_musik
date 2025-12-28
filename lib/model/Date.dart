class Date implements Comparable<Date> {
  Date(this.year, this.month, this.day)
    : assert(year >= 1900 && year <= 2099),
      assert(month >= 1 && month <= 12),
      assert(day >= 1 && day <= 31),
      _dateTime = DateTime(year, month, day) {
    if (_dateTime.year != year || _dateTime.month != month || _dateTime.day != day) {
      throw ArgumentError('Date($year, $month, $day) is not a valid date');
    }
  }

  factory Date.today() {
    final now = DateTime.now();
    return Date(now.year, now.month, now.day);
  }

  factory Date.tomorrow() {
    return Date.today().nextDay;
  }

  factory Date.yesterday() {
    return Date.today().previousDay;
  }

  factory Date.fromString(String dateString) {
    final match = RegExp('^([0-9]{4})-([01][0-9])-([0123][0-9])').firstMatch(dateString);
    if (match == null) {
      throw ArgumentError.value(dateString, 'dateString', 'must have the format yyyy-MM-dd');
    }
    final year = int.parse(match.group(1)!);
    final month = int.parse(match.group(2)!);
    final day = int.parse(match.group(3)!);
    return Date(year, month, day);
  }

  factory Date.fromInt(int yyyyMMdd) {
    return Date(yyyyMMdd ~/ 10000, (yyyyMMdd % 10000) ~/ 100, yyyyMMdd % 100);
  }

  factory Date.fromDateTime(DateTime dateTime) {
    if (dateTime.isUtc) {
      dateTime = dateTime.toLocal();
    }
    return Date(dateTime.year, dateTime.month, dateTime.day);
  }

  static Date? tryParse(String? dateString) {
    if (dateString == null) {
      return null;
    }
    try {
      final date = Date.fromString(dateString);
      return date;
    } catch (e) {
      return null;
    }
  }

  final int year;
  final int month;
  final int day;
  final DateTime _dateTime;

  Date get previousDay => toDateTime().subtract(Duration(hours: 6)).toDate();

  Date get nextDay => toDateTime().add(Duration(hours: 30)).toDate();

  /// Returns 1 for Monday, 2 for Tuesday, ..., and 7 for Sunday.
  int get weekday => toDateTime().weekday;

  Date addDays(int days) {
    var date = this;
    for (var i = 0; i < days; i++) {
      date = date.nextDay;
    }
    return date;
  }

  Date subtractDays(int days) {
    var date = this;
    for (var i = 0; i < days; i++) {
      date = date.previousDay;
    }
    return date;
  }

  /// Returns the monday of the week this date belongs to.
  Date get startOfWeek => subtractDays(weekday - 1);

  /// Returns the sunday of the week this date belongs to.
  Date get endOfWeek => addDays(7 - weekday);

  /// Returns the first day of the month this date belongs to.
  Date get startOfMonth => Date(year, month, 1);

  /// Returns the last day of the month this date belongs to.
  Date get endOfMonth {
    var d = Date(year, month, 28);
    var nextDay = d.nextDay;
    while (month == nextDay.month) {
      d = nextDay;
      nextDay = d.nextDay;
    }
    return d;
  }

  Date copyWith({int? year, int? month, int? day}) {
    return Date(year ?? this.year, month ?? this.month, day ?? this.day);
  }

  int toInt() {
    return year * 10000 + month * 100 + day;
  }

  DateTime toDateTime() => _dateTime;

  DateTime at(int hour, [int minute = 0, int second = 0]) => DateTime(year, month, day, hour, minute, second);

  @override
  int compareTo(Date other) {
    if (year < other.year) {
      return -1;
    } else if (year == other.year) {
      if (month < other.month) {
        return -1;
      } else if (month == other.month) {
        if (day < other.day) {
          return -1;
        } else if (day == other.day) {
          return 0;
        }
      }
    }
    return 1;
  }

  bool operator <(Date other) => compareTo(other) < 0;

  bool operator <=(Date other) => compareTo(other) <= 0;

  bool operator >(Date other) => compareTo(other) > 0;

  bool operator >=(Date other) => compareTo(other) >= 0;

  @override
  bool operator ==(Object other) {
    return identical(this, other) || other is Date && year == other.year && month == other.month && day == other.day;
  }

  @override
  int get hashCode => toInt();

  @override
  String toString() {
    return '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  }
}

extension DateTimeToDateExtension on DateTime {
  Date toDate() {
    if (isUtc) {
      return toLocal().toDate();
    }
    return Date(year, month, day);
  }
}
