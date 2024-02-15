import 'package:flutter/material.dart';

/// class generica [ProfileAnimations] responsavel pelas animações
/// durante a obetação de imagens vindas, para response post para o servidor

class ProfileAnimations {
  AnimationController control;
  Animation? scale1;
  Animation? scale2;
  Animation? scale3;
  Animation? scale4;
  ProfileAnimations({required this.control}) {
    scale1 = Tween<double>(begin: 0.01, end: 1).animate(
      CurvedAnimation(
        parent: control,
        curve: Interval(
          0,
          0.2,
          curve: Curves.fastLinearToSlowEaseIn,
        ),
      ),
    );
    scale2 = Tween<double>(begin: 0.01, end: 1).animate(
      CurvedAnimation(
        parent: control,
        curve: Interval(
          0.2,
          0.4,
          curve: Curves.fastLinearToSlowEaseIn,
        ),
      ),
    );
    scale3 = Tween<double>(begin: 0.01, end: 1).animate(
      CurvedAnimation(
        parent: control,
        curve: Interval(
          0.4,
          0.6,
          curve: Curves.fastLinearToSlowEaseIn,
        ),
      ),
    );
    scale4 = Tween<double>(begin: 0.01, end: 1).animate(
      CurvedAnimation(
        parent: control,
        curve: Interval(
          0.6,
          0.8,
          curve: Curves.fastLinearToSlowEaseIn,
        ),
      ),
    );
  }
}
