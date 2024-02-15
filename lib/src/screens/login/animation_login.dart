import 'package:flutter/material.dart';
import 'package:shift_flutter/src/CustomTheme.dart';

/// class [LoginAnimations] generica para animações explicitas no
/// campo de login durante requisição
class LoginAnimations {
  AnimationController control;
  late Animation logoColor;
  late Animation logoSize;
  late Animation shiftSize;
  late Animation formHeight;
  late Animation formWidth;
  late Animation buttonWidth;
  late Animation buttonHeight;
  late Animation scale;

  LoginAnimations({required this.control}) {
    logoColor =
        ColorTween(begin: Colors.white, end: CustomTheme.shift().primaryColor)
            .animate(
      CurvedAnimation(
        parent: control,
        curve: Interval(
          0,
          0.5,
          curve: Curves.easeIn,
        ),
      ),
    );
    logoSize = Tween<double>(begin: 200.0, end: 100.0).animate(
      CurvedAnimation(
        parent: control,
        curve: Interval(
          0.500,
          0.7,
          curve: Curves.fastLinearToSlowEaseIn,
        ),
      ),
    );
    shiftSize = Tween<double>(begin: 0, end: 20).animate(
      CurvedAnimation(
        parent: control,
        curve: Interval(
          0.9,
          1,
          curve: Curves.ease,
        ),
      ),
    );
    formHeight = Tween<double>(begin: 0, end: 200.0).animate(
      CurvedAnimation(
        parent: control,
        curve: Interval(
          0.6,
          0.7,
          curve: Curves.ease,
        ),
      ),
    );
    formWidth = Tween<double>(begin: 0, end: 300.0).animate(
      CurvedAnimation(
        parent: control,
        curve: Interval(
          0.7,
          0.8,
          curve: Curves.ease,
        ),
      ),
    );
    buttonWidth = Tween<double>(begin: 0, end: 300.0).animate(
      CurvedAnimation(
        parent: control,
        curve: Interval(
          0.8,
          0.9,
          curve: Curves.ease,
        ),
      ),
    );
    buttonHeight = Tween<double>(begin: 0, end: 50.0).animate(
      CurvedAnimation(
        parent: control,
        curve: Interval(
          0.85,
          0.95,
          curve: Curves.ease,
        ),
      ),
    );

    scale = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: control,
        curve: Interval(
          0.8,
          0.9,
          curve: Curves.ease,
        ),
      ),
    );
  }
}
