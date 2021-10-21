import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  // to void code duplication
  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus() async {
    // saving the old favorite status
    final oldStatus = isFavorite;
    // if it is true it will return false and if it is false it will return true
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        'https://flutter-update-c572d-default-rtdb.firebaseio.com/products/$id.json';

    try {
      final response = await http.patch(
        Uri.parse(url),
        body: json.encode({
          'isFavorite': isFavorite,
        }),
      );
      // if the response returning statuscode higher than 400 undo it
      if (response.statusCode >= 400) {
        // to undo the action
        _setFavValue(oldStatus);
      }
    } // if error occur undo the action 
    catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
