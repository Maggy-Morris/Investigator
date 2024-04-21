import 'dart:async';
import 'dart:convert';

// import 'package:Investigator/core/widgets/toast/toast.dart';
import 'package:flutter/foundation.dart';
import 'package:Investigator/core/remote_provider/remote_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Investigator/authentication/call_back_authentication.dart';

enum AuthenticationStatus { authenticated, unauthenticated }

class AuthenticationRepository {
  // late final AuthenticationProvider authenticationProvider = AuthenticationProvider();
  final StreamController<UserData> controller = StreamController<UserData>();

  static const userCacheKey = '__user_cache_key__';
  static const usernameCacheKey = '__username_cache_key__';
  static const passwordCacheKey = '__password_cache_key__';
  static const companyNameCacheKey = '__companyName_cache_key__';
  static const roomsNamesCacheKey = '__roomsNames_cache_key__';

  static const routesCacheKey = '__routes_cache_key__';

  // final CacheClient _cache = CacheClient();
  static SharedPreferences? sharedUser;

  AuthenticationRepository._();

  static final AuthenticationRepository _singleton = AuthenticationRepository();
  static final instance = AuthenticationRepository._();

  static getInstance() async {
    if (kDebugMode) {
      // print("init shared global");
    }
    sharedUser ??= await SharedPreferences.getInstance();
    if (instance != null) {
      return instance;
    } else {
      return AuthenticationRepository();
    }
  }

  AuthenticationRepository() {
    init();
  }

  Future init() async {}

  Stream<UserData> get userData async* {
    String? data = sharedUser?.getString(userCacheKey);
    if (data != null) {
      try {
        Map userMap = jsonDecode(data);
        String? username = sharedUser?.getString(usernameCacheKey);
        String? password = sharedUser?.getString(passwordCacheKey);
        String? comapnyName = sharedUser?.getString(companyNameCacheKey);
        String? roomsNamesString = sharedUser?.getString(roomsNamesCacheKey);
        List<String>? roomsNames = roomsNamesString != null
            ? List<String>.from(jsonDecode(roomsNamesString))
            : null;
        var user = UserData.fromJson(userMap as Map<String, dynamic>);
        controller.add(user);

        logInWithEmailAndPassword(
          email: username ?? "",
          password: password ?? "",
          // companyName: comapnyName ?? "",
        );
      } catch (e) {
        controller.add(UserData.empty);
      }
      // Map userMap = jsonDecode(data);
      // var user = UserData.fromJson(userMap as Map<String, dynamic>);
      // controller.add(user);
    } else {
      controller.add(UserData.empty);
    }

    yield* controller.stream;

    // return user;
    // return _firebaseAuth.authStateChanges().map((firebaseUser) {
    //   final user = firebaseUser == null ? User.empty : firebaseUser.toUser;
    //   shared_User.setString(userCacheKey, user.toString());
    //   return user;
    // });
  }

  UserData get currentUser {
    try {
      String? data = sharedUser?.getString(userCacheKey);
      String? username = sharedUser?.getString(usernameCacheKey);
      String? password = sharedUser?.getString(passwordCacheKey);
      String? companyName = sharedUser?.getString(companyNameCacheKey);
      String? roomsNamesString = sharedUser?.getString(roomsNamesCacheKey);
      // Decode the JSON string back to a list of strings
      if (roomsNamesString != null) {
        List<String>? roomsNames =
            List<String>.from(jsonDecode(roomsNamesString));
      }

      // List<String>? roomsNames = roomsNamesString != null
      //     ? List<String>.from(jsonDecode(roomsNamesString))
      //     : null;

      UserData? user = UserData.fromJson(
        jsonDecode(data ?? "") as Map<String, dynamic>,
      );

      return user;
    } catch (e) {
      return UserData.empty;
    }
    // return User.empty;
  }

  Future<void> updateRoomsNames(List<String> updatedRoomsNames) async {
    try {
      // Convert list of strings to JSON string before saving

      // UserData ahmed = currentUser;

      UserData ahmed1 = currentUser.copyWith(
          roomsNames: updatedRoomsNames, nRooms: updatedRoomsNames.length);
      String updatedRoomsNamesJson = jsonEncode(updatedRoomsNames);
      // Save the updated roomsNames to SharedPreferences

      sharedUser?.setString(roomsNamesCacheKey, updatedRoomsNamesJson);
      sharedUser?.setString(userCacheKey, jsonEncode(ahmed1));
      controller.add(ahmed1);
    } catch (e) {
      // Handle error
      print("Error updating roomsNames: $e");
    }
  }

