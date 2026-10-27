import 'banking.dart';
import 'contact.dart';
import 'identity.dart';
import 'tax.dart';

/// Validators shaped for Flutter's `TextFormField.validator`: each returns
/// null when the value is fine and an error message when it isn't.
///
/// ```dart
/// TextFormField(validator: IndiaValidators.pan)
/// TextFormField(validator: (v) => IndiaValidators.gstin(v, required: false))
/// ```
///
/// Pass [message] to show your own wording, for example in another language.
abstract final class IndiaValidators {
  static String? _check(
    String? value,
    bool Function(String) isValid, {
    required bool required,
    required String message,
    required String emptyMessage,
  }) {
    if (value == null || value.trim().isEmpty) {
      return required ? emptyMessage : null;
    }
    return isValid(value) ? null : message;
  }

  static String? pan(
    String? value, {
    bool required = true,
    String message = 'Enter a valid PAN, like ABCPE1234F',
    String emptyMessage = 'Enter your PAN',
  }) =>
      _check(value, Pan.isValid,
          required: required, message: message, emptyMessage: emptyMessage);

  static String? gstin(
    String? value, {
    bool required = true,
    String message = 'Enter a valid 15-character GSTIN',
    String emptyMessage = 'Enter your GSTIN',
  }) =>
      _check(value, Gstin.isValid,
          required: required, message: message, emptyMessage: emptyMessage);

  static String? aadhaar(
    String? value, {
    bool required = true,
    String message = 'Enter a valid 12-digit Aadhaar number',
    String emptyMessage = 'Enter your Aadhaar number',
  }) =>
      _check(value, Aadhaar.isValid,
          required: required, message: message, emptyMessage: emptyMessage);

  static String? ifsc(
    String? value, {
    bool required = true,
    String message = 'Enter a valid IFSC, like SBIN0001234',
    String emptyMessage = 'Enter the IFSC',
  }) =>
      _check(value, Ifsc.isValid,
          required: required, message: message, emptyMessage: emptyMessage);

  static String? upiId(
    String? value, {
    bool required = true,
    String message = 'Enter a valid UPI ID, like name@bank',
    String emptyMessage = 'Enter your UPI ID',
  }) =>
      _check(value, UpiId.isValid,
          required: required, message: message, emptyMessage: emptyMessage);

  static String? mobile(
    String? value, {
    bool required = true,
    String message = 'Enter a valid 10-digit mobile number',
    String emptyMessage = 'Enter your mobile number',
  }) =>
      _check(value, IndianMobile.isValid,
          required: required, message: message, emptyMessage: emptyMessage);

  static String? pincode(
    String? value, {
    bool required = true,
    String message = 'Enter a valid 6-digit PIN code',
    String emptyMessage = 'Enter your PIN code',
  }) =>
      _check(value, Pincode.isValid,
          required: required, message: message, emptyMessage: emptyMessage);
}
