import 'dart:convert';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:ecomly/models/upload_banner_model.dart';
import 'package:ecomly/common/global_variables.dart';
import 'package:ecomly/services/manage_http_response.dart';
import 'package:ecomly/services/cloudinary_optimizer.dart';
import 'package:http/http.dart' as http;

class BannerController {
  uploadBannerImage({required dynamic bannerImage, required context}) async {
    try {
      // Upload banner image with optimizations
      CloudinaryResponse bannerRes =
          await CloudinaryOptimizer.uploadOptimizedFile(
            file: CloudinaryFile.fromBytesData(
              bannerImage,
              identifier: 'BannerImage',
              folder: 'Banners',
            ),
          );
      String bannerImageUrl = bannerRes.secureUrl;

      BannerModel bannerModel = BannerModel(id: '', image: bannerImageUrl);
      http.Response response = await http.post(
        Uri.parse('$uri/api/banner'),
        body: bannerModel.toJson(),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
      manageHttpResonse(
        response: response,
        context: context,
        onSuccess: () {
          showsnackbar(context, 'Banner added');
        },
      );
    } catch (error) {
      print('Error uploading to Cloudinary: $error');
    }
  }

  Future<List<BannerModel>> fetchBanners() async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/banner'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
      print(response.body);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<BannerModel> banners = data
            .map((banner) => BannerModel.fromJson(banner))
            .toList();
        return banners;
      } else {
        throw Exception('Failed to load banners');
      }
    } catch (error) {
      throw Exception('Failed to load banners: $error');
    }
  }
}
