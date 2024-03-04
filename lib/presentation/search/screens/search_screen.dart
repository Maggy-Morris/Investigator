import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Investigator/core/resources/app_colors.dart';
import 'package:Investigator/core/utils/responsive.dart';
// import 'package:Investigator/core/widgets/drop_down_widgets.dart';
import 'package:Investigator/core/widgets/sizedbox.dart';
import 'package:Investigator/core/widgets/toast/toast.dart';
import 'package:Investigator/presentation/add_camera/bloc/home_bloc.dart';
import 'package:Investigator/presentation/standard_layout/screens/standard_layout.dart';

import '../../../core/enum/enum.dart';
import '../../../core/loader/loading_indicator.dart';
import '../../../core/widgets/textformfield.dart';
import '../../all_employees/screens/text.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController companyNameController = TextEditingController();
  TextEditingController employeeNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StandardLayoutScreen(
      body: BlocProvider(
        create: (context) => HomeBloc()..add(const DataEvent()),
        child: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state.submission == Submission.success) {
              companyNameController.clear();
              employeeNameController.clear();
              FxToast.showSuccessToast(context: context);
            }
            if (state.submission == Submission.error) {
              FxToast.showErrorToast(context: context);
            }
          },
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              return SingleChildScrollView(
                // physics: NeverScrollableScrollPhysics(),
                child: Card(
                  margin: const EdgeInsets.all(20),
                  color: AppColors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          "Search For Company".tr(),
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w600),
                        ),
                        FxBox.h24,
                        if (Responsive.isWeb(context))
                          Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _commonText("Company Name".tr()),
                                        FxBox.h4,
                                        _listBox(
                                            controller: companyNameController,
                                            hintText: "Search Company".tr(),
                                            onChanged: (value) {
                                              HomeBloc.get(context).add(
                                                GetEmployeeNames(
                                                  companyName: value,
                                                ),
                                              );
                                            }),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              FxBox.h60,
                              (state.submission == Submission.loading)
                                  ? loadingIndicator()
                                  : Center(
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          if (state.companyName.isEmpty) {
                                            FxToast.showErrorToast(
                                                context: context,
                                                message: "Add Company Name");
                                            return;
                                          }

                                          HomeBloc.get(context).add(
                                              const GetEmployeeNamesEvent());
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          backgroundColor: AppColors.green,
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
                              // search for employees
                              // Row(
                              //   children: [
                              //     Expanded(
                              //       child: Column(
                              //         crossAxisAlignment:
                              //             CrossAxisAlignment.start,
                              //         children: [
                              //           _commonText("Employee Name".tr()),
                              //           FxBox.h4,
                              //           _listBox(
                              //             controller: employeeNameController,
                              //             hintText: "Search Employee".tr(),
                              //             onChanged: (value) {
                              //               HomeBloc.get(context).add(
                              //                 GetPersonByName(
                              //                   companyName: state.companyName,
                              //                   personName: value,
                              //                 ),
                              //               );
                              //             },
                              //           ),
                              //         ],
                              //       ),
                              //     ),
                              //   ],
                              // ),

                              // FxBox.h60,
                              // (state.submission == Submission.loading)
                              //     ? loadingIndicator()
                              //     : Center(
                              //         child: ElevatedButton.icon(
                              //           onPressed: () {
                              //             if (state.companyName.isEmpty) {
                              //               FxToast.showErrorToast(
                              //                   context: context,
                              //                   message: "Add Employee Name");
                              //               return;
                              //             }

                              //             HomeBloc.get(context).add(
                              //                 const GetPersonByNameEvent());
                              //           },
                              //           style: ElevatedButton.styleFrom(
                              //             shape: RoundedRectangleBorder(
                              //                 borderRadius:
                              //                     BorderRadius.circular(10)),
                              //             backgroundColor: AppColors.green,
                              //           ),
                              //           label: Text(
                              //             "confirm".tr(),
                              //             style: const TextStyle(
                              //                 color: AppColors.white),
                              //           ),
                              //           icon: const Icon(
                              //             Icons.check_circle_outline,
                              //             color: AppColors.white,
                              //           ),
                              //         ),
                              //       ),

                              /////////////////////////////////////////////////
                              // BlocBuilder<HomeBloc, HomeState>(
                              //   builder: (context, state) {
                              // return
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      // FxBox.h24,
                                      // SizedBox(
                                      //   width: double.infinity,
                                      //   child: Row(
                                      //     mainAxisAlignment:
                                      //         MainAxisAlignment
                                      //             .spaceBetween,
                                      //     children: [
                                      //       Text("All Employees".tr(),
                                      //           style: const TextStyle(
                                      //               fontSize: 20,
                                      //               fontWeight:
                                      //                   FontWeight.bold)),

                                      //       // //Add Employee Button
                                      //       // MaterialButton(
                                      //       //   height: 50,
                                      //       //   minWidth: 210,
                                      //       //   shape: RoundedRectangleBorder(
                                      //       //     borderRadius:
                                      //       //         BorderRadius.circular(
                                      //       //             25.0),
                                      //       //   ),
                                      //       //   color: Color.fromARGB(
                                      //       //       255, 143, 188, 211),
                                      //       //   onPressed: () {
                                      //       //     // Show dialog to fill in employee data
                                      //       //     showDialog(
                                      //       //       context: context,
                                      //       //       builder: (BuildContext
                                      //       //           context) {
                                      //       //         return AlertDialog(
                                      //       //           title: Text(
                                      //       //               "Add Employee"),
                                      //       //           content: Column(
                                      //       //             mainAxisSize:
                                      //       //                 MainAxisSize
                                      //       //                     .min,
                                      //       //             children: [
                                      //       //               TextFormField(
                                      //       //                 decoration:
                                      //       //                     InputDecoration(
                                      //       //                         labelText:
                                      //       //                             'Name'),
                                      //       //               ),
                                      //       //               FxBox.h24,
                                      //       //               TextFormField(
                                      //       //                 decoration:
                                      //       //                     InputDecoration(
                                      //       //                         labelText:
                                      //       //                             'Phone Number'),
                                      //       //               ),
                                      //       //               FxBox.h24,

                                      //       //               TextFormField(
                                      //       //                 decoration:
                                      //       //                     InputDecoration(
                                      //       //                         labelText:
                                      //       //                             'Email'),
                                      //       //               ),
                                      //       //               // Add more fields as needed
                                      //       //             ],
                                      //       //           ),
                                      //       //           actions: [
                                      //       //             TextButton(
                                      //       //               onPressed: () {
                                      //       //                 Navigator.of(
                                      //       //                         context)
                                      //       //                     .pop(); // Close the dialog
                                      //       //               },
                                      //       //               child: Text(
                                      //       //                   'Cancel'),
                                      //       //             ),
                                      //       //             ElevatedButton(
                                      //       //               onPressed: () {
                                      //       //                 // Add logic to save employee data
                                      //       //                 Navigator.of(
                                      //       //                         context)
                                      //       //                     .pop(); // Close the dialog
                                      //       //               },
                                      //       //               child:
                                      //       //                   Text('Save'),
                                      //       //             ),
                                      //       //           ],
                                      //       //         );
                                      //       //       },
                                      //       //     );
                                      //       //   },
                                      //       //   child: const Text(
                                      //       //     "Add Employee",
                                      //       //     style: TextStyle(
                                      //       //       fontSize: 16,
                                      //       //       color: Colors.white,
                                      //       //       fontWeight:
                                      //       //           FontWeight.w500,
                                      //       //     ),
                                      //       //   ),
                                      //       // ),
                                      //     ],
                                      //   ),
                                      // ),

                                      // FxBox.h24,
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: GridView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount:
                                              state.employeeNamesList.length < 5
                                                  ? state
                                                      .employeeNamesList.length
                                                  : 5,

                                          // itemCount:
                                          //     state.employeeNamesList.length,
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
                                              name: employee.name ?? '',
                                              profession: employee.sId ?? '',
                                              onDelete: () {
                                                context.read<HomeBloc>().add(
                                                      DeletePersonByNameEvent(
                                                        state.companyName,
                                                        employee.name ?? '',
                                                      ),
                                                    );
                                                Navigator.of(context).pop();
                                              },
                                            );
                                          },
                                        ),
                                      ),

                                      //  SizedBox(
                                      //   width:
                                      //       MediaQuery.of(context).size.width,
                                      //   child: BlocProvider.value(
                                      //     value: BlocProvider.of<HomeBloc>(
                                      //         context),
                                      //     child: GridView.builder(
                                      //       shrinkWrap: true,
                                      //       physics:
                                      //           const NeverScrollableScrollPhysics(),
                                      //       itemCount:
                                      //           BlocProvider.of<HomeBloc>(
                                      //                   context)
                                      //               .state
                                      //               .employeeNamesList
                                      //               .length,
                                      //       gridDelegate: Responsive.isMobile(
                                      //               context)
                                      //           ? const SliverGridDelegateWithFixedCrossAxisCount(
                                      //               crossAxisCount: 1,
                                      //               crossAxisSpacing: 45,
                                      //               mainAxisSpacing: 45,
                                      //               mainAxisExtent: 350,
                                      //             )
                                      //           : Responsive.isTablet(context)
                                      //               ? const SliverGridDelegateWithFixedCrossAxisCount(
                                      //                   crossAxisCount: 2,
                                      //                   crossAxisSpacing: 45,
                                      //                   mainAxisSpacing: 45,
                                      //                   mainAxisExtent: 350,
                                      //                 )
                                      //               : MediaQuery.of(context)
                                      //                           .size
                                      //                           .width <
                                      //                       1500
                                      //                   ? SliverGridDelegateWithMaxCrossAxisExtent(
                                      //                       maxCrossAxisExtent:
                                      //                           MediaQuery.of(
                                      //                                       context)
                                      //                                   .size
                                      //                                   .width *
                                      //                               0.24,
                                      //                       crossAxisSpacing:
                                      //                           45,
                                      //                       mainAxisSpacing: 45,
                                      //                       mainAxisExtent: 350,
                                      //                     )
                                      //                   : SliverGridDelegateWithMaxCrossAxisExtent(
                                      //                       maxCrossAxisExtent:
                                      //                           MediaQuery.of(
                                      //                                       context)
                                      //                                   .size
                                      //                                   .width *
                                      //                               0.24,
                                      //                       crossAxisSpacing:
                                      //                           45,
                                      //                       mainAxisSpacing: 45,
                                      //                       mainAxisExtent: 350,
                                      //                     ),
                                      //       itemBuilder: (context, index) {
                                      //         final employee =
                                      //             BlocProvider.of<HomeBloc>(
                                      //                     context)
                                      //                 .state
                                      //                 .employeeNamesList[index];

                                      //         return _contactUi(
                                      //           name: employee.name ?? '',
                                      //           profession: employee.sId ?? '',
                                      //           onDelete: () {
                                      //             Navigator.of(context).pop();
                                      //           },
                                      //         );
                                      //       },
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              )
                              // ;
                              //   },
                              // ),
                            ],
                          ),
                        if (!Responsive.isWeb(context))
                          Column(
                            children: [
                              _commonText("Company Name".tr()),
                              FxBox.h4,
                              _listBox(
                                  hintText: "Search for Company".tr(),
                                  controller: companyNameController,
                                  onChanged: (value) {
                                    HomeBloc.get(context).add(
                                        GetEmployeeNames(companyName: value));
                                  }),
                              FxBox.h60,
                              (state.submission == Submission.loading)
                                  ? loadingIndicator()
                                  : Center(
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          HomeBloc.get(context).add(
                                              const GetEmployeeNamesEvent());
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          backgroundColor: AppColors.green,
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
              PopupMenuButton<String>(
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

  Widget _listBox({
    required String hintText,
    required void Function(String)? onChanged,
    required TextEditingController? controller,
    bool? enabled,
  }) {
    return CustomTextField(
      border: const OutlineInputBorder(),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      controller: controller,
      filled: true,
      enabled: enabled ?? true,
      fillColor: Colors.grey.shade200,
      enabledBorder:
          OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(style: BorderStyle.none)),
      focusedBorder:
          OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      hintText: hintText,
      onChanged: onChanged,
    );
  }

  Widget _commonText(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: Responsive.isMobile(context) ? 8.0 : 0.0,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
