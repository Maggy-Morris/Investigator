import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/enum/enum.dart';
import '../../core/loader/loading_indicator.dart';
import '../../core/resources/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/sizedbox.dart';
import '../../core/widgets/textformfield.dart';
import '../../core/widgets/toast/toast.dart';
import '../add_camera/bloc/home_bloc.dart';
import '../all_employees/screens/all_employees.dart';

class ChooseYourCompany extends StatelessWidget {
  const ChooseYourCompany({super.key});
  void saveCompanyName(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('companyName', value);
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController companyNameController = TextEditingController();

    return BlocProvider(
      create: (context) => HomeBloc()..add(const DataEvent()),
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state.submission == Submission.success) {
            companyNameController.clear();
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

              // Stack(
              //   alignment: Alignment.center,
              //   children: [
              //     Image.asset(
              //       "assets/images/bbb.jpeg",
              //       height: MediaQuery.of(context).size.height,
              //       width: MediaQuery.of(context).size.width,
              //       fit: BoxFit.cover,
              //     ),
              child: Stack(alignment: Alignment.center, children: [
                Image.asset(
                  "assets/images/bbb.jpeg",
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
                Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 150, horizontal: 400),
                  color: AppColors.blueB.withOpacity(0.9),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          "Enter Your Company Name".tr(),
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w900),
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
                                        // _commonText("Company Name".tr()),
                                        FxBox.h4,

                                        _listBox(
                                            controller: companyNameController,
                                            hintText: "Company Name".tr(),
                                            onChanged: (value) {
                                              saveCompanyName(value);
                                              print(
                                                  "pppppppppppppppppppppppppppppppppp" +
                                                      value);
                                              HomeBloc.get(context).add(
                                                  AddCompanyName(
                                                      companyName: value));

                                              // HomeBloc.get(context).add(
                                              //   GetEmployeeNames(
                                              //     companyName: value,
                                              //   ),
                                              // );
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
                                                  message:
                                                      "Enter Company Name");
                                              return;
                                            }
                                            HomeBloc.get(context)
                                                .add(const AddCompanyEvent());

                                            // HomeBloc.get(context).add(
                                            //     const GetEmployeeNamesEvent());

                                            Navigator.of(context).push<void>(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const AllEmployeesScreen(
                                                        // data: state
                                                        //     .employeeNamesList

                                                        ),
                                              ),
                                              // AllEmployeesScreen.route()
                                            );
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
                                          )),
                                    ),
                              // BlocBuilder<HomeBloc, HomeState>(
                              //   builder: (context, state) {
                              //     return
                              // Padding(
                              //       padding: const EdgeInsets.all(10.0),
                              //       child: SingleChildScrollView(
                              //         child: Column(
                              //           children: [
                              //             SizedBox(
                              //               width:
                              //                   MediaQuery.of(context).size.width,
                              //               child: GridView.builder(
                              //                 shrinkWrap: true,
                              //                 physics:
                              //                     const NeverScrollableScrollPhysics(),
                              //                 itemCount:
                              //                     state.employeeNamesList.length,
                              //                 gridDelegate: Responsive.isMobile(
                              //                         context)
                              //                     ? const SliverGridDelegateWithFixedCrossAxisCount(
                              //                         crossAxisCount: 1,
                              //                         crossAxisSpacing: 45,
                              //                         mainAxisSpacing: 45,
                              //                         mainAxisExtent: 350,
                              //                       )
                              //                     : Responsive.isTablet(context)
                              //                         ? const SliverGridDelegateWithFixedCrossAxisCount(
                              //                             crossAxisCount: 2,
                              //                             crossAxisSpacing: 45,
                              //                             mainAxisSpacing: 45,
                              //                             mainAxisExtent: 350,
                              //                           )
                              //                         : MediaQuery.of(context)
                              //                                     .size
                              //                                     .width <
                              //                                 1500
                              //                             ? SliverGridDelegateWithMaxCrossAxisExtent(
                              //                                 maxCrossAxisExtent:
                              //                                     MediaQuery.of(
                              //                                                 context)
                              //                                             .size
                              //                                             .width *
                              //                                         0.24,
                              //                                 crossAxisSpacing:
                              //                                     45,
                              //                                 mainAxisSpacing: 45,
                              //                                 mainAxisExtent: 350,
                              //                               )
                              //                             : SliverGridDelegateWithMaxCrossAxisExtent(
                              //                                 maxCrossAxisExtent:
                              //                                     MediaQuery.of(
                              //                                                 context)
                              //                                             .size
                              //                                             .width *
                              //                                         0.24,
                              //                                 crossAxisSpacing:
                              //                                     45,
                              //                                 mainAxisSpacing: 45,
                              //                                 mainAxisExtent: 350,
                              //                               ),
                              //                 itemBuilder: (context, index) {
                              //                   final employee = state
                              //                       .employeeNamesList[index];

                              //                   return _contactUi(
                              //                     name: employee.name ?? '',
                              //                     profession: employee.sId ?? '',
                              //                   );
                              //                 },
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //     );
                              //   },
                              // ),
                            ],
                          ),
                        if (!Responsive.isWeb(context))
                          Column(
                            children: [
                              // _commonText("Company Name".tr()),
                              FxBox.h4,
                              _listBox(
                                  hintText: "Company Name".tr(),
                                  controller: companyNameController,
                                  onChanged: (value) {
                                    HomeBloc.get(context).add(
                                        AddCompanyName(companyName: value));
                                    // HomeBloc.get(context).add(
                                    //   GetEmployeeNames(companyName: value),
                                    // );
                                  }),
                              FxBox.h60,
                              (state.submission == Submission.loading)
                                  ? loadingIndicator()
                                  : Center(
                                      child: ElevatedButton.icon(
                                          onPressed: () {
                                            HomeBloc.get(context)
                                                .add(const AddCompanyEvent());
                                            // HomeBloc.get(context).add(
                                            //     const GetEmployeeNamesEvent());
                                            Navigator.of(context).push<void>(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const AllEmployeesScreen(),
                                              ),
                                            );
                                            // Navigator.pushNamedAndRemoveUntil(
                                            //     context, "/home", (route) => false);
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
                                          )),
                                    ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ]),
            );
          },
        ),
      ),
    );
  }

  // Widget _contactUi({
  //   required String name,
  //   required String profession,
  // }) {
  //   return Container(
  //     width: 300,
  //     padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
  //     decoration: BoxDecoration(
  //         color:
  //             // context.isDarkMode ?
  //             Color.fromARGB(255, 143, 188, 211),
  //         // : ColorConst.white,
  //         borderRadius: BorderRadius.circular(12.0)),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Container(
  //               height: 70,
  //               width: 70,
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.circular(6.0),
  //               ),
  //               child: ClipRRect(
  //                 borderRadius: BorderRadius.circular(6.0),
  //                 child: Image.asset(
  //                   'assets/images/logo.png',
  //                   // Images.profileImage,
  //                   fit: BoxFit.cover,
  //                 ),
  //               ),
  //             ),
  //             PopupMenuButton<String>(
  //               icon: Icon(Icons.more_horiz, color: Colors.black),
  //               onSelected: (String choice) {
  //                 if (choice == 'Edit') {
  //                   // Handle edit action
  //                 } else if (choice == 'Delete') {
  //                   // Handle delete action
  //                 }
  //               },
  //               itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
  //                 const PopupMenuItem<String>(
  //                   value: 'Edit',
  //                   child: Text('Edit'),
  //                 ),
  //                 const PopupMenuItem<String>(
  //                   value: 'Delete',
  //                   child: Text('Delete'),
  //                 ),
  //               ],
  //             )
  //           ],
  //         ),
  //         FxBox.h24,
  //         ConstText.lightText(
  //           text: name,
  //           fontSize: 18,
  //           fontWeight: FontWeight.w700,
  //         ),
  //         FxBox.h8,
  //         ConstText.lightText(
  //           text: profession,
  //           fontSize: 14,
  //           color: Colors.black,
  //           fontWeight: FontWeight.w400,
  //         ),
  //         FxBox.h24,
  //         _iconWithText(
  //             icon: Icon(Icons.badge_outlined), text: 'Peterdraw Studio'),
  //         FxBox.h28,
  //         _iconWithText(icon: Icon(Icons.contact_phone), text: '+123 456 789'),
  //         FxBox.h28,
  //         _iconWithText(icon: Icon(Icons.email), text: 'email@mail.com'),
  //         // FxBox.h24,
  //       ],
  //     ),
  //   );
  // }

  // Widget _iconWithText({
  //   required Icon icon,
  //   required String text,
  // }) {
  //   return Row(
  //     children: [
  //       icon,
  //       FxBox.w16,
  //       ConstText.lightText(
  //         text: text,
  //         fontSize: 14,
  //         fontWeight: FontWeight.w400,
  //       ),
  //     ],
  //   );
  // }

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
}
