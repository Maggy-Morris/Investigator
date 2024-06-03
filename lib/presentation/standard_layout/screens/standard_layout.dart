import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Investigator/core/resources/adaptive.dart';
import 'package:Investigator/core/resources/app_colors.dart';
import 'package:Investigator/core/resources/app_fonts.dart';
import 'package:Investigator/presentation/standard_layout/bloc/standard_layout_cubit.dart';
import 'package:Investigator/presentation/standard_layout/widgets/main_app_bar.dart';
import 'package:Investigator/presentation/standard_layout/widgets/navigation_rail_header.dart';
import 'package:routemaster/routemaster.dart';

class StandardLayoutScreen extends StatelessWidget {
  const StandardLayoutScreen({
    Key? key,
    this.title,
    this.actions,
    this.leading,
    this.leadingWidth,
    required this.body,
  }) : super(key: key);

  final String? title;
  final Widget? leading;
  final double? leadingWidth;
  final List<Widget>? actions;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: mainDrawer(context),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //       begin: Alignment.topLeft,
        //       end: Alignment.bottomRight,
        //       colors: [
        //         AppColors.blue.withOpacity(0.3),
        //         AppColors.blue.withOpacity(0.5),
        //         AppColors.blue.withOpacity(0.3),
        //       ]),
        // ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocProvider.value(
              value: StandardLayoutCubit.get(context),
              child: BlocBuilder<StandardLayoutCubit, StandardLayoutState>(
                builder: (context, state) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      if (!isDisplayDesktop(context)) {
                        StandardLayoutCubit.get(context).onEditExtend(false);
                      } else {
                        StandardLayoutCubit.get(context)
                            .onEditExtend(state.extend);
                      }
                      return SingleChildScrollView(
                        clipBehavior: Clip.antiAlias,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                              maxWidth: (state.extend) ? 240 : double.infinity),
                          child: IntrinsicHeight(
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                  // colorScheme: const ColorScheme.light(
                                  //   primary: AppColors.blueBlack,
                                  // ),
                                  ),
                              child: NavigationRailTheme(
                                data: NavigationRailThemeData(
                                    useIndicator: true,
                                    labelType: (!state.extend)
                                        ? NavigationRailLabelType.selected
                                        : NavigationRailLabelType.none,
                                    backgroundColor: AppColors.blueB,
                                    indicatorColor:
                                        AppColors.grey.withOpacity(0.3),
                                    selectedLabelTextStyle: const TextStyle(
                                      fontFamily: "Cairo",
                                      fontSize: AppFontSize.s20,
                                      color: AppColors.white,
                                    ),
                                    unselectedLabelTextStyle: const TextStyle(
                                      fontFamily: "Cairo",
                                      fontSize: AppFontSize.s18,
                                      color: AppColors.white,
                                    ),
                                    selectedIconTheme: const IconThemeData(
                                      color: Colors.white,
                                    ),
                                    unselectedIconTheme: const IconThemeData(
                                      color: AppColors.white,
                                    )),
                                child: NavigationRail(
                                  destinations: [
                                    // NavigationRailDestination(
                                    //   icon: const Icon(Icons.dashboard),
                                    //   selectedIcon: const Icon(
                                    //     Icons.dashboard,
                                    //   ),
                                    //   label: Text('All'.tr()),
                                    // ),

                                    NavigationRailDestination(
                                      icon: const Icon(Icons.person_outlined),
                                      selectedIcon: const Icon(
                                        Icons.person_outlined,
                                      ),
                                      label: Text('AllPeople'.tr()),
                                    ),

                                    NavigationRailDestination(
                                      icon: const Icon(Icons.search),
                                      selectedIcon: const Icon(
                                        Icons.search,
                                      ),
                                      label: Text('Search'.tr()),
                                    ),

                                    NavigationRailDestination(
                                      icon: const Icon(
                                          Icons.model_training_outlined),
                                      selectedIcon: const Icon(
                                        Icons.model_training_outlined,
                                      ),
                                      label: Text('Investigator'.tr()),
                                    ),

                                    NavigationRailDestination(
                                      icon: const Icon(
                                          Icons.supervisor_account_outlined),
                                      selectedIcon: const Icon(
                                        Icons.supervisor_account_outlined,
                                      ),
                                      label: Text('DatabaseSearch'.tr()),
                                    ),

                                    NavigationRailDestination(
                                      icon: const Icon(
                                          Icons.manage_history_rounded),
                                      selectedIcon: const Icon(
                                          Icons.manage_history_rounded),
                                      label: Text('History'.tr()),
                                    ),

                                    NavigationRailDestination(
                                      icon: const Icon(Icons.settings),
                                      selectedIcon: const Icon(
                                        Icons.settings,
                                      ),
                                      label: Text('Settings'.tr()),
                                    ),

                                    /// Language
                                    ///
                                    // NavigationRailDestination(
                                    //   icon: const Icon(Icons.language_outlined),
                                    //   selectedIcon: const Icon(
                                    //     Icons.language_outlined,
                                    //   ),
                                    //   label: Text('changeLanguage'.tr()),
                                    // ),

                                    /// sign out
                                    ///
                                    // NavigationRailDestination(
                                    //   icon: const Icon(Icons.logout),
                                    //   selectedIcon: const Icon(
                                    //     Icons.logout,
                                    //   ),
                                    //   label: Text('logout'.tr()),
                                    // ),
                                  ],
                                  extended: state.extend,
                                  leading: NavigationRailHeader(
                                    isExpanded: state.extend,
                                    extended: () =>
                                        StandardLayoutCubit.get(context)
                                            .onEditExtend(!state.extend),
                                    logo: Image.asset(
                                      'assets/images/ico.png',
                                      width: 150,
                                      height: 150,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  selectedIndex: state.selectedPage,
                                  trailing: Container(
                                    margin: const EdgeInsets.only(top: 20),
                                    child: (state.extend)
                                        ? ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.scaffoldBackGround,
                                            ),
                                            icon: const Icon(
                                              Icons.logout,
                                            ),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (ctx) {
                                                  return AlertDialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    icon: const Icon(
                                                      Icons.warning,
                                                      color: Colors.amber,
                                                    ),
                                                    title: Text(
                                                      "areYouSureLogOut".tr(),
                                                      style: const TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                          child: Text(
                                                            "yes".tr(),
                                                            style: const TextStyle(
                                                                color: AppColors
                                                                    .thinkRedColor),
                                                          ),
                                                          onPressed: () async {
                                                            Navigator.of(ctx)
                                                                .pop();
                                                            // Navigator.of(ctx)
                                                            //     .pop();

                                                            await logout(
                                                                context);
                                                          }),
                                                      TextButton(
                                                          child: Text(
                                                            "no".tr(),
                                                            style: const TextStyle(
                                                                color: AppColors
                                                                    .green),
                                                          ),
                                                          onPressed: () =>
                                                              Navigator.of(ctx)
                                                                  .pop()),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            label: Text('logout'.tr()),
                                          )
                                        : IconButton(
                                            style: IconButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.scaffoldBackGround,
                                            ),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (ctx) {
                                                  return AlertDialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    icon: const Icon(
                                                      Icons.warning,
                                                      color: Colors.amber,
                                                    ),
                                                    title: Text(
                                                      "areYouSureLogOut".tr(),
                                                      style: const TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                          child: Text(
                                                            "yes".tr(),
                                                            style: const TextStyle(
                                                                color: AppColors
                                                                    .thinkRedColor),
                                                          ),
                                                          onPressed: () async {
                                                            Navigator.of(ctx)
                                                                .pop();
                                                            await logout(
                                                                context);
                                                          }),
                                                      TextButton(
                                                          child: Text(
                                                            "no".tr(),
                                                            style: const TextStyle(
                                                                color: AppColors
                                                                    .blueBlack),
                                                          ),
                                                          onPressed: () =>
                                                              Navigator.of(ctx)
                                                                  .pop()),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            icon: const Icon(Icons.logout)),
                                  ),
                                  onDestinationSelected: (index) {
                                    EasyLoading.dismiss();
                                    StandardLayoutCubit.get(context)
                                        .onEditPageNavigationNumber(index);

                                    if (index == 0) {
                                      Routemaster.of(context).push('/');
                                      // Routemaster.of(context).push('/home');
                                    } else if (index == 1) {
                                      Routemaster.of(context).push('/search');
                                    } else if (index == 2) {
                                      Routemaster.of(context)
                                          .push('/investigator');
                                    } else if (index == 3) {
                                      Routemaster.of(context)
                                          .push('/databaseSearch');


                                    } else if (index == 4) {
                                      Routemaster.of(context).push('/history');
                                    }
                                     else if (index == 5) {
                                      Routemaster.of(context).push('/settings');
                                    }
                                    ///////////////////////////////////////////////////////////////////////////////
                                    // else if (index == 4) {
                                    //   Routemaster.of(context)
                                    //       .push('/managementScreen');
                                    // }
                                    // else if (index == 4) {
                                    //   Routemaster.of(context)
                                    //       .push('/managementScreen');
                                    // }
                                    // else if (index == 6) {
                                    //   // await context.setLocale(const Locale("ar"));
                                    //   if (!kIsWeb) {
                                    //     showModalBottomSheet(
                                    //       context: context,
                                    //       shape: const RoundedRectangleBorder(
                                    //           borderRadius: BorderRadius.only(
                                    //               topLeft: Radius.circular(20),
                                    //               topRight:
                                    //                   Radius.circular(20))),
                                    //       // backgroundColor: const Color(0xFF6F0014),
                                    //       backgroundColor: AppColors.mediumBlue,
                                    //       builder: (context) {
                                    //         return Column(
                                    //           children: [
                                    //             ListTile(
                                    //               title: const Text("عربي",
                                    //                   style: TextStyle(
                                    //                       color: Colors.white,
                                    //                       fontWeight:
                                    //                           FontWeight.bold)),
                                    //               onTap: () async {
                                    //                 await context
                                    //                     .setLocale(
                                    //                         const Locale("ar"))
                                    //                     .then((value) =>
                                    //                         Navigator.of(
                                    //                                 context)
                                    //                             .pop());
                                    //               },
                                    //             ),
                                    //             const Divider(),
                                    //             ListTile(
                                    //               title: const Text("English",
                                    //                   style: TextStyle(
                                    //                       color: Colors.white,
                                    //                       fontWeight:
                                    //                           FontWeight.bold)),
                                    //               onTap: () async {
                                    //                 await context
                                    //                     .setLocale(
                                    //                         const Locale("en"))
                                    //                     .then((value) =>
                                    //                         Navigator.of(
                                    //                                 context)
                                    //                             .pop());
                                    //               },
                                    //             ),
                                    //             const Divider(),
                                    //             ListTile(
                                    //               title: const Text("Français",
                                    //                   style: TextStyle(
                                    //                       color: Colors.white,
                                    //                       fontWeight:
                                    //                           FontWeight.bold)),
                                    //               onTap: () async {
                                    //                 await context
                                    //                     .setLocale(
                                    //                         const Locale("fr"))
                                    //                     .then((value) =>
                                    //                         Navigator.of(
                                    //                                 context)
                                    //                             .pop());
                                    //               },
                                    //             ),
                                    //             const Divider(),
                                    //             ListTile(
                                    //               title: const Text("Español",
                                    //                   style: TextStyle(
                                    //                       color: Colors.white,
                                    //                       fontWeight:
                                    //                           FontWeight.bold)),
                                    //               onTap: () async {
                                    //                 await context
                                    //                     .setLocale(
                                    //                         const Locale("es"))
                                    //                     .then((value) =>
                                    //                         Navigator.of(
                                    //                                 context)
                                    //                             .pop());
                                    //               },
                                    //             ),
                                    //             const Divider(),
                                    //             ListTile(
                                    //               title: const Text("Italiano",
                                    //                   style: TextStyle(
                                    //                       color: Colors.white,
                                    //                       fontWeight:
                                    //                           FontWeight.bold)),
                                    //               onTap: () async {
                                    //                 await context
                                    //                     .setLocale(
                                    //                         const Locale("it"))
                                    //                     .then((value) =>
                                    //                         Navigator.of(
                                    //                                 context)
                                    //                             .pop());
                                    //               },
                                    //             ),
                                    //           ],
                                    //         );
                                    //       },
                                    //     );
                                    //   } else {
                                    //     showDialog(
                                    //       context: context,
                                    //       // shape: const RoundedRectangleBorder(
                                    //       //     borderRadius: BorderRadius.only(
                                    //       //         topLeft: Radius.circular(20),
                                    //       //         topRight: Radius.circular(20))),
                                    //       // backgroundColor: const Color(0xFF6F0014),
                                    //       builder: (context) {
                                    //         return AlertDialog(
                                    //           content: Column(
                                    //             children: [
                                    //               ListTile(
                                    //                 title: const Text("عربي",
                                    //                     style: TextStyle(
                                    //                         color: Colors.white,
                                    //                         fontWeight:
                                    //                             FontWeight
                                    //                                 .bold)),
                                    //                 onTap: () async {
                                    //                   await context
                                    //                       .setLocale(
                                    //                           const Locale(
                                    //                               "ar"))
                                    //                       .then((value) =>
                                    //                           Navigator.of(
                                    //                                   context)
                                    //                               .pop());
                                    //                 },
                                    //               ),
                                    //               const Divider(),
                                    //               ListTile(
                                    //                 title: const Text("English",
                                    //                     style: TextStyle(
                                    //                         color: Colors.white,
                                    //                         fontWeight:
                                    //                             FontWeight
                                    //                                 .bold)),
                                    //                 onTap: () async {
                                    //                   await context
                                    //                       .setLocale(
                                    //                           const Locale(
                                    //                               "en"))
                                    //                       .then((value) =>
                                    //                           Navigator.of(
                                    //                                   context)
                                    //                               .pop());
                                    //                 },
                                    //               ),
                                    //               const Divider(),
                                    //               ListTile(
                                    //                 title: const Text(
                                    //                     "Français",
                                    //                     style: TextStyle(
                                    //                         color: Colors.white,
                                    //                         fontWeight:
                                    //                             FontWeight
                                    //                                 .bold)),
                                    //                 onTap: () async {
                                    //                   await context
                                    //                       .setLocale(
                                    //                           const Locale(
                                    //                               "fr"))
                                    //                       .then((value) =>
                                    //                           Navigator.of(
                                    //                                   context)
                                    //                               .pop());
                                    //                 },
                                    //               ),
                                    //               const Divider(),
                                    //               ListTile(
                                    //                 title: const Text("Español",
                                    //                     style: TextStyle(
                                    //                         color: Colors.white,
                                    //                         fontWeight:
                                    //                             FontWeight
                                    //                                 .bold)),
                                    //                 onTap: () async {
                                    //                   await context
                                    //                       .setLocale(
                                    //                           const Locale(
                                    //                               "es"))
                                    //                       .then((value) =>
                                    //                           Navigator.of(
                                    //                                   context)
                                    //                               .pop());
                                    //                 },
                                    //               ),
                                    //               const Divider(),
                                    //               ListTile(
                                    //                 title: const Text(
                                    //                     "Italiano",
                                    //                     style: TextStyle(
                                    //                         color: Colors.white,
                                    //                         fontWeight:
                                    //                             FontWeight
                                    //                                 .bold)),
                                    //                 onTap: () async {
                                    //                   await context
                                    //                       .setLocale(
                                    //                           const Locale(
                                    //                               "it"))
                                    //                       .then((value) =>
                                    //                           Navigator.of(
                                    //                                   context)
                                    //                               .pop());
                                    //                 },
                                    //               ),
                                    //             ],
                                    //           ),
                                    //         );
                                    //       },
                                    //     );
                                    //   }
                                    // }
                                    // else if (index == 3) {
                                    //   showDialog(
                                    //     context: context,
                                    //     builder: (ctx) {
                                    //       return AlertDialog(
                                    //         shape: RoundedRectangleBorder(
                                    //           borderRadius:
                                    //               BorderRadius.circular(15),
                                    //         ),
                                    //         icon: const Icon(
                                    //           Icons.warning,
                                    //           color: Colors.amber,
                                    //         ),
                                    //         title: Text(
                                    //           "areYouSureLogOut".tr(),
                                    //           style: const TextStyle(
                                    //               color: Colors.black),
                                    //         ),
                                    //         actions: [
                                    //           TextButton(
                                    //               child: Text(
                                    //                 "yes".tr(),
                                    //                 style: const TextStyle(
                                    //                     color: AppColors
                                    //                         .thinkRedColor),
                                    //               ),
                                    //               onPressed: () async {
                                    //                 Navigator.of(ctx).pop();
                                    //                 await logout(context);
                                    //               }),
                                    //           TextButton(
                                    //               child: Text(
                                    //                 "no".tr(),
                                    //                 style: const TextStyle(
                                    //                     color: AppColors
                                    //                         .blueBlack),
                                    //               ),
                                    //               onPressed: () =>
                                    //                   Navigator.of(ctx).pop()),
                                    //         ],
                                    //       );
                                    //     },
                                    //   );
                                    // }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Expanded(
                child: Scaffold(
                    backgroundColor: AppColors.grey2,
                    appBar: mainAppBar(
                      leading: leading,
                      title: title,
                      actions: actions,
                      leadingWidth: leadingWidth,
                    ),
                    body: Padding(
                        padding: const EdgeInsets.all(8), child: body))),
          ],
        ),
        // child: Column(
        //   children: [
        //     Container(
        //       height: 30,
        //       width: double.infinity,
        //       margin: const EdgeInsets.all(5),
        //       padding: const EdgeInsets.all(5),
        //       child: ListView.separated(
        //         shrinkWrap: true,
        //         scrollDirection: Axis.horizontal,
        //         itemCount: routesList.length,
        //         physics: const BouncingScrollPhysics(),
        //         itemBuilder: (ctx, index) {
        //           return OutlinedButton(
        //             onPressed: () {
        //               Routemaster.of(context).push(
        //                   routesList[index].split("?").first,
        //                   queryParameters: {
        //                     "id": routesList[index]
        //                         .split("?")
        //                         .last
        //                         .replaceAll("/", "")
        //                   });
        //             },
        //             child: Text(
        //               mappedRoutesList[index],
        //               style: const TextStyle(
        //                   color: Colors.blueGrey,
        //                   fontFamily: "Cairo",
        //                   fontWeight: FontWeight.bold),
        //             ),
        //           );
        //         },
        //         separatorBuilder: (context, index) => Container(
        //             margin: const EdgeInsets.symmetric(horizontal: 10),
        //             child: const Icon(Icons.navigate_next)),
        //       ),
        //     ),
        //     Expanded(child: body),
        //   ],
        // ),
      ),
    );
  }
}
