import 'package:Investigator/core/enum/enum.dart';
import 'package:Investigator/core/utils/responsive.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import flutter_bloc for BlocProvider

import '../../../authentication/authentication_repository.dart';
import '../../../core/resources/app_colors.dart';
// import '../../../core/utils/responsive.dart';
import '../../../core/widgets/customTextField.dart';
import '../../../core/widgets/sizedbox.dart';
import '../../../core/widgets/toast/toast.dart';
import '../../standard_layout/screens/standard_layout.dart';
import '../bloc/settings_bloc.dart'; // Import your settings_bloc file

class Settings extends StatefulWidget {
  Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return StandardLayoutScreen(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => SettingsBloc()
              ..add(InitialList(
                  list: AuthenticationRepository
                          .instance.currentUser.roomsNames ??
                      [])),
          ),
        ],
        child: BlocListener<SettingsBloc, SettingsState>(
          listener: (context, state) {
            if (state.submission == Submission.success) {
              FxToast.showSuccessToast(
                  context: context,
                  message: state.responseMessage.isNotEmpty
                      ? state.responseMessage
                      : null);
            }
            if (state.submission == Submission.error) {
              FxToast.showErrorToast(
                  context: context,
                  message: state.responseMessage.isNotEmpty
                      ? state.responseMessage
                      : null);
            }
            if (state.submission == Submission.noDataFound) {
              FxToast.showWarningToast(
                  context: context, warningMessage: "Couldn't Update Rooms");
            }
          },
          child: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              return Card(
                margin: const EdgeInsets.all(20),
                color: AppColors.grey5,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildInputCard(
                            'Email',
                            AuthenticationRepository
                                    .instance.currentUser.username ??
                                "",
                            (value) {
                              // Update email state
                            },
                            true,
                            TextButton(
                              onPressed: () {
                                // Show dialog to fill in employee data
                                showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    return BlocProvider.value(
                                      value: SettingsBloc.get(context),
                                      child: BlocBuilder<SettingsBloc,
                                          SettingsState>(
                                        builder: (context, state) {
                                          return AlertDialog(
                                            title: const SizedBox(
                                              child: Text(
                                                "Change Password",
                                                style: TextStyle(
                                                    color: AppColors.white),
                                              ),
                                            ),
                                            content: SingleChildScrollView(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  buildTextFormField(
                                                    labelText: 'Old Password',
                                                    onChanged: (value) async {
                                                      SettingsBloc.get(context)
                                                          .add(
                                                        oldPasswordEvent(
                                                            oldpassword: value),
                                                      );
                                                    },
                                                  ),
                                                  FxBox.h24,
                                                  buildTextFormField(
                                                    labelText: 'New Password',
                                                    onChanged: (value) async {
                                                      SettingsBloc.get(context)
                                                          .add(
                                                        UpdatePasswordEvent(
                                                            passwordUpd: value),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Close the dialog
                                                },
                                                child: const Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  if (state
                                                      .oldpassword.isEmpty) {
                                                    FxToast.showErrorToast(
                                                        context: context,
                                                        message:
                                                            "Fill The Old Password");
                                                    return;
                                                  }
                                                  if (state
                                                      .passwordUpdate.isEmpty) {
                                                    FxToast.showErrorToast(
                                                        context: context,
                                                        message:
                                                            "Fill The New Password");
                                                    return;
                                                  }

                                                  SettingsBloc.get(context).add(
                                                    const UpdatePassword(),
                                                  );
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text(
                                                  'Confirm',
                                                  style: TextStyle(
                                                      color: AppColors.black),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                              child: const Text(
                                'Change Password',
                                style: TextStyle(
                                  color: AppColors.thinkRedColor,
                                ),
                              ), // Specify the text
                            ),
                            (Responsive.isWeb(context)) ? 500 : 250,
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Rooms Names',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.roomNAMS.length,
                          itemBuilder: (context, index) {
                            TextEditingController controller =
                                TextEditingController(
                                    text: state.roomNAMS[index]);
                            return Card(
                              margin: const EdgeInsets.only(bottom: 20),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child:
                                            // Builder(builder: (context) {
                                            //   return
                                            TextFormField(
                                      textDirection: TextDirection.ltr,
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                      controller: controller,
                                      onChanged: (value) {
                                        if (value.isNotEmpty) {
                                          SettingsBloc.get(context).add(
                                            UpdateRoomsEvent(
                                              checks: true,
                                              // index: index,
                                            ),
                                          );

                                          SettingsBloc.get(context).add(
                                            UpdateRoomsEventToList(
                                              roomNames: value,
                                              index: index,
                                            ),
                                          );
                                        } else if (value.isEmpty) {
                                          SettingsBloc.get(context).add(
                                            UpdateRoomsEvent(
                                              checks: false,
                                              // index: index,
                                            ),
                                          );
                                        }
                                      },
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        // suffix:
                                      ),
                                    )
                                        //   ;
                                        // }),
                                        ),
                                    IconButton(
                                      onPressed: () {
                                        // setState(() {

                                        showDialog(
                                          context: context,
                                          builder: (ctx) {
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              icon: const Icon(
                                                Icons.warning,
                                                color: Colors.red,
                                              ),
                                              title: Text(
                                                "Are you sure you want to remove this Room?"
                                                    .tr(),
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
                                                      SettingsBloc.get(context)
                                                          .add(
                                                        UpdateRoomsEventToList(
                                                          // roomNames: ,
                                                          index: index,
                                                        ),
                                                      );
                                                      SettingsBloc.get(context)
                                                          .add(
                                                        const UpdateRooms(),
                                                      );

                                                      Navigator.of(ctx).pop();
                                                    }),
                                                TextButton(
                                                    child: Text(
                                                      "no".tr(),
                                                      style: const TextStyle(
                                                          color:
                                                              AppColors.green),
                                                    ),
                                                    onPressed: () =>
                                                        Navigator.of(ctx)
                                                            .pop()),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      // },
                                      icon: const Icon(
                                        Icons.remove_circle,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Tooltip(
                        message: "open New Slot",
                        child: IconButton(
                          onPressed: () {
                            SettingsBloc.get(context).add(const AddListItem());
                          },
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                              onPressed: () async {
                                if (state.check == false) {
                                  FxToast.showErrorToast(
                                    context: context,
                                    message: "please fill the room name first",
                                  );
                                  return;
                                }
                                SettingsBloc.get(context).add(
                                  const UpdateRooms(),
                                );

                                SettingsBloc.get(context).add(
                                  const UpdateRoomsEvent(
                                    checks: false,
                                    // index: index,
                                  ),
                                );
                              },
                              child: const Text("Add The Rooms")),
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
}

Widget _buildInputCard(
  String title,
  String value,
  void Function(String) onChanged,
  bool readOnly, // Add a bool parameter for read-only state
  TextButton? suffixTextButton,
  double siz, // Add an optional suffix text button parameter
) {
  return SizedBox(
    width: siz,
    child: Card(
      color: AppColors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (suffixTextButton != null) suffixTextButton,
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              readOnly:
                  readOnly, // Set readOnly based on the provided parameter
              style: TextStyle(color: Colors.black),
              controller: TextEditingController(text: value),
              onChanged: onChanged,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
