import 'package:flutter/material.dart';
import 'package:myshop/models/products_provider.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
//  const ProductDetailScreen({ Key? key }) : super(key: key);
  // final String title;
  // final double price;
  // ProductDetailScreen(this.title,this.price);
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    ////////////////////////////////logic by me////////////////////////////////////
    // final product_provider = Provider.of<Products>(context);
    // final product = product_provider.items.firstWhere((product) => product.id == productId);
    //////////////////////////////////his first logic/////////////////////////
    //  final loadedProduct = Provider.of<Products>(context)
    //       .items
    //       .firstWhere((prod) => prod.id == productId);
    ///////////////////////////////////his second logic///////////////////////
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                loadedProduct.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '\$${loadedProduct.price}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                loadedProduct.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
