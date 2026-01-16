import 'dart:convert';

import 'package:ecomly/models/favourites_model.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

final favouritesProvider =
    StateNotifierProvider<FavouritesNotifier, Map<String, FavouritesModel>>(
      (ref) => FavouritesNotifier(),
    );

class FavouritesNotifier extends StateNotifier<Map<String, FavouritesModel>> {
  FavouritesNotifier() : super({}) {
    _loadFavouritesFromPrefs();
  }

  //load favourites from shared preferences
  Future<void> _loadFavouritesFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final prefsString = prefs.getString('favourites');
    if (prefsString != null) {
      try {
        final dynamic decoded = jsonDecode(prefsString);

        // Check if decoded is a Map
        if (decoded is Map<String, dynamic>) {
          final Map<String, FavouritesModel> favourites = {};

          decoded.forEach((key, value) {
            try {
              // Ensure value is a Map<String, dynamic>
              if (value is Map<String, dynamic>) {
                favourites[key] = FavouritesModel.fromJson(value);
              } else if (value is String) {
                // If value is a string, try to decode it
                final Map<String, dynamic> valueMap = jsonDecode(value);
                favourites[key] = FavouritesModel.fromJson(valueMap);
              }
            } catch (e) {
              // Skip corrupted entries
              print('Error parsing favourite item $key: $e');
            }
          });

          state = favourites;
        } else {
          // Clear corrupted data
          await prefs.remove('favourites');
          state = {};
        }
      } catch (e) {
        // Clear corrupted data and reset state
        print('Error loading favourites: $e');
        await prefs.remove('favourites');
        state = {};
      }
    }
  }

  //add favourites to shared preferences
  Future<void> _saveFavouritesToPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    // Convert FavouritesModel objects to JSON maps before encoding
    final Map<String, dynamic> favouritesJson = state.map(
      (key, value) => MapEntry(key, value.toJson()),
    );
    final favouriteString = jsonEncode(favouritesJson);
    await prefs.setString('favourites', favouriteString);
  }

  //add product to favourites
  void addToFavourites({
    required String productName,
    required String category,
    required double productPrice,
    required List<String> images,
    required String vendorId,

    required String productId,
    required String description,
    required String vendorFullName,
  }) {
    if (state.containsKey(productId)) {
      state = {
        ...state,
        productId: FavouritesModel(
          productName: state[productId]!.productName,
          category: state[productId]!.category,
          productPrice: state[productId]!.productPrice,
          images: state[productId]!.images,
          vendorId: state[productId]!.vendorId,

          productId: state[productId]!.productId,
          description: state[productId]!.description,
          vendorFullName: state[productId]!.vendorFullName,
        ),
      };
      _saveFavouritesToPrefs();
    } else {
      state = {
        ...state,
        productId: FavouritesModel(
          productName: productName,
          category: category,
          productPrice: productPrice,
          images: images,
          vendorId: vendorId,

          productId: productId,
          description: description,
          vendorFullName: vendorFullName,
        ),
      };
      _saveFavouritesToPrefs();
    }
  }

  void removeFavouritesProduct(String productId) {
    if (state.containsKey(productId)) {
      state.remove(productId);
      state = {...state};
      _saveFavouritesToPrefs();
    }
  }

  Map<String, FavouritesModel> get getFavouritesItems => state;
}
