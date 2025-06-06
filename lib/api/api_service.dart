import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();
  final String baseUrl = const String.fromEnvironment('BACKEND_URL');

  Future<List<dynamic>> fetchProdutos() async {
    try {
      final response = await _dio.get("$baseUrl/items/");
      return response.data;
    } catch (e) {
      print("Erro ao buscar produtos: $e");
      return [];
    }
  }

  Future<Response?> login(String email, String password) async {
    try {
      final response = await _dio.post(
        "$baseUrl/auth/login",
        options: Options(
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
          },
        ),
        data: {
          'email': email,
          'password': password,
        },
      );
      return response;
    } catch (e) {
      print("Erro no login: $e");
      return null;
    }
  }

  Future<Response?> register(
      String name, String email, String password, String userType) async {
    try {
      final response = await _dio.post(
        "$baseUrl/auth/register",
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
        data: {
          'name': name,
          'email': email,
          'password': password,
          'user_type': userType,
        },
      );
      return response;
    } catch (e) {
      print("Erro no cadastro: $e");
      return null;
    }
  }
}
