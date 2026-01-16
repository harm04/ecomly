import 'package:ecomly/cart/views/cart_screen.dart';
import 'package:ecomly/common_controllers/category_controller.dart';
import 'package:ecomly/categories/views/category_screen.dart';
import 'package:ecomly/categories/views/view_all_categories.dart';
import 'package:ecomly/common/constants.dart';
import 'package:ecomly/common/pallete.dart';
import 'package:ecomly/common/widgets/optimized_image.dart';
import 'package:ecomly/home/views/search_screen.dart';
import 'package:ecomly/providers/cart_provider.dart';
import 'package:ecomly/providers/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppBarWidget extends ConsumerStatefulWidget {
  const AppBarWidget({super.key});

  @override
  ConsumerState<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends ConsumerState<AppBarWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchCategories();
    });
  }

  Future<void> fetchCategories() async {
    final CategoryController categoryController = CategoryController();
    try {
      final categories = await categoryController.fetchCategories();
      ref.read(categoryProvider.notifier).setCategories(categories);
    } catch (error) {
      print('Error fetching popular products:$error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartData = ref.watch(cartProvider);
    final categories = ref.watch(categoryProvider);
    return categories.isEmpty || categories.length == 0
        ? Center(child: CircularProgressIndicator())
        : Container(
            height: 210,
            width: double.infinity,
            color: Pallete.primaryColor,
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(width: 18),
                      Expanded(
                        child: TextField(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return SearchScreen();
                                },
                              ),
                            );
                          },
                          decoration: InputDecoration(
                            fillColor: Pallete.backgroundColor,
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            hintText: 'Search for products',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Pallete.greyColor),
                            ),
                            suffixIcon: Icon(
                              Icons.search,
                              color: Pallete.greyColor,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return const CartScreen();
                                },
                              ),
                            );
                          },
                          child: Stack(
                            children: [
                              Image.asset(
                                Constants.cart,
                                height: 30,
                                color: Colors.white,
                              ),
                              Positioned(
                                right: 0,
                                child: CircleAvatar(
                                  radius: 8,
                                  backgroundColor: Colors.red,
                                  child: Text(
                                    cartData.length.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  //display categories in circle
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length > 5
                          ? 6
                          : categories.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 5) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18.0,
                            ),
                            child: Center(
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return ViewAllCategories();
                                      },
                                    ),
                                  );
                                },
                                child: Text(
                                  'View all',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                        final category = categories[index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return CategoryScreen(category: category);
                                  },
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 27,
                                  backgroundColor: Colors.white,
                                  child: ClipOval(
                                    child: ThumbnailImage(
                                      imageUrl: categories[index].image,
                                      size: 54,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  category.name,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
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
              ),
            ),
          );
  }
}
