import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginButtonPressed extends LoginEvent {
  final String username;
  final String password;
  final String fcmToken;

  const LoginButtonPressed({required this.username, required this.password, required this.fcmToken});

  @override
  List<Object> get props => [username, password,fcmToken];
}

class GetUserDataLogin extends LoginEvent {
  const GetUserDataLogin();

  @override
  List<Object> get props => [];
}

class LogoutButtonPressed extends LoginEvent {}
