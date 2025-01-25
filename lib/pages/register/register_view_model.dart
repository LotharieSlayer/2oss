import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:two_oss/components/organisms/camera/camera_view_model.dart';
import 'package:two_oss/main.dart';
import 'package:two_oss/model/mvvm/view_model.dart';
import 'package:two_oss/pages/verified/verified_view.dart';
import 'package:two_oss/repositories/face/face_detection_repository.dart';
import 'package:two_oss/services/database_service.dart';
import 'package:two_oss/services/face_service.dart';

class RegisterViewModel extends EventViewModel {
  GetIt getIt = GetIt.instance;
  FaceData? faceData = null;
  FaceData? latestFace = null;

  late FaceService faceService;
  late CameraWidgetController controller;

  RegisterViewModel(this.controller, {FaceService? faceService}) {
    this.faceService = faceService ?? getIt.get<FaceService>();
    init();
  }

  Future<void> init() async {
    // // Wait 5 seconds
    // await Future.delayed(Duration(seconds: 5));
    // FaceData faceData = await controller.getFace();
    // print(faceData);
    // await Future.delayed(Duration(seconds: 5));
  }

  Future<void> click(BuildContext context) async {
    if (faceData == null) {
      faceData = await controller.getFace();
      notify();
      GetIt getIt = GetIt.instance;
      DatabaseService databaseService = getIt.get<DatabaseService>();
      FaceService faceService = getIt.get<FaceService>();
      await databaseService.registerPerson(faceService.returnPersonFromFace(faceData!.image));
      Navigator.pushNamed(context, VerifiedView.route);
    }
  }
}
