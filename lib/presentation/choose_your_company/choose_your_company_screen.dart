import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../authentication/authentication_repository.dart';
import '../../core/enum/enum.dart';
import '../../core/loader/loading_indicator.dart';
import '../../core/resources/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/sizedbox.dart';
import '../../core/widgets/textformfield.dart';
import '../../core/widgets/toast/toast.dart';
import '../all_employees/screens/all_employees.dart';
import '../investigator/bloc/home_bloc.dart';

class ChooseYourCompany extends StatelessWidget {
  const ChooseYourCompany({super.key});
  void saveCompanyName(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('companyName', value);
  }

  Future<String> getCompanyName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('companyName') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    String companyNameRepo =
        AuthenticationRepository.instance.currentUser.companyName ?? "";
    TextEditingController companyNameController = TextEditingController();

    return BlocProvider(
      create: (context) => HomeBloc()

      // ..add(const DataEvent())

      ,
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
              child: Stack(alignment: Alignment.center, children: [
                // Image.asset(
                //   "assets/images/bbb.jpeg",
                //   height: MediaQuery.of(context).size.height,
                //   width: MediaQuery.of(context).size.width,
                //   fit: BoxFit.cover,
                // ),
                Column(
                  children: [
                    // Additional Cards Here
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push<void>(
                          MaterialPageRoute(
                            builder: (context) => const AllEmployeesScreen(
                                // data: state
                                //     .employeeNamesList

                                ),
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        color: AppColors.blueB.withOpacity(0.9),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: const BorderSide(
                              color: Colors.white, width: 2), // Add this line
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(40),
                          child: Column(
                            children: [
                              Text(
                                companyNameRepo,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400),
                              ),
                              // Add content for additional cards
                            ],
                          ),
                        ),
                      ),
                    ),
                    /////////////////////////////////////
                    // Card(
                    //   margin: const EdgeInsets.symmetric(
                    //       vertical: 50, horizontal: 400),
                    //   color: AppColors.blueB.withOpacity(0.9),
                    //   elevation: 2,
                    //   shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(15)),
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(20),
                    //     child: Column(
                    //       children: [
                    //         Text(
                    //           "Add New Company".tr(),
                    //           style: const TextStyle(
                    //               fontSize: 17,
                    //               fontWeight: FontWeight.w900,
                    //               color: Colors.white),
                    //         ),
                    //         FxBox.h24,
                    //         if (Responsive.isWeb(context))
                    //           Column(
                    //             children: [
                    //               Row(
                    //                 children: [
                    //                   Expanded(
                    //                     child: Column(
                    //                       crossAxisAlignment:
                    //                           CrossAxisAlignment.start,
                    //                       children: [
                    //                         // _commonText("Company Name".tr()),
                    //                         FxBox.h4,

                    //                         _listBox(
                    //                             controller:
                    //                                 companyNameController,
                    //                             hintText: "Company Name".tr(),
                    //                             onChanged: (value) {
                    //                               saveCompanyName(value);

                    //                               HomeBloc.get(context).add(
                    //                                   AddCompanyName(
                    //                                       companyName: value));

                    //                               HomeBloc.get(context).add(
                    //                                   CompnyNameFromSP(
                    //                                       companyName: value));
                    //                             }),
                    //                       ],
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //               FxBox.h60,
                    //               (state.submission == Submission.loading)
                    //                   ? loadingIndicator()
                    //                   : Center(
                    //                       child: ElevatedButton.icon(
                    //                           onPressed: () {
                    //                             if (state.companyName.isEmpty) {
                    //                               FxToast.showErrorToast(
                    //                                   context: context,
                    //                                   message:
                    //                                       "Enter Company Name");
                    //                               return;
                    //                             }
                    //                             HomeBloc.get(context).add(
                    //                                 const AddCompanyEvent());

                    //                             Navigator.of(context)
                    //                                 .push<void>(
                    //                               MaterialPageRoute(
                    //                                 builder: (context) =>
                    //                                     const AllEmployeesScreen(
                    //                                         // data: state
                    //                                         //     .employeeNamesList

                    //                                         ),
                    //                               ),
                    //                             );
                    //                           },
                    //                           style: ElevatedButton.styleFrom(
                    //                             shape: RoundedRectangleBorder(
                    //                                 borderRadius:
                    //                                     BorderRadius.circular(
                    //                                         10)),
                    //                             backgroundColor:
                    //                                 AppColors.green,
                    //                           ),
                    //                           label: Text(
                    //                             "confirm".tr(),
                    //                             style: const TextStyle(
                    //                                 color: AppColors.white),
                    //                           ),
                    //                           icon: const Icon(
                    //                             Icons.check_circle_outline,
                    //                             color: AppColors.white,
                    //                           )),
                    //                     ),
                    //             ],
                    //           ),
                    //         if (!Responsive.isWeb(context))
                    //           Column(
                    //             children: [
                    //               FxBox.h4,
                    //               _listBox(
                    //                   hintText: "Company Name".tr(),
                    //                   controller: companyNameController,
                    //                   onChanged: (value) {
                    //                     HomeBloc.get(context).add(
                    //                         AddCompanyName(companyName: value));
                    //                   }),
                    //               FxBox.h60,
                    //               (state.submission == Submission.loading)
                    //                   ? loadingIndicator()
                    //                   : Center(
                    //                       child: ElevatedButton.icon(
                    //                           onPressed: () {
                    //                             HomeBloc.get(context).add(
                    //                                 const AddCompanyEvent());

                    //                             Navigator.of(context)
                    //                                 .push<void>(
                    //                               MaterialPageRoute(
                    //                                 builder: (context) =>
                    //                                     const AllEmployeesScreen(),
                    //                               ),
                    //                             );
                    //                           },
                    //                           style: ElevatedButton.styleFrom(
                    //                             shape: RoundedRectangleBorder(
                    //                                 borderRadius:
                    //                                     BorderRadius.circular(
                    //                                         10)),
                    //                             backgroundColor:
                    //                                 AppColors.green,
                    //                           ),
                    //                           label: Text(
                    //                             "confirm".tr(),
                    //                             style: const TextStyle(
                    //                                 color: AppColors.white),
                    //                           ),
                    //                           icon: const Icon(
                    //                             Icons.check_circle_outline,
                    //                             color: AppColors.white,
                    //                           )),
                    //                     ),
                    //             ],
                    //           ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ]),
            );
          },
        ),
      ),
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
}
