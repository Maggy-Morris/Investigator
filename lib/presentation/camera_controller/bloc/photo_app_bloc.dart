import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../core/models/search_by_image_model.dart';

part 'photo_app_event.dart';
part 'photo_app_state.dart';

class PhotoAppBloc extends Bloc<PhotoAppEvent, PhotoAppState> {
  static PhotoAppBloc get(context) => BlocProvider.of<PhotoAppBloc>(context);

  CameraController? controller;
  late Timer _periodicTimer;

  bool isStreaming = false;

  PhotoAppBloc() : super(PhotoAppState()) {
    on<PhotoAppEvent>(_onPhotoAppEvent);

    on<OpenCameraEvent>(_onOpenCameraEvent);
    on<SwitchCameraOptions>(_onSwitchCameraOptions);
    on<SelectPhoto>(_onSelectPhoto);

    on<StartStreamEvent>(_onStartStreamEvent);

    on<StopPeriodicPictureCapture>(_onStopPeriodicPictureCapture);
  }

  _onPhotoAppEvent(PhotoAppEvent event, Emitter<PhotoAppState> emit) {}

  _onOpenCameraEvent(OpenCameraEvent event, Emitter<PhotoAppState> emit) async {
// void openCamera() async {
    final cameras = await availableCameras();
    controller = CameraController(cameras.first, ResolutionPreset.high);
    await controller!.initialize();
    emit(CameraState(controller: controller!, camera: controller!.description));
    // }
  }

  _onSelectPhoto(SelectPhoto event, Emitter<PhotoAppState> emit) {
    emit(SelectProfilePhotoState(file: event.file));
  }

  _onStopPeriodicPictureCapture(
      StopPeriodicPictureCapture event, Emitter<PhotoAppState> emit) {
    _periodicTimer.cancel();
  }

  _onSwitchCameraOptions(
      SwitchCameraOptions event, Emitter<PhotoAppState> emit) async {
    //        void switchCameraOptions({
    // })
    // async {
    if (controller == null || !controller!.value.isInitialized) {
      return;
    }

    final cameras = await availableCameras();
    final newCamera = event.isBackCam ? cameras.first : cameras.last;
    final newController = CameraController(
        newCamera, event.resolutionPreset ?? ResolutionPreset.high);

    await newController.initialize();
    controller!.dispose(); // Dispose the current controller
    controller = newController;

    emit(CameraState(
        controller: newController, camera: newController.description));
    // }
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

  Future<SearchByImageModel> startPeriodicPictureCapture(
      Duration interval) async {
    _periodicTimer = Timer.periodic(
      interval,
      (timer) async {
        final XFile? file = await takePicture();
        if (file != null) {
          final Uint8List bytes = await file.readAsBytes();
          String base64String = base64Encode(bytes);

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
          _channel.stream.listen(
            (dynamic response) {
              if (response.isNotEmpty) {
                SearchByImageModel callBackList =
                    SearchByImageModel.fromJson(response);

                debugPrint("Response from server: $response");
                emit(CameraState(
                    boxes: callBackList.boxes, result: callBackList.result));
              }
            },
            onDone: () {
              debugPrint("WebSocket connection closed.");
              // You might want to handle this event as per your requirements
            },
            onError: (error) {
              debugPrint("WebSocket error: $error");
            },
          );
          debugPrint('Captured picture: ${base64String}');
        }
      },
    );

    return SearchByImageModel();
  }






  void stopPeriodicPictureCapture() {
    _periodicTimer.cancel();
  }

  _onStartStreamEvent(StartStreamEvent event, Emitter<PhotoAppState> emit) {
    if (!isStreaming) {
      startPeriodicPictureCapture(const Duration(milliseconds: 250));
      isStreaming = true;
    } else {
      stopPeriodicPictureCapture();
      isStreaming = false;
    }
  }



}
