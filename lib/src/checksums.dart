// Verhoeff tables: multiplication in the dihedral group D5, the position
// permutation, and the inverse.
const _d = [
  [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
  [1, 2, 3, 4, 0, 6, 7, 8, 9, 5],
  [2, 3, 4, 0, 1, 7, 8, 9, 5, 6],
  [3, 4, 0, 1, 2, 8, 9, 5, 6, 7],
  [4, 0, 1, 2, 3, 9, 5, 6, 7, 8],
  [5, 9, 8, 7, 6, 0, 4, 3, 2, 1],
  [6, 5, 9, 8, 7, 1, 0, 4, 3, 2],
  [7, 6, 5, 9, 8, 2, 1, 0, 4, 3],
  [8, 7, 6, 5, 9, 3, 2, 1, 0, 4],
  [9, 8, 7, 6, 5, 4, 3, 2, 1, 0],
];
const _p = [
  [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
  [1, 5, 7, 6, 2, 8, 3, 0, 9, 4],
  [5, 8, 0, 3, 7, 9, 6, 1, 4, 2],
  [8, 9, 1, 6, 0, 4, 3, 5, 2, 7],
  [9, 4, 5, 3, 1, 2, 6, 8, 7, 0],
  [4, 2, 8, 6, 5, 7, 3, 9, 0, 1],
  [2, 7, 9, 3, 8, 0, 6, 4, 1, 5],
  [7, 0, 4, 6, 9, 1, 3, 2, 5, 8],
];
const _inverse = [0, 4, 3, 2, 1, 5, 6, 7, 8, 9];

List<int> _digitsFromRight(String digits) =>
    digits.codeUnits.reversed.map((unit) => unit - 0x30).toList();

/// Whether [digits] ends in a correct Verhoeff check digit, as used by
/// Aadhaar numbers.
bool verhoeffIsValid(String digits) {
  var check = 0;
  final reversed = _digitsFromRight(digits);
  for (var i = 0; i < reversed.length; i++) {
    check = _d[check][_p[i % 8][reversed[i]]];
  }
  return check == 0;
}

/// The Verhoeff check digit to append to [digits].
int verhoeffCheckDigit(String digits) {
  var check = 0;
  final reversed = _digitsFromRight(digits);
  for (var i = 0; i < reversed.length; i++) {
    check = _d[check][_p[(i + 1) % 8][reversed[i]]];
  }
  return _inverse[check];
}

const _base36 = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';

/// The GSTIN check character for the first 14 characters of a GSTIN.
///
/// Each character's base-36 value is multiplied by 1 or 2 in turn, the
/// quotient and remainder of each product by 36 are summed, and the check
/// character makes the total a multiple of 36.
String gstinCheckCharacter(String first14) {
  var sum = 0;
  for (var i = 0; i < first14.length; i++) {
    final product = _base36.indexOf(first14[i]) * (i.isEven ? 1 : 2);
    sum += product ~/ 36 + product % 36;
  }
  return _base36[(36 - sum % 36) % 36];
}
