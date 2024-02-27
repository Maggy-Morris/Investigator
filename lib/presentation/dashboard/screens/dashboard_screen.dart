// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:Investigator/core/half_circular_chart/half_chart.dart';
// import 'package:Investigator/core/resources/app_colors.dart';
// import 'package:Investigator/core/utils/responsive.dart';
// import 'package:Investigator/core/widgets/sizedbox.dart';
// import 'package:Investigator/presentation/dashboard/bloc/dashboard_bloc.dart';
// import 'package:Investigator/presentation/standard_layout/screens/standard_layout.dart';
// import 'package:routemaster/routemaster.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

// class DashboardScreen extends StatelessWidget {
//   const DashboardScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return StandardLayoutScreen(
//       body: BlocProvider(
//         create: (context) => DashboardBloc()
//           ..add(const DashboardMainDataEvent())
//           ..add(const DashboardInitializeDate()),
//         child: BlocBuilder<DashboardBloc, DashboardState>(
//           builder: (context, state) {
//             return SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     FxBox.h24,
//                     SizedBox(
//                       width: double.infinity,
//                       child: Text("CamerasPeopleCount".tr(),
//                           style: const TextStyle(
//                               fontSize: 20, fontWeight: FontWeight.bold)),
//                     ),

//                     /// all cameras counts
//                     Wrap(
//                       children: _responsiveCardList(
//                         context: context,
//                         state: state,
//                       ),
//                     ),
//                     FxBox.h24,

//                     /// date filter
//                     SizedBox(
//                       width: MediaQuery.of(context).size.width,
//                       height: 100,
//                       child: Row(
//                         children: [
//                           Flexible(
//                             child: ElevatedButton(
//                               onPressed: () async {
//                                 await showDatePicker(
//                                   context: context,
//                                   lastDate: DateTime(3000),
//                                   firstDate: DateTime(2020),
//                                 ).then((value) {
//                                   if (value != null) {
//                                     DashboardBloc.get(context).add(
//                                         DashboardAddDay(
//                                             selectedDay: "${value.day}"));
//                                     DashboardBloc.get(context).add(
//                                         DashboardAddMonth(
//                                             selectedMonth: "${value.month}"));
//                                     DashboardBloc.get(context).add(
//                                         DashboardAddYear(
//                                             selectedYear: "${value.year}"));
//                                   }
//                                 });
//                               },
//                               child: Text((state.selectedDay.isEmpty)
//                                   ? "all".tr()
//                                   : state.selectedDay),
//                             ),
//                           ),
//                           Flexible(
//                             child: ElevatedButton(
//                               onPressed: () async {
//                                 await showDatePicker(
//                                   context: context,
//                                   lastDate: DateTime(3000),
//                                   firstDate: DateTime(2020),
//                                 ).then((value) {
//                                   if (value != null) {
//                                     DashboardBloc.get(context).add(
//                                         const DashboardAddDay(selectedDay: ""));
//                                     DashboardBloc.get(context).add(
//                                         DashboardAddMonth(
//                                             selectedMonth: "${value.month}"));
//                                     DashboardBloc.get(context).add(
//                                         DashboardAddYear(
//                                             selectedYear: "${value.year}"));
//                                   }
//                                 });
//                               },
//                               child: Text((state.selectedMonth.isEmpty)
//                                   ? "all".tr()
//                                   : state.selectedMonth),
//                             ),
//                           ),
//                           Flexible(
//                             child: ElevatedButton(
//                               onPressed: () async {
//                                 await showDatePicker(
//                                   context: context,
//                                   lastDate: DateTime(3000),
//                                   firstDate: DateTime(2020),
//                                 ).then((value) {
//                                   if (value != null) {
//                                     DashboardBloc.get(context).add(
//                                         const DashboardAddDay(selectedDay: ""));
//                                     DashboardBloc.get(context).add(
//                                         const DashboardAddMonth(
//                                             selectedMonth: ""));
//                                     DashboardBloc.get(context).add(
//                                         DashboardAddYear(
//                                             selectedYear: "${value.year}"));
//                                   }
//                                 });
//                               },
//                               child: Text(state.selectedYear),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     FxBox.h24,

