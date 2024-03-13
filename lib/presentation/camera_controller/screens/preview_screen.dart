import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/photo_app_cubit.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhotoAppCubit, PhotoAppState>(
      builder: (context,state) {
        state as PreviewState;
        return Material(
          child: DecoratedBox(
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: FileImage(state.file!)
                )
              ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: (){
                    context.read<PhotoAppCubit>().openCamera();
                  },
                  child: Container(
                    height: 40,
                    width: 100,
                    color: Colors.white38,
                    child: const Icon(Icons.cancel_outlined),
                  ),
                ),
                const SizedBox(width: 20,),
                InkWell(
                  onTap: (){
                    context.read<PhotoAppCubit>().selectPhoto(file: state.file!);
                  },
                  child: Container(
                    height: 40,
                    width: 60,
                    color: Colors.white38,
                    child: const Icon(Icons.check_outlined),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}