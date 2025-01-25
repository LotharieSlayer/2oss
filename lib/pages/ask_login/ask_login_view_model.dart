import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:two_oss/components/organisms/camera/camera_view_model.dart';
import 'package:two_oss/main.dart';
import 'package:two_oss/model/mvvm/view_model.dart';
import 'package:two_oss/pages/auth_stage/auth_stage_view.dart';
import 'package:two_oss/pages/register/register_view.dart';
import 'package:two_oss/repositories/face/face_detection_repository.dart';
import 'package:two_oss/services/face_service.dart';

class AskLoginViewModel extends EventViewModel {
  GetIt getIt = GetIt.instance;
  FaceData? faceData = null;
  FaceData? latestFace = null;

  late FaceService faceService;
  late CameraWidgetController controller;

  AskLoginViewModel();

  Future<void> clickNo() async {
    print('clickNo');
    print(webSocketService);
    webSocketService.sendMessage('no');
  }

  Future<void> clickYes(BuildContext context) async {
    // push to RegisterView
    Navigator.pushNamed(context, AuthStageView.route);
  }
}
