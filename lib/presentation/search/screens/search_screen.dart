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
import '../../../core/models/search_by_image_model.dart';
import '../../../core/remote_provider/remote_data_source.dart';
import '../../../core/widgets/fullscreenImage.dart';
import '../../all_employees/screens/text.dart';
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
          backgroundColor: AppColors.backGround,
          shadowColor: AppColors.white,
          titlePadding: EdgeInsets.zero,
          title: YaruDialogTitleBar(
            foregroundColor: AppColors.grey3,
            backgroundColor: AppColors.grey,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            isClosable: false,
            title: SizedBox(
              // width: 500,
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
              height: 700,
              child: TabBarView(
                // clipBehavior: Clip.antiAliasWithSaveLayer,
                controller: tabController,
                children: [
                  BlocListener<SearchByImageBloc, SearchByImageState>(
                    listener: (context, state) {
                      if (state.submission == Submission.success) {
                        FxToast.showSuccessToast(context: context);
                      }

                      // if (state.submission == Submission.noDataFound) {
                      //   FxToast.showWarningToast(
                      //       context: context,
                      //       warningMessage: "NO data found about this person");
                      // }
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
                                                // FilePickerResult? result =
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
                                                    AppColors.buttonBlue,
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

                                    ///employee Data
                                    FxBox.h24,

                                    Padding(
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
                                                      "NOT in the Database!",
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
                                                                  .employeeNamesList
                                                                  .length <
                                                              20
                                                          ? state
                                                              .employeeNamesList
                                                              .length
                                                          : 20,
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
                                                        final employee = state
                                                                .employeeNamesList[
                                                            index];
                                                        return _contactUi(
                                                          id: employee.sId ??
                                                              '',
                                                          name: employee.name ??
                                                              '',
                                                          profession:
                                                              'Software Developer',
                                                          imagesrc: employee
                                                                  .imagePath ??
                                                              '',
                                                          phoneNum:
                                                              employee.phone ??
                                                                  '',
                                                          email:
                                                              employee.email ??
                                                                  '',
                                                          userId:
                                                              employee.userId ??
                                                                  '',
                                                          onUpdate: () {
                                                            _showUpdateDialog(
                                                                context,
                                                                employee);
                                                          },
                                                        );
                                                      },
                                                    ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    ///////////////////////////////////////////////
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
                                                    // FilePickerResult? result =
                                                    await FilePicker.platform
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
                                              ),
                                            ),
                                          ),

                                    ///employee Data
                                    FxBox.h24,

                                    Padding(
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
                                                                  .employeeNamesList
                                                                  .length <
                                                              20
                                                          ? state
                                                              .employeeNamesList
                                                              .length
                                                          : 20,
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
                                                        final employee = state
                                                                .employeeNamesList[
                                                            index];
                                                        return _contactUi(
                                                          id: employee.sId ??
                                                              '',
                                                          name: employee.name ??
                                                              '',
                                                          profession:
                                                              'Software Developer',
                                                          imagesrc: employee
                                                                  .imagePath ??
                                                              '',
                                                          phoneNum:
                                                              employee.phone ??
                                                                  '',
                                                          email:
                                                              employee.email ??
                                                                  '',
                                                          userId:
                                                              employee.userId ??
                                                                  '',
                                                          onUpdate: () {
                                                            _showUpdateDialog(
                                                                context,
                                                                employee);
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
                        );
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
                        return Expanded(
                          // aspectRatio: state.controller.value.aspectRatio,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(children: [
                                Container(
                                  width: 720,
                                  height: 480,
                                  child: AspectRatio(
                                    aspectRatio:
                                        state.controller.value.aspectRatio,
                                    child: CameraPreview(
                                      state.controller,
                                      child: Stack(
                                        // fit: StackFit.expand,
                                        alignment: Alignment.bottomCenter,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 20),
                                                child: ElevatedButton(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all<
                                                                      Color>(
                                                                  AppColors
                                                                      .babyBlue),
                                                      shape: MaterialStateProperty
                                                          .all<
                                                              RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(50),
                                                        ),
                                                      )),
                                                  onPressed: () {
                                                    context
                                                        .read<PhotoAppCubit>()
                                                        .startStream();
                                                  },
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
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
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
                                                  },
                                                  icon: const Icon(
                                                      Icons.cameraswitch))
                                            ],
                                          ),
                                          Positioned(
                                            top: 0,
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
                                                "Data : ${state.result}",
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                // Transform.scale(
                                //   scale: state.controller.value.aspectRatio,
                                //   child:
                                CustomPaint(
                                  painter: RectanglePainter(
                                    (state.boxes ?? [])
                                        .map((box) => (box))
                                        .toList(),
                                  ),
                                ),
                                // ),
                              ]),
                            ],
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

                  // ////////////////////////////////////////////////////////////////////////////
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

  Widget _contactUi({
    required String name,
    required String profession,
    required String phoneNum,
    required String email,
    required String userId,
    required String imagesrc,
    required String id,
    required Function onUpdate,
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
              BlocProvider(
                create: (context) => SearchByImageBloc(),
                child: BlocBuilder<SearchByImageBloc, SearchByImageState>(
                  builder: (context, state) {
                    return PopupMenuButton<String>(
                      icon: const Icon(Icons.more_horiz, color: Colors.black),
                      onSelected: (String choice) {
                        if (choice == 'Edit') {
                          onUpdate();
                          // Handle edit action
                        } else if (choice == 'Delete') {
                          // Handle delete action

                          showDialog(
                            context: context,
                            builder: (ctx) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                icon: const Icon(
                                  Icons.warning,
                                  color: Colors.amber,
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
                                        style: const TextStyle(
                                            color: AppColors.thinkRedColor),
                                      ),
                                      onPressed: () {
                                        context.read<SearchByImageBloc>().add(
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
                                        style: const TextStyle(
                                            color: AppColors.blueBlack),
                                      ),
                                      onPressed: () => Navigator.of(ctx).pop()),
                                ],
                              );
                            },
                          );
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'Edit',
                          child: Text('Edit'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'Delete',
                          child: Text('Delete'),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          FxBox.h24,
          ConstText.lightText(
            text: name,
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
          FxBox.h8,
          ConstText.lightText(
            text: userId,
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
          FxBox.h24,
          _iconWithText(
              icon: const Icon(
                Icons.badge_outlined,
                color: Colors.white,
              ),
              text: profession),
          FxBox.h28,
          _iconWithText(
              icon: const Icon(
                Icons.contact_phone,
                color: Colors.white,
              ),
              text: phoneNum),
          FxBox.h28,
          _iconWithText(
              icon: const Icon(
                Icons.email,
                color: Colors.white,
              ),
              text: email),
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
          text: text,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }

  void _showUpdateDialog(BuildContext context, Dataa employee) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Update Employee"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: employee.name,
                  decoration: const InputDecoration(labelText: 'Name'),
                  onChanged: (value) async {
                    if (value.isEmpty) {
                      SearchByImageBloc.get(context).add(
                        AdduserId(
                          userId: employee.name!,
                        ),
                      );
                    } else {
                      SearchByImageBloc.get(context).add(
                        AddpersonName(personName: value),
                      );
                    }
                  },
                ),
                FxBox.h24,
                TextFormField(
                  initialValue: employee.userId,
                  decoration: const InputDecoration(labelText: 'UserId'),
                  onChanged: (value) async {
                    if (value.isEmpty) {
                      SearchByImageBloc.get(context).add(
                        AdduserId(
                          userId: employee.userId!,
                        ),
                      );
                    } else {
                      SearchByImageBloc.get(context).add(
                        AdduserId(
                          userId: value,
                        ),
                      );
                    }
                  },
                ),
                FxBox.h24,
                TextFormField(
                  initialValue: employee.phone,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  onChanged: (value) async {
                    if (value.isEmpty) {
                      SearchByImageBloc.get(context).add(
                        AdduserId(
                          userId: employee.phone!,
                        ),
                      );
                    } else {
                      SearchByImageBloc.get(context).add(
                        AddphoneNum(
                          phoneNum: value,
                        ),
                      );
                    }
                  },
                ),
                FxBox.h24,
                TextFormField(
                  initialValue: employee.email,
                  decoration: const InputDecoration(labelText: 'Email'),
                  onChanged: (value) async {
                    if (value.isEmpty) {
                      SearchByImageBloc.get(context).add(
                        AdduserId(
                          userId: employee.email!,
                        ),
                      );
                    } else {
                      SearchByImageBloc.get(context).add(
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
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                SearchByImageBloc.get(context).add(
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
