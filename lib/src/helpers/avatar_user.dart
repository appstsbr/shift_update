import 'package:flutter/material.dart';

/// class [AvatarUser] responsavel pela formatação
/// do widget que formata a imagens de avatar vinda do servidor
class AvatarUser extends StatelessWidget {
  final String? src;
  final String? assetImg;
  final String name;
  final double size;
  const AvatarUser(
      {Key? key, this.src, this.name = " ", this.size = 50, this.assetImg})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String name2 = name == null ? " " : name;
    var urlPattern =
        r"^((?:.|\n)*?)((http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?)";
    var match = src != null
        ? new RegExp(urlPattern, caseSensitive: false).firstMatch(src!)
        : null;

    Widget child = match == null
        ? Container(
            child: Center(
                child: Text(
              name2[0],
              style: TextStyle(color: Colors.white),
            )),
            color: Theme.of(context).primaryColor)
        : Image.network(
            src!,
            fit: BoxFit.cover,
          );

    child = assetImg != null
        ? Image.asset(assetImg!, fit: BoxFit.scaleDown)
        : child;

    return Container(
      width: size,
      height: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(this.size),
        child: child,
      ),
    );
  }
}
