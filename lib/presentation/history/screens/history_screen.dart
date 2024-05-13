import 'package:Investigator/core/remote_provider/remote_data_source.dart';
import 'package:Investigator/core/widgets/persons_per_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chewie/chewie.dart';

import 'package:routemaster/routemaster.dart';
import 'package:video_player/video_player.dart';

import '../../../core/resources/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/FullImageURL.dart';
import '../../../core/widgets/sizedbox.dart';
// import '../../standard_layout/bloc/standard_layout_cubit.dart';
import '../../standard_layout/screens/standard_layout.dart';
import '../bloc/history_bloc.dart';

class AllHistoryScreen extends StatelessWidget {
  AllHistoryScreen({Key? key}) : super(key: key);
  final CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    // StandardLayoutCubit.get(context).onEditPageNavigationNumber(9);
    return StandardLayoutScreen(
      body: BlocProvider(
        create: (context) => HistoryBloc()..add(const PathesDataEvent()),
        child: BlocBuilder<HistoryBloc, HistoryState>(
          builder: (context, state) {
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
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "History".tr(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FxBox.h24,
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: CustomPagination(
                        // persons: state
                        //     .employeeNamesList, // Pass the list of data
                        pageCount: state.pageCount, // Pass the page count
                        onPageChanged: (int index) async {
                          ///////////////////////////

                          HistoryBloc.get(context)
                              .add(EditPageNumber(pageIndex: index));

                          //////////////////////////////
                        },
                      ),
                    ),
                    FxBox.h24,
                    (state.allHistory.isNotEmpty)
                        ? Wrap(
                            children: _responsiveCardList(
                              context: context,
                              state: state,
                            ),
                          )
                        : Column(
                            children: [
                              FxBox.h24,
                              const Text(
                                "No History Yet!",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 30),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            );
          },
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
                    Routemaster.of(context).push(
                      "/requestDetails",
                      queryParameters: {
                        "process": state.allHistory[index].videoPath ?? "",
                        // "timeStamp": state.allHistory[index].timestamp ?? "",
                      },
                    );
                  },
                  images: state.allHistory[index].imagePaths,
                  urlFromHistory: state.allHistory[index].videoPath ?? "",
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
                      child: _buildVideoPlayerWidget(
                          // urlFromHistory:
                          "http:${RemoteDataSource.baseUrlWithoutPort}8000/${urlFromHistory.split("Image_Database/")[1]}")),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pickVideoWidget({required String? urlFromHistory}) {
    VideoPlayerController? _controller;

    if (urlFromHistory != null && urlFromHistory.isNotEmpty) {
      _controller = VideoPlayerController.network(urlFromHistory)
        ..initialize().then((_) {
          _controller!.pause();
        });
    }

    if (_controller != null) {
      return Stack(children: [
        AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller)),
        Center(
          child: IconButton(
              icon: _controller.value.isPlaying
                  ? const Icon(Icons.pause)
                  : const Icon(Icons.play_arrow),
              onPressed: () {
                _controller!.value.isPlaying
                    ? _controller.pause()
                    : _controller.play();
              }),
        ),
        VideoProgressIndicator(
          _controller,
          allowScrubbing: true,
          padding: const EdgeInsets.all(10),
        ),
      ]);
    } else {
      return const SizedBox(); // Return an empty SizedBox if no video controller is available
    }
  }

  Widget _buildVideoPlayerWidget(String videoUrl) {
    final videoPlayerController = VideoPlayerController.network(videoUrl);
    final chewieController = ChewieController(
      // aspectRatio: videoPlayerController.value.aspectRatio,
      videoPlayerController: videoPlayerController,
      autoPlay: false,
      // startAt: Duration(seconds: 1),
      autoInitialize: true,
      looping: true,
    );

    return Chewie(
      controller: chewieController,
    );
  }
}
