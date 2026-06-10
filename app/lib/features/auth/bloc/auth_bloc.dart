import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/core/api/api_client.dart';
import 'package:app/features/auth/models/app_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<SelectUser>(_onSelectUser);
  }

  void _onSelectUser(SelectUser event, Emitter<AuthState> emit) {
    ApiClient.currentUserId = event.user.id;
    emit(AuthAuthenticated(event.user));
  }
}
