import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_insumos/api/api_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiService apiService;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  AuthBloc({required this.apiService}) : super(AuthInitial()) {
    on<CheckAuthEvent>(_onCheckAuth);
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onCheckAuth(
      CheckAuthEvent event, Emitter<AuthState> emit) async {
    final token = await secureStorage.read(key: 'jwt');
    final name = await secureStorage.read(key: 'name');
    final email = await secureStorage.read(key: 'email');
    final userType = await secureStorage.read(key: 'userType');

    if (token != null && email != null && userType != null) {
      emit(AuthAuthenticated(
        name: name ?? '',
        email: email,
        userType: userType,
        token: token,
      ));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await apiService.login(event.email, event.password);
      if (response != null && response.statusCode == 200) {
        final data = response.data;
        final token = data['access_token'];
        final user = data['user'];

        // Salva no storage
        await secureStorage.write(key: 'jwt', value: token);
        await secureStorage.write(key: 'name', value: user['name']);
        await secureStorage.write(key: 'email', value: user['email']);
        await secureStorage.write(key: 'userType', value: user['user_type']);

        emit(AuthAuthenticated(
          name: user['name'],
          email: user['email'],
          userType: user['user_type'],
          token: token,
        ));
      } else {
        emit(AuthError('Credenciais inválidas.'));
      }
    } catch (e) {
      emit(AuthError('Erro de login: ${e.toString()}'));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    await secureStorage.deleteAll();
    emit(AuthUnauthenticated());
  }
}
