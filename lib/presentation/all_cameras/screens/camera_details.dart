import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Investigator/core/loader/loading_indicator.dart';
import 'package:Investigator/core/resources/app_colors.dart';
import 'package:Investigator/core/utils/responsive.dart';
import 'package:Investigator/core/widgets/badge_builder.dart';
import 'package:Investigator/core/widgets/sizedbox.dart';
import 'package:Investigator/presentation/all_cameras/bloc/camera_bloc.dart';
import 'package:Investigator/presentation/standard_layout/screens/standard_layout.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CameraDetails extends StatefulWidget {
  final String cameraName;

  const CameraDetails({Key? key, required this.cameraName}) : super(key: key);

  @override
  State<CameraDetails> createState() => _CameraDetailsState();
}

class _CameraDetailsState extends State<CameraDetails> {
  @override
  Widget build(BuildContext context) {
    return StandardLayoutScreen(
      body: BlocProvider(
        create: (context) => CameraBloc()
          ..add(CameraDetailsEvent(cameraName: widget.cameraName))
          ..add(const CameraInitializeDate()),
        child: BlocListener<CameraBloc, CameraState>(
          listener: (context, state) {},
          child: BlocBuilder<CameraBloc, CameraState>(
            builder: (context, state) {
              if (state.singleCameraDetails.isEmpty) {
                return Center(child: loadingIndicator());
              }
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      FxBox.h24,
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                            state.singleCameraDetails.first.cameraName ?? "",
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      FxBox.h24,

                      /// Camera's Data
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Wrap(
                          alignment: WrapAlignment.start,
                          runAlignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          children: [
                            Card(
                              color: AppColors.white,
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                width: Responsive.isMobile(context)
                                    ? MediaQuery.of(context).size.width
                                    : MediaQuery.of(context).size.width * 0.2,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _commonText("cameraName".tr()),
                                    Text(state.singleCameraDetails.first
                                            .cameraInfo?.cameraName ??
                                        ""),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              color: AppColors.white,
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                width: Responsive.isMobile(context)
                                    ? MediaQuery.of(context).size.width
                                    : MediaQuery.of(context).size.width * 0.2,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _commonText("insertionDate".tr()),
                                    Text(state.singleCameraDetails.first
                                            .cameraInfo?.insertionDate ??
                                        ""),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              color: (state.singleCameraDetails.first.cameraInfo
                                          ?.status ==
                                      "ON")
                                  ? AppColors.green
                                  : (state.singleCameraDetails.first.cameraInfo
                                              ?.status ==
                                          "OFF")
                                      ? AppColors.thinkRedColor
                                      : AppColors.white,
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                width: Responsive.isMobile(context)
                                    ? MediaQuery.of(context).size.width
                                    : MediaQuery.of(context).size.width * 0.2,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _commonText("status".tr()),
                                    Text(state.singleCameraDetails.first
                                            .cameraInfo?.status ??
                                        ""),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              color: AppColors.white,
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                width: Responsive.isMobile(context)
                                    ? MediaQuery.of(context).size.width
                                    : MediaQuery.of(context).size.width * 0.2,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _commonText("sourceType".tr()),
                                    Text(state.singleCameraDetails.first
                                            .cameraInfo?.sourceType ??
                                        ""),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              color: AppColors.white,
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                width: Responsive.isMobile(context)
                                    ? MediaQuery.of(context).size.width
                                    : MediaQuery.of(context).size.width * 0.2,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _commonText("sourceTxt".tr()),
                                    Text(state.singleCameraDetails.first
                                            .cameraInfo?.source ??
                                        ""),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              color: AppColors.white,
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                width: Responsive.isMobile(context)
                                    ? MediaQuery.of(context).size.width
                                    : MediaQuery.of(context).size.width * 0.2,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _commonText("cameraModels".tr()),
                                    getCardBadgesRow(
                                        badgesList: state.singleCameraDetails
                                                .first.models ??
                                            []),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// date filter
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        child: Row(
                          children: [
                            Flexible(
                              child: ElevatedButton(
                                onPressed: () async {
                                  await showDatePicker(
                                    context: context,
                                    lastDate: DateTime(3000),
                                    firstDate: DateTime(2020),
                                  ).then((value) {
                                    if (value != null) {
                                      CameraBloc.get(context).add(CameraAddDay(
                                          selectedDay: "${value.day}"));
                                      CameraBloc.get(context).add(
                                          CameraAddMonth(
                                              selectedMonth: "${value.month}"));
                                      CameraBloc.get(context).add(CameraAddYear(
                                          selectedYear: "${value.year}"));
                                    }
                                  });
                                },
                                child: Text((state.selectedDay.isEmpty)
                                    ? "all".tr()
                                    : state.selectedDay),
                              ),
                            ),
                            Flexible(
                              child: ElevatedButton(
                                onPressed: () async {
                                  await showDatePicker(
                                    context: context,
                                    lastDate: DateTime(3000),
                                    firstDate: DateTime(2020),
                                  ).then((value) {
                                    if (value != null) {
                                      CameraBloc.get(context).add(
                                          const CameraAddDay(selectedDay: ""));
                                      CameraBloc.get(context).add(
                                          CameraAddMonth(
                                              selectedMonth: "${value.month}"));
                                      CameraBloc.get(context).add(CameraAddYear(
                                          selectedYear: "${value.year}"));
                                    }
                                  });
                                },
                                child: Text((state.selectedMonth.isEmpty)
                                    ? "all".tr()
                                    : state.selectedMonth),
                              ),
                            ),
                            Flexible(
                              child: ElevatedButton(
                                onPressed: () async {
                                  await showDatePicker(
                                    context: context,
                                    lastDate: DateTime(3000),
                                    firstDate: DateTime(2020),
                                  ).then((value) {
                                    if (value != null) {
                                      CameraBloc.get(context).add(
                                          const CameraAddDay(selectedDay: ""));
                                      CameraBloc.get(context).add(
                                          const CameraAddMonth(
                                              selectedMonth: ""));
                                      CameraBloc.get(context).add(CameraAddYear(
                                          selectedYear: "${value.year}"));
                                    }
                                  });
                                },
                                child: Text(state.selectedYear),
                              ),
                            ),
                          ],
                        ),
                      ),
                      FxBox.h24,

                      /// graph
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8,
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: SfCartesianChart(
                            title: ChartTitle(text: "averageCounts".tr()),
                            legend: const Legend(
                                isVisible: true,
                                position: LegendPosition.bottom,
                                overflowMode: LegendItemOverflowMode.wrap),
                            isTransposed: false,
                            // plotAreaBackgroundColor: AppColors.white,
                            // plotAreaBorderColor: AppColors.white,
                            // borderColor: AppColors.white,
                            primaryXAxis: CategoryAxis(
                                title: AxisTitle(text: "timeRange".tr()),
                                majorGridLines:
                                    const MajorGridLines(color: AppColors.white)),
                            primaryYAxis: NumericAxis(
                                title: AxisTitle(text: "count".tr()),
                                majorGridLines:
                                    const MajorGridLines(color: AppColors.white)),
                            tooltipBehavior: TooltipBehavior(enable: true),
                            series: _seriesList(state: state),
                          ),
                        ),
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

  List<CartesianSeries<dynamic, dynamic>> _seriesList(
      {required CameraState state}) {
    return List.generate(state.camerasCountsPerHour.length, (index) {
      // List<int> _dataSourceList = [];
      // state.camerasCountsPerHour[index].forEach((element) {
      //   _dataSourceList.add(element.countAverage??0);
      // });

      ///
      List<Map<String, dynamic>> dataSourceListPartTwo = [];
      state.camerasCountsPerHour[index].forEach((element) {
        dataSourceListPartTwo.add({
          "name": element.cameraName,
          "count": element.countAverage,
          "time": element.timeRange,
        });
      });
      return LineSeries(
        // xValueMapper: (datum, x) => _timeRangeList.isNotEmpty?_timeRangeList[x]:[],
        xValueMapper: (datum, x) => datum["time"],
        // dataLabelMapper: (datum, index) => datum["name"],
        name: dataSourceListPartTwo.isNotEmpty
            ? dataSourceListPartTwo.first["name"]
            : "NotDefined".tr(),
        // yValueMapper: (datum, x) => _dataSourceList.isNotEmpty?_dataSourceList[x]:0,
        yValueMapper: (datum, x) => datum["count"],
        dataSource: dataSourceListPartTwo,
        markerSettings: const MarkerSettings(isVisible: true),
      );
    });
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
