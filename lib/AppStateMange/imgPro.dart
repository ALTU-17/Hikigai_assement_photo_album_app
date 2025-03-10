import 'package:flutter/material.dart';

import '../ApiUtilsnConfig/ApiService.dart';
import '../Models/ImageMod.dart';


class ImageProvider1 with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<ImageModel> _images = [];
  bool _isLoading = false;
  String _error = '';

  List<ImageModel> get images => _images;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchImages(int page, int limit) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newImages = await _apiService.fetchImages(page, limit);
      _images.addAll(newImages);
      _error = '';
    } catch (e) {
      _error = 'Failed to load images: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<ImageModel> searchImages(String query) {
    return _images.where((image) => image.title.toLowerCase().contains(query.toLowerCase())).toList();
  }
}