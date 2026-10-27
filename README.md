# india_validators

[![pub package](https://img.shields.io/pub/v/india_validators.svg)](https://pub.dev/packages/india_validators)
[![pub points](https://img.shields.io/pub/points/india_validators)](https://pub.dev/packages/india_validators/score)
[![likes](https://img.shields.io/pub/likes/india_validators)](https://pub.dev/packages/india_validators/score)
[![CI](https://github.com/ChandraChaan/india_validators/actions/workflows/ci.yml/badge.svg)](https://github.com/ChandraChaan/india_validators/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

Validate, parse and format the identifiers every Indian app asks for: **PAN, GSTIN, Aadhaar, IFSC, UPI ID, mobile number and PIN code**.

It does more than a regex:

- **Real checksums:** a GSTIN's check character (base 36) and an Aadhaar number's Verhoeff digit, so typos are caught before you call an API
- **Typed details:** the state from a GSTIN, the holder type from a PAN, the bank from an IFSC, the postal zone from a PIN code
- **Ready for Flutter forms:** drop-in `TextFormField` validators with messages you can override
- **Forgiving input:** handles lower case, spaces, hyphens, `+91` and leading zeros the way people actually type them
- **Pure Dart, no dependencies:** works in Flutter apps, on the server and on the web

```dart
final gstin = Gstin.tryParse('27AAPFU0939F1ZV');
print(gstin?.state);            // Maharashtra
print(gstin?.pan.holderType);   // PanHolderType.firm

print(Aadhaar.tryParse('2341 2341 2346')?.masked);  // XXXX XXXX 2346
print(IndianMobile.tryParse('098765-43210')?.e164); // +919876543210
```

## Install

```bash
dart pub add india_validators
```

## What's supported

| Identifier | Class | Checks | Gives you |
|---|---|---|---|
| PAN | `Pan` | Format, holder type | `holderType` (individual, company, firm, trust…) |
| GSTIN | `Gstin` | Format, state code, embedded PAN, **check character** | `state`, `stateCode`, `pan`, `entityCode` |
| Aadhaar | `Aadhaar` | Format, **Verhoeff check digit** | `formatted`, `masked` |
| IFSC | `Ifsc` | Format | `bankCode`, `branchCode` |
| UPI ID | `UpiId` | Format | `username`, `handle` |
| Mobile number | `IndianMobile` | Format, 6–9 start | `e164`, `formatted`, `nationalNumber` |
| PIN code | `Pincode` | Format | `zone` (India Post postal zone) |

Every class has `tryParse(input)`, which returns null for invalid input, and `isValid(input)`.

## Flutter forms

`IndiaValidators` has a validator for each identifier, shaped for `TextFormField`:

```dart
Form(
  child: Column(
    children: [
      TextFormField(
        decoration: const InputDecoration(labelText: 'PAN'),
        validator: IndiaValidators.pan,
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'GSTIN (optional)'),
        validator: (value) => IndiaValidators.gstin(value, required: false),
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Mobile'),
        keyboardType: TextInputType.phone,
        validator: (value) => IndiaValidators.mobile(
          value,
          message: 'Please enter a 10-digit mobile number',
        ),
      ),
    ],
  ),
)
```

Each validator returns null when the value is fine, and otherwise an error message. Pass `message` and `emptyMessage` to use your own wording or another language.

## What validation can and can't tell you

These checks catch typos and malformed input on the device, for free and instantly. They **can't** tell you that a PAN, GSTIN, Aadhaar number, bank branch or UPI account actually exists or belongs to the user. For that, use the official verification APIs (the GST portal, NSDL/UTIITSL for PAN, UIDAI-authorised KYC providers, your payment gateway).

A few specifics:

- **PAN:** the Income Tax Department doesn't publish the algorithm for the last character, so only the format and holder type are checked.
- **GSTIN:** covers regular taxpayer GSTINs. Special formats, such as UINs for embassies, non-resident taxpayers and TDS/TCS registrations, aren't accepted.
- **Aadhaar:** the Verhoeff digit catches every single-digit typo and every swap of two neighbouring digits. Aadhaar numbers are sensitive: `toString()` returns the masked form so they don't end up in logs by accident. Show `masked`, and only store `value` if you must and are allowed to.

## Contributing

Issues and pull requests are welcome, especially new identifiers (vehicle registration, voter ID, passport) with references for their format.

## About the author

Built by [Chandra ObulaReddy](https://chandrachaan.com), a Flutter architect who has shipped FinTech, HRMS and e-commerce apps across India.
