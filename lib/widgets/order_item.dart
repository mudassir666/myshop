import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myshop/models/orders.dart' as ord;

//simpaly change the class name as OrderItemWidget
class OrderItem extends StatelessWidget {
  //when u change the class name you dont need to use ord.
  final ord.OrderItem order;

  OrderItem({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${order.amount}'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(order.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(Icons.expand_more),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}
