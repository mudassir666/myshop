import 'package:flutter/material.dart';
import 'package:myshop/models/products_provider.dart';
import 'package:myshop/widgets/product_item.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;
  ProductsGrid(this.showFavs);
  @override
  Widget build(BuildContext context) {
    //this provider rebuild the widget whenever it listen to anychanges and .of<Products> tell which class it is listneing
    final productsData = Provider.of<Products>(context);
    // if the showfavs is true so it will show the favorite list otherwise it will show all items
    final products = showFavs ? productsData.favoriteItems : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        // here we just wants to listen single product
        value: products[index],
        child: ProductItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
