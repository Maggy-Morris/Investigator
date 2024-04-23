import 'dart:convert';

import 'package:Investigator/core/models/search_by_video_in_group_search.dart';
import 'package:camera/camera.dart';
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
            create: (context) => GroupSearchBloc(),
          ),
          BlocProvider(
            create: (context) => PhotoAppCubit(),
          ),
        ],
        child: BlocListener<GroupSearchBloc, GroupSearchState>(
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
                        Text(
                          "Find Targets".tr(),
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white),
                        ),
                        FxBox.h24,
                        const Tooltip(
                          message:
                              "Choose The Accuracy You Want To Search For A Person With Using The SliderBar \n        Note That If the Video Resolution Is Bad Try to Choose Low Accuracy ",
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
                                        GroupSearchBloc.get(context).add(
                                            GetAccuracy(
                                                accuracy: (newValue / 100)
                                                    .toString()));
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
                              FxBox.h16,
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
                                        ? "All"
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
                                                await _pickVideo().then(
                                                  (PlatformFile? videoFile) {
                                                    if (videoFile != null) {
                                                      GroupSearchBloc.get(
                                                              context)
                                                          .add(videoevent(
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
                                            GroupSearchBloc.get(context).add(
                                                const reloadTargetsData(
                                                    Employyyy: []));
                                            GroupSearchBloc.get(context).add(
                                                const reloadSnapShots(
                                                    snapyy: []));
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
                                        const Text(
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
                                                itemCount: state
                                                    .employeeNamesList.length,
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
                                                  final employee = state
                                                      .employeeNamesList[index];
                                                  return _contactUi(
                                                    onDelete: () {
                                                      _showDeleteDialog(context,
                                                          employee.name ?? '');
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
                                                            color: Colors.red,
                                                            size: 50,
                                                          )
                                                        : null,
                                                    id: employee.sId ?? '',
                                                    name: employee.name ?? '',
                                                    profession:
                                                        'Software Developer',
                                                    imagesrc:
                                                        employee.imagePath ??
                                                            '',
                                                    phoneNum:
                                                        employee.phone ?? '',
                                                    email: employee.email ?? '',
                                                    userId:
                                                        employee.userId ?? '',
                                                    onUpdate: () {
                                                      _showUpdateDialog(
                                                          context, employee);
                                                    },
                                                  );
                                                },
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              FxBox.h16,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  (state.snapShots.isNotEmpty)
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
                                  // SizedBox(
                                  //   height: 300,
                                  //   width: 300,
                                  //   child: Card(
                                  //     elevation: 4,
                                  //     shape: RoundedRectangleBorder(
                                  //       borderRadius: BorderRadius.circular(12),
                                  //     ),
                                  //     child: ClipRRect(
                                  //       borderRadius: BorderRadius.circular(12),
                                  //       child: Stack(
                                  //         children: [
                                  //           GestureDetector(
                                  //             onTap: () async {
                                  //               // FilePickerResult? result =
                                  //               await FilePicker.platform
                                  //                   .pickFiles(
                                  //                 type: FileType.image,
                                  //               )
                                  //                   .then((result) {
                                  //                 if (result != null &&
                                  //                     result.files.isNotEmpty) {
                                  //                   // Use the selected image file
                                  //                   final imageFile =
                                  //                       result.files.first;
                                  //                   // Load the image file as an image
                                  //                   final image = imageFile
                                  //                               .bytes !=
                                  //                           null
                                  //                       ? Image.memory(
                                  //                           imageFile.bytes!,
                                  //                           fit: BoxFit.cover,
                                  //                         )
                                  //                       : loadingIndicator();
                                  //                   // Replace the image with the selected image

                                  //                   GroupSearchBloc.get(context).add(
                                  //                       ImageToSearchForEmployee(
                                  //                           imageWidget:
                                  //                               image));

                                  //                   GroupSearchBloc.get(context).add(
                                  //                       imageevent(
                                  //                           imageFile:
                                  //                               imageFile));
                                  //                 }
                                  //                 return null;
                                  //               });
                                  //             },
                                  //             child: Stack(
                                  //                 fit: StackFit.expand,
                                  //                 children: [
                                  //                   state.imageWidget ??
                                  //                       Image.asset(
                                  //                         'assets/images/imagepick.png',
                                  //                         width:
                                  //                             double.infinity,
                                  //                         height:
                                  //                             double.infinity,
                                  //                         fit: BoxFit.cover,
                                  //                       ),
                                  //                 ]),
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),

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
                                                    GroupSearchBloc.get(context)
                                                        .add(videoevent(
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
                                            GroupSearchBloc.get(context).add(
                                                const reloadTargetsData(
                                                    Employyyy: []));
                                            GroupSearchBloc.get(context).add(
                                                const reloadSnapShots(
                                                    snapyy: []));
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

                              FxBox.h16,

                              ///frames Data
                              Text("Frames Where Targets Appeard in :"),
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
                                "http:${RemoteDataSource.baseUrlWithoutPortForImages}8000/$imagesrc"),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6.0),
                    child: Image.network(
                      "http:${RemoteDataSource.baseUrlWithoutPortForImages}8000/$imagesrc",
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
                icon: const Icon(Icons.more_horiz, color: Colors.black),
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

  void _showUpdateDialog(BuildContext context, Dataaa employee) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const SizedBox(width: 500, child: Text("Update Employee")),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                    "http:${RemoteDataSource.baseUrlWithoutPortForImages}8000/${employee.imagePath}",
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
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
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
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