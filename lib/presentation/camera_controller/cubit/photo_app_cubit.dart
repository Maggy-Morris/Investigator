// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:Investigator/core/models/search_in_stream.dart';
// import 'package:Investigator/core/remote_provider/remote_data_source.dart';
// import 'package:camera/camera.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import '../../../authentication/authentication_repository.dart';
// import '../../../core/enum/enum.dart';
// part 'photo_app_state.dart';

// class PhotoAppCubit extends Cubit<PhotoAppState> {
//   PhotoAppCubit()
//       : super(
//           PhotoAppState(
//             isLoading: false,
//             hasError: false,
//             isChosen: false,
//             securityBreachChecked: false,
//             submission: Submission.initial,
//             controller: CameraController(
//                 const CameraDescription(
//                     name: "",
//                     lensDirection: CameraLensDirection.front,
//                     sensorOrientation: 0),
//                 ResolutionPreset.medium),
//           ),
//         );

//   String companyNameRepo =
//       AuthenticationRepository.instance.currentUser.companyName?.first ?? "";
//   // late CameraController controller;
//   late Timer _periodicTimer;

//   bool isStreaming = false;
//   bool isSecurityBreachChecked = false; // New variable to store checkbox state

//   void startStream() {
//     if (!isStreaming) {
//       startPeriodicPictureCapture(
//           const Duration(milliseconds: 250), state.roomChoosen);
//       isStreaming = true;
//     } else {
//       stopPeriodicPictureCapture();
//       isStreaming = false;
//     }
//   }

//   double get aspectRatio {
//     if ( state.controller != null &&
//         state.controller!.value.isInitialized &&
//         state.controller!.value.previewSize != null &&
//         state.controller!.value.previewSize?.width != null &&
//          state.controller!.value.previewSize?.height != null) {
//       final previewSize =  state.controller!.value.previewSize!;
//       return previewSize.width / previewSize.height;
//     } else {
//       // Return a default aspect ratio or handle the null case gracefully
//       return 16 / 9; // Default widescreen aspect ratio
//     }
//   }

//   void openCamera({required String roomChoosen, required bool security}) async {
//     final cameras = await availableCameras();
//     var controller = CameraController(cameras.first, ResolutionPreset.medium);

//     await controller.initialize();

//     emit(
//       state.copyWith(
//         controller: controller,
//         roomChoosen: roomChoosen,
//         securityBreachChecked: security,
//       ),
//     );
//   }

//   Future<XFile?> takePicture() async {
//     if (state.controller == null || !state.controller!.value.isInitialized) {
//       // Camera is not initialized
//       return null;
//     }

//     try {
//       final XFile file = await state.controller!.takePicture();
//       // final Uint8List bytes = await file.readAsBytes();
//       // String base64String = base64Encode(bytes);

//       // print("GGGGGGGGGGGG" + base64String);
//       return file;
//     }
//     catch (e)
//     {
//       // Error while taking picture
//       debugPrint('Error taking picture: $e');
//       return null;
//     }
//   }

//   void startPeriodicPictureCapture(Duration interval, String? roomChoosen) {
//     _periodicTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
//       final XFile? file = await takePicture();
//       if (file != null) {
//         final Uint8List bytes = await file.readAsBytes();
//         String base64String = base64Encode(bytes);
//         // Handle the picture file here ( send via WebSocket)

//         final _channel = WebSocketChannel.connect(
//           // Uri.parse('ws://192.168.1.114:8765/socket.io/'),

//           Uri.parse('ws:${RemoteDataSource.baseUrlWithoutPort}8765/socket.io/'),
//         );
//         Map<String, dynamic> data = {
//           'collection_name': companyNameRepo,
//           "image": base64String,
//           'username': AuthenticationRepository.instance.currentUser.username,
//           'current_room': state.roomChoosen,
//           "breach_checker": state.securityBreachChecked,
//           "similarity_score": state.sliderValue ?? "0.35",
//         };
//         String jsonData = jsonEncode(data);
//         _channel.sink.add(jsonData);

//         // Listen for response from the server
//         _channel.stream.listen((dynamic response) {
//           if (response.isNotEmpty) {
//             debugPrint("Response from server: $response");

//             SearchInStreamModel callBackList = SearchInStreamModel.fromJson(
//                 jsonDecode(response) as Map<String, dynamic>);
//             emit(state.copyWith(
//               controller: state.controller,
//               boxes: callBackList.boxes,
//               result: callBackList.result,
//               blacklisted: callBackList.blacklisted,
//               securityBreach: callBackList.security_breach,
//               textAccuracy: callBackList.textAccuracy,
//               blacklisted_list_checks: callBackList.blacklisted_list_checks,
//             ));
//           }
//         }, onDone: () {
//           debugPrint("WebSocket connection closed.");
//           _channel.sink.close();
//         }, onError: (error) {
//           debugPrint("WebSocket error: $error");
//         });
//         // debugPrint('Captured picture: ${base64String}');
//       }
//     });
//   }
//   //////////////////////////////////////////////////////

