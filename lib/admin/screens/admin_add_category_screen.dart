import 'package:dotted_border/dotted_border.dart';
import 'package:ecomly/common_controllers/category_controller.dart';
import 'package:ecomly/models/category_model.dart';
import 'package:ecomly/common/constants.dart';
import 'package:ecomly/common/pallete.dart';
import 'package:ecomly/common/pick_image.dart';
import 'package:ecomly/services/manage_http_response.dart';
import 'package:flutter/material.dart';

class AdminAddCategoryScreen extends StatefulWidget {
  static const String routeName = '/category';
  const AdminAddCategoryScreen({super.key});

  @override
  State<AdminAddCategoryScreen> createState() => _AdminAddCategoryScreenState();
}

class _AdminAddCategoryScreenState extends State<AdminAddCategoryScreen> {
  bool isLoading = false;
  dynamic categoryImage;
  dynamic bannerImage;
  TextEditingController categoryController = TextEditingController();
  late CategoryController _categoryController = CategoryController();
  late Future<List<CategoryModel>> categories;

  void selectCategoryImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        categoryImage = res.files.first.bytes;
      });
    }
  }

  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        bannerImage = res.files.first.bytes;
      });
    }
  }

  void uploadCategoryImages() async {
    setState(() {
      isLoading = true;
    });
    await _categoryController.uploadCategoryImage(
      categoryImage: categoryImage,
      bannerImage: bannerImage,
      categoryName: categoryController.text,
      context: context,
    );
    setState(() {
      isLoading = false;
      categoryImage = null;
      bannerImage = null;
      categoryController.clear();
      categories = _categoryController.fetchCategories();
    });
  }

  @override
  void initState() {
    super.initState();
    categories = _categoryController.fetchCategories();
  }

  @override
  void dispose() {
    super.dispose();
    categoryController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(18.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        //category image uplaod
                        GestureDetector(
                          onTap: selectCategoryImage,
                          child: DottedBorder(
                            options: RoundedRectDottedBorderOptions(
                              radius: const Radius.circular(10),
                              color: Pallete.greyColor,
                              strokeCap: StrokeCap.round,
                              dashPattern: const [10, 4],
                            ),
                            child: Container(
                              height: 170,
                              width: 170,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: categoryImage != null
                                  ? Image.memory(
                                      categoryImage!,
                                      fit: BoxFit.cover,
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          Constants.photo,
                                          height: 30,
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          'Upload Image',
                                          style: TextStyle(
                                            color: Pallete.greyColor,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        //banner image upload
                        GestureDetector(
                          onTap: selectBannerImage,
                          child: DottedBorder(
                            options: RoundedRectDottedBorderOptions(
                              radius: const Radius.circular(10),
                              color: Pallete.greyColor,
                              strokeCap: StrokeCap.round,
                              dashPattern: const [10, 4],
                            ),
                            child: Container(
                              height: 170,
                              width: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: bannerImage != null
                                  ? Image.memory(
                                      bannerImage!,
                                      fit: BoxFit.cover,
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          Constants.photo,
                                          height: 30,
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          'Upload Banner Image',
                                          style: TextStyle(
                                            color: Pallete.greyColor,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: 170,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              TextField(
                                controller: categoryController,
                                decoration: InputDecoration(
                                  labelText: 'Category Name',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Upload a clear, high-quality image representing the category.\nEnter a concise category name that clearly describes the product types included.',
                                style: TextStyle(color: Pallete.greyColor),
                              ),
                              SizedBox(height: 8),
                              GestureDetector(
                                onTap: () {
                                  if (categoryImage != null &&
                                      categoryController.text.isNotEmpty &&
                                      bannerImage != null) {
                                    uploadCategoryImages();
                                  } else {
                                    showsnackbar(
                                      context,
                                      'Please provide all required fields.',
                                    );
                                  }
                                },
                                child: Container(
                                  height: 45,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(142, 108, 239, 1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Add Category',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Divider(),
                    SizedBox(height: 20),
                    // Banners section
                    FutureBuilder<List<CategoryModel>>(
                      future: categories,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(50.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(50.0),
                              child: Text(
                                'Error: ${snapshot.error}',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(50.0),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.image_outlined,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'No Categories Found',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          // Calculate height for GridView - updated for square cards
                          int itemCount = snapshot.data!.length;
                          int crossAxisCount = 6;
                          int rowCount = (itemCount / crossAxisCount).ceil();
                          double itemHeight =
                              (MediaQuery.of(context).size.width - 56) /
                              crossAxisCount; // Square aspect ratio
                          double gridHeight =
                              (rowCount * itemHeight) +
                              ((rowCount - 1) * 10); // Add spacing

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Uploaded Categories (${snapshot.data!.length})',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                height: gridHeight,
                                child: GridView.builder(
                                  physics:
                                      NeverScrollableScrollPhysics(), // Disable grid scrolling
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: crossAxisCount,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10,
                                        childAspectRatio:
                                            1.0, // Changed from 16/9 to 1.0 for square cards
                                      ),
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    final category = snapshot.data![index];
                                    return Card(
                                      elevation: 4,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Stack(
                                          children: [
                                            Image.network(
                                              category.image,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: double.infinity,
                                              loadingBuilder:
                                                  (
                                                    context,
                                                    child,
                                                    loadingProgress,
                                                  ) {
                                                    if (loadingProgress == null)
                                                      return child;
                                                    return Container(
                                                      color: Colors.grey[200],
                                                      child: Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                              strokeWidth: 2,
                                                            ),
                                                      ),
                                                    );
                                                  },
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    return Container(
                                                      color: Colors.grey[300],
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons.error,
                                                            color: Colors.red,
                                                          ),
                                                          Text(
                                                            'Load failed',
                                                            style: TextStyle(
                                                              fontSize: 10,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                            ),
                                            // Category name overlay at bottom
                                            Positioned(
                                              bottom: 0,
                                              left: 0,
                                              right: 0,
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 4,
                                                  vertical: 18,
                                                ),
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin:
                                                        Alignment.bottomCenter,
                                                    end: Alignment.topCenter,
                                                    colors: [
                                                      Colors.black.withOpacity(
                                                        0.9,
                                                      ),
                                                      Colors.transparent,
                                                    ],
                                                  ),
                                                ),
                                                child: Text(
                                                  category.name,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            // Delete button
                                            Positioned(
                                              top: 5,
                                              right: 5,
                                              child: GestureDetector(
                                                onTap: () {},
                                                child: Container(
                                                  padding: EdgeInsets.all(4),
                                                  decoration: BoxDecoration(
                                                    color: Colors.red
                                                        .withOpacity(0.8),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                    size: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
