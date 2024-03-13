import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Investigator/core/enum/enum.dart';
import 'package:Investigator/core/loader/loading_indicator.dart';
import 'package:Investigator/core/resources/app_colors.dart';
import 'package:Investigator/core/utils/responsive.dart';
import 'package:Investigator/core/widgets/sizedbox.dart';
import 'package:Investigator/core/widgets/textformfield.dart';
import 'package:Investigator/core/widgets/toast/toast.dart';
import 'package:Investigator/presentation/add_camera/bloc/home_bloc.dart';
import 'package:Investigator/presentation/standard_layout/screens/standard_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../camera_controller/cubit/photo_app_cubit.dart';
import '../../camera_controller/photo_app_logic.dart';

class AddCameraScreen extends StatefulWidget {
  const AddCameraScreen({Key? key}) : super(key: key);

  @override
  State<AddCameraScreen> createState() => _AddCameraScreenState();
}

class _AddCameraScreenState extends State<AddCameraScreen> {
  TextEditingController cameraNameController = TextEditingController();
  Widget? _image;
  CameraController? controller;
  XFile? imageFile;
  XFile? videoFile;
  bool _isBackCamera = true;

  // VoidCallback? videoPlayerListener;
  // bool enableAudio = true;
  // double _minAvailableZoom = 1.0;
  // double _maxAvailableZoom = 1.0;
  // double _currentScale = 1.0;
  // double _baseScale = 1.0;
  // // Counting pointers (number of user fingers on screen)
  // int _pointers = 0;

  // List<CameraDescription> _cameras = <CameraDescription>[];

