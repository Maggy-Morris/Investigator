import 'dart:convert';
import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:Investigator/authentication/authentication_repository.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:file_picker/file_picker.dart';
import 'package:Investigator/core/error/exceptions.dart';

class RemoteDataSource {
  static String baseURL = 'http://localhost:10000';
  static String baseUrlWithoutPort = "//localhost:";
  static String baseUrlWithoutPortForImages = "//localhost:";

  // static String baseURL = 'http://172.10.1.2:10000';
  // static String baseUrlWithoutPort = "//172.10.1.2:";
  // static String baseUrlWithoutPortForImages = "//172.10.1.2:";
  // static String baseURL = 'http://192.168.1.79:10000';
  // static String baseUrlWithoutPort = "//192.168.1.79:";
  // static String baseUrlWithoutPortForImages = "//192.168.1.79:";

  Future<Map<String, dynamic>> post({
    required String endPoint,
    Object? body,
    String? baseURL_,
  }) async {
    // baseURL = 'http://192.168.1.103:5000';

    http.Response response;
    String url = (baseURL_ ?? baseURL) + endPoint;
    //1. base url
    if (kDebugMode) {
      debugPrint("url $url");
    }
    //2.parse url with Uri.parse()
    Uri uri = Uri.parse(url);
    //3. make post request
    Map<String, String> header = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization':
          'Bearer ${AuthenticationRepository.instance.currentUser.token}'
    };

    if (kDebugMode) {
      print("body string ${body.toString()}");
    }
    response = await http.post(uri, body: jsonEncode(body), headers: header);

