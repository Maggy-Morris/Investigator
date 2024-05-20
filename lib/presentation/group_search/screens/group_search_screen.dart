import 'dart:convert';

import 'package:Investigator/core/widgets/FullImageURL.dart';
import 'package:Investigator/core/widgets/flutter_pagination/flutter_pagination.dart';
import 'package:Investigator/core/widgets/slider_widget.dart';
import 'package:camera/camera.dart';
import 'package:chewie/chewie.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Investigator/core/enum/enum.dart';
import 'package:Investigator/core/loader/loading_indicator.dart';
import 'package:Investigator/core/resources/app_colors.dart';
import 'package:Investigator/core/utils/responsive.dart';
import 'package:Investigator/core/widgets/sizedbox.dart';
import 'package:Investigator/core/widgets/toast/toast.dart';
import 'package:Investigator/presentation/standard_layout/screens/standard_layout.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:video_player/video_player.dart';
import 'dart:html' as html;

import '../../../authentication/authentication_repository.dart';
import '../../../core/remote_provider/remote_data_source.dart';
import '../../../core/widgets/drop_down_widgets.dart';
import '../../../core/widgets/fullscreenImage.dart';
import '../../../core/widgets/image_downloader.dart';
import '../../../core/widgets/persons_per_widget.dart';
import '../../all_employees/screens/text.dart';
import '../../camera_controller/cubit/photo_app_cubit.dart';
import '../bloc/group_search_bloc.dart';

class GroupSearchScreen extends StatefulWidget {
  const GroupSearchScreen({Key? key}) : super(key: key);

  @override
  State<GroupSearchScreen> createState() => _GroupSearchScreenState();
}

class _GroupSearchScreenState extends State<GroupSearchScreen> {
  TextEditingController nameController = TextEditingController();
  CameraController? controller;
  XFile? imageFile;
  final double _min = 10;
  final double _max = 100;
  double _value = 10;
  // bool _isBackCamera = true;
  String companyNameRepo =
      AuthenticationRepository.instance.currentUser.companyName?.first ?? "";
  List<String> checkboxItems =
      AuthenticationRepository.instance.currentUser.roomsNames ?? [];
  ScrollController _scrollController = ScrollController();

  //////////////////////////////////////////////////////
  VideoPlayerController? _controller;

