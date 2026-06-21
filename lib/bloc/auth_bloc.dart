import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillday/events/auth_events.dart';
import 'package:skillday/repositry/auth_repositry.dart';
import 'package:skillday/states/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(AuthInitial()) {
    // REGISTER
    on<RegisterEvent>((event, emit) async {
      emit(AuthLoading());

      try {
        await repository.register(event.fullName, event.email, event.password);

        emit(AuthSuccess());
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    // LOGIN
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());

      try {
        await repository.login(event.email, event.password);

        emit(AuthSuccess());
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    // LOGOUT
    on<LogoutEvent>((event, emit) async {
      await repository.logout();
      emit(AuthInitial());
    });
  }
}
