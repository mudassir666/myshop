import 'package:flutter/material.dart';
// it will only import cart class not cartitem class
import 'package:myshop/models/cart.dart' show Cart;
import 'package:myshop/models/orders.dart';
import 'package:provider/provider.dart';
import 'package:myshop/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color:
                            Theme.of(context).primaryTextTheme.headline6!.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) => CartItem(
                //items are in map so all the map values will be converted into list then we will acess it
                id: cart.items.values.toList()[i].id,
                title: cart.items.values.toList()[i].title,
                quantity: cart.items.values.toList()[i].quantity,
                price: cart.items.values.toList()[i].price,
                // product id is the key which will be passed
                productId: cart.items.keys.toList()[i],
              ),
            ),
          )
        ],
      ),
    );
  }
}

// extract the orderButton to rebuild the less and make it stateful to show loading spinner

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  // to show loading spinner
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      // if the amount smaller then 0 and showing loading spinner button will be disable
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              // it will show the loading spinner while adding the order in database
              setState(() {
                _isLoading = true;
              });
              //converting cart items.object into a list of cart items.object instead of passing whole map
              await Provider.of<Orders>(context, listen: false).addOrder(
                widget.cart.items.values.toList(),
                widget.cart.totalAmount,
              );
              // it will stop showing loading spinner just after the order has been added to database
              setState(() {
                _isLoading = false;
              });
              // after passing items to order we want to clear the cart
              widget.cart.clear();
            },
      child: _isLoading
          ? CircularProgressIndicator()
          : Text(
              'ORDER NOW',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          Theme.of(context).primaryTextTheme.headline6!.color,
        ),
      ),
    );
  }
}
