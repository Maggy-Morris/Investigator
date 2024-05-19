// import 'package:Investigator/core/loader/loading_indicator.dart';
// import 'package:flutter/material.dart';
// import 'package:chewie/chewie.dart';
// import 'package:video_player/video_player.dart';

// import '../resources/app_colors.dart';

// class VideoPlayerWidget extends StatefulWidget {
//   final String videoUrl;
//   final int? secondsGiven;

//   const VideoPlayerWidget({
//     Key? key,
//     required this.videoUrl,
//     this.secondsGiven,
//   }) : super(key: key);

//   @override
//   _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
// }

// class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
//   late VideoPlayerController _videoPlayerController;
//   ChewieController? _chewieController;
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _initializePlayer();
//   }

//   Future<void> _initializePlayer() async {
//     _videoPlayerController =
//         VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
//     await _videoPlayerController.initialize();
//     // await _videoPlayerController
//     //     .seekTo(Duration(seconds: widget.secondsGiven ?? 15));

//     setState(() {
//       _chewieController = ChewieController(
//         videoPlayerController: _videoPlayerController,
//         aspectRatio: _videoPlayerController.value.aspectRatio,
//         startAt: Duration(seconds: widget.secondsGiven ?? 0),
//         autoPlay: false, // set to true to play automatically
//         autoInitialize: false,
//       );
//       _isLoading = false;
//     });
//   }

//   @override
//   void dispose() {
//     _chewieController?.dispose();
//     _videoPlayerController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _isLoading
//         ? Center(
//             child: loadingIndicator(
//               color: AppColors.buttonBlue,
//             ),
//           )
//         : Chewie(
//             controller: _chewieController!,
//           );
//   }
// }

import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:Investigator/core/loader/loading_indicator.dart';
import '../resources/app_colors.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final int? secondsGiven;

  const VideoPlayerWidget({
    Key? key,
    required this.videoUrl,
    this.secondsGiven,
  }) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  @override
  void didUpdateWidget(covariant VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if (widget.secondsGiven != oldWidget.secondsGiven) {
    _seekToNewPosition();
    // }
  }

  Future<void> _initializePlayer() async {
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    await _videoPlayerController.initialize();

    if (widget.secondsGiven != null && widget.secondsGiven! > 0) {
      await _videoPlayerController
          .seekTo(Duration(seconds: widget.secondsGiven!));
    }

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: _videoPlayerController.value.aspectRatio,
      autoPlay: false,
      autoInitialize: true,
    );

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _seekToNewPosition() async {
    if (widget.secondsGiven != null && widget.secondsGiven! > 0) {
      await _videoPlayerController
          .seekTo(Duration(seconds: widget.secondsGiven!));
      // setState(() {
      //   // Update the state to trigger a rebuild if necessary
      // });
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: loadingIndicator(
              color: AppColors.buttonBlue,
            ),
          )
        : Chewie(
            controller: _chewieController!,
          );
  }
}
