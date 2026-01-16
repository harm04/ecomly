import 'package:ecomly/models/orders_model.dart';
import 'package:ecomly/orders/controller/orders_controller.dart';
import 'package:flutter/material.dart';

class AdminOrdersScreen extends StatefulWidget {
  static const String routeName = '/orders';
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  late Future<List<OrdersModel>> futureOrders;
  @override
  void initState() {
    super.initState();
    futureOrders = OrdersController().fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Orders')),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: futureOrders,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                List<OrdersModel> orders = snapshot.data!;
                return DataTable(
                  border: TableBorder.all(color: Colors.black),
                  headingRowColor: MaterialStateProperty.all(Colors.grey[300]),
                  columns: const [
                    DataColumn(
                      label: Text(
                        'Sr. No.',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),

                    DataColumn(
                      label: Text(
                        'Image',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Order ID',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Product Name',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Vendor Id',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Buyer Id',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Buyer Email',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Quantity',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Product Price',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),

                    DataColumn(
                      label: Text(
                        'Buyer Phone',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Status',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Delete',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  rows: orders.map((order) {
                    return DataRow(
                      cells: [
                        DataCell(Text((orders.indexOf(order) + 1).toString())),
                        DataCell(
                          SizedBox(
                            height: 50,
                            width: 50,
                            child: Image.network(order.image),
                          ),
                        ),
                        DataCell(Text(order.id)),
                        DataCell(Text(order.productName)),
                        DataCell(Text(order.vendorId)),
                        DataCell(Text(order.buyerId)),
                        DataCell(Text(order.buyerEmail)),
                        DataCell(Text(order.quantity.toString())),
                        DataCell(Text(order.productPrice.toString())),

                        DataCell(Text(order.buyerPhone)),
                        DataCell(
                          Text(
                            order.processing
                                ? 'Processing'
                                : order.delivered
                                ? 'Delivered'
                                : order.cancelled
                                ? 'Cancelled'
                                : 'Pending',
                          ),
                        ),
                        DataCell(
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              // Implement delete functionality here
                            },
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                );
              } else {
                return Center(child: Text('No buyers found'));
              }
            },
          ),
        ),
      ),
    );
  }
}
