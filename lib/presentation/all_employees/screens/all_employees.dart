import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:Investigator/core/loader/loading_indicator.dart';
import 'package:Investigator/core/remote_provider/remote_data_source.dart';
import 'package:Investigator/core/resources/app_colors.dart';
import 'package:Investigator/core/widgets/customTextField.dart';
import 'package:Investigator/presentation/all_employees/screens/text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Investigator/core/utils/responsive.dart';
import 'package:Investigator/core/widgets/sizedbox.dart';
import 'package:Investigator/presentation/standard_layout/screens/standard_layout.dart';
import '../../../authentication/authentication_repository.dart';
import '../../../core/enum/enum.dart';
import '../../../core/widgets/drop_down_widgets.dart';
import '../../../core/widgets/fullscreenImage.dart';
import '../../../core/widgets/persons_per_widget.dart';
import '../../../core/widgets/toast/toast.dart';
import '../bloc/all_employess_bloc.dart';

class AllEmployeesScreen extends StatefulWidget {
  const AllEmployeesScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AllEmployeesScreen> createState() => _AllEmployeesScreenState();
}

class _AllEmployeesScreenState extends State<AllEmployeesScreen> {
  String companyNameRepo =
      AuthenticationRepository.instance.currentUser.companyName?.first ?? "";
  List<String> checkboxItems =
      AuthenticationRepository.instance.currentUser.roomsNames ?? [];

