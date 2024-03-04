import 'dart:convert';
import 'dart:io';

import 'package:Investigator/core/models/employee_model.dart';
import 'package:Investigator/core/resources/app_colors.dart';
import 'package:Investigator/presentation/all_employees/screens/text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Investigator/core/utils/responsive.dart';
import 'package:Investigator/core/widgets/badge_builder.dart';
import 'package:Investigator/core/widgets/sizedbox.dart';
import 'package:Investigator/presentation/standard_layout/screens/standard_layout.dart';
import 'package:path_provider/path_provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../add_camera/bloc/home_bloc.dart';
import '../bloc/camera_bloc.dart';

class AllEmployeesScreen extends StatefulWidget {
  // final List<Data> data;

  static Route<dynamic> route(List<Data> data) {
    return MaterialPageRoute<dynamic>(
      builder: (_) => AllEmployeesScreen(
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

  Future<String> getCompanyName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('companyName') ??
        ''; // If 'companyName' is not found, return an empty string
  }

  @override
  Widget build(BuildContext context) {
    return StandardLayoutScreen(
      body: BlocProvider(
        create: (context) => HomeBloc()..add(const DataEvent()),
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    FxBox.h24,
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //displaying the CompanyName across the app
                          FutureBuilder<String>(
                            future: getCompanyName(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                // Return a placeholder or loading indicator while waiting for the result
                                return CircularProgressIndicator(); // Example placeholder
                              } else {
                                // Once the future is resolved, display the result
                                return Text(
                                  "All Employees ${snapshot.data}".tr(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }
                            },
                          ),
                          // Text("All Employees ${getCompanyName()}".tr(),
                          //     style: const TextStyle(
                          //         fontSize: 20, fontWeight: FontWeight.bold)),

                          // Add Employee Button

                          BlocBuilder<HomeBloc, HomeState>(
                              builder: (context, state) {
                            return MaterialButton(
                              height: 50,
                              minWidth: 210,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              color: Color.fromARGB(255, 143, 188, 211),
                              onPressed: () {
                                // Show dialog to fill in employee data

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Add Employee"),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextFormField(
                                            controller: employeeNameController,
                                            decoration: InputDecoration(
                                                labelText: 'Name'),
                                            onChanged: (value) {
                                              // HomeBloc.get(context).add(
                                              // AddNewEmployee(
                                              //   companyName: 'maggy',
                                              //   personName: "mm",
                                              //   files: selectedImage,
                                              // ),
                                              // );
                                            },
                                          ),
                                          FxBox.h24,
                                          if (selectedImage != null &&
                                              selectedImage!.bytes != null)
                                            SizedBox(
                                              height: 100,
                                              child: Image.memory(
                                                selectedImage!.bytes!,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          FxBox.h24,

                                          ///pick and encode the image

                                          ElevatedButton(
                                            onPressed: () async {
                                              try {
                                                FilePickerResult? result =
                                                    await FilePicker.platform
                                                        .pickFiles(
                                                  type: FileType.image,
                                                );
                                                if (result != null &&
                                                    result.files.isNotEmpty) {
                                                  selectedImage =
                                                      result.files.first;
                                                  List<int> imageBytes =
                                                      selectedImage!.bytes!;
                                                  String base64Image =
                                                      base64Encode(imageBytes);
                                                  HomeBloc.get(context).add(
                                                    AddNewEmployee(
                                                      companyName: "maggy",
                                                      personName: 'mm',
                                                      image: base64Image,
                                                      // files: selectedImage,
                                                    ),
                                                  );
                                                }
                                              } catch (e) {
                                                print("Error picking file: $e");
                                              }
                                            },
                                            child: Text('Upload Image'),
                                          ),

                                          // ElevatedButton(
                                          //   onPressed: () async {
                                          //     try {
                                          //       FilePickerResult? result =
                                          //           await FilePicker.platform
                                          //               .pickFiles(
                                          //         type: FileType.image,
                                          //       );
                                          //       if (result != null &&
                                          //           result.files.isNotEmpty) {
                                          //         selectedImage =
                                          //             result.files.first;

                                          //         HomeBloc.get(context).add(
                                          //           AddNewEmployee(
                                          //             companyName: "maggy",
                                          //             personName: 'mm',
                                          //             image: selectedImage!
                                          //                 .bytes
                                          //                 .toString(),
                                          //             files: selectedImage,
                                          //           ),
                                          //         );
                                          //       }
                                          //     } catch (e) {
                                          //       print("Error picking file: $e");
                                          //     }
                                          //   },
                                          //   child: Text('Upload Image'),
                                          // ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                          },
                                          child: Text('Cancel'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            HomeBloc.get(context)
                                                .add(AddNewEmployeeEvent());

                                            // Add logic to save employee data
                                            // Navigator.of(context)
                                            //     .pop(); // Close the dialog
                                          },
                                          child: Text('Save'),
                                        ),
                                      ],
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
                          })
                        ],
                      ),
                    ),
                    FxBox.h24,

                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.employeeNamesList.length,
                        // widget.data.length,
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
                                : MediaQuery.of(context).size.width < 1500
                                    ? SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent:
                                            MediaQuery.of(context).size.width *
                                                0.24,
                                        crossAxisSpacing: 45,
                                        mainAxisSpacing: 45,
                                        mainAxisExtent: 350,
                                      )
                                    : SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent:
                                            MediaQuery.of(context).size.width *
                                                0.24,
                                        crossAxisSpacing: 45,
                                        mainAxisSpacing: 45,
                                        mainAxisExtent: 350,
                                      ),
                        itemBuilder: (context, index) {
                          final employee = state.employeeNamesList;
                          // print("KKKKKKKKKKKKKKK" +
                          //         widget.data.length.toString() ??
                          //     '');
                          return _contactUi(
                            name: employee[index].name ?? '',
                            profession: employee[index].sId ?? '',
                            onDelete: () {
                              context.read<HomeBloc>().add(
                                    DeletePersonByNameEvent(
                                      getCompanyName() as String,
                                      employee[index].name ?? '',
                                    ),
                                  );
                            },
                          );
                        },
                      ),
                    ),

                    // Wrap(
                    //     children: _responsiveCardList(
                    //         context: context, cameras: dummyEmployees)),
                  ],
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
          color:
              // context.isDarkMode ?
              Color.fromARGB(255, 143, 188, 211),
          // : ColorConst.white,
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
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  return PopupMenuButton<String>(
                    icon: Icon(Icons.more_horiz, color: Colors.black),
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

                                      // Navigator.of(ctx)
                                      //     .pop();
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
              icon: Icon(Icons.badge_outlined), text: 'Peterdraw Studio'),
          FxBox.h28,
          _iconWithText(icon: Icon(Icons.contact_phone), text: '+123 456 789'),
          FxBox.h28,
          _iconWithText(icon: Icon(Icons.email), text: 'email@mail.com'),
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