  /// Signs in with the provided [email] and [password].
  ///
  /// Throws a [LogInWithEmailAndPasswordFailure] if an exception occurs.
  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
    // required String companyName,
  }) async {
    try {
      await RemoteProvider().loginRemoteCredentials(email, password).then(
        (value) {
          if (value?.token != null) {
            String companyName = value!.companyName?.first ??
                ""; // Adjust this according to your response structure
            List<String>? roomNames = value.roomsNames;
            sharedUser?.setString(userCacheKey, jsonEncode(value));
            sharedUser?.setString(passwordCacheKey, password);

            sharedUser?.setString(usernameCacheKey, email);
            sharedUser?.setString(companyNameCacheKey, companyName);
            // sharedUser?.setString(roomsNamesCacheKey, roomNames);
            if (roomNames != null) {
              // Convert list of strings to JSON string before saving
              String roomNamesJson = jsonEncode(roomNames);
              sharedUser?.setString(roomsNamesCacheKey, roomNamesJson);
            }
            sharedUser?.setStringList(routesCacheKey, ["/"]);

            controller.add(value);
          } else if (value!.logined == false) {
            throw LogInWithEmailAndPasswordFailureFirebase.fromCode(
                "email or password is incorrect");
          } else {
            controller.add(UserData.empty);
            logOut();
            return;
          }
        },
      );
    } catch (e) {
      if (e.toString().isNotEmpty) {
        throw LogInWithEmailAndPasswordFailureFirebase.fromCode(e.toString());
      } else {
        throw const LogInWithEmailAndPasswordFailureFirebase();
      }
    }
  }

  /// Signs Up with the provided [email] and [password] and [companyName]

  Future<void> SignUpWithEmailAndPassword({
    required String email,
    required String password,
    required String companyName,
    required List<String> roomNames,
    required int roomsNumber,
  }) async {
    try {
      // final modelAuth =
      await RemoteProvider()
          .SignUpRemoteCredentials(
              email, password, companyName, roomsNumber, roomNames)
          .then(
        (value) {
          if (value.logined == "Signed up successfully!") {
            // sharedUser?.setString(userCacheKey, jsonEncode(value));
            // sharedUser?.setString(usernameCacheKey, email);
            // sharedUser?.setString(passwordCacheKey, password);
            // sharedUser?.setString(companyNameCacheKey, companyName);

            // sharedUser?.setStringList(routesCacheKey, ["/"]);

            // controller.add(value!);
          } else if (value.logined == "E-mail is already  in use") {
            throw SignUpWithEmailAndPasswordFailureFirebase.fromCode(
                "E-mail is already  in use");
          } else {
            controller.add(UserData.empty);
            logOut();

            return;
          }
        },
      );
    } catch (e) {
      if (e.toString().isNotEmpty) {
        throw SignUpWithEmailAndPasswordFailureFirebase.fromCode(e.toString());
      } else {
        throw const SignUpWithEmailAndPasswordFailureFirebase();
      }
    }
  }

  Future<void> logOut() async {
    try {
      sharedUser?.clear();
      controller.add(UserData.empty);
    } catch (_) {
      throw LogOutFailure();
    }
  }

// Stream<User> get user async* {
//   await Future<void>.delayed(const Duration(seconds: 1));
//   var user = _cache.read<User>(key: userCacheKey) ?? User.empty;
//   yield user;
// }

// void dispose() => _controller.close();
}

/// Thrown during the logout process if a failure occurs.
class LogOutFailure implements Exception {}

class SignUpWithEmailAndPasswordFailureFirebase implements Exception {
  /// {@macro sign_up_with_email_and_password_failure}
  const SignUpWithEmailAndPasswordFailureFirebase([
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  /// https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/createUserWithEmailAndPassword.html
  factory SignUpWithEmailAndPasswordFailureFirebase.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const SignUpWithEmailAndPasswordFailureFirebase(
          'Email is not valid or badly formatted.',
        );
      case 'user-disabled':
        return const SignUpWithEmailAndPasswordFailureFirebase(
          'This user has been disabled. Please contact support for help.',
        );
      case 'email-already-in-use':
        return const SignUpWithEmailAndPasswordFailureFirebase(
          'An account already exists for that email.',
        );
      case 'operation-not-allowed':
        return const SignUpWithEmailAndPasswordFailureFirebase(
          'Operation is not allowed.  Please contact support.',
        );
      case 'weak-password':
        return const SignUpWithEmailAndPasswordFailureFirebase(
          'Please enter a stronger password.',
        );
      default:
        return const SignUpWithEmailAndPasswordFailureFirebase();
    }
  }

  /// The associated error message.
  final String message;
}

class LogInWithEmailAndPasswordFailureFirebase implements Exception {
  /// {@macro log_in_with_email_and_password_failure}
  const LogInWithEmailAndPasswordFailureFirebase([
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  factory LogInWithEmailAndPasswordFailureFirebase.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        if (kDebugMode) {
          print("Email is not valid or badly formatted.");
        }
        return const LogInWithEmailAndPasswordFailureFirebase(
          'Email is not valid or badly formatted.',
        );
      case 'user-disabled':
        if (kDebugMode) {
          print(
              "This user has been disabled. Please contact support for help.");
        }
        return const LogInWithEmailAndPasswordFailureFirebase(
          'This user has been disabled. Please contact support for help.',
        );
      case 'dont-have-permission':
        if (kDebugMode) {
          print(
              "This user doesnt have permission. Please contact support for help.");
        }
        return const LogInWithEmailAndPasswordFailureFirebase(
          'This user doesnt have permission. Please contact support for help.',
        );
      case 'user-not-found':
        if (kDebugMode) {
          print("Email is not found, please create an account.");
        }
        return const LogInWithEmailAndPasswordFailureFirebase(
          'Email is not found, please create an account.',
        );
      case 'wrong-password':
        return const LogInWithEmailAndPasswordFailureFirebase(
          'Incorrect password, please try again.',
        );
      default:
        return const LogInWithEmailAndPasswordFailureFirebase();
    }
  }

  /// The associated error message.
  final String message;
}
