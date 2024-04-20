import 'dart:convert';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Investigator/core/enum/enum.dart';
import 'package:Investigator/core/loader/loading_indicator.dart';
import 'package:Investigator/core/resources/app_colors.dart';
import 'package:Investigator/core/utils/responsive.dart';
import 'package:Investigator/core/widgets/sizedbox.dart';
import 'package:Investigator/core/widgets/textformfield.dart';
import 'package:Investigator/core/widgets/toast/toast.dart';
import 'package:Investigator/presentation/standard_layout/screens/standard_layout.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_downloader_web/image_downloader_web.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:video_player/video_player.dart';
import 'dart:html' as html;

import '../../../authentication/authentication_repository.dart';
import '../../../core/remote_provider/remote_data_source.dart';
import '../../../core/widgets/fullscreenImage.dart';
import '../../camera_controller/cubit/photo_app_cubit.dart';
import '../bloc/home_bloc.dart';

class AddCameraScreen extends StatefulWidget {
  const AddCameraScreen({Key? key}) : super(key: key);

  @override
  State<AddCameraScreen> createState() => _AddCameraScreenState();
}

class _AddCameraScreenState extends State<AddCameraScreen> {
  TextEditingController nameController = TextEditingController();
  Widget? _image;
  CameraController? controller;
  XFile? imageFile;
  final double _min = 10;
  final double _max = 100;
  double _value = 10;
  // bool _isBackCamera = true;
  String companyNameRepo =
      AuthenticationRepository.instance.currentUser.companyName?.first ?? "";

