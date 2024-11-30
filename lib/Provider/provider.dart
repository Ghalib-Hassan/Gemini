import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gemini/Model/model.dart';
import 'package:http/http.dart' as http;

class GeminiProvider extends ChangeNotifier {
  List<String> message = [];
  GeminiModel geminiModel = GeminiModel();
  dynamic geminiResponse(String prompt) async {
    message.add(prompt);
    String url =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=AIzaSyB-mhJOrXRKF1Sf26JTDRyko3EKsgZwT2c";

    dynamic headers = {"Content-Type": "application/json"};

    dynamic body = {
      "contents": [
        {
          "parts": [
            {"text": prompt}
          ]
        }
      ]
    };

    await http
        .post(Uri.parse(url), headers: headers, body: jsonEncode(body))
        .then((response) {
      dynamic maxdata = jsonDecode(response.body);
      geminiModel = GeminiModel.fromJson(maxdata);
      notifyListeners();
      message.add(geminiModel.candidates![0].content!.parts![0].text!);
    });
  }
}
