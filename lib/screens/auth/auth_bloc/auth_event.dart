import 'package:front_insumos/models/user.dart';

abstract class AuthEvent {}

class CheckAuthEvent extends AuthEvent {}

class LoginEvent extends AuthEvent {
  final User user;

  LoginEvent({required this.user});
}


class LogoutEvent extends AuthEvent {}
