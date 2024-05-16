import 'dart:convert';
import 'dart:typed_data';
import 'dart:html' as html;

import 'package:Investigator/core/widgets/FullImageURL.dart';
import 'package:chewie/chewie.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import '../../../core/enum/enum.dart';
import '../../../core/loader/loading_indicator.dart';
import '../../../core/remote_provider/remote_data_source.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/image_downloader.dart';
import '../../../core/widgets/persons_per_widget.dart';
import '../../../core/widgets/sizedbox.dart';
import '../../../core/widgets/toast/toast.dart';
import '../bloc/history_bloc.dart';

class HistoryDetails extends StatefulWidget {
  final String path;
  // final String count;
  final List<String> images;

  const HistoryDetails({Key? key, required this.path, required this.images})
      : super(key: key);

  @override
  State<HistoryDetails> createState() => _HistoryDetails();
}

/// correct place to load iFrame

class _HistoryDetails extends State<HistoryDetails> {
  // final CarouselController _carouselController = CarouselController();

  late ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGround,
      appBar: AppBar(
        backgroundColor: AppColors.backGround,

        iconTheme: const IconThemeData(
            color: Colors.white), // Set back button color to white
        title: const Text(
          "History Details",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: BlocProvider(
        create: (context) => HistoryBloc()
          // ..add(CameraDetailsEvent(cameraName: widget.cameraName)),
          ..add(EditvideoPathForHistory(videoPathForHistory: widget.path)),
        // ..add(EditPageCount(pageCount: int.parse(widget.count)))

        child: BlocListener<HistoryBloc, HistoryState>(
          listener: (context, state) {
            if (state.submission == Submission.success) {
              FxToast.showSuccessToast(
                  context: context,
                  message: state.responseMessage.isNotEmpty
                      ? state.responseMessage
                      : null);
            }
            if (state.submission == Submission.error) {
              FxToast.showErrorToast(
                  context: context,
                  message: state.responseMessage.isNotEmpty
                      ? state.responseMessage
                      : null);
            }
          },
          child: BlocBuilder<HistoryBloc, HistoryState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: widget.images.isNotEmpty
                            ? MainAxisAlignment.spaceAround
                            : MainAxisAlignment.center,
                        children: [
                          widget.images.isNotEmpty
                              ? SizedBox(
                                  height: 300,
                                  width: 300,
                                  child: Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: InkWell(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (ctx) {
                                                return AlertDialog(
                                                    title: const Text(
                                                        "Images Searched With"),
                                                    content:
                                                        // SingleChildScrollView(
                                                        //   child:
                                                        SizedBox(
                                                      width: 400,
                                                      height: 400,
                                                      child: GridView.builder(
                                                        gridDelegate:
                                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount:
                                                              2, // Number of columns in the grid
                                                          crossAxisSpacing:
                                                              10, // Spacing between columns
                                                          mainAxisSpacing:
                                                              10, // Spacing between rows
                                                        ),
                                                        itemCount: widget
                                                            .images.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          // Display images from the URL in a grid
                                                          return GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          FullScreenImageFromUrl(
                                                                            text:
                                                                                "",
                                                                            imageUrl:
                                                                                "http:${RemoteDataSource.baseUrlWithoutPort}8000/${widget.images[index].split("Image_Database/")[1]}",
                                                                          )));
                                                            },
                                                            child:
                                                                Image.network(
                                                              "http:${RemoteDataSource.baseUrlWithoutPort}8000/${widget.images[index].split("Image_Database/")[1]}",
                                                              fit: BoxFit.cover,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    // ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop(); // Close the dialog
                                                        },
                                                        child: const Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ),
                                                    ]);
                                              });
                                        },
                                        child: Stack(
                                          children: [
                                            if (widget.images.isNotEmpty)
                                              ListView.builder(
                                                scrollDirection: Axis.vertical,
                                                itemCount: widget.images.length,
                                                itemBuilder: (context, index) {
                                                  final imageUrl =
                                                      widget.images[index];
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Image.network(
                                                      "http:${RemoteDataSource.baseUrlWithoutPort}8000/${imageUrl.split("Image_Database/")[1]}",
                                                      fit: BoxFit.cover,
                                                    ),
                                                  );
                                                },
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          Center(
                            child: SizedBox(
                              height: 300,
                              width: 700,
                              child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: _buildVideoPlayerWidget(
                                      // urlFromHistory:
                                      "http:${RemoteDataSource.baseUrlWithoutPort}8000/${widget.path.split("Image_Database/")[1]}",
                                      state.secondsGivenFromVideo)),
                            ),
                          ),
                        ],
                      ),
                      FxBox.h16,
                      BlocProvider.value(
                        value: HistoryBloc.get(context),
                        child: BlocBuilder<HistoryBloc, HistoryState>(
                          builder: (context, state) {
                            return state.submission == Submission.noDataFound
                                ? const Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text(
                                      "No Data Available",
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
                                          // Display the pagination controls

                                          // Display the list of data
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 200,
                                            child:
                                                (state.submission ==
                                                        Submission.noDataFound)
                                                    ? const Center(
                                                        child: Text(
                                                        "No data found Yet!",
                                                        style: TextStyle(
                                                            color:
                                                                AppColors.blueB,
                                                            fontSize: 25,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ))
                                                    : Row(
                                                        children: [
                                                          IconButton(
                                                            icon: const Icon(
                                                              Icons
                                                                  .arrow_back_ios_new_outlined,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            onPressed: () {
                                                              _scrollController
                                                                  .animateTo(
                                                                _scrollController
                                                                        .offset -
                                                                    400, // Adjust as needed
                                                                duration:
                                                                    const Duration(
                                                                        milliseconds:
                                                                            500),
                                                                curve: Curves
                                                                    .easeInOut,
                                                              );
                                                            },
                                                          ),
                                                          Expanded(
                                                            child: ListView
                                                                .builder(
                                                              controller:
                                                                  _scrollController,
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              shrinkWrap: true,
                                                              physics:
                                                                  const AlwaysScrollableScrollPhysics(),
                                                              itemCount: state
                                                                          .pathForImages
                                                                          .count !=
                                                                      0
                                                                  ? (state.pathForImages
                                                                              .count! <
                                                                          10)
                                                                      ? (state.pathForImages
                                                                              .count! %
                                                                          10)
                                                                      : (state.pageIndex ==
                                                                              (state.pathForImages.count! / 10).ceil())
                                                                          ? (state.pathForImages.count! % 10 == 0)
                                                                              ? 10
                                                                              : (state.pathForImages.count! % 10)
                                                                          : 10
                                                                  : 0,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                final data_time = state
                                                                    .pathForImages
                                                                    .timestamp?[(state.pageIndex == 1 || state.pageIndex == 0
                                                                            ? 0
                                                                            : state.pageIndex -
                                                                                1) *
                                                                        10 +
                                                                    (index)];
                                                                return SizedBox(
                                                                  height: 200,
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            10.0),
                                                                    child:
                                                                        imagesListWidget(
                                                                      onTapTime:
                                                                          () {
                                                                        List<String>
                                                                            parts =
                                                                            data_time!.split(RegExp(r'[:.]'));

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
                                                                        HistoryBloc.get(context).add(SecondsGivenFromVideoEvent(
                                                                            secondsGivenFromVideo:
                                                                                totalSeconds));
                                                                      },
                                                                      timeText:
                                                                          data_time ??
                                                                              "",
                                                                      onDownloadPressed:
                                                                          () {
                                                                        downloadImageFromWeb(
                                                                          imageUrl:
                                                                              "${state.pathForImages.filePath?.split('/').sublist(1, state.pathForImages.filePath!.split('/').length - 1).join('/')}/${state.pageIndex == 1 || state.pageIndex == 0 ? "" : state.pageIndex - 1}${index + 1 == 10 ? 9 : index + 1}.png",
                                                                        );
                                                                      },
                                                                      imageSource:
                                                                          "${state.pathForImages.filePath?.split('/').sublist(1, state.pathForImages.filePath!.split('/').length - 1).join('/')}/${state.pageIndex == 1 || state.pageIndex == 0 ? "" : state.pageIndex - 1}${index + 1 == 10 ? 9 : index + 1}.png",
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                          IconButton(
                                                            icon: const Icon(
                                                              Icons
                                                                  .arrow_forward_ios_outlined,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            onPressed: () {
                                                              // Handle scrolling to the right
                                                              _scrollController
                                                                  .animateTo(
                                                                _scrollController
                                                                        .offset +
                                                                    400, // Adjust as needed
                                                                duration:
                                                                    const Duration(
                                                                        milliseconds:
                                                                            500),
                                                                curve: Curves
                                                                    .easeInOut,
                                                              );
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 15.0),
                                            child: CustomPagination(
                                              // persons: state
                                              //     .employeeNamesList, // Pass the list of data
                                              pageCount: (state.pathForImages
                                                          .count! /
                                                      10)
                                                  .ceil(), // Pass the page count
                                              onPageChanged: (int index) async {
                                                HistoryBloc.get(context).add(
                                                    EditPageNumberInsideHistoryDetails(
                                                        pageIndex: index));
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                          },
                        ),
                      ),
                      FxBox.h24,
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget imagesListWidget({
    String? image64,
    required String imageSource,
    String? text,
    required String timeText,
    required VoidCallback onDownloadPressed,
    required Function()? onTapTime,
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
                onTap: onTapTime,
                // () {
                // print(imageSource);

                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => FullScreenImageFromUrl(
                //             text: text ?? "",
                //             imageUrl:
                //                 "http:${RemoteDataSource.baseUrlWithoutPort}8000/${imageSource}")));
                // },
                child: Image.network(
                  "http:${RemoteDataSource.baseUrlWithoutPort}8000/${imageSource}",

                  width: double.infinity,
                  height: double.infinity,
                  // Images.profileImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            //    Image.memory(
            //     _decodeBase64Image(base64Image: image64),
            //     width: double.infinity,
            //     height: double.infinity,
            //     fit: BoxFit.cover,
            //   ),
            // ),
            // Container(
            //   padding: const EdgeInsets.all(8),
            //   color: Colors.black.withOpacity(0.5),
            //   child: Text(
            //     text,
            //     style: const TextStyle(
            //       color: Colors.white,
            //       fontSize: 16,
            //     ),
            //   ),
            // ),
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
                            builder: (context) => FullScreenImageFromUrl(
                                text: text ?? "",
                                imageUrl:
                                    "http:${RemoteDataSource.baseUrlWithoutPort}8000/${imageSource}")));
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
              bottom: 0,
              left: 0,
              child: InkWell(
                onTap: onTapTime,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.black.withOpacity(0.5),
                  child: Text(
                    timeText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
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

  //   return Uint8List.fromList(bytes);
  // }

  // Widget _commonText(String text) {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(
  //       vertical: Responsive.isMobile(context) ? 8.0 : 0.0,
  //     ),
  //     child: Text(
  //       text,
  //       style: const TextStyle(
  //         fontWeight: FontWeight.w600,
  //       ),
  //     ),
  //   );
  // }

/////////////////////////////////////////////////////////////////////////////////////////////////////
  // Future<PlatformFile?> _pickVideo(
  //     {required VideoPlayerController? controller_}) async {
  //   // replace this later
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.video,
  //   );

  //   if (result != null) {
  //     final videoFile = result.files.first;
  //     final Uint8List videoBytes = videoFile.bytes!;
  //     final blob = html.Blob([videoBytes]);
  //     final url = html.Url.createObjectUrlFromBlob(blob);

  //     controller_ = VideoPlayerController.network(url)
  //       ..initialize().then((_) {
  //         // timeDuratioin == null
  //         controller_?.pause();
  //         // : _controller!.seekTo(Duration(seconds: timeDuratioin));
  //       });

  //     return videoFile; // Return the picked video file
  //   } else {
  //     return null; // Return null if no file is picked
  //   }
  // }

  Widget _buildVideoPlayerWidget(
    String videoUrl,
    int secondsGiven,
  ) {
    final videoPlayerController = VideoPlayerController.network(videoUrl);
    final chewieController = ChewieController(
      aspectRatio: videoPlayerController.value.aspectRatio,
      videoPlayerController: videoPlayerController,
      autoPlay: false,
      startAt: Duration(seconds: secondsGiven),
      autoInitialize: true,
      // looping: true,
    );

    return (chewieController.videoPlayerController.dataSource.isEmpty)
        ? Center(
            child: loadingIndicator(
              color: AppColors.buttonBlue,
            ), // Display circular progress indicator while loading
          )
        :
        //                                 :

        Chewie(
            controller: chewieController,
          );
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }
}