//   void stopPeriodicPictureCapture() {
//     _periodicTimer.cancel();
//   }

//   // void switchCameraOptions({
//   //   required bool isBackCam,
//   //   ResolutionPreset? resolutionPreset,
//   // }) async {
//   //   if (state.controller == null || !state.controller!.value.isInitialized) {
//   //     return;
//   //   }

//   //   final cameras = await availableCameras();
//   //   final newCamera = isBackCam ? cameras.first : cameras.last;
//   //   final newController =
//   //       CameraController(newCamera, resolutionPreset ?? ResolutionPreset.high);

//   //   await newController.initialize();
//   //    state.controller!.dispose(); // Dispose the current controller
//   //   // controller = newController;

//   //   emit(
//   //     state.copyWith(
//   //       controller: newController,
//   //       camera: newController.description,
//   //     ),
//   //   );
//   // }

//   void selectPhoto({required File file}) {
//     emit(
//       state.copyWith(
//         file: file,
//         isChosen: true,
//       ),
//     );
//   }

//   void sliderControl({required String sliderVal}) {
//     emit(
//       state.copyWith(
//         sliderValue: sliderVal,
//       ),
//     );
//   }

//   Future<void> stopCamera() async {
//     if (state.controller!.value.isInitialized) {
//       await  state.controller!.dispose();
//     }
//   }

//   void toggleSecurityBreach(bool value) {
//     emit(
//       state.copyWith(
//         securityBreachChecked: value,
//       ),
//     );
//   }

//   void isChosenChanged(bool value) {
//     // isChosen = value; // Update the checkbox state
//     emit(
//       state.copyWith(
//         isChosen: value,
//       ),
//     );
//   }

//   void roomChoosen(String value) {
//     emit(
//       state.copyWith(
//         roomChoosen: value,
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:Investigator/core/models/search_in_stream.dart';
import 'package:Investigator/core/remote_provider/remote_data_source.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../authentication/authentication_repository.dart';
import '../../../core/enum/enum.dart';

part 'photo_app_state.dart';

class PhotoAppCubit extends Cubit<PhotoAppState> {
  PhotoAppCubit()
      : super(PhotoAppState(
          isLoading: false,
          hasError: false,
          isChosen: false,
          securityBreachChecked: false,
          submission: Submission.initial,
          controller: CameraController(
            const CameraDescription(
                name: "",
                lensDirection: CameraLensDirection.front,
                sensorOrientation: 0),
            ResolutionPreset.medium,
          ),
        ));

  String companyNameRepo =
      AuthenticationRepository.instance.currentUser.companyName?.first ?? "";

  // late CameraController controller;
  late Timer _periodicTimer;

  bool isStreaming = false;
  bool isSecurityBreachChecked = false; // New variable to store checkbox state

  void startStream() {
    if (!isStreaming) {
      startPeriodicPictureCapture(
          const Duration(milliseconds: 250), state.roomChoosen);
      isStreaming = true;
    } else {
      stopPeriodicPictureCapture();
      isStreaming = false;
    }
  }

  double get aspectRatio {
    if (state.controller != null &&
        (state.controller?.value.isInitialized ?? false) &&
        state.controller?.value.previewSize != null &&
        state.controller?.value.previewSize?.width != null &&
        state.controller?.value.previewSize?.height != null) {
      final previewSize = state.controller!.value.previewSize!;
      return previewSize.width / previewSize.height;
    } else {
      // Return a default aspect ratio or handle the null case gracefully
      return 16 / 9; // Default widescreen aspect ratio
    }
  }

  void openCamera({required String roomChoosen, required bool security}) async {
    final cameras = await availableCameras();
    var controller = CameraController(cameras.first, ResolutionPreset.medium);

    await controller.initialize();

    emit(state.copyWith(
      controller: controller,
      roomChoosen: roomChoosen,
      securityBreachChecked: security,
    ));
  }

  Future<XFile?> takePicture() async {
    if (state.controller == null ||
        !(state.controller?.value.isInitialized ?? true)) {
      // Camera is not initialized
      return null;
    }

    try {
      final XFile file = await state.controller!.takePicture();
      // final Uint8List bytes = await file.readAsBytes();
      // String base64String = base64Encode(bytes);

      // print("GGGGGGGGGGGG" + base64String);
      return file;
    } catch (e) {
      // Error while taking picture
      debugPrint('Error taking picture: $e');
      return null;
    }
  }

