import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Investigator/core/enum/enum.dart';
import 'package:Investigator/core/loader/loading_indicator.dart';
import 'package:Investigator/core/resources/app_colors.dart';
import 'package:Investigator/core/utils/responsive.dart';
// import 'package:Investigator/core/widgets/drop_down_widgets.dart';
import 'package:Investigator/core/widgets/sizedbox.dart';
import 'package:Investigator/core/widgets/textformfield.dart';
import 'package:Investigator/core/widgets/toast/toast.dart';
import 'package:Investigator/presentation/add_camera/bloc/home_bloc.dart';
import 'package:Investigator/presentation/standard_layout/screens/standard_layout.dart';

class DashboardScreen extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (_) => DashboardScreen(),
    );
  }

  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _AddCameraScreenState();
}

class _AddCameraScreenState extends State<DashboardScreen> {
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController companyNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StandardLayoutScreen(
      body: BlocProvider(
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
              return Card(
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
                        "Add Company".tr(),
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
                                          hintText: "add Company".tr(),
                                          onChanged: (value) {
                                            HomeBloc.get(context).add(
                                                AddCompanyName(
                                                    companyName: value));
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

                                          HomeBloc.get(context)
                                              .add(const AddCompanyEvent());
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
                      if (!Responsive.isWeb(context))
                        Column(
                          children: [
                            _commonText("Company Name".tr()),
                            FxBox.h4,
                            _listBox(
                                hintText: "add Company".tr(),
                                controller: companyNameController,
                                onChanged: (value) {
                                  HomeBloc.get(context)
                                      .add(AddCompanyName(companyName: value));
                                }),
                            FxBox.h60,
                            (state.submission == Submission.loading)
                                ? loadingIndicator()
                                : Center(
                                    child: ElevatedButton.icon(
                                        onPressed: () {
                                          HomeBloc.get(context)
                                              .add(const AddCompanyEvent());
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
              );
            },
          ),
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