  @override
  Widget build(BuildContext context) {
    return StandardLayoutScreen(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => HomeBloc(),
          ),
          BlocProvider(
            create: (context) => PhotoAppCubit(),
            child: const PhotoAppLogic(),
          ),
        ],
        child: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state.submission == Submission.success) {
              cameraNameController.clear();
              FxToast.showSuccessToast(context: context);
            }
            if (state.submission == Submission.error) {
              FxToast.showErrorToast(context: context);
            }
          },
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              return Card(
                margin: const EdgeInsets.all(20),
                color: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          "Search for your Employee".tr(),
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w600),
                        ),
                        FxBox.h24,
                        if (Responsive.isWeb(context))
                          Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _commonText("Person Name".tr()),
                                        FxBox.h4,
                                        _listBox(
                                            controller: cameraNameController,
                                            hintText: "Add Person Name".tr(),
                                            onChanged: (value) {
                                              // HomeBloc.get(context).add(
                                              // AddCameraName(
                                              //     cameraName: value));
                                            }),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              FxBox.h16,
                              // Here to search for an Employee in the database
                              Row(
                                children: [
                                  SizedBox(
                                    height: 300,
                                    width: 300,
                                    child: Card(
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Stack(
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                FilePickerResult? result =
                                                    await FilePicker.platform
                                                        .pickFiles(
                                                  type: FileType.image,
                                                );
                                                if (result != null &&
                                                    result.files.isNotEmpty) {
                                                  // Use the selected image file
                                                  final imageFile =
                                                      result.files.first;
                                                  // Load the image file as an image
                                                  final image =
                                                      imageFile.bytes != null
                                                          ? Image.memory(
                                                              imageFile.bytes!,
                                                              fit: BoxFit.cover,
                                                            )
                                                          : loadingIndicator();

                                                  // Replace the image with the selected image
                                                  setState(() {
                                                    _image = image;
                                                  });

                                                  String base64Image =
                                                      base64Encode(
                                                          imageFile.bytes!);
                                                  final SharedPreferences
                                                      prefs =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  final String? companyName =
                                                      prefs.getString(
                                                          'companyName');
                                                  // SearchByImageBloc.get(context).add(
                                                  //   SearchForEmployee(
                                                  //     companyName: companyName ?? " ",
                                                  //     image: base64Image,
                                                  //   ),
                                                  // );
                                                }
                                              },
                                              child: _image ??
                                                  Image.network(
                                                    'https://images.pexels.com/photos/414171/pexels-photo-414171.jpeg',
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    // height: 200,
                                                    fit: BoxFit.cover,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              FxBox.h16,

                              Center(
                                child: ElevatedButton.icon(
                                    onPressed: () {
                                      // HomeBloc.get(context)
                                      //     .add(const AddCameraEvent());
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      backgroundColor: AppColors.green,
                                    ),
                                    label: Text(
                                      "confirm".tr(),
                                      style: const TextStyle(
                                          color: AppColors.white),
                                    ),
                                    icon: const Icon(
                                      Icons.check_circle_outline,
                                      color: AppColors.white,
                                    )),
                              ),
                              FxBox.h16,

                              // BlocProvider(
                              //   create: (context) => PhotoAppCubit(),
                              //   child:
                              // BlocBuilder<PhotoAppCubit, PhotoAppState>(
                              //   builder: (context, state) {
                              //     state as SelectProfilePhotoState;
                              //     return Column(
                              //       children: [
                              //         const SizedBox(
                              //           height: 10,
                              //         ),
                              //         Center(
                              //           child: Stack(
                              //             children: [
                              //               getAvatar(state.file),
                              //               Positioned(
                              //                 bottom: -10,
                              //                 left: 80,
                              //                 child: IconButton(
                              //                     onPressed: () {
                              //                       context
                              //                           .read<PhotoAppCubit>()
                              //                           .openCamera();
                              //                     },
                              //                     icon: const Icon(Icons
                              //                         .photo_camera_rounded)),
                              //               )
                              //             ],
                              //           ),
                              //         ),
                              //       ],
                              //     );
                              //   },
                              // ),
                              BlocBuilder<PhotoAppCubit, PhotoAppState>(
                                builder: (context, state) {
                                  if (state is SelectProfilePhotoState) {
                                    return Column(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Center(
                                          child: Stack(
                                            children: [
                                              getAvatar(state.file),
                                              Positioned(
                                                bottom: -10,
                                                left: 80,
                                                child: IconButton(
                                                  onPressed: () {
                                                    context
                                                        .read<PhotoAppCubit>()
                                                        .openCamera();
                                                  },
                                                  icon: const Icon(Icons
                                                      .photo_camera_rounded),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  } else if (state is CameraState) {
                                    // Handle CameraState here, if needed
                                    return CameraPreview(
                                      state.controller,
                                      child:
                                          //  Scaffold(
                                          //     backgroundColor: Colors.transparent,
                                          //     body:
                                          Stack(
                                        fit: StackFit.expand,
                                        alignment: Alignment.bottomCenter,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              // Inside GestureDetector
                                              GestureDetector(
                                                onTap: () {
                                                  context
                                                      .read<PhotoAppCubit>()
                                                      .startStream();
                                                },
                                                child: Container(
                                                  height: 100,
                                                  width: 70,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white,
                                                  ),
                                                  child: Stack(
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          context
                                                                  .watch<
                                                                      PhotoAppCubit>()
                                                                  .isStreaming
                                                              ? 'Stop Stream'
                                                              : 'Start Stream',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                              // GestureDetector(
                                              //     onTap: () {
                                              //       context
                                              //           .read<
                                              //               PhotoAppCubit>()
                                              //           .startPeriodicPictureCapture(
                                              //               const Duration(
                                              //                   milliseconds:
                                              //                       250));
                                              //     },
                                              //     child: Container(
                                              //       height: 100,
                                              //       width: 70,
                                              //       decoration:
                                              //           const BoxDecoration(
                                              //         shape:
                                              //             BoxShape.circle,
                                              //         color: Colors.white,
                                              //       ),
                                              //       child: const Stack(
                                              //         children: [
                                              //           Align(
                                              //             alignment:
                                              //                 Alignment
                                              //                     .center,
                                              //             child: Text(
                                              //               'Start Stream',
                                              //               style:
                                              //                   TextStyle(
                                              //                 color: Colors
                                              //                     .black,
                                              //                 fontSize: 12,
                                              //               ),
                                              //             ),
                                              //           ),
                                              //         ],
                                              //       ),
                                              //     )),

                                              const SizedBox(
                                                width: 10,
                                              ),
                                              IconButton(
                                                  color: Colors.white,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 25),
                                                  onPressed: () {
                                                    setState(() {
                                                      _isBackCamera =
                                                          !_isBackCamera;
                                                    });
                                                    // context
                                                    //     .read<
                                                    //         PhotoAppCubit>()
                                                    //     .switchCameraOptions(
                                                    //       isBackCam:
                                                    //           _isBackCamera,
                                                    //       cameraController:
                                                    //           state
                                                    //               .controller,
                                                    // );
                                                  },
                                                  icon: const Icon(
                                                      Icons.cameraswitch))
                                            ],
                                          ),
                                        ],
                                      ),

                                      // ),
                                    );
                                    // Placeholder widget
                                  } else if (state is PreviewState) {
                                    return Material(
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: FileImage(state.file!))),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                context
                                                    .read<PhotoAppCubit>()
                                                    .openCamera();
                                              },
                                              child: Container(
                                                height: 40,
                                                width: 100,
                                                color: Colors.white38,
                                                child: const Icon(
                                                    Icons.cancel_outlined),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                context
                                                    .read<PhotoAppCubit>()
                                                    .selectPhoto(
                                                        file: state.file!);
                                              },
                                              child: Container(
                                                height: 40,
                                                width: 60,
                                                color: Colors.white38,
                                                child: const Icon(
                                                    Icons.check_outlined),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  } else {
                                    return const Scaffold(
                                      body: Center(
                                        child: Text('Nothing to show'),
                                      ),
                                    );
                                  }
                                },
                              ),

                              // ),
                            ],
                          ),
                        if (!Responsive.isWeb(context))
                          Column(
                            children: [
                              _commonText("Person name".tr()),
                              FxBox.h4,
                              _listBox(
                                  hintText: "Add Person Name".tr(),
                                  controller: cameraNameController,
                                  onChanged: (value) {
                                    // HomeBloc.get(context)
                                    //     .add(AddCameraName(cameraName: value));
                                  }),
                              FxBox.h60,
                              (state.submission == Submission.loading)
                                  ? loadingIndicator()
                                  : Center(
                                      child: ElevatedButton.icon(
                                          onPressed: () {
                                            // HomeBloc.get(context)
                                            //     .add(const AddCameraEvent());
                                          },
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            backgroundColor: AppColors.green,
                                          ),
                                          label: Text(
                                            "confirm".tr(),
                                            style: const TextStyle(
                                                color: AppColors.white),
                                          ),
                                          icon: const Icon(
                                            Icons.check_circle_outline,
                                            color: AppColors.white,
                                          )),
                                    ),
                            ],
                          ),
                        // FxBox.h4,
                        // Column(
                        //   mainAxisAlignment: MainAxisAlignment.end,
                        //   children: <Widget>[
                        //     SizedBox(
                        //       height: 200,
                        //       width: 200,
                        //       child: Center(
                        //         child: _cameraPreviewWidget(),
                        //       ),
                        //       // ),
                        //     ),
                        //     Padding(
                        //       padding: const EdgeInsets.all(5.0),
                        //       child: Row(
                        //         children: <Widget>[
                        //           _cameraTogglesRowWidget(),
                        //         ],
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

/////////////////////////////////////////////////////////////////////////////////////////////////////
  ///
  ///

  CircleAvatar getAvatar(File? displayImage) {
    if (displayImage == null) {
      return const CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 65,
        backgroundImage: AssetImage('assets/images/unnamed.png'),
      );
    } else {
      return CircleAvatar(
        radius: 65,
        backgroundImage: FileImage(displayImage),
      );
    }
  }

  /// Display the preview from the camera (or a message if the preview is not available).
//   Widget _cameraPreviewWidget() {
//     final CameraController? cameraController = controller;

//     if (cameraController == null || !cameraController.value.isInitialized) {
//       return const Text(
//         'Tap a camera',
//         style: TextStyle(
//           color: Colors.black,
//           fontSize: 24.0,
//           fontWeight: FontWeight.w900,
//         ),
//       );
//     } else {
//       return Expanded(
//         child: Container(
//           width: 500,
//           height: 500,
//           child: Listener(
//             onPointerDown: (_) => _pointers++,
//             onPointerUp: (_) => _pointers--,
//             child: CameraPreview(
//               controller!,
//               child: LayoutBuilder(
//                   builder: (BuildContext context, BoxConstraints constraints) {
//                 return GestureDetector(
//                   behavior: HitTestBehavior.opaque,
//                   onScaleStart: _handleScaleStart,
//                   onScaleUpdate: _handleScaleUpdate,
//                   onTapDown: (TapDownDetails details) =>
//                       onViewFinderTap(details, constraints),
//                 );
//               }),
//             ),
//           ),
//         ),
//       );
//     }
//   }

//   void _handleScaleStart(ScaleStartDetails details) {
//     _baseScale = _currentScale;
//   }

//   Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
//     // When there are not exactly two fingers on screen don't scale
//     if (controller == null || _pointers != 2) {
//       return;
//     }

//     _currentScale = (_baseScale * details.scale)
//         .clamp(_minAvailableZoom, _maxAvailableZoom);

//     await controller!.setZoomLevel(_currentScale);
//   }

//   /// Display a row of toggle to select the camera (or a message if no camera is available).
//   Widget _cameraTogglesRowWidget() {
//     final List<Widget> toggles = <Widget>[];

//     void onChanged(CameraDescription? description) {
//       if (description == null) {
//         return;
//       }

//       onNewCameraSelected(description);
//     }

//     if (_cameras.isEmpty) {
//       SchedulerBinding.instance!.addPostFrameCallback((_) async {
//         showInSnackBar('No camera found.');
//       });
//       return const Text('None');
//     } else {
//       for (final CameraDescription cameraDescription in _cameras) {
//         toggles.add(
//           SizedBox(
//             width: 90.0,
//             child: RadioListTile<CameraDescription>(
//               title: Icon(getCameraLensIcon(cameraDescription.lensDirection)),
//               groupValue: controller?.description,
//               value: cameraDescription,
//               onChanged: onChanged,
//             ),
//           ),
//         );
//       }
//     }

//     return Row(children: toggles);
//   }

//   String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

//   void showInSnackBar(String message) {
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text(message)));
//   }

//   void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
//     if (controller == null) {
//       return;
//     }

//     final CameraController cameraController = controller!;

//     final Offset offset = Offset(
//       details.localPosition.dx / constraints.maxWidth,
//       details.localPosition.dy / constraints.maxHeight,
//     );
//     cameraController.setExposurePoint(offset);
//     cameraController.setFocusPoint(offset);
//   }

//   Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
//     if (controller != null) {
//       return controller!.setDescription(cameraDescription);
//     } else {
//       return _initializeCameraController(cameraDescription);
//     }
//   }

//   /// websocket connection
//   Future<void> _initializeCameraController(
//       CameraDescription cameraDescription) async {
//     // Define the interval (e.g., 250 milliseconds for four times a second)
//     const Duration interval = Duration(milliseconds: 250);

//     // Start the timer
//     Timer.periodic(interval, (Timer timer) {
//       takePicture().then((XFile? file) async {
//         if (file != null) {
//           final Uint8List bytes = await file.readAsBytes();
//           String base64String = base64Encode(bytes);
//           // print(base64String);

//           final _channel = WebSocketChannel.connect(
//             Uri.parse('ws://192.168.1.118:8765/socket.io/'),
//           );
//           Map<String, dynamic> data = {
//             'collection_name': 'maggy',
//             "image": base64String
//           };
//           String jsonData = jsonEncode(data);
//           _channel.sink.add(jsonData);

//           // Listen for response from the server
//           _channel.stream.listen((dynamic response) {
//             print("Response from server: $response");
//           }, onDone: () {
//             print("WebSocket connection closed.");
//             _channel.sink.close();
//           }, onError: (error) {
//             print("WebSocket error: $error");
//           });
//         }
//       });
//     });
//     final CameraController cameraController = CameraController(
//       cameraDescription,
//       kIsWeb ? ResolutionPreset.max : ResolutionPreset.medium,
//       enableAudio: enableAudio,
//       imageFormatGroup: ImageFormatGroup.jpeg,
//     );

//     controller = cameraController;

//     // If the controller is updated then update the UI.
//     cameraController.addListener(() {
//       if (mounted) {
//         setState(() {});
//       }
//       if (cameraController.value.hasError) {
//         showInSnackBar(
//             'Camera error ${cameraController.value.errorDescription}');
//       }
//     });

//     try {
//       await cameraController.initialize();
//       await Future.wait(<Future<Object?>>[
//         cameraController
//             .getMaxZoomLevel()
//             .then((double value) => _maxAvailableZoom = value),
//         cameraController
//             .getMinZoomLevel()
//             .then((double value) => _minAvailableZoom = value),
//       ]);
//     } on CameraException catch (e) {
//       switch (e.code) {
//         case 'CameraAccessDenied':
//           showInSnackBar('You have denied camera access.');
//         case 'CameraAccessDeniedWithoutPrompt':
//           // iOS only
//           showInSnackBar('Please go to Settings app to enable camera access.');
//         case 'CameraAccessRestricted':
//           // iOS only
//           showInSnackBar('Camera access is restricted.');
//         case 'AudioAccessDenied':
//           showInSnackBar('You have denied audio access.');
//         case 'AudioAccessDeniedWithoutPrompt':
//           // iOS only
//           showInSnackBar('Please go to Settings app to enable audio access.');
//         case 'AudioAccessRestricted':
//           // iOS only
//           showInSnackBar('Audio access is restricted.');
//         default:
//           _showCameraException(e);
//           break;
//       }
//     }

//     if (mounted) {
//       setState(() {});
//     }
//   }

// /////////////////////////////////////////////////////////
//   Future<XFile?> takePicture() async {
//     final CameraController? cameraController = controller;
//     if (cameraController == null || !cameraController.value.isInitialized) {
//       showInSnackBar('Error: select a camera first.');
//       return null;
//     }

//     if (cameraController.value.isTakingPicture) {
//       // A capture is already pending, do nothing.
//       return null;
//     }

//     try {
//       final XFile file = await cameraController.takePicture();
//       return file;
//     } on CameraException catch (e) {
//       _showCameraException(e);
//       return null;
//     }
//   }

//   void _showCameraException(CameraException e) {
//     _logError(e.code, e.description);
//     showInSnackBar('Error: ${e.code}\n${e.description}');
//   }

//   void _logError(String code, String? message) =>
//       print('Error: $code\nError Message: $message');

////////////////////////////////////////////////////////////////////////////////
  Widget _listBox({
    required String hintText,
    required void Function(String)? onChanged,
    required TextEditingController? controller,
    bool? enabled,
  }) {
    return CustomTextField(
      border: const OutlineInputBorder(),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      controller: controller,
      filled: true,
      enabled: enabled ?? true,
      fillColor: Colors.grey.shade200,
      enabledBorder:
          OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(style: BorderStyle.none)),
      focusedBorder:
          OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      hintText: hintText,
      onChanged: onChanged,
    );
  }

  Widget _commonText(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: Responsive.isMobile(context) ? 8.0 : 0.0,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
