import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luminalens/core/half_circular_chart/half_chart.dart';
import 'package:luminalens/core/resources/app_colors.dart';
import 'package:luminalens/core/utils/responsive.dart';
import 'package:luminalens/core/widgets/sizedbox.dart';
import 'package:luminalens/presentation/dashboard/bloc/dashboard_bloc.dart';
import 'package:luminalens/presentation/standard_layout/screens/standard_layout.dart';
import 'package:routemaster/routemaster.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StandardLayoutScreen(
      body: BlocProvider(
        create: (context) => DashboardBloc()
          ..add(const DashboardMainDataEvent())
          ..add(const DashboardInitializeDate()),
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FxBox.h24,
                    SizedBox(
                      width: double.infinity,
                      child: Text("CamerasPeopleCount".tr(),
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),

                    /// all cameras counts
                    Wrap(
                      children: _responsiveCardList(
                        context: context,
                        state: state,
                      ),
                    ),
                    FxBox.h24,

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
                                    DashboardBloc.get(context).add(
                                        DashboardAddDay(
                                            selectedDay: "${value.day}"));
                                    DashboardBloc.get(context).add(
                                        DashboardAddMonth(
                                            selectedMonth: "${value.month}"));
                                    DashboardBloc.get(context).add(
                                        DashboardAddYear(
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
                                    DashboardBloc.get(context).add(
                                        const DashboardAddDay(selectedDay: ""));
                                    DashboardBloc.get(context).add(
                                        DashboardAddMonth(
                                            selectedMonth: "${value.month}"));
                                    DashboardBloc.get(context).add(
                                        DashboardAddYear(
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
                                    DashboardBloc.get(context).add(
                                        const DashboardAddDay(selectedDay: ""));
                                    DashboardBloc.get(context).add(
                                        const DashboardAddMonth(
                                            selectedMonth: ""));
                                    DashboardBloc.get(context).add(
                                        DashboardAddYear(
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
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
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
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _responsiveCardList(
      {required BuildContext context, required DashboardState state}) {
    return List.generate(
        state.camerasCounts.length,
        (index) => InkWell(
              onTap: () {
                Routemaster.of(context).push(
                  "/cameraDetails",
                  queryParameters: {
                    "name": state.camerasCounts[index].cameraName ?? ""
                  },
                );
              },
              child: SizedBox(
                width: Responsive.isMobile(context)
                    ? MediaQuery.of(context).size.width
                    : Responsive.isTablet(context)
                        ? MediaQuery.of(context).size.width * 0.45
                        : MediaQuery.of(context).size.width * 0.15,
                height: 200,
                child: _dataOfCamera(
                  context: context,
                  name: state.camerasCounts[index].cameraName ?? "",
                  count: state.camerasCounts[index].countAverage.toString(),
                ),
              ),
              // child: Card(
              //   shadowColor: AppColors.blueBlack.withOpacity(0.5),
              //   elevation: 0,
              //   child: Container(
              //     width: Responsive.isMobile(context)
              //         ? MediaQuery.of(context).size.width
              //         : Responsive.isTablet(context)
              //             ? MediaQuery.of(context).size.width * 0.45
              //             : MediaQuery.of(context).size.width * 0.15,
              //     padding: const EdgeInsets.all(20.0),
              //     // decoration: BoxDecoration(
              //     //     gradient: LinearGradient(colors: [
              //     //
              //     //     ])),
              //     child: Column(
              //       children: [
              //         FxBox.h24,
              //         Text(state.camerasCounts[index].cameraName ?? ""),
              //         FxBox.h24,
              //         Text(state.camerasCounts[index].countAverage.toString()),
              //         FxBox.h24,
              //       ],
              //     ),
              //   ),
              // ),
            ));
  }

  List<CartesianSeries<dynamic, dynamic>> _seriesList(
      {required DashboardState state}) {
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

      ///

      // List<String> _namesList = [];
      // state.camerasCountsPerHour[index].forEach((element) {
      //   _namesList.add(element.cameraName ??"notFount".tr());
      // });

      // List<String> _timeRangeList = [];
      // state.camerasCountsPerHour[index].forEach((element) {
      //   _timeRangeList.add(element.timeRange??"0");
      // });

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

  Widget _dataOfCamera({
    // required double number,
    // required int index,
    required String name,
    required String count,
    required BuildContext context,
  }) {
    return Card(
      surfaceTintColor: Colors.transparent,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      name,
                      maxLines: 3,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  FxBox.h10,
                  Text(
                    count,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            FxBox.w12,
            _halfCircleChart(
              chartColor: AppColors.green,
              chartpercentage: 7 / 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget _halfCircleChart({
    required double chartpercentage,
    required Color chartColor,
    // required double radius,
  }) {
    return Center(
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          CircularPercentIndicator(
            radius: 20,
            lineWidth: 5,
            percent: 1,
            progressColor: AppColors.babyBlue,
            circularStrokeCap: CircularStrokeCap.round,
            arcType: ArcType.FULL,
          ),
          CircularPercentIndicator(
            radius: 20,
            lineWidth: 5,
            animation: true,
            animationDuration: 1200,
            percent: chartpercentage,
            curve: Curves.easeIn,
            backgroundColor: AppColors.white,
            progressColor: chartColor,
            circularStrokeCap: CircularStrokeCap.round,
            arcType: ArcType.FULL,
          ),
        ],
      ),
    );
  }
}
