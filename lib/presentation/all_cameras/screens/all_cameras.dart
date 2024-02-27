import 'package:Investigator/core/resources/app_colors.dart';
import 'package:Investigator/presentation/all_cameras/screens/text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Investigator/core/utils/responsive.dart';
import 'package:Investigator/core/widgets/badge_builder.dart';
import 'package:Investigator/core/widgets/sizedbox.dart';
import 'package:Investigator/presentation/all_cameras/bloc/camera_bloc.dart';
import 'package:Investigator/presentation/standard_layout/screens/standard_layout.dart';
import 'package:routemaster/routemaster.dart';

class AllCamerasScreen extends StatelessWidget {
  const AllCamerasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> _contactList = [
      {
        'name': 'John Doe',
        'profession': 'UI Designer',
      },
      {
        'name': 'Samantha William',
        'profession': 'UI Designer',
      },
      {
        'name': 'Tony Soap',
        'profession': 'Web Developer',
      },
      {
        'name': 'Karen Hope',
        'profession': 'Android Developer',
      },
      {
        'name': 'Tatang Wijaya',
        'profession': 'QA Engineer',
      },
      {
        'name': 'Johnny Ahmad',
        'profession': 'Product Owner',
      },
      {
        'name': 'Jordan Nico',
        'profession': 'Product Manager',
      },
      {
        'name': 'Budi Prabowo',
        'profession': 'ios Developer',
      },
      {
        'name': 'Nadila Adja',
        'profession': 'Graphic Designer',
      },
      {
        'name': 'Azizi Azazel',
        'profession': 'UX Engineer',
      },
      {
        'name': 'Angelina Crispy',
        'profession': 'Software Engineering',
      },
      {
        'name': 'Ipi Antoinette',
        'profession': 'VP Product',
      },
    ];

    List<CameraDetail> dummyEmployees = [
      CameraDetail(
        phone: '123456789',
        email: "omar@gmail.com",
        cameraName: 'employee 10',
        // models: ['Model g', 'Model h'],
      ),
      CameraDetail(
        phone: '123456789',
        email: "omar@gmail.com",
        cameraName: 'employee 10',
        // models: ['Model g', 'Model h'],
      ),
      CameraDetail(
        phone: '123456789',
        email: "omar@gmail.com",
        cameraName: 'employee 10',
        // models: ['Model g', 'Model h'],
      ),
      CameraDetail(
        phone: '123456789',
        email: "omar@gmail.com",
        cameraName: 'employee 10',
        // models: ['Model g', 'Model h'],
      ),
      CameraDetail(
        phone: '123456789',
        email: "omar@gmail.com",
        cameraName: 'employee 10',
        // models: ['Model g', 'Model h'],
      ),
      CameraDetail(
        phone: '123456789',
        email: "omar@gmail.com",
        cameraName: 'employee 10',
        // models: ['Model g', 'Model h'],
      ),
      CameraDetail(
        phone: '123456789',
        email: "omar@gmail.com",
        cameraName: 'employee 10',
        // models: ['Model g', 'Model h'],
      ),
      CameraDetail(
        phone: '123456789',
        email: "omar@gmail.com",
        cameraName: 'employee 10',
        // models: ['Model g', 'Model h'],
      ),
      CameraDetail(
        phone: '123456789',
        email: "omar@gmail.com",
        cameraName: 'employee 10',
        // models: ['Model g', 'Model h'],
      ),
      CameraDetail(
        phone: '123456789',
        email: "omar@gmail.com",
        cameraName: 'employee 10',
        // models: ['Model g', 'Model h'],
      ),
      CameraDetail(
        phone: '123456789',
        email: "omar@gmail.com",
        cameraName: 'employee 10',
        // models: ['Model g', 'Model h'],
      ),
    ];

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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("All Employees".tr(),
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),

