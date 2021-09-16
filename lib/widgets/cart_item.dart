import 'package:flutter/material.dart';
import 'package:myshop/models/cart.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  //const CartItem({ Key? key }) : super(key: key);
  final String id;
  final double price;
  final int quantity;
  final String title;
  final String productId;

  CartItem({
    required this.id,
    required this.price,
    required this.quantity,
    required this.title,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      onDismissed: (direction) {
        // here we just need a data thats why the listen is false
        Provider.of<Cart>(context,listen: false).removeItem(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
                child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: FittedBox(
                child: Text('\$$price'),
              ),
            )),
            title: Text(title),
            subtitle: Text('Total: \$${(price * quantity)}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
