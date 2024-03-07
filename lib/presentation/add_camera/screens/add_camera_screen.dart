import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

class AddCameraScreen extends StatefulWidget {
  const AddCameraScreen({Key? key}) : super(key: key);

  @override
  State<AddCameraScreen> createState() => _AddCameraScreenState();
}

class _AddCameraScreenState extends State<AddCameraScreen> {
  TextEditingController cameraNameController = TextEditingController();
  Widget? _image;

  @override
  Widget build(BuildContext context) {
    return StandardLayoutScreen(
      body: BlocProvider(
        create: (context) => HomeBloc(),
        child: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state.submission == Submission.success) {
              cameraNameController.clear();
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
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          "Search for your Employee".tr(),
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
                                        _commonText("Person Name".tr()),
                                        FxBox.h4,
                                        _listBox(
                                            controller: cameraNameController,
                                            hintText: "Add Person Name".tr(),
                                            onChanged: (value) {
                                              // HomeBloc.get(context).add(
                                              // AddCameraName(
                                              //     cameraName: value));
                                            }),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              FxBox.h16,
                              // Here to search for an Employee in the database
                              Row(
                                children: [
                                  SizedBox(
                                    height: 300,
                                    width: 300,
                                    child: Card(
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Stack(
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                FilePickerResult? result =
                                                    await FilePicker.platform
                                                        .pickFiles(
                                                  type: FileType.image,
                                                );
                                                if (result != null &&
                                                    result.files.isNotEmpty) {
                                                  // Use the selected image file
                                                  final imageFile =
                                                      result.files.first;
                                                  // Load the image file as an image
                                                  final image =
                                                      imageFile.bytes != null
                                                          ? Image.memory(
                                                              imageFile.bytes!,
                                                              fit: BoxFit.cover,
                                                            )
                                                          : loadingIndicator();

                                                  // Replace the image with the selected image
                                                  setState(() {
                                                    _image = image;
                                                  });

                                                  String base64Image =
                                                      base64Encode(
                                                          imageFile.bytes!);
                                                  final SharedPreferences
                                                      prefs =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  final String? companyName =
                                                      prefs.getString(
                                                          'companyName');
                                                  // SearchByImageBloc.get(context).add(
                                                  //   SearchForEmployee(
                                                  //     companyName: companyName ?? " ",
                                                  //     image: base64Image,
                                                  //   ),
                                                  // );
                                                }
                                              },
                                              child: _image ??
                                                  Image.network(
                                                    'https://images.pexels.com/photos/414171/pexels-photo-414171.jpeg',
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    // height: 200,
                                                    fit: BoxFit.cover,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              FxBox.h16,

                              Center(
                                child: ElevatedButton.icon(
                                    onPressed: () {
                                      // HomeBloc.get(context)
                                      //     .add(const AddCameraEvent());
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
                              _commonText("Person name".tr()),
                              FxBox.h4,
                              _listBox(
                                  hintText: "Add Person Name".tr(),
                                  controller: cameraNameController,
                                  onChanged: (value) {
                                    // HomeBloc.get(context)
                                    //     .add(AddCameraName(cameraName: value));
                                  }),
                              FxBox.h60,
                              (state.submission == Submission.loading)
                                  ? loadingIndicator()
                                  : Center(
                                      child: ElevatedButton.icon(
                                          onPressed: () {
                                            // HomeBloc.get(context)
                                            //     .add(const AddCameraEvent());
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
