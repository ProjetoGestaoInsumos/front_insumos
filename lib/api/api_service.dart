import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();
  final String baseUrl = "https://exemplo.onrender.com";

  Future<List<dynamic>> fetchProdutos() async {
    try {
      final response = await _dio.get("$baseUrl/items/");
      return response.data;
    } catch (e) {
      print("Erro ao buscar produtos: $e");
      return [];
    }
  }
}
