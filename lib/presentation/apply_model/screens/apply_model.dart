import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Investigator/core/resources/app_colors.dart';
import 'package:Investigator/core/utils/responsive.dart';
import 'package:Investigator/core/widgets/drop_down_widgets.dart';
import 'package:Investigator/core/widgets/sizedbox.dart';
import 'package:Investigator/core/widgets/toast/toast.dart';
import 'package:Investigator/presentation/add_camera/bloc/home_bloc.dart';
import 'package:Investigator/presentation/standard_layout/screens/standard_layout.dart';

class ApplyModelScreen extends StatefulWidget {
  const ApplyModelScreen({Key? key}) : super(key: key);

  @override
  State<ApplyModelScreen> createState() => _ApplyModelScreenState();
}

class _ApplyModelScreenState extends State<ApplyModelScreen> {
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return StandardLayoutScreen(
      body: BlocProvider(
        create: (context) => HomeBloc()..add(const DataEvent()),
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
                      "applyModel".tr(),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _commonText("cameraName".tr()),
                                    FxBox.h4,
                                    singleSelectGenericDropdown(
                                      isEnabled: true,
                                      isRequired: false,
                                      filled: true,
                                      showSearch: true,
                                      onChanged: (value) {
                                        if (value?.isNotEmpty ?? false) {
                                          HomeBloc.get(context).add(
                                              AddCameraName(
                                                  cameraName:
                                                  value ?? ""));
                                        }
                                      },
                                      itemsList: state.camerasNamesList,
                                    ),
                                  ],
                                ),
                              ),
                              FxBox.w16,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _commonText("cameraModels".tr()),
                                    FxBox.h4,
                                    multiSelectGenericDropdown(
                                      isEnabled: true,
                                      isRequired: false,
                                      filled: true,
                                      onChanged: (value) {
                                        HomeBloc.get(context).add(
                                            AddCameraSourceModels(
                                                cameraSelectedModels:
                                                value ?? []));
                                      },
                                      itemsList: state.modelsNameList,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          FxBox.h60,
                          Center(
                            child: ElevatedButton.icon(
                                onPressed: () {
                                  if(state.cameraName.isEmpty){
                                    FxToast.showErrorToast(context: context,message: "Select Camera Name");
                                    return;
                                  }
                                  if(state.cameraSelectedModels.isEmpty){
                                    FxToast.showErrorToast(context: context,message: "Select Model Name");
                                    return;
                                  }
                                  HomeBloc.get(context).add(const ApplyModelEvent());
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  backgroundColor: AppColors.green,
                                ),
                                label: Text(
                                  "confirm".tr(),
                                  style:
                                  const TextStyle(color: AppColors.white),
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
                          _commonText("cameraName".tr()),
                          FxBox.h4,
                          singleSelectGenericDropdown(
                            isEnabled: true,
                            isRequired: false,
                            filled: true,
                            showSearch: true,
                            onChanged: (value) {
                              if (value?.isNotEmpty ?? false) {
                                HomeBloc.get(context).add(
                                    AddCameraName(
                                        cameraName:
                                        value ?? ""));
                              }
                            },
                            itemsList: state.camerasNamesList,
                          ),
                          FxBox.h10,
                          _commonText("cameraModels".tr()),
                          FxBox.h4,
                          multiSelectGenericDropdown(
                            isEnabled: true,
                            isRequired: false,
                            filled: true,
                            onChanged: (value) {
                              HomeBloc.get(context).add(
                                  AddCameraSourceModels(
                                      cameraSelectedModels:
                                      value ?? []));
                            },
                            itemsList: state.modelsNameList,
                          ),
                          FxBox.h60,
                          Center(
                            child: ElevatedButton.icon(
                                onPressed: () {
                                  if(state.cameraName.isEmpty){
                                    FxToast.showErrorToast(context: context,message: "Select Camera Name");
                                    return;
                                  }
                                  if(state.cameraSelectedModels.isEmpty){
                                    FxToast.showErrorToast(context: context,message: "Select Model Name");
                                    return;
                                  }
                                  HomeBloc.get(context).add(const ApplyModelEvent());
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  backgroundColor: AppColors.green,
                                ),
                                label: Text(
                                  "confirm".tr(),
                                  style:
                                  const TextStyle(color: AppColors.white),
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
