import 'package:flutter/material.dart';

class LoadingButton extends StatelessWidget {
  static const int completed = 2;
  static const int load = 1;
  static const int init = 0;
  final Widget child;
  final Color color;
  final Color textColor;
  final ShapeBorder shape;
  final onPressed;
  final int state;
  final double width;
  final double height;
  final bool resizeOnLoad;

  LoadingButton(
      {Key? key,
      required this.child,
      required this.onPressed,
      required this.color,
      required this.textColor,
      required this.state,
      required this.shape,
      required this.width,
      required this.height,
      this.resizeOnLoad = true})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      child: RaisedButton(
          color: color,
          textColor: textColor,
          onPressed: onPressed,
          child: childState(),
          shape: shape),
      duration: Duration(milliseconds: durationState()),
      width: size(),
      height: this.height,
    );
  }

  double size() {
    if (state == load && resizeOnLoad) {
      if (width > 80)
        return 80;
      else
        return width;
    } else
      return this.width;
  }

  int durationState() {
    if (state != init)
      return 200;
    else
      return 0;
  }

  Widget childState() {
    switch (state) {
      case init:
        return child;
        break;
      case load:
        return CircularProgressIndicator(
            backgroundColor: textColor,
            valueColor: AlwaysStoppedAnimation<Color>(color));
        break;
      case completed:
        return Icon(Icons.check, color: textColor);
        break;
      default:
        return child;
    }
  }
}
