import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'dart:html' as html;

import 'package:flutter_easyloading/flutter_easyloading.dart';

downloadImageFromWeb(
    {required Uint8List data, String downloadName = 'image'}) async {
  if (data.isNotEmpty) {
    try {
      // first we make a request to the url like you did
      // in the android and ios version
      // final http.Response r = await http.get(
      //   Uri.parse(getPhotosServerLink(imageUrl)),
      // );

      // we get the bytes from the body
      // final data = r.bodyBytes;
      // and encode them to base64
      final base64data = base64Encode(data);

      // then we create and AnchorElement with the html package
      final a = html.AnchorElement(href: 'data:image/jpeg;base64,$base64data');

      // set the name of the file we want the image to get
      // downloaded to
      a.download = '$downloadName.jpg';

      // and we click the AnchorElement which downloads the image
      a.click();
      // finally we remove the AnchorElement
      a.remove();
    } catch (e) {
      if (kDebugMode) {
        // print(e);
      }
    }
  } else {
    EasyLoading.showError('لا يوجد صورة');
  }
}