import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/photo_app_cubit.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool _isBackCamera = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhotoAppCubit, PhotoAppState>(builder: (context, state) {
      state as CameraState;
      return CameraPreview(
        state.controller!,
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              fit: StackFit.expand,
              alignment: Alignment.bottomCenter,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.read<PhotoAppCubit>().takePicture();
                      },
                      child: Container(
                        height: 100,
                        width: 70,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    IconButton(
                        color: Colors.white,
                        padding: const EdgeInsets.only(bottom: 25),
                        onPressed: () {
                          setState(() {
                            _isBackCamera = !_isBackCamera;
                          });
                          // context.read<PhotoAppCubit>().switchCameraOptions(
                          //     isBackCam: _isBackCamera,
                          //     cameraController: state.controller,
                          //  );
                        },
                        icon: const Icon(Icons.cameraswitch))
                  ],
                ),
              ],
            )),
      );
    });
  }
}
