import 'dart:convert';

import 'package:Investigator/core/loader/loading_indicator.dart';
import 'package:Investigator/core/models/employee_model.dart';
import 'package:Investigator/core/remote_provider/remote_data_source.dart';
import 'package:Investigator/core/resources/app_colors.dart';
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
import '../../../core/widgets/persons_per_widget.dart';
import '../../../core/widgets/toast/toast.dart';
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
      AuthenticationRepository.instance.currentUser.companyName ?? "";

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
              FxToast.showSuccessToast(context: context);
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
                              children: [
                                ///search field
                                Form(
                                  child: SizedBox(
                                    height: 40,
                                    width: 300,
                                    child: TextFormField(
                                      controller: _searchController,
                                      decoration: InputDecoration(
                                        labelText: 'Search For Employee'.tr(),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        fillColor: Colors
                                            .white, // Set the fill color to white
                                        filled: true, //

                                        ///search Toggle
                                        suffixIcon: IconButton(
                                          icon: state.isSearching
                                              ? Icon(Icons.close)
                                              : Icon(Icons.search),
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
                                                  const GetEmployeeNamesEvent());
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
                                    borderRadius: BorderRadius.circular(25.0),
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
                                                title: const Text(
                                                  "Add Employee",
                                                  // style: TextStyle(
                                                  //     color: AppColors.white),
                                                ),
                                                content: SingleChildScrollView(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      TextFormField(
                                                        // controller:
                                                        //     employeeNameController,
                                                        decoration:
                                                            const InputDecoration(
                                                                labelText:
                                                                    'Name'),
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
                                                      TextFormField(
                                                        // controller:
                                                        //     employeeNameController,
                                                        decoration:
                                                            const InputDecoration(
                                                                labelText:
                                                                    'UserId'),
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
                                                      TextFormField(
                                                        // controller:
                                                        //     employeeNameController,
                                                        decoration:
                                                            const InputDecoration(
                                                                labelText:
                                                                    'Phone Number'),
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
                                                      TextFormField(
                                                        // controller:
                                                        //     employeeNameController,
                                                        decoration:
                                                            const InputDecoration(
                                                                labelText:
                                                                    'Email'),
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
                                                      if (selectedImage != null)
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
                                                                  personName: state
                                                                      .personName,
                                                                  userId: state
                                                                      .userId,
                                                                  email: state
                                                                      .email,
                                                                  phoneNum: state
                                                                      .phoneNum,
                                                                  image:
                                                                      base64Image,
                                                                ));
                                                              }
                                                              return null;
                                                            });
                                                          } catch (e) {
                                                            debugPrint(
                                                                "Error picking file: $e");
                                                          }
                                                        },
                                                        child: const Text(
                                                          'Upload Image',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
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
                              ],
                            ),
                          ),
                        if (!Responsive.isWeb(context))
                          SizedBox(
                            width: double.infinity,
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Add Employee Button

                                Form(
                                  child: SizedBox(
                                    height: 40,
                                    width: 300,
                                    child: TextFormField(
                                      controller: _searchController,
                                      decoration: InputDecoration(
                                        labelText: 'Search For Employee'.tr(),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        suffixIcon: IconButton(
                                          icon: const Icon(Icons.search),
                                          onPressed: () {
                                            AllEmployeesBloc.get(context).add(
                                              GetPersonByNameEvent(
                                                companyName: companyNameRepo,
                                                personName:
                                                    _searchController.text,
                                              ),
                                            );
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
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  color: AppColors.blueB,
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
                                                      TextFormField(
                                                        // controller:
                                                        //     employeeNameController,
                                                        decoration:
                                                            const InputDecoration(
                                                                labelText:
                                                                    'Name'),
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
                                                      TextFormField(
                                                        // controller:
                                                        //     employeeNameController,
                                                        decoration:
                                                            const InputDecoration(
                                                                labelText:
                                                                    'UserId'),
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
                                                      TextFormField(
                                                        // controller:
                                                        //     employeeNameController,
                                                        decoration:
                                                            const InputDecoration(
                                                                labelText:
                                                                    'Phone Number'),
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
                                                      TextFormField(
                                                        // controller:
                                                        //     employeeNameController,
                                                        decoration:
                                                            const InputDecoration(
                                                                labelText:
                                                                    'Email'),
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
                                                      // employeeNameController
                                                      //     .clear();
                                                      // setState(() {
                                                      //   selectedImage = null;
                                                      // });

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

                        ///show the employees data
                        // BlocBuilder<AllEmployeesBloc, AllEmployeesState>(
                        //   builder: (context, state) {
                        //     return
                        // return BlocBuilder<AllEmployeesBloc,
                        //     AllEmployeesState>(
                        //   builder: (context, state) {
                        //     var hits = state.employeeNamesList;
                        //
                        //     if (hits.isNotEmpty) {
                        //       return Container(
                        //         padding: const EdgeInsets.only(
                        //             right: 10, bottom: 30),
                        //         child: SfDataPagerTheme(
                        //           data: SfDataPagerThemeData(
                        //             itemColor: Colors.white,
                        //             selectedItemColor:
                        //             AppColors.thinkRedColor,
                        //             itemBorderRadius:
                        //             BorderRadius.circular(15),
                        //           ),
                        //           child: SfDataPager(
                        //               controller: DataPagerController(),
                        //               lastPageItemVisible: false,
                        //               pageCount: (((state.count) / state.take)
                        //                   .ceil())
                        //                   .toDouble(),
                        //               direction: Axis.horizontal,
                        //               visibleItemsCount:
                        //               isDisplayDesktop(context) ? 15 : 5,
                        //               onPageNavigationStart:
                        //                   (int pageIndex) async {
                        //                 PeopleBloc.get(context).add(EditPageNumber(pageIndex));
                        //               },
                        //               // availableRowsPerPage: const [
                        //               //   100,
                        //               //   500,
                        //               //   1000,
                        //               //   2000,
                        //               //   5000,
                        //               //   9000,
                        //               // ],
                        //               // onRowsPerPageChanged:
                        //               //     (int? rowsPerPage) async {
                        //               //   ThinkMainScreenPlusCubit.get(context)
                        //               //       .onEditTake(rowsPerPage ?? 100);
                        //               // },
                        //               delegate: DataPagerDelegate(),
                        //               onPageNavigationEnd:
                        //                   (int pageIndex) async {}),
                        //         ),
                        //       );
                        //     } else {
                        //       return Container();
                        //     }
                        //   },
                        // );
                        // personsPager(
                        //     persons: state.employeeNamesList,
                        //     totalSize: state.count,
                        //     context: context),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
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
                                          //         .length <
                                          //     20
                                          // ? state.employeeNamesList.length
                                          // : 20,
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
                                            );
                                          },
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        //   },
                        // ),
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6.0),
                  child: Image.network(
                    "http:${RemoteDataSource.baseUrlWithoutPort}8000/$imagesrc",
                    // Images.profileImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              BlocProvider(
                create: (context) => AllEmployeesBloc(),
                child: BlocBuilder<AllEmployeesBloc, AllEmployeesState>(
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
            fontWeight: FontWeight.w700,
          ),
          FxBox.h8,
          ConstText.lightText(
            text: userId,
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
          FxBox.h24,
          _iconWithText(
              icon: const Icon(Icons.badge_outlined), text: profession),
          FxBox.h28,
          _iconWithText(icon: const Icon(Icons.contact_phone), text: phoneNum),
          FxBox.h28,
          _iconWithText(icon: const Icon(Icons.email), text: email),
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

  void _showUpdateDialog(BuildContext context, Data employee) {
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
}
