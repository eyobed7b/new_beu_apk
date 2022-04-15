import 'package:efood_multivendor/data/api/api_client.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class RestaurantRepo {
  final ApiClient apiClient;
  RestaurantRepo({@required this.apiClient});

  Future<Response> getRestaurantList(String offset, String filterBy,
      String sort, String priceRange, double locLat, double locLong) async {
    if (sort != null) {
      String uriToCall =
          '${AppConstants.RESTAURANT_URI}/$filterBy?offset=$offset&limit=10&sort=$sort&price_range=$priceRange';
      if (kDebugMode) {
        print(uriToCall);
      }
      return await apiClient.getData(
          '${AppConstants.RESTAURANT_URI}/$filterBy?offset=$offset&limit=10&sort=$sort&price_range=$priceRange&lat=$locLat&lon=$locLong');
    } else {
      return await apiClient.getData(
          '${AppConstants.RESTAURANT_URI}/$filterBy?offset=$offset&limit=10&lat=$locLat&lon=$locLong');
    }
  }

  Future<Response> getPopularRestaurantList(String type) async {
    return await apiClient
        .getData('${AppConstants.POPULAR_RESTAURANT_URI}?type=$type');
  }

  Future<Response> getLatestRestaurantList(String type) async {
    return await apiClient
        .getData('${AppConstants.LATEST_RESTAURANT_URI}?type=$type');
  }

  Future<Response> getRestaurantDetails(String restaurantID) async {
    return await apiClient
        .getData('${AppConstants.RESTAURANT_DETAILS_URI}$restaurantID');
  }

  Future<Response> getRestaurantProductList(
      int restaurantID, int offset, int categoryID, String type) async {
    String testing =
        "${AppConstants.RESTAURANT_PRODUCT_URI}?restaurant_id=$restaurantID&category_id=$categoryID&offset=$offset&limit=10&type=$type";
    if (kDebugMode) {
      print("APICALLURL = $testing");
    }
    return await apiClient.getData(
      '${AppConstants.RESTAURANT_PRODUCT_URI}?restaurant_id=$restaurantID&category_id=$categoryID&offset=$offset&limit=10&type=$type',
    );
  }

  Future<Response> getRestaurantReviewList(String restaurantID) async {
    return await apiClient.getData(
        '${AppConstants.RESTAURANT_REVIEW_URI}?restaurant_id=$restaurantID');
  }
}
