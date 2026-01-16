import 'package:ecomly/common_controllers/buyers_controller.dart';
import 'package:ecomly/models/user_model.dart';
import 'package:flutter/material.dart';

class AdminBuyersScreen extends StatefulWidget {
  static const String routeName = '/buyers';
  const AdminBuyersScreen({super.key});

  @override
  State<AdminBuyersScreen> createState() => _AdminBuyersScreenState();
}

class _AdminBuyersScreenState extends State<AdminBuyersScreen> {
  late Future<List<UserModel>> futureBuyers;
  @override
  void initState() {
    super.initState();
    futureBuyers = BuyersController().fetchBuyers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Buyers')),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: futureBuyers,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                List<UserModel> buyers = snapshot.data!;
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
                        'Profile',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Full Name',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Email',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'City',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'State',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Phone',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Address',
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
                  rows: buyers.map((buyer) {
                    return DataRow(
                      cells: [
                        DataCell(Text((buyers.indexOf(buyer) + 1).toString())),
                        DataCell(CircleAvatar(child: Text(buyer.fullName[0]))),
                        DataCell(Text(buyer.fullName)),
                        DataCell(Text(buyer.email)),
                        DataCell(Text(buyer.city)),
                        DataCell(Text(buyer.state)),
                        DataCell(Text(buyer.phone)),
                        DataCell(Text(buyer.locality)),
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
