import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image/image.dart' as imglib;

class FaceDetectionRepository {
  Future<FaceData?> getFaceData(CameraImage cameraImage) async {
    final faceDetector = FaceDetector(options: FaceDetectorOptions());

    Uint8List imageData = _convertYUV420ToNV21(cameraImage);
    final faces = await faceDetector.processImage(InputImage.fromBytes(
        bytes: imageData,
        metadata: InputImageMetadata(
            size: Size(cameraImage.width.toDouble(), cameraImage.height.toDouble()),
            rotation: InputImageRotation.rotation90deg,
            format: InputImageFormat.nv21,
            bytesPerRow: cameraImage.width)));
    if (faces.isNotEmpty) {
      var image = _convertYUV420ToImage(cameraImage);
      var croppedImage = imglib.copyCrop(imglib.copyRotate(image, angle: 90),
          x: faces[0].boundingBox.topLeft.dx.toInt(),
          y: faces[0].boundingBox.topLeft.dy.toInt(),
          width: faces[0].boundingBox.bottomRight.dx.toInt() - faces[0].boundingBox.topLeft.dx.toInt(),
          height: faces[0].boundingBox.bottomRight.dy.toInt() - faces[0].boundingBox.topLeft.dy.toInt());
      return FaceData(croppedImage, faces[0]);
    } else {
      return null;
    }
  }

  Uint8List _convertYUV420ToNV21(CameraImage image) {
    final width = image.width;
    final height = image.height;

    // Planes from CameraImage
    final yPlane = image.planes[0];
    final uPlane = image.planes[1];
    final vPlane = image.planes[2];

    // Buffers from Y, U, and V planes
    final yBuffer = yPlane.bytes;
    final uBuffer = uPlane.bytes;
    final vBuffer = vPlane.bytes;

    // Total number of pixels in NV21 format
    final numPixels = width * height + (width * height ~/ 2);
    final nv21 = Uint8List(numPixels);

    // Y (Luma) plane metadata
    int idY = 0;
    int idUV = width * height; // Start UV after Y plane
    final uvWidth = width ~/ 2;
    final uvHeight = height ~/ 2;

    // Strides and pixel strides for Y and UV planes
    final yRowStride = yPlane.bytesPerRow;
    final yPixelStride = yPlane.bytesPerPixel ?? 1;
    final uvRowStride = uPlane.bytesPerRow;
    final uvPixelStride = uPlane.bytesPerPixel ?? 2;

    // Copy Y (Luma) channel
    for (int y = 0; y < height; ++y) {
      final yOffset = y * yRowStride;
      for (int x = 0; x < width; ++x) {
        nv21[idY++] = yBuffer[yOffset + x * yPixelStride];
      }
    }

    // Copy UV (Chroma) channels in NV21 format (YYYYVU interleaved)
    for (int y = 0; y < uvHeight; ++y) {
      final uvOffset = y * uvRowStride;
      for (int x = 0; x < uvWidth; ++x) {
        final bufferIndex = uvOffset + (x * uvPixelStride);
        nv21[idUV++] = vBuffer[bufferIndex]; // V channel
        nv21[idUV++] = uBuffer[bufferIndex]; // U channel
      }
    }

    return nv21;
  }

  imglib.Image _convertYUV420ToImage(CameraImage cameraImage) {
    final imageWidth = cameraImage.width;
    final imageHeight = cameraImage.height;

    final yBuffer = cameraImage.planes[0].bytes;
    final uBuffer = cameraImage.planes[1].bytes;
    final vBuffer = cameraImage.planes[2].bytes;

    final int yRowStride = cameraImage.planes[0].bytesPerRow;
    final int yPixelStride = cameraImage.planes[0].bytesPerPixel!;
    final int uvRowStride = cameraImage.planes[1].bytesPerRow;
    final int uvPixelStride = cameraImage.planes[1].bytesPerPixel!;

    final image = imglib.Image(width: imageWidth, height: imageHeight);

    for (int h = 0; h < imageHeight; h++) {
      int uvh = (h / 2).floor();

      for (int w = 0; w < imageWidth; w++) {
        int uvw = (w / 2).floor();

        final yIndex = (h * yRowStride) + (w * yPixelStride);

        final int y = yBuffer[yIndex];

        final int uvIndex = (uvh * uvRowStride) + (uvw * uvPixelStride);

        final int u = uBuffer[uvIndex];
        final int v = vBuffer[uvIndex];

        int r = (y + v * 1436 / 1024 - 179).round().clamp(0, 255);
        int g = (y - u * 46549 / 131072 + 44 - v * 93604 / 131072 + 91).round().clamp(0, 255);
        int b = (y + u * 1814 / 1024 - 227).round().clamp(0, 255);

        image.setPixelRgb(w, h, r, g, b);
      }
    }

    return image;
  }
}

class FaceData {
  final imglib.Image image;
  final Face face;

  FaceData(this.image, this.face);
}
