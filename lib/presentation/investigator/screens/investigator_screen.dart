// import 'dart:convert';
// import 'dart:typed_data';
import 'package:image/image.dart' as img;

import 'package:Investigator/core/widgets/flutter_pagination/flutter_pagination.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chewie/chewie.dart';
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
import 'package:Investigator/core/widgets/toast/toast.dart';
import 'package:Investigator/presentation/standard_layout/screens/standard_layout.dart';
import 'package:video_player/video_player.dart';
import 'dart:html' as html;

import '../../../authentication/authentication_repository.dart';
import '../../../core/remote_provider/remote_data_source.dart';
import '../../../core/widgets/fullscreenImage.dart';
import '../../../core/widgets/image_downloader.dart';
import '../../../core/widgets/slider_widget.dart';
import '../../camera_controller/cubit/photo_app_cubit.dart';
import '../bloc/home_bloc.dart';

class AddCameraScreen extends StatefulWidget {
  const AddCameraScreen({Key? key}) : super(key: key);

  @override
  State<AddCameraScreen> createState() => _AddCameraScreenState();
}

class _AddCameraScreenState extends State<AddCameraScreen> {
  // TextEditingController nameController = TextEditingController();
  // Widget? _image;
  // List<Widget>? _images;

  // CameraController? controller;
  // XFile? imageFile;
  // final double _min = 10;
  // final double _max = 100;
  // double _value = 10;

  // bool _isBackCamera = true;
  String companyNameRepo =
      AuthenticationRepository.instance.currentUser.companyName?.first ?? "";
  final CarouselController _carouselController = CarouselController();

  //////////////////////////////////////////////////////
  VideoPlayerController? _controller;