//                     /// graph
//                     SizedBox(
//                       height: MediaQuery.of(context).size.height * 0.8,
//                       child: SfCartesianChart(
//                         title: ChartTitle(text: "averageCounts".tr()),
//                         legend: const Legend(
//                             isVisible: true,
//                             position: LegendPosition.bottom,
//                             overflowMode: LegendItemOverflowMode.wrap),
//                         isTransposed: false,
//                         // plotAreaBackgroundColor: AppColors.white,
//                         // plotAreaBorderColor: AppColors.white,
//                         // borderColor: AppColors.white,
//                         primaryXAxis: CategoryAxis(
//                             title: AxisTitle(text: "timeRange".tr()),
//                             majorGridLines:
//                                 const MajorGridLines(color: AppColors.white)),
//                         primaryYAxis: NumericAxis(
//                             title: AxisTitle(text: "count".tr()),
//                             majorGridLines:
//                                 const MajorGridLines(color: AppColors.white)),
//                         tooltipBehavior: TooltipBehavior(enable: true),
//                         series: _seriesList(state: state),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   List<Widget> _responsiveCardList(
//       {required BuildContext context, required DashboardState state}) {
//     return List.generate(
//         state.camerasCounts.length,
//         (index) => InkWell(
//               onTap: () {
//                 Routemaster.of(context).push(
//                   "/cameraDetails",
//                   queryParameters: {
//                     "name": state.camerasCounts[index].cameraName ?? ""
//                   },
//                 );
//               },
//               child: SizedBox(
//                 width: Responsive.isMobile(context)
//                     ? MediaQuery.of(context).size.width
//                     : Responsive.isTablet(context)
//                         ? MediaQuery.of(context).size.width * 0.45
//                         : MediaQuery.of(context).size.width * 0.15,
//                 height: 200,
//                 child: _dataOfCamera(
//                   context: context,
//                   name: state.camerasCounts[index].cameraName ?? "",
//                   count: state.camerasCounts[index].countAverage.toString(),
//                 ),
//               ),
//               // child: Card(
//               //   shadowColor: AppColors.blueBlack.withOpacity(0.5),
//               //   elevation: 0,
//               //   child: Container(
//               //     width: Responsive.isMobile(context)
//               //         ? MediaQuery.of(context).size.width
//               //         : Responsive.isTablet(context)
//               //             ? MediaQuery.of(context).size.width * 0.45
//               //             : MediaQuery.of(context).size.width * 0.15,
//               //     padding: const EdgeInsets.all(20.0),
//               //     // decoration: BoxDecoration(
//               //     //     gradient: LinearGradient(colors: [
//               //     //
//               //     //     ])),
//               //     child: Column(
//               //       children: [
//               //         FxBox.h24,
//               //         Text(state.camerasCounts[index].cameraName ?? ""),
//               //         FxBox.h24,
//               //         Text(state.camerasCounts[index].countAverage.toString()),
//               //         FxBox.h24,
//               //       ],
//               //     ),
//               //   ),
//               // ),
//             ));
//   }

//   List<CartesianSeries<dynamic, dynamic>> _seriesList(
//       {required DashboardState state}) {
//     return List.generate(state.camerasCountsPerHour.length, (index) {
//       // List<int> _dataSourceList = [];
//       // state.camerasCountsPerHour[index].forEach((element) {
//       //   _dataSourceList.add(element.countAverage??0);
//       // });

//       ///
//       List<Map<String, dynamic>> dataSourceListPartTwo = [];
//       state.camerasCountsPerHour[index].forEach((element) {
//         dataSourceListPartTwo.add({
//           "name": element.cameraName,
//           "count": element.countAverage,
//           "time": element.timeRange,
//         });
//       });

//       ///

//       // List<String> _namesList = [];
//       // state.camerasCountsPerHour[index].forEach((element) {
//       //   _namesList.add(element.cameraName ??"notFount".tr());
//       // });

