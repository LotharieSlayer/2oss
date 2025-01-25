import 'dart:async';

import 'package:camera/camera.dart';
import 'package:get_it/get_it.dart';
import 'package:two_oss/model/mvvm/view_model.dart';
import 'package:two_oss/repositories/face/face_detection_repository.dart';
import 'package:two_oss/services/face_service.dart';

class CameraViewModel extends EventViewModel {
  final GetIt getIt = GetIt.instance;
  CameraController? cameraController;

  late FaceService faceService;

  CameraViewModel({FaceService? faceService}) {
    this.faceService = faceService ?? getIt.get<FaceService>();
    init();
  }

  Future<void> init() async {
    List<CameraDescription> cameras = await availableCameras();
    final CameraController cameraController = CameraController(
      cameras[0],
      ResolutionPreset.low,
    );
    await cameraController.initialize();
    this.cameraController = cameraController;
    notify();
  }
}

class CameraWidgetController {
  CameraViewModel? viewModel;

  void setCameraViewModel(CameraViewModel viewModel) {
    this.viewModel = viewModel;
  }

  void dispose() {
    viewModel = null;
  }

  Future<FaceData> getFace() async {
    Completer<FaceData> completer = Completer();
    viewModel!.cameraController!.startImageStream((image) async {
      FaceData? faceData = await viewModel!.faceService.findFace(image);
      if (faceData != null && !completer.isCompleted) {
        completer.complete(faceData);
        viewModel!.cameraController!.stopImageStream();
      }
    });
    return completer.future;
  }
}

class CameraFace {}
