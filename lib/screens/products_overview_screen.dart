import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:myshop/models/cart.dart';
import 'package:myshop/models/products_provider.dart';
import 'package:myshop/screens/cart_screen.dart';
import 'package:myshop/widgets/app_drawer.dart';
import 'package:myshop/widgets/badge.dart';
import 'package:myshop/widgets/products_grid.dart';
import 'package:provider/provider.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  // var _isInit = true;


  // init will only run ones before building the screen
  @override
  void initState() {
    
    // approch 1 : to make it listen false
    Provider.of<Products>(context, listen: false).fetchAndSetProducts();
   

   // approch 2 : to use delay
    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context).fetchAndSetProducts();
    // });

    super.initState();
  }


 // approch 3 : to use didChangeDependcies
  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {
  //      Provider.of<Products>(context).fetchAndSetProducts();
  // }
  //   _isInit = false;
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (ctx, cart, ch) => Badge(
              child: ch as Widget,
              value: cart.itemCount.toString(),
              color: Theme.of(context).accentColor,
            ),
            // this child is static it will not change and it is pass as a ch into builder
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: Icon(
                Icons.shopping_cart,
              ),
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}
