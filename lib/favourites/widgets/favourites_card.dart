import 'package:ecomly/common/widgets/optimized_image.dart';
import 'package:ecomly/models/favourites_model.dart';
import 'package:ecomly/providers/favourites_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavouritesCard extends ConsumerWidget {
  final FavouritesModel favouritesModel;
  const FavouritesCard({super.key, required this.favouritesModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favouritesData = ref.read(favouritesProvider.notifier);
    return Container(
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: GestureDetector(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: ProductImage(
                  imageUrl: favouritesModel.images[0],
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    favouritesModel.productName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 15),
                  ),
                  IconButton(
                    onPressed: () {
                      favouritesData.removeFavouritesProduct(
                        favouritesModel.productId,
                      );
                    },
                    icon: Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