  TextEditingController employeeNameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StandardLayoutScreen(
      body: BlocProvider(
        create: (context) =>
            AllEmployeesBloc()..add(const GetEmployeeNamesEvent()),
        child: BlocListener<AllEmployeesBloc, AllEmployeesState>(
          listener: (context, state) {
            if (state.submission == Submission.success) {
              EasyLoading.dismiss();

              FxToast.showSuccessToast(
                  context: context,
                  message: state.responseMessage.isNotEmpty
                      ? state.responseMessage
                      : null);
            }
            if (state.submission == Submission.loading &&
                state.addingEmployee == true) {
              EasyLoading.show(
                  status: "Adding Employee".tr(),
                  maskType: EasyLoadingMaskType.black,
                  dismissOnTap: false);
            }
            if (state.submission == Submission.error) {
              EasyLoading.dismiss();

              FxToast.showErrorToast(
                  context: context,
                  message: state.responseMessage.isNotEmpty
                      ? state.responseMessage
                      : null);
            }
            if (state.submission == Submission.noDataFound) {
              EasyLoading.dismiss();

              FxToast.showWarningToast(
                  context: context,
                  warningMessage: "NO data found about this person");
            }
          },
          child: BlocBuilder<AllEmployeesBloc, AllEmployeesState>(
            builder: (context, state) {
              return Card(
                margin: const EdgeInsets.all(15),
                color: AppColors.backGround,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          "All people ($companyNameRepo)".tr(),
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white),
                        ),
                        FxBox.h24,
                        if (Responsive.isWeb(context))
                          SizedBox(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ///search field
                                Form(
                                  child: SizedBox(
                                    height: 50,
                                    width: 300,
                                    child: TextFormField(
                                      cursorColor: Colors.black,
                                      style:
                                          const TextStyle(color: Colors.black),
                                      controller: _searchController,
                                      decoration: InputDecoration(
                                        hintText: 'Search For Employee'.tr(),
                                        hintStyle: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        fillColor: Colors
                                            .white, // Set the fill color to white
                                        filled: true, //
                                        prefixIcon: state.isSearching
                                            ? IconButton(
                                                icon: const Icon(Icons.search),
                                                onPressed: () {
                                                  AllEmployeesBloc.get(context)
                                                      .add(
                                                    GetPersonByNameEvent(
                                                      companyName:
                                                          companyNameRepo,
                                                      personName:
                                                          _searchController
                                                              .text,
                                                    ),
                                                  );
                                                },
                                              )
                                            : null,

                                        ///search Toggle
                                        suffixIcon: IconButton(
                                          icon: state.isSearching
                                              ? const Icon(Icons.close)
                                              : const Icon(Icons.search),
                                          onPressed: () async {
                                            state.isSearching = !state
                                                .isSearching; // Toggle the search state
                                            if (!state.isSearching) {
                                              _searchController.clear();
                                            }

                                            if (state.isSearching) {
                                              AllEmployeesBloc.get(context).add(
                                                GetPersonByNameEvent(
                                                  companyName: companyNameRepo,
                                                  personName:
                                                      _searchController.text,
                                                ),
                                              );
                                            } else {
                                              if (state.filterCase == "All") {
                                                AllEmployeesBloc.get(context)
                                                    .add(const EditPageNumber(
                                                        pageIndex: 1));
                                              } else if (state.filterCase ==
                                                  "Neutral") {
                                                AllEmployeesBloc.get(context).add(
                                                    const GetEmployeeNormalNamesEvent());
                                              } else if (state.filterCase ==
                                                  "BlackListed") {
                                                AllEmployeesBloc.get(context).add(
                                                    const GetEmployeeBlackListedNamesEvent());
                                              } else {
                                                AllEmployeesBloc.get(context)
                                                    .add(const EditPageNumber(
                                                        pageIndex: 1));
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // Add Employee Button
                                FxBox.h24,
                                MaterialButton(
                                  height: 55,
                                  minWidth: 210,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  color: AppColors.grey2,
                                  //  Color.fromARGB(255, 143, 188, 211),
                                  onPressed: () async {
                                    // Load the image file from the assets directory
                                    rootBundle
                                        .load(
                                            'assets/images/imagepickWhite.png')
                                        .then(
                                      (imageData) {
                                        Uint8List uint8List =
                                            imageData.buffer.asUint8List();

                                        PlatformFile imageFile = PlatformFile(
                                          name: 'imagepickWhite.png',
                                          size: uint8List.lengthInBytes,
                                          bytes: uint8List,
                                        );

                                        // Add the imageFile object to the AllEmployeesBloc
                                        AllEmployeesBloc.get(context).add(
                                            imageevent(imageFile: imageFile));
                                        AllEmployeesBloc.get(context)
                                            .add(const RadioButtonChanged(
                                          selectedOption: "",
                                          showTextField: false,
                                        ));
                                        // Show dialog to fill in employee data
                                        showDialog(
                                            context: context,
                                            builder: (ctx) {
                                              return BlocProvider.value(
                                                value: AllEmployeesBloc.get(
                                                    context),
                                                child: BlocBuilder<
                                                    AllEmployeesBloc,
                                                    AllEmployeesState>(
                                                  builder: (context, state) {
                                                    return AlertDialog(
                                                      title: const SizedBox(
                                                        width: 500,
                                                        child: Text(
                                                          "Add Employee",
                                                          style: TextStyle(
                                                              color: AppColors
                                                                  .white),
                                                        ),
                                                      ),
                                                      content:
                                                          SingleChildScrollView(
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            buildTextFormField(
                                                              labelText: 'Name',
                                                              onChanged:
                                                                  (valuee) async {
                                                                AllEmployeesBloc
                                                                        .get(
                                                                            context)
                                                                    .add(
                                                                  AddpersonName(
                                                                    personName:
                                                                        valuee,
                                                                  ),
                                                                );
                                                              },
                                                            ),

                                                            FxBox.h24,

                                                            buildTextFormField(
                                                              keyboardType:
                                                                  TextInputType
                                                                      .phone,
                                                              inputFormatters: [
                                                                FilteringTextInputFormatter
                                                                    .digitsOnly,
                                                              ],
                                                              labelText:
                                                                  'UserId',
                                                              hintText:
                                                                  'ex: 5643548',
                                                              onChanged:
                                                                  (value) async {
                                                                AllEmployeesBloc
                                                                        .get(
                                                                            context)
                                                                    .add(
                                                                  AdduserId(
                                                                    userId:
                                                                        value,
                                                                  ),
                                                                );
                                                              },
                                                            ),

                                                            FxBox.h24,

                                                            buildTextFormField(
                                                              keyboardType:
                                                                  TextInputType
                                                                      .phone,
                                                              inputFormatters: [
                                                                FilteringTextInputFormatter
                                                                    .digitsOnly,
                                                              ],
                                                              labelText:
                                                                  'Phone Number',
                                                              onChanged:
                                                                  (value) async {
                                                                AllEmployeesBloc
                                                                        .get(
                                                                            context)
                                                                    .add(
                                                                  AddphoneNum(
                                                                    phoneNum:
                                                                        value,
                                                                  ),
                                                                );
                                                              },
                                                            ),

                                                            FxBox.h24,

                                                            buildTextFormField(
                                                              keyboardType:
                                                                  TextInputType
                                                                      .emailAddress,
                                                              // inputFormatters: [
                                                              //   FilteringTextInputFormatter
                                                              //       .allow(RegExp(
                                                              //     r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
                                                              //   )),
                                                              // ],

                                                              //                                                   inputFormatters = [
                                                              // FilteringTextInputFormatter.allow(
                                                              //   RegExp(r'^[\w-\.]+@[a-zA-Z]+\.[a-zA-Z]{2,4}$'),
                                                              // ), ];
                                                              hintText:
                                                                  'ex: name@gmail.com  ',

                                                              labelText:
                                                                  'Email',
                                                              onChanged:
                                                                  (value) async {
                                                                AllEmployeesBloc
                                                                        .get(
                                                                            context)
                                                                    .add(
                                                                  Addemail(
                                                                    email:
                                                                        value,
                                                                  ),
                                                                );
                                                              },
                                                            ),

                                                            FxBox.h24,
                                                            if (state
                                                                    .imageFile !=
                                                                null)
                                                              SizedBox(
                                                                  height: 100,
                                                                  child: state.imageFile!
                                                                              .bytes !=
                                                                          null
                                                                      ? Image
                                                                          .memory(
                                                                          state
                                                                              .imageFile!
                                                                              .bytes!,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        )
                                                                      : loadingIndicator() // Show circular progress indicator while loading
                                                                  ),
                                                            FxBox.h24,

                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              // mainAxisSize:
                                                              //     MainAxisSize.min,
                                                              children: [
                                                                // Tooltip(
                                                                //   message:
                                                                //       "Capture Image",
                                                                //   child:
                                                                //       IconButton(
                                                                //     onPressed:
                                                                //         () {
                                                                //       // Navigator
                                                                //       //     .push(
                                                                //       //   context,
                                                                //       //   MaterialPageRoute(
                                                                //       //     builder:
                                                                //       //         (context) =>
                                                                //       //             AppBody(), // Navigate to AppBody screen
                                                                //       //   ),

                                                                //       // );
                                                                //     },
                                                                //     icon: const Icon(
                                                                //         Icons
                                                                //             .photo_camera_rounded,
                                                                //         // size: 300,
                                                                //         color: AppColors
                                                                //             .babyBlue),
                                                                //   ),
                                                                // ),
                                                                ElevatedButton(
                                                                  onPressed:
                                                                      () async {
                                                                    try {
                                                                      await FilePicker
                                                                          .platform
                                                                          .pickFiles(
                                                                              type: FileType.image)
                                                                          .then((result) {
                                                                        if (result !=
                                                                            null) {
                                                                          AllEmployeesBloc.get(context)
                                                                              .add(imageevent(imageFile: result.files.last));

                                                                          // This code block should execute after the image file has been picked
                                                                          List<int> imageBytes = result
                                                                              .files
                                                                              .first
                                                                              .bytes!;
                                                                          String
                                                                              base64Image =
                                                                              base64Encode(imageBytes);

                                                                          AllEmployeesBloc.get(context)
                                                                              .add(AddNewEmployee(
                                                                            companyName:
                                                                                companyNameRepo,
                                                                            personName:
                                                                                state.personName,
                                                                            userId:
                                                                                state.userId,
                                                                            email:
                                                                                state.email,
                                                                            phoneNum:
                                                                                state.phoneNum,
                                                                            image:
                                                                                base64Image,
                                                                          ));
                                                                        }
                                                                      });
                                                                    } catch (e) {
                                                                      debugPrint(
                                                                          "Error picking file: $e");
                                                                    }
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    'Upload Image',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),

                                                            const SizedBox(
                                                                height: 24),
                                                            //////////////////////////////////////

                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(
                                                                      16.0),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  const Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            'BlackListed:',
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.w900,
                                                                                color: AppColors.white,
                                                                                fontSize: 20.0),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                15,
                                                                          ),
                                                                          Icon(
                                                                            Icons.warning_amber_outlined,
                                                                            color:
                                                                                Colors.red,
                                                                            size:
                                                                                35,
                                                                          ),
                                                                          // SizedBox(
                                                                          //   width:
                                                                          //       50,
                                                                          // ),
                                                                        ],
                                                                      ),
                                                                      Tooltip(
                                                                        message:
                                                                            "If the person is BlackListed he has no access to any room if not choose the rooms he is authorized to enter",
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .info_outline,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  RadioListTile(
                                                                    activeColor:
                                                                        Colors
                                                                            .white,
                                                                    title: const Text(
                                                                        'Yes',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white)),
                                                                    value:
                                                                        'True',
                                                                    groupValue:
                                                                        state
                                                                            .selectedOption,
                                                                    onChanged:
                                                                        (value) {
                                                                      context.read<AllEmployeesBloc>().add(RadioButtonChanged(
                                                                          selectedOption: value
                                                                              .toString(),
                                                                          showTextField:
                                                                              false));
                                                                    },
                                                                  ),
                                                                  RadioListTile(
                                                                    activeColor:
                                                                        Colors
                                                                            .white,
                                                                    title: const Text(
                                                                        'No',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white)),
                                                                    value:
                                                                        'False',
                                                                    groupValue:
                                                                        state
                                                                            .selectedOption,
                                                                    onChanged:
                                                                        (value) {
                                                                      context.read<AllEmployeesBloc>().add(RadioButtonChanged(
                                                                          selectedOption: value
                                                                              .toString(),
                                                                          showTextField:
                                                                              true));
                                                                    },
                                                                  ),
                                                                  FxBox.h24,
                                                                  if (state
                                                                      .showTextField)
                                                                    multiSelectGenericDropdown(
                                                                      showSearch:
                                                                          true,
                                                                      isEnabled:
                                                                          true,
                                                                      isRequired:
                                                                          false,
                                                                      filled:
                                                                          true,
                                                                      // selectedItem:
                                                                      //     null,
                                                                      titleName:
                                                                          "Room Access Management",
                                                                      onChanged:
                                                                          (value) {
                                                                        AllEmployeesBloc.get(context).add(checkBox(
                                                                            room_NMs:
                                                                                value!));
                                                                      },
                                                                      itemsList:
                                                                          checkboxItems,
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
                                                            // AllEmployeesBloc.get(
                                                            //         context)
                                                            //     .add(const imageevent(
                                                            //         imageFile: null));
                                                            // state.imageFile == null;

                                                            Navigator.of(
                                                                    context)
                                                                .pop(); // Close the dialog
                                                          },
                                                          child: const Text(
                                                            'Cancel',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red),
                                                          ),
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            if (state.personName
                                                                .isEmpty) {
                                                              FxToast.showErrorToast(
                                                                  context:
                                                                      context,
                                                                  message:
                                                                      "Add person Name");
                                                              return;
                                                            }

                                                            if (state
                                                                .selectedOption
                                                                .isEmpty) {
                                                              FxToast.showErrorToast(
                                                                  context:
                                                                      context,
                                                                  message:
                                                                      "Choose if the person is blacklisted or Not");
                                                              return;
                                                            }
                                                            if (state.userId
                                                                .isEmpty) {
                                                              FxToast.showErrorToast(
                                                                  context:
                                                                      context,
                                                                  message:
                                                                      "Add UserId");
                                                              return;
                                                            }
                                                            if (state.email
                                                                .isEmpty) {
                                                              FxToast.showErrorToast(
                                                                  context:
                                                                      context,
                                                                  message:
                                                                      "Add Email");
                                                              return;
                                                            }
                                                            if (state.image
                                                                .isEmpty) {
                                                              FxToast.showErrorToast(
                                                                  context:
                                                                      context,
                                                                  message:
                                                                      "Add Image");
                                                              return;
                                                            }
                                                            if (state.phoneNum
                                                                .isEmpty) {
                                                              FxToast.showErrorToast(
                                                                  context:
                                                                      context,
                                                                  message:
                                                                      "Add Phone Number");
                                                              return;
                                                            }

                                                            if (state.personName ==
                                                                    "" &&
                                                                state.userId ==
                                                                    "" &&
                                                                state.email ==
                                                                    "" &&
                                                                state.image ==
                                                                    "" &&
                                                                state.phoneNum ==
                                                                    "") {
                                                              FxToast
                                                                  .showErrorToast(
                                                                context:
                                                                    context,
                                                                message:
                                                                    "Please Fill all the fields ",
                                                              );
                                                              return;
                                                            }
                                                            AllEmployeesBloc
                                                                    .get(
                                                                        context)
                                                                .add(
                                                                    const AddNewEmployeeEvent());

                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: const Text(
                                                            'Save',
                                                            style: TextStyle(
                                                                color: AppColors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              );
                                            }).catchError((error) {
                                          // Handle error
                                          debugPrint(
                                              "Error loading image: $error");
                                        });
                                      },
                                    );
                                  },
                                  child: const Text(
                                    "Add Employee",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (!Responsive.isWeb(context))
                          SizedBox(
                            width: double.infinity,
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ///search field
                                Form(
                                  child: SizedBox(
                                    height: 50,
                                    width: 300,
                                    child: TextFormField(
                                      cursorColor: Colors.black,
                                      style:
                                          const TextStyle(color: Colors.black),
                                      controller: _searchController,
                                      decoration: InputDecoration(
                                        hintText: 'Search For Employee'.tr(),
                                        hintStyle: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        fillColor: Colors
                                            .white, // Set the fill color to white
                                        filled: true, //

                                        ///search Toggle
                                        suffixIcon: IconButton(
                                          icon: state.isSearching
                                              ? const Icon(Icons.close)
                                              : const Icon(Icons.search),
                                          onPressed: () async {
                                            state.isSearching = !state
                                                .isSearching; // Toggle the search state
                                            if (!state.isSearching) {
                                              _searchController.clear();
                                            }

                                            if (state.isSearching) {
                                              AllEmployeesBloc.get(context).add(
                                                GetPersonByNameEvent(
                                                  companyName: companyNameRepo,
                                                  personName:
                                                      _searchController.text,
                                                ),
                                              );
                                            } else {
                                              if (state.filterCase == "All") {
                                                AllEmployeesBloc.get(context)
                                                    .add(const EditPageNumber(
                                                        pageIndex: 1));
                                              } else if (state.filterCase ==
                                                  "Neutral") {
                                                AllEmployeesBloc.get(context).add(
                                                    const GetEmployeeNormalNamesEvent());
                                              } else if (state.filterCase ==
                                                  "BlackListed") {
                                                AllEmployeesBloc.get(context).add(
                                                    const GetEmployeeBlackListedNamesEvent());
                                              } else {
                                                AllEmployeesBloc.get(context)
                                                    .add(const EditPageNumber(
                                                        pageIndex: 1));
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // Add Employee Button
                                FxBox.h24,

                                MaterialButton(
                                  height: 55,
                                  minWidth: 210,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  color: AppColors.grey2,
                                  //  Color.fromARGB(255, 143, 188, 211),
                                  onPressed: () async {
                                    // Load the image file from the assets directory
                                    rootBundle
                                        .load(
                                            'assets/images/imagepickWhite.png')
                                        .then(
                                      (imageData) {
                                        Uint8List uint8List =
                                            imageData.buffer.asUint8List();

                                        PlatformFile imageFile = PlatformFile(
                                          name: 'imagepickWhite.png',
                                          size: uint8List.lengthInBytes,
                                          bytes: uint8List,
                                        );

                                        // Add the imageFile object to the AllEmployeesBloc
                                        AllEmployeesBloc.get(context).add(
                                            imageevent(imageFile: imageFile));
                                        AllEmployeesBloc.get(context)
                                            .add(const RadioButtonChanged(
                                          selectedOption: "",
                                          showTextField: false,
                                        ));
                                        // // Load the image file from the assets directory
                                        // ByteData imageData = await rootBundle.load(
                                        //     'assets/images/imagepickWhite.png');

                                        // // Create a Uint8List from the image bytes
                                        // Uint8List uint8List =
                                        //     imageData.buffer.asUint8List();

                                        // // Create a PlatformFile object with the correct properties
                                        // PlatformFile imageFile =
                                        // PlatformFile(
                                        //   name: 'imagepickWhite.png',
                                        //   size: uint8List
                                        //       .lengthInBytes, // The size of the image file in bytes
                                        //   bytes:
                                        //       uint8List, // The byte representation of the image file
                                        // );

                                        // // Add the imageFile object to the AllEmployeesBloc
                                        // AllEmployeesBloc.get(context)
                                        //     .add(imageevent(imageFile: imageFile));

                                        // Show dialog to fill in employee data
                                        showDialog(
                                            context: context,
                                            builder: (ctx) {
                                              return BlocProvider.value(
                                                value: AllEmployeesBloc.get(
                                                    context),
                                                child: BlocBuilder<
                                                    AllEmployeesBloc,
                                                    AllEmployeesState>(
                                                  builder: (context, state) {
                                                    return AlertDialog(
                                                      title: const SizedBox(
                                                        width: 500,
                                                        child: Text(
                                                          "Add Employee",
                                                          style: TextStyle(
                                                              color: AppColors
                                                                  .white),
                                                        ),
                                                      ),
                                                      content:
                                                          SingleChildScrollView(
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            buildTextFormField(
                                                              labelText: 'Name',
                                                              onChanged:
                                                                  (valuee) async {
                                                                AllEmployeesBloc
                                                                        .get(
                                                                            context)
                                                                    .add(
                                                                  AddpersonName(
                                                                    personName:
                                                                        valuee,
                                                                  ),
                                                                );
                                                              },
                                                            ),

                                                            FxBox.h24,

                                                            buildTextFormField(
                                                              keyboardType:
                                                                  TextInputType
                                                                      .phone,
                                                              inputFormatters: [
                                                                FilteringTextInputFormatter
                                                                    .digitsOnly,
                                                              ],
                                                              labelText:
                                                                  'UserId',
                                                              hintText:
                                                                  'ex: 5643548',
                                                              onChanged:
                                                                  (value) async {
                                                                AllEmployeesBloc
                                                                        .get(
                                                                            context)
                                                                    .add(
                                                                  AdduserId(
                                                                    userId:
                                                                        value,
                                                                  ),
                                                                );
                                                              },
                                                            ),

                                                            FxBox.h24,

                                                            buildTextFormField(
                                                              keyboardType:
                                                                  TextInputType
                                                                      .phone,
                                                              inputFormatters: [
                                                                FilteringTextInputFormatter
                                                                    .digitsOnly,
                                                              ],
                                                              labelText:
                                                                  'Phone Number',
                                                              onChanged:
                                                                  (value) async {
                                                                AllEmployeesBloc
                                                                        .get(
                                                                            context)
                                                                    .add(
                                                                  AddphoneNum(
                                                                    phoneNum:
                                                                        value,
                                                                  ),
                                                                );
                                                              },
                                                            ),

                                                            FxBox.h24,

                                                            buildTextFormField(
                                                              keyboardType:
                                                                  TextInputType
                                                                      .emailAddress,
                                                              // inputFormatters: [
                                                              //   FilteringTextInputFormatter
                                                              //       .allow(
                                                              //     RegExp(
                                                              //         r'^[\w-\.]+@[a-zA-Z]+\.[a-zA-Z]{2,4}$'),
                                                              //   ),
                                                              // ],
                                                              hintText:
                                                                  'ex: name@gmail.com  ',
                                                              labelText:
                                                                  'Email',
                                                              onChanged:
                                                                  (value) async {
                                                                AllEmployeesBloc
                                                                        .get(
                                                                            context)
                                                                    .add(
                                                                  Addemail(
                                                                    email:
                                                                        value,
                                                                  ),
                                                                );
                                                              },
                                                            ),

                                                            FxBox.h24,
                                                            if (state
                                                                    .imageFile !=
                                                                null)
                                                              SizedBox(
                                                                  height: 100,
                                                                  child: state.imageFile!
                                                                              .bytes !=
                                                                          null
                                                                      ? Image
                                                                          .memory(
                                                                          state
                                                                              .imageFile!
                                                                              .bytes!,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        )
                                                                      : loadingIndicator() // Show circular progress indicator while loading
                                                                  ),

                                                            FxBox.h24,

                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              // mainAxisSize:
                                                              //     MainAxisSize.min,
                                                              children: [
                                                                // Tooltip(
                                                                //   message:
                                                                //       "Capture Image",
                                                                //   child: IconButton(
                                                                //     onPressed: () {
                                                                //       Navigator
                                                                //           .push(
                                                                //         context,
                                                                //         MaterialPageRoute(
                                                                //           builder:
                                                                //               (context) =>
                                                                //                   AppBody(), // Navigate to AppBody screen
                                                                //         ),

                                                                //       );

                                                                //     },
                                                                //     icon: const Icon(
                                                                //         Icons
                                                                //             .photo_camera_rounded,
                                                                //         // size: 300,
                                                                //         color: AppColors
                                                                //             .babyBlue),
                                                                //   ),
                                                                // ),
                                                                ElevatedButton(
                                                                  onPressed:
                                                                      () async {
                                                                    try {
                                                                      await FilePicker
                                                                          .platform
                                                                          .pickFiles(
                                                                              type: FileType.image)
                                                                          .then((result) {
                                                                        if (result !=
                                                                            null) {
                                                                          AllEmployeesBloc.get(context)
                                                                              .add(imageevent(imageFile: result.files.last));

                                                                          // This code block should execute after the image file has been picked
                                                                          List<int> imageBytes = result
                                                                              .files
                                                                              .first
                                                                              .bytes!;
                                                                          String
                                                                              base64Image =
                                                                              base64Encode(imageBytes);

                                                                          AllEmployeesBloc.get(context)
                                                                              .add(AddNewEmployee(
                                                                            companyName:
                                                                                companyNameRepo,
                                                                            personName:
                                                                                state.personName,
                                                                            userId:
                                                                                state.userId,
                                                                            email:
                                                                                state.email,
                                                                            phoneNum:
                                                                                state.phoneNum,
                                                                            image:
                                                                                base64Image,
                                                                          ));
                                                                        }
                                                                      });
                                                                    } catch (e) {
                                                                      debugPrint(
                                                                          "Error picking file: $e");
                                                                    }
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    'Upload Image',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),

                                                            const SizedBox(
                                                                height: 24),
                                                            //////////////////////////////////////

                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(
                                                                      16.0),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  const Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    // mainAxisSize:
                                                                    //     MainAxisSize
                                                                    //         .min,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
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
                                                                              // SizedBox(
                                                                              //   width:
                                                                              //       50,
                                                                              // ),
                                                                            ],
                                                                          ),
                                                                          Tooltip(
                                                                            message:
                                                                                "If the person is BlackListed he has no access to any room if not choose the rooms he is authorized to enter",
                                                                            child:
                                                                                Icon(
                                                                              Icons.info_outline,
                                                                              color: Colors.white,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  RadioListTile(
                                                                    activeColor:
                                                                        Colors
                                                                            .white,
                                                                    title: const Text(
                                                                        'Yes',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white)),
                                                                    value:
                                                                        'True',
                                                                    groupValue:
                                                                        state
                                                                            .selectedOption,
                                                                    onChanged:
                                                                        (value) {
                                                                      context.read<AllEmployeesBloc>().add(RadioButtonChanged(
                                                                          selectedOption: value
                                                                              .toString(),
                                                                          showTextField:
                                                                              false));
                                                                    },
                                                                  ),
                                                                  RadioListTile(
                                                                    activeColor:
                                                                        Colors
                                                                            .white,
                                                                    title: const Text(
                                                                        'No',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white)),
                                                                    value:
                                                                        'False',
                                                                    groupValue:
                                                                        state
                                                                            .selectedOption,
                                                                    onChanged:
                                                                        (value) {
                                                                      context.read<AllEmployeesBloc>().add(RadioButtonChanged(
                                                                          selectedOption: value
                                                                              .toString(),
                                                                          showTextField:
                                                                              true));
                                                                    },
                                                                  ),
                                                                  FxBox.h24,
                                                                  if (state
                                                                      .showTextField)
                                                                    multiSelectGenericDropdown(
                                                                      showSearch:
                                                                          true,
                                                                      isEnabled:
                                                                          true,
                                                                      isRequired:
                                                                          false,
                                                                      filled:
                                                                          true,
                                                                      // selectedItem:
                                                                      //     null,
                                                                      titleName:
                                                                          "Room Access Management",
                                                                      onChanged:
                                                                          (value) {
                                                                        AllEmployeesBloc.get(context).add(checkBox(
                                                                            room_NMs:
                                                                                value!));
                                                                      },
                                                                      itemsList:
                                                                          checkboxItems,
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
                                                            Navigator.of(
                                                                    context)
                                                                .pop(); // Close the dialog
                                                          },
                                                          child: const Text(
                                                            'Cancel',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red),
                                                          ),
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            if (state.personName
                                                                .isEmpty) {
                                                              FxToast.showErrorToast(
                                                                  context:
                                                                      context,
                                                                  message:
                                                                      "Add person Name");
                                                              return;
                                                            }

                                                            if (state
                                                                .selectedOption
                                                                .isEmpty) {
                                                              FxToast.showErrorToast(
                                                                  context:
                                                                      context,
                                                                  message:
                                                                      "Choose if the person is blacklisted or Not");
                                                              return;
                                                            }
                                                            if (state.userId
                                                                .isEmpty) {
                                                              FxToast.showErrorToast(
                                                                  context:
                                                                      context,
                                                                  message:
                                                                      "Add UserId");
                                                              return;
                                                            }
                                                            if (state.email
                                                                .isEmpty) {
                                                              FxToast.showErrorToast(
                                                                  context:
                                                                      context,
                                                                  message:
                                                                      "Add Email");
                                                              return;
                                                            }
                                                            if (state.image
                                                                .isEmpty) {
                                                              FxToast.showErrorToast(
                                                                  context:
                                                                      context,
                                                                  message:
                                                                      "Add Image");
                                                              return;
                                                            }
                                                            if (state.phoneNum
                                                                .isEmpty) {
                                                              FxToast.showErrorToast(
                                                                  context:
                                                                      context,
                                                                  message:
                                                                      "Add Phone Number");
                                                              return;
                                                            }

                                                            if (state.personName ==
                                                                    "" &&
                                                                state.userId ==
                                                                    "" &&
                                                                state.email ==
                                                                    "" &&
                                                                state.image ==
                                                                    "" &&
                                                                state.phoneNum ==
                                                                    "") {
                                                              FxToast
                                                                  .showErrorToast(
                                                                context:
                                                                    context,
                                                                message:
                                                                    "Please Fill all the fields ",
                                                              );
                                                              return;
                                                            }
                                                            AllEmployeesBloc
                                                                    .get(
                                                                        context)
                                                                .add(
                                                                    const AddNewEmployeeEvent());

                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: const Text(
                                                            'Save',
                                                            style: TextStyle(
                                                                color: AppColors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              );
                                            }).catchError((error) {
                                          // Handle error
                                          print("Error loading image: $error");
                                        });
                                      },
                                    );
                                  },
                                  child: const Text(
                                    "Add Employee",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                // }),
                              ],
                            ),
                          ),
                        FxBox.h24,
                        Row(
                          children: [
                            Text(
                              "Filter By : ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: (Responsive.isWeb(context)) ? 25 : 17,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: SizedBox(
                                width: 170,
                                child: singleSelectGenericDropdown<String>(
                                  // titleName: "Filter By:",
                                  isEnabled: true,
                                  isRequired: false,
                                  filled: true,
                                  // showSearch: true,
                                  selectedItem: state.filterCase!.isEmpty
                                      ? "All"
                                      : state.filterCase,
                                  onChanged: (value) {
                                    AllEmployeesBloc.get(context)
                                        .add(const EditPageNumber(
                                      pageIndex: 1,
                                    ));
                                    // AllEmployeesBloc.get(context)
                                    //     .add(const EditPageNumberNeutral(
                                    //   pageIndex: 1,
                                    // ));
                                    // AllEmployeesBloc.get(context)
                                    //     .add(const EditPageNumberBlackListed(
                                    //   pageIndex: 1,
                                    // ));
                                    if (value?.isNotEmpty ?? false) {
                                      AllEmployeesBloc.get(context).add(
                                          selectedFiltering(
                                              filterCase: value ?? ""));
                                      if (value == "All") {
                                        AllEmployeesBloc.get(context)
                                            .add(const GetEmployeeNamesEvent());
                                        // AllEmployeesBloc.get(context)
                                        //     .add(const EditPageNumber(
                                        //   pageIndex: 1,
                                        // ));
                                      } else if (value == "Neutral") {
                                        AllEmployeesBloc.get(context).add(
                                            const GetEmployeeNormalNamesEvent());
                                        // AllEmployeesBloc.get(context)
                                        //     .add(const EditPageNumberNeutral(
                                        //   pageIndex: 1,
                                        // ));
                                      } else if (value == "BlackListed") {
                                        AllEmployeesBloc.get(context).add(
                                            const GetEmployeeBlackListedNamesEvent());
                                        // AllEmployeesBloc.get(context).add(
                                        //     const EditPageNumberBlackListed(
                                        //   pageIndex: 1,
                                        // ));
                                      }
                                    }
                                  },
                                  itemsList: ["All", "Neutral", "BlackListed"],
                                ),
                              ),
                            ),
                          ],
                        ),
                        BlocProvider.value(
                          value: AllEmployeesBloc.get(context),
                          child:
                              BlocBuilder<AllEmployeesBloc, AllEmployeesState>(
                            builder: (context, state) {
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      // Display the pagination controls
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 15.0),
                                        child: CustomPagination(
                                          // persons: state
                                          //     .employeeNamesList, // Pass the list of data
                                          pageCount: state
                                              .pageCount, // Pass the page count
                                          onPageChanged: (int index) async {
                                            ///////////////////////////
                                            if (state.filterCase == "All") {
                                              AllEmployeesBloc.get(context).add(
                                                  EditPageNumber(
                                                      pageIndex: index));
                                            } else if (state.filterCase ==
                                                "Neutral") {
                                              AllEmployeesBloc.get(context).add(
                                                  EditPageNumberNeutral(
                                                      pageIndex: index));
                                            } else if (state.filterCase ==
                                                "BlackListed") {
                                              AllEmployeesBloc.get(context).add(
                                                  EditPageNumberBlackListed(
                                                      pageIndex: index));
                                            } else {
                                              AllEmployeesBloc.get(context).add(
                                                  EditPageNumber(
                                                      pageIndex: index));
                                            }
                                            //////////////////////////////
                                          },
                                        ),
                                      ),
                                      // Display the list of data
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child:
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
                                                          AllEmployeesBloc.get(
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
                                                                value: AllEmployeesBloc
                                                                    .get(
                                                                        context),
                                                                child: BlocBuilder<
                                                                    AllEmployeesBloc,
                                                                    AllEmployeesState>(
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
                                                                                if (value.isNotEmpty) {
                                                                                  AllEmployeesBloc.get(context).add(
                                                                                    AddpersonName(personName: value),
                                                                                  );
                                                                                } else {
                                                                                  AllEmployeesBloc.get(context).add(
                                                                                    AddpersonName(personName: employee.name ?? ""),
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
                                                                                if (value.isNotEmpty) {
                                                                                  AllEmployeesBloc.get(context).add(
                                                                                    AdduserId(
                                                                                      userId: value,
                                                                                    ),
                                                                                  );
                                                                                } else {
                                                                                  AllEmployeesBloc.get(context).add(
                                                                                    AdduserId(
                                                                                      userId: employee.userId ?? "",
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
                                                                                if (value.isNotEmpty) {
                                                                                  AllEmployeesBloc.get(context).add(
                                                                                    AddphoneNum(
                                                                                      phoneNum: value,
                                                                                    ),
                                                                                  );
                                                                                } else {
                                                                                  AllEmployeesBloc.get(context).add(
                                                                                    AddphoneNum(
                                                                                      phoneNum: employee.phone ?? "",
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
                                                                                if (value.isNotEmpty) {
                                                                                  AllEmployeesBloc.get(context).add(
                                                                                    Addemail(
                                                                                      email: value,
                                                                                    ),
                                                                                  );
                                                                                } else {
                                                                                  AllEmployeesBloc.get(context).add(
                                                                                    Addemail(
                                                                                      email: employee.email ?? "",
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

                                                                            ////////////////////////////////////////
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
                                                                                      AllEmployeesBloc.get(context).add(RadioButtonChanged(selectedOption: value.toString(), showTextField: false));
                                                                                    },
                                                                                  ),
                                                                                  RadioListTile(
                                                                                    activeColor: Colors.white,
                                                                                    title: const Text('No', style: TextStyle(color: Colors.white)),
                                                                                    value: 'False',
                                                                                    // selected: employee.blackListed != "True",
                                                                                    groupValue: state.selectedOption,
                                                                                    onChanged: (value) {
                                                                                      AllEmployeesBloc.get(context).add(RadioButtonChanged(selectedOption: value.toString(), showTextField: true));
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
                                                                                        AllEmployeesBloc.get(context).add(checkBox(room_NMs: value!));
                                                                                      },
                                                                                      itemsList: checkboxItems,
                                                                                    ),
                                                                                ],
                                                                              ),
                                                                            ),

                                                                            ///////////////////////////////////////////////
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      actions: [
                                                                        TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            // AllEmployeesBloc.get(context).add(RadioButtonChanged(
                                                                            //   selectedOption: "",
                                                                            // ));

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
                                                                            AllEmployeesBloc.get(context).add(
                                                                              UpdateEmployeeEvent(
                                                                                companyName: companyNameRepo,
                                                                                id: employee.sId ?? '',

                                                                                // userId: state.userId,
                                                                                // companyName: state.companyName,
                                                                              ),
                                                                            );
                                                                            // AllEmployeesBloc.get(context).add(RadioButtonChanged(
                                                                            //   selectedOption: "",
                                                                            // ));

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
                                                        onDelete: () {
                                                          _showDeleteDialog(
                                                              context,
                                                              employee.name ??
                                                                  '');
                                                        },
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
              //   create: (context) => AllEmployeesBloc(),
              //   child: BlocBuilder<AllEmployeesBloc, AllEmployeesState>(
              //     builder: (context, state) {
              //       return
              PopupMenuButton<String>(
                color: Colors.white,
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
                  context.read<AllEmployeesBloc>().add(
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

  // void _openCameraDialog() async {
  //   await _initializeCamera().then((value) {
  //     showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: const Text('Camera'),
  //         content: SizedBox(
  //           width: 300,
  //           height: 300,
  //           child: _controller.value.isInitialized
  //               ? CameraPreview(_controller)
  //               : CircularProgressIndicator(),
  //         ),
  //         actions: [
  //           ElevatedButton(
  //             onPressed: () async {
  //               final image = await _controller.takePicture();
  //               setState(() {
  //                 _imageFile = image;
  //               });
  //               _controller.dispose();
  //               Navigator.pop(context);
  //             },
  //             child: Text('Capture Image'),
  //           ),
  //           ElevatedButton(
  //             onPressed: () {
  //               _controller.dispose();
  //               Navigator.pop(context);
  //             },
  //             child: Text('Close'),
  //           ),
  //         ],
  //       );
  //     },
  //   );

  //   });
  // }

  // Future<Uint8List> _getImageBytes() async {
  //   final bytes = await _imageFile!.readAsBytes();
  //   return bytes;
  // }
}
