import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as imglib;

class FaceRecognitionRepository {

  Interpreter? interpreter = null;

  FaceRecognitionRepository() {
    Interpreter.fromAsset('assets/mobilefacenet.tflite')
    .then((Interpreter interpreter) {
      this.interpreter = interpreter;
    });
  }

  List<dynamic> imageOutput(imglib.Image image) {
    final convertedImage = imglib.copyResizeCropSquare(image, size: 112);

    final list = _imageToByteListFloat32(convertedImage);

    var output = List.generate(1, (index) => List.filled(192, 0.0)).reshape([1, 192]);
    interpreter!.run(list.reshape([1, 112, 112, 3]), output);
    final reshapedOutput = output.reshape([192]);
    return reshapedOutput as List<dynamic>;
  }

  bool compareFace(List<dynamic> e1, List<dynamic> e2) {
    double distance = _euclideanDistance(e1, e2);
    print("DISTANCE EUCLIDIENNE");
    print(distance);
    return distance < 0.75;
  }

  Float32List _imageToByteListFloat32(imglib.Image image) {
    var convertedBytes = Float32List(1 * 112 * 112 * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;

    for (var i = 0; i < 112; i++) {
      for (var j = 0; j < 112; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = (pixel.r - 128) / 128;
        buffer[pixelIndex++] = (pixel.g - 128) / 128;
        buffer[pixelIndex++] = (pixel.b - 128) / 128;
      }
    }
    return convertedBytes.buffer.asFloat32List();
  }

  double _euclideanDistance(List? e1, List? e2) {
    if (e1 == null || e2 == null) throw Exception("Null argument");

    double sum = 0.0;
    for (int i = 0; i < e1.length; i++) {
      sum += pow((e1[i] - e2[i]), 2);
    }
    return sqrt(sum);
  }
}
