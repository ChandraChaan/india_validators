import 'package:india_validators/india_validators.dart';
import 'package:test/test.dart';

// All numbers below are made up, except the two GSTIN samples that GST
// documentation and tutorials use as examples.
void main() {
  group('checksums', () {
    test('Verhoeff matches the textbook example', () {
      expect(verhoeffCheckDigit('236'), 3);
      expect(verhoeffIsValid('2363'), isTrue);
      expect(verhoeffIsValid('2364'), isFalse);
    });

    test('GSTIN check character matches published samples', () {
      expect(gstinCheckCharacter('27AAPFU0939F1Z'), 'V');
      expect(gstinCheckCharacter('29AAGCB7383J1Z'), '4');
    });
  });

  group('Pan', () {
    test('parses and reads the holder type', () {
      final pan = Pan.tryParse(' abcpe1234f ')!;
      expect(pan.value, 'ABCPE1234F');
      expect(pan.holderType, PanHolderType.individual);
      expect(Pan.tryParse('ABCCE1234F')!.holderType, PanHolderType.company);
    });

    test('rejects bad formats and unknown holder types', () {
      expect(Pan.isValid('ABCPE1234'), isFalse);
      expect(Pan.isValid('ABCPE12345'), isFalse);
      expect(Pan.isValid('1BCPE1234F'), isFalse);
      expect(Pan.isValid('ABCZE1234F'), isFalse);
    });
  });

  group('Gstin', () {
    test('parses a valid GSTIN and its parts', () {
      final gstin = Gstin.tryParse('27abcpe1234f1zb')!;
      expect(gstin.value, '27ABCPE1234F1ZB');
      expect(gstin.stateCode, '27');
      expect(gstin.state, 'Maharashtra');
      expect(gstin.pan.value, 'ABCPE1234F');
      expect(gstin.entityCode, '1');
      expect(Gstin.tryParse('07ABCCE1234F2Z3')!.state, 'Delhi');
    });

    test('accepts the published samples', () {
      expect(Gstin.isValid('27AAPFU0939F1ZV'), isTrue);
      expect(Gstin.isValid('29AAGCB7383J1Z4'), isTrue);
    });

    test('rejects a wrong check character', () {
      expect(Gstin.isValid('27ABCPE1234F1ZC'), isFalse);
    });

    test('rejects an unknown state code', () {
      // 40 isn't a state code, even with a matching check character.
      final first14 = '40ABCPE1234F1Z';
      expect(Gstin.isValid('$first14${gstinCheckCharacter(first14)}'), isFalse);
    });

    test('rejects a malformed GSTIN', () {
      expect(Gstin.isValid('27ABCPE1234F1Z'), isFalse);
      expect(Gstin.isValid('27ABCPE1234F0ZB'), isFalse);
      expect(Gstin.isValid('27ABCPE1234F1YB'), isFalse);
    });
  });

  group('Aadhaar', () {
    test('parses a number with a valid check digit', () {
      final aadhaar = Aadhaar.tryParse('2341 2341 2346')!;
      expect(aadhaar.value, '234123412346');
      expect(aadhaar.formatted, '2341 2341 2346');
      expect(aadhaar.masked, 'XXXX XXXX 2346');
      expect(aadhaar.toString(), 'XXXX XXXX 2346');
    });

    test('catches a single-digit typo and an adjacent swap', () {
      expect(Aadhaar.isValid('234123412347'), isFalse);
      expect(Aadhaar.isValid('324123412346'), isFalse);
    });

    test('rejects numbers starting with 0 or 1, or the wrong length', () {
      expect(Aadhaar.isValid('012345678901'), isFalse);
      expect(Aadhaar.isValid('112345678901'), isFalse);
      expect(Aadhaar.isValid('23412341234'), isFalse);
    });
  });

  group('Ifsc', () {
    test('parses bank and branch codes', () {
      final ifsc = Ifsc.tryParse('sbin0001234')!;
      expect(ifsc.value, 'SBIN0001234');
      expect(ifsc.bankCode, 'SBIN');
      expect(ifsc.branchCode, '001234');
    });

    test('requires a zero in the fifth position', () {
      expect(Ifsc.isValid('SBIN1001234'), isFalse);
      expect(Ifsc.isValid('SBI00001234'), isFalse);
    });
  });

  group('UpiId', () {
    test('parses username and handle', () {
      final upi = UpiId.tryParse(' chandra.dev@OKHDFCBANK ')!;
      expect(upi.username, 'chandra.dev');
      expect(upi.handle, 'okhdfcbank');
      expect(upi.value, 'chandra.dev@okhdfcbank');
    });

    test('rejects malformed IDs', () {
      expect(UpiId.isValid('chandra'), isFalse);
      expect(UpiId.isValid('@ybl'), isFalse);
      expect(UpiId.isValid('a@ybl'), isFalse);
      expect(UpiId.isValid('name@1bank'), isFalse);
      expect(UpiId.isValid('name@bank.com'), isFalse);
    });
  });

  group('IndianMobile', () {
    test('accepts the common ways of writing a number', () {
      for (final input in [
        '9876543210',
        '09876543210',
        '+919876543210',
        '+91 98765 43210',
        '91-98765-43210',
        '(+91) 98765 43210',
      ]) {
        final mobile = IndianMobile.tryParse(input);
        expect(mobile?.nationalNumber, '9876543210', reason: input);
      }
    });

    test('formats for display and APIs', () {
      final mobile = IndianMobile.tryParse('9876543210')!;
      expect(mobile.e164, '+919876543210');
      expect(mobile.formatted, '+91 98765 43210');
    });

    test('rejects landlines and wrong lengths', () {
      expect(IndianMobile.isValid('5876543210'), isFalse);
      expect(IndianMobile.isValid('987654321'), isFalse);
      expect(IndianMobile.isValid('+449876543210'), isFalse);
    });
  });

  group('Pincode', () {
    test('parses and maps to a postal zone', () {
      expect(Pincode.tryParse('110001')!.zone, PostalZone.northern);
      expect(Pincode.tryParse('400001')!.zone, PostalZone.western);
      expect(Pincode.tryParse('560 001')!.zone, PostalZone.southern);
      expect(Pincode.tryParse('700001')!.zone, PostalZone.eastern);
      expect(Pincode.tryParse('900001')!.zone, PostalZone.armyPostalService);
    });

    test('rejects a leading zero and wrong lengths', () {
      expect(Pincode.isValid('012345'), isFalse);
      expect(Pincode.isValid('56001'), isFalse);
    });
  });

  group('IndiaValidators', () {
    test('returns null for valid input and a message otherwise', () {
      expect(IndiaValidators.pan('ABCPE1234F'), isNull);
      expect(IndiaValidators.pan('nope'), 'Enter a valid PAN, like ABCPE1234F');
      expect(IndiaValidators.gstin('27ABCPE1234F1ZB'), isNull);
      expect(IndiaValidators.aadhaar('234123412346'), isNull);
      expect(IndiaValidators.ifsc('SBIN0001234'), isNull);
      expect(IndiaValidators.upiId('name@ybl'), isNull);
      expect(IndiaValidators.mobile('9876543210'), isNull);
      expect(IndiaValidators.pincode('560001'), isNull);
    });

    test('handles empty values according to required', () {
      expect(IndiaValidators.pan(null), 'Enter your PAN');
      expect(IndiaValidators.pan('  '), 'Enter your PAN');
      expect(IndiaValidators.pan('', required: false), isNull);
    });

    test('uses custom messages', () {
      expect(IndiaValidators.pincode('1', message: 'Invalid'), 'Invalid');
      expect(
          IndiaValidators.mobile(null, emptyMessage: 'Required'), 'Required');
    });
  });
}