                          //Add Employee Button
                          MaterialButton(
                            height: 50,
                            minWidth: 210,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0)),
                            color: Colors.blueGrey,
                            onPressed: () {},
                            child: ConstText.largeText(
                              text: "Add Employee",
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FxBox.h24,
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _contactList.length,
                        gridDelegate: Responsive.isMobile(context)
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
                                : MediaQuery.of(context).size.width < 1500
                                    ? SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent:
                                            MediaQuery.of(context).size.width *
                                                0.24,
                                        crossAxisSpacing: 45,
                                        mainAxisSpacing: 45,
                                        mainAxisExtent: 350,
                                      )
                                    : SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent:
                                            MediaQuery.of(context).size.width *
                                                0.24,
                                        crossAxisSpacing: 45,
                                        mainAxisSpacing: 45,
                                        mainAxisExtent: 350,
                                      ),
                        itemBuilder: (context, index) {
                          return _contactUi(
                              name: _contactList[index]['name'],
                              profession: _contactList[index]['profession']);
                        },
                      ),
                    ),

                    // Wrap(
                    //     children: _responsiveCardList(
                    //         context: context, cameras: dummyEmployees)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _contactUi({
    required String name,
    required String profession,
  }) {
    return Container(
      width: 300,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
      decoration: BoxDecoration(
          color:
              // context.isDarkMode ?
              Colors.blueGrey,
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
                  color: Colors.black,
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
              const Icon(
                Icons.more_horiz,
                color: Colors.black,
              ),
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
  // List<Widget> _responsiveCardList({
  //   required BuildContext context,
  //   required List<CameraDetail> cameras,
  // }) {
  //   return List.generate(
  //       cameras.length,
  //       (index) => InkWell(
  //             onTap: () {
  //               Routemaster.of(context).push(
  //                 "/cameraDetails",
  //                 queryParameters: {"name": cameras[index].cameraName ?? ""},
  //               );
  //             },
  //             child: SizedBox(
  //                 width: Responsive.isMobile(context)
  //                     ? MediaQuery.of(context).size.width
  //                     : Responsive.isTablet(context)
  //                         ? MediaQuery.of(context).size.width * 0.45
  //                         : MediaQuery.of(context).size.width * 0.15,
  //                 height: 200,
  //                 child: _dataOfCamera(
  //                     name: cameras[index].cameraName ?? "",
  //                     phone: cameras[index].phone ?? "",
  //                     email: cameras[index].email ?? "",
  //                     // models: cameras[index].models ?? [],
  //                     context: context)),

  //             // List<Widget> _responsiveCardList(
  //             //     {required BuildContext context, required CameraState state}) {
  //             //   return List.generate(
  //             //       state.camerasDetails.length,
  //             //       (index) => InkWell(
  //             //             onTap: () {
  //             //               Routemaster.of(context).push(
  //             //                 "/cameraDetails",
  //             //                 queryParameters: {
  //             //                   "name": state.camerasDetails[index].cameraName ?? ""
  //             //                 },
  //             //               );
  //             //             },
  //             //             child: SizedBox(
  //             //                 width: Responsive.isMobile(context)
  //             //                     ? MediaQuery.of(context).size.width
  //             //                     : Responsive.isTablet(context)
  //             //                         ? MediaQuery.of(context).size.width * 0.45
  //             //                         : MediaQuery.of(context).size.width * 0.15,
  //             //                 height: 200,
  //             //                 child: _dataOfCamera(
  //             //                     name: state.camerasDetails[index].cameraName ?? "",
  //             //                     models: state.camerasDetails[index].models ?? [],
  //             //                     context: context)),

  //             //////////////////
  //             /////////////////
  //             /////////////////
  //             // child: Card(
  //             //   shadowColor: AppColors.blueBlack.withOpacity(0.5),
  //             //   elevation: 0,
  //             //   child: Container(
  //             //     width: Responsive.isMobile(context)
  //             //         ? MediaQuery.of(context).size.width
  //             //         : Responsive.isTablet(context)
  //             //             ? MediaQuery.of(context).size.width * 0.45
  //             //             : MediaQuery.of(context).size.width * 0.15,
  //             //     padding: const EdgeInsets.all(20.0),
  //             //     // decoration: BoxDecoration(
  //             //     //     gradient: LinearGradient(colors: [
  //             //     //
  //             //     //     ])),
  //             //     child: Column(
  //             //       children: [
  //             //         FxBox.h24,
  //             //         Text(state.camerasCounts[index].cameraName ?? ""),
  //             //         FxBox.h24,
  //             //         Text(state.camerasCounts[index].countAverage.toString()),
  //             //         FxBox.h24,
  //             //       ],
  //             //     ),
  //             //   ),
  //             // ),
  //           ));
  // }

  // Widget _dataOfCamera({
  //   required String name,
  //   required String phone,
  //   required String email,

  //   // required List<String> models,
  //   required BuildContext context,
  // }) {
  //   return Card(
  //     surfaceTintColor: Colors.transparent,
  //     elevation: 2,
  //     child: Padding(
  //       padding: const EdgeInsets.all(15),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Flexible(
  //             child: Text(
  //               name,
  //               maxLines: 3,
  //               style: const TextStyle(
  //                 fontSize: 20,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //             ),
  //           ),
  //           FxBox.h10,
  //           Flexible(
  //             child: Text(
  //               phone,
  //               maxLines: 3,
  //               style: const TextStyle(
  //                 fontSize: 20,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //             ),
  //           ),
  //           Flexible(
  //             child: Text(
  //               email,
  //               maxLines: 3,
  //               style: const TextStyle(
  //                 fontSize: 20,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //             ),
  //           ),
  //           // getCardBadgesRow(badgesList: models),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:Investigator/core/utils/responsive.dart';
// import 'package:Investigator/core/widgets/badge_builder.dart';
// import 'package:Investigator/core/widgets/sizedbox.dart';
// import 'package:Investigator/presentation/all_cameras/bloc/camera_bloc.dart';
// import 'package:Investigator/presentation/standard_layout/screens/standard_layout.dart';
// import 'package:routemaster/routemaster.dart';

// class AllCamerasScreen extends StatelessWidget {
//   const AllCamerasScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final List<Map<String, dynamic>> _contactList = [
//       {
//         'name': 'John Doe',
//         'profession': 'UI Designer',
//       },
//       {
//         'name': 'Samantha William',
//         'profession': 'UI Designer',
//       },
//       {
//         'name': 'Tony Soap',
//         'profession': 'Web Developer',
//       },
//       {
//         'name': 'Karen Hope',
//         'profession': 'Android Developer',
//       },
//       {
//         'name': 'Tatang Wijaya',
//         'profession': 'QA Engineer',
//       },
//       {
//         'name': 'Johnny Ahmad',
//         'profession': 'Product Owner',
//       },
//       {
//         'name': 'Jordan Nico',
//         'profession': 'Product Manager',
//       },
//       {
//         'name': 'Budi Prabowo',
//         'profession': 'ios Developer',
//       },
//       {
//         'name': 'Nadila Adja',
//         'profession': 'Graphic Designer',
//       },
//       {
//         'name': 'Azizi Azazel',
//         'profession': 'UX Engineer',
//       },
//       {
//         'name': 'Angelina Crispy',
//         'profession': 'Software Engineering',
//       },
//       {
//         'name': 'Ipi Antoinette',
//         'profession': 'VP Product',
//       },
//     ];
// // return SingleChildScrollView(
// //       child: Padding(
// //         padding: const EdgeInsets.symmetric(horizontal: 24.0),
// //         child: Column(
// //           children: [
// //             FxBox.h24,
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 const RouteTitle(),
// //                 MaterialButton(
// //                   height: 50,
// //                   minWidth: 210,
// //                   shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(4.0)),
// //                   color: ConstColor.primary,
// //                   onPressed: () {},
// //                   child: ConstText.largeText(
// //                     text: ConstString.addContact,
// //                     fontSize: 16,
// //                     color: ConstColor.white,
// //                     fontWeight: FontWeight.w500,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             FxBox.h28,
// //             SizedBox(
// //               width: MediaQuery.of(context).size.width,
// //               child: GridView.builder(
// //                 shrinkWrap: true,
// //                 physics: const NeverScrollableScrollPhysics(),
// //                 itemCount: _contactList.length,
// //                 gridDelegate: Responsive.isMobile(context)
// //                     ? const SliverGridDelegateWithFixedCrossAxisCount(
// //                         crossAxisCount: 1,
// //                         crossAxisSpacing: 45,
// //                         mainAxisSpacing: 45,
// //                         mainAxisExtent: 350,
// //                       )
// //                     : Responsive.isTablet(context)
// //                         ? const SliverGridDelegateWithFixedCrossAxisCount(
// //                             crossAxisCount: 2,
// //                             crossAxisSpacing: 45,
// //                             mainAxisSpacing: 45,
// //                             mainAxisExtent: 350,
// //                           )
// //                         : MediaQuery.of(context).size.width < 1500
// //                             ? SliverGridDelegateWithMaxCrossAxisExtent(
// //                                 maxCrossAxisExtent:
// //                                     MediaQuery.of(context).size.width * 0.24,
// //                                 crossAxisSpacing: 45,
// //                                 mainAxisSpacing: 45,
// //                                 mainAxisExtent: 350,
// //                               )
// //                             : SliverGridDelegateWithMaxCrossAxisExtent(
// //                                 maxCrossAxisExtent:
// //                                     MediaQuery.of(context).size.width * 0.24,
// //                                 crossAxisSpacing: 45,
// //                                 mainAxisSpacing: 45,
// //                                 mainAxisExtent: 350,
// //                               ),
// //                 itemBuilder: (context, index) {
// //                   return _contactUi(
// //                       name: _contactList[index]['name'],
// //                       profession: _contactList[index]['profession']);
// //                 },
// //               ),
// //             ),
// //             FxBox.h60,
// //             Responsive.isMobile(context) || Responsive.isTablet(context)
// //                 ? Column(
// //                     children: [
// //                       ConstText.lightText(
// //                         text: 'Showing ${pageIndex + 1} of 240 data',
// //                         fontSize: 14,
// //                         fontWeight: FontWeight.w400,
// //                         color: const Color(0xff98A4B5),
// //                       ),
// //                       FxBox.h32,
// //                       _button(),
// //                     ],
// //                   )
// //                 : _bottomFooter(),
// //             SafeArea(child: FxBox.h24),
// //           ],
// //         ),
// //       ),
// //     );

//     return StandardLayoutScreen(
//       body: BlocProvider(
//         create: (context) => CameraBloc()
//           ..add(const CameraMainDataEvent())
//           ..add(const CameraInitializeDate()),
//         child: BlocBuilder<CameraBloc, CameraState>(
//           builder: (context, state) {
//             // Dummy camera details data
//             List<CameraDetail> dummyEmployees = [
//               CameraDetail(
//                 cameraName: 'employee 1',
//                 models: ['Model A', 'Model B'],
//               ),
//               CameraDetail(
//                 cameraName: 'employee 2',
//                 models: ['Model C', 'Model D'],
//               ),
//               CameraDetail(
//                 cameraName: 'employee 3',
//                 models: ['Model e', 'Model f'],
//               ),
//               CameraDetail(
//                 cameraName: 'employee 4',
//                 models: ['Model g', 'Model h'],
//               ),
//               CameraDetail(
//                 cameraName: 'employee 6',
//                 models: ['Model g', 'Model h'],
//               ),
//               CameraDetail(
//                 cameraName: 'employee 7',
//                 models: ['Model g', 'Model h'],
//               ),
//               CameraDetail(
//                 cameraName: 'employee 8',
//                 models: ['Model g', 'Model h'],
//               ),
//               CameraDetail(
//                 cameraName: 'employee 9',
//                 models: ['Model g', 'Model h'],
//               ),
//               CameraDetail(
//                 cameraName: 'employee 10',
//                 models: ['Model g', 'Model h'],
//               ),
//               CameraDetail(
//                 cameraName: 'employee 10',
//                 models: ['Model g', 'Model h'],
//               ),
//               CameraDetail(
//                 cameraName: 'employee 10',
//                 models: ['Model g', 'Model h'],
//               ),
//               CameraDetail(
//                 cameraName: 'employee 10',
//                 models: ['Model g', 'Model h'],
//               ),
//               CameraDetail(
//                 cameraName: 'employee 10',
//                 models: ['Model g', 'Model h'],
//               ),
//               CameraDetail(
//                 cameraName: 'employee 10',
//                 models: ['Model g', 'Model h'],
//               ),
//             ];

//             return Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     FxBox.h24,
//                     SizedBox(
//                       width: double.infinity,
//                       child: Text(
//                         "All Employees".tr(),
//                         style: const TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     FxBox.h24,
//                     Wrap(
//                       children: _responsiveCardList(
//                         context: context,
//                         cameras: dummyEmployees,
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

//   List<Widget> _responsiveCardList({
//     required BuildContext context,
//     required List<CameraDetail> cameras,
//   }) {
//     return cameras.map((camera) {
//       return InkWell(
//         onTap: () {
//           Routemaster.of(context).push(
//             "/cameraDetails",
//             queryParameters: {"name": camera.cameraName},
//           );
//         },
//         child: SizedBox(
//           width: Responsive.isMobile(context)
//               ? MediaQuery.of(context).size.width
//               : Responsive.isTablet(context)
//                   ? MediaQuery.of(context).size.width * 0.45
//                   : MediaQuery.of(context).size.width * 0.15,
//           height: 200,
//           child: Card(
//             elevation: 2,
//             child: Padding(
//               padding: const EdgeInsets.all(15),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Flexible(
//                     child: Text(
//                       camera.cameraName,
//                       maxLines: 3,
//                       style: const TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                   FxBox.h10,
//                   getCardBadgesRow(badgesList: camera.models),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       );
//     }).toList();
//   }

// }

class CameraDetail {
  final String phone;
  final String email;
  final String cameraName;
  // final List<String> models;

  CameraDetail(
      {required this.cameraName, required this.phone, required this.email});
}
