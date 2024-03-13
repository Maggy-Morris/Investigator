
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/photo_app_cubit.dart';
import 'screens/camera_screen.dart';
import 'screens/my_photo_screen.dart';
import 'screens/preview_screen.dart';

class PhotoAppLogic extends StatelessWidget {
  const PhotoAppLogic({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PhotoAppCubit, PhotoAppState>(
        builder: (context, state){
           if (state is SelectProfilePhotoState){
             return const PhotoScreen();
           }
           else if (state is CameraState){
             return const CameraScreen();
           }
           else if (state is PreviewState){
             return const PreviewScreen();
           }
           else {
             return const Scaffold(
               body: Center(
                 child: Text('Nothing to show'),
               ),
             );
           }
        },
        //Could be used with the Super state variables to handle loading dialogs and error but not implemented yet.
        listener: (context, state ){
          //if (state.isLoading == false) popTheDialog;
          //if (state.isLoading == true) showLoadingDialog;
          //if (state.hasError == true) showErrorDialog;
        }
    );
  }
}