//       // List<String> _timeRangeList = [];
//       // state.camerasCountsPerHour[index].forEach((element) {
//       //   _timeRangeList.add(element.timeRange??"0");
//       // });

//       return LineSeries(
//         // xValueMapper: (datum, x) => _timeRangeList.isNotEmpty?_timeRangeList[x]:[],
//         xValueMapper: (datum, x) => datum["time"],
//         // dataLabelMapper: (datum, index) => datum["name"],
//         name: dataSourceListPartTwo.isNotEmpty
//             ? dataSourceListPartTwo.first["name"]
//             : "NotDefined".tr(),
//         // yValueMapper: (datum, x) => _dataSourceList.isNotEmpty?_dataSourceList[x]:0,
//         yValueMapper: (datum, x) => datum["count"],
//         dataSource: dataSourceListPartTwo,
//         markerSettings: const MarkerSettings(isVisible: true),
//       );
//     });
//   }

//   Widget _dataOfCamera({
//     // required double number,
//     // required int index,
//     required String name,
//     required String count,
//     required BuildContext context,
//   }) {
//     return Card(
//       surfaceTintColor: Colors.transparent,
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.all(15),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Flexible(
//                     child: Text(
//                       name,
//                       maxLines: 3,
//                       style: const TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                   FxBox.h10,
//                   Text(
//                     count,
//                     maxLines: 1,
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             FxBox.w12,
//             _halfCircleChart(
//               chartColor: AppColors.green,
//               chartpercentage: 7 / 10,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _halfCircleChart({
//     required double chartpercentage,
//     required Color chartColor,
//     // required double radius,
//   }) {
//     return Center(
//       child: Stack(
//         alignment: AlignmentDirectional.center,
//         children: [
//           CircularPercentIndicator(
//             radius: 20,
//             lineWidth: 5,
//             percent: 1,
//             progressColor: AppColors.babyBlue,
//             circularStrokeCap: CircularStrokeCap.round,
//             arcType: ArcType.FULL,
//           ),
//           CircularPercentIndicator(
//             radius: 20,
//             lineWidth: 5,
//             animation: true,
//             animationDuration: 1200,
//             percent: chartpercentage,
//             curve: Curves.easeIn,
//             backgroundColor: AppColors.white,
//             progressColor: chartColor,
//             circularStrokeCap: CircularStrokeCap.round,
//             arcType: ArcType.FULL,
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Investigator/core/enum/enum.dart';
import 'package:Investigator/core/loader/loading_indicator.dart';
import 'package:Investigator/core/resources/app_colors.dart';
import 'package:Investigator/core/utils/responsive.dart';
import 'package:Investigator/core/widgets/drop_down_widgets.dart';
import 'package:Investigator/core/widgets/sizedbox.dart';
import 'package:Investigator/core/widgets/textformfield.dart';
import 'package:Investigator/core/widgets/toast/toast.dart';
import 'package:Investigator/presentation/add_camera/bloc/home_bloc.dart';
import 'package:Investigator/presentation/standard_layout/screens/standard_layout.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _AddCameraScreenState();
}