    if (kDebugMode) {
      // print("response ${response.body.toString()}");
    }
    //4. Error handling for the response
    return _responseHandler(response: response);
  }

  Future<Uint8List> postToReturnFile({
    required String endPoint,
    Object? body,
    String? baseURL_,
  }) async {
    http.Response response;
    String url = (baseURL_ ?? baseURL) + endPoint;
    //1. base url
    if (kDebugMode) {
      debugPrint("url $url");
    }
    //2.parse url with Uri.parse()
    Uri uri = Uri.parse(url);
    //3. make post request
    Map<String, String> header = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization':
          'Bearer ${AuthenticationRepository.instance.currentUser.token}'
    };

    if (kDebugMode) {
      print("body string ${body.toString()}");
    }
    response = await http.post(uri, body: jsonEncode(body), headers: header);

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      return Uint8List(0);
    }
  }

  Future<Map<String, dynamic>> put({
    required String endPoint,
    Object? body,
  }) async {
    http.Response response;
    String url = baseURL + endPoint;
    //1. base url
    if (kDebugMode) {
      print("url $url");
    }
    //2.parse url with Uri.parse()
    Uri uri = Uri.parse(url);
    //3. make post request
    Map<String, String> header = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization':
          'Bearer ${AuthenticationRepository.instance.currentUser.token}'
    };

    if (kDebugMode) {
      print("body string ${body.toString()}");
    }
    response = await http.put(uri, body: jsonEncode(body), headers: header);

    if (kDebugMode) {
      print("response ${response.body.toString()}");
    }
    //4. Error handling for the response
    return _responseHandler(response: response);
  }

  ///returns response data of get request
  Future<dynamic> get({
    required String endPoint,
  }) async {
    http.Response response;
    String url = baseURL + endPoint;
    //1. base url
    if (kDebugMode) {
      print("url $url");
    }
    //2.parse url with Uri.parse()
    Uri uri = Uri.parse(url);

    //3. make get request

    Map<String, String> header = {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer ${AuthenticationRepository.instance.currentUser.token}'
    };

    response = await http.get(uri, headers: header);

    if (kDebugMode) {
      print("response ${response.body.toString()}");
    }
    //4. Error handling for the response
    return _responseHandler(response: response);
  }

  Future<Map<String, dynamic>> delete({
    required String endPoint,
    Object? body,
  }) async {
    http.Response response;
    String url = baseURL + endPoint;
    //1. base url
    if (kDebugMode) {
      print("url $url");
    }
    //2.parse url with Uri.parse()
    Uri uri = Uri.parse(url);
    //3. make post request
    Map<String, String> header = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization':
          'Bearer ${AuthenticationRepository.instance.currentUser.token}'
    };

    if (kDebugMode) {
      print("body string ${body.toString()}");
    }
    response = await http.delete(uri, body: jsonEncode(body), headers: header);

    if (kDebugMode) {
      print("response ${response.body.toString()}");
    }
    //4. Error handling for the response
    return _responseHandler(response: response);
  }

  ///returns response data of post multipart request
  Future<dynamic> postMultiPartFiles({
    required String endPoint,
    Map<String, String>? body,
    List<PlatformFile>? files,
  }) async {
    http.MultipartRequest response;
    String url = baseURL + endPoint;
    //1. base url
    if (kDebugMode) {
      print("url $url");
    }
    //2.parse url with Uri.parse()
    Uri uri = Uri.parse(url);

    //3. make post request

    Map<String, String> header = {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer ${AuthenticationRepository.instance.currentUser.token}'
    };

    response = http.MultipartRequest("POST", uri);
    response.headers.addAll(header);

    if (files != null) {
      if (files.isNotEmpty) {
        for (var file in files) {
          response.files.add(MultipartFile.fromBytes(
              'files[]', file.bytes ?? [],
              filename: file.name));
        }
      }
    }
    if (body != null) {
      response.fields.addAll(body);
    }

    var streamedResponse = await response.send();
    var result = await http.Response.fromStream(streamedResponse);
    if (result.statusCode >= 200 && result.statusCode < 300) {
      return jsonDecode(result.body);
    }
    if (result.statusCode == 400) {
      throw RequestErrorException(
          responseMessage: jsonDecode(result.body)['message']);
    } else {
      // throw UnknownServerException();
    }
  }

  Future<dynamic> postMultiPartListOfListFiles({
    required String endPoint,
    Map<String, String>? body,
    Map<String, dynamic>? files,
  }) async {
    http.MultipartRequest response;
    String url = baseURL + endPoint;
    //1. base url
    if (kDebugMode) {
      print("url $url");
    }
    //2.parse url with Uri.parse()
    Uri uri = Uri.parse(url);

    //3. make post request

    Map<String, String> header = {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer ${AuthenticationRepository.instance.currentUser.token}'
    };

    response = http.MultipartRequest("POST", uri);
    response.headers.addAll(header);

    if (files != null) {
      if (files.isNotEmpty) {
        PlatformFile videoFile = files["video"];
        response.files.add(MultipartFile.fromBytes(
            'files[]', videoFile.bytes ?? [],
            filename: videoFile.name));

        for (var (file as PlatformFile) in files["imagesList"]) {
          response.files.add(MultipartFile.fromBytes(
              'files[]', file.bytes ?? [],
              filename: file.name));
        }
      }
    }
    if (body != null) {
      response.fields.addAll(body);
    }

    var streamedResponse = await response.send();
    var result = await http.Response.fromStream(streamedResponse);
    if (result.statusCode >= 200 && result.statusCode < 300) {
      return jsonDecode(result.body);
    }
    if (result.statusCode == 400) {
      throw RequestErrorException(
          responseMessage: jsonDecode(result.body)['message']);
    } else {
      // throw UnknownServerException();
    }
  }

  Future<dynamic> postMultiPartFile({
    required String endPoint,
    Map<String, String>? body,
    List<PlatformFile>? files,
  }) async {
    http.MultipartRequest response;
    String url = baseURL + endPoint;
    //1. base url
    if (kDebugMode) {
      print("url $url");
    }
    //2.parse url with Uri.parse()
    Uri uri = Uri.parse(url);

    //3. make post request

    Map<String, String> header = {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer ${AuthenticationRepository.instance.currentUser.token}'
    };

    response = http.MultipartRequest("POST", uri);
    response.headers.addAll(header);

    if (files != null) {
      if (files.isNotEmpty) {
        response.files.add(MultipartFile.fromBytes(
            'file', files.first.bytes ?? [],
            filename: files.first.name));
      }
    }
    if (body != null) {
      response.fields.addAll(body);
    }

    var streamedResponse = await response.send();
    var result = await http.Response.fromStream(streamedResponse);
    if (result.statusCode >= 200 && result.statusCode < 300) {
      return jsonDecode(result.body);
    }
    if (result.statusCode == 400) {
      throw RequestErrorException(
          responseMessage: jsonDecode(result.body)['message']);
    } else {
      throw UnknownServerException();
    }
  }

  Future<dynamic> postWithFile({
    required String endPoint,
    Map<String, String>? body,
    PlatformFile? files,
  }) async {
    http.MultipartRequest response;
    String url = baseURL + endPoint;
    //1. base url
    if (kDebugMode) {
      print("url $url");
    }
    //2.parse url with Uri.parse()
    Uri uri = Uri.parse(url);

    //3. make post request

    Map<String, String> header = {
      'Content-Type': 'multipart/form-data; charset=UTF-8',
      'Authorization':
          'Bearer ${AuthenticationRepository.instance.currentUser.token}'
    };

    response = http.MultipartRequest("POST", uri);
    response.headers.addAll(header);

    if (files != null) {
      // if (files.isNotEmpty) {
      //   for (var file in files) {
      /// response.files.add(await http.MultipartFile.fromPath('file', files.path!,filename: files.name));
      response.files.add(http.MultipartFile(
          'file', files.readStream as Stream<List<int>>, files.size,
          filename: files.name));

      ///
      //   }
      // }
    }
    if (body != null) {
      response.fields.addAll(body);
    }

    var streamedResponse = await response.send();
    var result = await http.Response.fromStream(streamedResponse);
    if (result.statusCode >= 200 && result.statusCode < 300) {
      return jsonDecode(result.body);
    }
    if (result.statusCode == 400) {
      throw RequestErrorException(
          responseMessage: jsonDecode(result.body)['message']);
    } else {
      throw UnknownServerException();
    }
  }

  // Future<dynamic> postWithFileTest({
  //   required String endPoint,
  //   Map<String, String>? body,
  //   File? files,
  // }) async {
  //   http.MultipartRequest response;
  //   String url = baseURL + endPoint;
  //   //1. base url
  //   if (kDebugMode) {
  //     print("url $url");
  //   }
  //   //2.parse url with Uri.parse()
  //   Uri uri = Uri.parse(url);
  //
  //   //3. make post request
  //
  //   Map<String, String> header = {
  //     'Content-Type': 'multipart/form-data; charset=UTF-8',
  //     'Authorization':
  //         'Bearer ${AuthenticationRepository.instance.currentUser.token}'
  //   };
  //
  //   response = http.MultipartRequest("POST", uri);
  //   response.headers.addAll(header);
  //
  //   if (files != null) {
  //     // if (files.isNotEmpty) {
  //     //   for (var file in files) {
  //     /// response.files.add(await http.MultipartFile.fromPath('file', files.path!,filename: files.name));
  //     response.files.add(await http.MultipartFile.fromPath(
  //         'file', files.relativePath ?? "",
  //         filename: files.name));
  //
  //     ///
  //     //   }
  //     // }
  //   }
  //   if (body != null) {
  //     response.fields.addAll(body);
  //   }
  //
  //   var streamedResponse = await response.send();
  //   var result = await http.Response.fromStream(streamedResponse);
  //   if (result.statusCode >= 200 && result.statusCode < 300) {
  //     return jsonDecode(result.body);
  //   }
  //   if (result.statusCode == 400) {
  //     throw RequestErrorException(
  //         responseMessage: jsonDecode(result.body)['message']);
  //   } else {
  //     throw UnknownServerException();
  //   }
  // }

  dynamic _responseHandler({
    required http.Response response,
  }) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    }
    if (response.statusCode == 400) {
      throw RequestErrorException(
          responseMessage: jsonDecode(response.body)['message']);
    } else {
      throw UnknownServerException();
    }
  }
}
