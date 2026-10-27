import 'checksums.dart';

/// An Aadhaar number.
///
/// Checks the format and the Verhoeff check digit, which catches every
/// single-digit typo and every swap of two adjacent digits. It can't tell
/// whether the number was actually issued.
///
/// Aadhaar numbers are sensitive personal data. Show them [masked], and
/// avoid logging or storing [value] unless you must.
final class Aadhaar {
  const Aadhaar._(this.value);

  static final _pattern = RegExp(r'^[2-9]\d{11}$');

  /// Parses [input], ignoring spaces and hyphens. Returns null if it isn't a
  /// valid Aadhaar number.
  static Aadhaar? tryParse(String input) {
    final value = input.replaceAll(RegExp(r'[\s-]'), '');
    if (!_pattern.hasMatch(value) || !verhoeffIsValid(value)) return null;
    return Aadhaar._(value);
  }

  static bool isValid(String input) => tryParse(input) != null;

  /// The 12 digits, without spaces.
  final String value;

  /// The number in groups of four, like `2341 2341 2346`.
  String get formatted =>
      '${value.substring(0, 4)} ${value.substring(4, 8)} ${value.substring(8)}';

  /// The number with only the last four digits visible, like
  /// `XXXX XXXX 2346`.
  String get masked => 'XXXX XXXX ${value.substring(8)}';

  /// Returns [masked], so the full number doesn't end up in logs by
  /// accident.
  @override
  String toString() => masked;
}
