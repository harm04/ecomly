import 'package:ecomly/models/upload_banner_model.dart';
import 'package:flutter_riverpod/legacy.dart';

class BannerProvider extends StateNotifier<List<BannerModel>> {
  BannerProvider() : super([]);
  void setBanners(List<BannerModel> banners) {
    state = banners;
  }
}

final bannerProvider = StateNotifierProvider<BannerProvider, List<BannerModel>>(
  (ref) => BannerProvider(),
);
