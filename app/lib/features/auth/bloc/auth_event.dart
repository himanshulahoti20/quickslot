part of 'auth_bloc.dart';

sealed class AuthEvent {}

final class SelectUser extends AuthEvent {
  SelectUser(this.user);
  final AppUser user;
}

final class SignOut extends AuthEvent {}
