import 'package:Investigator/authentication/auth_bloc/app_bloc.dart';
import 'package:Investigator/core/enum/enum.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import flutter_bloc for BlocProvider

import '../../../authentication/authentication_repository.dart';
import '../../../core/resources/app_colors.dart';
// import '../../../core/utils/responsive.dart';
import '../../../core/widgets/toast/toast.dart';
import '../../standard_layout/screens/standard_layout.dart';
import '../bloc/settings_bloc.dart'; // Import your settings_bloc file

class Settings extends StatefulWidget {
  Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}
// final AuthenticationRepository authenticationRepository =
//       await AuthenticationRepository.getInstance();

class _SettingsState extends State<Settings> {
  // TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<String> roomNames =
        AuthenticationRepository.instance.currentUser.roomsNames ?? [];
    print(roomNames);
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
          // BlocProvider(
          //   create: (context) => AppBloc(
          //       authenticationRepository:
          //          AuthenticationRepository.getInstance()),
          // ),
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
                  context: context,
                  warningMessage: "NO data found about this person");
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
                          const Text(
                            'Rooms Names',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Tooltip(
                            message: "Add Room",
                            child: IconButton(
                              onPressed: () {
                                SettingsBloc.get(context)
                                    .add(const AddListItem());
                                // setState(() {
                                //   roomNames.add('');
                                // });
                                // Pass the updated roomNames list to SettingsBloc
                                // SettingsBloc.get(context).add(
                                //   UpdateRoomsEvent(
                                //       roomNames: roomNames,
                                //       room_num: roomNames.length),
                                // );
                              },
                              icon: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 25,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
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
                                      child: TextFormField(
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                        controller: controller,
                                        textAlign: TextAlign
                                            .start, // Set text alignment to start

                                        onChanged: (value) {
                                          // setState(() {
                                          //   // Update the value in the roomNames list
                                          // roomNames[index] = value;
                                          // });
                                          // if (state.submission ==
                                          //     Submission.success) {
                                          //   AuthenticationRepository.instance
                                          //       .updateRoomsNames(roomNames);
                                          // }

                                          // state.submission == Submission.success ? await AuthenticationRepository.instance.updateRoomsNames(roomNames);

                                          SettingsBloc.get(context).add(
                                            UpdateRoomsEvent(
                                              roomNames: value,
                                              index: index,
                                            ),
                                          );
                                        },
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          suffix: IconButton(
                                            onPressed: () {
                                              // setState(() {
                                              //   // Remove the corresponding element from the list
                                              //   roomNames.removeAt(index);
                                              // });

                                              // Pass the updated roomNames list to SettingsBloc

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
                                                            SettingsBloc.get(
                                                                    context)
                                                                .add(
                                                              UpdateRoomsEvent(
                                                                // roomNames: ,
                                                                index: index,
                                                              ),
                                                            );
                                                            SettingsBloc.get(
                                                                    context)
                                                                .add(
                                                              const UpdateRooms(),
                                                            );

                                                            // if (state.submission == Submission.success) {
                                                            // await AuthenticationRepository
                                                            //     .instance
                                                            //     .updateRoomsNames(
                                                            //         state
                                                            //             .roomNAMS);

                                                            Navigator.of(ctx)
                                                                .pop();
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
                                            // },
                                            icon: const Icon(
                                              Icons.remove_circle,
                                              color: Colors.red,
                                            ),
                                          ),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                              onPressed: () async {
                                SettingsBloc.get(context).add(
                                  const UpdateRooms(),
                                );

                                // if (state.submission == Submission.success) {
                                // await AuthenticationRepository.instance
                                //     .updateRoomsNames(state.roomNAMS);
                                // }
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


// Widget _buildInputCard(
//   String title,
//   String value,
//   void Function(String) onChanged,
//   bool readOnly, // Add a bool parameter for read-only state
//   IconButton? suffixIconButton, // Add an optional suffix icon button parameter
// ) {
//   return SizedBox(
//     width: 500,
//     child: Card(
//       color: AppColors.white,
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 if (suffixIconButton != null) suffixIconButton,
//               ],
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               readOnly:
//                   readOnly, // Set readOnly based on the provided parameter
//               style: TextStyle(color: Colors.black),
//               controller: TextEditingController(text: value),
//               onChanged: onChanged,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: BorderSide.none,
//                 ),
//                 filled: true,
//                 fillColor: Colors.grey[200],
//                 contentPadding:
//                     const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }




// import 'package:Investigator/core/enum/enum.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart'; // Import flutter_bloc for BlocProvider

// import '../../../authentication/authentication_repository.dart';
// import '../../../core/resources/app_colors.dart';
// // import '../../../core/utils/responsive.dart';
// import '../../../core/widgets/toast/toast.dart';
// import '../../standard_layout/screens/standard_layout.dart';
// import '../bloc/settings_bloc.dart'; // Import your settings_bloc file

// class Settings extends StatelessWidget {
//   Settings({Key? key}) : super(key: key);
//   TextEditingController passwordController = TextEditingController();

//   List<String> roomNames =
//       AuthenticationRepository.instance.currentUser.roomsNames ?? [];
//   @override
//   Widget build(BuildContext context) {
//     return StandardLayoutScreen(
//       body: BlocProvider(
//         create: (context) => SettingsBloc(),
//         child: BlocListener<SettingsBloc, SettingsState>(
//           listener: (context, state) {
//             if (state.submission == Submission.success) {
//               FxToast.showSuccessToast(
//                   context: context,
//                   message: state.responseMessage.isNotEmpty
//                       ? state.responseMessage
//                       : null);
//             }
//             if (state.submission == Submission.error) {
//               FxToast.showErrorToast(
//                   context: context,
//                   message: state.responseMessage.isNotEmpty
//                       ? state.responseMessage
//                       : null);
//             }
//             if (state.submission == Submission.noDataFound) {
//               FxToast.showWarningToast(
//                   context: context,
//                   warningMessage: "NO data found about this person");
//             }
//           },
//           child: BlocBuilder<SettingsBloc, SettingsState>(
//             builder: (context, state) {
//               return Card(
//                 margin: const EdgeInsets.all(20),
//                 color: AppColors.grey5,
//                 elevation: 0,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
// //                       Row(
// //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                         children: [
// //                           _buildInputCard(
// //                             'Email',
// //                             AuthenticationRepository
// //                                     .instance.currentUser.username ??
// //                                 "",
// //                             (value) {
// //                               // Update email state
// //                             },
// //                             true,
// //                             IconButton(
// //                               onPressed: () {
// //                                 // Handle suffix icon button pressed
// //                               },
// //                               icon: Icon(Icons.check, color: Colors.green),
// //                             ),
// //                           ),
// //                           _buildInputCard(
// //                             'Password',
// //                             // Set an initial value (masked)
// //                             "********",
// //                             (value) {
// //                               SettingsBloc.get(context).add(
// //                                 UpdatePasswordEvent(passwordUpd: value),
// //                               );
// //                             },
// //                             false,
// //                             IconButton(
// //                               onPressed: () {
// //                                 // Access the password value from the controller
// //                                 String newPassword = passwordController.text;
// //                                 // Pass the value to the bloc
// //                                 SettingsBloc.get(context).add(
// //                                   UpdatePassword(),
// //                                 );
// //                               },
// //                               icon: Icon(Icons.check, color: Colors.green),
// //                             ),
// //                           ),
// // //                           _buildInputCard(
// // //   'Password',
// // //   // Set an initial value (masked)
// // //   "********",
// // //   null, // No onChanged function needed here
// // //   false,
// // //   IconButton(
// // //     onPressed: () {
// // //       // Access the password value from the controller
// // //       String newPassword = passwordController.text;
// // //       // Pass the value to the bloc
// // //       SettingsBloc.get(context).add(
// // //         UpdatePasswordEvent(passwordUpdate: newPassword),
// // //       );
// // //     },
// // //     icon: Icon(Icons.check, color: Colors.green),
// // //   ),
// // // ),

// //                           SizedBox(height: 10),
// //                         ],
// //                       ),
// //                       SizedBox(height: 10),
//                       const Text(
//                         'Rooms Names',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 10),
//                       Expanded(
//                         child: ListView.builder(
//                           itemCount: roomNames.length,
//                           itemBuilder: (context, index) {
//                             TextEditingController controller =
//                                 TextEditingController(text: roomNames[index]);
//                             return Card(
//                               margin: const EdgeInsets.only(bottom: 20),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(16.0),
//                                 child: Row(
//                                   children: [
//                                     Expanded(
//                                       child: TextField(
//                                         style: TextStyle(color: Colors.black),
//                                         controller: controller,
//                                         decoration: InputDecoration(
//                                           border: InputBorder.none,
//                                         ),
//                                       ),
//                                     ),
//                                     IconButton(
//                                       icon: Icon(Icons.edit),
//                                       onPressed: () {


                                       
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

// Widget _buildInputCard(
//   String title,
//   String value,
//   void Function(String) onChanged,
//   bool readOnly, // Add a bool parameter for read-only state
//   IconButton? suffixIconButton, // Add an optional suffix icon button parameter
// ) {
//   return SizedBox(
//     width: 500,
//     child: Card(
//       color: AppColors.white,
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 if (suffixIconButton != null) suffixIconButton,
//               ],
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               readOnly:
//                   readOnly, // Set readOnly based on the provided parameter
//               style: TextStyle(color: Colors.black),
//               controller: TextEditingController(text: value),
//               onChanged: onChanged,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: BorderSide.none,
//                 ),
//                 filled: true,
//                 fillColor: Colors.grey[200],
//                 contentPadding:
//                     const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
