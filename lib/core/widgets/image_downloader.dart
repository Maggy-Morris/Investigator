import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'dart:html' as html;
import 'package:http/http.dart' as http;
import '../../../core/remote_provider/remote_data_source.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';

// downloadImageFromWeb(
//     {required Uint8List data, String downloadName = 'image'}) async {
//   if (data.isNotEmpty) {
//     try {
//       // first we make a request to the url like you did
//       // in the android and ios version
//       // final http.Response r = await http.get(
//       //   Uri.parse(getPhotosServerLink(imageUrl)),
//       // );

//       // we get the bytes from the body
//       // final data = r.bodyBytes;
//       // and encode them to base64
//       final base64data = base64Encode(data);

//       // then we create and AnchorElement with the html package
//       final a = html.AnchorElement(href: 'data:image/jpeg;base64,$base64data');

//       // set the name of the file we want the image to get
//       // downloaded to
//       a.download = '$downloadName.jpg';

//       // and we click the AnchorElement which downloads the image
//       a.click();
//       // finally we remove the AnchorElement
//       a.remove();
//     } catch (e) {
//       if (kDebugMode) {
//         // print(e);
//       }
//     }
//   } else {
//     EasyLoading.showError('لا يوجد صورة');
//   }
// }






downloadImageFromWeb({
    required String imageUrl,
    String downloadName = 'image',
  }) async {
    if (imageUrl.isNotEmpty) {
      try {
        final http.Response response = await http.get(
          Uri.parse(
              "http:${RemoteDataSource.baseUrlWithoutPort}8000/${imageUrl}"),
        );

        if (response.statusCode == 200) {
          final List<int> data = response.bodyBytes;
          final String base64data = base64Encode(data);
          final html.AnchorElement anchor = html.AnchorElement(
            href: 'data:image/jpeg;base64,$base64data',
          );

          anchor.download = '$downloadName.jpg';
          anchor.click();
          anchor.remove();
        } else {
          if (kDebugMode) {
            print('Failed to download image: ${response.statusCode}');
          }
          EasyLoading.showError('فشل تنزيل الصورة');
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error downloading image: $e');
        }
        EasyLoading.showError('حدث خطأ أثناء تنزيل الصورة');
      }
    } else {
      EasyLoading.showError('لا يوجد صورة');
    }
  }


















  ///download image from base46
  //  _downloadImage({required String data, String downloadName = 'image'}) async {
  //   if (data.isNotEmpty) {
  //     try {
  //       final uint8List = _decodeBase64Image(base64Image: data);
  //       // first we make a request to the url like you did
  //       // in the android and ios version
  //       // final http.Response r = await http.get(
  //       //   Uri.parse(getPhotosServerLink(imageUrl)),
  //       // );

  //       // we get the bytes from the body
  //       // final data = r.bodyBytes;
  //       // and encode them to base64
  //       final base64data = base64Encode(uint8List);

  //       // then we create and AnchorElement with the html package
  //       final a =
  //           html.AnchorElement(href: 'data:image/jpeg;base64,$base64data');

  //       // set the name of the file we want the image to get
  //       // downloaded to
  //       a.download = '$downloadName.jpg';

  //       // and we click the AnchorElement which downloads the image
  //       a.click();
  //       // finally we remove the AnchorElement
  //       a.remove();
  //     } catch (e) {
  //       if (kDebugMode) {
  //         print(e);
  //       }
  //     }
  //   } else {
  //     EasyLoading.showError('لا يوجد صورة');
  //   }
  // }

