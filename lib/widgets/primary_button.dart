import 'package:flutter/material.dart';
import 'package:sa_common/utils/colors.dart';
import 'package:sa_common/utils/styles.dart';
 

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    Key? key,
    this.isActive = false,
    required this.text,
    required this.press,
    this.color = AppColors.primary,
    this.style = Styles.elevatedButtonTextStyle,
    this.minHeight = 50,
    this.minWidth,
    this.textAlign,
    this.maxLines,
  }) : super(key: key);

  final bool isActive;
  final String? text;
  final Function()? press;
  final Color? color;
  final TextStyle? style;
  final double? minHeight;
  final double? minWidth;
  final TextAlign? textAlign;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all<Size>(Size(minWidth ?? MediaQuery.sizeOf(context).width, minHeight ?? 50)),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(Styles.xsmallRadius))),
        backgroundColor: MaterialStateProperty.all(color),
      ),
      onPressed: isActive ? null : press,
      child: Text(
        text!,
        style: style ?? Styles.elevatedButtonTextStyle,
        textAlign: textAlign,
        maxLines: maxLines,
      ),
    );
  }
}
