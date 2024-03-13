import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/photo_app_cubit.dart';

class PhotoScreen extends StatelessWidget {
  const PhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhotoAppCubit, PhotoAppState>(
        builder: (context, state){
          state as SelectProfilePhotoState;
          return Scaffold(
            appBar: AppBar(
              title: const Text("Take a Photo"),
              centerTitle: true,
            ),
            body: Column(
              children: [
                const SizedBox(height: 10,),
                Center(
                  child: Stack(
                    children: [
                      getAvatar(state.file),
                      Positioned(
                        bottom: -10,
                        left:  80,
                        child: IconButton(
                          onPressed: (){
                            context.read<PhotoAppCubit>().openCamera();
                          },
                          icon: const Icon(Icons.photo_camera_rounded)),
                    )
                  ],
              ),
                ),
            ],),
          );
        },
    );
 
 
 
  }
}

CircleAvatar getAvatar(File? displayImage){
  if(displayImage == null){
    return const CircleAvatar(
      radius: 65,
      backgroundImage: AssetImage('assets/avatar.png'),
    );
  } else {
    return CircleAvatar(
      radius: 65,
      backgroundImage: FileImage(displayImage),
    );
  }
}