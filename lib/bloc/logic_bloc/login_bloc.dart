import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import '../../data/api/ApiService.dart';
import '../event/login_event.dart';
import '../state/common_state.dart';

class LoginBloc extends Bloc<LoginEvent, CommonState> {
  LoginBloc() : super(InitialState()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
    on<GetUserDataLogin>(_onGetUserData);
  }

  Future<void> _onLoginButtonPressed(
      LoginButtonPressed event, Emitter<CommonState> emit) async {
    // Handle the LoginButtonPressed event
    emit(LoadingState());

    try {
      dynamic response =
          await ApiService().getUserLogin(event.username.trim(), event.password,event.fcmToken);

      // Process the API response
      // Emit a success state
      if (kDebugMode) {
        print("api response--$response");
      }
      emit(SuccessState(response));
    } catch (error) {
      // Emit a failure state
      emit(FailureState(error.toString()));
    }
  }

  Future<void> _onGetUserData(
      GetUserDataLogin event, Emitter<CommonState> emit) async {
    // Handle the Get User Data event
    emit(LoadingState());

    try {
      dynamic getUserData = await ApiService().getUserData();
      // Process the API response
      // Emit a success state
      if (kDebugMode) {
        print(getUserData);
      }
      emit(UserDataSuccessState(getUserData));
    } catch (error) {
      // Emit a failure state
      emit(FailureState(error.toString()));
    }
  }

// Other methods and event handlers...
}
