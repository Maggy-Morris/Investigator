import 'dart:convert';

import 'package:Investigator/core/loader/loading_indicator.dart';
import 'package:Investigator/core/models/employee_model.dart';
import 'package:Investigator/core/resources/app_colors.dart';
import 'package:Investigator/presentation/all_employees/screens/text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Investigator/core/utils/responsive.dart';
import 'package:Investigator/core/widgets/sizedbox.dart';
import 'package:Investigator/presentation/standard_layout/screens/standard_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/all_employess_bloc.dart';

class AllEmployeesScreen extends StatefulWidget {
  static Route<dynamic> route(List<Data> data) {
    return MaterialPageRoute<dynamic>(
      builder: (_) => const AllEmployeesScreen(
          // data: data
          ),
    );
  }

  const AllEmployeesScreen({
    Key? key,
    // required this.data
  }) : super(key: key);

  @override
  State<AllEmployeesScreen> createState() => _AllEmployeesScreenState();
}

class _AllEmployeesScreenState extends State<AllEmployeesScreen> {
  PlatformFile? selectedImage;
  TextEditingController employeeNameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
    });
  }

  @override
  Widget build(BuildContext context) {
    return StandardLayoutScreen(
      body: BlocProvider(
        create: (context) => AllEmployeesBloc()
          ..add(const AddNewEmployeeEvent())
          ..add(const GetEmployeeNamesEvent()),
        child: BlocBuilder<AllEmployeesBloc, AllEmployeesState>(
          builder: (context, state) {
            return Card(
              margin: const EdgeInsets.all(20),
              color: AppColors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        "All Employees ".tr(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      FxBox.h24,
                      if (Responsive.isWeb(context))
                        SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.search),
                                        onPressed: () async {
                                          final SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();

                                          final String? companyName =
                                              prefs.getString('companyName');

                                          AllEmployeesBloc.get(context).add(
                                            GetPersonByNameEvent(
                                              companyName: companyName ?? "",
                                              personName:
                                                  _searchController.text,
                                            ),
                                          );
                                          // AllEmployeesBloc.get(context)
                                          //     .add(const GetPersonByNameEvent());
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // Add Employee Button
                              FxBox.h24,
                              BlocBuilder<AllEmployeesBloc, AllEmployeesState>(
                                  builder: (context, state) {
                                return MaterialButton(
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
                                          child: StatefulBuilder(
                                            builder: (context, setState) {
                                              return AlertDialog(
                                                title:
                                                    const Text("Add Employee"),
                                                content: Column(
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
                                                      onChanged: (value) async {
                                                        state.personName =
                                                            value;
                                                      },
                                                    ),
                                                    const SizedBox(height: 24),
                                                    if (selectedImage != null &&
                                                        selectedImage!.bytes !=
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
                                                    const SizedBox(height: 24),
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        try {
                                                          FilePickerResult?
                                                              result =
                                                              await FilePicker
                                                                  .platform
                                                                  .pickFiles(
                                                            type:
                                                                FileType.image,
                                                          );
                                                          if (result != null &&
                                                              result.files
                                                                  .isNotEmpty) {
                                                            setState(() {
                                                              selectedImage =
                                                                  result.files
                                                                      .first;
                                                            });

                                                            List<int>
                                                                imageBytes =
                                                                selectedImage!
                                                                    .bytes!;

                                                            // String imageName =
                                                            //     selectedImage!.name;

                                                            final SharedPreferences
                                                                prefs =
                                                                await SharedPreferences
                                                                    .getInstance();

                                                            final String?
                                                                companyName =
                                                                prefs.getString(
                                                                    'companyName');

                                                            String base64Image =
                                                                base64Encode(
                                                                    imageBytes);

                                                            AllEmployeesBloc
                                                                    .get(
                                                                        context)
                                                                .add(
                                                              AddNewEmployee(
                                                                companyName:
                                                                    companyName ??
                                                                        "No Company ",
                                                                personName: state
                                                                    .personName,
                                                                image:
                                                                    base64Image,
                                                              ),
                                                            );
                                                          }
                                                        } catch (e) {
                                                          print(
                                                              "Error picking file: $e");
                                                        }
                                                      },
                                                      child: const Text(
                                                          'Upload Image'),
                                                    ),
                                                  ],
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(); // Close the dialog
                                                    },
                                                    child: const Text('Cancel'),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      // context.read<AllEmolyessBloc>().add(
                                                      //     const GetEmployeeNamesEvent());

                                                      AllEmployeesBloc.get(
                                                              context)
                                                          .add(
                                                              const AddNewEmployeeEvent());
                                                      employeeNameController
                                                          .clear();
                                                      setState(() {
                                                        selectedImage = null;
                                                      });
                                                      Navigator.of(context)
                                                          .pop(); // Close the dialog
                                                    },
                                                    child: const Text('Save'),
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
                                );
                              }),
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
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.search),
                                        onPressed: () async {
                                          final SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();

                                          final String? companyName =
                                              prefs.getString('companyName');

                                          AllEmployeesBloc.get(context).add(
                                            GetPersonByNameEvent(
                                              companyName: companyName ?? "",
                                              personName:
                                                  _searchController.text,
                                            ),
                                          );
                                          // AllEmployeesBloc.get(context)
                                          //     .add(const GetPersonByNameEvent());
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // Add Employee Button
                              FxBox.h24,
                              BlocBuilder<AllEmployeesBloc, AllEmployeesState>(
                                  builder: (context, state) {
                                return MaterialButton(
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
                                          child: StatefulBuilder(
                                            builder: (context, setState) {
                                              return AlertDialog(
                                                title:
                                                    const Text("Add Employee"),
                                                content: Column(
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
                                                      onChanged: (value) async {
                                                        state.personName =
                                                            value;
                                                      },
                                                    ),
                                                    const SizedBox(height: 24),
                                                    if (selectedImage != null &&
                                                        selectedImage!.bytes !=
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
                                                    const SizedBox(height: 24),
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        try {
                                                          FilePickerResult?
                                                              result =
                                                              await FilePicker
                                                                  .platform
                                                                  .pickFiles(
                                                            type:
                                                                FileType.image,
                                                          );
                                                          if (result != null &&
                                                              result.files
                                                                  .isNotEmpty) {
                                                            setState(() {
                                                              selectedImage =
                                                                  result.files
                                                                      .first;
                                                            });

                                                            List<int>
                                                                imageBytes =
                                                                selectedImage!
                                                                    .bytes!;

                                                            // String imageName =
                                                            //     selectedImage!.name;

                                                            final SharedPreferences
                                                                prefs =
                                                                await SharedPreferences
                                                                    .getInstance();

                                                            final String?
                                                                companyName =
                                                                prefs.getString(
                                                                    'companyName');

                                                            String base64Image =
                                                                base64Encode(
                                                                    imageBytes);

                                                            AllEmployeesBloc
                                                                    .get(
                                                                        context)
                                                                .add(
                                                              AddNewEmployee(
                                                                companyName:
                                                                    companyName ??
                                                                        "No Company ",
                                                                personName: state
                                                                    .personName,
                                                                image:
                                                                    base64Image,
                                                              ),
                                                            );
                                                          }
                                                        } catch (e) {
                                                          print(
                                                              "Error picking file: $e");
                                                        }
                                                      },
                                                      child: const Text(
                                                          'Upload Image'),
                                                    ),
                                                  ],
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(); // Close the dialog
                                                    },
                                                    child: const Text('Cancel'),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      // context.read<AllEmolyessBloc>().add(
                                                      //     const GetEmployeeNamesEvent());

                                                      AllEmployeesBloc.get(
                                                              context)
                                                          .add(
                                                              const AddNewEmployeeEvent());
                                                      employeeNameController
                                                          .clear();
                                                      setState(() {
                                                        selectedImage = null;
                                                      });
                                                      Navigator.of(context)
                                                          .pop(); // Close the dialog
                                                    },
                                                    child: const Text('Save'),
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
                                );
                              }),
                            ],
                          ),
                        ),
                      FxBox.h24,
                      BlocBuilder<AllEmployeesBloc, AllEmployeesState>(
                        builder: (context, state) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount:
                                          state.employeeNamesList.length < 5
                                              ? state.employeeNamesList.length
                                              : 5,
                                      gridDelegate: Responsive.isMobile(context)
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
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.24,
                                                      crossAxisSpacing: 45,
                                                      mainAxisSpacing: 45,
                                                      mainAxisExtent: 350,
                                                    )
                                                  : SliverGridDelegateWithMaxCrossAxisExtent(
                                                      maxCrossAxisExtent:
                                                          MediaQuery.of(context)
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
                                          // context: context,
                                          name: employee.name ?? '',
                                          profession: employee.sId ?? '',
                                          onDelete: () async {
                                            final SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();

                                            final String? companyName =
                                                prefs.getString('companyName');
                                            context
                                                .read<AllEmployeesBloc>()
                                                .add(
                                                  DeletePersonByNameEvent(
                                                    companyName ?? '',
                                                    employee.name ?? '',
                                                  ),
                                                );
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
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _contactUi({
    required String name,
    required String profession,
    required VoidCallback onDelete,
  }) {
    return Container(
      width: 300,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
      decoration: BoxDecoration(
          color: AppColors.babyBlue,
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
                  child: Image.asset(
                    'assets/images/logo.png',
                    // Images.profileImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              BlocBuilder<AllEmployeesBloc, AllEmployeesState>(
                builder: (context, state) {
                  return PopupMenuButton<String>(
                    icon: const Icon(Icons.more_horiz, color: Colors.black),
                    onSelected: (String choice) {
                      if (choice == 'Edit') {
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
                                    onPressed: () async {
                                      onDelete();

                                      Navigator.of(ctx).pop();
                                      // await logout(
                                      //     context);
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
              )
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
            text: profession,
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
          FxBox.h24,
          _iconWithText(
              icon: const Icon(Icons.badge_outlined), text: 'Peterdraw Studio'),
          FxBox.h28,
          _iconWithText(
              icon: const Icon(Icons.contact_phone), text: '+123 456 789'),
          FxBox.h28,
          _iconWithText(icon: const Icon(Icons.email), text: 'email@mail.com'),
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
}
