import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luminalens/core/utils/responsive.dart';
import 'package:luminalens/core/widgets/badge_builder.dart';
import 'package:luminalens/core/widgets/sizedbox.dart';
import 'package:luminalens/presentation/all_cameras/bloc/camera_bloc.dart';
import 'package:luminalens/presentation/standard_layout/screens/standard_layout.dart';
import 'package:routemaster/routemaster.dart';

class AllCamerasScreen extends StatelessWidget {
  const AllCamerasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StandardLayoutScreen(
      body: BlocProvider(
        create: (context) => CameraBloc()
          ..add(const CameraMainDataEvent())
          ..add(const CameraInitializeDate()),
        child: BlocBuilder<CameraBloc, CameraState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    FxBox.h24,
                    SizedBox(
                      width: double.infinity,
                      child: Text("AllCameras".tr(),
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    FxBox.h24,
                    Wrap(
                        children: _responsiveCardList(
                            context: context, state: state)),
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
      {required BuildContext context, required CameraState state}) {
    return List.generate(
        state.camerasDetails.length,
        (index) => InkWell(
              onTap: () {
                Routemaster.of(context).push(
                  "/cameraDetails",
                  queryParameters: {
                    "name": state.camerasDetails[index].cameraName ?? ""
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
                      name: state.camerasDetails[index].cameraName ?? "",
                      models: state.camerasDetails[index].models ?? [],
                      context: context)),
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

  Widget _dataOfCamera({
    required String name,
    required List<String> models,
    required BuildContext context,
  }) {
    return Card(
      surfaceTintColor: Colors.transparent,
      elevation: 2,
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
            getCardBadgesRow(badgesList: models),
          ],
        ),
      ),
    );
  }
}
