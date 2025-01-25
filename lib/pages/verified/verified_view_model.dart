import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:two_oss/model/mvvm/view_model.dart';
import 'package:two_oss/pages/ask_login/ask_login_view.dart';

class VerifiedViewModel extends EventViewModel {

  VerifiedViewModel();

  Future<void> init(BuildContext context) async {
    // Wait 5 seconds then go to VerifiedView page, using Navigator
    Future.delayed(const Duration(seconds: 3), () {
      // Close app
      // Navigator.of(context).popUntil((route) => route.isFirst);
      // SystemNavigator.pop();
      Navigator.pushNamed(context, AskLoginView.route);
    });
  }
}
