part of 'auth_bloc.dart';

abstract class AuthEvent {}

final class SelectUser extends AuthEvent {
  SelectUser(this.userId);
  final int userId;
}

final class ClearUser extends AuthEvent {}
