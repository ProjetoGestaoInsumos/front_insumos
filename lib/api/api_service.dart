import 'package:dio/dio.dart';
import 'package:front_insumos/models/item.dart';
import 'package:front_insumos/models/stock.dart';
import 'package:front_insumos/models/user.dart';
import 'package:front_insumos/models/pop_response.dart';
import 'package:front_insumos/models/pop_create.dart';

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

  // 🔹 MOVIMENTS -------------------------------

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

  // 🔹 STOCK -------------------------------

  Future<List<Stock>> fetchStocks() async {
    try {
      final response = await _dio.get("$baseUrl/stock");
      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List).map((e) => Stock.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print("Erro ao buscar estoque: $e");
      return [];
    }
  }

  Future<Stock?> createStock(Stock stock) async {
    try {
      final response = await _dio.post(
        "$baseUrl/stock",
        data: stock.toJson(),
      );
      if (response.statusCode == 200) {
        return Stock.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print("Erro ao criar estoque: $e");
      return null;
    }
  }

  Future<Stock?> updateStock(Stock stock) async {
    if (stock.id == null) return null;
    try {
      final response = await _dio.put(
        "$baseUrl/stock/${stock.id}",
        data: stock.toJson(),
      );
      if (response.statusCode == 200) {
        return Stock.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print("Erro ao atualizar estoque: $e");
      return null;
    }
  }

  Future<bool> deleteStock(int id) async {
    try {
      final response = await _dio.delete("$baseUrl/stock/$id");
      return response.statusCode == 200;
    } catch (e) {
      print("Erro ao deletar estoque: $e");
      return false;
    }
  }

  // 🔹 ITEMS -------------------------------

  Future<List<Item>> fetchItems() async {
    try {
      final response = await _dio.get("$baseUrl/items");
      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List).map((e) => Item.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print("Erro ao buscar items: $e");
      return [];
    }
  }

  Future<Item?> createItem(Item item) async {
    try {
      final response = await _dio.post(
        "$baseUrl/items",
        data: item.toJson(),
      );
      if (response.statusCode == 200) {
        return Item.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print("Erro ao criar item: $e");
      return null;
    }
  }

  Future<bool> deleteItem(int id) async {
    try {
      final response = await _dio.delete("$baseUrl/items/$id");
      return response.statusCode == 200;
    } catch (e) {
      print("Erro ao deletar item: $e");
      return false;
    }
  }

  // 🔹 POP -------------------------------

Future<POPResponse> createPop(POPCreate popData) async {
  try {
    final response = await Dio().post(
      '$baseUrl/pop',
      data: popData.toJson(),
    );

    if (response.statusCode == 200) {
      return POPResponse.fromJson(response.data);
    } else {
      throw Exception('Erro ao criar POP: Status ${response.statusCode}');
    }
  } catch (e) {
    print("Erro ao criar POP: $e");
    throw Exception('Erro ao criar POP');
  }
}


Future<List<POPResponse>> fetchPopResponses(String baseUrl) async {
  try {
    final response = await Dio().get('$baseUrl/pop');
    if (response.statusCode == 200) {
      // Mapeia a resposta JSON para uma lista de POPResponse
      return List<POPResponse>.from(
        response.data.map((x) => POPResponse.fromJson(x)),
      );
    }
    return [];
  } catch (e) {
    print("Erro ao buscar POPs: $e");
    return [];
  }
}

Future<void> updatePopStatus(String baseUrl, int popId, String status) async {
  try {
    final response = await Dio().put(
      '$baseUrl/pop/$popId/status',
      data: {'status': status},
    );
    if (response.statusCode == 200) {
      print("Status do POP atualizado com sucesso");
    }
  } catch (e) {
    print("Erro ao atualizar status do POP: $e");
  }
}

  // 🔹 RECIPES -------------------------------

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
