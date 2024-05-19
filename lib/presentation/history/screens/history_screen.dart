import 'package:Investigator/core/enum/enum.dart';
import 'package:Investigator/core/loader/loading_indicator.dart';
import 'package:Investigator/core/remote_provider/remote_data_source.dart';
import 'package:Investigator/core/widgets/persons_per_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chewie/chewie.dart';

import 'package:video_player/video_player.dart';

import '../../../core/resources/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/FullImageURL.dart';
import '../../../core/widgets/sizedbox.dart';
// import '../../standard_layout/bloc/standard_layout_cubit.dart';
import '../../standard_layout/screens/standard_layout.dart';
import '../bloc/history_bloc.dart';
import 'history_details.dart';
import '../../../core/widgets/video_player_widget.dart';

class AllHistoryScreen extends StatelessWidget {
  AllHistoryScreen({Key? key}) : super(key: key);
  final CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    // StandardLayoutCubit.get(context).onEditPageNavigationNumber(9);
    return StandardLayoutScreen(
      body: BlocProvider(
        create: (context) => HistoryBloc()..add(const PathesDataEvent()),
        child: BlocListener<HistoryBloc, HistoryState>(
          listener: (context, state) {
            if (state.submission == Submission.loading) {
              loadingIndicator();
            }
          },
          child: BlocBuilder<HistoryBloc, HistoryState>(
            builder: (context, state) {
              // if (state.submission == Submission.loading) {
              //   return Center(
              //     child: GridView.builder(
              //         itemCount: 6,
              //         itemBuilder: (context, index) {
              //           return Shimmer.fromColors(
              //             baseColor: const Color.fromARGB(255, 110, 101, 101),
              //             highlightColor: const Color.fromARGB(255, 70, 63, 63),
              //             child: SizedBox(
              //               // height: 200,
              //               width: Responsive.isMobile(context)
              //                   ? MediaQuery.of(context).size.width
              //                   : Responsive.isTablet(context)
              //                       ? MediaQuery.of(context).size.width * 0.45
              //                       : MediaQuery.of(context).size.width * 0.35,
              //               child: Padding(
              //                 padding: const EdgeInsets.all(8.0),
              //                 child: _dataOfCamera(
              //                   onPressed: () {},
              //                   images: [],
              //                   urlFromHistory: "",
              //                   date: "",
              //                   time: "",
              //                   name: "",
              //                   context: context,
              //                 ),
              //               ),
              //             ),
              //           );
              //         },
              //         gridDelegate:
              //             const SliverGridDelegateWithFixedCrossAxisCount(
              //           crossAxisCount: 2,
              //           childAspectRatio: 1,
              //           crossAxisSpacing: 17,
              //           mainAxisSpacing: 10,
              //         )),
              //   );
              // } else {
              return Card(
                margin: const EdgeInsets.all(20),
                color: AppColors.backGround,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      FxBox.h24,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "History".tr(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Flexible(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      // topLeft:
                                      Radius.circular(15.0), // Curved side
                                      // bottomLeft:
                                      //     Radius.circular(15.0), // Square side
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  showDatePicker(
                                    context: context,
                                    lastDate: DateTime(3000),
                                    firstDate: DateTime(2020),
                                  ).then(
                                    (value) {
                                      if (value != null) {
                                        // CameraBloc.get(context).add(
                                        //     const CameraAddHour(
                                        //         selectedHour: ""));
                                        // CameraBloc.get(context).add(
                                        //     const CameraAddMinute(
                                        //         selectedMinute: ""));
                                        // CameraBloc.get(context).add(
                                        //   const CameraAddStartDay(
                                        //       selectedStartDay: ""),
                                        // );
                                        // CameraBloc.get(context).add(
                                        //   const CameraAddStartMonth(
                                        //       selectedStartMonth: ""),
                                        // );
                                        // CameraBloc.get(context).add(
                                        //   const CameraAddStartYear(
                                        //       selectedStartYear: ""),
                                        // );

                                        // CameraBloc.get(context).add(
                                        //   const CameraAddEndDay(
                                        //       selectedEndDay: ""),
                                        // );
                                        // CameraBloc.get(context).add(
                                        //   const CameraAddEndMonth(
                                        //       selectedEndMonth: ""),
                                        // );
                                        // CameraBloc.get(context).add(
                                        //   const CameraAddEndYear(
                                        //       selectedEndYear: ""),
                                        // );

                                        HistoryBloc.get(context).add(
                                            SearchByDay(
                                                selectedDay: "${value.day}"));

                                        HistoryBloc.get(context).add(
                                            SearchByMonth(
                                                selectedMonth:
                                                    "${value.month}"));

                                        HistoryBloc.get(context).add(
                                            SearchByYear(
                                                selectedYear: "${value.year}"));

                                        HistoryBloc.get(context)
                                            .add(const FilterSearchDataEvent());
                                        HistoryBloc.get(context).add(
                                            const EditPageNumberFiltered(
                                                pageIndex: 1));
                                      }
                                    },
                                  );
                                },
                                child: Text(
                                  (state.selectedDay.isEmpty)
                                      ? "Date Filtration".tr()
                                      : "${state.selectedDay}/${state.selectedMonth}/${state.selectedYear}",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      FxBox.h24,
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child:
                            //  BlocBuilder<HistoryBloc, HistoryState>(
                            //   // buildWhen: (previous, current) =>
                            //   //     previous.pageCount != current.pageCount,
                            //   builder: (context, state) {
                            //     return
                            CustomPagination(
                          // defaultValue: state.pageIndex,
                          // persons: state
                          //     .employeeNamesList, // Pass the list of data
                          pageCount: state.pageCount, // Pass the page count

                          onPageChanged: (int index) async {
                            ///////////////////////////
                            if (state.selectedDay.isNotEmpty) {
                              HistoryBloc.get(context).add(
                                  EditPageNumberFiltered(pageIndex: index));
                            } else {
                              HistoryBloc.get(context)
                                  .add(EditPageNumber(pageIndex: index));
                            }
                            //////////////////////////////
                          },
                          key: ValueKey<String>(
                              "${state.selectedDay}"), // Use state.pageIndex as ValueKey
                        ),
                        // },
                        // ),
                      ),
                      FxBox.h24,
                      (state.submission != Submission.noDataFound)
                          ? Wrap(
                              children: _responsiveCardList(
                                context: context,
                                state: state,
                              ),
                            )
                          : Column(
                              children: [
                                const Center(
                                  child: Text(
                                    "No History Yet!",
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 30),
                                  ),
                                ),
                                FxBox.h56,
                                FxBox.h56,
                                FxBox.h56,
                                FxBox.h56,
                              ],
                            ),
                    ],
                  ),
                ),
              );
              // }
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _responsiveCardList(
      {required BuildContext context, required HistoryState state}) {
    return List.generate(
      state.allHistory.length,
      (index) => Column(
        children: [
          SizedBox(
              width: Responsive.isMobile(context)
                  ? MediaQuery.of(context).size.width
                  : Responsive.isTablet(context)
                      ? MediaQuery.of(context).size.width * 0.45
                      : MediaQuery.of(context).size.width * 0.35,
              // height: 200,
              child: _dataOfCamera(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HistoryDetails(
                                  pathsended:
                                      state.allHistory[index].videoPath ?? "",
                                  path: state.allHistory[index].videoUrl ?? "",
                                  images:
                                      state.allHistory[index].imagePaths ?? [],
                                )));

                    // Routemaster.of(context).push(
                    //   "/requestDetails",
                    //   queryParameters: {
                    //     "process": state.allHistory[index].videoPath ?? "",
                    //     // "timeStamp": state.allHistory[index].timestamp ?? "",
                    //   },
                    // );
                  },
                  images: state.allHistory[index].imagePaths,
                  urlFromHistory: state.allHistory[index].videoUrl ?? "",
                  date: state.allHistory[index].timestamp?.split("_")[0] ?? "",
                  time: state.allHistory[index].timestamp?.split("_")[1] ?? "",
                  name: state.allHistory[index].function ?? "",
                  // models: state.allPathes[index].count.,
                  context: context)),
        ],
      ),
    );
  }

  Widget _dataOfCamera({
    required Function() onPressed,
    required String urlFromHistory,
    required String name,
    required String date,
    required String time,
    required List<String>? images,
    required BuildContext context,
  }) {
    return Card(
      surfaceTintColor: Colors.transparent,
      elevation: 2,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      FxBox.h10,
                      Text(
                        name,
                        maxLines: 3,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      FxBox.h10,
                      Text(
                        date,
                        maxLines: 3,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      FxBox.h10,
                      Text(
                        time,
                        maxLines: 3,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  (name != "db search")
                      ? SizedBox(
                          height: 100,
                          width: 100,
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
                                                itemCount: images?.length ?? 0,
                                                itemBuilder: (context, index) {
                                                  // Display images from the URL in a grid
                                                  return GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  FullScreenImageFromUrl(
                                                                    text: name,
                                                                    imageUrl:
                                                                        "http:${RemoteDataSource.baseUrlWithoutPort}8000/${images[index].split("Image_Database/")[1]}",
                                                                  )));
                                                    },
                                                    child: Image.network(
                                                      "http:${RemoteDataSource.baseUrlWithoutPort}8000/${images![index].split("Image_Database/")[1]}",
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
                                    Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        // Convert the list of image URLs into Image widgets
                                        if (images != null)
                                          CarouselSlider(
                                            carouselController:
                                                _carouselController,
                                            items: images.map((imageUrl) {
                                              return Image.network(
                                                "http:${RemoteDataSource.baseUrlWithoutPort}8000/${imageUrl.split("Image_Database/")[1]}",
                                                fit: BoxFit.cover,
                                              );
                                            }).toList(),
                                            options: CarouselOptions(
                                              aspectRatio: 16 / 9,
                                              viewportFraction: 0.8,
                                              enableInfiniteScroll: false,
                                              reverse: false,
                                              autoPlay: true,
                                              enlargeCenterPage: true,
                                              scrollDirection: Axis.horizontal,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  Tooltip(
                    message: "View Full History For This Request",
                    child: IconButton(
                        onPressed: onPressed,
                        icon: const Icon(
                          Icons.folder_shared_rounded,
                          color: Color.fromARGB(255, 60, 180, 134),
                          size: 35,
                        )),
                  ),
                ],
              ),

              // FxBox.h10,
              // getCardBadgesRow(badgesList: models ?? []),
              FxBox.h10,
              Center(
                child: SizedBox(
                  height: 250,
                  width: 400,
                  child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: VideoPlayerWidget(
                          // urlFromHistory:
                          // videoUrl: state.,
                          videoUrl: urlFromHistory
                          // "http:${RemoteDataSource.baseUrlWithoutPort}8000/${urlFromHistory.split("Image_Database/")[1]}"
                          )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
