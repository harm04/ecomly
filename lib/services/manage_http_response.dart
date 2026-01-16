import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void manageHttpResonse({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 400:
      showsnackbar(context, jsonDecode(response.body)['message']);
      break;
    case 500:
      showsnackbar(context, jsonDecode(response.body)['error']);
      break;
    case 201:
      onSuccess();
      break;
  }
}

void showsnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), duration: Duration(seconds: 2)),
  );
}
