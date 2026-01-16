import 'package:ecomly/common_controllers/category_controller.dart';
import 'package:ecomly/categories/views/category_screen.dart';
import 'package:ecomly/categories/widgets/category_card.dart';
import 'package:ecomly/providers/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ViewAllCategories extends ConsumerStatefulWidget {
  const ViewAllCategories({super.key});

  @override
  ConsumerState<ViewAllCategories> createState() => _ViewAllCategoriesState();
}

class _ViewAllCategoriesState extends ConsumerState<ViewAllCategories> {

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
    final categories = ref.watch(categoryProvider);
    return Scaffold(
      appBar: AppBar(title: Text('All Categories')),
      body: categories.isEmpty || categories.length == 0
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: EdgeInsets.all(18),
              itemCount: categories.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2 / 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                final category = categories[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return CategoryScreen(category: category);
                        },
                      ),
                    );
                  },
                  child: CategoryCard(category: category),
                );
              },
            ),
    );
  }
}
