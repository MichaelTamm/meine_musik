class RateLimit {
  RateLimit({required this.max, required this.per, this.now = DateTime.now}) {
    if (max > 1000) {
      throw ArgumentError('max ($max) must no be greater than 1000');
    }
  }

  final int max;
  final Duration per;
  final DateTime Function() now;

  final List<DateTime> _a = [];
  int _i = 0;

  bool withinRateLimit() {
    final now = this.now();
    if (_a.length < max) {
      _a.add(now.add(per));
      return true;
    }
    if (_a[_i].isBefore(now)) {
      _a[_i] = now.add(per);
      _i = (_i + 1) % max;
      return true;
    }
    return false;
  }
}
