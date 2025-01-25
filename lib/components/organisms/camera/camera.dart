import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:two_oss/components/organisms/camera/camera_view_model.dart';
import 'package:two_oss/model/mvvm/widget_event_observer.dart';

class CameraWidget extends StatefulWidget {
  final CameraWidgetController controller;

  const CameraWidget({super.key, required this.controller});

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends WidgetEventObserver<CameraWidget> {
  CameraViewModel viewModel = CameraViewModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.controller.setCameraViewModel(viewModel);
    viewModel.subscribe(this);
  }

  @override
  Widget build(BuildContext context) {
    if (viewModel.cameraController == null) {
      return const CircularProgressIndicator();
    } else {
      return CameraPreview(viewModel.cameraController!);
    }
  }
}