  //////////////////////////////////////////////////////
  VideoPlayerController? _controller;
  bool _loading = false;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  /////////////////////////////////////////////////
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
          ),
        ],
        child: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state.submission == Submission.success) {
              FxToast.showSuccessToast(context: context);
            }
            if (state.submission == Submission.noDataFound) {
              FxToast.showWarningToast(
                  context: context,
                  warningMessage: "The person isn't in the the video .");
            }
          },
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              return Card(
                margin: const EdgeInsets.all(20),
                color: AppColors.backGround,
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
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white),
                        ),
                        FxBox.h24,
                        const Tooltip(
                          message:
                              "Choose The Accuracy You Want To Search For A Person With Using The SliderBar \n        Note That If the Video Resolution Is Bad Try to Choose High Accuracy ",
                          child: Icon(
                            Icons.info_outline_rounded,
                            color: AppColors.white,
                            size: 25,
                          ),
                        ),
                        if (Responsive.isWeb(context))
                          Column(
                            children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50.0, vertical: 20),
                                  child: SfRangeSliderTheme(
                                    data: SfRangeSliderThemeData(
                                      activeTrackColor: Colors.white,
                                      activeLabelStyle: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic),
                                      inactiveLabelStyle: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic),
                                    ),
                                    child: SfSlider(
                                      enableTooltip: true,
                                      activeColor: const Color.fromRGBO(
                                          214, 221, 224, 1),
                                      min: _min,
                                      max: _max,
                                      value: _value,
                                      interval: 18, // Assuming interval is 1
                                      showTicks: true,
                                      showLabels: true,

                                      onChanged: (dynamic newValue) {
                                        HomeBloc.get(context).add(GetAccuracy(
                                            accuracy:
                                                (newValue / 100).toString()));
                                        setState(() {
                                          _value = newValue;
                                        });
                                      },
                                     labelFormatterCallback: (dynamic value,
                                          String formattedValue) {
                                        // Map numeric values to custom string labels
                                        switch (value.toInt()) {
                                          case 10:
                                            return 'Low';
                                          case 28:
                                            return 'Medium';
                                          case 46:
                                            return 'High';
                                          case 64:
                                            return 'Very High';
                                          case 82:
                                            return 'Extreme';
                                          case 100:
                                            return 'Identical';
                                          default:
                                            return ''; // Return empty string for other values
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              // FxBox.h16,

                              // Here to search for an Employee in the database
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
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
                                                await FilePicker.platform
                                                    .pickFiles(
                                                  type: FileType.image,
                                                )
                                                    .then((result) {
                                                  if (result != null &&
                                                      result.files.isNotEmpty) {
                                                    // Use the selected image file
                                                    final imageFile =
                                                        result.files.first;
                                                    // Load the image file as an image
                                                    final image = imageFile
                                                                .bytes !=
                                                            null
                                                        ? Image.memory(
                                                            imageFile.bytes!,
                                                            fit: BoxFit.cover,
                                                          )
                                                        : loadingIndicator();

                                                    // Replace the image with the selected image
                                                    setState(() {
                                                      _image = image;
                                                    });
                                                    HomeBloc.get(context).add(
                                                        ImageToSearchForEmployee(
                                                            imageWidget:
                                                                image));

                                                    HomeBloc.get(context).add(
                                                        imageevent(
                                                            imageFile:
                                                                imageFile));
                                                  }
                                                });
                                              },
                                              child: Stack(
                                                  fit: StackFit.expand,
                                                  children: [
                                                    // state.imageWidget
                                                    _image ??
                                                        Image.asset(
                                                          'assets/images/imagepick.png',
                                                          width:
                                                              double.infinity,
                                                          height:
                                                              double.infinity,
                                                          fit: BoxFit.cover,
                                                        ),
                                                  ]),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
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
                                                await _pickVideo().then(
                                                  (PlatformFile? videoFile) {
                                                    if (videoFile != null) {
                                                      HomeBloc.get(context).add(
                                                          videoevent(
                                                              video:
                                                                  videoFile));
                                                    }
                                                  },
                                                );
                                              }, // Call _pickVideo function when tapped
                                              child: Stack(
                                                fit: StackFit.expand,
                                                children: [
                                                  if (_loading)
                                                    Center(
                                                      child:
                                                          loadingIndicator(), // Display circular progress indicator while loading
                                                    )
                                                  else if (_controller != null)
                                                    AspectRatio(
                                                      aspectRatio: _controller!
                                                          .value.aspectRatio,
                                                      child: VideoPlayer(
                                                          _controller!),
                                                    )
                                                  else
                                                    Image.asset(
                                                      'assets/images/iconVid.png',
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                      fit: BoxFit.cover,
                                                    ),
                                                ],
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
                              state.submission == Submission.loading
                                  ? loadingIndicator()
                                  : Center(
                                      child: ElevatedButton.icon(
                                          onPressed: () {
                                            HomeBloc.get(context).add(
                                                const reloadSnapShots(
                                                    snapyy: []));
                                            HomeBloc.get(context).add(
                                                const SearchForEmployeeByVideoEvent());
                                          },
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            backgroundColor:
                                                AppColors.buttonBlue,
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

                              ///frames Data
                              state.submission == Submission.noDataFound
                                  ? const Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Text(
                                        "This Person Is   Not In The Video",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 25,
                                        ),
                                      ))
                                  : Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: (state.submission ==
                                                      Submission.noDataFound)
                                                  ? const Center(
                                                      child: Text(
                                                      "No data found Yet!",
                                                      style: TextStyle(
                                                          color:
                                                              AppColors.blueB,
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ))
                                                  : GridView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      itemCount: state
                                                          .snapShots.length,
                                                      gridDelegate: Responsive
                                                              .isMobile(context)
                                                          ? const SliverGridDelegateWithFixedCrossAxisCount(
                                                              crossAxisCount: 1,
                                                              crossAxisSpacing:
                                                                  45,
                                                              mainAxisSpacing:
                                                                  45,
                                                              mainAxisExtent:
                                                                  350,
                                                            )
                                                          : Responsive.isTablet(
                                                                  context)
                                                              ? const SliverGridDelegateWithFixedCrossAxisCount(
                                                                  crossAxisCount:
                                                                      2,
                                                                  crossAxisSpacing:
                                                                      45,
                                                                  mainAxisSpacing:
                                                                      45,
                                                                  mainAxisExtent:
                                                                      350,
                                                                )
                                                              : MediaQuery.of(context)
                                                                          .size
                                                                          .width <
                                                                      1500
                                                                  ? SliverGridDelegateWithMaxCrossAxisExtent(
                                                                      maxCrossAxisExtent:
                                                                          MediaQuery.of(context).size.width *
                                                                              0.24,
                                                                      crossAxisSpacing:
                                                                          45,
                                                                      mainAxisSpacing:
                                                                          45,
                                                                      mainAxisExtent:
                                                                          350,
                                                                    )
                                                                  : SliverGridDelegateWithMaxCrossAxisExtent(
                                                                      maxCrossAxisExtent:
                                                                          MediaQuery.of(context).size.width *
                                                                              0.24,
                                                                      crossAxisSpacing:
                                                                          45,
                                                                      mainAxisSpacing:
                                                                          45,
                                                                      mainAxisExtent:
                                                                          350,
                                                                    ),
                                                      itemBuilder:
                                                          (context, index) {
                                                        final image = state
                                                            .snapShots[index];

                                                        final data_time =
                                                            state.data[index];
                                                        return imagesListWidget(
                                                            onDownloadPressed:
                                                                () {
                                                              _downloadImage(
                                                                  data: image,
                                                                  downloadName:
                                                                      data_time);
                                                            },
                                                            image64: image,
                                                            text: data_time);
                                                      },
                                                    ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                              // ),
                            ],
                          ),
                        if (!Responsive.isWeb(context))
                          Column(
                            children: [
                              // Here to search for an Employee in the database
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
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
                                                // FilePickerResult? result =
                                                await FilePicker.platform
                                                    .pickFiles(
                                                  type: FileType.image,
                                                )
                                                    .then((result) {
                                                  if (result != null &&
                                                      result.files.isNotEmpty) {
                                                    // Use the selected image file
                                                    final imageFile =
                                                        result.files.first;
                                                    // Load the image file as an image
                                                    final image = imageFile
                                                                .bytes !=
                                                            null
                                                        ? Image.memory(
                                                            imageFile.bytes!,
                                                            fit: BoxFit.cover,
                                                          )
                                                        : loadingIndicator();
                                                    // Replace the image with the selected image

                                                    HomeBloc.get(context).add(
                                                        ImageToSearchForEmployee(
                                                            imageWidget:
                                                                image));

                                                    HomeBloc.get(context).add(
                                                        imageevent(
                                                            imageFile:
                                                                imageFile));
                                                  }
                                                  return null;
                                                });
                                              },
                                              child: Stack(
                                                  fit: StackFit.expand,
                                                  children: [
                                                    state.imageWidget ??
                                                        Image.asset(
                                                          'assets/images/imagepick.png',
                                                          width:
                                                              double.infinity,
                                                          height:
                                                              double.infinity,
                                                          fit: BoxFit.cover,
                                                        ),
                                                  ]),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

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
                                                _pickVideo().then(
                                                    (PlatformFile? videoFile) {
                                                  if (videoFile != null) {
                                                    HomeBloc.get(context).add(
                                                        videoevent(
                                                            video: videoFile));
                                                  }
                                                });
                                              }, // Call _pickVideo function when tapped
                                              child: Stack(
                                                fit: StackFit.expand,
                                                children: [
                                                  if (_loading)
                                                    Center(
                                                      child:
                                                          loadingIndicator(), // Display circular progress indicator while loading
                                                    )
                                                  else if (_controller != null)
                                                    AspectRatio(
                                                      aspectRatio: _controller!
                                                          .value.aspectRatio,
                                                      child: VideoPlayer(
                                                          _controller!),
                                                    )
                                                  else
                                                    Image.asset(
                                                      'assets/images/iconVid.png',
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                      fit: BoxFit.cover,
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  ///////////////////////////////
                                ],
                              ),

                              FxBox.h60,
                              (state.submission == Submission.loading)
                                  ? loadingIndicator()
                                  : Center(
                                      child: ElevatedButton.icon(
                                          onPressed: () {
                                            HomeBloc.get(context).add(
                                                const reloadSnapShots(
                                                    snapyy: []));
                                            HomeBloc.get(context).add(
                                                const SearchForEmployeeByVideoEvent());
                                          },
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            backgroundColor:
                                                AppColors.buttonBlue,
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

                              ///frames Data

                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: (state.submission ==
                                                Submission.noDataFound)
                                            ? const Center(
                                                child: Text(
                                                "No data found Yet!",
                                                style: TextStyle(
                                                    color: AppColors.blueB,
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ))
                                            : GridView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount:
                                                    state.snapShots.length,
                                                gridDelegate: Responsive
                                                        .isMobile(context)
                                                    ? const SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 1,
                                                        crossAxisSpacing: 45,
                                                        mainAxisSpacing: 45,
                                                        mainAxisExtent: 350,
                                                      )
                                                    : Responsive.isTablet(
                                                            context)
                                                        ? const SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 2,
                                                            crossAxisSpacing:
                                                                45,
                                                            mainAxisSpacing: 45,
                                                            mainAxisExtent: 350,
                                                          )
                                                        : MediaQuery.of(context)
                                                                    .size
                                                                    .width <
                                                                1500
                                                            ? SliverGridDelegateWithMaxCrossAxisExtent(
                                                                maxCrossAxisExtent:
                                                                    MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.24,
                                                                crossAxisSpacing:
                                                                    45,
                                                                mainAxisSpacing:
                                                                    45,
                                                                mainAxisExtent:
                                                                    350,
                                                              )
                                                            : SliverGridDelegateWithMaxCrossAxisExtent(
                                                                maxCrossAxisExtent:
                                                                    MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.24,
                                                                crossAxisSpacing:
                                                                    45,
                                                                mainAxisSpacing:
                                                                    45,
                                                                mainAxisExtent:
                                                                    350,
                                                              ),
                                                itemBuilder: (context, index) {
                                                  final image =
                                                      state.snapShots[index];

                                                  final data_time =
                                                      state.data[index];
                                                  return imagesListWidget(
                                                      onDownloadPressed: () {
                                                        final uint8List =
                                                            _decodeBase64Image(
                                                                base64Image:
                                                                    image);

                                                        _downloadImage(
                                                            data: image,
                                                            downloadName:
                                                                data_time);
                                                      },
                                                      image64: image,
                                                      text: data_time);
                                                },
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
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
  Future<PlatformFile?> _pickVideo() async {
    // replace this later
    setState(() {
      _loading = true;
    });

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    setState(() {
      _loading = false;
    });

    if (result != null) {
      final videoFile = result.files.first;
      final Uint8List videoBytes = videoFile.bytes!;
      final blob = html.Blob([videoBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);

      _controller = VideoPlayerController.network(url)
        ..initialize().then((_) {
          _controller!.play();
        });

      return videoFile; // Return the picked video file
    } else {
      return null; // Return null if no file is picked
    }
  }

////////////////////////////////////////////////////////////////////////////////
//   Widget imagesListWidget({
//     required String image64,
//     required String text,
//     required VoidCallback onDownloadPressed,
//   }) {
//     return Container(
//       width: 300,
//       padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
//       decoration: BoxDecoration(
//         color: Colors.grey.withOpacity(0.3),
//         borderRadius: BorderRadius.circular(12.0),
//       ),
//       child: Column(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(6.0),
//             child: Stack(
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => FullScreenImageFromMemory(
//                           text: text,
//                           imageUrl: image64,
//                         ),
//                       ),
//                     );
//                   },
//                   child: Image.memory(
//                     _decodeBase64Image(base64Image: image64),
//                     width: double.infinity,
//                     height: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   color: Colors.black.withOpacity(0.5),
//                   child: Text(
//                     text,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // SizedBox(
//           //   height: 50,
//           //   width: 50,
//           //   child: ElevatedButton(
//           //     onPressed: onDownloadPressed,
//           //     child: Text('Download'),
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }

//   Uint8List _decodeBase64Image({required String base64Image}) {
//     final bytes = base64.decode(base64Image);
//     return Uint8List.fromList(bytes);
//   }

// }
  Widget imagesListWidget({
    required String image64,
    required String text,
    required VoidCallback onDownloadPressed,
  }) {
    return Container(
      width: 300,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6.0),
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FullScreenImageFromMemory(
                            text: text, imageUrl: image64)));
              },
              child: Image.memory(
                _decodeBase64Image(base64Image: image64),
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.black.withOpacity(0.5),
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                onPressed: onDownloadPressed,
                icon: const Icon(
                  Icons.download,
                  size: 45,
                  color: AppColors.buttonBlue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Uint8List _decodeBase64Image({required String base64Image}) {
    final bytes = base64.decode(base64Image);

    return Uint8List.fromList(bytes);
  }

//   Future<void> _downloadImage({required String image64}) async {
//     final uint8List = _decodeBase64Image(base64Image: image64);
//     await WebImageDownloader.downloadImageFromUInt8List(uInt8List: uint8List);
//   }
// }
  _downloadImage({required String data, String downloadName = 'image'}) async {
    if (data.isNotEmpty) {
      try {
        final uint8List = _decodeBase64Image(base64Image: data);
        // first we make a request to the url like you did
        // in the android and ios version
        // final http.Response r = await http.get(
        //   Uri.parse(getPhotosServerLink(imageUrl)),
        // );

        // we get the bytes from the body
        // final data = r.bodyBytes;
        // and encode them to base64
        final base64data = base64Encode(uint8List);

        // then we create and AnchorElement with the html package
        final a =
            html.AnchorElement(href: 'data:image/jpeg;base64,$base64data');

        // set the name of the file we want the image to get
        // downloaded to
        a.download = '$downloadName.jpg';

        // and we click the AnchorElement which downloads the image
        a.click();
        // finally we remove the AnchorElement
        a.remove();
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    } else {
      EasyLoading.showError('لا يوجد صورة');
    }
  }
}
// Stack(
//         fit: StackFit.expand,
//         children: [
//         ClipRRect(
//           borderRadius: BorderRadius.circular(6.0),
//           child: Image.memory(
//             _decodeBase64Image(base64Image: image64),
//             fit: BoxFit.cover,
//           ),
//         ),
//         Positioned(
//           bottom: 0,
//           left: 0,
//           child: Container(
//             padding: EdgeInsets.all(8),
//             color: Colors.black.withOpacity(0.5),
//             child: Text(
//               'Your Texttttttttttttttttttttttttttttttttttttt',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//               ),
//             ),
//           ),
//         ),
//       ])