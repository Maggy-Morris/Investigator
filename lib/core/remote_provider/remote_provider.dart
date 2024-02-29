import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:Investigator/authentication/call_back_authentication.dart';
import 'package:Investigator/core/models/add_camera_model.dart';
import 'package:Investigator/core/models/apply_model_model.dart';
import 'package:Investigator/core/models/camera_details_model.dart';
import 'package:Investigator/core/models/dashboard_models.dart';
import 'package:Investigator/core/remote_provider/remote_data_source.dart';

import '../models/add_company_model.dart';
import '../models/call_back_model.dart';
import '../models/employee_model.dart';

enum AppLifecycleStatus { online, offline }

class RemoteProvider {
  static final RemoteProvider _inst = RemoteProvider._internal();

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
          endPoint: "/qdrant/login",
          body: {"username": email, "password": password});

      if (loginCallBack != null) {
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

  //SignUp API
  Future<UserData?> SignUpRemoteCredentials(
      String email, String password) async {
    try {
      var loginCallBack = await RemoteDataSource().postWithFile(
          endPoint: "/qdrant/signup",
          body: {"username": email, "password": password});

      if (loginCallBack != null) {
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

  ///Add Comany
  Future<CallBackModel> addCompany({
    required String companyName,
  }) async {
    try {
      Map<String, dynamic> callBack = await RemoteDataSource()
          .post(endPoint: "/qdrant/create_collection", body: {
        "collection_name": companyName,
      });

      //Change this "Collection Created Successfully!"
      if (callBack.isNotEmpty) {
        CallBackModel callBackList = CallBackModel.fromJson(callBack);
        return callBackList;
      } else {
        return CallBackModel();
      }
    } catch (e) {
      return CallBackModel();
    }
  }

  ///Delete Company
  Future<CallBackModel> deleteCompany({
    required String companyName,
  }) async {
    try {
      Map<String, dynamic> callBack = await RemoteDataSource()
          .post(endPoint: "/qdrant/delete_qcollection", body: {
        "collection_name": companyName,
      });

      //Change this "Collection Created Successfully!"
      if (callBack.isNotEmpty) {
        CallBackModel callBackList = CallBackModel.fromJson(callBack);
        return callBackList;
      } else {
        return CallBackModel();
      }
    } catch (e) {
      return CallBackModel();
    }
  }

  /// Get all EmployeeNames
  ///
  Future<List<Data>> getAllEmployeeNames({
    required String companyName,
  }) async {
    try {
      Map<String, dynamic> callBack = await RemoteDataSource()
          .post(endPoint: "/qdrant/retrieve_it_all", body: {
        "collection_name": companyName,
      });

      if (callBack.isNotEmpty && callBack['data'] != null) {
        // Extract the relevant data from the callBack
        List<dynamic> dataList = callBack['data'];

        // Map the extracted data to my EmployeeModel
        List<Data> employeeDataList =
            dataList.map((data) => Data.fromJson(data)).toList();

        return employeeDataList;
      } else {
        return [];
      }
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  // Future<EmployeeModel> getAllEmployeeNames({
  //   required String companyName,
  // }) async {
  //   try {
  //     // var callBack = await RemoteDataSource()

  //     Map<String, dynamic> callBack = await RemoteDataSource()
  //         .post(endPoint: "/qdrant/retrieve_it_all", body: {
  //       "collection_name": companyName,
  //     });
  //     if (callBack.isNotEmpty) {
  //       EmployeeModel employeeModel = EmployeeModel.fromJson(callBack);
  //       if (kDebugMode) {
  //         debugPrint(
  //             "kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk" + callBack.toString());
  //       }
  //       return employeeModel;
  //     } else {
  //       return EmployeeModel();
  //     }
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     return EmployeeModel();
  //   }
  // }

  ///get person data by name
  Future<EmployeeModel> getPersonByName(
      {required String companyName, required String personName}) async {
    try {
      var callBack = await RemoteDataSource().post(
          endPoint: "/qdrant/get_document_by_name",
          body: {"collection_name": companyName, "target_name": personName});
      if (callBack.isNotEmpty) {
        EmployeeModel employeeModel = EmployeeModel.fromJson(callBack);
        return employeeModel;
      } else {
        return EmployeeModel();
      }
    } catch (e) {
      debugPrint(e.toString());
      return EmployeeModel();
    }
  }

  ///get person data by ID
  Future<EmployeeModel> getDocumentById(
      {required String companyName, required String personId}) async {
    try {
      var callBack = await RemoteDataSource().post(
          endPoint: "/qdrant/get_document_by_id",
          body: {"collection_name": companyName, "point_id": personId});
      if (callBack.isNotEmpty) {
        EmployeeModel employeeModel = EmployeeModel.fromJson(callBack);
        return employeeModel;
      } else {
        return EmployeeModel();
      }
    } catch (e) {
      debugPrint(e.toString());
      return EmployeeModel();
    }
  }

  ///Delete person data by Name
  Future<EmployeeModel> deleteDocumentByName(
      {required String companyName, required String personName}) async {
    try {
      var callBack = await RemoteDataSource().post(
          endPoint: "/qdrant/delete_document_by_name",
          body: {"collection_name": companyName, "target_name": personName});
      if (callBack.isNotEmpty) {
        EmployeeModel employeeModel = EmployeeModel.fromJson(callBack);
        return employeeModel;
      } else {
        return EmployeeModel();
      }
    } catch (e) {
      debugPrint(e.toString());
      return EmployeeModel();
    }
  }

  ///Delete person data by ID
  Future<EmployeeModel> deleteDocumentById(
      {required String companyName, required String personId}) async {
    try {
      var callBack = await RemoteDataSource().post(
          endPoint: "/qdrant/delete_document_by_id",
          body: {"collection_name": companyName, "point_id": personId});
      if (callBack.isNotEmpty) {
        EmployeeModel employeeModel = EmployeeModel.fromJson(callBack);
        return employeeModel;
      } else {
        return EmployeeModel();
      }
    } catch (e) {
      debugPrint(e.toString());
      return EmployeeModel();
    }
  }

  // /// get all static lists
  // Future<List<String>> getAllCamerasNames() async {
  //   try {
  //     List<dynamic> callBack = await RemoteDataSource().get(
  //       endPoint: "/c",
  //     );
  //     if (callBack.isNotEmpty) {
  //       List<String> callBackList = callBack.cast<String>();

  //       if (kDebugMode) {
  //         debugPrint(callBack.toString());
  //       }
  //       return callBackList;
  //     } else {
  //       return [];
  //     }
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     return [];
  //   }
  // }

  // Future<List<String>> getAllModelsNames() async {
  //   try {
  //     List<dynamic> callBack = await RemoteDataSource().get(
  //       endPoint: "/get_modelname",
  //     );
  //     if (callBack.isNotEmpty) {
  //       List<String> callBackList = callBack.cast<String>();

  //       if (kDebugMode) {
  //         debugPrint(callBack.toString());
  //       }
  //       return callBackList;
  //     } else {
  //       return [];
  //     }
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     return [];
  //   }
  // }

  // Future<List<String>> getAllSourceTypes() async {
  //   try {
  //     List<dynamic> callBack = await RemoteDataSource().get(
  //       endPoint: "/get_sourcetype",
  //     );
  //     if (callBack.isNotEmpty) {
  //       List<String> callBackList = callBack.cast<String>();

  //       if (kDebugMode) {
  //         debugPrint(callBack.toString());
  //       }
  //       return callBackList;
  //     } else {
  //       return [];
  //     }
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     return [];
  //   }
  // }

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
  // Future<ApplyModelModel> applyModelToCamera({
  //   required String cameraName,
  //   required List<String> modelName,
  // }) async {
  //   try {
  //     Map<String, dynamic> callBack = await RemoteDataSource()
  //         .postWithFile(endPoint: "/Investigator", body: {
  //       "cameraname": cameraName,
  //       // "modelname": modelName.join(","),
  //       "modelname": jsonEncode(modelName),
  //     });
  //     if (callBack.isNotEmpty) {
  //       ApplyModelModel callBackList = ApplyModelModel.fromJson(callBack);
  //       return callBackList;
  //     } else {
  //       return ApplyModelModel();
  //     }
  //   } catch (e) {
  //     return ApplyModelModel();
  //   }
  // }

  // Future<GetAllCameraCount> getAllCamerasCountsForDashboard(
  //     {required String cameraName}) async {
  //   try {
  //     var callBack = await RemoteDataSource().postWithFile(
  //         endPoint: "/postcam_getallmodelsStat",
  //         body: {"cameraname": cameraName});
  //     if (callBack.isNotEmpty) {
  //       GetAllCameraCount countsModel = GetAllCameraCount.fromJson(callBack);
  //       return countsModel;
  //     } else {
  //       return GetAllCameraCount();
  //     }
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     return GetAllCameraCount();
  //   }
  // }

  // Future<List<GetAllCameraCountPerHour>>
  //     getAllCamerasCountsPerHourForDashboard({
  //   required String cameraName,
  //   required String day,
  //   required String month,
  //   required String year,
  // }) async {
  //   Map<String, String> body = {};

  //   if (cameraName.isNotEmpty) {
  //     body["cameraname"] = cameraName;
  //   }
  //   if (day.isNotEmpty) {
  //     body["day"] = day;
  //   }
  //   if (month.isNotEmpty) {
  //     body["month"] = month;
  //   }
  //   if (year.isNotEmpty) {
  //     body["year"] = year;
  //   }

  //   try {
  //     List<dynamic> callBack = await RemoteDataSource()
  //         .postWithFile(endPoint: "/allmodelsstatistics", body: body
  //             //     {
  //             //   "cameraname": cameraName,
  //             //   "day": "19",
  //             //   "month": "2",
  //             //   "year": "2024",
  //             // }
  //             );
  //     if (callBack.isNotEmpty) {
  //       debugPrint("0-0-0-0$callBack");
  //       List<GetAllCameraCountPerHour> callbackList = [];
  //       for (var element in callBack) {
  //         callbackList.add(GetAllCameraCountPerHour.fromJson(element));
  //       }
  //       return callbackList;
  //     } else {
  //       return [];
  //     }
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     return [];
  //   }
  // }

  Future<GetAllCameraDetails> getAllCamerasDetails(
      {required String cameraName}) async {
    try {
      var callBack = await RemoteDataSource().postWithFile(
          endPoint: "/getallmodelsincam", body: {"cameraname": cameraName});

      if (callBack.isNotEmpty) {
        GetAllCameraDetails countsModel =
            GetAllCameraDetails.fromJson(callBack);
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
