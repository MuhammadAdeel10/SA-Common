import 'package:flutter/services.dart';
import 'package:sa_common/utils/Helper.dart';

class DecimalTextInputFormatter extends TextInputFormatter {
  final int decimalRange = Helper.requestContext.decimalPlaces;
  final int maxLength;

  DecimalTextInputFormatter({this.maxLength = 12});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;

    if (newText.contains('.') && newText.indexOf('.') != newText.lastIndexOf('.')) {
      return oldValue;
    }

    final parts = newText.split('.');

    if (parts.length > 1 && parts[1].length > decimalRange) {
      return oldValue;
    }
    return newValue;
  }
}
