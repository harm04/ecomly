import 'dart:convert';
import 'package:ecomly/common/global_variables.dart';
import 'package:ecomly/models/user_model.dart';
import 'package:http/http.dart' as http;

class BuyersController {
  Future<List<UserModel>> fetchBuyers() async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/users'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
      print(response.body);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<UserModel> buyers = data
            .map((buyer) => UserModel.fromMap(buyer))
            .toList();
        return buyers;
      } else {
        throw Exception('Failed to load buyers');
      }
    } catch (error) {
      throw Exception('Failed to load buyers: $error');
    }
  }
}
