import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

part 'photo_app_state.dart';

// class PhotoAppCubit extends Cubit<PhotoAppState> {
//   PhotoAppCubit() : super(PhotoAppInitial());
// }

class PhotoAppCubit extends Cubit<PhotoAppState> {
  PhotoAppCubit() : super(const SelectProfilePhotoState());

  CameraController? controller;
  late Timer _periodicTimer;

  bool isStreaming = false;

  void startStream() {
    if (!isStreaming) {
      startPeriodicPictureCapture(const Duration(milliseconds: 250));
      isStreaming = true;
    } else {
      stopPeriodicPictureCapture();
      isStreaming = false;
    }
  }

  void openCamera() async {
    final cameras = await availableCameras();
    controller = CameraController(cameras.first, ResolutionPreset.high);
    await controller!.initialize();
    emit(CameraState(controller: controller!, camera: controller!.description));
  }

  Future<XFile?> takePicture() async {
    if (controller == null || !controller!.value.isInitialized) {
      // Camera is not initialized
      return null;
    }

    try {
      final XFile file = await controller!.takePicture();
      // final Uint8List bytes = await file.readAsBytes();
      // String base64String = base64Encode(bytes);

      // print("GGGGGGGGGGGG" + base64String);
      return file;
    } catch (e) {
      // Error while taking picture
      print('Error taking picture: $e');
      return null;
    }
  }

  void startPeriodicPictureCapture(Duration interval) {
    _periodicTimer = Timer.periodic(interval, (timer) async {
      final XFile? file = await takePicture();
      if (file != null) {
        final Uint8List bytes = await file.readAsBytes();
        String base64String = base64Encode(bytes);
        // Handle the picture file here ( send via WebSocket)

        final _channel = WebSocketChannel.connect(
          Uri.parse('ws://192.168.1.118:8765/socket.io/'),
        );
        Map<String, dynamic> data = {
          'collection_name': 'maggy',
          "image": base64String
        };
        String jsonData = jsonEncode(data);
        _channel.sink.add(jsonData);

        // Listen for response from the server
        _channel.stream.listen((dynamic response) {
          debugPrint("Response from server: $response");
        }, onDone: () {
          debugPrint("WebSocket connection closed.");
          _channel.sink.close();
        }, onError: (error) {
          debugPrint("WebSocket error: $error");
        });
        // For demonstration, print the path of the captured picture
        debugPrint('Captured picture: ${base64String}');
      }
    });
  }

  void stopPeriodicPictureCapture() {
    _periodicTimer.cancel();
  }

  void switchCameraOptions({
    required bool isBackCam,
    ResolutionPreset? resolutionPreset,
  }) async {
    if (controller == null || !controller!.value.isInitialized) {
      return;
    }

    final cameras = await availableCameras();
    final newCamera = isBackCam ? cameras.first : cameras.last;
    final newController =
        CameraController(newCamera, resolutionPreset ?? ResolutionPreset.high);

    await newController.initialize();
    controller!.dispose(); // Dispose the current controller
    controller = newController;

    emit(CameraState(
        controller: newController, camera: newController.description));
  }

  void selectPhoto({required File file}) {
    emit(SelectProfilePhotoState(file: file));
  }
}
