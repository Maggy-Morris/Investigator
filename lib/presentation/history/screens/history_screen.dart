import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:routemaster/routemaster.dart';

import '../../../core/resources/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/badge_builder.dart';
import '../../../core/widgets/sizedbox.dart';
// import '../../standard_layout/bloc/standard_layout_cubit.dart';
import '../../standard_layout/screens/standard_layout.dart';
import '../bloc/history_bloc.dart';

class AllHistoryScreen extends StatelessWidget {
  const AllHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // StandardLayoutCubit.get(context).onEditPageNavigationNumber(9);
    return StandardLayoutScreen(
      body: BlocProvider(
        create: (context) => HistoryBloc()..add(const PathesDataEvent()),
        child: BlocBuilder<HistoryBloc, HistoryState>(
          builder: (context, state) {
            return Card(
              margin: const EdgeInsets.all(20),
              color: AppColors.backGround,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 20.0, right: 20.0, left: 20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          FxBox.h24,
                          SizedBox(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "History".tr(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          FxBox.h24,
                          (state.allPathes.isNotEmpty)
                              ? Wrap(
                                  children: _responsiveCardList(
                                    context: context,
                                    state: state,
                                  ),
                                )
                              : Column(
                                  children: [
                                    FxBox.h24,
                                    const Text(
                                      "No History Yet!",
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 30),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _responsiveCardList(
      {required BuildContext context, required HistoryState state}) {
    return List.generate(
        state.allPathes.length,
        (index) => InkWell(
              onTap: () {
                Routemaster.of(context).push(
                  "/requestDetails",
                  queryParameters: {
                    "path": state.allPathes[index].path ?? "",
                    "count": state.allPathes[index].count.toString()
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
                      date: state.allPathes[index].path
                              ?.split("/")[2]
                              .split("_")[0] ??
                          "",
                      time: state.allPathes[index].path
                              ?.split("/")[2]
                              .split("_")[1] ??
                          "",
                      name: state.allPathes[index].path?.split("/")[1] ?? "",
                      // models: state.allPathes[index].count.,
                      context: context)),
            ));
  }

  Widget _dataOfCamera({
    required String name,
    required String date,
    required String time,
    List<String>? models,
    required BuildContext context,
  }) {
    return Card(
      surfaceTintColor: Colors.transparent,
      elevation: 2,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
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
              Flexible(
                child: Text(
                  date,
                  maxLines: 3,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              FxBox.h10,
              Flexible(
                child: Text(
                  time,
                  maxLines: 3,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              FxBox.h10,
              getCardBadgesRow(badgesList: models ?? []),
            ],
          ),
        ),
      ),
    );
  }
}
