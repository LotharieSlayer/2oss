import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:two_oss/components/organisms/camera/camera.dart';
import 'package:two_oss/components/organisms/camera/camera_view_model.dart';
import 'package:two_oss/model/mvvm/widget_event_observer.dart';
import 'package:two_oss/pages/auth_stage/auth_stage_view_model.dart';
import 'package:image/image.dart' as imglib;

class AuthStageView extends StatefulWidget {
  static String route = '/authStage';

  const AuthStageView({super.key});

  @override
  State<AuthStageView> createState() => _AuthStageViewState();
}

class _AuthStageViewState extends WidgetEventObserver<AuthStageView> {
  CameraWidgetController controller = CameraWidgetController();
  late AuthStageViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = AuthStageViewModel(controller);
    viewModel.subscribe(this);
    viewModel.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      CameraWidget(controller: controller),
      // Row(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     ElevatedButton(
      //         onPressed: () {
      //           viewModel.click(context);
      //         },
      //         child: Text("Photo")),
      //     if (viewModel.faceData != null)
      //       Image.memory(
      //           Uint8List.fromList(imglib.encodeJpg(viewModel.faceData!.image)))
      //     else
      //       Container(),
      //     if (viewModel.latestFace != null)
      //       Image.memory(Uint8List.fromList(
      //           imglib.encodeJpg(viewModel.latestFace!.image)))
      //     else
      //       Container()
      //   ],
      // ),
    ]);
  }
}
