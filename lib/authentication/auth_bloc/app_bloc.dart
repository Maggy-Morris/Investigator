import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../authentication/authentication_repository.dart';
import '../call_back_authentication.dart';


part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  static AppBloc get(context) => BlocProvider.of(context);
  AppBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(
          // authenticationRepository.currentUser.isNotEmpty
          //     ? AppState.authenticated(authenticationRepository.currentUser)
          //     :
          const AppState.unauthenticated(),
        ) {
    on<AppUserChanged>(_onUserChanged);
    on<AppLogoutRequested>(_onLogoutRequested);
    _userSubscription = _authenticationRepository.userData.listen(
      (user) => add(AppUserChanged(user)),
    );
  }

  final AuthenticationRepository _authenticationRepository;
  late final StreamSubscription<UserData> _userSubscription;


  void _onUserChanged(AppUserChanged event, Emitter<AppState> emit) async{
    // String username = event.user.username ?? "";
    String authentication = event.user.token ?? "";
    // if (kDebugMode) {
    //   print("=====>> $name");
    // }
    if(
    // username.isEmpty ||
        authentication.isEmpty){
      emit(state.copyWith(status: AppStatus.unauthenticated));
    }else{
      emit(
        (event.user.token?.isNotEmpty??false)
            ? state.copyWith(user: event.user,status: AppStatus.authenticated)
            : const AppState.unauthenticated(),
      );
    }
 
  }

  void _onLogoutRequested(AppLogoutRequested event, Emitter<AppState> emit) {
    unawaited(_authenticationRepository.logOut());
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