  void startPeriodicPictureCapture(Duration interval, String? roomChoosen) {
    _periodicTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final XFile? file = await takePicture();
      if (file != null) {
        final Uint8List bytes = await file.readAsBytes();
        String base64String = base64Encode(bytes);
        // Handle the picture file here ( send via WebSocket)

        final _channel = WebSocketChannel.connect(
          // Uri.parse('ws://192.168.1.114:8765/socket.io/'),

          Uri.parse('ws:${RemoteDataSource.baseUrlWithoutPort}8765/socket.io/'),
        );
        Map<String, dynamic> data = {
          'collection_name': companyNameRepo,
          "image": base64String,
          'username': AuthenticationRepository.instance.currentUser.username,
          'current_room': state.roomChoosen,
          "breach_checker": state.securityBreachChecked,
          "similarity_score": state.sliderValue ?? "0.35",
        };
        String jsonData = jsonEncode(data);
        _channel.sink.add(jsonData);

        // Listen for response from the server
        _channel.stream.listen((dynamic response) {
          if (response.isNotEmpty) {
            debugPrint("Response from server: $response");

            SearchInStreamModel callBackList = SearchInStreamModel.fromJson(
                jsonDecode(response) as Map<String, dynamic>);
            emit(state.copyWith(
              controller: state.controller,
              boxes: callBackList.boxes,
              result: callBackList.result,
              blacklisted: callBackList.blacklisted,
              securityBreach: callBackList.security_breach,
              textAccuracy: callBackList.textAccuracy,
              blacklisted_list_checks: callBackList.blacklisted_list_checks,
            ));
          }
        }, onDone: () {
          debugPrint("WebSocket connection closed.");
          _channel.sink.close();
        }, onError: (error) {
          debugPrint("WebSocket error: $error");
        });
        // debugPrint('Captured picture: ${base64String}');
      }
    });
  }

  //////////////////////////////////////////////////////

  void stopPeriodicPictureCapture() {
    // final _channel = WebSocketChannel.connect(

    //   Uri.parse('ws:${RemoteDataSource.baseUrlWithoutPort}8765/socket.io/'),
    // );
    emit(state.copyWith(
      boxes: [],
      blacklisted_list_checks: [],
      blacklisted: false,
      result: [],
      securityBreach: false,
      textAccuracy: [],
    ));
    _periodicTimer.cancel();
    // _channel.sink.close();
  }

  void switchCameraOptions({
    required bool isBackCam,
    ResolutionPreset? resolutionPreset,
  }) async {
    if (state.controller == null ||
        !(state.controller?.value.isInitialized ?? true)) {
      return;
    }

    final cameras = await availableCameras();
    final newCamera = isBackCam ? cameras.first : cameras.last;
    final newController =
        CameraController(newCamera, resolutionPreset ?? ResolutionPreset.high);

    await newController.initialize();
    state.controller?.dispose(); // Dispose the current controller
    // controller = newController;

    emit(state.copyWith(
      controller: newController,
      camera: newController.description,
    ));
  }

  void selectPhoto({required File file}) {
    emit(state.copyWith(
      file: file,
      isChosen: true,
    ));
  }

  void sliderControl({required String sliderVal}) {
    emit(state.copyWith(
      sliderValue: sliderVal,
    ));
  }

  Future<void> stopCamera() async {
    // final _channel = WebSocketChannel.connect(
    //   // Uri.parse('ws://192.168.1.114:8765/socket.io/'),

    //   Uri.parse('ws:${RemoteDataSource.baseUrlWithoutPort}8765/socket.io/'),
    // );

    if (state.controller?.value.isInitialized ?? false) {
      _periodicTimer.cancel();
      // _channel.sink.close();

      await state.controller?.dispose();
      emit(state.copyWith(
        boxes: [],
        blacklisted_list_checks: [],
        blacklisted: false,
        result: [],
        securityBreach: false,
        textAccuracy: [],
        controller: CameraController(
          const CameraDescription(
              name: "",
              lensDirection: CameraLensDirection.front,
              sensorOrientation: 0),
          ResolutionPreset.medium,
        ),
      ));
    }
  }

  void toggleSecurityBreach(bool value) {
    emit(state.copyWith(
      securityBreachChecked: value,
    ));
  }

  void isChosenChanged(bool value) {
    // isChosen = value; // Update the checkbox state
    emit(state.copyWith(
      isChosen: value,
    ));
  }

  void roomChoosen(String value) {
    emit(state.copyWith(
      roomChoosen: value,
    ));
  }
}
