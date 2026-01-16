import 'package:ecomly/vendor/controllers/vendor_controller.dart';
import 'package:ecomly/vendor/models/vendor_model.dart';
import 'package:flutter/material.dart';

class AdminVendorsScreen extends StatefulWidget {
  static const String routeName = '/vendors';
  const AdminVendorsScreen({super.key});

  @override
  State<AdminVendorsScreen> createState() => _AdminVendorsScreenState();
}

class _AdminVendorsScreenState extends State<AdminVendorsScreen> {
  late Future<List<VendorModel>> futureVendors;
  @override
  void initState() {
    super.initState();
    futureVendors = VendorController().fetchVendor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Vendors')),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: futureVendors,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                List<VendorModel> vendors = snapshot.data!;
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
                        'Vendor Id',
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
                        'Shop Name',
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
                  rows: vendors.map((vendor) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Text((vendors.indexOf(vendor) + 1).toString()),
                        ),
                        DataCell(
                          CircleAvatar(child: Text(vendor.vendorFullName[0])),
                        ),
                        DataCell(Text(vendor.id)),
                        DataCell(Text(vendor.vendorFullName)),
                        DataCell(Text(vendor.vendorEmail)),
                        DataCell(Text(vendor.shopName)),
                        DataCell(Text(vendor.city)),
                        DataCell(Text(vendor.state)),
                        DataCell(Text(vendor.phone)),
                        DataCell(Text(vendor.locality)),
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
