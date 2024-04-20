import 'dart:convert';
import 'dart:core';
import 'package:eshop_multivendor/Helper/ApiBaseHelper.dart';
import 'package:eshop_multivendor/Model/favorite_seller_model.dart';
import '../Helper/Constant.dart';
import '../Helper/String.dart';

class SellerDetailRepository {
  ///This method is used to getseller
  static Future<Map<String, dynamic>> fetchSeller({
    required Map<String, dynamic> parameter,
  }) async {
    try {
      var result = await ApiBaseHelper().postAPICall(getSellerApi, parameter);

      return result;
    } on Exception catch (e) {
      throw ApiException('$errorMesaage${e.toString()}');
    }
  }

  static Future<Map<String, dynamic>> addSellerToFavorite({
    required Map<String, dynamic> parameter,
  }) async {
    try {
      var result =
          await ApiBaseHelper().postAPICall(sellerAddToFavorite, parameter);

      return result;
    } on Exception catch (e) {
      throw ApiException('$errorMesaage${e.toString()}');
    }
  }

  static Future<Map<String, dynamic>> removeSellerToFavorite({
    required Map<String, dynamic> parameter,
  }) async {
    try {
      var result =
          await ApiBaseHelper().postAPICall(sellerRemoveToFavorite, parameter);

      return result;
    } on Exception catch (e) {
      throw ApiException('$errorMesaage${e.toString()}');
    }
  }

  static Future getFollowedSellers({
    required Map<String, dynamic> parameter,
  }) async {
    try {
      var result =
          await ApiBaseHelper().postAPICall(getFavoriteSeller, parameter);
      print(result);
      Favorite response = Favorite.fromJson(result);
      return response;
    } on Exception catch (e) {
      throw ApiException('$errorMesaage${e.toString()}');
    }
  }
}
