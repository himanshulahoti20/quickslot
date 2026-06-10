part of 'auth_bloc.dart';

abstract class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthAuthenticated extends AuthState {
  AuthAuthenticated({required this.userId, required this.userName});
  final int userId;
  final String userName;
}
