part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthenticateUser extends AuthEvent {
  String username;
  String password;
  AuthenticateUser({required this.username, required this.password});
}
