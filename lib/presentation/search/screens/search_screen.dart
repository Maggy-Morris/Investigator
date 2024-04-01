import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:yaru/yaru.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Investigator/core/resources/app_colors.dart';
import 'package:Investigator/core/utils/responsive.dart';
import 'package:Investigator/core/widgets/sizedbox.dart';
import 'package:Investigator/core/widgets/toast/toast.dart';
import 'package:Investigator/presentation/standard_layout/screens/standard_layout.dart';

import '../../../authentication/authentication_repository.dart';
import '../../../core/enum/enum.dart';
import '../../../core/loader/loading_indicator.dart';
import '../../camera_controller/cubit/photo_app_cubit.dart';
// import '../../camera_controller/photo_app_logic.dart';
import '../bloc/search_by_image_bloc.dart';
import 'face_painter.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> with TickerProviderStateMixin {
  Widget? _image;
  PlatformFile? ima;
  String companyNameRepo =
      AuthenticationRepository.instance.currentUser.companyName ?? "";
  late TabController tabController;
  bool _isBackCamera = true;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return StandardLayoutScreen(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => SearchByImageBloc(),
          ),
          BlocProvider(
            create: (context) => PhotoAppCubit(),
          ),
        ],
        child: SimpleDialog(
          // contentPadding:
          //     EdgeInsets.symmetric(vertical: 200, horizontal: 100),
          backgroundColor: AppColors.white,
          shadowColor: AppColors.white,
          titlePadding: EdgeInsets.zero,
          title: YaruDialogTitleBar(
            isClosable: false,
            title: SizedBox(
              width: 500,
              child: YaruTabBar(
                tabController: tabController,
                tabs: const [
                  YaruTab(
                    label: 'By Image',
                    icon: Icon(YaruIcons.library_artists),
                  ),
                  YaruTab(
                    label: 'By liveStream',
                    icon: Icon(YaruIcons.camera_photo),
                  ),
                ],
              ),
            ),
          ),
          children: [
            SizedBox(
              width: 1100,
              height: 600,
              child: TabBarView(
                controller: tabController,
                children: [
                  BlocListener<SearchByImageBloc, SearchByImageState>(
                    listener: (context, state) {
                      if (state.submission == Submission.success) {
                        FxToast.showSuccessToast(context: context);
                      }

                      if (state.submission == Submission.noDataFound) {
                        FxToast.showWarningToast(
                            context: context,
                            warningMessage: "NO data found about this person");
                      }
                    },
                    child: BlocBuilder<SearchByImageBloc, SearchByImageState>(
                      builder: (context, state) {
                        return SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              FxBox.h24,
                              if (Responsive.isWeb(context))
                                Column(
                                  children: [
                                    FxBox.h24,

                                    // Here to search for an Employee in the database
                                    // BlocBuilder<SearchByImageBloc,
                                    //     SearchByImageState>(
                                    //   builder: (context, state) {
                                    // return
                                    Card(
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
                                                )
                                                        .then((result) {
                                                  if (result != null &&
                                                      result.files.isNotEmpty) {
                                                    final imageFile =
                                                        result.files.first;
                                                    final image = imageFile
                                                                .bytes !=
                                                            null
                                                        ? Image.memory(
                                                            imageFile.bytes!,
                                                            fit: BoxFit.cover,
                                                          )
                                                        : loadingIndicator();

                                                    SearchByImageBloc.get(
                                                            context)
                                                        .add(
                                                      ImageToSearchForEmployee(
                                                          imageWidget: image),
                                                    );

                                                    setState(() {
                                                      _image = image;
                                                    });
                                                    String base64Image =
                                                        base64Encode(
                                                            imageFile.bytes!);

                                                    SearchByImageBloc.get(
                                                            context)
                                                        .add(
                                                      SearchForEmployee(
                                                        companyName:
                                                            companyNameRepo,
                                                        image: base64Image,
                                                      ),
                                                    );
                                                  }
                                                  return null;
                                                });
                                              },
                                              child:
                                                  //  state.imageWidget
                                                  _image ??
                                                      SizedBox(
                                                        width: 400,
                                                        height: 400,
                                                        child: Image.asset(
                                                          'assets/images/person-search.png',
                                                          // width: double.infinity,
                                                          // height: 200,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                            ),
                                            Positioned(
                                              bottom: 0,
                                              left: 0,
                                              right: 0,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 8,
                                                  horizontal: 16,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(12),
                                                    bottomRight:
                                                        Radius.circular(12),
                                                  ),
                                                  color: Colors.black
                                                      .withOpacity(0.6),
                                                ),
                                                child: Text(
                                                  // Use state data to show appropriate text
                                                  state.submission ==
                                                          Submission.loading
                                                      ? 'Searching...'
                                                      : state.submission ==
                                                              Submission.success
                                                          ? '${state.result}'
                                                          : state.submission ==
                                                                  Submission
                                                                      .noDataFound
                                                              ? 'Not in the Database'
                                                              : '',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            CustomPaint(
                                              painter: RectanglePainter(
                                                (state.boxes ?? [])
                                                    .map((box) => (box))
                                                    .toList(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    //   },
                                    // ),

                                    //Confirm Button to send the image
                                    FxBox.h24,

                                    state.submission == Submission.loading
                                        ? loadingIndicator()
                                        : Center(
                                            child: ElevatedButton.icon(
                                              onPressed: () {
                                                if (state.imageWidget == null) {
                                                  FxToast.showErrorToast(
                                                    context: context,
                                                    message:
                                                        "Pick your picture",
                                                  );
                                                  return;
                                                }

                                                SearchByImageBloc.get(context)
                                                    .add(
                                                  const SearchForEmployeeEvent(),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                backgroundColor:
                                                    AppColors.green,
                                              ),
                                              label: const Text(
                                                "Confirm",
                                                style: TextStyle(
                                                    color: AppColors.white),
                                              ),
                                              icon: const Icon(
                                                Icons.check_circle_outline,
                                                color: AppColors.white,
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                              if (!Responsive.isWeb(context))
                                Column(
                                  children: [
                                    // Here to search for an Employee in the database
                                    BlocBuilder<SearchByImageBloc,
                                        SearchByImageState>(
                                      builder: (context, state) {
                                        return Card(
                                          elevation: 4,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Stack(
                                              children: [
                                                GestureDetector(
                                                  onTap: () async {
                                                    FilePickerResult? result =
                                                        await FilePicker
                                                            .platform
                                                            .pickFiles(
                                                      type: FileType.image,
                                                    )
                                                            .then((result) {
                                                      if (result != null &&
                                                          result.files
                                                              .isNotEmpty) {
                                                        final imageFile =
                                                            result.files.first;
                                                        final image = imageFile
                                                                    .bytes !=
                                                                null
                                                            ? Image.memory(
                                                                imageFile
                                                                    .bytes!,
                                                                fit: BoxFit
                                                                    .cover,
                                                              )
                                                            : loadingIndicator();

                                                        SearchByImageBloc.get(
                                                                context)
                                                            .add(
                                                          ImageToSearchForEmployee(
                                                              imageWidget:
                                                                  image),
                                                        );

                                                        String base64Image =
                                                            base64Encode(
                                                                imageFile
                                                                    .bytes!);

                                                        SearchByImageBloc.get(
                                                                context)
                                                            .add(
                                                          SearchForEmployee(
                                                            companyName:
                                                                companyNameRepo,
                                                            image: base64Image,
                                                          ),
                                                        );
                                                      }
                                                      return null;
                                                    });
                                                  },
                                                  child: state.imageWidget ??
                                                      Image.asset(
                                                        'assets/images/person-search.png',
                                                        // width: double.infinity,
                                                        // height: 200,
                                                        fit: BoxFit.cover,
                                                      ),
                                                ),
                                                Positioned(
                                                  bottom: 0,
                                                  left: 0,
                                                  right: 0,
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      vertical: 8,
                                                      horizontal: 16,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        bottomLeft:
                                                            Radius.circular(12),
                                                        bottomRight:
                                                            Radius.circular(12),
                                                      ),
                                                      color: Colors.black
                                                          .withOpacity(0.6),
                                                    ),
                                                    child: Text(
                                                      // Use state data to show appropriate text
                                                      state.submission ==
                                                              Submission.loading
                                                          ? 'Searching...'
                                                          : state.submission ==
                                                                  Submission
                                                                      .success
                                                              ? '${state.result}'
                                                              : state.submission ==
                                                                      Submission
                                                                          .noDataFound
                                                                  ? 'Not in the Database'
                                                                  : '',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  // Use state data to show appropriate text
                                                  state.submission ==
                                                          Submission.loading
                                                      ? 'Searching...'
                                                      : state.submission ==
                                                              Submission.success
                                                          ? '${state.boxes}'
                                                          : state.submission ==
                                                                  Submission
                                                                      .noDataFound
                                                              ? 'Not in the database'
                                                              : '',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                CustomPaint(
                                                  painter: RectanglePainter(
                                                    (state.boxes ?? [])
                                                        .map((box) => (box))
                                                        .toList(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),

                                    //Confirm Button to send the image
                                    FxBox.h24,
                                    (state.submission == Submission.loading)
                                        ? loadingIndicator()
                                        : Center(
                                            child: ElevatedButton.icon(
                                              onPressed: () {
                                                if (state.imageWidget == null) {
                                                  FxToast.showErrorToast(
                                                      context: context,
                                                      message:
                                                          "pick your picture ");
                                                  return;
                                                }
                                                SearchByImageBloc.get(context)
                                                    .add(
                                                  const SearchForEmployeeEvent(),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                backgroundColor:
                                                    AppColors.green,
                                              ),
                                              label: Text(
                                                "confirm".tr(),
                                                style: const TextStyle(
                                                    color: AppColors.white),
                                              ),
                                              icon: const Icon(
                                                Icons.check_circle_outline,
                                                color: AppColors.white,
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                            ],
                          ),
                          // );
                        );
                        // );
                      },
                    ),
                  ),

                  /////////////////////////////////////////////////////////////////////////////////////////////
                  ///Live Stream Video

                  BlocBuilder<PhotoAppCubit, PhotoAppState>(
                    builder: (context, state) {
                      if (state is SelectProfilePhotoState) {
                        return Column(
                          children: [
                            // const SizedBox(
                            //   height: 10,
                            // ),
                            Center(
                              child: Stack(
                                children: [
                                  getAvatar(state.file),
                                  Positioned(
                                    bottom: -10,
                                    left: 80,
                                    child: IconButton(
                                      onPressed: () {
                                        // PhotoAppBloc.get(context).add(
                                        //   OpenCameraEvent(),
                                        // );
                                        context
                                            .read<PhotoAppCubit>()
                                            .openCamera();
                                      },
                                      icon: const Icon(
                                        Icons.photo_camera_rounded,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      } else if (state is CameraState) {
                        // Handle CameraState here, if needed
                        return SizedBox(
                          width: 500,
                          height: 500,
                          child: Stack(children: [
                            CameraPreview(
                              state.controller,
                              child: Stack(
                                fit: StackFit.expand,
                                alignment: Alignment.bottomCenter,
                                children: [
                                  // CustomPaint(
                                  //   painter: RectanglePainter(
                                  //     //Remove map(box)
                                  //     (state.boxes ?? [])
                                  //         .map((box) => (box))
                                  //         .toList(),
                                  //   ),
                                  // ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child: Stack(
                                            children: [
                                              Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  context
                                                          .watch<
                                                              PhotoAppCubit>()
                                                          .isStreaming
                                                      ? 'Stop Stream'
                                                      : 'Start Stream',
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      const SizedBox(
                                        width: 10,
                                      ),
                                      IconButton(
                                          color: Colors.white,
                                          padding:
                                              const EdgeInsets.only(bottom: 25),
                                          onPressed: () {
                                            setState(() {
                                              _isBackCamera = !_isBackCamera;
                                            });
                                          },
                                          icon: const Icon(Icons.cameraswitch))
                                    ],
                                  ),
                                ],
                              ),

                              // ),
                            ),
                            CustomPaint(
                              painter: RectanglePainter(
                                (state.boxes ?? [])
                                    .map((box) => (box))
                                    .toList(),
                              ),
                            ),
                          ]),
                        );

                        // Placeholder widget
                      }

                      // else if (state is PreviewState) {
                      //   return Material(
                      //     child: DecoratedBox(
                      //       decoration: BoxDecoration(
                      //           image: DecorationImage(
                      //               fit: BoxFit.cover,
                      //               image: FileImage(state.file!))),
                      //       child: Row(
                      //         crossAxisAlignment: CrossAxisAlignment.end,
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           InkWell(
                      //             onTap: () {
                      //               // PhotoAppBloc.get(context).add(
                      //               //   OpenCameraEvent(),
                      //               // );

                      //               context.read<PhotoAppCubit>().openCamera();
                      //             },
                      //             child: Container(
                      //               height: 40,
                      //               width: 100,
                      //               color: Colors.white38,
                      //               child: const Icon(Icons.cancel_outlined),
                      //             ),
                      //           ),
                      //           const SizedBox(
                      //             width: 20,
                      //           ),
                      //           InkWell(
                      //             onTap: () {
                      //               // context
                      //               //     .read<PhotoAppCubit>()
                      //               //     .selectPhoto(file: state.file!);
                      //             },
                      //             child: Container(
                      //               height: 40,
                      //               width: 60,
                      //               color: Colors.white38,
                      //               child: const Icon(Icons.check_outlined),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   );

                      // }
                      else {
                        return const Scaffold(
                          body: Center(
                            child: Text('Nothing to show'),
                          ),
                        );
                      }
                    },
                  ),

                  // ////////////////////////////////////////////////////////////////////////////////////////////                      // Icon(YaruIcons.keyboard),
                ],
              ),
            ),
          ],
        ),
      ),
      //   ),
      // ),
    );
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////
  ///
  Widget getAvatar(File? displayImage) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.grey[300]!, // Adjust border color as needed
          width: 5, // Adjust border width as needed
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
            150), // Half of width/height for perfect circle
        child: displayImage == null
            ? Image.asset(
                'assets/images/lens-removebg-preview.png',
                fit: BoxFit.cover,
              )
            : Image.file(
                displayImage,
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  ///
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
