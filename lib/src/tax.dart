import 'checksums.dart';

String _compact(String input) =>
    input.replaceAll(RegExp(r'[\s-]'), '').toUpperCase();

/// Who a PAN belongs to, from its fourth character.
enum PanHolderType {
  associationOfPersons('A'),
  bodyOfIndividuals('B'),
  company('C'),
  firm('F'),
  government('G'),
  hinduUndividedFamily('H'),
  artificialJuridicalPerson('J'),
  localAuthority('L'),
  individual('P'),
  trust('T');

  const PanHolderType(this.code);

  final String code;

  static PanHolderType? _fromCode(String code) {
    for (final type in values) {
      if (type.code == code) return type;
    }
    return null;
  }
}

/// A Permanent Account Number, such as `ABCPE1234F`.
///
/// Checks the format and the holder type. The Income Tax Department doesn't
/// publish the algorithm for the last character, so it can't be verified.
final class Pan {
  const Pan._(this.value, this.holderType);

  static final _pattern = RegExp(r'^[A-Z]{3}([A-Z])[A-Z]\d{4}[A-Z]$');

  /// Parses [input], ignoring case, spaces and hyphens. Returns null if it
  /// isn't a well-formed PAN.
  static Pan? tryParse(String input) {
    final value = _compact(input);
    final match = _pattern.firstMatch(value);
    if (match == null) return null;
    final holderType = PanHolderType._fromCode(match.group(1)!);
    return holderType == null ? null : Pan._(value, holderType);
  }

  static bool isValid(String input) => tryParse(input) != null;

  /// The PAN in upper case, without spaces.
  final String value;
  final PanHolderType holderType;

  @override
  String toString() => value;
}

/// GST state codes and the state or union territory each one belongs to.
const gstStateCodes = <String, String>{
  '01': 'Jammu and Kashmir',
  '02': 'Himachal Pradesh',
  '03': 'Punjab',
  '04': 'Chandigarh',
  '05': 'Uttarakhand',
  '06': 'Haryana',
  '07': 'Delhi',
  '08': 'Rajasthan',
  '09': 'Uttar Pradesh',
  '10': 'Bihar',
  '11': 'Sikkim',
  '12': 'Arunachal Pradesh',
  '13': 'Nagaland',
  '14': 'Manipur',
  '15': 'Mizoram',
  '16': 'Tripura',
  '17': 'Meghalaya',
  '18': 'Assam',
  '19': 'West Bengal',
  '20': 'Jharkhand',
  '21': 'Odisha',
  '22': 'Chhattisgarh',
  '23': 'Madhya Pradesh',
  '24': 'Gujarat',
  '25': 'Daman and Diu',
  '26': 'Dadra and Nagar Haveli and Daman and Diu',
  '27': 'Maharashtra',
  '28': 'Andhra Pradesh (before 2014)',
  '29': 'Karnataka',
  '30': 'Goa',
  '31': 'Lakshadweep',
  '32': 'Kerala',
  '33': 'Tamil Nadu',
  '34': 'Puducherry',
  '35': 'Andaman and Nicobar Islands',
  '36': 'Telangana',
  '37': 'Andhra Pradesh',
  '38': 'Ladakh',
  '97': 'Other Territory',
  '99': 'Centre Jurisdiction',
};

/// A GST Identification Number, such as `27AAPFU0939F1ZV`.
///
/// Checks the format, the state code, the embedded PAN and the check
/// character. Covers regular taxpayer GSTINs; special formats such as UINs
/// for embassies, non-resident taxpayers and TDS/TCS registrations aren't
/// accepted.
final class Gstin {
  const Gstin._(this.value, this.pan);

  static final _pattern =
      RegExp(r'^(\d{2})([A-Z]{5}\d{4}[A-Z])([1-9A-Z])Z([0-9A-Z])$');

  /// Parses [input], ignoring case, spaces and hyphens. Returns null if it
  /// isn't a valid GSTIN.
  static Gstin? tryParse(String input) {
    final value = _compact(input);
    final match = _pattern.firstMatch(value);
    if (match == null || !gstStateCodes.containsKey(match.group(1))) {
      return null;
    }
    final pan = Pan.tryParse(match.group(2)!);
    if (pan == null) return null;
    if (gstinCheckCharacter(value.substring(0, 14)) != match.group(4)) {
      return null;
    }
    return Gstin._(value, pan);
  }

  static bool isValid(String input) => tryParse(input) != null;

  /// The GSTIN in upper case, without spaces.
  final String value;

  /// The PAN of the business, from characters 3 to 12.
  final Pan pan;

  String get stateCode => value.substring(0, 2);

  /// The state or union territory the business is registered in.
  String get state => gstStateCodes[stateCode]!;

  /// Which registration this is for the same PAN in the same state: `1` for
  /// the first, then `2` to `9`, then `A` to `Z`.
  String get entityCode => value[12];

  @override
  String toString() => value;
}
