import 'package:a1_kirim_mobile/src/data/data_sources/api_service.dart';
import 'package:a1_kirim_mobile/src/domain/models/market.dart';
import 'package:flutter/material.dart';

class MarketRepository{
  final ApiService apiService;
  MarketRepository(this.apiService);

  Future<List<Market>> getMarkets()async{
    try{
      print("in market repository we are fetching markets...");
      final mar = await apiService.fetchMarkets();
      print("in market repository we fetched markets result: ${mar.toString()}");
      return mar;
    }catch(e){
      print("in market repository failed to load markets exception: ${e.toString()}");
      return [];
    }
  }

  Future<Market> addMarket(Market market)async{
    try{
      print("in market repository we are adding market...");
      final mar = await apiService.addMarket(market);
      print("in market repository added market ___ result: ${mar.toString()}");
      return mar;
    }catch(e){
      print("in market repository failed to add market ___ exception: ${e.toString()}");
      throw "${e.toString()}";
    }
  }
}