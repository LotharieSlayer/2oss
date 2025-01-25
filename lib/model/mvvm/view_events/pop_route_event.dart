import 'package:flutter/material.dart';
import 'package:two_oss/model/mvvm/view_event.dart';

/// Event to pop the current route.
class PopRouteEvent extends ViewEvent {
  const PopRouteEvent();

  @override
  void execute(context) {
    Navigator.of(context).pop();
  }
}
