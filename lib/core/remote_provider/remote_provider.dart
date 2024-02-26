import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:luminalens/authentication/call_back_authentication.dart';
import 'package:luminalens/core/models/add_camera_model.dart';
import 'package:luminalens/core/models/apply_model_model.dart';
import 'package:luminalens/core/models/camera_details_model.dart';
import 'package:luminalens/core/models/dashboard_models.dart';
import 'package:luminalens/core/remote_provider/remote_data_source.dart';

enum AppLifecycleStatus { online, offline }

class RemoteProvider {
  static final RemoteProvider _inst = RemoteProvider._internal();

  // final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;

  RemoteProvider._internal();

  factory RemoteProvider() {
    // _inst.currentUser = currentUser;
    return _inst;
  }

  /// Login API
  Future<UserData?> loginRemoteCredentials(
      String email, String password) async {
    try {
      var loginCallBack = await RemoteDataSource().postWithFile(
          endPoint: "/signin", body: {"username": email, "password": password});
      if (loginCallBack != null) {
        // CallBackRemote callBackRemote = CallBackRemote.fromJson(loginCallBack);
        // if (callBackRemote.data != null) {
        // debugPrint(loginCallBack.toString());
        UserData callBackDetailID = UserData.fromJson(loginCallBack);

        if (kDebugMode) {
          debugPrint(loginCallBack.toString());
        }
        return callBackDetailID;
        // return AddNewMainPersonalDataInitial.fromJson(callBackRemote.data ?? {});
        // } else {
        //   return null;
        // }
      } else {
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  /// get all static lists
  Future<List<String>> getAllCamerasNames() async {
    try {
      List<dynamic> callBack = await RemoteDataSource().get(
        endPoint: "/get_cameraname",
      );
      if (callBack.isNotEmpty) {
        List<String> callBackList = callBack.cast<String>();

        if (kDebugMode) {
          debugPrint(callBack.toString());
        }
        return callBackList;
      } else {
        return [];
      }
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<String>> getAllModelsNames() async {
    try {
      List<dynamic> callBack = await RemoteDataSource().get(
        endPoint: "/get_modelname",
      );
      if (callBack.isNotEmpty) {
        List<String> callBackList = callBack.cast<String>();

        if (kDebugMode) {
          debugPrint(callBack.toString());
        }
        return callBackList;
      } else {
        return [];
      }
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<String>> getAllSourceTypes() async {
    try {
      List<dynamic> callBack = await RemoteDataSource().get(
        endPoint: "/get_sourcetype",
      );
      if (callBack.isNotEmpty) {
        List<String> callBackList = callBack.cast<String>();

        if (kDebugMode) {
          debugPrint(callBack.toString());
        }
        return callBackList;
      } else {
        return [];
      }
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  /// Add camera
  Future<AddCameraModel> addCamera({
    required String cameraName,
    required String sourceType,
    required String sourceData,
  }) async {
    try {
      Map<String, dynamic> callBack =
          await RemoteDataSource().postWithFile(endPoint: "/addCamera", body: {
        "cameraName": cameraName,
        "sourceType": sourceType,
        "source": sourceData,
      });
      if (callBack.isNotEmpty) {
        AddCameraModel callBackList = AddCameraModel.fromJson(callBack);
        return callBackList;
      } else {
        return AddCameraModel();
      }
    } catch (e) {
      return AddCameraModel();
    }
  }

  ///  Apply Model
  Future<ApplyModelModel> applyModelToCamera({
    required String cameraName,
    required List<String> modelName,
  }) async {
    try {
      Map<String, dynamic> callBack =
          await RemoteDataSource().postWithFile(endPoint: "/applyModel", body: {
        "cameraname": cameraName,
        // "modelname": modelName.join(","),
        "modelname": jsonEncode(modelName),
      });
      if (callBack.isNotEmpty) {
        ApplyModelModel callBackList = ApplyModelModel.fromJson(callBack);
        return callBackList;
      } else {
        return ApplyModelModel();
      }
    } catch (e) {
      return ApplyModelModel();
    }
  }

  Future<GetAllCameraCount> getAllCamerasCountsForDashboard(
      {required String cameraName}) async {
    try {
      var callBack = await RemoteDataSource().postWithFile(
          endPoint: "/postcam_getallmodelsStat",
          body: {"cameraname": cameraName});
      if (callBack.isNotEmpty) {
        GetAllCameraCount countsModel = GetAllCameraCount.fromJson(callBack);
        return countsModel;
      } else {
        return GetAllCameraCount();
      }
    } catch (e) {
      debugPrint(e.toString());
      return GetAllCameraCount();
    }
  }

  Future<List<GetAllCameraCountPerHour>>
      getAllCamerasCountsPerHourForDashboard({
    required String cameraName,
    required String day,
    required String month,
    required String year,
  }) async {
    Map<String,String> body ={};

    if(cameraName.isNotEmpty){
      body["cameraname"] = cameraName;
    }
    if(day.isNotEmpty){
      body["day"] = day;
    }
    if(month.isNotEmpty){
      body["month"] = month;
    }
    if(year.isNotEmpty){
      body["year"] = year;
    }

    try {
      List<dynamic> callBack = await RemoteDataSource()
          .postWithFile(endPoint: "/allmodelsstatistics",
          body: body
      //     {
      //   "cameraname": cameraName,
      //   "day": "19",
      //   "month": "2",
      //   "year": "2024",
      // }
      );
      if (callBack.isNotEmpty) {
        debugPrint("0-0-0-0$callBack");
        List<GetAllCameraCountPerHour> callbackList = [];
        for (var element in callBack) {
          callbackList.add(GetAllCameraCountPerHour.fromJson(element));
        }
        return callbackList;
      } else {
        return [];
      }
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }


  Future<GetAllCameraDetails> getAllCamerasDetails(
      {required String cameraName}) async {
    try {
      var callBack = await RemoteDataSource().postWithFile(
          endPoint: "/getallmodelsincam",
          body: {"cameraname": cameraName});
      if (callBack.isNotEmpty) {
        GetAllCameraDetails countsModel = GetAllCameraDetails.fromJson(callBack);
        return countsModel;
      } else {
        return GetAllCameraDetails();
      }
    } catch (e) {
      debugPrint(e.toString());
      return GetAllCameraDetails();
    }
  }

}
