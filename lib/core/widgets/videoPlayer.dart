
import 'dart:typed_data';
import 'dart:html' as html;

import 'package:file_picker/file_picker.dart';
import 'package:video_player/video_player.dart';

class VideoPickResult {
  final PlatformFile? videoFile;
  final VideoPlayerController? controller;

  VideoPickResult({this.videoFile, this.controller});
}

VideoPlayerController? _controller;

Future<VideoPickResult?> _pickVideo({required int? timeDuration}) async {
  // Your existing code
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.video,
  );

  if (result != null) {
    final videoFile = result.files.first;
    final Uint8List videoBytes = videoFile.bytes!;
    final blob = html.Blob([videoBytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    _controller = VideoPlayerController.network(url)
      ..initialize().then((_) {
        timeDuration == null
            ? _controller!.play()
            : _controller!.seekTo(Duration(seconds: timeDuration));
      });

    return VideoPickResult(videoFile: videoFile, controller: _controller);
  } else {
    return null;
  }
}
