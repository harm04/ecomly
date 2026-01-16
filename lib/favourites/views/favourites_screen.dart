import 'package:ecomly/common/constants.dart';
import 'package:ecomly/favourites/widgets/favourites_card.dart';
import 'package:ecomly/providers/favourites_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavouritesScreen extends ConsumerStatefulWidget {
  const FavouritesScreen({super.key});

  @override
  ConsumerState<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends ConsumerState<FavouritesScreen> {
  @override
  Widget build(BuildContext context) {
    final favouritesData = ref.watch(favouritesProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Favourites')),
      body: favouritesData.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 100.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(Constants.empty_cart),
                    SizedBox(height: 20),
                    Text(
                      'Your Favourites is Empty',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              itemCount: favouritesData.length,
              itemBuilder: (context, index) {
                final favouriteItem = favouritesData.values.toList()[index];
                print(favouriteItem.productName);
                return FavouritesCard(favouritesModel: favouriteItem);
              },
            ),
    );
  }
}
