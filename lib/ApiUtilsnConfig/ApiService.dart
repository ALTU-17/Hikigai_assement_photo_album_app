import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Models/ImageMod.dart';



class ApiService {
  static const String _baseUrl = 'https://picsum.photos/v2/list';

  Future<List<ImageModel>> fetchImages(int page, int limit) async {
    final response = await http.get(Uri.parse('$_baseUrl?page=$page&limit=$limit'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => ImageModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load images');
    }
  }
}