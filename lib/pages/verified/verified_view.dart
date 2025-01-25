import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:two_oss/model/mvvm/widget_event_observer.dart';
import 'package:two_oss/pages/verified/verified_view_model.dart';

class VerifiedView extends StatefulWidget {
  static String route = '/verified';

  const VerifiedView({super.key});

  @override
  State<VerifiedView> createState() => _VerifiedViewState();
}

class _VerifiedViewState extends WidgetEventObserver<VerifiedView> {
  late VerifiedViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = VerifiedViewModel();
    viewModel.subscribe(this);
    viewModel.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Colors.blue,
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Text("C'est validé !", style: TextStyle(fontSize: 60, color: Colors.white)),
                ]))));
  }
}
