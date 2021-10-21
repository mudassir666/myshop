import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myshop/models/http_exception.dart';
import 'package:myshop/models/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    //   Product(
    //     id: 'p1',
    //     title: 'Red Shirt',
    //     description: 'A red shirt - it is pretty red!',
    //     price: 29.99,
    //     imageUrl:
    //         'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    //   ),
    //   Product(
    //     id: 'p2',
    //     title: 'Trousers',
    //     description: 'A nice pair of trousers.',
    //     price: 59.99,
    //     imageUrl:
    //         'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    //   ),
    //   Product(
    //     id: 'p3',
    //     title: 'Yellow Scarf',
    //     description: 'Warm and cozy - exactly what you need for the winter.',
    //     price: 19.99,
    //     imageUrl:
    //         'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    //   ),
    //   Product(
    //     id: 'p4',
    //     title: 'A Pan',
    //     description: 'Prepare any meal you want.',
    //     price: 49.99,
    //     imageUrl:
    //         'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    //   ),
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

  Future<void> fetchAndSetProducts() async {
    const url =
        'https://flutter-update-c572d-default-rtdb.firebaseio.com/products.json';

    // get will get the data from database
    try {
      final response = await http.get(Uri.parse(url));
      // response has a Map which have id and its description
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      // temporay list which will store product and places into items
      final List<Product> loadedProducts = [];
      //                       key    value
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavorite: prodData['isFavorite'],
        ));
      });
      // moving it into items
      _items = loadedProducts;
      // to updated all places
      notifyListeners();
      // print(json.decode(response.body));
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    // url consist a url
    const url =
        'https://flutter-update-c572d-default-rtdb.firebaseio.com/products.json';

// try has the code which might fail because of user input and internet connection
    try {
      // await mean it will act like .then for waiting
      final response = await http.post(
        Uri.parse(url),
        // it will post and body is sending a map in json
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'isFavorite': product.isFavorite,
        }),
      );
      // the product we are getting from argument , it will be pass into new product then it will be added
      final newProduct = Product(
        // we decode the response body and get the name which is stored as a map
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );

      _items.add(newProduct);
      // _items.insert(0, newProduct); // at the start of the list

      //it will notify all the listner that some update has been made therefor listner widget will rebuild
      notifyListeners();
    } catch (error) {
      //  it will catch the error if it occurs in await

      print(error);
      // it is going to throw the same error after catching it but for some usefull thing
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    // it will give the index of the product we are going to update
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    //to check if we have  the index or not
    if (prodIndex >= 0) {
      // Url must be dynamic and should concertrate on id
      final url =
          'https://flutter-update-c572d-default-rtdb.firebaseio.com/products/$id.json';
      try {
        //Patch is use to update data
        await http.patch(Uri.parse(url),
            body: json.encode({
              'title': newProduct.title,
              'description': newProduct.description,
              'price': newProduct.price,
              'imageUrl': newProduct.imageUrl,
            }));
        // replace the chosen product from index to newProduct
        _items[prodIndex] = newProduct;
        notifyListeners();
      } catch (error) {
        throw error;
      }
    } else {
      print('no index');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://flutter-update-c572d-default-rtdb.firebaseio.com/products/$id.json';

    // it will store the index of the deleting product
    final existingProductIndex = _items.indexWhere((prop) => prop.id == id);

    // it will store the deleting product in the memory
    var existingProduct = _items[existingProductIndex];

    // deleting the  product from the list not from the memory
    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(Uri.parse(url));

    // when something went wrong
    if (response.statusCode >= 400) {
      print(response.statusCode);
      // if we catch the error the product will be deleted so to undo that we use this approch to add it again
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();

      // throw cancel the function execution
      throw HttpException('Could not delete product.');
    }
    // if nothing goes wrong just clear the memory
    // after the response the product in the stored memory is not needed , it should be null
    existingProduct = null as Product;

    // _items.removeWhere((prop) => prop.id == id);
    // notifyListeners();
  }
}
