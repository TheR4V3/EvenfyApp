// ignore_for_file: always_specify_types

import "package:flutter/material.dart";

class Navigators {
  static GlobalKey<NavigatorState> navigatorState = GlobalKey<NavigatorState>();

  static Future<T?> push<T extends Object?>(BuildContext context, Widget widget) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        settings: RouteSettings(
          name: widget.runtimeType.toString(),
        ),
        builder: (BuildContext context) {
          return widget;
        },
      ),
    );
  }

  static void pushReplacement(BuildContext context, Widget widget) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        settings: RouteSettings(
          name: widget.runtimeType.toString(),
        ),
        builder: (materialContext) {
          return widget;
        },
      ),
    );
  }

  static void pushAndRemoveAll(BuildContext context, Widget widget) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        settings: RouteSettings(
          name: widget.runtimeType.toString(),
        ),
        builder: (BuildContext context) {
          return widget;
        },
      ), (Route route) => false,
    );
  }

  static void pop(BuildContext context) {
    Navigator.of(context).pop(context);
  }

  static void popAll(BuildContext context) {
    Navigator.of(context).popUntil((Route route) => route.isFirst);
  }
}
