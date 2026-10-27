import 'package:india_validators/india_validators.dart';

void main() {
  final gstin = Gstin.tryParse('27AAPFU0939F1ZV');
  if (gstin != null) {
    print('GSTIN ${gstin.value}: ${gstin.state}, ${gstin.pan.holderType.name}');
  }

  final aadhaar = Aadhaar.tryParse('2341 2341 2346');
  print('Aadhaar: ${aadhaar?.masked ?? 'invalid'}');

  final mobile = IndianMobile.tryParse('098765-43210');
  print('Mobile: ${mobile?.formatted ?? 'invalid'}');

  final ifsc = Ifsc.tryParse('sbin0001234');
  print('IFSC bank: ${ifsc?.bankCode ?? 'invalid'}');

  final pin = Pincode.tryParse('560001');
  print('PIN zone: ${pin?.zone.name ?? 'invalid'}');

  // Form validators return null when valid, or an error message.
  print('PAN check: ${IndiaValidators.pan('ABCPE1234') ?? 'ok'}');
  print('UPI check: ${IndiaValidators.upiId('not-a-upi-id') ?? 'ok'}');
}
