import 'package:flutter/material.dart';
import 'package:sa_common/utils/colors.dart';

class Styles {
  static const TextStyle elevatedButtonTextStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: "Poppins", fontSize: 14);

  static const EdgeInsets xsmallPadding = EdgeInsets.all(4);
  static const EdgeInsets smallPadding = EdgeInsets.all(8);
  static const EdgeInsets formPadding = EdgeInsets.all(12);
  static const EdgeInsets mediumPadding = EdgeInsets.all(16);
  static const EdgeInsets largePadding = EdgeInsets.all(32);
  static const EdgeInsets xLargePadding = EdgeInsets.all(64);
  static const EdgeInsets xxLargePadding = EdgeInsets.all(128);

  static const EdgeInsets xsmallMargin = EdgeInsets.all(4);
  static const EdgeInsets smallMargin = EdgeInsets.all(8);
  static const EdgeInsets mediumMargin = EdgeInsets.all(16);
  static const EdgeInsets largeMargin = EdgeInsets.all(32);
  static const EdgeInsets xLargeMargin = EdgeInsets.all(64);
  static const EdgeInsets xxLargeMargin = EdgeInsets.all(128);

  static const double smallIconSize = 16;
  static const double mediumIconSize = 24;
  static const double largeIconSize = 32;
  static const double xlargeIconSize = 64;
  static const double x2largeIconSize = 80;

  // custom sizes
  static const double loadingIconSize = 220;
  static const double appBarSize = 60;

  static const double xxsmallSize = 12;
  static const double xsmallSize = 14;
  static const double smallSize = 16;
  static const double mediumSize = 32;
  static const double largeSize = 64;
  static const double xlargeSize = 80;
  static const double x2largeSize = 96;
  static const double x3largeSize = 160;

  static const double xlabelSmallSize = 4;
  static const double labelSmallSize = 8;
  static const double labelMediumSize = 16;
  static const double labelLargeSize = 24;

  static const TextStyle deliveryFont = TextStyle(fontSize: Styles.xsmallSize, color: Colors.black, fontWeight: FontWeight.w500, fontFamily: "Poppins");
  static const TextStyle fontLarge = TextStyle(fontSize: Styles.largeSize, color: Colors.black, fontWeight: FontWeight.bold, fontFamily: "Poppins");
  static const TextStyle fontMedium = TextStyle(fontSize: Styles.mediumSize, color: Colors.black, fontWeight: FontWeight.w500, fontFamily: "Poppins");
  static const TextStyle fontSmall = TextStyle(fontSize: Styles.smallSize, color: Colors.black, fontWeight: FontWeight.w500, fontFamily: "Poppins");
  static const TextStyle fontSmallForForm = TextStyle(fontSize: Styles.smallSize, color: Colors.black, fontWeight: FontWeight.w400, fontFamily: "Poppins");
  static const TextStyle fontForDashboard = TextStyle(fontSize: Styles.xxsmallSize, color: Colors.black, fontWeight: FontWeight.w400, fontFamily: "Poppins");
  static const TextStyle labelLarge = TextStyle(fontSize: Styles.labelLargeSize, fontFamily: "Poppins");
  static const TextStyle labelMedium = TextStyle(fontSize: Styles.labelMediumSize, fontFamily: "Poppins");

  static const SizedBox xsmallVGap = SizedBox(height: 8);
  static const SizedBox xxsmallVGap = SizedBox(height: 16);
  static const SizedBox smallVGap = SizedBox(height: 24);
  static const SizedBox mediumVGap = SizedBox(height: 32);
  static const SizedBox largeVGap = SizedBox(height: 40);

  static const SizedBox xxsmallHGap = SizedBox(width: 8);
  static const SizedBox xsmallHGap = SizedBox(width: 16);
  static const SizedBox smallHGap = SizedBox(width: 24);
  static const SizedBox mediumHGap = SizedBox(width: 32);
  static const SizedBox largeHGap = SizedBox(width: 40);

  static const double xsmallRadius = 12;
  static const double smallRadius = 24;
  static const double mediumRadius = 40;
  static const double largeRadius = 64;
  static const double xlargeRadius = 80;

  /* <---- Input Decorations Theme -----> */
  static final defaultInputDecorationTheme = InputDecorationTheme(
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      filled: true,
      hintStyle: Styles.fontSmall.copyWith(color: AppColors.darkgray, fontSize: xsmallSize,fontFamily: "Poppins"),
      border: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: AppColors.darkgray),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: AppColors.darkgray),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: AppColors.primary),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      suffixIconColor: AppColors.grey,
      prefixIconColor: AppColors.grey);

  static const searchInputDecorationTheme = InputDecorationTheme(
      fillColor: Colors.white,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      hintStyle: TextStyle(color: AppColors.grey,fontFamily: "Poppins"),
      border: OutlineInputBorder(
        borderSide: BorderSide(width: 0.1),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 0.1),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: AppColors.primary),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      suffixIconColor: AppColors.grey,
      prefixIconColor: AppColors.grey);

  static const secondaryInputDecorationTheme = InputDecorationTheme(
    fillColor: Colors.white,
    filled: true,
    floatingLabelBehavior: FloatingLabelBehavior.never,
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
    focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
  );
}
