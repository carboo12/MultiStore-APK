import 'package:flutter/services.dart';

/// Formats the input to a US-style phone number: (XXX) XXX-XXXX
class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text;
    final oldText = oldValue.text;

    // Get only the digits from the new value.
    final digitsOnly = newText.replaceAll(RegExp(r'\D'), '');
    final charCount = digitsOnly.length;

    // If the user is deleting, the default behavior is fine.
    if (newText.length < oldText.length) {
      return newValue;
    }

    // Don't allow more than 10 digits.
    if (charCount > 10) {
      return oldValue;
    }

    var formattedText = StringBuffer();

    if (charCount > 0) {
      formattedText.write(
        '(${digitsOnly.substring(0, charCount > 3 ? 3 : charCount)}',
      );
    }
    if (charCount > 3) {
      formattedText.write(
        ') ${digitsOnly.substring(3, charCount > 6 ? 6 : charCount)}',
      );
    }
    if (charCount > 6) {
      formattedText.write('-${digitsOnly.substring(6, charCount)}');
    }

    final resultText = formattedText.toString();
    return TextEditingValue(
      text: resultText,
      selection: TextSelection.collapsed(offset: resultText.length),
    );
  }
}