  @override
  void dispose() {
    // _controller?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return StandardLayoutScreen(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => GroupSearchBloc(),
          ),
          BlocProvider(
            create: (context) => PhotoAppCubit(),
          ),
        ],
        child: BlocListener<GroupSearchBloc, GroupSearchState>(
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
            if (state.submission == Submission.noDataFound) {
              FxToast.showWarningToast(
                  context: context,
                  warningMessage: "NO data found about this person");
            }
          },
          child: BlocBuilder<GroupSearchBloc, GroupSearchState>(
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
                              "Find Targets".tr(),
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
                              Column(
                                children: [
                                  Center(
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 50.0, left: 50.0, bottom: 5),
                                        child: SliderWidget(
                                          showLabelFormatter: true,
                                          onChanged: (newValue) {
                                            GroupSearchBloc.get(context).add(
                                                GetAccuracy(
                                                    accuracy: (newValue / 100)
                                                        .toString()));
                                          },
                                        )),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: SizedBox(
                                  width: 295,
                                  child: singleSelectGenericDropdown<String>(
                                    // titleName: "Filter By:",
                                    isEnabled: true,
                                    isRequired: false,
                                    filled: true,
                                    // showSearch: true,
                                    selectedItem: state.filterCase.isEmpty
                                        ? "Filter By :"
                                        : state.filterCase,
                                    onChanged: (value) {
                                      if (value?.isNotEmpty ?? false) {
                                        GroupSearchBloc.get(context).add(
                                            selectedFiltering(
                                                filterCase: value ?? ""));
                                        // if (value == "All") {
                                        //   GroupSearchBloc.get(context)
                                        //       .add(const GetEmployeeNamesEvent());
                                        // } else if (value == "Normal") {
                                        //   GroupSearchBloc.get(context).add(
                                        //       const GetEmployeeNormalNamesEvent());
                                        // } else if (value == "BlackListed") {
                                        //   GroupSearchBloc.get(context).add(
                                        //       const GetEmployeeBlackListedNamesEvent());
                                        // }
                                      }
                                    },
                                    itemsList: [
                                      "All",
                                      "Neutral",
                                      "BlackListed"
                                    ],
                                  ),
                                ),
                              ),
                              // Here to search for an Employee in the database
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    height: 300,
                                    width: 700,
                                    child: Card(
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          // if (_controller
                                          //         ?.value.isInitialized ==
                                          //     true)
                                          //   Center(
                                          //     child:
                                          //         loadingIndicator(), // Display circular progress indicator while loading
                                          //   )
                                          // else
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
                                                            GroupSearchBloc.get(
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
                                          // AspectRatio(
                                          //   aspectRatio: _controller!
                                          //       .value.aspectRatio,
                                          //   child:
                                          //       VideoPlayer(_controller!),
                                          // )
                                          else
                                            GestureDetector(
                                              onTap: () {
                                                _pickVideo().then(
                                                    (PlatformFile? videoFile) {
                                                  if (videoFile != null) {
                                                    GroupSearchBloc.get(context)
                                                        .add(videoevent(
                                                            video: videoFile));
                                                  }
                                                });
                                              },
                                              child: Tooltip(
                                                message: "Upload a video",
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

                              FxBox.h16,
                              state.submission == Submission.loading
                                  ? loadingIndicator()
                                  : Center(
                                      child: ElevatedButton.icon(
                                          onPressed: () {
                                            if (state.filterCase.isEmpty) {
                                              FxToast.showErrorToast(
                                                context: context,
                                                message:
                                                    "Pick How You Want To Filter Your Targets {All,Neutral,BlackListed}",
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
                                            //   GroupSearchBloc.get(context).add(
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
                                            GroupSearchBloc.get(context).add(
                                                const EditPageCount(
                                                    pageCount: 0));

                                            GroupSearchBloc.get(context).add(
                                                const reloadTargetsData(
                                                    Employyyy: []));
                                            GroupSearchBloc.get(context).add(
                                                const reloadPath(
                                                    path_provided: ""));
                                            GroupSearchBloc.get(context).add(
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

                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  (state.pathProvided.isNotEmpty)
                                      ? const Text(
                                          "Frames Where Targets Appeard in :",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25),
                                        )
                                      : const Text(
                                          "",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25),
                                        ),
                                ],
                              ),

                              ///   paginated Frames
                              BlocProvider.value(
                                value: GroupSearchBloc.get(context),
                                child: BlocBuilder<GroupSearchBloc,
                                    GroupSearchState>(
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
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: 300,
                                                    child: (state.submission ==
                                                            Submission
                                                                .noDataFound)
                                                        ? const Center(
                                                            child: Text(
                                                            "",
                                                            style: TextStyle(
                                                                color: AppColors
                                                                    .blueB,
                                                                fontSize: 25,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ))
                                                        : Row(
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
                                                                      onPressed:
                                                                          () {
                                                                        _scrollController
                                                                            .animateTo(
                                                                          _scrollController.offset -
                                                                              400, // Adjust as needed
                                                                          duration:
                                                                              const Duration(milliseconds: 500),
                                                                          curve:
                                                                              Curves.easeInOut,
                                                                        );
                                                                      },
                                                                    )
                                                                  : const SizedBox(),
                                                              Expanded(
                                                                child: ListView
                                                                    .builder(
                                                                  controller:
                                                                      _scrollController,
                                                                  shrinkWrap:
                                                                      true,
                                                                  scrollDirection:
                                                                      Axis.horizontal,
                                                                  physics:
                                                                      const AlwaysScrollableScrollPhysics(),
                                                                  itemCount: state
                                                                              .pageCount !=
                                                                          0
                                                                      ? (state.pageCount <
                                                                              10)
                                                                          ? (state.pageCount %
                                                                              10)
                                                                          : (state.pageIndex == (state.pageCount / 10).ceil())
                                                                              ? (state.pageCount % 10 == 0)
                                                                                  ? 10
                                                                                  : (state.pageCount % 10)
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
                                                                    final names = state
                                                                        .data[(state.pageIndex == 1 || state.pageIndex == 0
                                                                                ? 0
                                                                                : state.pageIndex - 1) *
                                                                            10 +
                                                                        (index)];

                                                                    final data_time = state
                                                                        .timestamps[(state.pageIndex == 1 || state.pageIndex == 0
                                                                                ? 0
                                                                                : state.pageIndex - 1) *
                                                                            10 +
                                                                        (index)];
                                                                    return Padding(
                                                                      padding: const EdgeInsets
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
                                                                            int totalSeconds = hours * 3600 +
                                                                                minutes * 60 +
                                                                                seconds;
                                                                            GroupSearchBloc.get(context).add(SetTimeDuration(timeDuration: totalSeconds));

                                                                            ///////////////////////////////////////////////////////////////
                                                                            debugPrint(totalSeconds.toString());
                                                                          },
                                                                          onDownloadPressed: () {
                                                                            downloadImageFromWeb(
                                                                              imageUrl: "${state.pathProvided}/${state.pageIndex == 1 || state.pageIndex == 0 ? "" : state.pageIndex - 1}${index + 1 == 10 ? 9 : index + 1}.png",

                                                                              // downloadName:
                                                                              //     data_time,
                                                                            );
                                                                            // _downloadImage(
                                                                            //     data:
                                                                            //         image,
                                                                            //     downloadName:
                                                                            //         data_time);
                                                                          },
                                                                          timeText: data_time,
                                                                          imageSource: "${state.pathProvided}/${state.pageIndex == 1 || state.pageIndex == 0 ? "" : state.pageIndex - 1}${index + 1 == 10 ? 9 : index + 1}.png",
                                                                          text: names),
                                                                    );
                                                                  },
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
                                                                      onPressed:
                                                                          () {
                                                                        // Handle scrolling to the right
                                                                        _scrollController
                                                                            .animateTo(
                                                                          _scrollController.offset +
                                                                              400, // Adjust as needed
                                                                          duration:
                                                                              const Duration(milliseconds: 500),
                                                                          curve:
                                                                              Curves.easeInOut,
                                                                        );
                                                                      },
                                                                    )
                                                                  : const SizedBox(),
                                                            ],
                                                          ),
                                                  ),

                                                  // Display the pagination controls
                                                  FlutterPagination(
                                                    // persons: state
                                                    //     .employeeNamesList, // Pass the list of data
                                                    listCount: (state
                                                                .pageCount /
                                                            10)
                                                        .ceil(), // Pass the page count
                                                    onSelectCallback:
                                                        (int index) async {
                                                      GroupSearchBloc.get(
                                                              context)
                                                          .add(EditPageNumber(
                                                              pageIndex:
                                                                  index));
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                  },
                                ),
                              ),

                              FxBox.h16,
                              Divider(
                                thickness: 7,
                                color: AppColors.grey.withOpacity(0.3),
                              ),

                              (state.submission == Submission.noDataFound)
                                  ? const Text(
                                      "No Data Found",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 30),
                                    )
                                  : const Text(
                                      "",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 25),
                                    ),
                              (state.employeeNamesList.isNotEmpty)
                                  ? const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Targets Data :",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25),
                                        ),
                                      ],
                                    )
                                  : const Text(
                                      "",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 25),
                                    ),

                              ///employee Data
                              FxBox.h24,

                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child:
                                            (state.submission ==
                                                    Submission.noDataFound)
                                                ? const Center(
                                                    child: Text(
                                                    "",
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
                                                    itemCount: state
                                                        .employeeNamesList
                                                        .length,
                                                    gridDelegate: Responsive
                                                            .isMobile(context)
                                                        ? const SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 1,
                                                            crossAxisSpacing:
                                                                45,
                                                            mainAxisSpacing: 45,
                                                            mainAxisExtent: 350,
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
                                                      final employee = state
                                                              .employeeNamesList[
                                                          index];
                                                      return _contactUi(
                                                        onDelete: () {
                                                          _showDeleteDialog(
                                                              context,
                                                              employee.name ??
                                                                  '');
                                                        },
                                                        message: employee
                                                                    .blackListed ==
                                                                'True'
                                                            ? "Blacklisted person"
                                                            : '',
                                                        // Conditional display based on whether the employee is blacklisted
                                                        Icoon: employee
                                                                    .blackListed ==
                                                                'True'
                                                            ? const Icon(
                                                                Icons
                                                                    .warning_amber_outlined,
                                                                color:
                                                                    Colors.red,
                                                                size: 50,
                                                              )
                                                            : null,
                                                        id: employee.sId ?? '',
                                                        name:
                                                            employee.name ?? '',
                                                        profession:
                                                            'Software Developer',
                                                        imagesrc: employee
                                                                .imagePath ??
                                                            '',
                                                        phoneNum:
                                                            employee.phone ??
                                                                '',
                                                        email: employee.email ??
                                                            '',
                                                        userId:
                                                            employee.userId ??
                                                                '',
                                                        onUpdate: () {
                                                          GroupSearchBloc.get(
                                                                  context)
                                                              .add(RadioButtonChanged(
                                                                  selectedOption:
                                                                      employee
                                                                          .blackListed
                                                                          .toString(),
                                                                  showTextField:
                                                                      employee.blackListed ==
                                                                              "True"
                                                                          ? false
                                                                          : true));

                                                          showDialog(
                                                            context: context,
                                                            builder: (ctx) {
                                                              return BlocProvider
                                                                  .value(
                                                                value: GroupSearchBloc
                                                                    .get(
                                                                        context),
                                                                child: BlocBuilder<
                                                                    GroupSearchBloc,
                                                                    GroupSearchState>(
                                                                  builder:
                                                                      (context,
                                                                          state) {
                                                                    return AlertDialog(
                                                                      title: const SizedBox(
                                                                          width:
                                                                              500,
                                                                          child:
                                                                              Text("Update Employee")),
                                                                      content:
                                                                          SingleChildScrollView(
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            TextFormField(
                                                                              cursorColor: Colors.white,
                                                                              style: const TextStyle(color: Colors.white),
                                                                              initialValue: employee.name,
                                                                              decoration: const InputDecoration(labelText: 'Name'),
                                                                              onChanged: (value) async {
                                                                                if (value.isEmpty) {
                                                                                  GroupSearchBloc.get(context).add(
                                                                                    AdduserId(
                                                                                      userId: employee.name!,
                                                                                    ),
                                                                                  );
                                                                                } else {
                                                                                  GroupSearchBloc.get(context).add(
                                                                                    AddpersonName(personName: value),
                                                                                  );
                                                                                }
                                                                              },
                                                                            ),
                                                                            FxBox.h24,
                                                                            TextFormField(
                                                                              keyboardType: TextInputType.phone,
                                                                              inputFormatters: [
                                                                                FilteringTextInputFormatter.digitsOnly,
                                                                              ],
                                                                              cursorColor: Colors.white,
                                                                              style: const TextStyle(color: Colors.white),
                                                                              initialValue: employee.userId,
                                                                              decoration: const InputDecoration(labelText: 'UserId'),
                                                                              onChanged: (value) async {
                                                                                if (value.isEmpty) {
                                                                                  GroupSearchBloc.get(context).add(
                                                                                    AdduserId(
                                                                                      userId: employee.userId!,
                                                                                    ),
                                                                                  );
                                                                                } else {
                                                                                  GroupSearchBloc.get(context).add(
                                                                                    AdduserId(
                                                                                      userId: value,
                                                                                    ),
                                                                                  );
                                                                                }
                                                                              },
                                                                            ),
                                                                            FxBox.h24,
                                                                            TextFormField(
                                                                              keyboardType: TextInputType.phone,
                                                                              inputFormatters: [
                                                                                FilteringTextInputFormatter.digitsOnly,
                                                                              ],
                                                                              cursorColor: Colors.white,
                                                                              style: const TextStyle(color: Colors.white),
                                                                              initialValue: employee.phone,
                                                                              decoration: const InputDecoration(labelText: 'Phone Number'),
                                                                              onChanged: (value) async {
                                                                                if (value.isEmpty) {
                                                                                  GroupSearchBloc.get(context).add(
                                                                                    AdduserId(
                                                                                      userId: employee.phone!,
                                                                                    ),
                                                                                  );
                                                                                } else {
                                                                                  GroupSearchBloc.get(context).add(
                                                                                    AddphoneNum(
                                                                                      phoneNum: value,
                                                                                    ),
                                                                                  );
                                                                                }
                                                                              },
                                                                            ),
                                                                            FxBox.h24,
                                                                            TextFormField(
                                                                              cursorColor: Colors.white,
                                                                              style: const TextStyle(color: Colors.white),
                                                                              initialValue: employee.email,
                                                                              decoration: const InputDecoration(labelText: 'Email'),
                                                                              onChanged: (value) async {
                                                                                if (value.isEmpty) {
                                                                                  GroupSearchBloc.get(context).add(
                                                                                    AdduserId(
                                                                                      userId: employee.email!,
                                                                                    ),
                                                                                  );
                                                                                } else {
                                                                                  GroupSearchBloc.get(context).add(
                                                                                    Addemail(
                                                                                      email: value,
                                                                                    ),
                                                                                  );
                                                                                }
                                                                              },
                                                                            ),
                                                                            FxBox.h24,
                                                                            FxBox.h24,
                                                                            SizedBox(
                                                                              height: 100,
                                                                              child: Image.network(
                                                                                "http:${RemoteDataSource.baseUrlWithoutPort}8000/${employee.imagePath}",
                                                                                fit: BoxFit.cover,
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(16.0),
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  const Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Row(
                                                                                        children: [
                                                                                          Text(
                                                                                            'BlackListed:',
                                                                                            style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.white, fontSize: 20.0),
                                                                                          ),
                                                                                          SizedBox(
                                                                                            width: 15,
                                                                                          ),
                                                                                          Icon(
                                                                                            Icons.warning_amber_outlined,
                                                                                            color: Colors.red,
                                                                                            size: 35,
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      Tooltip(
                                                                                        message: "If the person is BlackListed he has no access to any room if not choose the rooms he is authorized to enter",
                                                                                        child: Icon(
                                                                                          Icons.info_outline,
                                                                                          color: Colors.white,
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  RadioListTile(
                                                                                    activeColor: Colors.white,
                                                                                    // selected: employee.blackListed == "True",
                                                                                    title: const Text('Yes', style: TextStyle(color: Colors.white)),
                                                                                    value: 'True',
                                                                                    groupValue: state.selectedOption,
                                                                                    onChanged: (value) {
                                                                                      GroupSearchBloc.get(context).add(RadioButtonChanged(selectedOption: value.toString(), showTextField: false));
                                                                                    },
                                                                                  ),
                                                                                  RadioListTile(
                                                                                    activeColor: Colors.white,
                                                                                    title: const Text('No', style: TextStyle(color: Colors.white)),
                                                                                    value: 'False',
                                                                                    // selected: employee.blackListed != "True",
                                                                                    groupValue: state.selectedOption,
                                                                                    onChanged: (value) {
                                                                                      GroupSearchBloc.get(context).add(RadioButtonChanged(selectedOption: value.toString(), showTextField: true));
                                                                                    },
                                                                                  ),
                                                                                  FxBox.h24,
                                                                                  if (state.showTextField)
                                                                                    multiSelectGenericDropdown(
                                                                                      showSearch: true,
                                                                                      isEnabled: true,
                                                                                      isRequired: false,
                                                                                      filled: true,
                                                                                      selectedItem: employee.roomsAccesseble,
                                                                                      titleName: "Room Access Management",
                                                                                      onChanged: (value) {
                                                                                        GroupSearchBloc.get(context).add(checkBox(room_NMs: value!));
                                                                                      },
                                                                                      itemsList: checkboxItems,
                                                                                    ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      actions: [
                                                                        TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).pop(); // Close the dialog
                                                                          },
                                                                          child:
                                                                              const Text(
                                                                            'Cancel',
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.red,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        ElevatedButton(
                                                                          onPressed:
                                                                              () {
                                                                            GroupSearchBloc.get(context).add(
                                                                              UpdateEmployeeEvent(
                                                                                companyName: companyNameRepo,
                                                                                id: employee.sId ?? '',

                                                                                // userId: state.userId,
                                                                                // companyName: state.companyName,
                                                                              ),
                                                                            );
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child:
                                                                              const Text('Update'),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  },
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        if (!Responsive.isWeb(context))
                          Column(
                            children: [
                              Column(
                                children: [
                                  Center(
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 50.0, left: 50.0, bottom: 5),
                                        child: SliderWidget(
                                          onChanged: (newValue) {
                                            GroupSearchBloc.get(context).add(
                                                GetAccuracy(
                                                    accuracy: (newValue / 100)
                                                        .toString()));
                                          },
                                        )
                                        ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: SizedBox(
                                      width: 295,
                                      child:
                                          singleSelectGenericDropdown<String>(
                                        // titleName: "Filter By:",
                                        isEnabled: true,
                                        isRequired: false,
                                        filled: true,
                                        // showSearch: true,
                                        selectedItem: state.filterCase.isEmpty
                                            ? "Filter By :"
                                            : state.filterCase,
                                        onChanged: (value) {
                                          // if (value?.isNotEmpty ?? false) {
                                          GroupSearchBloc.get(context).add(
                                              selectedFiltering(
                                                  filterCase: value ?? "All"));
                                          // if (value == "All") {
                                          //   GroupSearchBloc.get(context)
                                          //       .add(const GetEmployeeNamesEvent());
                                          // } else if (value == "Normal") {
                                          //   GroupSearchBloc.get(context).add(
                                          //       const GetEmployeeNormalNamesEvent());
                                          // } else if (value == "BlackListed") {
                                          //   GroupSearchBloc.get(context).add(
                                          //       const GetEmployeeBlackListedNamesEvent());
                                          // }
                                          // }
                                        },
                                        itemsList: [
                                          "All",
                                          "Neutral",
                                          "BlackListed"
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // Here to search for an Employee in the database
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    height: 230,
                                    width: 230,
                                    child: Card(
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          // if (_controller
                                          //         ?.value.isInitialized ==
                                          //     false)
                                          //   Center(
                                          //     child:
                                          //         loadingIndicator(), // Display circular progress indicator while loading
                                          //   )
                                          // else
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
                                                            GroupSearchBloc.get(
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
                                          // AspectRatio(
                                          //   aspectRatio: _controller!
                                          //       .value.aspectRatio,
                                          //   child:
                                          //       VideoPlayer(_controller!),
                                          // )
                                          else
                                            GestureDetector(
                                              onTap: () {
                                                _pickVideo().then(
                                                    (PlatformFile? videoFile) {
                                                  if (videoFile != null) {
                                                    GroupSearchBloc.get(context)
                                                        .add(videoevent(
                                                            video: videoFile));
                                                  }
                                                });
                                              },
                                              child: Tooltip(
                                                message: "Upload a video",
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

                              FxBox.h16,
                              state.submission == Submission.loading
                                  ? loadingIndicator()
                                  : Center(
                                      child: ElevatedButton.icon(
                                          onPressed: () {
                                            GroupSearchBloc.get(context).add(
                                                const EditPageCount(
                                                    pageCount: 0));

                                            GroupSearchBloc.get(context).add(
                                                const reloadTargetsData(
                                                    Employyyy: []));
                                            GroupSearchBloc.get(context).add(
                                                const reloadPath(
                                                    path_provided: ""));
                                            GroupSearchBloc.get(context).add(
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

                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  (state.pathProvided.isNotEmpty)
                                      ? const Text(
                                          "Frames Where Targets Appeard in :",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25),
                                        )
                                      : const Text(
                                          "",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25),
                                        ),
                                ],
                              ),

                              ///frames Data

                              BlocProvider.value(
                                value: GroupSearchBloc.get(context),
                                child: BlocBuilder<GroupSearchBloc,
                                    GroupSearchState>(
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
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: 300,
                                                    child: (state.submission ==
                                                            Submission
                                                                .noDataFound)
                                                        ? const Center(
                                                            child: Text(
                                                            "",
                                                            style: TextStyle(
                                                                color: AppColors
                                                                    .blueB,
                                                                fontSize: 25,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ))
                                                        : Row(
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
                                                                      onPressed:
                                                                          () {
                                                                        _scrollController
                                                                            .animateTo(
                                                                          _scrollController.offset -
                                                                              400, // Adjust as needed
                                                                          duration:
                                                                              const Duration(milliseconds: 500),
                                                                          curve:
                                                                              Curves.easeInOut,
                                                                        );
                                                                      },
                                                                    )
                                                                  : const SizedBox(),
                                                              Expanded(
                                                                child: ListView
                                                                    .builder(
                                                                  controller:
                                                                      _scrollController,
                                                                  shrinkWrap:
                                                                      true,
                                                                  scrollDirection:
                                                                      Axis.horizontal,
                                                                  physics:
                                                                      const AlwaysScrollableScrollPhysics(),
                                                                  itemCount: state
                                                                              .pageCount !=
                                                                          0
                                                                      ? (state.pageCount <
                                                                              10)
                                                                          ? (state.pageCount %
                                                                              10)
                                                                          : (state.pageIndex == (state.pageCount / 10).ceil())
                                                                              ? (state.pageCount % 10 == 0)
                                                                                  ? 10
                                                                                  : (state.pageCount % 10)
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

                                                                    final names = state
                                                                        .data[(state.pageIndex == 1 || state.pageIndex == 0
                                                                                ? 0
                                                                                : state.pageIndex - 1) *
                                                                            10 +
                                                                        (index)];

                                                                    final data_time = state
                                                                        .timestamps[(state.pageIndex == 1 || state.pageIndex == 0
                                                                                ? 0
                                                                                : state.pageIndex - 1) *
                                                                            10 +
                                                                        (index)];
                                                                    return Padding(
                                                                      padding: const EdgeInsets
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
                                                                            int totalSeconds = hours * 3600 +
                                                                                minutes * 60 +
                                                                                seconds;
                                                                            GroupSearchBloc.get(context).add(SetTimeDuration(timeDuration: totalSeconds));

                                                                            ///////////////////////////////////////////////////////////////
                                                                            debugPrint(totalSeconds.toString());
                                                                          },
                                                                          onDownloadPressed: () {
                                                                            downloadImageFromWeb(
                                                                              imageUrl: "${state.pathProvided}/${state.pageIndex == 1 || state.pageIndex == 0 ? "" : state.pageIndex - 1}${index + 1 == 10 ? 9 : index + 1}.png",
                                                                            );
                                                                          },
                                                                          timeText: data_time,
                                                                          // image64:
                                                                          //     image,
                                                                          imageSource: "${state.pathProvided}/${state.pageIndex == 1 || state.pageIndex == 0 ? "" : state.pageIndex - 1}${index + 1 == 10 ? 9 : index + 1}.png",
                                                                          text: names),
                                                                    );
                                                                  },
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
                                                                      onPressed:
                                                                          () {
                                                                        // Handle scrolling to the right
                                                                        _scrollController
                                                                            .animateTo(
                                                                          _scrollController.offset +
                                                                              400, // Adjust as needed
                                                                          duration:
                                                                              const Duration(milliseconds: 500),
                                                                          curve:
                                                                              Curves.easeInOut,
                                                                        );
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
                                                        GroupSearchBloc.get(
                                                                context)
                                                            .add(EditPageNumber(
                                                                pageIndex:
                                                                    index));
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

                              FxBox.h16,

                              (state.submission == Submission.noDataFound)
                                  ? const Text(
                                      "No Data Found",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 30),
                                    )
                                  : const Text(
                                      "",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 25),
                                    ),
                              (state.employeeNamesList.isNotEmpty)
                                  ? const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Targets Data :",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25),
                                        ),
                                      ],
                                    )
                                  : const Text(
                                      "",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 25),
                                    ),

                              ///employee Data
                              FxBox.h24,

                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child:
                                            (state.submission ==
                                                    Submission.noDataFound)
                                                ? const Center(
                                                    child: Text(
                                                    "",
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
                                                    itemCount: state
                                                        .employeeNamesList
                                                        .length,
                                                    gridDelegate: Responsive
                                                            .isMobile(context)
                                                        ? const SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 1,
                                                            crossAxisSpacing:
                                                                45,
                                                            mainAxisSpacing: 45,
                                                            mainAxisExtent: 350,
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
                                                      final employee = state
                                                              .employeeNamesList[
                                                          index];
                                                      return _contactUi(
                                                        onDelete: () {
                                                          _showDeleteDialog(
                                                              context,
                                                              employee.name ??
                                                                  '');
                                                        },
                                                        message: employee
                                                                    .blackListed ==
                                                                'True'
                                                            ? "Blacklisted person"
                                                            : '',
                                                        // Conditional display based on whether the employee is blacklisted
                                                        Icoon: employee
                                                                    .blackListed ==
                                                                'True'
                                                            ? const Icon(
                                                                Icons
                                                                    .warning_amber_outlined,
                                                                color:
                                                                    Colors.red,
                                                                size: 50,
                                                              )
                                                            : null,
                                                        id: employee.sId ?? '',
                                                        name:
                                                            employee.name ?? '',
                                                        profession:
                                                            'Software Developer',
                                                        imagesrc: employee
                                                                .imagePath ??
                                                            '',
                                                        phoneNum:
                                                            employee.phone ??
                                                                '',
                                                        email: employee.email ??
                                                            '',
                                                        userId:
                                                            employee.userId ??
                                                                '',
                                                        onUpdate: () {
                                                          GroupSearchBloc.get(
                                                                  context)
                                                              .add(RadioButtonChanged(
                                                                  selectedOption:
                                                                      employee
                                                                          .blackListed
                                                                          .toString(),
                                                                  showTextField:
                                                                      employee.blackListed ==
                                                                              "True"
                                                                          ? false
                                                                          : true));

                                                          showDialog(
                                                            context: context,
                                                            builder: (ctx) {
                                                              return BlocProvider
                                                                  .value(
                                                                value: GroupSearchBloc
                                                                    .get(
                                                                        context),
                                                                child: BlocBuilder<
                                                                    GroupSearchBloc,
                                                                    GroupSearchState>(
                                                                  builder:
                                                                      (context,
                                                                          state) {
                                                                    return AlertDialog(
                                                                      title: const SizedBox(
                                                                          width:
                                                                              500,
                                                                          child:
                                                                              Text("Update Employee")),
                                                                      content:
                                                                          SingleChildScrollView(
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            TextFormField(
                                                                              cursorColor: Colors.white,
                                                                              style: const TextStyle(color: Colors.white),
                                                                              initialValue: employee.name,
                                                                              decoration: const InputDecoration(labelText: 'Name'),
                                                                              onChanged: (value) async {
                                                                                if (value.isEmpty) {
                                                                                  GroupSearchBloc.get(context).add(
                                                                                    AdduserId(
                                                                                      userId: employee.name!,
                                                                                    ),
                                                                                  );
                                                                                } else {
                                                                                  GroupSearchBloc.get(context).add(
                                                                                    AddpersonName(personName: value),
                                                                                  );
                                                                                }
                                                                              },
                                                                            ),
                                                                            FxBox.h24,
                                                                            TextFormField(
                                                                              keyboardType: TextInputType.phone,
                                                                              inputFormatters: [
                                                                                FilteringTextInputFormatter.digitsOnly,
                                                                              ],
                                                                              cursorColor: Colors.white,
                                                                              style: const TextStyle(color: Colors.white),
                                                                              initialValue: employee.userId,
                                                                              decoration: const InputDecoration(labelText: 'UserId'),
                                                                              onChanged: (value) async {
                                                                                if (value.isEmpty) {
                                                                                  GroupSearchBloc.get(context).add(
                                                                                    AdduserId(
                                                                                      userId: employee.userId!,
                                                                                    ),
                                                                                  );
                                                                                } else {
                                                                                  GroupSearchBloc.get(context).add(
                                                                                    AdduserId(
                                                                                      userId: value,
                                                                                    ),
                                                                                  );
                                                                                }
                                                                              },
                                                                            ),
                                                                            FxBox.h24,
                                                                            TextFormField(
                                                                              keyboardType: TextInputType.phone,
                                                                              inputFormatters: [
                                                                                FilteringTextInputFormatter.digitsOnly,
                                                                              ],
                                                                              cursorColor: Colors.white,
                                                                              style: const TextStyle(color: Colors.white),
                                                                              initialValue: employee.phone,
                                                                              decoration: const InputDecoration(labelText: 'Phone Number'),
                                                                              onChanged: (value) async {
                                                                                if (value.isEmpty) {
                                                                                  GroupSearchBloc.get(context).add(
                                                                                    AdduserId(
                                                                                      userId: employee.phone!,
                                                                                    ),
                                                                                  );
                                                                                } else {
                                                                                  GroupSearchBloc.get(context).add(
                                                                                    AddphoneNum(
                                                                                      phoneNum: value,
                                                                                    ),
                                                                                  );
                                                                                }
                                                                              },
                                                                            ),
                                                                            FxBox.h24,
                                                                            TextFormField(
                                                                              cursorColor: Colors.white,
                                                                              style: const TextStyle(color: Colors.white),
                                                                              initialValue: employee.email,
                                                                              decoration: const InputDecoration(labelText: 'Email'),
                                                                              onChanged: (value) async {
                                                                                if (value.isEmpty) {
                                                                                  GroupSearchBloc.get(context).add(
                                                                                    AdduserId(
                                                                                      userId: employee.email!,
                                                                                    ),
                                                                                  );
                                                                                } else {
                                                                                  GroupSearchBloc.get(context).add(
                                                                                    Addemail(
                                                                                      email: value,
                                                                                    ),
                                                                                  );
                                                                                }
                                                                              },
                                                                            ),
                                                                            FxBox.h24,
                                                                            FxBox.h24,
                                                                            SizedBox(
                                                                              height: 100,
                                                                              child: Image.network(
                                                                                "http:${RemoteDataSource.baseUrlWithoutPort}8000/${employee.imagePath}",
                                                                                fit: BoxFit.cover,
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(16.0),
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  const Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Row(
                                                                                        children: [
                                                                                          Text(
                                                                                            'BlackListed:',
                                                                                            style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.white, fontSize: 20.0),
                                                                                          ),
                                                                                          SizedBox(
                                                                                            width: 15,
                                                                                          ),
                                                                                          Icon(
                                                                                            Icons.warning_amber_outlined,
                                                                                            color: Colors.red,
                                                                                            size: 35,
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      Tooltip(
                                                                                        message: "If the person is BlackListed he has no access to any room if not choose the rooms he is authorized to enter",
                                                                                        child: Icon(
                                                                                          Icons.info_outline,
                                                                                          color: Colors.white,
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  RadioListTile(
                                                                                    activeColor: Colors.white,
                                                                                    // selected: employee.blackListed == "True",
                                                                                    title: const Text('Yes', style: TextStyle(color: Colors.white)),
                                                                                    value: 'True',
                                                                                    groupValue: state.selectedOption,
                                                                                    onChanged: (value) {
                                                                                      GroupSearchBloc.get(context).add(RadioButtonChanged(selectedOption: value.toString(), showTextField: false));
                                                                                    },
                                                                                  ),
                                                                                  RadioListTile(
                                                                                    activeColor: Colors.white,
                                                                                    title: const Text('No', style: TextStyle(color: Colors.white)),
                                                                                    value: 'False',
                                                                                    // selected: employee.blackListed != "True",
                                                                                    groupValue: state.selectedOption,
                                                                                    onChanged: (value) {
                                                                                      GroupSearchBloc.get(context).add(RadioButtonChanged(selectedOption: value.toString(), showTextField: true));
                                                                                    },
                                                                                  ),
                                                                                  FxBox.h24,
                                                                                  if (state.showTextField)
                                                                                    multiSelectGenericDropdown(
                                                                                      showSearch: true,
                                                                                      isEnabled: true,
                                                                                      isRequired: false,
                                                                                      filled: true,
                                                                                      selectedItem: employee.roomsAccesseble,
                                                                                      titleName: "Room Access Management",
                                                                                      onChanged: (value) {
                                                                                        GroupSearchBloc.get(context).add(checkBox(room_NMs: value!));
                                                                                      },
                                                                                      itemsList: checkboxItems,
                                                                                    ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      actions: [
                                                                        TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).pop(); // Close the dialog
                                                                          },
                                                                          child:
                                                                              const Text(
                                                                            'Cancel',
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.red,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        ElevatedButton(
                                                                          onPressed:
                                                                              () {
                                                                            GroupSearchBloc.get(context).add(
                                                                              UpdateEmployeeEvent(
                                                                                companyName: companyNameRepo,
                                                                                id: employee.sId ?? '',

                                                                                // userId: state.userId,
                                                                                // companyName: state.companyName,
                                                                              ),
                                                                            );
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child:
                                                                              const Text('Update'),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  },
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                      );
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
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result != null) {
      final videoFile = result.files.first;
      final Uint8List videoBytes = videoFile.bytes!;
      final blob = html.Blob([videoBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final uri = Uri.parse(url);
      _controller = VideoPlayerController.networkUrl(uri)
        ..initialize().then((_) {
          _controller?.pause();
        });

      return videoFile; // Return the picked video file
    } else {
      return null; // Return null if no file is picked
    }
  }

  Widget imagesListWidget({
    //  String? image64,
    required String imageSource,
    required String text,
    required String timeText,
    required VoidCallback onDownloadPressed,
    required Function() onTap,
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
              bottom: 0,
              right: 0,
              child: Tooltip(
                message: "Open Image",
                child: IconButton(
                  onPressed: () {
                    debugPrint(imageSource);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FullScreenImage(
                                text: text,
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
              left: 0,
              child: GestureDetector(
                onTap: onTap,
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

  Uint8List _decodeBase64Image({required String base64Image}) {
    final bytes = base64.decode(base64Image);

    return Uint8List.fromList(bytes);
  }

  Widget _contactUi({
    required String name,
    required String profession,
    required String phoneNum,
    required String email,
    required String userId,
    required String imagesrc,
    required String id,
    String? message,
    Icon? Icoon,
    required Function onUpdate,
    required Function onDelete,
  }) {
    return Container(
      width: 300,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
      decoration: BoxDecoration(
          color: AppColors.grey.withOpacity(0.3),

          // const Color.fromARGB(255, 143, 188, 211),
          borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullScreenImage(
                            text: name,
                            imageUrl:
                                "http:${RemoteDataSource.baseUrlWithoutPort}8000/$imagesrc"),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6.0),
                    child: Image.network(
                      "http:${RemoteDataSource.baseUrlWithoutPort}8000/$imagesrc",
                      // Images.profileImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Tooltip(message: message, child: Icoon),
              // BlocProvider(
              //   create: (context) => GroupSearchBloc(),
              //   child: BlocBuilder<GroupSearchBloc, AllEmployeesState>(
              //     builder: (context, state) {
              //       return
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_horiz, color: Colors.white),
                onSelected: (String choice) {
                  if (choice == 'Edit') {
                    onUpdate();
                    // Handle edit action
                  } else if (choice == 'Delete') {
                    // Handle delete action

                    onDelete();
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'Edit',
                    child: Text('Edit'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Delete',
                    child: Text('Delete'),
                  ),
                ],
              ),
              //     },
              //   ),
              // ),
            ],
          ),
          FxBox.h24,
          ConstText.lightText(
            message: "Name",
            color: Colors.white,
            text: name,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
          FxBox.h8,
          ConstText.lightText(
            message: "UserID",
            text: userId,
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
          FxBox.h24,
          Tooltip(
            message: "Job Title",
            child: _iconWithText(
                icon: const Icon(
                  Icons.badge_outlined,
                  color: Colors.white,
                ),
                text: profession),
          ),
          FxBox.h28,
          Tooltip(
            message: "Phone Contact",
            child: _iconWithText(
                icon: const Icon(
                  Icons.contact_phone,
                  color: Colors.white,
                ),
                text: phoneNum),
          ),
          FxBox.h28,
          Tooltip(
            message: "Email Address",
            child: _iconWithText(
                icon: const Icon(
                  Icons.email,
                  color: Colors.white,
                ),
                text: email),
          ),
          // FxBox.h24,
        ],
      ),
    );
  }

  Widget _iconWithText({
    required Icon icon,
    required String text,
  }) {
    return Row(
      children: [
        icon,
        FxBox.w16,
        ConstText.lightText(
          color: Colors.white,
          text: text,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context, String name) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          icon: const Icon(
            Icons.warning,
            color: Colors.red,
          ),
          title: Text(
            "Are you sure you want to remove this person from the organization?"
                .tr(),
            style: const TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
                child: Text(
                  "yes".tr(),
                  style: const TextStyle(color: AppColors.thinkRedColor),
                ),
                onPressed: () {
                  context.read<GroupSearchBloc>().add(
                        DeletePersonByNameEvent(
                          companyNameRepo,
                          name,
                        ),
                      );

                  Navigator.of(ctx).pop();
                }),
            TextButton(
                child: Text(
                  "no".tr(),
                  style: const TextStyle(color: AppColors.green),
                ),
                onPressed: () => Navigator.of(ctx).pop()),
          ],
        );
      },
    );
  }
}
