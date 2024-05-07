import 'dart:convert';
import 'dart:typed_data';

// import 'package:Investigator/core/widgets/fullscreenImage.dart';
// import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
// import 'package:luminalens/core/enum/enum.dart';
// import 'package:luminalens/core/loader/loading_indicator.dart';
// import 'package:luminalens/core/remote_provider/remote_data_source.dart';
// import 'package:luminalens/core/resources/app_colors.dart';
// import 'package:luminalens/core/utils/responsive.dart';
// import 'package:luminalens/core/widgets/badge_builder.dart';
// import 'package:luminalens/core/widgets/sizedbox.dart';
// import 'package:luminalens/presentation/all_cameras/bloc/camera_bloc.dart';
// import 'package:luminalens/presentation/standard_layout/screens/standard_layout.dart';
// import 'package:month_picker_dialog/month_picker_dialog.dart';

import 'dart:html' as html;
// import 'dart:ui_web' as ui;

import '../../../core/enum/enum.dart';
import '../../../core/loader/loading_indicator.dart';
import '../../../core/remote_provider/remote_data_source.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/utils/responsive.dart';
// import '../../../core/widgets/badge_builder.dart';
import '../../../core/widgets/image_downloader.dart';
import '../../../core/widgets/persons_per_widget.dart';
import '../../../core/widgets/sizedbox.dart';
import '../../../core/widgets/toast/toast.dart';
import '../../standard_layout/screens/standard_layout.dart';
import '../bloc/history_bloc.dart';

class HistoryDetails extends StatefulWidget {
  final String path;
  final String count;

  const HistoryDetails({Key? key, required this.path, required this.count})
      : super(key: key);

  @override
  State<HistoryDetails> createState() => _CameraDetailsState();
}

/// correct place to load iFrame
///

