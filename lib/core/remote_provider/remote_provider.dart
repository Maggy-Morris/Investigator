import 'package:Investigator/core/models/pathes_model.dart';
import 'package:Investigator/core/models/search_by_video.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:Investigator/authentication/call_back_authentication.dart';
import 'package:Investigator/core/models/add_camera_model.dart';
// import 'package:Investigator/core/models/apply_model_model.dart';
import 'package:Investigator/core/models/camera_details_model.dart';
// import 'package:Investigator/core/models/dashboard_models.dart';
import 'package:Investigator/core/remote_provider/remote_data_source.dart';

// import '../models/add_company_model.dart';
import '../models/add_person_model.dart';
import '../models/call_back_model.dart';
import '../models/dashboard_models.dart';
import '../models/delete_model.dart';
import '../models/employee_model.dart';
import '../models/search_by_image_model.dart';
import '../models/search_by_video_in_group_search.dart';
import '../models/sigup_model.dart';
import '../models/update_model.dart';
import '../models/update_password_model.dart';

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
        body: {
          "username": email,
          "password": password,
        },
      );

      if (loginCallBack != null) {
        UserData callBackDetailID = UserData.fromJson(loginCallBack);
        if (kDebugMode) {
          debugPrint(loginCallBack.toString());
        }
        return callBackDetailID;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  //SignUp API
  Future<signupModel> SignUpRemoteCredentials(
    String email,
    String password,
    String companyName,
    int roomsNumber,
    List<String> roomNames,
  ) async {
    try {
      Map<String, dynamic> signUpCallBack =
          await RemoteDataSource().post(endPoint: "/qdrant/signup", body: {
        "username": email,
        "password": password,
        "company_name": companyName,
        "n_rooms": roomsNumber,
        "rooms_names": roomNames,
      });

      if (signUpCallBack.isNotEmpty) {
        signupModel callBackList = signupModel.fromJson(signUpCallBack);

        // UserData callBackDetailID = UserData.fromJson(signUpCallBack);

        // if (kDebugMode) {
        //   debugPrint(signUpCallBack.toString());
        // }
        return callBackList;
        // return AddNewMainPersonalDataInitial.fromJson(callBackRemote.data ?? {});
        // } else {
        //   return null;
        // }
      } else {
        return signupModel();
      }
    } catch (e) {
      debugPrint(e.toString());
      return signupModel();
    }
  }

  ///edit Rooms Data

  Future<UpdateModel> UpdateRooms({
    // required String companyName,
    required String email,
    required int roomsNumber,
    required List<String> roomNames,
  }) async {
    try {
      Map<String, dynamic> callBack = await RemoteDataSource().post(
        endPoint: "/qdrant/update_rooms",
        body: {
          "username": email,
          "n_rooms": roomsNumber,
          "rooms_names": roomNames,
        },
      );
      // debugPrint(callBack);
      //Change this "Collection Created Successfully!"

      if (callBack.isNotEmpty) {
        UpdateModel callBackList = UpdateModel.fromJson(callBack);

        return callBackList;
      } else {
        return UpdateModel();
      }
    } catch (e) {
      return UpdateModel();
    }
  }

  ///edit Password Data

  Future<UpdatePasswordModel> UpdatePassword({
    required String password,
    required String oldPassword,
    required String email,
  }) async {
    try {
      Map<String, dynamic> callBack = await RemoteDataSource().post(
        endPoint: "/qdrant/update_password",
        body: {
          "username": email,
          "password": password,
          "old_password": oldPassword,
        },
      );

      //Change this "Collection Created Successfully!"

      if (callBack.isNotEmpty) {
        UpdatePasswordModel callBackList =
            UpdatePasswordModel.fromJson(callBack);

        return callBackList;
      } else {
        return UpdatePasswordModel();
      }
    } catch (e) {
      return UpdatePasswordModel();
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

  /// Add New Person with image as stream of bytes
  Future<AddPersonModel> addNewPersonToACompany({
    required String companyName,
    required String personName,
    // required PlatformFile? image,
    required String image,
    required String email,
    required String phoneNum,
    required String userId,
    required String blackListed,
    List<String>? roomNamesChoosen,
  }) async {
    try {
      Map<String, dynamic> body = {
        "blacklisted": blackListed,
        "collection_name": companyName,
        "target_name": personName,
        "image": image,
        "email": email,
        "phone": phoneNum,
        "user_id": userId,
      };

      // Conditionally include roomNamesChoosen in the body if it's not empty
      if (roomNamesChoosen != null) {
        body["IAM"] = roomNamesChoosen;
      }
      Map<String, dynamic> callBack = await RemoteDataSource().post(
        endPoint: "/add_a_new_person",
        body: body,
      );

      if (callBack.isNotEmpty) {
        AddPersonModel addPersonModel = AddPersonModel.fromJson(callBack);
        return addPersonModel;
      } else {
        return AddPersonModel();
      }
    } catch (e) {
      return AddPersonModel();
    }
  }

  /// Add New Person with image as stream of bytes
  Future<UpdateModel> UpdateEmployeeData({
    required String companyName,
    required String personName,
    required String email,
    required String id,
    required String phoneNum,
    required String userId,
    required String blackListed,
    List<String>? roomNamesChoosen,
  }) async {
    try {
      Map<String, dynamic> body = {
        "collection_name": companyName,
        "_id": id,
        "data": {
          if (blackListed.isNotEmpty) "blacklisted": blackListed,
          "target_name": personName,
          "email": email,
          "phone": phoneNum,
          "user_id": userId,
          if (roomNamesChoosen != null) "IAM": roomNamesChoosen,
        }
      };

      // if (roomNamesChoosen != null) {
      //   body["IAM"] = roomNamesChoosen;
      // }
      Map<String, dynamic> callBack = await RemoteDataSource().post(
        endPoint: "/qdrant/update_user",
        body: body,
      );

      //Change this "Collection Created Successfully!"

      if (callBack.isNotEmpty) {
        UpdateModel updateModel = UpdateModel.fromJson(callBack);
        return updateModel;
      } else {
        return UpdateModel();
      }
    } catch (e) {
      return UpdateModel();
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

  Future<EmployeeModel> getAllEmployeeNames({
    required String companyName,
    required int pageNumber,
  }) async {
    try {
      Map<String, dynamic> callBack = await RemoteDataSource()
          .post(endPoint: "/qdrant/retrieve_it_all", body: {
        "collection_name": companyName,
        "page_number": pageNumber,
      });

      if (callBack.isNotEmpty) {
        // Extract the relevant data from the callBack
        // List<dynamic> dataList = callBack['data'];
        EmployeeModel general = EmployeeModel.fromJson(callBack);
        // Map the extracted data to my EmployeeModel
        // List<Data> employeeDataList =
        //     dataList.map((data) => Data.fromJson(data)).toList();

        return general;
      } else {
        return EmployeeModel();
      }
    } catch (e) {
      debugPrint(e.toString());
      return EmployeeModel();
    }
  }

  ///

  Future<EmployeeModel> getOnlyNormalEmployeeNames({
    required String companyName,
    required int pageNumber,
  }) async {
    try {
      Map<String, dynamic> callBack = await RemoteDataSource()
          .post(endPoint: "/qdrant/retrieve_it_all_normal", body: {
        "collection_name": companyName,
        "page_number": pageNumber,
      });

      if (callBack.isNotEmpty) {
        // Extract the relevant data from the callBack
        // List<dynamic> dataList = callBack['data'];
        EmployeeModel general = EmployeeModel.fromJson(callBack);
        // Map the extracted data to my EmployeeModel
        // List<Data> employeeDataList =
        //     dataList.map((data) => Data.fromJson(data)).toList();

        return general;
      } else {
        return EmployeeModel();
      }
    } catch (e) {
      debugPrint(e.toString());
      return EmployeeModel();
    }
  }

  ///
  Future<EmployeeModel> getOnlyBlackListedEmployeeNames({
    required String companyName,
    required int pageNumber,
  }) async {
    try {
      Map<String, dynamic> callBack = await RemoteDataSource()
          .post(endPoint: "/qdrant/retrieve_it_all_blacklisted", body: {
        "collection_name": companyName,
        "page_number": pageNumber,
      });

      if (callBack.isNotEmpty) {
        // Extract the relevant data from the callBack
        // List<dynamic> dataList = callBack['data'];
        EmployeeModel general = EmployeeModel.fromJson(callBack);
        // Map the extracted data to my EmployeeModel
        // List<Data> employeeDataList =
        //     dataList.map((data) => Data.fromJson(data)).toList();

        return general;
      } else {
        return EmployeeModel();
      }
    } catch (e) {
      debugPrint(e.toString());
      return EmployeeModel();
    }
  }

  ///get person data by name
  Future<List<Data>> getPersonByName(
      {required String companyName, required String personName}) async {
    try {
      var callBack = await RemoteDataSource().post(
          endPoint: "/qdrant/get_document_by_name",
          body: {"collection_name": companyName, "target_name": personName});

      if (callBack.isNotEmpty) {
        // Extract the relevant data from the callBack
        EmployeeModel general = EmployeeModel.fromJson(callBack);

        // CallBackModel callBackList = CallBackModel.fromJson(callBack);
        return general.data ?? [];
      } else {
        return [];
      }
    } catch (e) {
      return [];
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

  Future<DeleteModel> deleteDocumentByName(
      {required String companyName, required String personName}) async {
    try {
      var callBack = await RemoteDataSource().post(
          endPoint: "/qdrant/delete_document_by_name",
          body: {"collection_name": companyName, "target_name": personName});
      if (callBack.isNotEmpty) {
        DeleteModel deleteModel = DeleteModel.fromJson(callBack);
        return deleteModel;
      } else {
        return DeleteModel();
      }
    } catch (e) {
      debugPrint(e.toString());
      return DeleteModel();
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

  ///Search for person in the database by image
  Future<SearchByImageModel> searchForpersonByImage({
    required String companyName,
    required String username,
    // required PlatformFile? image,
    required String image,
  }) async {
    try {
      Map<String, dynamic> callBack = await RemoteDataSource().post(
        endPoint: "/search_with_image",
        body: {
          "collection_name": companyName,
          "image": image,
          "username": username,
        },
      );

      if (callBack.isNotEmpty) {
        SearchByImageModel callBackList = SearchByImageModel.fromJson(callBack);
        return callBackList;
      } else {
        return SearchByImageModel();
      }
    } catch (e) {
      return SearchByImageModel();
    }
  }

  ///Search for person in the database by Video
  Future<SearchByVideoInGroupSearch> searchForpersonByVideoGroupSearch({
    required PlatformFile? video,
    required String similarityScore,
    required String filterCase,
    required String companyName,
  }) async {
    try {
      Map<String, String> body = {
        "collection_name": companyName,
        "similarity_score": similarityScore,
        "search_type": filterCase,
      };

      Map<String, dynamic>? callBack =
          await RemoteDataSource().postMultiPartFiles(
        endPoint: "/search_in_video",
        body: body,
        files: [
          video!,
        ],
      );

      if (callBack != null) {
        return SearchByVideoInGroupSearch.fromJson(callBack);
      } else {
        return SearchByVideoInGroupSearch();
      }
    } catch (e) {
      return SearchByVideoInGroupSearch();
    }
  }

  ///Search for person in the database by Video
  Future<SearchByVideoAndImage> searchForpersonByVideo({
    required PlatformFile? video,
    // required PlatformFile? image,
    required List<PlatformFile>? images,
    required String similarityScore,
    required String companyName,
  }) async {
    try {
      Map<String, String> body = {
        "similarity_score": similarityScore,
        "collection_name": companyName,
      };

      Map<String, dynamic>? callBack = await RemoteDataSource()
          .postMultiPartListOfListFiles(
              endPoint: "/find_target",
              body: body,
              files: {
            "video": video,
            "imagesList": images,
          });

      if (callBack != null && callBack.isNotEmpty) {
        return SearchByVideoAndImage.fromJson(callBack);
      } else {
        return SearchByVideoAndImage();
      }
    } catch (e) {
      return SearchByVideoAndImage();
    }
  }

  // Future<List<GetAllCameraCountPerHour>>
  //     getAllCamerasCountsPerHourForDashboard({
  //   required String cameraName,
  //   // required String startDay,
  //   // required String endDay,
  //   // required String day,
  //   // required String startMonth,
  //   // required String endMonth,
  //   // required String month,
  //   // required String startYear,
  //   // required String endYear,
  //   // required String year,
  //   // required String hour,
  //   // required String minute,
  // }) async {
  //   Map<String, String> body = {};

  //   if (cameraName.isNotEmpty) {
  //     body["cameraname"] = cameraName;
  //   }

  //   // if (minute.isNotEmpty) {
  //   //   body["minute"] = minute;
  //   // }

  //   // if (hour.isNotEmpty) {
  //   //   body["hour"] = hour;
  //   // }
  //   // if (startDay.isNotEmpty) {
  //   //   body["start_day"] = startDay;
  //   // }
  //   // if (endDay.isNotEmpty) {
  //   //   body["end_day"] = endDay;
  //   // }
  //   // if (day.isNotEmpty) {
  //   //   body["day"] = day;
  //   // }
  //   // if (startMonth.isNotEmpty) {
  //   //   body["start_month"] = startMonth;
  //   // }

  //   // if (endMonth.isNotEmpty) {
  //   //   body["end_month"] = endMonth;
  //   // }
  //   // if (month.isNotEmpty) {
  //   //   body["month"] = month;
  //   // }
  //   // if (startYear.isNotEmpty) {
  //   //   body["start_year"] = startYear;
  //   // }
  //   // if (endYear.isNotEmpty) {
  //   //   body["end_year"] = endYear;
  //   // }
  //   // if (year.isNotEmpty) {
  //   //   body["year"] = year;
  //   // }

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

  // Future<GetAllCameraDetails> getAllCamerasDetails(
  //     {required String cameraName}) async {
  //   try {
  //     var callBack = await RemoteDataSource().postWithFile(
  //         endPoint: "/getallmodelsincam", body: {"cameraname": cameraName});
  //     if (callBack.isNotEmpty) {
  //       GetAllCameraDetails countsModel =
  //           GetAllCameraDetails.fromJson(callBack);
  //       return countsModel;
  //     } else {
  //       return GetAllCameraDetails();
  //     }
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     return GetAllCameraDetails();
  //   }
  // }

// get all pathes
  Future<pathes_model> getAllPathes({
    required String companyName,
  }) async {
    try {
      Map<String, dynamic> callBack =
          await RemoteDataSource().post(endPoint: "/history", body: {
        "collection_name": companyName,
      });

      if (callBack.isNotEmpty) {
        pathes_model callBackList = pathes_model.fromJson(callBack);
        // print(callBackList);
        return callBackList;
      } else {
        // Return a Future<pathes_model> with an empty list
        return Future.value(
            pathes_model()); // Adjust this according to your pathes_model constructor
      }
    } catch (e) {
      debugPrint(e.toString());
      // Return a Future<pathes_model> with an empty list
      return Future.value(
          pathes_model()); // Adjust this according to your pathes_model constructor
    }
  }

  // /// Get paginted frames
  // Future<EmployeeModel> getPaginationPagesForFrames({
  //   required String pathProvided,
  //   required int pageNumber,
  // }) async {
  //   try {
  //     Map<String, dynamic> callBack = await RemoteDataSource()
  //         .post(endPoint: "/qdrant/retrieve_it_all", body: {
  //       "Path_privided": pathProvided,
  //       "page_number": pageNumber,
  //     });

  //     if (callBack.isNotEmpty) {
  //       // Extract the relevant data from the callBack
  //       // List<dynamic> dataList = callBack['data'];
  //       EmployeeModel general = EmployeeModel.fromJson(callBack);
  //       // Map the extracted data to my EmployeeModel
  //       // List<Data> employeeDataList =
  //       //     dataList.map((data) => Data.fromJson(data)).toList();

  //       return general;
  //     } else {
  //       return EmployeeModel();
  //     }
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     return EmployeeModel();
  //   }
  // }

  // Future<SearchByVideoAndImage> searchForpersonByVideo({
  //   required PlatformFile? video,
  //   required PlatformFile? image,
  //   required String similarityScore,
  //   // required String personName,
  // }) async {
  //   try {
  //     Map<String, dynamic> callBack =
  //         await RemoteDataSource().postMultiPartFiles(
  //       endPoint: "/find_target",
  //       body: {
  //         "similarity_score": similarityScore,
  //         "name": "personName",
  //       },

  //       files: [
  //         video!,
  //         image!,
  //       ],
  //     );
  //     if (callBack.isNotEmpty) {
  //       SearchByVideoAndImage callBackList =
  //           SearchByVideoAndImage.fromJson(callBack);

  //       return callBackList;
  //     } else {
  //       return SearchByVideoAndImage();
  //     }
  //   } catch (e) {
  //     return SearchByVideoAndImage();
  //   }
  // }

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
  // Future<AddCameraModel> addCamera({
  //   required String cameraName,
  //   required String sourceType,
  //   required String sourceData,
  // }) async {
  //   try {
  //     Map<String, dynamic> callBack =
  //         await RemoteDataSource().postWithFile(endPoint: "/addCamera", body: {
  //       "cameraName": cameraName,
  //       "sourceType": sourceType,
  //       "source": sourceData,
  //     });
  //     if (callBack.isNotEmpty) {
  //       AddCameraModel callBackList = AddCameraModel.fromJson(callBack);
  //       return callBackList;
  //     } else {
  //       return AddCameraModel();
  //     }
  //   } catch (e) {
  //     return AddCameraModel();
  //   }
  // }

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

//   Future<GetAllCameraDetails> getAllCamerasDetails(
//       {required String cameraName}) async {
//     try {
//       var callBack = await RemoteDataSource().postWithFile(
//           endPoint: "/getallmodelsincam", body: {"cameraname": cameraName});

//       if (callBack.isNotEmpty) {
//         GetAllCameraDetails countsModel =
//             GetAllCameraDetails.fromJson(callBack);
//         return countsModel;
//       } else {
//         return GetAllCameraDetails();
//       }
//     } catch (e) {
//       debugPrint(e.toString());
//       return GetAllCameraDetails();
//     }
//   }
}
