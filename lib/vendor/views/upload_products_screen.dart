import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:ecomly/common/constants.dart';
import 'package:ecomly/common/pallete.dart';
import 'package:ecomly/common/widgets/button.dart';
import 'package:ecomly/common_controllers/category_controller.dart';
import 'package:ecomly/products/controllers/product_controller.dart';
import 'package:ecomly/models/category_model.dart';
import 'package:ecomly/providers/vendor_provider.dart';
import 'package:ecomly/services/manage_http_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class UploadProductScreen extends ConsumerStatefulWidget {
  const UploadProductScreen({super.key});

  @override
  ConsumerState<UploadProductScreen> createState() =>
      _UploadProductScreenState();
}

class _UploadProductScreenState extends ConsumerState<UploadProductScreen> {
  ImagePicker picker = ImagePicker();
  List<File> images = [];
  PageController pageController = PageController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Future<List<CategoryModel>> futureCategories;
  CategoryModel? selectedCategory;
  ProductController productController = ProductController();
  bool isLoading = false;

  @override
  initState() {
    super.initState();
    futureCategories = CategoryController().fetchCategories();
  }

  late String productName;
  late String productDescription;
  late double productPrice;
  late int productQuantity;

  //function to pick multiple images
  chooseImage() async {
    final pickedFiles = await picker.pickMultiImage();

    // ignore: unnecessary_null_comparison
    if (pickedFiles == null || pickedFiles.isEmpty) return;
    if (pickedFiles.length + images.length > 5) {
      showsnackbar(context, 'Max 5 images are allowed');
      return;
    }

    setState(() {
      images.addAll(pickedFiles.map((file) => File(file.path)));
    });
  }

  //upload product function
  uploadProduct({
    required String vendorId,
    required String vendorFullName,
    required context,
    required String category,
    required List<File> images,
    required String productName,
    required String productDescription,
    required double productPrice,
    required int quantity,
  }) async {
    setState(() {
      isLoading = true;
    });
    await productController.uploadProducts(
      productName: productName,
      productDescription: productDescription,
      productPrice: productPrice,
      quantity: quantity,
      category: category,
      vendorId: vendorId,
      vendorFullName: vendorFullName,
      images: images,
      context: context,
    );
    setState(() {
      images.clear();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final vendor = ref.read(vendorProvider);
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Upload Products',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Divider(thickness: 0.002, color: Pallete.greyColor),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Product Image'),
                                SizedBox(width: 3),
                                Text('*', style: TextStyle(color: Colors.red)),
                              ],
                            ),
                            Text(
                              '${images.length}/5',
                              style: TextStyle(color: Pallete.greyColor),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: chooseImage,
                          child: images.isNotEmpty
                              ? Column(
                                  children: [
                                    SizedBox(
                                      height: 140,

                                      child: ListView.builder(
                                        controller: pageController,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            width: 140,
                                            height: 140,
                                            margin: EdgeInsets.symmetric(
                                              horizontal: 5,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.file(
                                                images[index],
                                                width: 140,
                                                height: 140,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          );
                                        },
                                        itemCount: images.length,
                                      ),
                                    ),
                                  ],
                                )
                              : DottedBorder(
                                  options: RoundedRectDottedBorderOptions(
                                    radius: const Radius.circular(10),
                                    color: Pallete.greyColor,
                                    strokeCap: StrokeCap.round,
                                    dashPattern: const [10, 4],
                                  ),
                                  child: Container(
                                    height: 140,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          Constants.photo,
                                          height: 30,
                                        ),
                                        SizedBox(height: 5),
                                        Text('Upload Product Images (max 5)'),
                                        Text(
                                          'Supported files: JPG, PNG, JPEG',
                                          style: TextStyle(
                                            color: Pallete.greyColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                        //product name
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Product Name'),
                            SizedBox(width: 3),
                            Text('*', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          onChanged: (value) {
                            productName = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter product name';
                            }
                            return null;
                          },
                          maxLength: 100,
                          decoration: InputDecoration(
                            hintText: 'Enter product name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),

                        //product description
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Product Description'),
                            SizedBox(width: 3),
                            Text('*', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          onChanged: (value) {
                            productDescription = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter product description';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          maxLength: 500,
                          decoration: InputDecoration(
                            hintText: 'Enter product description',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Category'),
                            SizedBox(width: 3),
                            Text('*', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                        SizedBox(height: 10),

                        //category dropdown
                        FutureBuilder(
                          future: futureCategories,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text('Error fetching categories'),
                              );
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Center(
                                child: Text('No categories available'),
                              );
                            } else {
                              return DropdownButtonFormField<CategoryModel>(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                hint: Text('Select Category'),
                                items: snapshot.data!
                                    .map(
                                      (category) =>
                                          DropdownMenuItem<CategoryModel>(
                                            value: category,
                                            child: Text(category.name),
                                          ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedCategory = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select a category';
                                  }
                                  return null;
                                },
                              );
                            }
                          },
                        ),
                        SizedBox(height: 20),

                        //product price
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Product Price'),
                            SizedBox(width: 3),
                            Text('*', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          onChanged: (value) {
                            productPrice = double.parse(value);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter product price';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Enter product price',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        //product quantity
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Product Quantity'),
                            SizedBox(width: 3),
                            Text('*', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          onChanged: (value) {
                            productQuantity = int.parse(value);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter product quantity';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Enter product quantity',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        GestureDetector(
                          onTap: () {
                            print(
                              'vendor id: ${vendor!.id}, vendor name: ${vendor.vendorFullName}',
                            );
                            if (_formKey.currentState!.validate() &&
                                images.isNotEmpty &&
                                selectedCategory != null) {
                              uploadProduct(
                                vendorId: vendor.id,
                                vendorFullName: vendor.vendorFullName,
                                context: context,
                                category: selectedCategory!.name,
                                images: images,
                                productName: productName,
                                productDescription: productDescription,
                                productPrice: productPrice,
                                quantity: productQuantity,
                              );
                            } else if (images.isEmpty) {
                              showsnackbar(
                                context,
                                'Please upload at least one image',
                              );
                            }
                          },
                          child: ButtonWidget(text: 'Upload Product'),
                        ),
                        SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