  final ScrollController _scrollController = ScrollController();

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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Search for your Targets".tr(),
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white),
                            ),
                            const SizedBox(width: 10),
                            const Tooltip(
                              message:
                                  "Choose The Accuracy You Want To Search For A Person With Using The SliderBar \n        Note That If the Video Resolution Is Bad Try to Choose Low Accuracy ",
                              child: Icon(
                                Icons.info_outline_rounded,
                                color: AppColors.white,
                                size: 25,
                              ),
                            ),
                          ],
                        ),
                        if (Responsive.isWeb(context))
                          Column(
                            children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 50.0, left: 50.0, bottom: 15),
                                  child: SliderWidget(
                                    value: state.sliderValue,
                                    onChanged: (newValue) {
                                      HomeBloc.get(context).add(GetAccuracy(
                                          sliderValue: newValue,
                                          accuracy:
                                              (newValue / 100).toString()));
                                    },
                                    showLabelFormatter: true,
                                  ),
                                ),
                              ),
                              // FxBox.h16,

                              // Here to search for an Employee in the database
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  // Images Carasol
                                  Tooltip(
                                    message: "Upload Image or Images",
                                    child: SizedBox(
                                      height: 300,
                                      width: 250,
                                      child: Card(
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
                                                  HomeBloc.get(context).add(
                                                    const loadingEvent(
                                                        load: true),
                                                  );

                                                  await FilePicker.platform
                                                      .pickFiles(
                                                    type: FileType.image,
                                                    allowMultiple: true,
                                                  )
                                                      .then((result) {
                                                    HomeBloc.get(context).add(
                                                      const loadingEvent(
                                                          load: false),
                                                    );

                                                    if (result != null &&
                                                        result
                                                            .files.isNotEmpty) {
                                                      List<Widget> images = [];
                                                      for (var imageFile
                                                          in result.files) {
                                                        final Uint8List?
                                                            imageBytes =
                                                            imageFile.bytes;

                                                        if (imageBytes !=
                                                            null) {
                                                          // Decode the image
                                                          final img.Image?
                                                              image =
                                                              img.decodeImage(
                                                                  imageBytes);

                                                          if (image != null) {
                                                            if (image.width >=
                                                                    300 &&
                                                                image.height >=
                                                                    300) {
                                                              final imageWidget =
                                                                  Image.memory(
                                                                imageBytes,
                                                                fit: BoxFit
                                                                    .cover,
                                                              );

                                                              images.add(
                                                                  imageWidget);

                                                              HomeBloc.get(
                                                                      context)
                                                                  .add(
                                                                imagesList(
                                                                    imagesListdata:
                                                                        result
                                                                            .files),
                                                              );
                                                              // Process each selected image file
                                                              // HomeBloc.get(
                                                              //         context)
                                                              //     .add(
                                                              //   ImageToSearchForEmployee(
                                                              //       imageWidget:
                                                              //           imageWidget),
                                                              // );
                                                              // HomeBloc.get(
                                                              //         context)
                                                              //     .add(
                                                              //   imageevent(
                                                              //       imageFile:
                                                              //           imageFile),
                                                              // );

                                                              // HomeBloc.get(
                                                              //         context)
                                                              //     .add(
                                                              //   const loadingEvent(
                                                              //       load:
                                                              //           false),
                                                              // );
                                                            } else {
                                                              // Show a message to the user
                                                              FxToast.showErrorToast(
                                                                  message:
                                                                      "Image resolution is too low. Minimum required is 300x300.",
                                                                  context:
                                                                      context);

                                                              // HomeBloc.get(
                                                              //         context)
                                                              //     .add(
                                                              //   const loadingEvent(
                                                              //       load:
                                                              //           false),
                                                              // );
                                                            }
                                                          }
                                                        }
                                                      }

                                                      HomeBloc.get(context).add(
                                                          ImageListWidget(
                                                              imageWidgetss:
                                                                  images));

                                                      // HomeBloc.get(context).add(
                                                      //   const loadingEvent(
                                                      //       load: false),
                                                      // );
                                                    }
                                                  });

                                                  // HomeBloc.get(context).add(
                                                  //   const loadingEvent(
                                                  //       load: false),
                                                  // );
                                                },
                                                child: Stack(
                                                  fit: StackFit.expand,
                                                  children: [
                                                    state.load == true
                                                        ? loadingIndicator(
                                                            color: AppColors
                                                                .buttonBlue)
                                                        : state.imageWidgetss
                                                                    .isNotEmpty ==
                                                                true
                                                            ? CarouselSlider(
                                                                carouselController:
                                                                    _carouselController,
                                                                items: state
                                                                    .imageWidgetss,
                                                                options:
                                                                    CarouselOptions(
                                                                  aspectRatio:
                                                                      16 / 9,
                                                                  viewportFraction:
                                                                      0.8,
                                                                  enableInfiniteScroll:
                                                                      false,
                                                                  reverse:
                                                                      false,
                                                                  autoPlay:
                                                                      true,
                                                                  enlargeCenterPage:
                                                                      true,
                                                                  scrollDirection:
                                                                      Axis.horizontal,
                                                                ),
                                                              )
                                                            : Image.asset(
                                                                'assets/images/imagepick.png',
                                                                width: double
                                                                    .infinity,
                                                                height: double
                                                                    .infinity,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                  ],
                                                ),
                                              ),
                                              state.imageWidgetss.isNotEmpty ==
                                                          true &&
                                                      state.imageWidgetss
                                                              .length !=
                                                          1
                                                  ?
                                                  // Left Button
                                                  Positioned(
                                                      left: 0,
                                                      top: 110,
                                                      bottom: 110,
                                                      child: IconButton(
                                                        icon: const Icon(
                                                          Icons.arrow_left,
                                                          size: 35,
                                                        ),
                                                        onPressed: () {
                                                          // Scroll the carousel to the left
                                                          _carouselController
                                                              .previousPage();
                                                        },
                                                      ),
                                                    )
                                                  : const Positioned(
                                                      child: Text("")),
                                              state.imageWidgetss.isNotEmpty ==
                                                          true &&
                                                      state.imageWidgetss
                                                              .length !=
                                                          1
                                                  ?
                                                  // Right Button
                                                  Positioned(
                                                      right: 0,
                                                      top: 110,
                                                      bottom: 110,
                                                      child: IconButton(
                                                        icon: const Icon(
                                                          Icons.arrow_right,
                                                          size: 35,
                                                        ),
                                                        onPressed: () {
                                                          // Scroll the carousel to the right
                                                          _carouselController
                                                              .nextPage();
                                                        },
                                                      ),
                                                    )
                                                  : const Positioned(
                                                      child: Text("")),

                                              //info Button
                                              Positioned(
                                                top: 0,
                                                child: Tooltip(
                                                  message:
                                                      "Images Less Than 300x300 In Resolution Will Be Dismissed",
                                                  child: IconButton(
                                                    icon: const Icon(
                                                      Icons.info_outline,
                                                      color: AppColors.black,
                                                      size: 30,
                                                    ),
                                                    onPressed: () {},
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Uploading Videos
                                  SizedBox(
                                    height: 300,
                                    width: 600,
                                    child: Card(
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          if (_controller != null)
                                            AspectRatio(
                                              aspectRatio: _controller!
                                                  .value.aspectRatio,
                                              child: Stack(children: [
                                                Chewie(
                                                  controller: ChewieController(
                                                    aspectRatio: _controller
                                                        ?.value.aspectRatio,
                                                    videoPlayerController:
                                                        _controller!,
                                                    autoPlay: false,
                                                    startAt: Duration(
                                                        seconds:
                                                            state.timeDuration),
                                                    autoInitialize: true,
                                                    looping: false,
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 0,
                                                  right: 0,
                                                  child: Tooltip(
                                                    message:
                                                        "Upload Another Video",
                                                    child: IconButton(
                                                      onPressed: () {
                                                        _pickVideo().then(
                                                            (PlatformFile?
                                                                videoFile) {
                                                          if (videoFile !=
                                                              null) {
                                                            HomeBloc.get(
                                                                    context)
                                                                .add(videoevent(
                                                                    video:
                                                                        videoFile));
                                                          }
                                                        });
                                                      },
                                                      icon: const Icon(
                                                        Icons.upload,
                                                        size: 45,
                                                        color: AppColors
                                                            .buttonBlue,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                            )
                                          else
                                            Tooltip(
                                              message: "Upload a video",
                                              child: GestureDetector(
                                                onTap: () {
                                                  _pickVideo().then(
                                                      (PlatformFile?
                                                          videoFile) {
                                                    if (videoFile != null) {
                                                      HomeBloc.get(context).add(
                                                          videoevent(
                                                              video:
                                                                  videoFile));
                                                    }
                                                  });
                                                },
                                                child: Image.asset(
                                                  'assets/images/iconVid.png',
                                                  // width: double.infinity,
                                                  // height: double.infinity,
                                                  // fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              FxBox.h24,
                              state.submission == Submission.loading
                                  ? loadingIndicator()
                                  : Center(
                                      child: ElevatedButton.icon(
                                          onPressed: () {
                                            if (state.imageWidgetss.isEmpty) {
                                              FxToast.showErrorToast(
                                                context: context,
                                                message:
                                                    "Pick your Image or Images",
                                              );
                                              return;
                                            }
                                            if (state.video == null) {
                                              FxToast.showErrorToast(
                                                context: context,
                                                message: "Pick your Video",
                                              );
                                              return;
                                            }

                                            // if (state.accuracy.isEmpty) {
                                            //   HomeBloc.get(context).add(
                                            //       GetAccuracy(
                                            //           accuracy: (10 / 100)
                                            //               .toString()));
                                            //   // FxToast.showErrorToast(
                                            //   //   context: context,
                                            //   //   message:
                                            //   //       "Choose Accuracy on the SliderBar",
                                            //   // );
                                            //   return;
                                            // }
                                            HomeBloc.get(context).add(
                                                const EditPageCount(
                                                    pageCount: 0));

                                            HomeBloc.get(context).add(
                                                const reloadPath(
                                                    path_provided: ""));
                                            // HomeBloc.get(context).add(
                                            //     const reloadSnapShots(
                                            //         snapyy: []));
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
// /////////////////////////////////////////////////////////////////////////////////////
                              ///pagination for frames
                              BlocProvider.value(
                                value: HomeBloc.get(context),
                                child: BlocBuilder<HomeBloc, HomeState>(
                                  builder: (context, state) {
                                    ///frames Data
                                    return state.submission ==
                                            Submission.noDataFound
                                        ? const Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Text(
                                              "This Person Is Not In The Video",
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
                                                  // Display the list of data
                                                  SizedBox(
                                                    width:
                                                        // 200,
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: state.pathProvided
                                                            .isNotEmpty
                                                        ? 300
                                                        : 10,
                                                    child: Row(
                                                      children: [
                                                        state.pathProvided
                                                                .isNotEmpty
                                                            ? IconButton(
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .arrow_back_ios_new_outlined,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                onPressed: () {
                                                                  _scrollController
                                                                      .animateTo(
                                                                    _scrollController
                                                                            .offset -
                                                                        400, // Adjust as needed
                                                                    duration: const Duration(
                                                                        milliseconds:
                                                                            500),
                                                                    curve: Curves
                                                                        .easeInOut,
                                                                  );
                                                                  // _scrollController
                                                                  //     .animateTo(
                                                                  //   _scrollController.offset -
                                                                  //       MediaQuery.of(context).size.width, // Adjust the offset as needed
                                                                  //   duration:
                                                                  //       const Duration(milliseconds: 500),
                                                                  //   curve:
                                                                  //       Curves.easeInOut,
                                                                  // );
                                                                },
                                                              )
                                                            : const SizedBox(),
                                                        Expanded(
                                                          child:
                                                              ListView.builder(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            shrinkWrap: true,
                                                            physics:
                                                                const AlwaysScrollableScrollPhysics(),
                                                            itemCount: state
                                                                        .pageCount !=
                                                                    0
                                                                ? (state.pageCount <
                                                                        10)
                                                                    ? (state.pageCount %
                                                                        10)
                                                                    : (state.pageIndex ==
                                                                            (state.pageCount / 10)
                                                                                .ceil())
                                                                        ? (state.pageCount % 10 ==
                                                                                0)
                                                                            ? 10
                                                                            : (state.pageCount %
                                                                                10)
                                                                        : 10
                                                                : 0,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              // final image = state
                                                              //         .snapShots[
                                                              //     (state.pageIndex == 1 || state.pageIndex == 0
                                                              //                 ? 0
                                                              //                 : state.pageIndex - 1) *
                                                              //             10 +
                                                              //         (index)];

                                                              final data_time = state
                                                                  .data[(state.pageIndex == 1 ||
                                                                              state.pageIndex ==
                                                                                  0
                                                                          ? 0
                                                                          : state.pageIndex -
                                                                              1) *
                                                                      10 +
                                                                  (index)];
                                                              return SizedBox(
                                                                height: 300,
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          10.0),
                                                                  child: imagesListWidget(
                                                                      onTap: () {
                                                                        List<String>
                                                                            parts =
                                                                            data_time.split(RegExp(r'[:.]'));

                                                                        int hours =
                                                                            int.parse(parts[0]);
                                                                        int minutes =
                                                                            int.parse(parts[1]);
                                                                        int seconds =
                                                                            int.parse(parts[2]);

                                                                        // Calculate the total duration in seconds
                                                                        int totalSeconds = hours *
                                                                                3600 +
                                                                            minutes *
                                                                                60 +
                                                                            seconds;
                                                                        HomeBloc.get(context).add(SetTimeDuration(
                                                                            timeDuration:
                                                                                totalSeconds));

                                                                        ///////////////////////////////////////////////////////////////
                                                                        debugPrint(
                                                                            totalSeconds.toString());
                                                                      },
                                                                      onDownloadPressed: () {
                                                                        downloadImageFromWeb(
                                                                          imageUrl:
                                                                              "${state.pathProvided}/${state.pageIndex == 1 || state.pageIndex == 0 ? "" : state.pageIndex - 1}${index + 1 == 10 ? 9 : index + 1}.png",

                                                                          // downloadName:
                                                                          //     data_time,
                                                                        );
                                                                        // _downloadImage(
                                                                        //     data:
                                                                        //         image,
                                                                        //     downloadName:
                                                                        //         data_time);
                                                                      },
                                                                      imageSource: "${state.pathProvided}/${state.pageIndex == 1 || state.pageIndex == 0 ? "" : state.pageIndex - 1}${index + 1 == 10 ? 9 : index + 1}.png",
                                                                      text: data_time),
                                                                ),
                                                              );
                                                            },
                                                            controller:
                                                                _scrollController, // Assign the ScrollController here
                                                          ),
                                                        ),
                                                        state.pathProvided
                                                                .isNotEmpty
                                                            ? IconButton(
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .arrow_forward_ios_outlined,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                onPressed: () {
                                                                  // Handle scrolling to the right
                                                                  _scrollController
                                                                      .animateTo(
                                                                    _scrollController
                                                                            .offset +
                                                                        400, // Adjust as needed
                                                                    duration: const Duration(
                                                                        milliseconds:
                                                                            500),
                                                                    curve: Curves
                                                                        .easeInOut,
                                                                  );
                                                                  // _scrollController
                                                                  //     .animateTo(
                                                                  //   _scrollController.offset +
                                                                  //       MediaQuery.of(context).size.width, // Adjust the offset as needed
                                                                  //   duration:
                                                                  //       const Duration(milliseconds: 500),
                                                                  //   curve:
                                                                  //       Curves.easeInOut,
                                                                  // );
                                                                },
                                                              )
                                                            : const SizedBox(),
                                                      ],
                                                    ),
                                                  ),

                                                  // Display the pagination controls
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 15.0),
                                                    child: FlutterPagination(
                                                      // persons: state
                                                      //     .employeeNamesList, // Pass the list of data
                                                      listCount: (state
                                                                  .pageCount /
                                                              10)
                                                          .ceil(), // Pass the page count
                                                      onSelectCallback:
                                                          (int index) async {
                                                        HomeBloc.get(context)
                                                            .add(EditPageNumber(
                                                                pageIndex:
                                                                    index));
                                                      },
                                                      key: ValueKey<String>(
                                                          state.pathProvided),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                  },
                                ),
                              )
                            ],
                          ),
                        if (!Responsive.isWeb(context))
                          Column(
                            children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50.0, vertical: 20),
                                  child: SliderWidget(
                                    value: state.sliderValue,
                                    onChanged: (newValue) {
                                      HomeBloc.get(context).add(GetAccuracy(
                                          sliderValue: newValue,
                                          accuracy:
                                              (newValue / 100).toString()));
                                    },
                                  ),
                                ),
                              ),
                              // FxBox.h16,

                              // Here to search for an Employee in the database
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  // Images Carasol
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
                                                HomeBloc.get(context).add(
                                                  const loadingEvent(
                                                      load: true),
                                                );

                                                await FilePicker.platform
                                                    .pickFiles(
                                                  type: FileType.image,
                                                  allowMultiple: true,
                                                )
                                                    .then((result) {
                                                  HomeBloc.get(context).add(
                                                    const loadingEvent(
                                                        load: false),
                                                  );

                                                  if (result != null &&
                                                      result.files.isNotEmpty) {
                                                    List<Widget> images = [];
                                                    for (var imageFile
                                                        in result.files) {
                                                      final Uint8List?
                                                          imageBytes =
                                                          imageFile.bytes;

                                                      if (imageBytes != null) {
                                                        // Decode the image
                                                        final img.Image? image =
                                                            img.decodeImage(
                                                                imageBytes);

                                                        if (image != null) {
                                                          if (image.width >=
                                                                  300 &&
                                                              image.height >=
                                                                  300) {
                                                            final imageWidget =
                                                                Image.memory(
                                                              imageBytes,
                                                              fit: BoxFit.cover,
                                                            );

                                                            images.add(
                                                                imageWidget);

                                                            HomeBloc.get(
                                                                    context)
                                                                .add(
                                                              imagesList(
                                                                  imagesListdata:
                                                                      result
                                                                          .files),
                                                            );
                                                            // Process each selected image file
                                                            // HomeBloc.get(
                                                            //         context)
                                                            //     .add(
                                                            //   ImageToSearchForEmployee(
                                                            //       imageWidget:
                                                            //           imageWidget),
                                                            // );
                                                            // HomeBloc.get(
                                                            //         context)
                                                            //     .add(
                                                            //   imageevent(
                                                            //       imageFile:
                                                            //           imageFile),
                                                            // );

                                                            // HomeBloc.get(
                                                            //         context)
                                                            //     .add(
                                                            //   const loadingEvent(
                                                            //       load:
                                                            //           false),
                                                            // );
                                                          } else {
                                                            // Show a message to the user
                                                            FxToast.showErrorToast(
                                                                message:
                                                                    "Image resolution is too low. Minimum required is 300x300.",
                                                                context:
                                                                    context);

                                                            // HomeBloc.get(
                                                            //         context)
                                                            //     .add(
                                                            //   const loadingEvent(
                                                            //       load:
                                                            //           false),
                                                            // );
                                                          }
                                                        }
                                                      }
                                                    }

                                                    HomeBloc.get(context).add(
                                                        ImageListWidget(
                                                            imageWidgetss:
                                                                images));

                                                    // HomeBloc.get(context).add(
                                                    //   const loadingEvent(
                                                    //       load: false),
                                                    // );
                                                  }
                                                });

                                                // HomeBloc.get(context).add(
                                                //   const loadingEvent(
                                                //       load: false),
                                                // );
                                              },
                                              child: Stack(
                                                fit: StackFit.expand,
                                                children: [
                                                  if (state.load == true)
                                                    loadingIndicator(
                                                        color: AppColors
                                                            .buttonBlue),
                                                  if (state.load == false)
                                                    state.imagesListdata
                                                                ?.isNotEmpty ==
                                                            true
                                                        ? CarouselSlider(
                                                            carouselController:
                                                                _carouselController,
                                                            items: state
                                                                .imageWidgetss,
                                                            options:
                                                                CarouselOptions(
                                                              aspectRatio:
                                                                  16 / 9,
                                                              viewportFraction:
                                                                  0.8,
                                                              enableInfiniteScroll:
                                                                  false,
                                                              reverse: false,
                                                              autoPlay: true,
                                                              enlargeCenterPage:
                                                                  true,
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                            ),
                                                          )
                                                        : Image.asset(
                                                            'assets/images/imagepick.png',
                                                            width:
                                                                double.infinity,
                                                            height:
                                                                double.infinity,
                                                            fit: BoxFit.cover,
                                                          ),
                                                ],
                                              ),
                                            ),
                                            state.imagesListdata?.isNotEmpty ==
                                                        true &&
                                                    state.imagesListdata
                                                            ?.length !=
                                                        1
                                                ?
                                                // Left Button
                                                Positioned(
                                                    left: 0,
                                                    top: 110,
                                                    bottom: 110,
                                                    child: IconButton(
                                                      icon: const Icon(
                                                        Icons.arrow_left,
                                                        size: 35,
                                                      ),
                                                      onPressed: () {
                                                        // Scroll the carousel to the left
                                                        _carouselController
                                                            .previousPage();
                                                      },
                                                    ),
                                                  )
                                                : const Positioned(
                                                    child: Text("")),
                                            state.imagesListdata?.isNotEmpty ==
                                                        true &&
                                                    state.imagesListdata
                                                            ?.length !=
                                                        1
                                                ?
                                                // Right Button
                                                Positioned(
                                                    right: 0,
                                                    top: 110,
                                                    bottom: 110,
                                                    child: IconButton(
                                                      icon: const Icon(
                                                        Icons.arrow_right,
                                                        size: 35,
                                                      ),
                                                      onPressed: () {
                                                        // Scroll the carousel to the right
                                                        _carouselController
                                                            .nextPage();
                                                      },
                                                    ),
                                                  )
                                                : const Positioned(
                                                    child: Text("")),

                                            //info Button
                                            Positioned(
                                              top: 0,
                                              child: Tooltip(
                                                message:
                                                    "Images Less Than 300x300 In Resolution Will Be Dismissed",
                                                child: IconButton(
                                                  icon: const Icon(
                                                    Icons.info_outline,
                                                    color: AppColors.black,
                                                    size: 30,
                                                  ),
                                                  onPressed: () {},
                                                ),
                                              ),
                                            )
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
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          if (_controller != null)
                                            AspectRatio(
                                              aspectRatio: _controller!
                                                  .value.aspectRatio,
                                              child: Stack(children: [
                                                Chewie(
                                                  controller: ChewieController(
                                                    aspectRatio: _controller
                                                        ?.value.aspectRatio,
                                                    videoPlayerController:
                                                        _controller!,
                                                    autoPlay: false,
                                                    startAt: Duration(
                                                        seconds:
                                                            state.timeDuration),
                                                    autoInitialize: true,
                                                    looping: false,
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 0,
                                                  right: 0,
                                                  child: Tooltip(
                                                    message:
                                                        "Upload Another Video",
                                                    child: IconButton(
                                                      onPressed: () {
                                                        _pickVideo().then(
                                                            (PlatformFile?
                                                                videoFile) {
                                                          if (videoFile !=
                                                              null) {
                                                            HomeBloc.get(
                                                                    context)
                                                                .add(videoevent(
                                                                    video:
                                                                        videoFile));
                                                          }
                                                        });
                                                      },
                                                      icon: const Icon(
                                                        Icons.upload,
                                                        size: 45,
                                                        color: AppColors
                                                            .buttonBlue,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                            )
                                          else
                                            Tooltip(
                                              message: "Upload a video",
                                              child: GestureDetector(
                                                onTap: () {
                                                  _pickVideo().then(
                                                      (PlatformFile?
                                                          videoFile) {
                                                    if (videoFile != null) {
                                                      HomeBloc.get(context).add(
                                                          videoevent(
                                                              video:
                                                                  videoFile));
                                                    }
                                                  });
                                                },
                                                child: Image.asset(
                                                  'assets/images/iconVid.png',
                                                  // width: double.infinity,
                                                  // height: double.infinity,
                                                  // fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                        ],
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
                                            if (state.imageWidgetss.isEmpty) {
                                              FxToast.showErrorToast(
                                                context: context,
                                                message:
                                                    "Pick your Image or Images",
                                              );
                                              return;
                                            }
                                            if (state.video == null) {
                                              FxToast.showErrorToast(
                                                context: context,
                                                message: "Pick your Video",
                                              );
                                              return;
                                            }
                                            // if (state.accuracy.isEmpty) {
                                            //   HomeBloc.get(context).add(
                                            //       GetAccuracy(
                                            //           accuracy: (10 / 100)
                                            //               .toString()));
                                            //   // FxToast.showErrorToast(
                                            //   //   context: context,
                                            //   //   message:
                                            //   //       "Choose Accuracy on the SliderBar",
                                            //   // );
                                            //   return;
                                            // }
                                            HomeBloc.get(context).add(
                                                const EditPageCount(
                                                    pageCount: 0));

                                            HomeBloc.get(context).add(
                                                const reloadPath(
                                                    path_provided: ""));

                                            // HomeBloc.get(context).add(
                                            //     const reloadSnapShots(
                                            //         snapyy: []));
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
                              BlocProvider.value(
                                value: HomeBloc.get(context),
                                child: BlocBuilder<HomeBloc, HomeState>(
                                  builder: (context, state) {
                                    ///frames Data
                                    return state.submission ==
                                            Submission.noDataFound
                                        ? const Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Text(
                                              "This Person Is Not In The Video",
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 25,
                                              ),
                                            ))
                                        : Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              children: [
                                                // Display the list of data
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: state.pathProvided
                                                          .isNotEmpty
                                                      ? 300
                                                      : 10,
                                                  child: Row(
                                                    children: [
                                                      state.pathProvided
                                                              .isNotEmpty
                                                          ? IconButton(
                                                              icon: const Icon(
                                                                Icons
                                                                    .arrow_back_ios_new_outlined,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              onPressed: () {
                                                                _scrollController
                                                                    .animateTo(
                                                                  _scrollController
                                                                          .offset -
                                                                      400, // Adjust as needed
                                                                  duration: const Duration(
                                                                      milliseconds:
                                                                          500),
                                                                  curve: Curves
                                                                      .easeInOut,
                                                                );
                                                              },
                                                            )
                                                          : const SizedBox(),
                                                      Expanded(
                                                        child: ListView.builder(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          shrinkWrap: true,
                                                          physics:
                                                              const AlwaysScrollableScrollPhysics(),
                                                          itemCount: state
                                                                      .pageCount !=
                                                                  0
                                                              ? (state.pageCount <
                                                                      10)
                                                                  ? (state.pageCount %
                                                                      10)
                                                                  : (state.pageIndex ==
                                                                          (state.pageCount / 10)
                                                                              .ceil())
                                                                      ? (state.pageCount % 10 ==
                                                                              0)
                                                                          ? 10
                                                                          : (state.pageCount %
                                                                              10)
                                                                      : 10
                                                              : 0,
                                                          itemBuilder:
                                                              (context, index) {
                                                            // final image = state
                                                            //         .snapShots[
                                                            //     (state.pageIndex == 1 || state.pageIndex == 0
                                                            //                 ? 0
                                                            //                 : state.pageIndex - 1) *
                                                            //             10 +
                                                            //         (index)];

                                                            final data_time = state
                                                                .data[(state.pageIndex ==
                                                                                1 ||
                                                                            state.pageIndex ==
                                                                                0
                                                                        ? 0
                                                                        : state.pageIndex -
                                                                            1) *
                                                                    10 +
                                                                (index)];
                                                            return SizedBox(
                                                              height: 300,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        10.0),
                                                                child:
                                                                    imagesListWidget(
                                                                        onTap:
                                                                            () {
                                                                          List<String>
                                                                              parts =
                                                                              data_time.split(RegExp(r'[:.]'));

                                                                          int hours =
                                                                              int.parse(parts[0]);
                                                                          int minutes =
                                                                              int.parse(parts[1]);
                                                                          int seconds =
                                                                              int.parse(parts[2]);

                                                                          // Calculate the total duration in seconds
                                                                          int totalSeconds = hours * 3600 +
                                                                              minutes * 60 +
                                                                              seconds;
                                                                          HomeBloc.get(context)
                                                                              .add(SetTimeDuration(timeDuration: totalSeconds));

                                                                          ///////////////////////////////////////////////////////////////
                                                                          debugPrint(
                                                                              totalSeconds.toString());
                                                                        },
                                                                        onDownloadPressed:
                                                                            () {
                                                                          downloadImageFromWeb(
                                                                            imageUrl:
                                                                                "${state.pathProvided}/${state.pageIndex == 1 || state.pageIndex == 0 ? "" : state.pageIndex - 1}${index + 1 == 10 ? 9 : index + 1}.png",

                                                                            // downloadName:
                                                                            //     data_time,
                                                                          );
                                                                          // _downloadImage(
                                                                          //     data:
                                                                          //         image,
                                                                          //     downloadName:
                                                                          //         data_time);
                                                                        },
                                                                        imageSource:
                                                                            "${state.pathProvided}/${state.pageIndex == 1 || state.pageIndex == 0 ? "" : state.pageIndex - 1}${index + 1 == 10 ? 9 : index + 1}.png",
                                                                        text:
                                                                            data_time),
                                                              ),
                                                            );
                                                          },

                                                          controller:
                                                              _scrollController, // Assign the ScrollController here
                                                        ),
                                                      ),
                                                      state.pathProvided
                                                              .isNotEmpty
                                                          ? IconButton(
                                                              icon: const Icon(
                                                                Icons
                                                                    .arrow_forward_ios_outlined,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              onPressed: () {
                                                                // Handle scrolling to the right
                                                                _scrollController
                                                                    .animateTo(
                                                                  _scrollController
                                                                          .offset +
                                                                      400, // Adjust as needed
                                                                  duration: const Duration(
                                                                      milliseconds:
                                                                          500),
                                                                  curve: Curves
                                                                      .easeInOut,
                                                                );
                                                                // _scrollController
                                                                //     .animateTo(
                                                                //   _scrollController.offset +
                                                                //       MediaQuery.of(context).size.width, // Adjust the offset as needed
                                                                //   duration:
                                                                //       const Duration(milliseconds: 500),
                                                                //   curve:
                                                                //       Curves.easeInOut,
                                                                // );
                                                              },
                                                            )
                                                          : const SizedBox(),
                                                    ],
                                                  ),
                                                ),

                                                // Display the pagination controls
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 15.0),
                                                  child: FlutterPagination(
                                                    // persons: state
                                                    //     .employeeNamesList, // Pass the list of data
                                                    listCount: (state
                                                                .pageCount /
                                                            10)
                                                        .ceil(), // Pass the page count
                                                    onSelectCallback:
                                                        (int index) async {
                                                      HomeBloc.get(context).add(
                                                          EditPageNumber(
                                                              pageIndex:
                                                                  index));
                                                    },
                                                    key: ValueKey<String>(
                                                        state.pathProvided),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                  },
                                ),
                              )
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
  Future<PlatformFile?> _pickVideo(
      // {required int? timeDuratioin}
      ) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result != null) {
      final videoFile = result.files.first;
      final Uint8List videoBytes = videoFile.bytes!;
      final blob = html.Blob([videoBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);

      _controller = VideoPlayerController.networkUrl(Uri.parse(url))
        ..initialize().then((_) {
          // timeDuratioin == null
          _controller?.pause();
          // : _controller!.seekTo(Duration(seconds: timeDuratioin));
        });

      return videoFile; // Return the picked video file
    } else {
      return null; // Return null if no file is picked
    }
  }

////////////////////////////////////////////////////////////////////////////////

  Widget imagesListWidget({
    // required String image64,
    required Function() onTap,
    required String imageSource,
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
            Tooltip(
              message: "Go To Frame In Video",
              child: GestureDetector(
                onTap: onTap,
                // () {

                //   Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => FullScreenImage(
                //               text: text,
                //               imageUrl:
                //                   "http:${RemoteDataSource.baseUrlWithoutPort}8000/${imageSource}")));
                // },
                child: Image.network(
                  "http:${RemoteDataSource.baseUrlWithoutPort}8000/$imageSource",
                  width: double.infinity,
                  height: double.infinity,
                  // Images.profileImage,
                  fit: BoxFit.cover,
                ),
                //     Image.memory(
                //   _decodeBase64Image(base64Image: image64),
                //   width: double.infinity,
                //   height: double.infinity,
                //   fit: BoxFit.cover,
                // ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                color: Colors.black.withOpacity(0.5),
                child: GestureDetector(
                  onTap: onTap,
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Tooltip(
                message: "Open Image",
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FullScreenImage(
                                text: text,
                                imageUrl:
                                    "http:${RemoteDataSource.baseUrlWithoutPort}8000/$imageSource")));
                  },
                  icon: const Icon(
                    Icons.crop_free_sharp,
                    size: 45,
                    color: AppColors.buttonBlue,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Tooltip(
                message: "Download This Frame",
                child: IconButton(
                  onPressed: onDownloadPressed,
                  icon: const Icon(
                    Icons.download,
                    size: 45,
                    color: AppColors.buttonBlue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Uint8List _decodeBase64Image({required String base64Image}) {
  //   final bytes = base64.decode(base64Image);
  //
  //   return Uint8List.fromList(bytes);
  // }

  // _downloadImage({required String data, String downloadName = 'image'}) async {
  //   if (data.isNotEmpty) {
  //     try {
  //       final uint8List = _decodeBase64Image(base64Image: data);
  //       // first we make a request to the url like you did
  //       // in the android and ios version
  //       // final http.Response r = await http.get(
  //       //   Uri.parse(getPhotosServerLink(imageUrl)),
  //       // );

  //       // we get the bytes from the body
  //       // final data = r.bodyBytes;
  //       // and encode them to base64
  //       final base64data = base64Encode(uint8List);

  //       // then we create and AnchorElement with the html package
  //       final a =
  //           html.AnchorElement(href: 'data:image/jpeg;base64,$base64data');

  //       // set the name of the file we want the image to get
  //       // downloaded to
  //       a.download = '$downloadName.jpg';

  //       // and we click the AnchorElement which downloads the image
  //       a.click();
  //       // finally we remove the AnchorElement
  //       a.remove();
  //     } catch (e) {
  //       if (kDebugMode) {
  //         print(e);
  //       }
  //     }
  //   } else {
  //     EasyLoading.showError('لا يوجد صورة');
  //   }
  // }

  // Future<Uint8List?> pickImageWithResolution(
  //     {required int minWidth, required int minHeight}) async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  //   if (pickedFile != null) {
  //     final Uint8List imageBytes = await pickedFile.readAsBytes();

  //     // Decode the image
  //     final img.Image? image = img.decodeImage(imageBytes);

  //     if (image != null) {
  //       if (image.width >= minWidth && image.height >= minHeight) {
  //         return imageBytes;
  //       } else {
  //         // Show a message or handle the error that image resolution is too low
  //         print(
  //             "Image resolution is too low. Minimum required is ${minWidth}x${minHeight}");
  //         return null;
  //       }
  //     }
  //   }
  //   return null;
  // }

  @override
  void dispose() {
    // _controller?.dispose();
    _scrollController.dispose();

    super.dispose();
  }
}
