import 'package:two_oss/repositories/database/database_repository.dart';
import 'package:two_oss/repositories/face/face_detection_repository.dart';
import 'package:two_oss/repositories/face/face_recognition_repository.dart';
import 'package:two_oss/repositories/notifications_repository.dart';
import 'package:two_oss/services/database_service.dart';
import 'package:two_oss/services/face_service.dart';
import 'package:two_oss/transformers/example_transformer.dart';
import 'package:get_it/get_it.dart';

/// Provider for the transformers, the repositories and the services.
///
/// This class is responsible for initializing the objects and register them into the GetIt instance.
///
/// Every subclasses register their own transformers, repositories and services.
class Provider {
  final getIt = GetIt.instance;

  Provider() {
    initTransformers();
    initRepositories();
    initServices();
  }

  initTransformers() {
    getIt.registerSingleton<ExampleTransformer>(ExampleTransformer());
  }

  initRepositories() {
    getIt.registerSingleton<DatabaseRepository>(DatabaseRepository());
    getIt.registerSingleton<FaceDetectionRepository>(FaceDetectionRepository());
    getIt.registerSingleton<FaceRecognitionRepository>(FaceRecognitionRepository());
    // getIt.registerSingleton<NotificationsRepository>(NotificationsRepository());
  }

  initServices() {
    getIt.registerSingleton<DatabaseService>(DatabaseService());
    getIt.registerSingleton<FaceService>(FaceService());
  }
}
