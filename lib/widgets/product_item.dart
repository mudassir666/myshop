import 'package:flutter/material.dart';
import 'package:myshop/models/product.dart';
import 'package:myshop/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Listen is false because we dont want to rebuild the whole tree , Consumer will be rebuild
    final product = Provider.of<Product>(context, listen: false);
    print('product');
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          //Consumer is used to rebuild only this part or we could break it into different widget into a class
          leading: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
              onPressed: () {
                product.toggleFavoriteStatus();
              },
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              color: Theme.of(context).accentColor,
            ),
          ),
          backgroundColor: Colors.black87,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            onPressed: () {},
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
