import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_insumos/api/api_service.dart';
import 'package:front_insumos/models/user.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiService apiService;
  final FlutterSecureStorage secureStorage;

  AuthBloc({required this.apiService, required this.secureStorage})
      : super(AuthInitial()) {
    on<CheckAuthEvent>(_onCheckAuth);
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onCheckAuth(
      CheckAuthEvent event, Emitter<AuthState> emit) async {
    emit(AuthChecking());
    final token = await secureStorage.read(key: 'jwt');
    final name = await secureStorage.read(key: 'name');
    final email = await secureStorage.read(key: 'email');
    final userType = await secureStorage.read(key: 'userType');

    if (token != null && name != null && email != null && userType != null) {
      try {
        final user = User(
          name: name,
          email: email,
          role: roleFromString(userType),
        );
        emit(AuthAuthenticated(user: user, token: token));
      } catch (e) {
        emit(AuthUnauthenticated()); // falha na conversão
      }
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await apiService.login(event.user);
      if (response != null && response.statusCode == 200) {
        final data = response.data;
        final token = data['access_token'];

        if (token == null) {
          emit(AuthError('Token ausente na resposta da API.'));
          return;
        }
        // Agora buscamos o usuário autenticado com esse token
        final user = await apiService.getMe(token);

        if (user == null) {
          emit(AuthError('Não foi possível carregar os dados do usuário.'));
          return;
        }

        // Salva no storage
        await secureStorage.write(key: 'jwt', value: token);
        await secureStorage.write(key: 'name', value: user.name);
        await secureStorage.write(key: 'email', value: user.email);
        await secureStorage.write(
            key: 'userType', value: roleToString(user.role));

        emit(AuthAuthenticated(
          user: user,
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
