import 'dart:convert';
import 'dart:io';

import 'package:Investigator/core/widgets/slider_widget.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
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
import '../../../core/widgets/drop_down_widgets.dart';
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
      AuthenticationRepository.instance.currentUser.companyName?.first ?? "";
  late TabController tabController;
  // bool _isBackCamera = true;
  final double _min = 10;
  final double _max = 100;
  double _value = 10;
  bool? isChecked;
  List<String> checkboxItems =
      AuthenticationRepository.instance.currentUser.roomsNames ?? [];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
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
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
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
              height: 500,
              child: TabBarView(
                // clipBehavior: Clip.antiAliasWithSaveLayer,
                controller: tabController,
                children: [
                  BlocBuilder<PhotoAppCubit, PhotoAppState>(
                    builder: (context, state) {
                      context.read<PhotoAppCubit>().stopCamera();
                      context.read<PhotoAppCubit>().isChosenChanged(false);
                      return BlocListener<SearchByImageBloc,
                          SearchByImageState>(
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
                                warningMessage:
                                    "NO data found about this person");
                          }
                        },
                        child:
                            BlocBuilder<SearchByImageBloc, SearchByImageState>(
                          builder: (context, state) {
                            return SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  if (Responsive.isWeb(context))
                                    Column(
                                      children: [
                                        // Here to search for an Employee in the database
                                        // BlocBuilder<SearchByImageBloc,
                                        //     SearchByImageState>(
                                        //   builder: (context, state) {
                                        // return
                                        Card(
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

                                                        setState(() {
                                                          _image = image;
                                                        });
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
                                                  child:
                                                      //  state.imageWidget
                                                      _image ??
                                                          SizedBox(
                                                            width: 350,
                                                            height: 350,
                                                            child: Image.asset(
                                                              'assets/images/person-search.png',
                                                              // width: double.infinity,
                                                              // height: 200,
                                                              // fit: BoxFit.cover,
                                                            ),
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
                                                CustomPaint(
                                                  painter: RectanglePainter(
                                                    (state.blacklis ?? [])
                                                        .map((blacklis) =>
                                                            blacklis)
                                                        .toList(),
                                                    (state.result ?? [])
                                                        .map((result) => result)
                                                        .toList(),
                                                    (state.boxes ?? [])
                                                        .map((box) => (box))
                                                        .toList(),
                                                    (state.textAccuracy ?? [])
                                                        .map(
                                                            (textForAccuracy) =>
                                                                textForAccuracy)
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
                                                    if (state.imageWidget ==
                                                        null) {
                                                      FxToast.showErrorToast(
                                                        context: context,
                                                        message:
                                                            "Pick your picture",
                                                      );
                                                      return;
                                                    }

                                                    SearchByImageBloc.get(
                                                            context)
                                                        .add(
                                                      const reloadEmployeeData(
                                                          resultData: [],
                                                          blacklisData: [],
                                                          boxesData: [],
                                                          textAccuracyData: [],
                                                          employeeData: []),
                                                    );
                                                    SearchByImageBloc.get(
                                                            context)
                                                        .add(
                                                      const SearchForEmployeeEvent(),
                                                    );
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
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
                                        (state.submission ==
                                                Submission.noDataFound)
                                            ? const Center(
                                                child: Text(
                                                "NOT in the Database!",
                                                style: TextStyle(
                                                    color: AppColors.blueB,
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ))
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10.0, right: 10.0),
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        child: GridView.builder(
                                                          shrinkWrap: true,
                                                          physics:
                                                              const NeverScrollableScrollPhysics(),
                                                          itemCount: state
                                                              .employeeNamesList
                                                              .length,
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
                                                              : Responsive
                                                                      .isTablet(
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
                                                                              MediaQuery.of(context).size.width * 0.24,
                                                                          crossAxisSpacing:
                                                                              45,
                                                                          mainAxisSpacing:
                                                                              45,
                                                                          mainAxisExtent:
                                                                              350,
                                                                        )
                                                                      : SliverGridDelegateWithMaxCrossAxisExtent(
                                                                          maxCrossAxisExtent:
                                                                              MediaQuery.of(context).size.width * 0.24,
                                                                          crossAxisSpacing:
                                                                              45,
                                                                          mainAxisSpacing:
                                                                              45,
                                                                          mainAxisExtent:
                                                                              350,
                                                                        ),
                                                          itemBuilder:
                                                              (context, index) {
                                                            final employee =
                                                                state.employeeNamesList[
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
                                                                      color: Colors
                                                                          .red,
                                                                      size: 50,
                                                                    )
                                                                  : null,
                                                              id: employee
                                                                      .sId ??
                                                                  '',
                                                              name: employee
                                                                      .name ??
                                                                  '',
                                                              profession:
                                                                  'Software Developer',
                                                              imagesrc: employee
                                                                      .imagePath ??
                                                                  '',
                                                              phoneNum: employee
                                                                      .phone ??
                                                                  '',
                                                              email: employee
                                                                      .email ??
                                                                  '',
                                                              userId: employee
                                                                      .userId ??
                                                                  '',
                                                              onUpdate: () {
                                                                SearchByImageBloc.get(context).add(RadioButtonChanged(
                                                                    selectedOption:
                                                                        employee
                                                                            .blackListed
                                                                            .toString(),
                                                                    showTextField: employee.blackListed ==
                                                                            "True"
                                                                        ? false
                                                                        : true));

                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (ctx) {
                                                                    return BlocProvider
                                                                        .value(
                                                                      value: SearchByImageBloc
                                                                          .get(
                                                                              context),
                                                                      child: BlocBuilder<
                                                                          SearchByImageBloc,
                                                                          SearchByImageState>(
                                                                        builder:
                                                                            (context,
                                                                                state) {
                                                                          return AlertDialog(
                                                                            title:
                                                                                const SizedBox(width: 500, child: Text("Update Employee")),
                                                                            content:
                                                                                SingleChildScrollView(
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
                                                                                    keyboardType: TextInputType.emailAddress,
                                                                                    cursorColor: Colors.white,
                                                                                    style: const TextStyle(color: Colors.white),
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
                                                                                            SearchByImageBloc.get(context).add(RadioButtonChanged(selectedOption: value.toString(), showTextField: false));
                                                                                          },
                                                                                        ),
                                                                                        RadioListTile(
                                                                                          activeColor: Colors.white,
                                                                                          title: const Text('No', style: TextStyle(color: Colors.white)),
                                                                                          value: 'False',
                                                                                          // selected: employee.blackListed != "True",
                                                                                          groupValue: state.selectedOption,
                                                                                          onChanged: (value) {
                                                                                            SearchByImageBloc.get(context).add(RadioButtonChanged(selectedOption: value.toString(), showTextField: true));
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
                                                                                              SearchByImageBloc.get(context).add(checkBox(room_NMs: value!));
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
                                                                                onPressed: () {
                                                                                  Navigator.of(context).pop(); // Close the dialog
                                                                                },
                                                                                child: const Text(
                                                                                  'Cancel',
                                                                                  style: TextStyle(color: Colors.red),
                                                                                ),
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

                                        ///////////////////////////////////////////////
                                      ],
                                    ),
                                  if (!Responsive.isWeb(context))
                                    Column(
                                      children: [
                                        // Here to search for an Employee in the database

                                        BlocProvider.value(
                                          value: SearchByImageBloc.get(context),
                                          child: BlocBuilder<SearchByImageBloc,
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
                                                          await FilePicker
                                                              .platform
                                                              .pickFiles(
                                                            type:
                                                                FileType.image,
                                                          )
                                                              .then((result) {
                                                            if (result !=
                                                                    null &&
                                                                result.files
                                                                    .isNotEmpty) {
                                                              final imageFile =
                                                                  result.files
                                                                      .first;
                                                              final image = imageFile
                                                                          .bytes !=
                                                                      null
                                                                  ? Image
                                                                      .memory(
                                                                      imageFile
                                                                          .bytes!,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    )
                                                                  : loadingIndicator();

                                                              SearchByImageBloc
                                                                      .get(
                                                                          context)
                                                                  .add(
                                                                ImageToSearchForEmployee(
                                                                    imageWidget:
                                                                        image),
                                                              );
                                                              setState(() {
                                                                _image = image;
                                                              });

                                                              String
                                                                  base64Image =
                                                                  base64Encode(
                                                                      imageFile
                                                                          .bytes!);

                                                              SearchByImageBloc
                                                                      .get(
                                                                          context)
                                                                  .add(
                                                                SearchForEmployee(
                                                                  companyName:
                                                                      companyNameRepo,
                                                                  image:
                                                                      base64Image,
                                                                ),
                                                              );
                                                            }
                                                            return null;
                                                          });
                                                        },
                                                        child: _image
                                                            // state
                                                            //         .imageWidget

                                                            ??
                                                            Image.asset(
                                                              'assets/images/person-search.png',
                                                              // width: double.infinity,
                                                              // height: 200,
                                                              // fit: BoxFit.cover,
                                                            ),
                                                      ),
                                                      Positioned(
                                                        bottom: 0,
                                                        left: 0,
                                                        right: 0,
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            vertical: 8,
                                                            horizontal: 16,
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .only(
                                                              bottomLeft: Radius
                                                                  .circular(12),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          12),
                                                            ),
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.6),
                                                          ),
                                                          child: Text(
                                                            // Use state data to show appropriate text
                                                            state.submission ==
                                                                    Submission
                                                                        .loading
                                                                ? 'Searching...'
                                                                : state.submission ==
                                                                        Submission
                                                                            .success
                                                                    ? '${state.result}'
                                                                    : state.submission ==
                                                                            Submission.noDataFound
                                                                        ? 'Not in the Database'
                                                                        : '',
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      CustomPaint(
                                                        painter:
                                                            RectanglePainter(
                                                          (state.blacklis ?? [])
                                                              .map((blacklis) =>
                                                                  blacklis)
                                                              .toList(),
                                                          (state.result ?? [])
                                                              .map((result) =>
                                                                  result)
                                                              .toList(),
                                                          (state.boxes ?? [])
                                                              .map((box) =>
                                                                  (box))
                                                              .toList(),
                                                          (state.textAccuracy ??
                                                                  [])
                                                              .map((textForAccuracy) =>
                                                                  textForAccuracy)
                                                              .toList(),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        //Confirm Button to send the image
                                        FxBox.h24,
                                        (state.submission == Submission.loading)
                                            ? loadingIndicator()
                                            : Center(
                                                child: ElevatedButton.icon(
                                                  onPressed: () {
                                                    if (state.imageWidget ==
                                                        null) {
                                                      FxToast.showErrorToast(
                                                          context: context,
                                                          message:
                                                              "pick your picture ");
                                                      return;
                                                    }
                                                    SearchByImageBloc.get(
                                                            context)
                                                        .add(
                                                      const reloadEmployeeData(
                                                          resultData: [],
                                                          blacklisData: [],
                                                          boxesData: [],
                                                          textAccuracyData: [],
                                                          employeeData: []),
                                                    );
                                                    SearchByImageBloc.get(
                                                            context)
                                                        .add(
                                                      const SearchForEmployeeEvent(),
                                                    );
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
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
                                        (state.submission ==
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
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        child: GridView.builder(
                                                          shrinkWrap: true,
                                                          physics:
                                                              const NeverScrollableScrollPhysics(),
                                                          itemCount: state
                                                              .employeeNamesList
                                                              .length,
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
                                                              : Responsive
                                                                      .isTablet(
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
                                                                              MediaQuery.of(context).size.width * 0.24,
                                                                          crossAxisSpacing:
                                                                              45,
                                                                          mainAxisSpacing:
                                                                              45,
                                                                          mainAxisExtent:
                                                                              350,
                                                                        )
                                                                      : SliverGridDelegateWithMaxCrossAxisExtent(
                                                                          maxCrossAxisExtent:
                                                                              MediaQuery.of(context).size.width * 0.24,
                                                                          crossAxisSpacing:
                                                                              45,
                                                                          mainAxisSpacing:
                                                                              45,
                                                                          mainAxisExtent:
                                                                              350,
                                                                        ),
                                                          itemBuilder:
                                                              (context, index) {
                                                            final employee =
                                                                state.employeeNamesList[
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
                                                                      color: Colors
                                                                          .red,
                                                                      size: 50,
                                                                    )
                                                                  : null,
                                                              id: employee
                                                                      .sId ??
                                                                  '',
                                                              name: employee
                                                                      .name ??
                                                                  '',
                                                              profession:
                                                                  'Software Developer',
                                                              imagesrc: employee
                                                                      .imagePath ??
                                                                  '',
                                                              phoneNum: employee
                                                                      .phone ??
                                                                  '',
                                                              email: employee
                                                                      .email ??
                                                                  '',
                                                              userId: employee
                                                                      .userId ??
                                                                  '',
                                                              onUpdate: () {
                                                                SearchByImageBloc.get(context).add(RadioButtonChanged(
                                                                    selectedOption:
                                                                        employee
                                                                            .blackListed
                                                                            .toString(),
                                                                    showTextField: employee.blackListed ==
                                                                            "True"
                                                                        ? false
                                                                        : true));

                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (ctx) {
                                                                    return BlocProvider
                                                                        .value(
                                                                      value: SearchByImageBloc
                                                                          .get(
                                                                              context),
                                                                      child: BlocBuilder<
                                                                          SearchByImageBloc,
                                                                          SearchByImageState>(
                                                                        builder:
                                                                            (context,
                                                                                state) {
                                                                          return AlertDialog(
                                                                            title:
                                                                                const SizedBox(width: 500, child: Text("Update Employee")),
                                                                            content:
                                                                                SingleChildScrollView(
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
                                                                                    cursorColor: Colors.white,
                                                                                    style: const TextStyle(color: Colors.white),
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
                                                                                    keyboardType: TextInputType.emailAddress,
                                                                                    cursorColor: Colors.white,
                                                                                    style: const TextStyle(color: Colors.white),
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
                                                                                            SearchByImageBloc.get(context).add(RadioButtonChanged(selectedOption: value.toString(), showTextField: false));
                                                                                          },
                                                                                        ),
                                                                                        RadioListTile(
                                                                                          activeColor: Colors.white,
                                                                                          title: const Text('No', style: TextStyle(color: Colors.white)),
                                                                                          value: 'False',
                                                                                          // selected: employee.blackListed != "True",
                                                                                          groupValue: state.selectedOption,
                                                                                          onChanged: (value) {
                                                                                            SearchByImageBloc.get(context).add(RadioButtonChanged(selectedOption: value.toString(), showTextField: true));
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
                                                                                              SearchByImageBloc.get(context).add(checkBox(room_NMs: value!));
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
                                                                                onPressed: () {
                                                                                  Navigator.of(context).pop(); // Close the dialog
                                                                                },
                                                                                child: const Text(
                                                                                  'Cancel',
                                                                                  style: TextStyle(color: Colors.red),
                                                                                ),
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
                            );
                          },
                        ),
                      );
                    },
                  ),

                  /////////////////////////////////////////////////////////////////////////////////////////////
                  ///Live Stream Video

                  BlocListener<PhotoAppCubit, PhotoAppState>(
                    listener: (context, state) {
                      // Handle any state changes if needed
                    },
                    child: BlocBuilder<PhotoAppCubit, PhotoAppState>(
                      builder: (context, state) {
                        if (state.isChosen == false) {
                          return Column(
                            children: [
                              if (Responsive.isWeb(context))
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: SizedBox(
                                            width: 250,
                                            child: singleSelectGenericDropdown<
                                                String>(
                                              titleName: "Select A Room",
                                              isEnabled: true,
                                              isRequired: false,
                                              filled: true,
                                              showSearch: true,
                                              selectedItem: state.roomChoosen,
                                              onChanged: (value) {
                                                if (value?.isNotEmpty ??
                                                    false) {
                                                  // context
                                                  //     .read<SearchByImageBloc>()
                                                  //     .add(
                                                  //       RadioButtonChanged(
                                                  //           selectedOption:
                                                  //               value ?? ""),
                                                  //);

                                                  context
                                                      .read<PhotoAppCubit>()
                                                      .roomChoosen(value ?? "");
                                                }
                                              },
                                              itemsList: checkboxItems,
                                            ),
                                          ),
                                        ),

                                        ///////////////////////////////////////

                                        Row(
                                          children: [
                                            Checkbox(
                                              checkColor: Colors.white,
                                              focusColor: Colors.white,
                                              hoverColor: Colors.white,
                                              value:
                                                  state.securityBreachChecked,
                                              onChanged: (bool? value) {
                                                context
                                                    .read<PhotoAppCubit>()
                                                    .toggleSecurityBreach(
                                                        value ?? false);
                                              },
                                            ),
                                            const Text(
                                              'Security Breach',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white
                                                  // You can adjust the style of the text as needed
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Tooltip(
                                      message:
                                          "Choose The Accuracy You Want To Search For A Person With Using The SliderBar \n        Note That If the Video Resolution Is Bad Try to Choose High Accuracy ",
                                      child: Icon(
                                        Icons.info_outline_rounded,
                                        color: AppColors.white,
                                        size: 25,
                                      ),
                                    ),
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 50.0,
                                        ),
                                        child: SliderWidget(
                                          onChanged: (newValue) {
                                            context
                                                .read<PhotoAppCubit>()
                                                .sliderControl(
                                                    sliderVal: (newValue / 100)
                                                        .toString());
                                          },
                                          showLabelFormatter: true,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              if (!Responsive.isWeb(context))
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: SizedBox(
                                        width: 150,
                                        child:
                                            singleSelectGenericDropdown<String>(
                                          titleName: "Select A Room",
                                          isEnabled: true,
                                          isRequired: false,
                                          filled: true,
                                          showSearch: true,
                                          selectedItem: state.roomChoosen,
                                          onChanged: (value) {
                                            if (value?.isNotEmpty ?? false) {
                                              context
                                                  .read<PhotoAppCubit>()
                                                  .roomChoosen(value ?? "");
                                            }
                                          },
                                          itemsList: checkboxItems,
                                        ),
                                      ),
                                    ),

                                    ///////////////////////////////////////

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Checkbox(
                                          checkColor: Colors.white,
                                          focusColor: Colors.white,
                                          hoverColor: Colors.white,
                                          value: state.securityBreachChecked,
                                          onChanged: (bool? value) {
                                            context
                                                .read<PhotoAppCubit>()
                                                .toggleSecurityBreach(
                                                    value ?? false);
                                          },
                                        ),
                                        const Text(
                                          'Security Breach',
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.white
                                              // You can adjust the style of the text as needed
                                              ),
                                        ),
                                      ],
                                    ),
                                    const Tooltip(
                                      message:
                                          "Choose The Accuracy You Want To Search For A Person With Using The SliderBar \n        Note That If the Video Resolution Is Bad Try to Choose High Accuracy ",
                                      child: Icon(
                                        Icons.info_outline_rounded,
                                        color: AppColors.white,
                                        size: 25,
                                      ),
                                    ),
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 50.0, vertical: 20),
                                        child: SliderWidget(
                                          onChanged: (newValue) {
                                            context
                                                .read<PhotoAppCubit>()
                                                .sliderControl(
                                                    sliderVal: (newValue / 100)
                                                        .toString());
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              Center(
                                child: Stack(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        // if (state.sliderValue == null) {
                                        //   FxToast.showErrorToast(
                                        //     context: context,
                                        //     message:
                                        //         "Choose Accuracy on the SliderBar",
                                        //   );
                                        //   return;
                                        // }
                                        if (state.roomChoosen == null) {
                                          FxToast.showErrorToast(
                                            context: context,
                                            message: "Pick your room first",
                                          );
                                          return;
                                        }
                                        context
                                            .read<PhotoAppCubit>()
                                            .isChosenChanged(
                                              true,
                                            );
                                        context
                                            .read<PhotoAppCubit>()
                                            .openCamera(
                                              roomChoosen:
                                                  state.roomChoosen ?? '',
                                              security:
                                                  state.securityBreachChecked,
                                            );
                                      },
                                      icon: const Icon(
                                          Icons.photo_camera_rounded,
                                          size: 300,
                                          color: AppColors.babyBlue),
                                    ),
                                    // ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(children: [
                                SizedBox(
                                  width: 720,
                                  height: 480,
                                  child: AspectRatio(
                                    aspectRatio:
                                        // state.controller?.value.aspectRatio ??
                                        16 / 10.7,
                                    child: (state.controller?.value
                                                .isInitialized ==
                                            false)
                                        ? loadingIndicator()
                                        : CameraPreview(
                                            state.controller!,
                                            child: Stack(
                                              alignment: Alignment.bottomCenter,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8.0,
                                                          vertical: 20),
                                                      child: ElevatedButton(
                                                        style: ButtonStyle(
                                                            backgroundColor: context
                                                                    .watch<
                                                                        PhotoAppCubit>()
                                                                    .isStreaming
                                                                ? MaterialStateProperty.all<
                                                                        Color>(
                                                                    AppColors
                                                                        .thinkRedColor)
                                                                : MaterialStateProperty.all<
                                                                        Color>(
                                                                    AppColors
                                                                        .babyBlue),
                                                            shape: MaterialStateProperty
                                                                .all<
                                                                    RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            50),
                                                              ),
                                                            )),
                                                        onPressed: () {
                                                          context
                                                              .read<
                                                                  PhotoAppCubit>()
                                                              .startStream();
                                                        },
                                                        child: Text(
                                                          context
                                                                  .watch<
                                                                      PhotoAppCubit>()
                                                                  .isStreaming
                                                              ? 'Stop Stream'
                                                              : 'Start Stream',
                                                          style: TextStyle(
                                                              color: context
                                                                      .watch<
                                                                          PhotoAppCubit>()
                                                                      .isStreaming
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ),
                                                    // IconButton(
                                                    //     color: Colors.white,
                                                    //     padding:
                                                    //         const EdgeInsets.only(
                                                    //             bottom: 25),
                                                    //     onPressed: () {
                                                    //       setState(() {
                                                    //         _isBackCamera =
                                                    //             !_isBackCamera;
                                                    //       });
                                                    //     },
                                                    //     icon: const Icon(
                                                    //       Icons.cameraswitch,
                                                    //       size: 25,
                                                    //       color: Colors.white,
                                                    //     ))
                                                  ],
                                                ),
                                                Positioned(
                                                  top: 0,
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
                                                      "Data : ${state.result}",
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                state.blacklisted == true
                                                    ? const Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                            Tooltip(
                                                              message:
                                                                  "BlackListed Person",
                                                              child: Icon(
                                                                Icons.warning,
                                                                color:
                                                                    Colors.red,
                                                                size: 60,
                                                              ),
                                                            ),
                                                          ])
                                                    : const SizedBox(),
                                                state.securityBreach == true
                                                    ? const Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                            Tooltip(
                                                              message:
                                                                  "Security Breach Unauthorized person",
                                                              child: Icon(
                                                                Icons.warning,
                                                                color: Colors
                                                                    .amber,
                                                                size: 50,
                                                              ),
                                                            ),
                                                          ])
                                                    : const SizedBox(),
                                              ],
                                            ),
                                          ),
                                  ),
                                ),
                                CustomPaint(
                                  painter: RectanglePainter(
                                    (state.blacklisted_list_checks ?? [])
                                        .map((blacklisted_list_checks) =>
                                            blacklisted_list_checks)
                                        .toList(),
                                    (state.result ?? [])
                                        .map((result) => result)
                                        .toList(),
                                    (state.boxes ?? [])
                                        .map((box) => (box))
                                        .toList(),
                                    (state.textAccuracy ?? [])
                                        .map((textForAccuracy) =>
                                            textForAccuracy)
                                        .toList(),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  // left: 0,
                                  right: 0,
                                  child: IconButton(
                                    onPressed: () {
                                      context
                                          .read<PhotoAppCubit>()
                                          .stopCamera();

                                      context
                                          .read<PhotoAppCubit>()
                                          .isChosenChanged(
                                            false,
                                          );
                                      // Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                      Icons.close,
                                      size: 50,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ]),
                            ],
                          );
                        }
                      },
                    ),
                  ),
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
      height: 350,
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
    String? message,
    Icon? Icoon,
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
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_horiz, color: Colors.white),
                onSelected: (String choice) {
                  if (choice == 'Edit') {
                    onUpdate();
                    // Handle edit action
                  } else if (choice == 'Delete') {
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
          text: text,
          color: Colors.white,
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
                  style: const TextStyle(color: AppColors.green),
                ),
                onPressed: () => Navigator.of(ctx).pop()),
          ],
        );
      },
    );
  }
}
