import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  //In map the key is the product_id and value is cartItem
  Map<String, CartItem> _items = {};

  // getter
  Map<String, CartItem> get items {
    return {..._items};
  }

  //get _items count
  int get itemCount {
    return _items.length;
  }

  // to get the totalAmount
  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      //view each cartitem and add the amount in total
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(String productId, double price, String title) {
    // will check if the item has the same product id as a key , if true will increase the quantity else add the new item in cart
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingCardItem) => CartItem(
                id: existingCardItem.id,
                title: existingCardItem.title,
                price: existingCardItem.price,
                quantity: existingCardItem.quantity + 1,
              ));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
                id: DateTime.now().toString(),
                title: title,
                price: price,
                quantity: 1,
              ));
    }
    notifyListeners();
  }

  // deleting a product form cart with the help of key
  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  // items will be clear when order now button pressed so all the items move into order list
  void clear() {
    _items = {};
    notifyListeners();
  }
}
