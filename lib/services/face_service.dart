
import 'package:camera/camera.dart';
import 'package:get_it/get_it.dart';
import 'package:two_oss/model/class/person.dart';
import 'package:two_oss/repositories/face/face_detection_repository.dart';
import 'package:two_oss/repositories/face/face_recognition_repository.dart';
import 'package:image/image.dart' as imglib;
import 'package:two_oss/services/database_service.dart';

class FaceService {
  GetIt _getIt = GetIt.instance;
  late FaceDetectionRepository _faceDetectionRepository;
  late FaceRecognitionRepository _faceRecognitionRepository;

  FaceService({FaceDetectionRepository? faceRepository, FaceRecognitionRepository? faceRecognitionRepository}) {
    _faceDetectionRepository = faceRepository ?? _getIt.get<FaceDetectionRepository>();
    _faceRecognitionRepository = faceRecognitionRepository ?? _getIt.get<FaceRecognitionRepository>();
  }

  Future<FaceData?> findFace(CameraImage cameraImage) {
    return _faceDetectionRepository.getFaceData(cameraImage);
  }

  Future<bool> compareFace(imglib.Image image2) async {
    GetIt getIt = GetIt.instance;
    DatabaseService databaseService = getIt.get<DatabaseService>();
    List<double> output = (await databaseService.getRegisteredPerson())!.biometricData;
    List<double> output2 = _faceRecognitionRepository.imageOutput(image2).cast<double>();
    print("Second output : ${output2.length}");
    return _faceRecognitionRepository.compareFace(output, output2);
  }

  Person returnPersonFromFace(imglib.Image image) {
    return Person("Lothaire", _faceRecognitionRepository.imageOutput(image).cast<double>());
  }
}