class _AddCameraScreenState extends State<DashboardScreen> {
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController companySourceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StandardLayoutScreen(
      // key: _scaffoldKey,
      // appBar: AppBar(),
      body: BlocProvider(
        create: (context) => HomeBloc()..add(const DataEvent()),
        child: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state.submission == Submission.success) {
              companyNameController.clear();
              companySourceController.clear();
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
                                // FxBox.w16,
                                // Expanded(
                                //   child: Column(
                                //     crossAxisAlignment:
                                //         CrossAxisAlignment.start,
                                //     children: [
                                //       _commonText("sourceType".tr()),
                                //       FxBox.h4,
                                //       singleSelectGenericDropdown(
                                //         isEnabled: true,
                                //         isRequired: false,
                                //         filled: true,
                                //         selectedItem: state.cameraSourceType,
                                //         onChanged: (value) {
                                //           if (value?.isNotEmpty ?? false) {
                                //             HomeBloc.get(context).add(
                                //                 AddCameraSourceType(
                                //                     cameraSourceType:
                                //                         value ?? ""));
                                //           }
                                //         },
                                //         itemsList: state.sourceTypesList,
                                //       ),
                                //     ],
                                //   ),
                                // ),
                              ],
                            ),
                            // FxBox.h16,
                            // Row(
                            //   children: [
                            //     Expanded(
                            //       child: Column(
                            //         crossAxisAlignment:
                            //             CrossAxisAlignment.start,
                            //         children: [
                            //           _commonText("sourceTxt".tr()),
                            //           FxBox.h4,
                            //           _listBox(
                            //               hintText: "addSourceTxt".tr(),
                            //               enabled:
                            //                   state.cameraSourceType.isNotEmpty,
                            //               controller: cameraSourceController,
                            //               onChanged: (value) {
                            //                 HomeBloc.get(context).add(
                            //                     AddCameraSource(
                            //                         cameraSource: value));
                            //               }),
                            //         ],
                            //       ),
                            //     ),
                            //     FxBox.w16,
                            //     Expanded(
                            //       child: Column(
                            //         crossAxisAlignment:
                            //             CrossAxisAlignment.start,
                            //         children: [
                            //           _commonText("cameraModels".tr()),
                            //           FxBox.h4,
                            //           multiSelectGenericDropdown(
                            //             isEnabled: true,
                            //             isRequired: false,
                            //             filled: true,
                            //             selectedItem:
                            //                 state.cameraSelectedModels,
                            //             onChanged: (value) {
                            //               HomeBloc.get(context).add(
                            //                   AddCameraSourceModels(
                            //                       cameraSelectedModels:
                            //                           value ?? []));
                            //             },
                            //             itemsList: state.modelsNameList,
                            //           ),
                            //         ],
                            //       ),
                            //     ),
                            //   ],
                            // ),

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
                                          // if (state.cameraSource.isEmpty) {
                                          //   FxToast.showErrorToast(
                                          //       context: context,
                                          //       message: "Add Source");
                                          //   return;
                                          // }
                                          // if (state.cameraSourceType.isEmpty) {
                                          //   FxToast.showErrorToast(
                                          //       context: context,
                                          //       message: "Add Source Type");
                                          //   return;
                                          // }
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
                            // FxBox.h10,
                            // _commonText("sourceType".tr()),
                            // FxBox.h4,
                            // singleSelectGenericDropdown(
                            //   isEnabled: true,
                            //   isRequired: false,
                            //   filled: true,
                            //   selectedItem: state.cameraSourceType,
                            //   onChanged: (value) {
                            //     if (value?.isNotEmpty ?? false) {
                            //       HomeBloc.get(context).add(AddCameraSourceType(
                            //           cameraSourceType: value ?? ""));
                            //     }
                            //   },
                            //   itemsList: state.sourceTypesList,
                            // ),
                            // FxBox.h10,
                            // _commonText("sourceTxt".tr()),
                            // FxBox.h4,
                            // _listBox(
                            //     hintText: "addSourceTxt".tr(),
                            //     enabled: state.cameraSourceType.isNotEmpty,
                            //     controller: cameraSourceController,
                            //     onChanged: (value) {
                            //       HomeBloc.get(context).add(
                            //           AddCameraSource(cameraSource: value));
                            //     }),
                            // FxBox.h10,
                            // _commonText("cameraModels".tr()),
                            // FxBox.h4,
                            // multiSelectGenericDropdown(
                            //   isEnabled: true,
                            //   isRequired: false,
                            //   filled: true,
                            //   selectedItem: state.cameraSelectedModels,
                            //   onChanged: (value) {
                            //     HomeBloc.get(context).add(AddCameraSourceModels(
                            //         cameraSelectedModels: value ?? []));
                            //   },
                            //   itemsList: state.modelsNameList,
                            // ),
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
