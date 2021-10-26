import 'package:flutter/material.dart';
import 'package:myshop/models/orders.dart' show Orders;
import 'package:myshop/widgets/app_drawer.dart';
import 'package:myshop/widgets/order_item.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  //const OrdersScreen({ Key? key }) : super(key: key);
  static const routeName = '/orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
 // no new future will be create after doing this and the app will not rebuild again
  late Future _ordersFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('building orders');
    // this will cause infinte loop problem because when data will be fetch it will call notify listner
    // solution is to use consumer
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: _ordersFuture,
          builder: (ctx, dataSnapshot) {
            // checking if the data connection state is waiting or not
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            // if error occur // falure
            else {
              if (dataSnapshot.error != null) {
                // do error handling stuff
                return Center(child: Text('An error occurred'));
              }
              // if everything run perfectly // success
              else {
                // use consumer for listview
                return Consumer<Orders>(
                  builder: (ctx, orderData, child) => ListView.builder(
                    itemCount: orderData.orders.length,
                    itemBuilder: (ctx, i) =>
                        OrderItem(order: orderData.orders[i]),
                  ),
                );
              }
            }
          },
        ));
  }
}