class _CameraDetailsState extends State<HistoryDetails> {
  @override
  Widget build(BuildContext context) {
    return StandardLayoutScreen(
      body: BlocProvider(
        create: (context) => HistoryBloc()
          // ..add(CameraDetailsEvent(cameraName: widget.cameraName)),
          ..add(EditPathProvided(pathProvided: widget.path))
          ..add(EditPageCount(pageCount: int.parse(widget.count))),

        // ..add(const CameraInitializeDate()),
        // ..add(GetVehicleDashboardData(cameraName: widget.cameraName))
        // ..add(GetGenderDashboardData(cameraName: widget.cameraName))
        // ..add(GetAgeDashboardData(cameraName: widget.cameraName))
        // ..add(GetViolenceDashboardData(cameraName: widget.cameraName)),
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
            buildWhen: (previous, current) {
              return previous.pathProvided != current.pathProvided;
            },
            builder: (context, state) {
              // if (state.singleCameraDetails.isEmpty) {
              //   return Center(child: loadingIndicator());
              // }

              return BlocBuilder<HistoryBloc, HistoryState>(
                builder: (context, state) {
                  return Card(
                    margin: const EdgeInsets.all(20),
                    color: AppColors.backGround,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            /// Live Preview
                            // Card(
                            //   child: Container(
                            //     width: MediaQuery.of(context).size.width,
                            //     height: 500,
                            //     padding: const EdgeInsets.all(10.0),
                            //     // width: Responsive.isMobile(context)
                            //     //     ? MediaQuery.of(context).size.width
                            //     //     : MediaQuery.of(context).size.width * 0.2,
                            //     child: iframeWidget,
                            //   ),
                            // ),
                            // FxBox.h24,
                            // SizedBox(
                            //   width: double.infinity,
                            //   child: Text(state.pathProvided,
                            //       style: const TextStyle(
                            //           color: Colors.white,
                            //           fontSize: 20,
                            //           fontWeight: FontWeight.bold)),
                            // ),

                            FxBox.h24,

                            FxBox.h24,
                            BlocProvider.value(
                              value: HistoryBloc.get(context),
                              child: BlocBuilder<HistoryBloc, HistoryState>(
                                builder: (context, state) {
                                  return state.submission ==
                                          Submission.noDataFound
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
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 15.0),
                                                  child: CustomPagination(
                                                    // persons: state
                                                    //     .employeeNamesList, // Pass the list of data
                                                    pageCount: (state
                                                                .pageCount /
                                                            10)
                                                        .ceil(), // Pass the page count
                                                    onPageChanged:
                                                        (int index) async {
                                                      HistoryBloc.get(context)
                                                          .add(EditPageNumber(
                                                              pageIndex:
                                                                  index));
                                                    },
                                                  ),
                                                ),
                                                // Display the list of data
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child:
                                                      (state.submission ==
                                                              Submission
                                                                  .noDataFound)
                                                          ? const Center(
                                                              child: Text(
                                                              "No data found Yet!",
                                                              style: TextStyle(
                                                                  color:
                                                                      AppColors
                                                                          .blueB,
                                                                  fontSize: 25,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ))
                                                          : GridView.builder(
                                                              shrinkWrap: true,
                                                              physics:
                                                                  const NeverScrollableScrollPhysics(),
                                                              itemCount: state
                                                                          .pageCount !=
                                                                      0
                                                                  ? (state.pageCount <
                                                                          10)
                                                                      ? (state.pageCount %
                                                                          10)
                                                                      : (state.pageIndex ==
                                                                              (state.pageCount / 10).ceil())
                                                                          ? (state.pageCount % 10 == 0)
                                                                              ? 10
                                                                              : (state.pageCount % 10)
                                                                          : 10
                                                                  : 0,
                                                              gridDelegate: Responsive
                                                                      .isMobile(
                                                                          context)
                                                                  ? const SliverGridDelegateWithFixedCrossAxisCount(
                                                                      crossAxisCount:
                                                                          1,
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
                                                                      : MediaQuery.of(context).size.width <
                                                                              1500
                                                                          ? SliverGridDelegateWithMaxCrossAxisExtent(
                                                                              maxCrossAxisExtent: MediaQuery.of(context).size.width * 0.24,
                                                                              crossAxisSpacing: 45,
                                                                              mainAxisSpacing: 45,
                                                                              mainAxisExtent: 350,
                                                                            )
                                                                          : SliverGridDelegateWithMaxCrossAxisExtent(
                                                                              maxCrossAxisExtent: MediaQuery.of(context).size.width * 0.24,
                                                                              crossAxisSpacing: 45,
                                                                              mainAxisSpacing: 45,
                                                                              mainAxisExtent: 350,
                                                                            ),
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

                                                                // final names = state
                                                                //     .data[(state.pageIndex == 1 ||
                                                                //                 state.pageIndex ==
                                                                //                     0
                                                                //             ? 0
                                                                //             : state.pageIndex -
                                                                //                 1) *
                                                                //         10 +
                                                                //     (index)];

                                                                // final data_time = state
                                                                //         .timestamps[
                                                                //     (state.pageIndex == 1 || state.pageIndex == 0
                                                                //                 ? 0
                                                                //                 : state.pageIndex - 1) *
                                                                //             10 +
                                                                //         (index)];
                                                                return imagesListWidget(
                                                                  onDownloadPressed:
                                                                      () {
                                                                    downloadImageFromWeb(
                                                                      imageUrl:
                                                                          "${state.pathProvided}/${state.pageIndex == 1 || state.pageIndex == 0 ? "" : state.pageIndex - 1}${index + 1 == 10 ? 9 : index + 1}.png",

                                                                      // downloadName:
                                                                      //     data_time,
                                                                    );
                                                                  },
                                                                  // timeText:
                                                                  //     data_time,
                                                                  // image64: image,
                                                                  imageSource:
                                                                      "${state.pathProvided}/${state.pageIndex == 1 || state.pageIndex == 0 ? "" : state.pageIndex - 1}${index + 1 == 10 ? 9 : index + 1}.png",
                                                                  // text: names
                                                                );
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
                    ),
                  );
                },
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
    String? timeText,
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
                print(imageSource);

                // Navigator.push(
                //     context,
                // MaterialPageRoute(
                //     builder: (context) => FullScreenImageFromMemory(
                //         text: text, imageUrl: image64)));
              },
              child: Image.network(
                "http:${RemoteDataSource.baseUrlWithoutPort}8000/${imageSource}",

                width: double.infinity,
                height: double.infinity,
                // Images.profileImage,
                fit: BoxFit.cover,
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
            // Positioned(
            //   bottom: 0,
            //   right: 0,
            //   child: Container(
            //     padding: const EdgeInsets.all(8),
            //     color: Colors.black.withOpacity(0.5),
            //     child: Text(
            //       timeText,
            //       style: const TextStyle(
            //         color: Colors.white,
            //         fontSize: 16,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Uint8List _decodeBase64Image({required String base64Image}) {
    final bytes = base64.decode(base64Image);

    return Uint8List.fromList(bytes);
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
