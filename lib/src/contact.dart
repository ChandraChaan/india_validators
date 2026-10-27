/// An Indian mobile number.
///
/// Accepts the forms people actually type: `9876543210`, `09876543210`,
/// `+91 98765 43210`, `91-98765-43210` and so on. Mobile numbers start with
/// 6, 7, 8 or 9; landlines aren't accepted.
final class IndianMobile {
  const IndianMobile._(this.nationalNumber);

  static final _pattern = RegExp(r'^(?:\+?91|0)?([6-9]\d{9})$');

  /// Parses [input], ignoring spaces, hyphens and brackets. Returns null if
  /// it isn't an Indian mobile number.
  static IndianMobile? tryParse(String input) {
    final match =
        _pattern.firstMatch(input.replaceAll(RegExp(r'[\s\-()]'), ''));
    return match == null ? null : IndianMobile._(match.group(1)!);
  }

  static bool isValid(String input) => tryParse(input) != null;

  /// The 10-digit number without the country code.
  final String nationalNumber;

  /// The number in E.164 form for APIs and SMS gateways, like
  /// `+919876543210`.
  String get e164 => '+91$nationalNumber';

  /// The number for display, like `+91 98765 43210`.
  String get formatted =>
      '+91 ${nationalNumber.substring(0, 5)} ${nationalNumber.substring(5)}';

  @override
  String toString() => e164;
}

/// India Post's postal zones, from the first digit of a PIN code.
enum PostalZone {
  northern('Delhi, Haryana, Punjab, Himachal Pradesh, Jammu and Kashmir, '
      'Ladakh, Chandigarh, Uttar Pradesh and Uttarakhand'),
  western('Rajasthan, Gujarat, Maharashtra, Madhya Pradesh, Chhattisgarh, '
      'Goa, and Dadra and Nagar Haveli and Daman and Diu'),
  southern('Andhra Pradesh, Telangana, Karnataka, Tamil Nadu, Kerala, '
      'Puducherry and Lakshadweep'),
  eastern('West Bengal, Odisha, Bihar, Jharkhand, Sikkim, the North-East '
      'and the Andaman and Nicobar Islands'),
  armyPostalService('Army Postal Service');

  const PostalZone(this.covers);

  /// The states and territories the zone covers.
  final String covers;
}

/// A six-digit postal index number, such as `560001`.
final class Pincode {
  const Pincode._(this.value);

  static final _pattern = RegExp(r'^[1-9]\d{5}$');

  /// Parses [input], ignoring spaces. Returns null if it isn't a well-formed
  /// PIN code.
  static Pincode? tryParse(String input) {
    final value = input.replaceAll(RegExp(r'\s'), '');
    return _pattern.hasMatch(value) ? Pincode._(value) : null;
  }

  static bool isValid(String input) => tryParse(input) != null;

  /// The six digits.
  final String value;

  /// The postal zone. The first digit is 1 or 2 for northern, 3 or 4 for
  /// western, 5 or 6 for southern, 7 or 8 for eastern, and 9 for the Army
  /// Postal Service.
  PostalZone get zone => switch (value[0]) {
        '1' || '2' => PostalZone.northern,
        '3' || '4' => PostalZone.western,
        '5' || '6' => PostalZone.southern,
        '7' || '8' => PostalZone.eastern,
        _ => PostalZone.armyPostalService,
      };

  @override
  String toString() => value;
}
