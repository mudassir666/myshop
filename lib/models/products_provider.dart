import 'package:flutter/material.dart';
import 'package:myshop/models/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  // we used getter so we could access private items
  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    // it will return the list which product item isFavorite is true
    return _items.where((prodItem) => prodItem.isFavorite == true).toList();
  }

  Product findById(var id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  void addProduct(Product product) {
    // the product we are getting from argument , it will be pass into new product then it will be added
    final newProduct = Product(
      id: DateTime.now().toString(),
      title: product.title,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
    );

    _items.add(newProduct);
    // _items.insert(0, newProduct); // at the start of the list

    //it will notify all the listner that some update has been made therefor listner widget will rebuild
    notifyListeners();
  }

  void updateProduct(String id, Product newProduct) {
    // it will give the index of the product we are going to update
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    //to check if we have  the index or not
    if (prodIndex >= 0) {
      // replace the chosen product from index to newProduct
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('no index');
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((prop) => prop.id == id);
    notifyListeners();
  }
}
