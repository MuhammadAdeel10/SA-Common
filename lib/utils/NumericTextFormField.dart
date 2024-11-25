import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sa_common/utils/Helper.dart';

class NumericTextFormField extends StatelessWidget {
  final FocusNode focusNode;
  final TextEditingController controller;
  final TextAlign textAlign;
  final bool isFractional;
  final int decimalRange;
  final Function(String)? onChanged;
  final VoidCallback? onTap;
  final InputDecoration? decoration;

  const NumericTextFormField({
    Key? key,
    required this.focusNode,
    required this.controller,
    this.textAlign = TextAlign.start,
    this.isFractional = false,
    this.decimalRange = 2,
    this.onChanged,
    this.onTap,
    this.decoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      controller: controller,
      textAlign: textAlign,
      style: GoogleFonts.openSans(
        color: Colors.black,
        fontSize: 13.5,
        fontWeight: FontWeight.normal,
      ),
      keyboardType: TextInputType.numberWithOptions(
        decimal: isFractional,
        signed: false,
      ),
      onTap: onTap,
      inputFormatters: [if (!isFractional) FilteringTextInputFormatter.digitsOnly],
      onChanged: (val) {
        if (Helper.AmountLengthCheck(input: val, lengthValue: 10, allowDecimal: isFractional, decimalPlaces: decimalRange, isEmptyAllowed: true)) {
          if (onChanged != null) {
            onChanged!(val);
          }
        } else {
          return;
        }
      },
      decoration: decoration ??
          InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.all(8),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(width: 1.3, color: Color(0xffdadfe6)),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: Color(0xffdadfe6)),
            ),
          ),
    );
  }
}
