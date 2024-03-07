import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Investigator/core/resources/app_colors.dart';
import 'package:Investigator/core/utils/responsive.dart';
// import 'package:Investigator/core/widgets/drop_down_widgets.dart';
import 'package:Investigator/core/widgets/sizedbox.dart';
import 'package:Investigator/core/widgets/toast/toast.dart';
import 'package:Investigator/presentation/standard_layout/screens/standard_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/enum/enum.dart';
import '../../../core/loader/loading_indicator.dart';
import '../bloc/search_by_image_bloc.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Widget? _image;

  @override
  Widget build(BuildContext context) {
    return StandardLayoutScreen(
      body: BlocProvider(
        create: (context) => SearchByImageBloc(),
        child: BlocListener<SearchByImageBloc, SearchByImageState>(
          listener: (context, state) {
            if (state.submission == Submission.success) {
              FxToast.showSuccessToast(context: context);
            }
            if (state.submission == Submission.error) {
              FxToast.showErrorToast(context: context);
            }
          },
          child: BlocBuilder<SearchByImageBloc, SearchByImageState>(
            builder: (context, state) {
              return SingleChildScrollView(
                // physics: NeverScrollableScrollPhysics(),
                child: Card(
                  margin: const EdgeInsets.all(20),
                  color: AppColors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Text(
                        //   "Search For Your Employee".tr(),
                        //   style: const TextStyle(
                        //       fontSize: 17, fontWeight: FontWeight.w600),
                        // ),
                        FxBox.h24,
                        if (Responsive.isWeb(context))
                          Column(
                            children: [
                              const Row(
                                children: [],
                              ),

                              FxBox.h24,

                              // Here to search for an Employee in the database
                              Card(
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
                                                base64Encode(imageFile.bytes!);
                                            final SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            final String? companyName =
                                                prefs.getString('companyName');
                                            SearchByImageBloc.get(context).add(
                                              SearchForEmployee(
                                                companyName: companyName ?? " ",
                                                image: base64Image,
                                              ),
                                            );
                                          }
                                        },
                                        child: _image ??
                                            Image.network(
                                              'https://images.pexels.com/photos/414171/pexels-photo-414171.jpeg',
                                              width: double.infinity,
                                              // height: 200,
                                              fit: BoxFit.cover,
                                            ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 16),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomLeft: Radius.circular(12),
                                              bottomRight:
                                                  const Radius.circular(12),
                                            ),
                                            color:
                                                Colors.black.withOpacity(0.6),
                                          ),
                                          child: const Text(
                                            '',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              //Confirm Button to send the image
                              FxBox.h24,
                              (state.submission == Submission.loading)
                                  ? loadingIndicator()
                                  : Center(
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          if (_image == null) {
                                            FxToast.showErrorToast(
                                                context: context,
                                                message: "pick your picture ");
                                            return;
                                          }

                                          SearchByImageBloc.get(context).add(
                                            SearchForEmployeeEvent(),
                                          );
                                          // HomeBloc.get(context).add(
                                          //     const GetEmployeeNamesEvent());
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
                                        ),
                                      ),
                                    ), /////////////////////////////////////////////

                              /////////////////////////////////////////////////
                            ],
                          ),
                        if (!Responsive.isWeb(context))
                          Column(
                            children: [
                              Card(
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
                                                    : loadingIndicator(); //

                                            // Replace the image with the selected image
                                            setState(() {
                                              _image = image;
                                            });
                                          }
                                        },
                                        child: _image ??
                                            Image.network(
                                              'https://images.pexels.com/photos/414171/pexels-photo-414171.jpeg',
                                              width: double.infinity,
                                              // height: 200,
                                              fit: BoxFit.cover,
                                            ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 16),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomLeft: Radius.circular(12),
                                              bottomRight:
                                                  const Radius.circular(12),
                                            ),
                                            color:
                                                Colors.black.withOpacity(0.6),
                                          ),
                                          child: const Text(
                                            '',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              //Confirm Button to send the image
                              FxBox.h24,
                              (state.submission == Submission.loading)
                                  ? loadingIndicator()
                                  : Center(
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          if (_image == null) {
                                            FxToast.showErrorToast(
                                                context: context,
                                                message: "pick your picture ");
                                            return;
                                          }

                                          // HomeBloc.get(context).add(
                                          //     const GetEmployeeNamesEvent());
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
                                        ),
                                      ),
                                    ), /////////////////////////////////////////////
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
