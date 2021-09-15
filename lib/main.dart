import 'package:flutter/material.dart';
import 'package:myshop/models/cart.dart';
import 'package:myshop/screens/cart_screen.dart';
import 'package:myshop/screens/product_detail_screen.dart';
import 'package:myshop/screens/products_overview_screen.dart';
import 'package:provider/provider.dart';

import 'models/products_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName : (ctx) => CartScreen(),
        },
      ),
    );
  }
}
