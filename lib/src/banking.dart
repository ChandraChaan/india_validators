/// An Indian Financial System Code, such as `SBIN0001234`.
///
/// Checks the format: a four-letter bank code, a zero, and a six-character
/// branch code. It can't tell whether the branch exists.
final class Ifsc {
  const Ifsc._(this.value);

  static final _pattern = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');

  /// Parses [input], ignoring case and spaces. Returns null if it isn't a
  /// well-formed IFSC.
  static Ifsc? tryParse(String input) {
    final value = input.replaceAll(RegExp(r'\s'), '').toUpperCase();
    return _pattern.hasMatch(value) ? Ifsc._(value) : null;
  }

  static bool isValid(String input) => tryParse(input) != null;

  /// The IFSC in upper case.
  final String value;

  /// The bank, such as `SBIN` for State Bank of India or `HDFC` for HDFC
  /// Bank.
  String get bankCode => value.substring(0, 4);

  /// The branch, from the last six characters.
  String get branchCode => value.substring(5);

  @override
  String toString() => value;
}

/// A UPI ID (virtual payment address), such as `name@okhdfcbank`.
///
/// Checks the format. It can't tell whether the account exists: only a
/// payment app or a UPI verification API can.
final class UpiId {
  const UpiId._(this.username, this.handle);

  static final _pattern = RegExp(
      r'^([a-zA-Z0-9][a-zA-Z0-9._-]{1,255})@([a-zA-Z][a-zA-Z0-9]{1,63})$');

  /// Parses [input], ignoring surrounding spaces. Returns null if it isn't a
  /// well-formed UPI ID.
  static UpiId? tryParse(String input) {
    final match = _pattern.firstMatch(input.trim());
    if (match == null) return null;
    return UpiId._(match.group(1)!, match.group(2)!.toLowerCase());
  }

  static bool isValid(String input) => tryParse(input) != null;

  /// The part before the `@`.
  final String username;

  /// The payment provider's handle after the `@`, in lower case, such as
  /// `okhdfcbank` or `ybl`.
  final String handle;

  String get value => '$username@$handle';

  @override
  String toString() => value;
}
