import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:two_oss/components/organisms/camera/camera.dart';
import 'package:two_oss/components/organisms/camera/camera_view_model.dart';
import 'package:two_oss/model/mvvm/widget_event_observer.dart';
import 'package:two_oss/pages/register/register_view_model.dart';
import 'package:image/image.dart' as imglib;

class RegisterView extends StatefulWidget {
  static String route = '/register';

  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends WidgetEventObserver<RegisterView> {
  CameraWidgetController controller = CameraWidgetController();
  late RegisterViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = RegisterViewModel(controller);
    viewModel.subscribe(this);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      CameraWidget(controller: controller),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () {
                viewModel.click(context);
              },
              child: Text("Photo")),
          if (viewModel.faceData != null)
            Image.memory(
                Uint8List.fromList(imglib.encodeJpg(viewModel.faceData!.image)))
          else
            Container(),
          if (viewModel.latestFace != null)
            Image.memory(Uint8List.fromList(
                imglib.encodeJpg(viewModel.latestFace!.image)))
          else
            Container()
        ],
      ),
    ]);
  }
}
