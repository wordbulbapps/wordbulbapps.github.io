import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Service extends ChangeNotifier {
  var ticker = '';
  var fhToken = '';
  var tickerConfirmed = false;
  var tokenConfirmed = false;

  double currentPrice = 0;
  var interval = 15;
  var priceDifference = 5;
  var upText = 'Your stock is up to @';
  var downText = 'Your stock is down to @';

  Future<bool> setTicker(var t) async {
    try {
      Response response = await Dio().get("https://finnhub.io/api/v1/quote?symbol=$t&token=$fhToken");
      print(response);
      ticker = t;
      tickerConfirmed = true;
      notifyListeners();
      return true;
    } catch (e) {
      print(e);

      return false;
    }
  }

  Future<bool> setFHToken(var t) async {
    try {
      Response response = await Dio().get("https://finnhub.io/api/v1/quote?symbol=GME&token=$t");
      print(response);
      fhToken = t;
      tokenConfirmed = true;
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  double registeredPrice = 0;
  var tts = FlutterTts();

  Future<void> engineRev() async {
    try {
      Response response = await Dio().get("https://finnhub.io/api/v1/quote?symbol=${ticker.toUpperCase()}&token=$fhToken");
      print(response);
      if (registeredPrice < response.data['c'] - priceDifference) {
        registeredPrice = response.data['c'];
        currentPrice = registeredPrice;
        upText = upText.replaceAll('@', response.data['c'].toString().split('.')[0]);
        tts.speak(upText);
      }
      if (registeredPrice > response.data['c'] + priceDifference) {
        registeredPrice = response.data['c'];
        currentPrice = registeredPrice;
        downText = downText.replaceAll('@', response.data['c'].toString().split('.')[0]);
        tts.speak(downText);
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
