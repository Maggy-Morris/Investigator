import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:Investigator/authentication/auth_bloc/app_bloc.dart';
import 'package:Investigator/core/resources/app_colors.dart';
import 'package:routemaster/routemaster.dart';

logout(BuildContext context) {
  Routemaster.of(context).replace("/");
  AppBloc.get(context).add(AppLogoutRequested());
  // Navigator.of(context).pushReplacementNamed(checkAuthority());
}

AppBar mainAppBar(
    {String? title,
    Widget? leading,
    double? leadingWidth,
    List<Widget>? actions}) {
  return AppBar(
    scrolledUnderElevation: 0.0,

    title: Text(
      (title?.isNotEmpty ?? false) ? title ?? "Investigator" : "Investigator",
      style: const TextStyle(color: AppColors.white, fontFamily: "Cairo"),
    ),
    automaticallyImplyLeading: false,
    leading: leading,
    leadingWidth: leadingWidth,
    actions: actions,
    centerTitle: true,
    iconTheme: const IconThemeData(
      color: AppColors.blueBlack,
    ),
    // shape: const RoundedRectangleBorder(
    //   borderRadius: BorderRadius.vertical(
    //     bottom: Radius.circular(15),
    //   ),
    // ),
    // backgroundColor: Colors.blueGrey[300],
    backgroundColor: AppColors.backGround,
    elevation: 0,
  );
}

Drawer mainDrawer(BuildContext context) {
  return Drawer(
    backgroundColor: AppColors.blue,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.horizontal(
        left: Radius.circular(15),
      ),
    ),
    child: ListView(
      shrinkWrap: true,
      children: [
        Container(
            margin: const EdgeInsets.all(10),
            child: const Divider(
              color: Colors.transparent,
            )),

        /// Language
        ListTile(
          title: Text(
            "changeLanguage".tr(),
            style: const TextStyle(
                fontFamily: "Cairo",
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.white),
          ),
          leading: const Icon(Icons.language_outlined, color: Colors.white),
          onTap: () async {
            // await context.setLocale(const Locale("ar"));
            if (!kIsWeb) {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                // backgroundColor: const Color(0xFF6F0014),
                backgroundColor: AppColors.mediumBlue,
                builder: (context) {
                  return Column(
                    children: [
                      ListTile(
                        title: const Text("عربي",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        onTap: () async {
                          await context
                              .setLocale(const Locale("ar"))
                              .then((value) => Navigator.of(context).pop());
                        },
                      ),
                      const Divider(),
                      ListTile(
                        title: const Text("English",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        onTap: () async {
                          await context
                              .setLocale(const Locale("en"))
                              .then((value) => Navigator.of(context).pop());
                        },
                      ),
                      const Divider(),
                      ListTile(
                        title: const Text("Français",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        onTap: () async {
                          await context
                              .setLocale(const Locale("fr"))
                              .then((value) => Navigator.of(context).pop());
                        },
                      ),
                      const Divider(),
                      ListTile(
                        title: const Text("Español",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        onTap: () async {
                          await context
                              .setLocale(const Locale("es"))
                              .then((value) => Navigator.of(context).pop());
                        },
                      ),
                      const Divider(),
                      ListTile(
                        title: const Text("Italiano",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        onTap: () async {
                          await context
                              .setLocale(const Locale("it"))
                              .then((value) => Navigator.of(context).pop());
                        },
                      ),
                    ],
                  );
                },
              );
            } else {
              showDialog(
                context: context,
                // shape: const RoundedRectangleBorder(
                //     borderRadius: BorderRadius.only(
                //         topLeft: Radius.circular(20),
                //         topRight: Radius.circular(20))),
                // backgroundColor: const Color(0xFF6F0014),
                builder: (context) {
                  return Dialog(
                    child: Column(
                      children: [
                        ListTile(
                          title: const Text("عربي",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          onTap: () async {
                            await context
                                .setLocale(const Locale("ar"))
                                .then((value) => Navigator.of(context).pop());
                          },
                        ),
                        const Divider(),
                        ListTile(
                          title: const Text("English",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          onTap: () async {
                            await context
                                .setLocale(const Locale("en"))
                                .then((value) => Navigator.of(context).pop());
                          },
                        ),
                        const Divider(),
                        ListTile(
                          title: const Text("Français",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          onTap: () async {
                            await context
                                .setLocale(const Locale("fr"))
                                .then((value) => Navigator.of(context).pop());
                          },
                        ),
                        const Divider(),
                        ListTile(
                          title: const Text("Español",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          onTap: () async {
                            await context
                                .setLocale(const Locale("es"))
                                .then((value) => Navigator.of(context).pop());
                          },
                        ),
                        const Divider(),
                        ListTile(
                          title: const Text("Italiano",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          onTap: () async {
                            await context
                                .setLocale(const Locale("it"))
                                .then((value) => Navigator.of(context).pop());
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),

        /// sign out
        ListTile(
          title: Text(
            "logout".tr(),
            style: const TextStyle(
                fontFamily: "Cairo",
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.white),
          ),
          leading: const Icon(Icons.logout, color: Colors.white),
          onTap: () {
            showDialog(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  icon: const Icon(
                    Icons.warning,
                    color: Colors.amber,
                  ),
                  title: Text(
                    "areYouSureLogOut".tr(),
                    style: const TextStyle(color: Colors.black),
                  ),
                  actions: [
                    TextButton(
                        child: Text(
                          "yes".tr(),
                          style:
                              const TextStyle(color: AppColors.thinkRedColor),
                        ),
                        onPressed: () async {
                          Navigator.of(ctx).pop();
                          await logout(context);
                        }),
                    TextButton(
                        child: Text(
                          "no".tr(),
                          style: const TextStyle(color: AppColors.blueBlack),
                        ),
                        onPressed: () => Navigator.of(ctx).pop()),
                  ],
                );
              },
            );
            // AppBloc.get(context).add(AppLogoutRequested());
          },
        ),
      ],
    ),
  );
}
