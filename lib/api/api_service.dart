import 'package:dio/dio.dart';
import 'package:front_insumos/models/user.dart';

class ApiService {
  final Dio _dio = Dio();
  final String baseUrl = const String.fromEnvironment('BACKEND_URL');

  Future<User?> getMe(String token) async {
    try {
      final response = await _dio.get(
        "$baseUrl/auth/me",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        return User.fromJson(response.data);
      }

      return null;
    } catch (e) {
      print("Erro ao buscar dados do usuário: $e");
      return null;
    }
  }

  Future<Response?> login(User user) async {
    try {
      final response = await _dio.post(
        "$baseUrl/auth/login",
        options: Options(
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
          },
        ),
        data: {
          'username': user.email,
          'password': user.password,
          'grant_type': 'password',
          'scope': '',
          'client_id': '',
          'client_secret': '',
        },
      );
      return response;
    } catch (e) {
      print("Erro no login: $e");
      return null;
    }
  }

  Future<Response?> register(User user) async {
    try {
      final response = await _dio.post(
        "$baseUrl/auth/register",
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
        data: user.toJson(), // já inclui o password, se existir
      );
      return response;
    } on DioException catch (e) {
      // Se for erro vindo da API (400, 422, etc.), ainda queremos a resposta
      if (e.response != null) {
        return e.response;
      } else {
        print("Erro sem resposta do servidor: $e");
        return null;
      }
    } catch (e) {
      print("Erro no cadastro: $e");
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> fetchMovements() async {
    try {
      final response = await _dio.get("$baseUrl/movement");
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      }
      return [];
    } catch (e) {
      print("Erro ao buscar movimentações: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchStocks() async {
    try {
      final response = await _dio.get("$baseUrl/stock");
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      }
      return [];
    } catch (e) {
      print("Erro ao buscar stock: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchItems() async {
    try {
      final response = await _dio.get("$baseUrl/items");
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      }
      return [];
    } catch (e) {
      print("Erro ao buscar items: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchPOP() async {
    try {
      final response = await _dio.get("$baseUrl/pop");
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      }
      return [];
    } catch (e) {
      print("Erro ao buscar pop: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchRecipes() async {
    try {
      final response = await _dio.get("$baseUrl/recipe");
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      }
      return [];
    } catch (e) {
      print("Erro ao buscar recipes: $e");
      return [];
    }
  }
}
