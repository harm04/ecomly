import 'package:ecomly/common/pallete.dart';
import 'package:ecomly/home/widgets/search_card.dart';
import 'package:ecomly/models/product_model.dart';
import 'package:ecomly/products/controllers/product_controller.dart';
import 'package:ecomly/products/views/product_details_screen.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  final ProductController productController = ProductController();
  List<ProductModel> searchedProducts = [];
  bool isLoading = false;
  void searchProducts() async {
    setState(() {
      isLoading = true;
    });
    try {
      final query = searchController.text.trim();
      if (query.isNotEmpty) {
        final results = await productController.searchProducts(query);
        setState(() {
          searchedProducts = results;
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            fillColor: Pallete.backgroundColor,
            filled: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 12),
            hintText: 'Search for products',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Pallete.greyColor),
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.search, color: Pallete.greyColor),
              onPressed: () {
                searchProducts();
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          if (isLoading)
            CircularProgressIndicator()
          else if (searchedProducts.isEmpty)
            Center(child: Text('No products found'))
          else
            Expanded(
              child: ListView.builder(
                itemCount: searchedProducts.length,
                itemBuilder: (context, index) {
                  final product = searchedProducts[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ProductDetailScreen(productModel: product);
                          },
                        ),
                      );
                    },
                    child: SearchCard(productModel: product),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
