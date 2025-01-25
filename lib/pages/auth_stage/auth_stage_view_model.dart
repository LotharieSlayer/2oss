import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:two_oss/components/organisms/camera/camera_view_model.dart';
import 'package:two_oss/main.dart';
import 'package:two_oss/model/mvvm/view_model.dart';
import 'package:two_oss/pages/verified/verified_view.dart';
import 'package:two_oss/repositories/face/face_detection_repository.dart';
import 'package:two_oss/services/face_service.dart';

class AuthStageViewModel extends EventViewModel {
  GetIt getIt = GetIt.instance;
  FaceData? faceData = null;
  FaceData? latestFace = null;

  late FaceService faceService;
  late CameraWidgetController controller;

  AuthStageViewModel(this.controller, {FaceService? faceService}) {
    this.faceService = faceService ?? getIt.get<FaceService>();
  }

  Future<void> init(BuildContext context) async {
    // toutes les 3 secondes, on prend une photo
    Timer.periodic(Duration(seconds: 1), (timer) async {
      print("Comparing faces");
      FaceData faceData2 = await controller.getFace();
      latestFace = faceData2;

      bool isTheRightPerson = await faceService.compareFace(faceData2.image);
      if (isTheRightPerson) {
        print("The right person, unlocking...");
        webSocketService.sendMessage('yes');
        Navigator.pushNamed(context, VerifiedView.route);
      } else {
        print("Not the right person");
      }
      notify();
    });
  }

  Future<void> click(BuildContext context) async {
    print("Comparing faces");
    FaceData faceData2 = await controller.getFace();
    latestFace = faceData2;

    bool isTheRightPerson = await faceService.compareFace(faceData2.image);
    if (isTheRightPerson) {
      print("The right person, unlocking...");
      webSocketService.sendMessage('yes');
      Navigator.pushNamed(context, VerifiedView.route);
    } else {
      print("Not the right person");
    }
    notify();
  }
}
