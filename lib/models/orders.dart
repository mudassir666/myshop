import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'cart.dart';

// blue print for Orders
class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    const url =
        'https://flutter-update-c572d-default-rtdb.firebaseio.com/orders.json';

    try {
      final response = await http.get(Uri.parse(url));
      print(json.decode(response.body));
      // if the response has nothing in return so it will terminate right here because running foreach on extractedData cause error
      if (json.decode(response.body) == null) {
        _orders = [];
        return;
      }
      // to store the fetch data
      final List<OrderItem> loadedOrders = [];
      // fetched data is in the form of map
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      // if the response has nothing in return so it will terminate right here because running foreach on extractedData cause error
      // if (extractedData == null) {
      //   return;
      // }

      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(
          OrderItem(
            id: orderId,
            amount: orderData['amount'],
            dateTime: DateTime.parse(orderData['dateTime']),
            // product consist list of cartitems which are map , list of maps
            products: (orderData['products'] as List<dynamic>)
                .map(
                  (item) => CartItem(
                    id: item["id"],
                    title: item['title'],
                    quantity: item['quantity'],
                    price: item['price'],
                  ),
                )
                .toList(),
          ),
        );
      });
      // loadedOrders transfer its orders into the orders and the orders will be reversed
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    }
     catch (error) {
      throw error;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    const url =
        'https://flutter-update-c572d-default-rtdb.firebaseio.com/orders.json';
    // to store the same time in server and locally
    final timestamp = DateTime.now();

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          // want to map each products in to the list
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price,
                  })
              .toList(),
        }),
      );
      // it will add the product at the begging of the list
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartProducts,
          dateTime: timestamp,
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}

// Future<void> fetchAndSetProducts() async {
//   const url =
//       'https://flutter-update-c572d-default-rtdb.firebaseio.com/products.json';

//   // get will get the data from database
//   try {
//     final response = await http.get(Uri.parse(url));
//     // response has a Map which have id and its description
//     final extractedData = json.decode(response.body) as Map<String, dynamic>;
//     // temporay list which will store product and places into items
//     final List<Product> loadedProducts = [];
//     //                       key    value
//     extractedData.forEach((prodId, prodData) {
//       loadedProducts.add(Product(
//         id: prodId,
//         title: prodData['title'],
//         description: prodData['description'],
//         price: prodData['price'],
//         imageUrl: prodData['imageUrl'],
//         isFavorite: prodData['isFavorite'],
//       ));
//     });
//     // moving it into items
//     _items = loadedProducts;
//     // to updated all places
//     notifyListeners();
//     // print(json.decode(response.body));
//   } catch (error) {
//     throw error;
//   }
// }
