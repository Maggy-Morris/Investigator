import 'dart:convert';

import 'package:Investigator/core/loader/loading_indicator.dart';
import 'package:Investigator/core/models/employee_model.dart';
import 'package:Investigator/core/remote_provider/remote_data_source.dart';
import 'package:Investigator/core/resources/app_colors.dart';
import 'package:Investigator/core/widgets/customTextField.dart';
import 'package:Investigator/presentation/all_employees/screens/text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
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
import '../../search/screens/camera_front.dart';
import '../bloc/all_employess_bloc.dart';

class AllEmployeesScreen extends StatefulWidget {
  // static Route<dynamic> route(List<Data> data) {
  //   return MaterialPageRoute<dynamic>(
  //     builder: (_) => const AllEmployeesScreen(),
  //   );
  // }

  const AllEmployeesScreen({
    Key? key,
    // required this.data
  }) : super(key: key);

  @override
  State<AllEmployeesScreen> createState() => _AllEmployeesScreenState();
}

class _AllEmployeesScreenState extends State<AllEmployeesScreen> {
  PlatformFile? selectedImage;
  String companyNameRepo =
      AuthenticationRepository.instance.currentUser.companyName?.first ?? "";
  List<String> checkboxItems =
      AuthenticationRepository.instance.currentUser.roomsNames ?? [];
  Map<String, bool> checkboxMap = {};
  // bool _val = false;

// for (String item in checkboxItems) {
//   checkboxMap[item] = false; // Set the initial value to false
// }
  //////////////

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
                          "All Employees ($companyNameRepo)".tr(),
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
                                    height: 40,
                                    width: 300,
                                    child: TextFormField(
                                      cursorColor: Colors.white,
                                      style: TextStyle(color: Colors.black),
                                      controller: _searchController,
                                      decoration: InputDecoration(
                                        labelText: 'Search For Employee'.tr(),
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
                                              AllEmployeesBloc.get(context).add(
                                                  const EditPageNumber(
                                                      pageIndex: 1));
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
                                  height: 50,
                                  minWidth: 210,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  color: AppColors.grey2,
                                  //  Color.fromARGB(255, 143, 188, 211),
                                  onPressed: () {
                                    // Show dialog to fill in employee data
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return BlocProvider(
                                          create: (context) =>
                                              AllEmployeesBloc(),
                                          child: BlocBuilder<AllEmployeesBloc,
                                              AllEmployeesState>(
                                            builder: (context, state) {
                                              return AlertDialog(
                                                title:
                                                    const Text("Add Employee"),
                                                content: SingleChildScrollView(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      buildTextFormField(
                                                        labelText: 'Name',
                                                        onChanged:
                                                            (valuee) async {
                                                          AllEmployeesBloc.get(
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
                                                        labelText: 'UserId',
                                                        onChanged:
                                                            (value) async {
                                                          AllEmployeesBloc.get(
                                                                  context)
                                                              .add(
                                                            AdduserId(
                                                              userId: value,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                      FxBox.h24,
                                                      buildTextFormField(
                                                        labelText:
                                                            'Phone Number',
                                                        onChanged:
                                                            (value) async {
                                                          AllEmployeesBloc.get(
                                                                  context)
                                                              .add(
                                                            AddphoneNum(
                                                              phoneNum: value,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                      FxBox.h24,

                                                      buildTextFormField(
                                                        labelText: 'Email',
                                                        onChanged:
                                                            (value) async {
                                                          AllEmployeesBloc.get(
                                                                  context)
                                                              .add(
                                                            Addemail(
                                                              email: value,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                      FxBox.h24,
                                                      // TextFormField(
                                                      //   // controller:
                                                      //   //     employeeNameController,
                                                      //   decoration:
                                                      //       const InputDecoration(
                                                      //           labelText:
                                                      //               'Profession'),
                                                      //   onChanged:
                                                      //       (valueeeeeee) async {},
                                                      // ),
                                                      FxBox.h24,
                                                      if (selectedImage !=
                                                              null &&
                                                          selectedImage!
                                                                  .bytes !=
                                                              null)
                                                        SizedBox(
                                                            height: 100,
                                                            child: selectedImage!
                                                                        .bytes !=
                                                                    null
                                                                ? Image.memory(
                                                                    selectedImage!
                                                                        .bytes!,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  )
                                                                : loadingIndicator() // Show circular progress indicator while loading
                                                            ),
                                                      const SizedBox(
                                                          height: 24),
                                                      ElevatedButton(
                                                        onPressed: () async {
                                                          try {
                                                            // FilePickerResult?
                                                            //     result =
                                                            await FilePicker
                                                                .platform
                                                                .pickFiles(
                                                              type: FileType
                                                                  .image,
                                                            )
                                                                .then((result) {
                                                              if (result !=
                                                                      null &&
                                                                  result.files
                                                                      .isNotEmpty) {
                                                                setState(() {
                                                                  selectedImage =
                                                                      result
                                                                          .files
                                                                          .first;
                                                                });

                                                                List<int>
                                                                    imageBytes =
                                                                    selectedImage!
                                                                        .bytes!;

                                                                String
                                                                    base64Image =
                                                                    base64Encode(
                                                                        imageBytes);

                                                                AllEmployeesBloc
                                                                        .get(
                                                                            context)
                                                                    .add(
                                                                  AddNewEmployee(
                                                                    companyName:
                                                                        companyNameRepo,
                                                                    personName:
                                                                        state
                                                                            .personName,
                                                                    userId: state
                                                                        .userId,
                                                                    email: state
                                                                        .email,
                                                                    phoneNum: state
                                                                        .phoneNum,
                                                                    image:
                                                                        base64Image,
                                                                  ),
                                                                );
                                                              }
                                                            });
                                                          } catch (e) {
                                                            debugPrint(
                                                                "Error picking file: $e");
                                                          }
                                                        },
                                                        child: const Text(
                                                          'Upload Image',
                                                          style: TextStyle(
                                                              color: AppColors
                                                                  .black),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(); // Close the dialog
                                                    },
                                                    child: const Text(
                                                      'Cancel',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      AllEmployeesBloc.get(
                                                              context)
                                                          .add(
                                                              const AddNewEmployeeEvent());

                                                      AllEmployeesBloc.get(
                                                              context)
                                                          .add(
                                                              const GetEmployeeNamesEvent());
                                                      employeeNameController
                                                          .clear();
                                                      setState(() {
                                                        selectedImage = null;
                                                      });

                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text(
                                                      'Save',
                                                      style: TextStyle(
                                                          color:
                                                              AppColors.black),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        );
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

                                // MaterialButton(
                                //   height: 50,
                                //   minWidth: 210,
                                //   shape: RoundedRectangleBorder(
                                //     borderRadius: BorderRadius.circular(15.0),
                                //   ),
                                //   color: AppColors.grey2,
                                //   //  Color.fromARGB(255, 143, 188, 211),
                                //   onPressed: () {
                                //     _addEmployeeDialog(context, state);
                                //     // Show dialog to fill in employee data
                                //   },
                                //   child: const Text(
                                //     "Add Employee",
                                //     style: TextStyle(
                                //       fontSize: 16,
                                //       color: Colors.white,
                                //       fontWeight: FontWeight.w500,
                                //     ),
                                //   ),
                                // ),
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
                                    height: 40,
                                    width: 300,
                                    child: TextFormField(
                                      cursorColor: Colors.white,
                                      style: TextStyle(color: Colors.black),
                                      controller: _searchController,
                                      decoration: InputDecoration(
                                        labelText: 'Search For Employee'.tr(),
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
                                              AllEmployeesBloc.get(context).add(
                                                  const EditPageNumber(
                                                      pageIndex: 1));
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
                                  height: 50,
                                  minWidth: 210,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  color: AppColors.grey2,
                                  //  Color.fromARGB(255, 143, 188, 211),
                                  onPressed: () {
                                    // Show dialog to fill in employee data
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return BlocProvider(
                                          create: (context) =>
                                              AllEmployeesBloc(),
                                          child: BlocBuilder<AllEmployeesBloc,
                                              AllEmployeesState>(
                                            builder: (context, state) {
                                              return AlertDialog(
                                                title:
                                                    const Text("Add Employee"),
                                                content: SingleChildScrollView(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      buildTextFormField(
                                                        labelText: 'Name',
                                                        onChanged:
                                                            (valuee) async {
                                                          AllEmployeesBloc.get(
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
                                                        labelText: 'UserId',
                                                        onChanged:
                                                            (value) async {
                                                          AllEmployeesBloc.get(
                                                                  context)
                                                              .add(
                                                            AdduserId(
                                                              userId: value,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                      FxBox.h24,
                                                      buildTextFormField(
                                                        labelText:
                                                            'Phone Number',
                                                        onChanged:
                                                            (value) async {
                                                          AllEmployeesBloc.get(
                                                                  context)
                                                              .add(
                                                            AddphoneNum(
                                                              phoneNum: value,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                      FxBox.h24,

                                                      buildTextFormField(
                                                        labelText: 'Email',
                                                        onChanged:
                                                            (value) async {
                                                          AllEmployeesBloc.get(
                                                                  context)
                                                              .add(
                                                            Addemail(
                                                              email: value,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                      FxBox.h24,
                                                      // TextFormField(
                                                      //   // controller:
                                                      //   //     employeeNameController,
                                                      //   decoration:
                                                      //       const InputDecoration(
                                                      //           labelText:
                                                      //               'Profession'),
                                                      //   onChanged:
                                                      //       (valueeeeeee) async {},
                                                      // ),
                                                      FxBox.h24,
                                                      if (selectedImage !=
                                                              null &&
                                                          selectedImage!
                                                                  .bytes !=
                                                              null)
                                                        SizedBox(
                                                            height: 100,
                                                            child: selectedImage!
                                                                        .bytes !=
                                                                    null
                                                                ? Image.memory(
                                                                    selectedImage!
                                                                        .bytes!,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  )
                                                                : loadingIndicator() // Show circular progress indicator while loading
                                                            ),
                                                      const SizedBox(
                                                          height: 24),

                                                      ElevatedButton(
                                                        onPressed: () async {
                                                          try {
                                                            // FilePickerResult?
                                                            //     result =
                                                            await FilePicker
                                                                .platform
                                                                .pickFiles(
                                                              type: FileType
                                                                  .image,
                                                            )
                                                                .then((result) {
                                                              if (result !=
                                                                      null &&
                                                                  result.files
                                                                      .isNotEmpty) {
                                                                setState(() {
                                                                  selectedImage =
                                                                      result
                                                                          .files
                                                                          .first;
                                                                });

                                                                List<int>
                                                                    imageBytes =
                                                                    selectedImage!
                                                                        .bytes!;

                                                                String
                                                                    base64Image =
                                                                    base64Encode(
                                                                        imageBytes);

                                                                AllEmployeesBloc
                                                                        .get(
                                                                            context)
                                                                    .add(
                                                                  AddNewEmployee(
                                                                    companyName:
                                                                        companyNameRepo,
                                                                    personName:
                                                                        state
                                                                            .personName,
                                                                    userId: state
                                                                        .userId,
                                                                    email: state
                                                                        .email,
                                                                    phoneNum: state
                                                                        .phoneNum,
                                                                    image:
                                                                        base64Image,
                                                                  ),
                                                                );
                                                              }
                                                            });
                                                          } catch (e) {
                                                            debugPrint(
                                                                "Error picking file: $e");
                                                          }
                                                        },
                                                        child: const Text(
                                                          'Upload Image',
                                                          style: TextStyle(
                                                              color: AppColors
                                                                  .black),
                                                        ),
                                                      ),

                                                      const SizedBox(
                                                          height: 24),
                                                      //////////////////////////////////////

                                                      // BlocProvider(
                                                      //   create: (context) =>
                                                      //       RadioButtonBloc(),
                                                      //   child: BlocBuilder<
                                                      //       RadioButtonBloc,
                                                      //       RadioButtonState>(
                                                      //     builder: (context,
                                                      //         state) {
                                                      //       return
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(16.0),
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
                                                                Text(
                                                                  'BlackListed:',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w900,
                                                                      color: AppColors
                                                                          .white,
                                                                      fontSize:
                                                                          20.0),
                                                                ),
                                                                Icon(
                                                                  Icons
                                                                      .warning_amber_outlined,
                                                                  color: Colors
                                                                      .red,
                                                                  size: 35,
                                                                )
                                                              ],
                                                            ),
                                                            RadioListTile(
                                                              activeColor:
                                                                  Colors.white,
                                                              title: const Text(
                                                                  'True',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white)),
                                                              value: 'True',
                                                              groupValue: state
                                                                  .selectedOption,
                                                              onChanged:
                                                                  (value) {
                                                                context.read<AllEmployeesBloc>().add(RadioButtonChanged(
                                                                    selectedOption:
                                                                        value
                                                                            .toString(),
                                                                    showTextField:
                                                                        false));
                                                              },
                                                            ),
                                                            RadioListTile(
                                                              activeColor:
                                                                  Colors.white,
                                                              title: const Text(
                                                                  'False',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white)),
                                                              value: 'False',
                                                              groupValue: state
                                                                  .selectedOption,
                                                              onChanged:
                                                                  (value) {
                                                                context
                                                                    .read<
                                                                        AllEmployeesBloc>()
                                                                    .add(RadioButtonChanged(
                                                                        selectedOption:
                                                                            value
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
                                                                isEnabled: true,
                                                                isRequired:
                                                                    false,
                                                                filled: true,
                                                                // selectedItem:
                                                                //     null,
                                                                titleName:
                                                                    "Room Access Management",
                                                                onChanged:
                                                                    (value) {
                                                                  AllEmployeesBloc
                                                                          .get(
                                                                              context)
                                                                      .add(checkBox(
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
                                                      Navigator.of(context)
                                                          .pop(); // Close the dialog
                                                    },
                                                    child: const Text(
                                                      'Cancel',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      AllEmployeesBloc.get(
                                                              context)
                                                          .add(
                                                              const AddNewEmployeeEvent());

                                                      AllEmployeesBloc.get(
                                                              context)
                                                          .add(
                                                              const GetEmployeeNamesEvent());
                                                      employeeNameController
                                                          .clear();
                                                      setState(() {
                                                        selectedImage = null;
                                                      });

                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text(
                                                      'Save',
                                                      style: TextStyle(
                                                          color:
                                                              AppColors.black),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        );
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
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                // Display the pagination controls
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 15.0),
                                  child: CustomPagination(
                                    // persons: state
                                    //     .employeeNamesList, // Pass the list of data
                                    pageCount:
                                        state.pageCount, // Pass the page count
                                    onPageChanged: (int index) async {
                                      // Your logic to update UI or fetch data for the selected page
                                      AllEmployeesBloc.get(context).add(
                                          EditPageNumber(pageIndex: index));
                                    },
                                  ),
                                ),
                                // Display the list of data
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: (state.submission ==
                                          Submission.noDataFound)
                                      ? const Center(
                                          child: Text(
                                          "No data found Yet!",
                                          style: TextStyle(
                                              color: AppColors.blueB,
                                              fontSize: 25,
                                              fontWeight: FontWeight.w600),
                                        ))
                                      : GridView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount:
                                              state.employeeNamesList.length,
                                          gridDelegate: Responsive.isMobile(
                                                  context)
                                              ? const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 1,
                                                  crossAxisSpacing: 45,
                                                  mainAxisSpacing: 45,
                                                  mainAxisExtent: 350,
                                                )
                                              : Responsive.isTablet(context)
                                                  ? const SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 2,
                                                      crossAxisSpacing: 45,
                                                      mainAxisSpacing: 45,
                                                      mainAxisExtent: 350,
                                                    )
                                                  : MediaQuery.of(context)
                                                              .size
                                                              .width <
                                                          1500
                                                      ? SliverGridDelegateWithMaxCrossAxisExtent(
                                                          maxCrossAxisExtent:
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.24,
                                                          crossAxisSpacing: 45,
                                                          mainAxisSpacing: 45,
                                                          mainAxisExtent: 350,
                                                        )
                                                      : SliverGridDelegateWithMaxCrossAxisExtent(
                                                          maxCrossAxisExtent:
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.24,
                                                          crossAxisSpacing: 45,
                                                          mainAxisSpacing: 45,
                                                          mainAxisExtent: 350,
                                                        ),
                                          itemBuilder: (context, index) {
                                            final employee =
                                                state.employeeNamesList[index];
                                            return _contactUi(
                                              message:
                                                  employee.blackListed == 'True'
                                                      ? "Blacklisted person"
                                                      : '',
                                              // Conditional display based on whether the employee is blacklisted
                                              Icoon:
                                                  employee.blackListed == 'True'
                                                      ? const Icon(
                                                          Icons
                                                              .warning_amber_outlined,
                                                          color: Colors.red,
                                                          size: 50,
                                                        )
                                                      : null,
                                              id: employee.sId ?? '',
                                              name: employee.name ?? '',
                                              profession: 'Software Developer',
                                              imagesrc:
                                                  employee.imagePath ?? '',
                                              phoneNum: employee.phone ?? '',
                                              email: employee.email ?? '',
                                              userId: employee.userId ?? '',

                                              onUpdate: () {
                                                _showUpdateDialog(
                                                    context, employee);
                                              },
                                              onDelete: () {
                                                _showDeleteDialog(context,
                                                    employee.name ?? '');
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
              //   create: (context) => AllEmployeesBloc(),
              //   child: BlocBuilder<AllEmployeesBloc, AllEmployeesState>(
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
            color: Colors.white,
            text: name,
            fontSize: 18,
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

  void _showUpdateDialog(BuildContext context, Data employee) {
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
                      AllEmployeesBloc.get(context).add(
                        AdduserId(
                          userId: employee.name!,
                        ),
                      );
                    } else {
                      AllEmployeesBloc.get(context).add(
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
                      AllEmployeesBloc.get(context).add(
                        AdduserId(
                          userId: employee.userId!,
                        ),
                      );
                    } else {
                      AllEmployeesBloc.get(context).add(
                        AdduserId(
                          userId: value,
                        ),
                      );
                    }
                  },
                ),
                FxBox.h24,
                TextFormField(
                  cursorColor: Colors.white,
                  style: const TextStyle(color: Colors.white),
                  initialValue: employee.phone,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  onChanged: (value) async {
                    if (value.isEmpty) {
                      AllEmployeesBloc.get(context).add(
                        AdduserId(
                          userId: employee.phone!,
                        ),
                      );
                    } else {
                      AllEmployeesBloc.get(context).add(
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
                      AllEmployeesBloc.get(context).add(
                        AdduserId(
                          userId: employee.email!,
                        ),
                      );
                    } else {
                      AllEmployeesBloc.get(context).add(
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
                AllEmployeesBloc.get(context).add(
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

  void _addEmployeeDialog(BuildContext context, AllEmployeesState state) {
    showDialog(
      context: context,
      builder: (ctx) {
        return BlocBuilder<AllEmployeesBloc, AllEmployeesState>(
          builder: (context, state) {
            return AlertDialog(
              title: const SizedBox(
                width: 500,
                child: Text(
                  "Add Employee",
                  style: TextStyle(color: AppColors.white),
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildTextFormField(
                      labelText: 'Name',
                      onChanged: (valuee) async {
                        AllEmployeesBloc.get(context).add(
                          AddpersonName(
                            personName: valuee,
                          ),
                        );
                      },
                    ),

                    FxBox.h24,

                    buildTextFormField(
                      labelText: 'UserId',
                      onChanged: (value) async {
                        AllEmployeesBloc.get(context).add(
                          AdduserId(
                            userId: value,
                          ),
                        );
                      },
                    ),

                    FxBox.h24,

                    buildTextFormField(
                      labelText: 'Phone Number',
                      onChanged: (value) async {
                        AllEmployeesBloc.get(context).add(
                          AddphoneNum(
                            phoneNum: value,
                          ),
                        );
                      },
                    ),

                    FxBox.h24,

                    buildTextFormField(
                      labelText: 'Email',
                      onChanged: (value) async {
                        AllEmployeesBloc.get(context).add(
                          Addemail(
                            email: value,
                          ),
                        );
                      },
                    ),

                    FxBox.h24,

                    FxBox.h24,

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                          onPressed: () async {
                            try {
                              await FilePicker.platform
                                  .pickFiles(type: FileType.image)
                                  .then((result) {
                                if (result != null) {
                                  print(result);
                                  AllEmployeesBloc.get(context).add(
                                      imageevent(imageFile: result.files.last));
                                  print(result.files.last);

                                  // This code block should execute after the image file has been picked
                                  List<int> imageBytes =
                                      result.files.first.bytes!;
                                  String base64Image = base64Encode(imageBytes);

                                  AllEmployeesBloc.get(context)
                                      .add(AddNewEmployee(
                                    companyName: companyNameRepo,
                                    personName: state.personName,
                                    userId: state.userId,
                                    email: state.email,
                                    phoneNum: state.phoneNum,
                                    image: base64Image,
                                  ));
                                }
                              });
                            } catch (e) {
                              debugPrint("Error picking file: $e");
                            }
                          },
                          child: const Text(
                            'Upload Image',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),

                        // ElevatedButton(
                        //   onPressed: () async {
                        //     try {
                        //       await FilePicker.platform
                        //           .pickFiles(
                        //         type: FileType.image,
                        //       )
                        //           .then((result) {
                        //         if (result != null) {
                        //           print(result);
                        //           // setState(() {
                        //           //   selectedImage =
                        //           //       result.files
                        //           //           .first;
                        //           // });
                        //           AllEmployeesBloc.get(context).add(
                        //               imageevent(imageFile: result.files.last));
                        //           print(state.imageFile);
                        //           List<int> imageBytes = result.files.first.bytes!;

                        //           String base64Image = base64Encode(imageBytes);

                        //           AllEmployeesBloc.get(context).add(AddNewEmployee(
                        //             companyName: companyNameRepo,
                        //             personName: state.personName,
                        //             userId: state.userId,
                        //             email: state.email,
                        //             phoneNum: state.phoneNum,
                        //             image: base64Image,
                        //           ));
                        //         }
                        //         // return state.imageFile;
                        //       });
                        //     } catch (e) {
                        //       debugPrint("Error picking file: $e");
                        //     }
                        //   },
                        //   child: const Text(
                        //     'Upload Image',
                        //     style: TextStyle(color: Colors.black),
                        //   ),
                        // ),
                      ],
                    ),
                    if (state.imageFile != null)
                      SizedBox(
                          height: 100,
                          child: state.imageFile!.bytes != null
                              ? Image.memory(
                                  state.imageFile!.bytes!,
                                  fit: BoxFit.cover,
                                )
                              : loadingIndicator() // Show circular progress indicator while loading
                          ),
                    const SizedBox(height: 24),
                    //////////////////////////////////////

                    // BlocProvider(
                    //   create: (context) =>
                    //       RadioButtonBloc(),
                    //   child: BlocBuilder<
                    //       RadioButtonBloc,
                    //       RadioButtonState>(
                    //     builder: (context,
                    //         state) {
                    //       return
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // mainAxisSize:
                            //     MainAxisSize
                            //         .min,
                            children: [
                              Text(
                                'BlackListed:',
                                style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.white,
                                    fontSize: 20.0),
                              ),
                              Icon(
                                Icons.warning_amber_outlined,
                                color: Colors.red,
                                size: 35,
                              )
                            ],
                          ),
                          RadioListTile(
                            activeColor: Colors.white,
                            title: const Text('True',
                                style: TextStyle(color: Colors.white)),
                            value: 'True',
                            groupValue: state.selectedOption,
                            onChanged: (value) {
                              context.read<AllEmployeesBloc>().add(
                                  RadioButtonChanged(
                                      selectedOption: value.toString(),
                                      showTextField: false));
                            },
                          ),
                          RadioListTile(
                            activeColor: Colors.white,
                            title: const Text('False',
                                style: TextStyle(color: Colors.white)),
                            value: 'False',
                            groupValue: state.selectedOption,
                            onChanged: (value) {
                              context.read<AllEmployeesBloc>().add(
                                  RadioButtonChanged(
                                      selectedOption: value.toString(),
                                      showTextField: true));
                            },
                          ),
                          FxBox.h24,
                          if (state.showTextField)
                            multiSelectGenericDropdown(
                              showSearch: true,
                              isEnabled: true,
                              isRequired: false,
                              filled: true,
                              // selectedItem:
                              //     null,
                              titleName: "Room Access Management",
                              onChanged: (value) {
                                AllEmployeesBloc.get(context)
                                    .add(checkBox(room_NMs: value!));
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
                    if (state.personName.isEmpty) {
                      FxToast.showErrorToast(
                          context: context, message: "Add person Name");
                      return;
                    }

                    if (state.selectedOption.isEmpty) {
                      FxToast.showErrorToast(
                          context: context,
                          message:
                              "Choose if the person is blacklisted or Not");
                      return;
                    }
                    if (state.userId.isEmpty) {
                      FxToast.showErrorToast(
                          context: context, message: "Add UserId");
                      return;
                    }
                    if (state.email.isEmpty) {
                      FxToast.showErrorToast(
                          context: context, message: "Add Email");
                      return;
                    }
                    if (state.image.isEmpty) {
                      FxToast.showErrorToast(
                          context: context, message: "Add Image");
                      return;
                    }
                    if (state.phoneNum.isEmpty) {
                      FxToast.showErrorToast(
                          context: context, message: "Add Phone Number");
                      return;
                    }

                    if (state.personName == "" &&
                        state.userId == "" &&
                        state.email == "" &&
                        state.image == "" &&
                        state.phoneNum == "") {
                      FxToast.showErrorToast(
                        context: context,
                        message: "Please Fill all the fields ",
                      );
                      return;
                    }
                    AllEmployeesBloc.get(context)
                        .add(const AddNewEmployeeEvent());

                    employeeNameController.clear();
                    setState(() {
                      selectedImage = null;
                    });

                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(color: AppColors.black),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }





}
